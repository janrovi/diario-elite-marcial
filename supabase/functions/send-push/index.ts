import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const VAPID_PUBLIC_KEY  = Deno.env.get("VAPID_PUBLIC_KEY")  || "";
const VAPID_PRIVATE_KEY = Deno.env.get("VAPID_PRIVATE_KEY") || "";
const VAPID_SUBJECT     = "mailto:jan@elitemarcial.com";
const SUPABASE_URL      = Deno.env.get("SUPABASE_URL")!;
const ANON_KEY          = Deno.env.get("ANON_KEY")!;

// ── VAPID signing helpers ───────────────────────────────────────────────────
function b64urlDecode(str: string): Uint8Array {
  const pad = str.length % 4;
  const b64 = str.replace(/-/g, "+").replace(/_/g, "/") + (pad ? "=".repeat(4 - pad) : "");
  return Uint8Array.from(atob(b64), c => c.charCodeAt(0));
}

function b64urlEncode(buf: ArrayBuffer): string {
  return btoa(String.fromCharCode(...new Uint8Array(buf)))
    .replace(/\+/g, "-").replace(/\//g, "_").replace(/=/g, "");
}

async function buildVapidHeaders(audience: string): Promise<Record<string, string>> {
  const now = Math.floor(Date.now() / 1000);
  const header = { typ: "JWT", alg: "ES256" };
  const payload = { aud: audience, exp: now + 12 * 3600, sub: VAPID_SUBJECT };

  const enc = new TextEncoder();
  const headerB64  = b64urlEncode(enc.encode(JSON.stringify(header)));
  const payloadB64 = b64urlEncode(enc.encode(JSON.stringify(payload)));
  const sigInput   = `${headerB64}.${payloadB64}`;

  const privKeyBytes = b64urlDecode(VAPID_PRIVATE_KEY);
  const cryptoKey = await crypto.subtle.importKey(
    "raw", privKeyBytes,
    { name: "ECDSA", namedCurve: "P-256" },
    false, ["sign"]
  );
  const sig = await crypto.subtle.sign(
    { name: "ECDSA", hash: "SHA-256" },
    cryptoKey,
    enc.encode(sigInput)
  );

  const jwt = `${sigInput}.${b64urlEncode(sig)}`;
  return {
    Authorization: `vapid t=${jwt},k=${VAPID_PUBLIC_KEY}`,
    "Content-Type": "application/octet-stream",
    "TTL": "86400",
  };
}

// ── AES-128-GCM encryption for push payload ─────────────────────────────────
async function encryptPayload(
  payload: string,
  p256dh: string,
  auth: string
): Promise<{ ciphertext: Uint8Array; salt: Uint8Array; serverPublicKey: Uint8Array }> {
  const enc = new TextEncoder();

  const recipientPub = await crypto.subtle.importKey(
    "raw", b64urlDecode(p256dh),
    { name: "ECDH", namedCurve: "P-256" },
    false, []
  );

  const serverKeyPair = await crypto.subtle.generateKey(
    { name: "ECDH", namedCurve: "P-256" },
    true, ["deriveKey", "deriveBits"]
  );
  const serverPublicKeyRaw = new Uint8Array(
    await crypto.subtle.exportKey("raw", serverKeyPair.publicKey)
  );

  const sharedBits = await crypto.subtle.deriveBits(
    { name: "ECDH", public: recipientPub },
    serverKeyPair.privateKey, 256
  );

  const authSecret = b64urlDecode(auth);
  const salt = crypto.getRandomValues(new Uint8Array(16));
  const hkdfKey = await crypto.subtle.importKey("raw", sharedBits, "HKDF", false, ["deriveBits"]);

  const prkInfo = enc.encode("Content-Encoding: auth\0");
  const prk = await crypto.subtle.deriveBits(
    { name: "HKDF", hash: "SHA-256", salt: authSecret, info: prkInfo },
    hkdfKey, 256
  );

  const cekInfo = new Uint8Array([
    ...enc.encode("Content-Encoding: aesgcm\0"),
    ...new Uint8Array(1),
    ...new Uint8Array([65]),
    ...serverPublicKeyRaw,
    ...new Uint8Array([65]),
    ...b64urlDecode(p256dh),
  ]);
  const nonceInfo = new Uint8Array([
    ...enc.encode("Content-Encoding: nonce\0"),
    ...new Uint8Array(1),
    ...new Uint8Array([65]),
    ...serverPublicKeyRaw,
    ...new Uint8Array([65]),
    ...b64urlDecode(p256dh),
  ]);

  const prkKey = await crypto.subtle.importKey("raw", prk, "HKDF", false, ["deriveBits"]);
  const cekBits = await crypto.subtle.deriveBits(
    { name: "HKDF", hash: "SHA-256", salt, info: cekInfo },
    prkKey, 128
  );
  const nonceBits = await crypto.subtle.deriveBits(
    { name: "HKDF", hash: "SHA-256", salt, info: nonceInfo },
    prkKey, 96
  );

  const cek   = await crypto.subtle.importKey("raw", cekBits, "AES-GCM", false, ["encrypt"]);
  const nonce = new Uint8Array(nonceBits);

  const plaintext = enc.encode(payload);
  const padded = new Uint8Array(2 + plaintext.length);
  padded.set(plaintext, 2);

  const ciphertext = new Uint8Array(await crypto.subtle.encrypt(
    { name: "AES-GCM", iv: nonce },
    cek, padded
  ));

  return { ciphertext, salt, serverPublicKey: serverPublicKeyRaw };
}

// ── Main handler ─────────────────────────────────────────────────────────────
serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });

  // ── FIX #1: Verificar JWT — solo usuarios autenticados pueden enviar push ──
  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return new Response("Unauthorized", { status: 401, headers: corsHeaders });
  }
  const token = authHeader.slice(7);
  const anonClient = createClient(SUPABASE_URL, ANON_KEY);
  const { data: { user }, error: authErr } = await anonClient.auth.getUser(token);
  if (authErr || !user) {
    return new Response("Invalid token", { status: 401, headers: corsHeaders });
  }

  try {
    const { user_id, title, body, url = "/", tag, icon } = await req.json();
    if (!user_id) return new Response(JSON.stringify({ error: "user_id required" }), { status: 400, headers: corsHeaders });

    // ── FIX #1b: Solo puedes enviar push al propio usuario o a tus atletas ──
    const supabase = createClient(SUPABASE_URL, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);

    if (user_id !== user.id) {
      // Verificar relación coach→atleta activa
      const { data: rel } = await supabase
        .from("coach_atleta")
        .select("id")
        .eq("coach_id", user.id)
        .eq("atleta_id", user_id)
        .eq("estado", "aceptado")
        .single();

      if (!rel) {
        return new Response("Forbidden", { status: 403, headers: corsHeaders });
      }
    }

    // Fetch all subscriptions for this user
    const { data: subs } = await supabase
      .from("push_subscriptions")
      .select("*")
      .eq("user_id", user_id);

    if (!subs || subs.length === 0) {
      return new Response(JSON.stringify({ sent: 0 }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
    }

    const payload = JSON.stringify({ title, body, url, tag, icon });
    const results = await Promise.allSettled(
      subs.map(async (sub) => {
        const endpoint = sub.endpoint;
        const audience  = new URL(endpoint).origin;
        const headers   = await buildVapidHeaders(audience);

        const { ciphertext, salt, serverPublicKey } = await encryptPayload(
          payload, sub.p256dh, sub.auth
        );

        const rs = new Uint8Array([0, 0, 16, 0]);
        const keyIdLen = new Uint8Array([65]);
        const bodyBuf = new Uint8Array(16 + 4 + 1 + 65 + ciphertext.length);
        let offset = 0;
        bodyBuf.set(salt, offset); offset += 16;
        bodyBuf.set(rs, offset);   offset += 4;
        bodyBuf.set(keyIdLen, offset); offset += 1;
        bodyBuf.set(serverPublicKey, offset); offset += 65;
        bodyBuf.set(ciphertext, offset);

        const res = await fetch(endpoint, {
          method: "POST",
          headers: {
            ...headers,
            "Content-Encoding": "aesgcm",
            "Encryption": `salt=${b64urlEncode(salt)}`,
            "Crypto-Key": `dh=${b64urlEncode(serverPublicKey)};p256ecdsa=${VAPID_PUBLIC_KEY}`,
          },
          body: bodyBuf,
        });

        if (res.status === 410 || res.status === 404) {
          await supabase.from("push_subscriptions").delete().eq("id", sub.id);
        }

        return { status: res.status, endpoint };
      })
    );

    const sent = results.filter(r => r.status === "fulfilled").length;
    return new Response(JSON.stringify({ sent, total: subs.length }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" }
    });

  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" }
    });
  }
});

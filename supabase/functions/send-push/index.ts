import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const VAPID_PUBLIC_KEY  = Deno.env.get("VAPID_PUBLIC_KEY")  || "";
const VAPID_PRIVATE_KEY = Deno.env.get("VAPID_PRIVATE_KEY") || "";
const VAPID_SUBJECT     = "mailto:jan@elitemarcial.com";

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

  // Recipient public key
  const recipientPub = await crypto.subtle.importKey(
    "raw", b64urlDecode(p256dh),
    { name: "ECDH", namedCurve: "P-256" },
    false, []
  );

  // Generate ephemeral key pair
  const serverKeyPair = await crypto.subtle.generateKey(
    { name: "ECDH", namedCurve: "P-256" },
    true, ["deriveKey", "deriveBits"]
  );
  const serverPublicKeyRaw = new Uint8Array(
    await crypto.subtle.exportKey("raw", serverKeyPair.publicKey)
  );

  // ECDH shared secret
  const sharedBits = await crypto.subtle.deriveBits(
    { name: "ECDH", public: recipientPub },
    serverKeyPair.privateKey, 256
  );

  // Auth secret
  const authSecret = b64urlDecode(auth);

  // HKDF: PRK
  const salt = crypto.getRandomValues(new Uint8Array(16));
  const hkdfKey = await crypto.subtle.importKey("raw", sharedBits, "HKDF", false, ["deriveBits"]);

  // Content encryption key + nonce
  const prkInfo = enc.encode("Content-Encoding: auth\0");
  const prkSalt = authSecret;
  const prk = await crypto.subtle.deriveBits(
    { name: "HKDF", hash: "SHA-256", salt: prkSalt, info: prkInfo },
    hkdfKey, 256
  );

  const cekInfo = new Uint8Array([
    ...enc.encode("Content-Encoding: aesgcm\0"),
    ...new Uint8Array(1),
    ...new Uint8Array([65]), // length of pub key
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

  // Pad payload (2-byte length prefix)
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

  try {
    const { user_id, title, body, url = "/", tag, icon } = await req.json();
    if (!user_id) return new Response(JSON.stringify({ error: "user_id required" }), { status: 400, headers: corsHeaders });

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

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
        const audience = new URL(endpoint).origin;
        const headers  = await buildVapidHeaders(audience);

        // Encrypt payload
        const { ciphertext, salt, serverPublicKey } = await encryptPayload(
          payload, sub.p256dh, sub.auth
        );

        // Build body: salt(16) + rs(4) + keyid_len(1) + server_pub(65) + ciphertext
        const rs = new Uint8Array([0, 0, 16, 0]); // record size 4096
        const keyIdLen = new Uint8Array([65]);
        const body = new Uint8Array(16 + 4 + 1 + 65 + ciphertext.length);
        let offset = 0;
        body.set(salt, offset); offset += 16;
        body.set(rs, offset);   offset += 4;
        body.set(keyIdLen, offset); offset += 1;
        body.set(serverPublicKey, offset); offset += 65;
        body.set(ciphertext, offset);

        const res = await fetch(endpoint, {
          method: "POST",
          headers: {
            ...headers,
            "Content-Encoding": "aesgcm",
            "Encryption": `salt=${b64urlEncode(salt)}`,
            "Crypto-Key": `dh=${b64urlEncode(serverPublicKey)};p256ecdsa=${VAPID_PUBLIC_KEY}`,
          },
          body,
        });

        // Remove expired/invalid subscriptions
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

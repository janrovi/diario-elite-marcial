import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY");
const SUPABASE_URL   = Deno.env.get("SUPABASE_URL")!;
const ANON_KEY       = Deno.env.get("ANON_KEY")!;
const TO_EMAIL       = "jan@elitemarcial.com";
const FROM_EMAIL     = "notificaciones@elitemarcial.com";

const corsHeaders = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// ── FIX #4b: Escape HTML para evitar injection en el email ──────────────────
function escapeHtml(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;")
    .replace(/\n/g, "<br>");
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  // ── FIX #4a: Verificar JWT — solo usuarios autenticados pueden sugerir ─────
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
    const { tipo, texto, nombre, email, fecha } = await req.json();

    const tipoLabel: Record<string, string> = {
      funcion:  "💡 Nueva función",
      bug:      "🐛 Bug / Error",
      mejora:   "⚡ Mejora",
      contenido:"📚 Contenido",
      otro:     "💬 Otro",
    };

    const html = `
      <div style="font-family:sans-serif;max-width:600px;margin:0 auto;background:#0a0a0a;color:#f0f0f0;border-radius:12px;overflow:hidden">
        <div style="background:linear-gradient(135deg,#C41A1A,#8b0000);padding:24px 28px">
          <div style="font-size:20px;font-weight:900;letter-spacing:-0.5px">🥋 Élite Marcial</div>
          <div style="font-size:12px;opacity:0.7;margin-top:4px">Nueva sugerencia de Fundador</div>
        </div>
        <div style="padding:24px 28px">
          <div style="background:#1a1a1a;border:1px solid #333;border-left:4px solid #C41A1A;border-radius:8px;padding:16px;margin-bottom:20px">
            <div style="font-size:11px;font-weight:700;color:#C41A1A;text-transform:uppercase;letter-spacing:1px;margin-bottom:8px">${escapeHtml(tipoLabel[tipo] || tipo)}</div>
            <div style="font-size:15px;line-height:1.6;color:#f0f0f0">${escapeHtml(texto)}</div>
          </div>
          <table style="width:100%;border-collapse:collapse;font-size:12px;color:#888">
            <tr><td style="padding:4px 0"><strong style="color:#ccc">De:</strong></td><td>${escapeHtml(nombre)} &lt;${escapeHtml(email)}&gt;</td></tr>
            <tr><td style="padding:4px 0"><strong style="color:#ccc">Fecha:</strong></td><td>${escapeHtml(fecha)}</td></tr>
            <tr><td style="padding:4px 0"><strong style="color:#ccc">User ID:</strong></td><td>${user.id}</td></tr>
          </table>
        </div>
        <div style="padding:12px 28px 20px;font-size:11px;color:#555;border-top:1px solid #222">
          Enviado automáticamente desde la app Élite Marcial
        </div>
      </div>
    `;

    const res = await fetch("https://api.resend.com/emails", {
      method:  "POST",
      headers: {
        "Authorization": `Bearer ${RESEND_API_KEY}`,
        "Content-Type":  "application/json",
      },
      body: JSON.stringify({
        from:    `Élite Marcial <${FROM_EMAIL}>`,
        to:      [TO_EMAIL],
        subject: `[EM Fundador] ${tipoLabel[tipo] || tipo} — ${escapeHtml(nombre)}`,
        html,
      }),
    });

    if (!res.ok) {
      const err = await res.text();
      console.error("Resend error:", err);
      return new Response(JSON.stringify({ error: err }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    return new Response(JSON.stringify({ ok: true }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });

  } catch (e) {
    console.error(e);
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});

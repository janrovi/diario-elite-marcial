import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

// ─── Env vars (set in Supabase Dashboard > Project Settings > Edge Functions) ──
const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY")!;
// fix: secret obligatorio — falla duro si no está configurado
const WEBHOOK_SECRET = Deno.env.get("WELCOME_EMAIL_WEBHOOK_SECRET")!;

const FROM = "Élite Marcial <hola@elitemarcial.com>";
const APP_URL = "https://diario-elite-marcial.vercel.app";

// ─── Main handler ─────────────────────────────────────────────────────────────
serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  // Verificar secret obligatorio
  const secret = req.headers.get("x-webhook-secret");
  if (!secret || secret !== WEBHOOK_SECRET) {
    return new Response("Unauthorized", { status: 401 });
  }

  let payload: { type?: string; record?: { email?: string; raw_user_meta_data?: { full_name?: string } } };
  try {
    payload = await req.json();
  } catch {
    return new Response("Invalid JSON", { status: 400 });
  }

  // Supabase database webhook sends: { type: "UPDATE", record: { ... }, old_record: { ... } }
  const record = payload?.record;
  const email = record?.email;
  if (!email) {
    return new Response("No email in payload", { status: 400 });
  }

  const name = record?.raw_user_meta_data?.full_name?.split(" ")[0] || "campeón";

  const html = `
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bienvenido a Élite Marcial</title>
</head>
<body style="margin:0;padding:0;background:#111;font-family:Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#111;padding:40px 0;">
    <tr>
      <td align="center">
        <table width="560" cellpadding="0" cellspacing="0" style="background:#1a1a1a;border-radius:16px;overflow:hidden;max-width:560px;width:100%;">

          <!-- Header -->
          <tr>
            <td style="background:linear-gradient(135deg,#C41A1A,#8B0000);padding:36px 40px;text-align:center;">
              <div style="font-size:40px;margin-bottom:10px;">⚔️</div>
              <div style="font-size:24px;font-weight:900;color:#fff;letter-spacing:-0.5px;">ÉLITE MARCIAL</div>
              <div style="font-size:13px;color:rgba(255,255,255,0.7);margin-top:4px;text-transform:uppercase;letter-spacing:1px;">Tu diario de entrenamiento</div>
            </td>
          </tr>

          <!-- Body -->
          <tr>
            <td style="padding:36px 40px;">
              <p style="font-size:22px;font-weight:800;color:#f1f1f1;margin:0 0 12px;">¡Bienvenido, ${name}! 🥊</p>
              <p style="font-size:15px;color:#aaa;line-height:1.7;margin:0 0 24px;">
                Tu cuenta está lista. Empieza a registrar tus entrenos, seguir tu progreso y convertirte en el atleta que quieres ser.
              </p>

              <!-- CTA -->
              <table cellpadding="0" cellspacing="0" style="margin:0 0 28px;">
                <tr>
                  <td style="background:#C41A1A;border-radius:10px;">
                    <a href="${APP_URL}" style="display:inline-block;padding:14px 32px;font-size:15px;font-weight:800;color:#fff;text-decoration:none;letter-spacing:0.2px;">
                      Abrir la app →
                    </a>
                  </td>
                </tr>
              </table>

              <!-- Tips -->
              <p style="font-size:13px;font-weight:700;color:#f1f1f1;margin:0 0 12px;text-transform:uppercase;letter-spacing:0.5px;">Para empezar:</p>
              <table width="100%" cellpadding="0" cellspacing="0">
                ${[
                  ["📝", "Registra tu primera sesión", "Anota ejercicios, series, RPE y notas."],
                  ["📊", "Revisa tus estadísticas", "Heatmap anual, volumen semanal y más."],
                  ["🏆", "Descubre tu hoja de ruta", "Vota las funciones que quieres ver."],
                ].map(([icon, title, desc]) => `
                <tr>
                  <td style="padding:10px 0;border-bottom:1px solid #2a2a2a;">
                    <table cellpadding="0" cellspacing="0">
                      <tr>
                        <td style="font-size:22px;padding-right:14px;vertical-align:top;">${icon}</td>
                        <td>
                          <div style="font-size:14px;font-weight:700;color:#f1f1f1;">${title}</div>
                          <div style="font-size:12px;color:#888;margin-top:2px;">${desc}</div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>`).join("")}
              </table>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding:20px 40px;border-top:1px solid #2a2a2a;text-align:center;">
              <p style="font-size:11px;color:#555;margin:0;">
                Recibes este email porque creaste una cuenta en Élite Marcial.<br>
                © 2025 Élite Marcial · <a href="${APP_URL}" style="color:#C41A1A;text-decoration:none;">elitemarcial.com</a>
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;

  // Send via Resend
  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${RESEND_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      from: FROM,
      to: [email],
      subject: `¡Bienvenido a Élite Marcial, ${name}! ⚔️`,
      html,
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    console.error("Resend error:", err);
    return new Response("Email send failed", { status: 500 });
  }

  console.log(`Welcome email sent to ${email}`);
  return new Response(JSON.stringify({ ok: true }), {
    status: 200,
    headers: { "Content-Type": "application/json" },
  });
});

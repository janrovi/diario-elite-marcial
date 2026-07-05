import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY")!;
const HOOK_SECRET    = Deno.env.get("AUTH_HOOK_SECRET")!;
const FROM           = "Élite Marcial <noreply@elitemarcial.com>";
const SUPABASE_URL   = "https://jhudfgnfpgzjobskuhcr.supabase.co";

serve(async (req) => {
  // Verificar secret del hook
  const auth = req.headers.get("Authorization") ?? "";
  if (auth !== `Bearer ${HOOK_SECRET}`) {
    return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });
  }

  const { user, email_data } = await req.json();
  const { token_hash, redirect_to, email_action_type, site_url } = email_data;

  const link = `${SUPABASE_URL}/auth/v1/verify?token=${token_hash}&type=${email_action_type}&redirect_to=${redirect_to || site_url}`;

  let subject = "Acción requerida — Élite Marcial";
  let heading = "Acción requerida";
  let body    = `Haz click en el botón para continuar.`;
  let btnText = "Continuar";

  if (email_action_type === "recovery") {
    subject = "Restablecer contraseña — Élite Marcial";
    heading = "Restablecer contraseña";
    body    = "Recibimos una solicitud para restablecer tu contraseña. El enlace expira en 1 hora.";
    btnText = "Crear nueva contraseña";
  } else if (["signup", "email_confirmation"].includes(email_action_type)) {
    subject = "Confirma tu email — Élite Marcial";
    heading = "¡Bienvenido a Élite Marcial!";
    body    = "Confirma tu dirección de email para activar tu cuenta.";
    btnText = "Confirmar email";
  } else if (email_action_type === "invite") {
    subject = "Invitación — Élite Marcial";
    heading = "Te han invitado a Élite Marcial";
    body    = "Acepta la invitación para crear tu cuenta.";
    btnText = "Aceptar invitación";
  }

  const html = `<!DOCTYPE html>
<html>
<body style="margin:0;padding:0;background:#0f0f0f;font-family:Arial,sans-serif;">
  <div style="max-width:520px;margin:40px auto;background:#1a1a1a;border-radius:16px;padding:40px;color:#fff;">
    <div style="display:flex;align-items:center;gap:12px;margin-bottom:32px;">
      <span style="font-size:24px;font-weight:900;color:#e53e3e;">ÉM</span>
      <span style="font-size:18px;font-weight:700;color:#fff;">Élite Marcial</span>
    </div>
    <h2 style="margin:0 0 12px;font-size:22px;font-weight:800;">${heading}</h2>
    <p style="margin:0 0 28px;color:#aaa;font-size:15px;line-height:1.6;">${body}</p>
    <a href="${link}"
       style="display:inline-block;background:#e53e3e;color:#fff;padding:14px 28px;border-radius:10px;text-decoration:none;font-weight:700;font-size:15px;">
      ${btnText}
    </a>
    <p style="margin:28px 0 0;color:#555;font-size:12px;">
      Si el botón no funciona, copia este enlace en tu navegador:<br>
      <span style="color:#777;word-break:break-all;">${link}</span>
    </p>
    <hr style="border:none;border-top:1px solid #333;margin:28px 0;">
    <p style="margin:0;color:#555;font-size:11px;">
      Si no solicitaste este email, puedes ignorarlo con seguridad.
    </p>
  </div>
</body>
</html>`;

  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${RESEND_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ from: FROM, to: [user.email], subject, html }),
  });

  if (!res.ok) {
    const err = await res.text();
    console.error("Resend error:", err);
    return new Response(JSON.stringify({ error: err }), { status: 500 });
  }

  return new Response(JSON.stringify({ success: true }), { status: 200 });
});

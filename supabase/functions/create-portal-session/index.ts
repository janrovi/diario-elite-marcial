import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import Stripe from "https://esm.sh/stripe@14?target=deno&no-check";

const STRIPE_SECRET_KEY  = Deno.env.get("STRIPE_SECRET_KEY")!;
const SUPABASE_URL       = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const ANON_KEY           = Deno.env.get("ANON_KEY")!;

const stripe = new Stripe(STRIPE_SECRET_KEY, {
  apiVersion: "2024-06-20",
  httpClient: Stripe.createFetchHttpClient(),
});

serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  // ── Verificar JWT ──────────────────────────────────────────────────────────
  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return new Response("Unauthorized", { status: 401 });
  }
  const token = authHeader.slice(7);

  const anonClient = createClient(SUPABASE_URL, ANON_KEY);
  const { data: { user }, error: authErr } = await anonClient.auth.getUser(token);
  if (authErr || !user) {
    return new Response("Invalid token", { status: 401 });
  }

  // ── Obtener stripe_customer_id del perfil ─────────────────────────────────
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE);
  const { data: profile, error: profileErr } = await supabase
    .from("profiles")
    .select("stripe_customer_id, plan")
    .eq("id", user.id)
    .single();

  if (profileErr || !profile) {
    return new Response(JSON.stringify({ error: "Profile not found" }), { status: 404 });
  }

  if (!profile.stripe_customer_id) {
    return new Response(JSON.stringify({ error: "No active subscription found" }), { status: 400 });
  }

  // ── Leer return_url del body — FIX #6: validar dominio para evitar open redirect ──
  const ALLOWED_HOSTS = ["elitemarcial.com", "diario-elite-marcial.vercel.app"];
  let returnUrl = "https://diario-elite-marcial.vercel.app/";
  try {
    const body = await req.json();
    if (body.return_url) {
      const parsed = new URL(body.return_url);
      if (ALLOWED_HOSTS.includes(parsed.hostname)) {
        returnUrl = body.return_url;
      }
    }
  } catch (_) { /* body vacío o URL inválida, usar default */ }

  // ── Crear sesión del Customer Portal ─────────────────────────────────────
  try {
    const session = await stripe.billingPortal.sessions.create({
      customer: profile.stripe_customer_id,
      return_url: returnUrl,
    });

    return new Response(JSON.stringify({ url: session.url }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Stripe portal session error:", err.message);
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
});

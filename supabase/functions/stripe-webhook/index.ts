import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import Stripe from "https://esm.sh/stripe@14?target=deno&no-check";

// ─── Env vars (set in Supabase Dashboard > Edge Functions > stripe-webhook) ──
const STRIPE_SECRET_KEY    = Deno.env.get("STRIPE_SECRET_KEY")!;
const STRIPE_WEBHOOK_SECRET = Deno.env.get("STRIPE_WEBHOOK_SECRET")!;
const SUPABASE_URL          = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

// ─── Map Stripe Price IDs → plan name ────────────────────────────────────────
// Fill these in Supabase env vars once you have the price IDs from Stripe Dashboard
const PRICE_TO_PLAN: Record<string, string> = {
  [Deno.env.get("STRIPE_PRICE_COACH_MENSUAL") || "price_coach_mensual"]: "coach",
  [Deno.env.get("STRIPE_PRICE_COACH_ANUAL")   || "price_coach_anual"]:   "coach",
  [Deno.env.get("STRIPE_PRICE_FUNDADOR")       || "price_fundador"]:      "fundador",
};

const stripe = new Stripe(STRIPE_SECRET_KEY, {
  apiVersion: "2024-06-20",
  httpClient: Stripe.createFetchHttpClient(),
});

// ─── Main handler ─────────────────────────────────────────────────────────────
serve(async (req: Request) => {
  // Only POST
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  const signature = req.headers.get("stripe-signature");
  if (!signature) {
    console.error("Missing stripe-signature header");
    return new Response("Missing signature", { status: 400 });
  }

  // Read raw body (required for signature verification)
  const body = await req.text();

  // ── Verify Stripe signature ──────────────────────────────────────────────
  let event: Stripe.Event;
  try {
    event = await stripe.webhooks.constructEventAsync(
      body,
      signature,
      STRIPE_WEBHOOK_SECRET
    );
  } catch (err) {
    console.error("Signature verification failed:", err.message);
    return new Response(`Webhook error: ${err.message}`, { status: 400 });
  }

  console.log("Stripe event received:", event.type, event.id);

  // ── Handle checkout.session.completed ────────────────────────────────────
  if (event.type === "checkout.session.completed") {
    const session = event.data.object as Stripe.Checkout.Session;

    // Payment must be paid (not pending)
    if (session.payment_status !== "paid") {
      console.log("Session not paid yet, skipping:", session.payment_status);
      return new Response(JSON.stringify({ received: true }), { status: 200 });
    }

    const email = session.customer_details?.email || session.customer_email;
    if (!email) {
      console.error("No email in session:", session.id);
      return new Response("No email", { status: 400 });
    }

    // Determine plan from line items
    const lineItems = await stripe.checkout.sessions.listLineItems(session.id, { limit: 5 });
    const priceId = lineItems.data[0]?.price?.id;
    const plan = priceId ? PRICE_TO_PLAN[priceId] : null;

    if (!plan) {
      console.error("Unknown price ID:", priceId, "— add it to PRICE_TO_PLAN");
      // Return 200 so Stripe doesn't retry — unknown product
      return new Response(JSON.stringify({ received: true, warning: "unknown_price" }), { status: 200 });
    }

    // Update plan in Supabase (service_role bypasses RLS)
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE);

    // Find user by email via admin API
    const { data: { users }, error: listErr } = await supabase.auth.admin.listUsers({
      page: 1,
      perPage: 1000,
    });

    if (listErr) {
      console.error("Failed to list users:", listErr);
      return new Response("DB error", { status: 500 });
    }

    const user = users.find(u => u.email?.toLowerCase() === email.toLowerCase());
    if (!user) {
      console.error("User not found for email:", email);
      // Return 200 to avoid retries — user may have deleted account
      return new Response(JSON.stringify({ received: true, warning: "user_not_found" }), { status: 200 });
    }

    const { error: updateErr } = await supabase
      .from("profiles")
      .update({
        plan,
        stripe_customer_id: session.customer as string | null,
        plan_activated_at: new Date().toISOString(),
      })
      .eq("id", user.id);

    if (updateErr) {
      // If stripe_customer_id column doesn't exist yet, try without it
      const { error: updateErr2 } = await supabase
        .from("profiles")
        .update({ plan })
        .eq("id", user.id);

      if (updateErr2) {
        console.error("Failed to update plan:", updateErr2);
        return new Response("DB update error", { status: 500 });
      }
    }

    console.log(`✅ Plan activated: ${email} → ${plan} (session: ${session.id})`);
  }

  // ── Handle subscription cancellations ────────────────────────────────────
  if (event.type === "customer.subscription.deleted") {
    const subscription = event.data.object as Stripe.Subscription;
    const customerId = subscription.customer as string;

    if (!customerId) {
      console.error("No customer ID in subscription.deleted event");
      return new Response(JSON.stringify({ received: true }), { status: 200 });
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE);

    // Find user by stripe_customer_id and downgrade to free
    const { error: downgradeErr } = await supabase
      .from("profiles")
      .update({ plan: "free", plan_activated_at: null })
      .eq("stripe_customer_id", customerId);

    if (downgradeErr) {
      console.error("Failed to downgrade plan:", downgradeErr);
      // Try finding by email as fallback
      const customer = await stripe.customers.retrieve(customerId);
      if (!customer.deleted && customer.email) {
        const { data: { users } } = await supabase.auth.admin.listUsers({ page: 1, perPage: 1000 });
        const user = users.find(u => u.email?.toLowerCase() === customer.email!.toLowerCase());
        if (user) {
          await supabase.from("profiles").update({ plan: "free", plan_activated_at: null }).eq("id", user.id);
          console.log(`⬇️ Plan downgraded via email fallback: ${customer.email} → free`);
        }
      }
    } else {
      console.log(`⬇️ Plan downgraded: customer ${customerId} → free`);
    }
  }

  return new Response(JSON.stringify({ received: true }), {
    status: 200,
    headers: { "Content-Type": "application/json" },
  });
});

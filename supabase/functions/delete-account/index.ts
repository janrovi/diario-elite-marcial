import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL         = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const ANON_KEY             = Deno.env.get("ANON_KEY")!;

serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  // ── Verificar JWT del usuario ──────────────────────────────────────────────
  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return new Response("Unauthorized", { status: 401 });
  }
  const token = authHeader.slice(7);

  // Verificar el token con el cliente anon (JWT validation)
  const anonClient = createClient(SUPABASE_URL, ANON_KEY);
  const { data: { user }, error: authErr } = await anonClient.auth.getUser(token);
  if (authErr || !user) {
    return new Response("Invalid token", { status: 401 });
  }

  const uid = user.id;
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE);

  try {
    // 1. Borrar todos los datos del usuario en cascada via función SQL
    const { error: rpcErr } = await supabase.rpc("delete_user_data", { uid });
    if (rpcErr) {
      console.error("delete_user_data failed:", rpcErr);
      return new Response(JSON.stringify({ error: "Failed to delete user data" }), { status: 500 });
    }

    // 2. Intentar borrar avatar del storage
    const { data: avatarFiles } = await supabase.storage
      .from("avatars")
      .list(uid);
    if (avatarFiles && avatarFiles.length > 0) {
      await supabase.storage
        .from("avatars")
        .remove(avatarFiles.map(f => `${uid}/${f.name}`));
    }

    // 3. Borrar el usuario de auth (irreversible)
    const { error: deleteErr } = await supabase.auth.admin.deleteUser(uid);
    if (deleteErr) {
      console.error("deleteUser failed:", deleteErr);
      return new Response(JSON.stringify({ error: "Failed to delete auth user" }), { status: 500 });
    }

    console.log(`✅ Account deleted: ${uid}`);
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Unexpected error:", err);
    return new Response(JSON.stringify({ error: "Unexpected error" }), { status: 500 });
  }
});

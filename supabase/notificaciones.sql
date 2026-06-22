-- ── Tabla notificaciones ───────────────────────────────────────────────────
-- Ejecutar en Supabase → SQL Editor

create table if not exists notificaciones (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid references auth.users(id) on delete cascade not null,
  tipo       text not null default 'general',
  -- tipos: mensaje | coach_invite | invite_accepted | invite_rejected
  --        sesion_programada | sesion_completada | general
  titulo     text not null,
  cuerpo     text,
  leida      boolean not null default false,
  created_at timestamptz default now()
);

-- ── Índices ────────────────────────────────────────────────────────────────
create index if not exists notificaciones_user_id_idx on notificaciones(user_id);
create index if not exists notificaciones_created_at_idx on notificaciones(created_at desc);

-- ── RLS ───────────────────────────────────────────────────────────────────
alter table notificaciones enable row level security;

-- Cada usuario solo ve sus propias notificaciones
create policy "Users read own notifs"
  on notificaciones for select
  using (auth.uid() = user_id);

-- Cualquier usuario autenticado puede insertar (coach → atleta, atleta → coach)
create policy "Authenticated users insert notifs"
  on notificaciones for insert
  with check (auth.role() = 'authenticated');

-- Solo el destinatario puede marcarlas como leídas
create policy "Users update own notifs"
  on notificaciones for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- El usuario puede borrar las suyas
create policy "Users delete own notifs"
  on notificaciones for delete
  using (auth.uid() = user_id);

-- ── Realtime ──────────────────────────────────────────────────────────────
-- IMPORTANTE: habilitar también desde Supabase → Database → Replication
-- o con este comando:
alter publication supabase_realtime add table notificaciones;

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

-- FIX #3: INSERT solo permitido al propio usuario o a coaches hacia sus atletas
-- Reemplaza la policy anterior "Authenticated users insert notifs" que no validaba destinatario
create policy "Coaches notify own athletes"
  on notificaciones for insert
  with check (
    auth.role() = 'authenticated'
    AND (
      -- El destinatario es el propio usuario (notificaciones propias del sistema)
      user_id = auth.uid()
      OR
      -- O existe una relación coach→atleta activa
      EXISTS (
        SELECT 1 FROM coach_atleta
        WHERE coach_id = auth.uid()
          AND atleta_id = notificaciones.user_id
          AND estado = 'aceptado'
      )
    )
  );

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

-- ── Aplicar en producción ─────────────────────────────────────────────────
-- Si la tabla ya existe, corre esto en SQL Editor para actualizar las policies:
-- drop policy if exists "Authenticated users insert notifs" on notificaciones;
-- (luego crea la nueva policy "Coaches notify own athletes" de arriba)

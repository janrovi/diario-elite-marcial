-- Tabla para almacenar subscripciones push de cada usuario/dispositivo
create table if not exists push_subscriptions (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid references auth.users(id) on delete cascade not null,
  endpoint   text not null,
  p256dh     text not null,
  auth       text not null,
  created_at timestamptz default now(),
  unique(user_id, endpoint)
);

-- RLS
alter table push_subscriptions enable row level security;

create policy "Users manage own subscriptions"
  on push_subscriptions for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- FIX #2: eliminada la policy "Service role reads all" con using(true)
-- El service_role key ya bypasea RLS por completo — no necesita ninguna policy.
-- Si necesitas ejecutar este fix en producción, corre en SQL Editor:
-- drop policy if exists "Service role reads all" on push_subscriptions;

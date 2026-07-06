-- ── 1. Fecha de combate en profiles ──────────────────────────────────────
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS proxima_pelea DATE;

-- ── 2. Tabla periodizaciones (coach → atleta) ─────────────────────────────
CREATE TABLE IF NOT EXISTS periodizaciones (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coach_id    UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  atleta_id   UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  data        JSONB NOT NULL DEFAULT '[]',
  updated_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(coach_id, atleta_id)
);

ALTER TABLE periodizaciones ENABLE ROW LEVEL SECURITY;

-- El coach puede leer y escribir sus propias periodizaciones
CREATE POLICY "Coach gestiona sus periodizaciones" ON periodizaciones
  FOR ALL USING (auth.uid() = coach_id);

-- El atleta puede leer la periodización que le asignó su coach
CREATE POLICY "Atleta lee su periodizacion" ON periodizaciones
  FOR SELECT USING (auth.uid() = atleta_id);

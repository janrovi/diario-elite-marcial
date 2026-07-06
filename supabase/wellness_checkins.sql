-- ── Tabla: wellness_checkins ─────────────────────────────────────────────
-- Check-in diario de bienestar del atleta (Hooper Wellness Index)
-- HRW = sueño + físico + mental (3–15)
-- < 9  → no entrenar fuerte
-- 9–12 → entreno moderado
-- > 12 → listo para máximo rendimiento

CREATE TABLE IF NOT EXISTS wellness_checkins (
  id         UUID    DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id    UUID    REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  fecha      DATE    NOT NULL DEFAULT CURRENT_DATE,
  sueno      INTEGER NOT NULL CHECK (sueno  >= 1 AND sueno  <= 5),
  fisico     INTEGER NOT NULL CHECK (fisico >= 1 AND fisico <= 5),
  mental     INTEGER NOT NULL CHECK (mental >= 1 AND mental <= 5),
  notas      TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (user_id, fecha)  -- un check-in por día por usuario
);

-- RLS
ALTER TABLE wellness_checkins ENABLE ROW LEVEL SECURITY;

CREATE POLICY "wellness_select" ON wellness_checkins
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "wellness_insert" ON wellness_checkins
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "wellness_update" ON wellness_checkins
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "wellness_delete" ON wellness_checkins
  FOR DELETE USING (auth.uid() = user_id);

-- Índice para consultas frecuentes (usuario + fecha)
CREATE INDEX IF NOT EXISTS wellness_checkins_user_fecha
  ON wellness_checkins (user_id, fecha DESC);

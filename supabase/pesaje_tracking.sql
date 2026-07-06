-- ── Tabla: pesaje_tracking ──────────────────────────────────────────────────
-- Registro diario de peso durante el recorte Fight Week.
-- Atleta: CRUD propio. Coach: SELECT de sus atletas (vía coach_atleta).

CREATE TABLE IF NOT EXISTS pesaje_tracking (
  id            UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  atleta_id     UUID        REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  fecha         DATE        NOT NULL DEFAULT CURRENT_DATE,
  peso_kg       NUMERIC(5,2) NOT NULL,
  fecha_pesaje  DATE,          -- fecha del pesaje oficial (proxima_pelea)
  notas         TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (atleta_id, fecha)    -- solo un check-in por día por atleta
);

ALTER TABLE pesaje_tracking ENABLE ROW LEVEL SECURITY;

-- Atleta: acceso total a sus propias entradas
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='pesaje_tracking' AND policyname='atleta_pesaje_select') THEN
    CREATE POLICY "atleta_pesaje_select" ON pesaje_tracking
      FOR SELECT USING (auth.uid() = atleta_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='pesaje_tracking' AND policyname='atleta_pesaje_insert') THEN
    CREATE POLICY "atleta_pesaje_insert" ON pesaje_tracking
      FOR INSERT WITH CHECK (auth.uid() = atleta_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='pesaje_tracking' AND policyname='atleta_pesaje_update') THEN
    CREATE POLICY "atleta_pesaje_update" ON pesaje_tracking
      FOR UPDATE USING (auth.uid() = atleta_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='pesaje_tracking' AND policyname='atleta_pesaje_delete') THEN
    CREATE POLICY "atleta_pesaje_delete" ON pesaje_tracking
      FOR DELETE USING (auth.uid() = atleta_id);
  END IF;
END $$;

-- Coach: puede leer el pesaje de sus atletas
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='pesaje_tracking' AND policyname='coach_pesaje_select') THEN
    CREATE POLICY "coach_pesaje_select" ON pesaje_tracking
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM coach_atleta ca
          WHERE ca.coach_id = auth.uid()
            AND ca.atleta_id = pesaje_tracking.atleta_id
            AND ca.estado = 'activo'
        )
      );
  END IF;
END $$;

-- Índice
CREATE INDEX IF NOT EXISTS pesaje_atleta_fecha
  ON pesaje_tracking (atleta_id, fecha DESC);

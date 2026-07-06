-- ── Tabla: checkins_dolor ────────────────────────────────────────────────────
-- Check-in diario de dolor/molestia (modelo biopsicosocial simplificado).
-- Atleta: CRUD propio. Coach: SELECT de sus atletas (vía coach_atleta).

CREATE TABLE IF NOT EXISTS checkins_dolor (
  id          UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  atleta_id   UUID        REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  fecha       DATE        NOT NULL DEFAULT CURRENT_DATE,
  zona        TEXT        NOT NULL,
  intensidad  INTEGER     NOT NULL CHECK (intensidad BETWEEN 1 AND 10),
  tipo        TEXT        NOT NULL DEFAULT 'agudo' CHECK (tipo IN ('agudo','cronico','difuso')),
  estado      TEXT        NOT NULL DEFAULT 'activo' CHECK (estado IN ('activo','mejorado','resuelto')),
  notas       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE checkins_dolor ENABLE ROW LEVEL SECURITY;

-- Atleta: acceso total a sus propias entradas
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='checkins_dolor' AND policyname='atleta_dolor_select') THEN
    CREATE POLICY "atleta_dolor_select" ON checkins_dolor
      FOR SELECT USING (auth.uid() = atleta_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='checkins_dolor' AND policyname='atleta_dolor_insert') THEN
    CREATE POLICY "atleta_dolor_insert" ON checkins_dolor
      FOR INSERT WITH CHECK (auth.uid() = atleta_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='checkins_dolor' AND policyname='atleta_dolor_update') THEN
    CREATE POLICY "atleta_dolor_update" ON checkins_dolor
      FOR UPDATE USING (auth.uid() = atleta_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='checkins_dolor' AND policyname='atleta_dolor_delete') THEN
    CREATE POLICY "atleta_dolor_delete" ON checkins_dolor
      FOR DELETE USING (auth.uid() = atleta_id);
  END IF;
END $$;

-- Coach: puede leer el dolor de sus atletas
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='checkins_dolor' AND policyname='coach_dolor_select') THEN
    CREATE POLICY "coach_dolor_select" ON checkins_dolor
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM coach_atleta ca
          WHERE ca.coach_id = auth.uid()
            AND ca.atleta_id = checkins_dolor.atleta_id
            AND ca.estado = 'activo'
        )
      );
  END IF;
END $$;

-- Índices
CREATE INDEX IF NOT EXISTS dolor_atleta_fecha
  ON checkins_dolor (atleta_id, fecha DESC);

CREATE INDEX IF NOT EXISTS dolor_atleta_estado
  ON checkins_dolor (atleta_id, estado, fecha DESC);

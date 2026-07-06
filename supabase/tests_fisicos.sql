-- ── Tabla: tests_fisicos ─────────────────────────────────────────────────────
-- Resultados de tests de rendimiento (VO2max, CMJ, etc.)
-- Atleta: CRUD propio. Coach: SELECT de sus atletas (vía coach_atleta).

CREATE TABLE IF NOT EXISTS tests_fisicos (
  id          UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  atleta_id   UUID        REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  fecha       DATE        NOT NULL DEFAULT CURRENT_DATE,
  tipo_test   TEXT        NOT NULL,
  valor       NUMERIC(8,2) NOT NULL,
  unidad      TEXT        NOT NULL DEFAULT '',
  notas       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE tests_fisicos ENABLE ROW LEVEL SECURITY;

-- Atleta: acceso total a sus propios tests
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='tests_fisicos' AND policyname='atleta_tests_select') THEN
    CREATE POLICY "atleta_tests_select" ON tests_fisicos
      FOR SELECT USING (auth.uid() = atleta_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='tests_fisicos' AND policyname='atleta_tests_insert') THEN
    CREATE POLICY "atleta_tests_insert" ON tests_fisicos
      FOR INSERT WITH CHECK (auth.uid() = atleta_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='tests_fisicos' AND policyname='atleta_tests_update') THEN
    CREATE POLICY "atleta_tests_update" ON tests_fisicos
      FOR UPDATE USING (auth.uid() = atleta_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='tests_fisicos' AND policyname='atleta_tests_delete') THEN
    CREATE POLICY "atleta_tests_delete" ON tests_fisicos
      FOR DELETE USING (auth.uid() = atleta_id);
  END IF;
END $$;

-- Coach: puede leer los tests de sus atletas
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='tests_fisicos' AND policyname='coach_tests_select') THEN
    CREATE POLICY "coach_tests_select" ON tests_fisicos
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM coach_atleta ca
          WHERE ca.coach_id = auth.uid()
            AND ca.atleta_id = tests_fisicos.atleta_id
            AND ca.estado = 'activo'
        )
      );
  END IF;
END $$;

-- Índices
CREATE INDEX IF NOT EXISTS tests_atleta_fecha
  ON tests_fisicos (atleta_id, fecha DESC);

CREATE INDEX IF NOT EXISTS tests_atleta_tipo
  ON tests_fisicos (atleta_id, tipo_test, fecha DESC);

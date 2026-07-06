-- ── Tabla: tecnicas_asignadas ────────────────────────────────────────────────
-- Técnicas que el coach asigna a un atleta para trabajar.
-- Atleta: SELECT + UPDATE propio. Coach: CRUD de sus atletas.

CREATE TABLE IF NOT EXISTS tecnicas_asignadas (
  id                UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  atleta_id         UUID        REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  coach_id          UUID        REFERENCES auth.users(id) ON DELETE SET NULL,
  nombre            TEXT        NOT NULL,
  disciplina        TEXT,
  descripcion       TEXT,
  estado            TEXT        NOT NULL DEFAULT 'pendiente'
                                CHECK (estado IN ('pendiente','practicando','dominada')),
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE tecnicas_asignadas ENABLE ROW LEVEL SECURITY;

-- Atleta: SELECT y UPDATE de sus técnicas (para cambiar estado)
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='tecnicas_asignadas' AND policyname='atleta_tecnicas_select') THEN
    CREATE POLICY "atleta_tecnicas_select" ON tecnicas_asignadas
      FOR SELECT USING (auth.uid() = atleta_id);
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='tecnicas_asignadas' AND policyname='atleta_tecnicas_update') THEN
    CREATE POLICY "atleta_tecnicas_update" ON tecnicas_asignadas
      FOR UPDATE USING (auth.uid() = atleta_id);
  END IF;
END $$;

-- Coach: CRUD completo de las técnicas de sus atletas
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='tecnicas_asignadas' AND policyname='coach_tecnicas_select') THEN
    CREATE POLICY "coach_tecnicas_select" ON tecnicas_asignadas
      FOR SELECT USING (
        EXISTS (SELECT 1 FROM coach_atleta ca
          WHERE ca.coach_id = auth.uid() AND ca.atleta_id = tecnicas_asignadas.atleta_id AND ca.estado = 'activo')
      );
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='tecnicas_asignadas' AND policyname='coach_tecnicas_insert') THEN
    CREATE POLICY "coach_tecnicas_insert" ON tecnicas_asignadas
      FOR INSERT WITH CHECK (
        EXISTS (SELECT 1 FROM coach_atleta ca
          WHERE ca.coach_id = auth.uid() AND ca.atleta_id = tecnicas_asignadas.atleta_id AND ca.estado = 'activo')
      );
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename='tecnicas_asignadas' AND policyname='coach_tecnicas_delete') THEN
    CREATE POLICY "coach_tecnicas_delete" ON tecnicas_asignadas
      FOR DELETE USING (
        EXISTS (SELECT 1 FROM coach_atleta ca
          WHERE ca.coach_id = auth.uid() AND ca.atleta_id = tecnicas_asignadas.atleta_id AND ca.estado = 'activo')
      );
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS tecnicas_asig_atleta
  ON tecnicas_asignadas (atleta_id, estado, created_at DESC);

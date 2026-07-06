-- evaluaciones_coach: structured periodic athlete evaluations by coach
-- Run this in Supabase SQL Editor

DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='evaluaciones_coach') THEN
    CREATE TABLE evaluaciones_coach (
      id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      atleta_id  UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
      coach_id   UUID REFERENCES auth.users(id) ON DELETE SET NULL,
      fecha      DATE NOT NULL DEFAULT CURRENT_DATE,
      tecnica    SMALLINT NOT NULL DEFAULT 5 CHECK (tecnica BETWEEN 1 AND 10),
      fisico     SMALLINT NOT NULL DEFAULT 5 CHECK (fisico  BETWEEN 1 AND 10),
      mental     SMALLINT NOT NULL DEFAULT 5 CHECK (mental  BETWEEN 1 AND 10),
      tactica    SMALLINT NOT NULL DEFAULT 5 CHECK (tactica BETWEEN 1 AND 10),
      comentario TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END $$;

-- RLS
ALTER TABLE evaluaciones_coach ENABLE ROW LEVEL SECURITY;

-- Athlete can read their own evaluations
DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_policies WHERE tablename='evaluaciones_coach' AND policyname='atleta_evals_select') THEN
    CREATE POLICY atleta_evals_select ON evaluaciones_coach
      FOR SELECT TO authenticated
      USING (atleta_id = auth.uid());
  END IF;
END $$;

-- Coach can read evaluations for their athletes
DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_policies WHERE tablename='evaluaciones_coach' AND policyname='coach_evals_select') THEN
    CREATE POLICY coach_evals_select ON evaluaciones_coach
      FOR SELECT TO authenticated
      USING (
        EXISTS (
          SELECT 1 FROM coach_atleta
          WHERE coach_atleta.coach_id = auth.uid()
            AND coach_atleta.atleta_id = evaluaciones_coach.atleta_id
            AND coach_atleta.estado = 'activo'
        )
      );
  END IF;
END $$;

-- Coach can insert evaluations for their athletes
DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_policies WHERE tablename='evaluaciones_coach' AND policyname='coach_evals_insert') THEN
    CREATE POLICY coach_evals_insert ON evaluaciones_coach
      FOR INSERT TO authenticated
      WITH CHECK (
        coach_id = auth.uid() AND
        EXISTS (
          SELECT 1 FROM coach_atleta
          WHERE coach_atleta.coach_id = auth.uid()
            AND coach_atleta.atleta_id = evaluaciones_coach.atleta_id
            AND coach_atleta.estado = 'activo'
        )
      );
  END IF;
END $$;

-- Coach can delete their own evaluations
DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_policies WHERE tablename='evaluaciones_coach' AND policyname='coach_evals_delete') THEN
    CREATE POLICY coach_evals_delete ON evaluaciones_coach
      FOR DELETE TO authenticated
      USING (coach_id = auth.uid());
  END IF;
END $$;

-- Index
CREATE INDEX IF NOT EXISTS evals_atleta_fecha ON evaluaciones_coach(atleta_id, fecha DESC);

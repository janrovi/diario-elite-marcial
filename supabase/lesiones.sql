-- ── Tabla: lesiones ─────────────────────────────────────────────────────────
-- Registro clínico de lesiones del atleta.
-- Atleta: CRUD propio. Coach: SELECT de sus atletas, INSERT para reportar.

CREATE TABLE IF NOT EXISTS lesiones (
  id              UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  atleta_id       UUID        REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  fecha_inicio    DATE        NOT NULL DEFAULT CURRENT_DATE,
  zona            TEXT        NOT NULL,
  tipo            TEXT,
  gravedad        TEXT        DEFAULT 'moderada' CHECK (gravedad IN ('leve','moderada','grave')),
  estado          TEXT        NOT NULL DEFAULT 'activa' CHECK (estado IN ('activa','recuperando','curada')),
  notas           TEXT,
  reportado_por   TEXT        DEFAULT 'atleta' CHECK (reportado_por IN ('atleta','coach','medico')),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE lesiones ENABLE ROW LEVEL SECURITY;

-- Atleta: acceso total a sus propias lesiones
CREATE POLICY "atleta_lesiones_select" ON lesiones
  FOR SELECT USING (auth.uid() = atleta_id);

CREATE POLICY "atleta_lesiones_insert" ON lesiones
  FOR INSERT WITH CHECK (auth.uid() = atleta_id);

CREATE POLICY "atleta_lesiones_update" ON lesiones
  FOR UPDATE USING (auth.uid() = atleta_id);

CREATE POLICY "atleta_lesiones_delete" ON lesiones
  FOR DELETE USING (auth.uid() = atleta_id);

-- Coach: puede leer las lesiones de sus atletas (vía coach_atleta)
CREATE POLICY "coach_lesiones_select" ON lesiones
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM coach_atleta ca
      WHERE ca.coach_id = auth.uid()
        AND ca.atleta_id = lesiones.atleta_id
        AND ca.estado = 'activo'
    )
  );

-- Coach: puede registrar lesiones en sus atletas
CREATE POLICY "coach_lesiones_insert" ON lesiones
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM coach_atleta ca
      WHERE ca.coach_id = auth.uid()
        AND ca.atleta_id = lesiones.atleta_id
        AND ca.estado = 'activo'
    )
  );

-- Índices
CREATE INDEX IF NOT EXISTS lesiones_atleta_estado
  ON lesiones (atleta_id, estado, fecha_inicio DESC);

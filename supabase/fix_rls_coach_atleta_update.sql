-- ── FIX: coach_atleta_atleta_update — WITH CHECK desincronizado con la app ──
-- Problema identificado: el WITH CHECK usaba estado IN ('aceptado','rechazado')
-- pero la app escribe estado='activo' al aceptar y estado='inactivo' al rechazar.
-- Resultado: los atletas no podían aceptar ni rechazar invitaciones (UPDATE bloqueado).
--
-- Ejecutar en Supabase → SQL Editor (proyecto jhudfgnfpgzjobskuhcr)
-- ─────────────────────────────────────────────────────────────────────────────

-- Paso 1: eliminar la policy incorrecta
DROP POLICY IF EXISTS "coach_atleta_atleta_update" ON coach_atleta;

-- Paso 2: recrear con los valores correctos que usa la app
--   'activo'   → atleta acepta la invitación
--   'inactivo' → atleta rechaza la invitación
--   (no se permite volver a 'pendiente' ni ningún otro valor)
CREATE POLICY "coach_atleta_atleta_update"
  ON coach_atleta FOR UPDATE
  USING (atleta_id = auth.uid())
  WITH CHECK (
    atleta_id = auth.uid()
    AND coach_id = (SELECT coach_id FROM coach_atleta ca2 WHERE ca2.id = coach_atleta.id)
    AND estado IN ('activo', 'inactivo')
  );


-- ── VERIFICACIÓN: ejecutar después para confirmar ─────────────────────────────
-- SELECT policyname, cmd, qual, with_check
-- FROM pg_policies
-- WHERE tablename = 'coach_atleta'
-- ORDER BY policyname;

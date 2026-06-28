-- ── RLS Fixes: mensajes + coach_atleta ─────────────────────────────────────
-- Ejecutar en Supabase → SQL Editor
-- Identificado en revisión de policies post-auditoría

-- ══════════════════════════════════════════════════════════════════════════════
-- FIX 1: mensajes — verificar que existe relación coach↔atleta activa
-- Problema: la policy ALL solo comprueba coach_id/atleta_id = auth.uid(),
-- pero no que exista una relación real en coach_atleta. Cualquier usuario
-- autenticado podía insertar mensajes a cualquier otro usuario.
-- ══════════════════════════════════════════════════════════════════════════════

-- Eliminar policy permisiva existente
drop policy if exists "Coach y atleta pueden ver sus mensajes" on mensajes;

-- SELECT: solo partes de la conversación
create policy "mensajes_select"
  on mensajes for select
  using (
    coach_id = auth.uid() OR atleta_id = auth.uid()
  );

-- INSERT: solo si existe relación aceptada entre ambas partes
create policy "mensajes_insert"
  on mensajes for insert
  with check (
    (coach_id = auth.uid() OR atleta_id = auth.uid())
    AND EXISTS (
      SELECT 1 FROM coach_atleta ca
      WHERE ca.coach_id = mensajes.coach_id
        AND ca.atleta_id = mensajes.atleta_id
        AND ca.estado = 'aceptado'
    )
  );

-- UPDATE: solo las partes pueden editar sus mensajes (ej: marcar como leído)
create policy "mensajes_update"
  on mensajes for update
  using (coach_id = auth.uid() OR atleta_id = auth.uid())
  with check (coach_id = auth.uid() OR atleta_id = auth.uid());

-- DELETE: cada parte solo borra sus propios mensajes
create policy "mensajes_delete"
  on mensajes for delete
  using (coach_id = auth.uid() OR atleta_id = auth.uid());


-- ══════════════════════════════════════════════════════════════════════════════
-- FIX 2: coach_atleta — eliminar "relaciones propias" (ALL demasiado amplia)
-- Problema: esta policy daba a los atletas INSERT y DELETE vía la cláusula
-- ALL, solapándose con coaches_manage y creando permisos no intencionados.
-- La sustituimos por policies granulares.
-- ══════════════════════════════════════════════════════════════════════════════

-- Eliminar policies solapadas
drop policy if exists "relaciones propias" on coach_atleta;
drop policy if exists "coaches_manage" on coach_atleta;
drop policy if exists "athletes_view" on coach_atleta;
drop policy if exists "athletes_respond" on coach_atleta;

-- Coaches: control total sobre las relaciones que ellos crean
create policy "coach_atleta_coach_all"
  on coach_atleta for all
  using (coach_id = auth.uid())
  with check (coach_id = auth.uid());

-- Atletas: solo pueden VER las relaciones donde aparecen
create policy "coach_atleta_atleta_select"
  on coach_atleta for select
  using (atleta_id = auth.uid());

-- Atletas: solo pueden actualizar el campo estado (aceptar/rechazar invitación)
-- No pueden cambiar coach_id ni atleta_id
create policy "coach_atleta_atleta_update"
  on coach_atleta for update
  using (atleta_id = auth.uid())
  with check (
    atleta_id = auth.uid()
    AND coach_id = (SELECT coach_id FROM coach_atleta WHERE id = coach_atleta.id)
  );


-- ══════════════════════════════════════════════════════════════════════════════
-- VERIFICACIÓN (opcional, ejecutar después)
-- ══════════════════════════════════════════════════════════════════════════════
-- SELECT schemaname, tablename, policyname, cmd, qual, with_check
-- FROM pg_policies
-- WHERE tablename IN ('mensajes', 'coach_atleta')
-- ORDER BY tablename, policyname;

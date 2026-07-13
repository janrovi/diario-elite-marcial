---
tags: [database, preparacion-fisica, enfaf]
actualizado: 2026-07-13
---
# Estado de implementación — Database Élite Marcial
> Actualizado: julio 2026  
> Fuente de propuestas: `respuesta-chat-database-esquema-coach.md` (basado en ENFAF Asignaturas 1–5)

---

## ✅ Tablas implementadas

### `lesiones`
Migrada de localStorage a Supabase. El coach la ve en la ficha del atleta.  
Campos: zona, tipo, gravedad, estado, fecha_inicio, fecha_resolucion, notas, reportado_por  
RLS: atleta CRUD propio; coach SELECT vía coach_atleta  
**Falta**: banner de "lesión activa" en el panel antes de programar sesión (visual) — el dato ya existe.

---

### `checkins_dolor`
Implementada. Tab "Dolor" en CuerpoView del atleta.  
Campos: zona, tipo (agudo/crónico/difuso), intensidad 0–10, fecha, notas, estado (activo/mejorado/resuelto)  
Coach ve dolores no resueltos de los últimos 14 días en la ficha del atleta.  
**Falta**: campo `persiste_noche` (señal de alarma de Asignatura 5 · Fran Ortega) y `dias_consecutivos` calculado.  
**Falta**: alerta automática al coach si intensidad > 7 o lleva > 3 días activo.

---

### `fight_week_tracking`
Implementada. El atleta registra pesos diarios con alerta si el corte supera el 5%.  
Campos: atleta_id, fecha_pesaje, peso_objetivo_kg, peso_actual_kg, fase (crónica/aguda), notas  
Coach ve alerta en la ficha cuando el atleta está en Fight Week.  
**Falta**: `rebote_post_pesaje_kg` (dato de seguimiento post-pesaje)  
**Falta**: `checklist_logistica` JSONB (viaje, documentación médica, material reglamentario — Asignatura 4 · Clase 8)

---

### `tests_fisicos`
Implementada. El atleta registra resultados de tests en la vista Progreso; coach los ve en la ficha.  
Tipos disponibles: VO2máx, CMJ/salto vertical, velocidad 10m/30m, grip strength, press banca 1RM, sentadilla 1RM, peso muerto 1RM, flexibilidad sit-reach, Test Cooper 12min, Yo-Yo test, FC reposo, % grasa corporal, Otro  
Campos: atleta_id, fecha, tipo_test, valor, unidad, notas  
**Falta**: tests específicos de Asignatura 2 (Course Navette, test de agilidad con escalera, test equilibrio) — están como "Otro" por ahora.  
**Falta**: gráfico de evolución temporal por tipo (actualmente solo muestra último valor + tendencia ▲▼).

---

### `tecnicas_asignadas`
Implementada. Coach asigna desde la ficha; atleta ve en tab "📋 Coach" de TecnicasView.  
Campos: atleta_id, coach_id, nombre, disciplina, descripcion, estado (pendiente/practicando/dominada)  
**Falta**: cruzar con `sesiones.tecnica_dia` para ver si el atleta está practicando lo que se le asignó.  
**Falta**: prioridad y fecha_limite.

---

### `evaluaciones_coach`
Implementada. Coach evalúa desde tab "📋 Eval"; atleta ve en Progreso.  
Campos: atleta_id, coach_id, fecha, tecnica (1–10), fisico (1–10), mental (1–10), tactica (1–10), comentario  
**Falta**: más dimensiones (nutrición, recuperación — los 5 componentes de Asignatura 4 · Clase 4).  
**Falta**: gráfico radar de evolución de las 4 dimensiones a lo largo del tiempo.

---

## 🔜 Pendiente de implementar

### `sesiones_grupales`
La más compleja. Estructura planificada:
- Tabla principal: coach_id, fecha, nombre, disciplina, descripcion, duracion_min
- Tabla puente: `sesiones_grupales_atletas` (sesion_grupal_id, atleta_id, asistencia BOOL, rpe_individual, notas)
- Permite que cada atleta reporte su propio RPE sobre una sesión compartida
- El coach ve la distribución de RPE del grupo en una sola pantalla
- Integración con el calendario del coach (vista de grupo vs. individual)

**Prioridad**: alta. Es la siguiente en el roadmap.

---

### `terapias_recuperacion`
Basada en Asignatura 3 y 5 (Fran Ortega: no masaje intenso/punción seca en 48h previas a combate).  
Estructura propuesta: atleta_id, fecha, tipo (crioterapia/HBOT/contraste_termico/luz_roja/masaje/puncion_seca/EMG), duracion_min, notas  
Utilidad real: alerta al coach si el atleta registra una terapia agresiva demasiado cerca del pesaje.  
**Prioridad**: media-baja. El dato más crítico (evitar punción seca pre-combate) podría implementarse como un campo en fight_week_tracking.

---

## ⚡ Quick wins pendientes (datos que ya existen, sin UI todavía)

| Qué | Dato existente | Lo que falta |
|-----|----------------|--------------|
| Cruzar técnica asignada con `sesiones.tecnica_dia` | `tecnicas_asignadas` + `sesiones` | Indicador en ficha del atleta: "¿está practicando lo que le pedí?" |
| Banner "lesión activa" antes de programar sesión | `lesiones` (estado=activa) | Aviso visual en el calendario del coach al crear sesión para ese atleta |
| Evolución gráfica de tests físicos | `tests_fisicos` (histórico completo) | Gráfico de línea por tipo_test — los datos están, falta la visualización |
| Radar de evaluaciones coach | `evaluaciones_coach` | Gráfico radar técnica/físico/mental/táctica acumulado |
| `persiste_noche` en dolor | No existe aún | Añadir campo booleano en `checkins_dolor` — dato de alarma explícito de Asignatura 5 |

---

## 📌 Notas de arquitectura

- Todas las tablas nuevas usan RLS: atleta CRUD en sus propios datos; coach SELECT/INSERT/DELETE vía `coach_atleta` con estado='activo'
- Índices por `(atleta_id, fecha DESC)` en todas las tablas de series temporales
- Las tablas de series temporales (tests, dolor, pesaje, evaluaciones) no tienen UPDATE en RLS — los registros son inmutables por diseño; se corrige borrando e insertando de nuevo

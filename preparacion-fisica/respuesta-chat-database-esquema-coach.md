# Respuesta para Chat Database — Enriquecer el panel del coach

> Basado en el conocimiento consolidado en `preparacion-fisica/` (Asignaturas 1-5 del curso ENFAF). Cada propuesta cita la clase de origen para que puedas verificar el porqué.

## 1. Quick wins — datos que ya existen y no se muestran

- **Periodización de 12 semanas** (`periodizaciones.data`): mostrar en la ficha del atleta la fase actual (Adaptación / Especificidad / Tapering) con los porcentajes de volumen-intensidad-especificidad de esa semana (90/50/30 → 70/75/60 → 40/90/95, según Asignatura 4 · Clase 3). Esto convierte una tabla JSONB "muerta" en el dato más importante de la ficha: en qué fase del Training Camp está el atleta ahora mismo.
- **Técnica del día, lesiones y notas de `sesiones`**: exponerlas en la ficha, no solo el RPE. La técnica del día permite cruzar con `periodizaciones` para ver si la sesión real coincide con lo planificado; las notas de lesión son la primera señal de alarma que un coach debería ver sin tener que abrir cada sesión (Asignatura 5 · Dr. Beneito: "la detección precoz permite adaptar los entrenamientos antes de que la lesión se agrave").
- **Historial de lesiones consolidado**: hoy está disperso en `sesiones.lesiones` como texto libre; agregarlo en una vista/tabla propia (ver punto 2) para poder ver evolución en el tiempo, no solo el último parte.

## 2. Nuevas tablas propuestas

### `lesiones`
Consolida el catálogo clínico de Asignatura 3 y las clases del Dr. Beneito (Asignatura 5).

| Campo | Tipo | Notas |
|---|---|---|
| atleta_id | FK profiles | |
| fecha_inicio | DATE | |
| zona | TEXT | rodilla, hombro, acromioclavicular, mano, etc. |
| tipo | TEXT | traumática / por repetición / fatiga (clasificación de Asignatura 5 · Fisioterapia) |
| gravedad | TEXT | leve / moderada / grave |
| estado | TEXT | activa / en tratamiento / resuelta |
| fecha_resolucion | DATE, nullable | |
| notas_medicas | TEXT | |
| reportado_por | TEXT | atleta / coach / médico |

Esto habilita un "banner de lesión activa" en la ficha del atleta, visible antes de que el coach programe una sesión de alta carga.

### `checkins_dolor` (o extender `wellness_checkins`)
Basado en el modelo biopsicosocial del dolor (Asignatura 5 · Fran Ortega): dolor ≠ lesión, pero la persistencia sí importa.

| Campo | Tipo | Notas |
|---|---|---|
| user_id | FK profiles | |
| fecha | DATE | |
| zona | TEXT | |
| intensidad | INT 0-10 | escala tipo RPE |
| persiste_noche | BOOLEAN | señal de alarma explícita (Asignatura 5) |
| dias_consecutivos | INT calculado | dispara alerta al coach si > 3 |

### `fight_week_tracking`
Cubre Asignatura 4 · Clase 8 (Fight Week) y Asignatura 5 · Glenn Castro (nutrición) + Dr. Aldo (protocolo de rehidratación).

| Campo | Tipo | Notas |
|---|---|---|
| atleta_id | FK | |
| fecha_pesaje | DATE | |
| peso_objetivo_kg | NUMERIC | |
| peso_actual_kg | NUMERIC (histórico diario) | |
| pct_corte_24h | NUMERIC calculado | alerta si > 5% |
| fase | TEXT | crónica / aguda |
| rebote_post_pesaje_kg | NUMERIC | dato real registrado en Asignatura 5 (Topuria: 10.3-14 kg según combate) |
| checklist_logistica | JSONB | viaje, material reglamentario, documentación médica (Asignatura 4 · Clase 8) |

### `tests_fisicos`
Recoge los tests dispersos en Asignatura 1 y 2 (Course Navette, test esfuerzo máximo en cinta, dinamometría manual, sit and reach, test de agilidad) más los biomarcadores de Asignatura 5 (TMR, % grasa DEXA, análisis de sangre).

| Campo | Tipo | Notas |
|---|---|---|
| atleta_id | FK | |
| fecha | DATE | |
| tipo_test | TEXT | course_navette / dinamometria / sit_and_reach / agilidad / composicion_corporal / analitica_sangre |
| resultado | NUMERIC/JSONB | según tipo |
| notas | TEXT | |

Permite graficar evolución de VO2máx, fuerza de agarre, movilidad, % grasa, etc. a lo largo de temporadas — algo que hoy no existe en ninguna tabla.

### `tecnicas_asignadas` (coach → atleta)
Ya mencionada como pendiente. Sugerencia de columnas: `coach_id`, `atleta_id`, `tecnica`, `fecha_asignacion`, `disciplina`, `prioridad`, `estado` (pendiente/en progreso/dominada), `notas_coach`. Conecta con el campo `técnica_dia` de `sesiones` para que el coach vea si el atleta está practicando lo que se le asignó.

### `sesiones_grupales`
Ya mencionada. Estructura mínima: `coach_id`, `fecha`, `nombre`, `disciplina`, `descripcion`, y una tabla puente `sesiones_grupales_atletas` (atleta_id, sesion_grupal_id, asistencia, rpe_individual) para que cada atleta pueda reportar su propio RPE/fatiga sobre una sesión compartida.

### `evaluaciones_coach`
Evaluaciones estructuradas del atleta (ya mencionada como pendiente). Sugerencia: plantilla flexible tipo JSONB con secciones fijas inspiradas en el curso — técnico-táctico, físico, psicológico, recuperación, nutrición (los "5 componentes clave" de Asignatura 4 · Clase 4) — para que el coach puntúe cada dimensión periódicamente y se pueda graficar la evolución global del atleta, no solo el RPE de sesión.

### `terapias_recuperacion`
Opcional pero justificado por Asignatura 3 y 5: registrar qué terapia de recuperación recibió el atleta y cuándo (crioterapia, HBOT, luz roja, contraste térmico, EMG). Cruzado con `fight_week_tracking`, permite bloquear/alertar terapias agresivas (punción seca, masaje intenso) en las 48h previas a competir (Asignatura 5 · Fran Ortega).

## 3. Priorización sugerida

1. Exponer periodización + técnica/lesiones/notas en la ficha del atleta (coste bajo, ya existe el dato).
2. `lesiones` + `checkins_dolor` (mayor impacto en prevención, encaja con el bloque médico más repetido del curso).
3. `fight_week_tracking` (alto valor diferencial, nadie más lo cubre con este detalle).
4. `tecnicas_asignadas` y `sesiones_grupales` (ya en el roadmap del propio equipo).
5. `tests_fisicos` y `evaluaciones_coach` (más ambicioso, pero es lo que convierte la app de "diario de sesiones" a "sistema de seguimiento de rendimiento").

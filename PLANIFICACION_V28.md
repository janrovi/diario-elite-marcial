---
tags: [planificacion]
version: "2.8"
estado: completado
actualizado: 2026-07-06
---
# Planificación v2.8 — Periodización Inteligente
> Última actualización: 6 jul 2026  
> Empezar aquí en la próxima sesión.

---

## ¿Qué es v2.8?

La actualización más importante hasta la fecha. Transforma la app de un diario de entrenamiento en un **sistema inteligente de preparación física para artes marciales**, basado en la metodología del curso universitario ENFAF (5 asignaturas procesadas).

---

## Las 4 features del anuncio

### 1. 📅 Periodización de 12 semanas
**Qué hace:** El atleta introduce la fecha de su próximo combate. La app genera automáticamente un plan de 12 semanas dividido en 3 fases:

| Fase | Semanas | Volumen | Intensidad | Especificidad |
|------|---------|---------|------------|---------------|
| Preparación General | 1–4 | 90% | 50% | 30% |
| Preparación Específica | 5–8 | 70% | 75% | 60% |
| Pre-competición | 9–12 | 40% | 90% | 95% |

**Dónde vive en la app:** Nueva sección en vista atleta — "Mi Plan" o pestaña en CalendarView.  
**Tabla Supabase necesaria:** `planes_periodizacion` (nueva).

---

### 2. ⚡ Alertas de sobrecarga (sRPE)
**Qué hace:** Calcula la carga de entrenamiento semanal usando sRPE = RPE × duración (min). Si la carga sube >10% respecto a la semana anterior → alerta amarilla. Si sube >20% → alerta roja.

**Datos que ya tenemos:** `sesiones.rpe` y `sesiones.duracion_min` ya están en la DB.  
**Implementación:** Cálculo en el frontend al cargar HomeView. Sin tabla nueva necesaria.

---

### 3. 🥊 Protocolo Fight Week
**Qué hace:** Cuando quedan ≤7 días para el combate, activa un modo especial con:
- Límite seguro de corte de peso: máx. 5% del peso corporal en 7 días
- Guía día a día (entrenamientos cortos, técnica, tapering)
- Control de peso diario con alerta si la bajada es demasiado rápida

**Datos que ya tenemos:** `sesiones.peso` (biometría). Necesitamos `combates.fecha_combate` (tabla nueva o campo en profiles).

---

### 4. 🧠 Check-in diario de bienestar
**Qué hace:** Cada día al abrir la app, el atleta responde 3 preguntas rápidas (30 seg):
- 😴 ¿Cómo dormiste? (1–5)
- 💪 ¿Cómo te sientes físicamente? (1–5)
- 🧠 ¿Cómo estás mentalmente? (1–5)

Calcula HRW (Hooper Wellness Index) = suma de los 3. Si HRW < 9 → no entrenar duro.  
**Tabla Supabase necesaria:** `wellness_checkins` (nueva).

---

### 5. 🔴 Protocolo Hormonal (ciclo menstrual)
**Qué hace:** Para mujeres biológicas, adapta automáticamente las recomendaciones de entrenamiento según la fase del ciclo menstrual. Las 4 fases tienen perfiles hormonales distintos que afectan la capacidad de rendir, recuperarse y el riesgo de lesión:

| Fase | Días aprox. | Hormonas | Entrenamiento óptimo |
|------|-------------|----------|----------------------|
| Menstrual | 1–5 | Estrógeno y progesterona bajos | Volumen bajo, movilidad, recuperación |
| Folicular | 6–13 | Estrógeno sube | Alta intensidad, fuerza máxima, técnica |
| Ovulatoria | 14 | Estrógeno pico | Máximo rendimiento, competición ideal |
| Lútea | 15–28 | Progesterona alta | Volumen moderado, cardio, atención a fatiga |

**Datos necesarios:** Fecha de inicio del último ciclo + duración media del ciclo (guardado en profiles o tabla nueva `ciclo_config`).  
**Implementación:** Cálculo de fase en el frontend + badge en HomeView indicando la fase actual + recomendaciones del día ajustadas.  
**Importante:** Activación opcional — el atleta elige si quiere usar esta función. Nunca mostrado al coach sin permiso explícito.

---

## Orden de implementación recomendado

```
Sesión 1 (próxima):
  ├── Diseñar tablas Supabase (wellness_checkins, planes_periodizacion)
  ├── Crear SQL en Supabase + RLS
  └── Implementar Check-in diario (el más sencillo, alto impacto visual)

Sesión 2:
  ├── Implementar cálculo sRPE en HomeView
  ├── Alertas de sobrecarga (lógica + UI)
  └── Test con datos reales

Sesión 3:
  ├── Campo fecha_combate en profiles o tabla combates
  ├── Protocolo Fight Week (activación automática)
  └── Vista "Mi Plan" con las 3 fases

Sesión 4:
  ├── Periodización completa (12 semanas, generador)
  ├── Integración con CalendarView
  └── Vista del coach: ver el plan de cada atleta

Sesión 5:
  ├── Protocolo hormonal — configuración de ciclo en perfil
  ├── Cálculo de fase actual + recomendaciones adaptadas
  └── Badge en HomeView + integración con check-in diario
```

---

## Base de conocimiento disponible (ENFAF)

Los resumenes están en `preparacion-fisica/`:
- `resumen-asignatura-1-para-app.md` — VO₂máx, sRPE, Course Navette
- `resumen-asignatura-2-para-app.md` — movilidad, joint-by-joint
- `resumen-asignatura-3-para-app.md` — wellness, recuperación, HRW
- `resumen-asignatura-4-para-app.md` — periodización, Training Camp, macrociclos
- `resumen-asignatura-5-para-app.md` — nutrición, corte de peso, Topuria case

---

## Cómo arrancar la próxima sesión

1. Pegar `SESION_CONTEXTO.md` al inicio del chat
2. Decir: "Vamos con v2.8 — empezamos por el check-in diario de bienestar"
3. Claude lee este archivo y arranca directamente con el SQL + implementación

---

## Notas técnicas importantes

- `App.jsx` tiene ~16.550 líneas → SIEMPRE editar con scripts Python
- Tablas nuevas en Supabase → crear SQL + políticas RLS antes de usar en frontend
- El check-in debe ser no-intrusivo: aparecer una vez al día, dismissable, rápido
- sRPE ya tiene los datos → es la feature más fácil de implementar primero

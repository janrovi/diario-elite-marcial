---
tags: [roadmap]
actualizado: 2026-07-14
---
# Pendiente — Élite Marcial
> Orden = prioridad de implementación
> **Criterio actual:** experiencia atleta en móvil primero. Vista coach → después de testear.

**Ver también:** [[SESION_CONTEXTO]] · [[HISTORIAL_MEJORAS]] · [[preparacion-fisica/estado-implementacion-database]]

---

## 🔴 Vista atleta — Alta prioridad

- [ ] **Gráficos evolución tests físicos** — atleta ve su progresión en el tiempo. Datos ya en `tests_fisicos`, falta gráfico de línea por tipo de test (fuerza, cardio, etc.). Quick win: dato existe, solo falta visualización. #alta
- [ ] **Radar evaluaciones 4D** — atleta ve su evaluación técnica/físico/mental/táctica en `Progreso`. Datos en `evaluaciones_coach`. Gráfico spider motivador. Quick win. #alta
- [ ] **`sesiones_grupales` — lado atleta** — atleta recibe sesión grupal asignada por el coach y reporta su RPE individual. Solo la mitad atleta por ahora (coach UI queda en deferred). #alta

---

## 🟡 Vista atleta — Media prioridad

- [ ] **`terapias_recuperacion`** — atleta registra terapias de recuperación (crioterapia, masaje, HBOT...). Alerta si hay terapia agresiva 48h antes de competir. Nueva tabla. #media
- [ ] **`checkins_dolor` — campo `persiste_noche`** — booleano en el check-in de dolor del atleta. Alarma clínica (ENFAF). Campo pequeño en feature ya funcional. #media
- [ ] **Internacionalización atleta** — revisar strings hardcodeados en vistas móviles del atleta (HomeView, CalendarView, CuerpoView, TecnicasView). #media

---

## ⏸️ Deferred — Vista coach (después de testear atleta)

- [ ] **`sesiones_grupales` — lado coach** — crear sesión grupal, asignar atletas, ver distribución de RPE. Depende de que el lado atleta esté funcionando. #coach
- [ ] **Notificaciones push al coach** — trigger SQL cuando dolor > 7 o lesión nueva. Sistema ya existe. #coach
- [ ] **Banner lesión activa** — aviso al coach al programar sesión para atleta con lesión activa. #coach
- [ ] **Cruce técnicas ↔ sesiones practicadas** — indicador en ficha del atleta (vista coach): ¿practica la técnica asignada? #coach
- [ ] **Perfil público coach** (`/coach/:username`) — SEO, enlace compartible. Base existe en `CoachPublicProfile`. #coach

---

## ✅ Implementado recientemente

- [x] `evaluaciones_coach` — tab Eval en panel coach + sección en Progreso atleta
- [x] `tecnicas_asignadas` — coach asigna, atleta cicla estado
- [x] `tests_fisicos` — tests físicos con tendencia ▲▼
- [x] `checkins_dolor` — tab Dolor en CuerpoView + visibilidad coach
- [x] `fight_week_tracking` — seguimiento de pesaje con alerta 5%
- [x] `lesiones` — migradas a Supabase, visibles en ficha del atleta
- [x] Chat atleta ↔ coach — mensajería directa en la app
- [x] Fix registro — trigger SQL crea perfil sin sesión activa

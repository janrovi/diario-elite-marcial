---
tags: [roadmap]
actualizado: 2026-07-13
---
# Pendiente — Élite Marcial
> Orden = prioridad de implementación

**Ver también:** [[SESION_CONTEXTO]] · [[HISTORIAL_MEJORAS]] · [[MAPA_APP]] · [[preparacion-fisica/estado-implementacion-database]]

---

## 🔴 Alta prioridad

- [ ] **`sesiones_grupales`** — Coach crea sesión grupal → múltiples atletas reciben. Cada atleta reporta RPE individual. Requiere 2 tablas SQL + UI coach (crear/asignar) + UI atleta (recibir/reportar) + vista distribución RPE por sesión. #alta

---

## 🟡 Media prioridad

- [ ] **Perfil público coach** (`/coach/:username`) — URL limpia, SEO básico (meta tags), enlace compartible. Base ya existe en `CoachPublicProfile`. #media
- [ ] **Notificaciones push al coach** — trigger SQL cuando dolor > 7 o lesión nueva. Sistema de notificaciones ya existe. #media
- [ ] **Gráficos evolución tests físicos** — datos en `tests_fisicos`, falta visualización de línea temporal por tipo de test. #media
- [ ] **Radar evaluaciones coach** — gráfico spider con 4 dimensiones (técnica/físico/mental/táctica) por fecha. Datos en `evaluaciones_coach`. #media

---

## 🟢 Baja prioridad / backlog

- [ ] **`terapias_recuperacion`** — registrar terapias (crioterapia, masaje, HBOT...). Alerta si hay terapia agresiva 48h antes de competir. #baja
- [ ] **Banner lesión activa** — aviso al coach al programar sesión para atleta con lesión activa. Datos ya en `lesiones`. #baja
- [ ] **Cruce técnicas ↔ sesiones practicadas** — indicador en ficha del atleta: ¿practica la técnica asignada? Cruza `tecnicas_asignadas` con `sesiones.tecnica_dia`. #baja
- [ ] **`checkins_dolor` — campo `persiste_noche`** — booleano de alarma clínica según ENFAF Asignatura 5. Disparar alerta al coach si TRUE. #baja
- [ ] **Internacionalización completa** — strings hardcodeados en CoachApp y algunos modales. #baja

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

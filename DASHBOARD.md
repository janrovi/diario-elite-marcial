---
tags: [dashboard]
---
# 📊 Dashboard — Élite Marcial

> Panel central del proyecto. Los bloques Dataview se actualizan automáticamente.

**Accesos rápidos:** [[SESION_CONTEXTO]] · [[PENDIENTE]] · [[GUIA_PATRONES]] · [[DECISIONES]] · [[HISTORIAL_MEJORAS]] · [[PLANIFICACION_V28]]

**Última sesión:** [[sesiones/2026-07-14]]

---

## 🔜 Por implementar

```dataview
TASK
FROM "PENDIENTE"
WHERE !completed
```

---

## ✅ Implementado recientemente

```dataview
TASK
FROM "PENDIENTE"
WHERE completed
```

---

## 📁 Archivos del vault (más recientes)

```dataview
TABLE file.mtime AS "Modificado", tags AS "Etiquetas"
FROM ""
WHERE file.name != "DASHBOARD" AND file.name != "MAPA_APP"
SORT file.mtime DESC
LIMIT 8
```

---

## 📓 Sesiones recientes

```dataview
TABLE fecha AS "Fecha", duracion AS "Duración"
FROM "sesiones"
WHERE file.name != "TEMPLATE"
SORT fecha DESC
LIMIT 5
```

---

## 📚 Referencias técnicas

```dataview
TABLE tags AS "Tipo", file.mtime AS "Actualizado"
FROM #decisiones OR #patrones OR #historial
SORT file.mtime DESC
```

---

## 🗄️ Estado base de datos

| Tabla | Estado |
|-------|--------|
| `profiles` | ✅ |
| `sesiones` | ✅ |
| `sesiones_programadas` | ✅ |
| `coach_atleta` | ✅ |
| `mensajes` | ✅ |
| `lesiones` | ✅ |
| `checkins_dolor` | ✅ |
| `tests_fisicos` | ✅ |
| `tecnicas_asignadas` | ✅ |
| `evaluaciones_coach` | ✅ |
| `fight_week_tracking` | ✅ |
| `wellness_checkins` | ✅ |
| `periodizaciones` | ✅ |
| `sesiones_grupales` | ⏳ próximo |

Ver detalle completo → [[preparacion-fisica/estado-implementacion-database]]

---

## 🔗 Info del proyecto

| Campo | Valor |
|-------|-------|
| URL producción | https://diario-elite-marcial.vercel.app |
| Stack | React + Vite + Supabase + Stripe + Resend |
| Deploy | Vercel (auto en push a `main`) |
| Repo | `C:\Users\janro\diario-elite-marcial` |
| Supabase | `jhudfgnfpgzjobskuhcr` (Frankfurt) |

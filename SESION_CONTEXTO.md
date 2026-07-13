---
tags: [contexto, referencia]
actualizado: 2026-07-14
---
# Élite Marcial — Contexto de Sesión para Claude

> Pega este archivo al inicio de cualquier nueva conversación en Cowork.
> Última actualización: julio 2026

**Ver también:** [[DASHBOARD]] · [[PENDIENTE]] · [[GUIA_PATRONES]] · [[DECISIONES]] · [[HISTORIAL_MEJORAS]]

---

## ¿Qué es este proyecto?

**Diario Élite Marcial** es una PWA (Progressive Web App) para deportistas de artes marciales y sus entrenadores. Construida desde cero en esta conversación con Claude.

- **URL producción:** https://diario-elite-marcial.vercel.app
- **Stack:** React (Vite) + Supabase (PostgreSQL + Auth + Edge Functions + Storage) + Stripe + Resend
- **Deploy:** Vercel (automático en push a `main`)
- **Repositorio local:** `C:\Users\janro\diario-elite-marcial`

---

## Arquitectura general

### Frontend
- **Un único archivo:** `src/App.jsx` (~18.500 líneas)
- **REGLA CRÍTICA:** Nunca editar App.jsx con el Edit tool de Claude directamente. SIEMPRE usar scripts Python con `str.replace()`. El archivo es demasiado grande y el Edit tool falla o corrompe el código.

```python
# Patrón estándar de edición
with open("src/App.jsx", "r", encoding="utf-8") as f:
    code = f.read()
code = code.replace("""TEXTO_ORIGINAL""", """TEXTO_NUEVO""")
with open("src/App.jsx", "w", encoding="utf-8") as f:
    f.write(code)
```

### Backend (Supabase)
- **Proyecto:** `jhudfgnfpgzjobskuhcr` (región eu-central-1, Frankfurt)
- **URL:** https://jhudfgnfpgzjobskuhcr.supabase.co
- **Variables de entorno en `.env`:**
  ```
  VITE_SUPABASE_URL=https://jhudfgnfpgzjobskuhcr.supabase.co
  VITE_SUPABASE_ANON_KEY=sb_publishable_g6r-isX18cKpIF-LInVNYA_g-0qu73b
  ```

### Tablas Supabase
| Tabla | Descripción |
|-------|-------------|
| `profiles` | Usuarios (atletas y coaches). Campos clave: `plan`, `rol`, `email`, `nombre` |
| `sesiones` | Entrenamientos registrados por atletas |
| `sesiones_programadas` | Sesiones planificadas por el coach para el atleta |
| `coach_atleta` | Relación coach↔atleta. Estados: `pendiente`, `activo`, `inactivo` |
| `mensajes` | Chat entre coach y atleta |
| `notificaciones` | Notificaciones push in-app |
| `push_subscriptions` | Suscripciones Web Push (endpoint, p256dh, auth) |
| `coach_notas` | Notas privadas del coach sobre un atleta |
| `roadmap_votes` | Votos del roadmap de features (Club Fundador) |
| `avatars` | Storage bucket para avatares de usuario |
| `lesiones` | Lesiones del atleta (migradas de localStorage) |
| `checkins_dolor` | Check-in de dolor diario por zona corporal |
| `tests_fisicos` | Tests de condición física con tendencia ▲▼ |
| `tecnicas_asignadas` | Coach asigna técnicas, atleta cicla estado |
| `evaluaciones_coach` | Evaluación 4D coach (técnica/físico/mental/táctica) |
| `fight_week_tracking` | Seguimiento de pesaje fight week |
| `wellness_checkins` | Check-in de bienestar diario (HRW) |
| `periodizaciones` | Planes de periodización 12 semanas |

Ver detalle completo → [[preparacion-fisica/estado-implementacion-database]]

---

## Sistema de traducciones (i18n)

### Dos funciones distintas según contexto:

**`t(key, lang)`** — para componentes de atleta y compartidos:
```javascript
function t(key, lang) { return TRANSLATIONS[lang]?.[key] ?? TRANSLATIONS["es"][key] ?? key; }
```

**`tr(key)`** — para la vista coach (CoachApp). Lee `lang` del closure del componente.

### Idiomas soportados
- `es` — Español (default)
- `en` — English
- `ca` — Català

### Cómo añadir una nueva clave de traducción

1. Localizar la línea ancla en cada sección del objeto `TRANSLATIONS` (ES, EN, CA):
   ```javascript
   home_action_weight:"Registrar Peso",  // ancla ES
   ```
2. Insertar después de esa línea con `str.replace()` en Python:
   ```python
   code.replace(
     'home_action_weight:"Registrar Peso",',
     'home_action_weight:"Registrar Peso",\n    nueva_clave:"Valor en español",'
   )
   ```
3. Repetir para EN y CA.

### Strings con variables (interpolación)
Usar `{0}`, `{1}` como placeholders:
```javascript
// En TRANSLATIONS:
insight_rpe_up: "Tu RPE subió de {0} a {1} esta semana"

// En el componente:
t("insight_rpe_up", lang).replace("{0}", avgLast.toFixed(1)).replace("{1}", avgThis.toFixed(1))
```

### Regla `lang` en componentes standalone
Cualquier componente que no esté anidado en `CoachApp` o `MainApp` debe declarar:
```javascript
const lang = localStorage.getItem("em_lang") || "es";
```
Si se olvida → ReferenceError → pantalla "Algo salió mal".

### Fechas localizadas
Siempre usar `lang` como locale, nunca hardcodear `"es"`:
```javascript
// CORRECTO:
new Date().toLocaleDateString(lang, { weekday: "long", day: "numeric", month: "long" })

// MAL:
new Date().toLocaleDateString("es", ...)
```

---

## Estructura de componentes principales

```
MainApp()                    — componente raíz, gestiona auth y routing
├── AuthScreen               — login / registro / reset password
├── PendingPaymentScreen     — pago pendiente (coach en trial)
├── CoachView                — detecta si el usuario es coach
│   └── CoachApp             — app completa del coach (desktop)
│       ├── HomeView (coach)
│       ├── AthleteCard
│       ├── CoachFundadorPanel
│       └── ClubFundadorContent  ← componente standalone, necesita const lang
└── MainApp (atleta)         — app del atleta (mobile-first)
    ├── HomeView
    ├── CalendarView
    ├── TecnicasView
    ├── CuerpoView
    ├── NotasView
    └── UserMenu
```

---

## Disciplinas y grupos

### DISC_GROUPS (selector de disciplina en formulario de sesión)
```javascript
const DISC_GROUPS = [
  { label: "🥊 Striking",  discs: ["Boxeo","Muay Thai","Kickboxing","Karate","Taekwondo","Sanda","Savate","Krav Maga","Kyokushin","Lethwei","Cardio Kickboxing"] },
  { label: "🤼 Grappling", discs: ["BJJ","Lucha","Judo","Sambo","Grappling","Catch Wrestling","Shootfighting"] },
  { label: "⚔️ MMA",       discs: ["MMA"] },
  { label: "🏋️ Gym",       discs: ["Fuerza","Hipertrofia","Cardio","Movilidad","Calistenia","CrossFit","Funcional","Pliometría","Velocidad"] },
  { label: "🥋 Artes Trad.",discs: ["Kung Fu","Aikido","Hapkido","Ninjutsu","Escrima","Silat","Systema","Capoeira"] },
  { label: "🛡️ Defensa",   discs: ["Defensa Personal"] },
  { label: "➕ Otra",       discs: ["Otra"] },
]
```

### DISC_TO_TIPO (auto-rellena tipo_sesion al seleccionar disciplina)
```javascript
const DISC_TO_TIPO = {
  "Fuerza":"Fuerza", "Hipertrofia":"Fuerza", "Calistenia":"Fuerza",
  "CrossFit":"Fuerza", "Funcional":"Fuerza", "Pliometría":"Fuerza",
  "Cardio":"Cardio", "Velocidad":"Cardio", "Entrenamiento Aeróbico":"Cardio",
  "Movilidad":"Recuperación",
};
```

---

## Planes y monetización (Stripe)

### Planes disponibles
| Plan | Tipo | Precio | Descripción |
|------|------|--------|-------------|
| `atleta` | Gratis | — | Atleta sin coach |
| `coach_mensual` | Suscripción | 19€/mes | Coach con acceso a panel |
| `coach_anual` | Suscripción | 190€/año | Coach anual (2 meses gratis) |
| `fundador` | Vitalicio | 499€ (precio fundador) | Acceso vitalicio, Club Fundador |

### Lógica de activación
- Stripe webhook → confirma pago → actualiza `profiles.plan`
- El frontend usa **polling** (hasta 80s) para detectar la activación
- NO se permite auto-activar el plan desde el cliente

### Stripe Links (en `PRICES` const de App.jsx)
```javascript
const PRICES = {
  coach: {
    mensual: { stripe: "https://buy.stripe.com/14AfZgeou2iD5God5F2Ji00" },
    anual:   { stripe: "https://buy.stripe.com/cNieVcdkq5uP8SA1mX2Ji01" },
  },
  fundador: { actual: { stripe: "https://buy.stripe.com/cNi4gy3JQ0av3yg7Ll2Ji02" } },
}
```

---

## Edge Functions (Supabase)

| Función | Estado | Descripción |
|---------|--------|-------------|
| `send-suggestion` | ✅ Desplegada | Email de sugerencias al admin via Resend |
| `stripe-webhook` | ✅ Desplegada | Procesa pagos Stripe, actualiza plan |
| `create-portal-session` | ✅ Desplegada | Portal de gestión suscripción Stripe |
| `delete-account` | ✅ Desplegada | Borrado RGPD de cuenta |
| `send-push` | ✅ Desplegada | Notificaciones Web Push |
| `welcome-email` | ✅ Desplegada | Email bienvenida en registro |
| `auth-email-hook` | ⚠️ EN DUDA | Hook para emails de auth (reset password) via Resend |

### auth-email-hook — ✅ CONFIGURADO Y FUNCIONANDO (jul 2026)
Desplegada, Auth Hook activo, dominio elitemarcial.com verificado en Resend.

**Bug resuelto (5 jul 2026):** El `AUTH_HOOK_SECRET` de Edge Functions no coincidía con el secret configurado en Auth Hooks → Supabase devolvía 500 "Hook requires authorization token". Fix: regenerar secret en Auth Hooks y actualizar `AUTH_HOOK_SECRET` en Edge Functions secrets con el mismo valor `v1,whsec_...`.

**Diagnóstico:** Error visible en DevTools → Red → petición a `recover?redirect_to=...` → Response body muestra el error exacto de Supabase.

**Rate limit:** Supabase limita emails de recovery por dirección. Si se hacen muchos intentos seguidos → error 429 "over_email_send_rate_limit". Esperar 1h y reintentar.

**Nota:** Los emails llegaban pero iban a spam (ahora con dominio verificado no debería pasar).

### Secrets configurados en Supabase
- `RESEND_API_KEY` — API key de Resend (para emails)
- `STRIPE_SECRET_KEY` — Clave secreta Stripe
- `STRIPE_WEBHOOK_SECRET` — Secret para verificar webhooks de Stripe
- `STRIPE_PRICE_COACH_MENSUAL`, `STRIPE_PRICE_COACH_ANUAL` — Price IDs de Stripe
- `AUTH_HOOK_SECRET` — Secret para el hook de auth (verificar si está)

---

## Políticas RLS críticas

### coach_atleta — estados correctos
La app usa estos valores (NO 'aceptado'/'rechazado'):
- `'pendiente'` — invitación enviada por coach
- `'activo'` — atleta aceptó
- `'inactivo'` — atleta rechazó

El archivo `supabase/fix_rls_coach_atleta_update.sql` contiene la policy corregida y ya fue aplicado en el SQL Editor.

### Archivos SQL en el repo
- `supabase/rls_fixes_mensajes_coach_atleta.sql` — policies de mensajes y coach_atleta
- `supabase/fix_rls_coach_atleta_update.sql` — fix específico del WITH CHECK
- `supabase/notificaciones.sql` — policies de notificaciones
- `supabase/push_subscriptions.sql` — policies de push subscriptions

---

## Git y deploy

### Flujo de trabajo
1. Claude edita archivos via scripts Python o herramientas de archivo
2. **El sandbox de Claude NO puede hacer `git push`** (sin acceso a internet para Git)
3. El usuario hace el commit y push desde **PowerShell en su máquina**:

```powershell
# Si hay error de HEAD.lock (frecuente):
Remove-Item "C:\Users\janro\diario-elite-marcial\.git\HEAD.lock" -Force -ErrorAction SilentlyContinue

# Commit y push normal:
cd C:\Users\janro\diario-elite-marcial
git add -A
git commit -m "descripción del cambio"
git push
```

4. Vercel detecta el push a `main` y despliega automáticamente en ~1 min

### Error recurrente: HEAD.lock
Git a veces deja un archivo lock. Solución: el comando `Remove-Item` de arriba antes de cualquier operación git.

---

## Password reset — flujo completo

```javascript
// En AuthScreen (~línea 10992 de App.jsx):
await supabase.auth.resetPasswordForEmail(form.email, {
  redirectTo: "https://diario-elite-marcial.vercel.app"
});
```

Supabase llama al hook `auth-email-hook` que envía el email via Resend desde `noreply@elitemarcial.com`. El link redirige al usuario a la app donde se detecta `window.location.hash.includes("type=recovery")` y se muestra el formulario de nueva contraseña.

---

## Seguridad — resumen de lo implementado

- ✅ Rate limiting en login (bloqueo progresivo: 5/10/15 intentos → 30s/5min/30min)
- ✅ Headers HTTP: CSP, HSTS, X-Frame-Options, nosniff, Permissions-Policy
- ✅ JWT verification en todas las Edge Functions
- ✅ RLS en todas las tablas
- ✅ Stripe webhook con verificación de firma
- ✅ Anti-enumeración en registro y reset de contraseña
- ✅ UUID del admin en variable de entorno (`VITE_ADMIN_USER_ID`)
- ✅ Borrado de cuenta RGPD (`delete-account`)
- ✅ ErrorBoundary global (pantalla amigable en lugar de pantalla en blanco)

---

## Variables de entorno en Vercel

Configuradas en el dashboard de Vercel (no en el repo):
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`
- `VITE_ADMIN_USER_ID` — UUID del usuario admin

---

## Convenciones de código importantes

### Formulario de sesión
El formulario de nueva sesión usa `setF(campo, valor)`. Al seleccionar disciplina:
```javascript
onClick={() => {
  setF("disciplina", active ? "" : d);
  if (!active && DISC_TO_TIPO[d]) setF("tipo_sesion", DISC_TO_TIPO[d]);
  if (!active) setFormDiscCat("");
}}
```

### Colores de tema (CSS variables)
La app soporta modo oscuro/claro via CSS variables. No hardcodear colores hex en componentes nuevos.

### Supabase client
```javascript
import { createClient } from "@supabase/supabase-js";
const supabase = createClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
);
```

---

## Pendiente / próximas tareas

→ Ver [[PENDIENTE]] para el roadmap completo con prioridades.

Tareas técnicas recurrentes a revisar:
- [ ] **Re-deploy Edge Functions** si se modifican (send-push, send-suggestion, create-portal-session, stripe-webhook)
- [ ] **Continuar barrido i18n** — puede haber strings hardcodeados en secciones coach interiores

---

## Cómo arrancar una nueva sesión

1. Abre [[DASHBOARD]] en Obsidian → ver estado de tareas pendientes
2. Revisa [[GUIA_PATRONES]] si tienes dudas sobre cómo editar el código
3. Pega este archivo al inicio de la conversación en Cowork:

> "Estoy trabajando en la app Élite Marcial. Te adjunto el contexto del proyecto. [pega este archivo]"

Y Claude tendrá todo el contexto necesario para continuar sin preguntas.

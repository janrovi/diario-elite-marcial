# Élite Marcial — Auditoría de Seguridad v2.0
**Fecha:** 28 de junio de 2026

---

## Resumen ejecutivo

Segunda auditoría de seguridad completa sobre la PWA Élite Marcial. Se han identificado y cerrado 11 hallazgos adicionales distribuidos en tres áreas: Edge Functions, RLS de Supabase y frontend/service worker. Todos los vectores explotables sin credenciales han sido eliminados.

---

## Hallazgos y correcciones — Primera pasada

### 🔴 Crítico

#### 1. `send-push` — Sin autenticación
**Archivo:** `supabase/functions/send-push/index.ts`

Cualquier persona podía llamar al endpoint con un `user_id` arbitrario y enviar notificaciones push a cualquier usuario sin autenticarse. CORS abierto (`*`) lo hacía accesible desde cualquier origen.

**Fix:** JWT verification añadida (idéntica al patrón de `delete-account`). El emisor solo puede enviar push a su propio `user_id` o a atletas con relación `coach_atleta` aceptada verificada en BD.

---

### 🟠 Altos

#### 2. `push_subscriptions` — Policy RLS exponía claves push de todos los usuarios
**Archivo:** `supabase/push_subscriptions.sql`

La policy `"Service role reads all"` usaba `using(true)` sin restricción de rol, lo que en Supabase (donde las policies se combinan con OR) permitía a cualquier usuario autenticado leer `endpoint`, `p256dh` y `auth` de todos los demás usuarios.

**Fix:** Policy eliminada. El `service_role` key bypasses RLS por diseño y no necesita policy explícita.

#### 3. `notificaciones` — INSERT sin validar destinatario
**Archivo:** `supabase/notificaciones.sql`

La policy de INSERT solo verificaba `auth.role() = 'authenticated'`, permitiendo a cualquier usuario autenticado inyectar notificaciones con `user_id` apuntando a cualquier otra cuenta.

**Fix:** Policy reemplazada por `"Coaches notify own athletes"` que valida existencia de relación activa en `coach_atleta` con `estado = 'aceptado'`, o que el destinatario sea el propio usuario.

#### 4. `send-suggestion` — Sin autenticación + HTML injection
**Archivo:** `supabase/functions/send-suggestion/index.ts`

El endpoint era callable sin JWT, permitiendo spam al email del admin. Los campos `texto`, `nombre` y `email` se insertaban directamente en HTML sin escapar.

**Fix:** JWT verification añadida. Función `escapeHtml()` aplicada a todos los campos antes de generar el HTML del email.

---

### 🟡 Medios

#### 5. `stripe-webhook` — `listUsers` con límite 1000
**Archivo:** `supabase/functions/stripe-webhook/index.ts`

La búsqueda del usuario pagador descargaba hasta 1000 registros completos para hacer `find()` por email. Con más de 1000 usuarios, un pago legítimo no activaría el plan del cliente.

**Fix:** Búsqueda directa en tabla `profiles` por email con `eq("email", email)`.

#### 6. `create-portal-session` — Open redirect en `return_url`
**Archivo:** `supabase/functions/create-portal-session/index.ts`

El campo `return_url` se aceptaba del body del cliente sin validación, permitiendo redirigir al usuario a cualquier dominio tras el portal de Stripe.

**Fix:** Validación de dominio contra whitelist `['elitemarcial.com', 'diario-elite-marcial.vercel.app']` antes de usar la URL.

#### 7. UUID del admin hardcodeado en el bundle público
**Archivo:** `src/App.jsx` (línea 5739)

El UUID `fc8270f1-0be8-4248-90f8-a6517e845a0a` estaba expuesto en el JavaScript público de la app.

**Fix:** Movido a variable de entorno `VITE_ADMIN_USER_ID`. Configurado en Vercel dashboard + redeploy.

---

## Hallazgos y correcciones — Segunda pasada (barrido general)

#### 8. `welcome-email` — Webhook secret opcional con fallback inseguro
**Archivo:** `supabase/functions/welcome-email/index.ts`

El secret se cargaba con `|| ""`, haciendo que la verificación se saltara si la variable de entorno no estaba configurada.

**Fix:** Carga con `!` (falla duro si no está configurado). Función activada en producción con secret obligatorio.

#### 9. Contraseña mínima inconsistente
**Archivo:** `src/App.jsx`

El flujo de reset pedía mínimo 6 caracteres mientras el cambio desde perfil exigía 8.

**Fix:** Unificado a 8 caracteres en ambos flujos.

#### 10. Service Worker — open redirect en notificación click
**Archivo:** `src/sw.js`

`clients.openWindow(url)` abría cualquier URL recibida en el payload push sin validar origen.

**Fix:** Validación previa: solo se abre si la URL empieza por `/` o por el mismo origen del SW.

```javascript
const safeUrl = url.startsWith('/') || url.startsWith(self.location.origin)
  ? url : '/';
if (clients.openWindow) return clients.openWindow(safeUrl);
```

---

## Hallazgos y correcciones — Revisión RLS (tercera pasada)

#### 11. `mensajes` — Sin verificación de relación coach↔atleta
Policy `ALL` con `coach_id = auth.uid() OR atleta_id = auth.uid()` no comprobaba que existiera una relación real. Cualquier usuario autenticado podía enviar mensajes a cualquier otro.

**Fix:** Policy separada en 4 granulares (SELECT/INSERT/UPDATE/DELETE). El INSERT exige `EXISTS` en `coach_atleta` con `estado = 'aceptado'`.

#### 12. `coach_atleta` — Policy ALL demasiado amplia para atletas
El patrón `ALL` para `coach_id OR atleta_id` daba a los atletas permisos de INSERT y DELETE no intencionados. Un atleta podía crear solicitudes de relación y borrar filas directamente.

**Fix:** Reemplazada por 3 policies granulares:
- Coaches: `ALL`
- Atletas: `SELECT` + `UPDATE` con `WITH CHECK (estado IN ('aceptado', 'rechazado'))` — impide reactivar relaciones eliminadas por el coach.

#### Fix adicional: `welcome-email` — disparaba en todos los UPDATEs
El webhook en `auth.users UPDATE` enviaba el email de bienvenida en cada login, cambio de contraseña o actualización de perfil.

**Fix:** Check `isFirstConfirmation` — solo envía cuando `email_confirmed_at` pasa de `NULL` a un valor.

---

## Estado final de RLS verificado en producción

```sql
SELECT tablename, policyname, cmd FROM pg_policies
WHERE tablename IN ('mensajes', 'coach_atleta')
ORDER BY tablename, cmd;
```

**Resultado:** 7 policies activas, 0 solapadas. Todas las policies antiguas reemplazadas.

| Tabla | Policy | Comando |
|-------|--------|---------|
| coach_atleta | coach_atleta_coach_all | ALL |
| coach_atleta | coach_atleta_atleta_select | SELECT |
| coach_atleta | coach_atleta_atleta_update | UPDATE |
| mensajes | mensajes_select | SELECT |
| mensajes | mensajes_insert | INSERT |
| mensajes | mensajes_update | UPDATE |
| mensajes | mensajes_delete | DELETE |

---

## Reconciliación de datos en producción

Query ejecutada para detectar usuarios con plan activo sin `stripe_customer_id`:

```sql
SELECT id, email, plan, stripe_customer_id
FROM profiles
WHERE plan IN ('coach', 'fundador') AND stripe_customer_id IS NULL;
```

**Resultado:** 3 filas — todas cuentas de test internas. Ningún cliente real desincronizado.

---

## Pendiente (Backlog documentado)

| # | Qué | Motivo de aplazamiento |
|---|-----|------------------------|
| CSP `unsafe-inline`/`unsafe-eval` | Requiere Edge Middleware en Vercel — proyecto en sí mismo |
| Rate limiting server-side avanzado | Supabase Auth rate limit activo por defecto, suficiente para fase actual |
| `buscar_usuario_por_email` RPC — enumeración para coaches | UX requerida para el flujo de invitación; impacto limitado al rol coach |
| Penetration testing formal | Planificado para Fase 3 (crecimiento y monetización) |

---

## Decisiones de producto confirmadas

- **`profiles` coaches visibles para `anon`:** Intencional. Previsto directorio público de coaches en elitemarcial.com.

---

## Commits de esta sesión

| Commit | Descripción |
|--------|-------------|
| (RLS SQL Editor) | push_subscriptions: drop policy "Service role reads all" |
| (RLS SQL Editor) | notificaciones: nueva policy "Coaches notify own athletes" |
| (RLS SQL Editor) | mensajes + coach_atleta: 7 policies granulares |
| `07cc3a9` | security: second pass — webhook secret obligatorio, password min 8, SW open redirect, rate limit docs |
| (Vercel env) | VITE_ADMIN_USER_ID: UUID admin eliminado del bundle |
| (Supabase deploy) | welcome-email: isFirstConfirmation + secret obligatorio |

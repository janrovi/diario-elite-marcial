# Élite Marcial — Auditoría de Seguridad v1.0
**Fecha:** 24 de junio de 2026

---

## Resumen ejecutivo

Se ha completado la fase inicial de hardening de seguridad de la aplicación Élite Marcial PWA. Se han implementado 13 mejoras de seguridad que cubren las capas de red, datos, pagos, usuario y código.

---

## Cambios implementados

### 1. Headers HTTP de seguridad (Vercel)
**Commit:** `9938480`
- `Content-Security-Policy` — controla qué recursos puede cargar la app
- `Strict-Transport-Security` — fuerza HTTPS, preload en lista HSTS
- `X-Frame-Options: DENY` — protege contra clickjacking
- `X-Content-Type-Options: nosniff` — evita MIME sniffing
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy` — desactiva cámara, micrófono, geolocalización y pagos no autorizados
- `X-XSS-Protection: 1; mode=block`

### 2. Auditoría y corrección de RLS (Supabase)
**Aplicado vía SQL Editor**

Vulnerabilidades corregidas:
- **`notificaciones` INSERT** — cualquier usuario autenticado podía insertar notificaciones para otros usuarios. Corregido con `WITH CHECK (auth.uid() = user_id)`.
- **`coach_atleta` UPDATE** — política sin `WITH CHECK` permitía cambiar el `atleta_id`. Corregido añadiendo `WITH CHECK (atleta_id = auth.uid())`.
- **`profiles` UPDATE** — un usuario podía actualizar su propio campo `plan` directamente. Bloqueado con `WITH CHECK` que impide modificar el plan.

### 3. Bloqueo de auto-activación de plan
**Commits:** `38ec7d4`, RLS profiles

Se eliminó la lógica que permitía a un usuario activarse el plan `fundador` manipulando `localStorage`. Ahora la activación solo ocurre cuando el webhook de Stripe confirma el pago.

### 4. Stripe webhook con verificación de firma
**Edge Function:** `stripe-webhook`

- Verificación de `stripe-signature` con `stripe.webhooks.constructEventAsync()`
- Mapeo de Price IDs a planes via variables de entorno
- Actualización de `profiles.plan` solo tras pago confirmado
- JWT verification desactivado (Stripe no envía JWT)

### 5. Activación por polling
**Commit:** `38ec7d4`

Reemplazó la actualización directa del plan por un sistema de polling que espera hasta 80 segundos a que el webhook confirme el pago. Elimina por completo la posibilidad de auto-activación.

### 6. Variables de entorno auditadas
- Solo variables con prefijo `VITE_` se incluyen en el bundle del cliente
- Secrets de servidor únicamente en Supabase Edge Functions Secrets
- Variables de entorno configuradas en Vercel dashboard (no en repo)

### 7. .env eliminado de git
**Commit:** `2ab1e57`

- `git rm --cached .env`
- `.gitignore` actualizado con reglas para `.env`, `.env.*`, `!.env.example`

### 8. Rotación de credenciales comprometidas
**Fecha:** 24/06/2026

Credenciales que aparecieron en texto plano en el chat rotadas:
- `STRIPE_SECRET_KEY` — nueva clave generada, antigua con caducidad 24h
- `STRIPE_WEBHOOK_SECRET` — nuevo `whsec_` generado y actualizado en Supabase Secrets

### 9. Borrado de cuenta RGPD completo
**Commits:** `4e057fd`, SQL + Edge Function `delete-account`

- Función SQL `delete_user_data(uid)` borra en cascada: notificaciones, votos, push subscriptions, notas, mensajes, sesiones, relaciones coach-atleta, perfil
- Edge Function `delete-account`: verifica JWT → borra datos → borra storage → elimina usuario de auth
- UI: botón "Eliminar cuenta" en menú de perfil con modal de confirmación (requiere escribir "ELIMINAR")

### 10. npm audit
**Resultado:** 0 vulnerabilidades en dependencias

### 11. Email enumeration corregido
**Commit:** `ffa85e6`

El registro ya no revela si un email está registrado. Mensaje genérico en caso de email duplicado: "Si este email no está registrado, recibirás un correo de confirmación."

### 12. Input validation (maxLength)
**Commit:** `ffa85e6`

`maxLength` añadido en inputs críticos:
- Email: 254 caracteres (RFC 5321)
- Password: 128 caracteres
- Nombre: 100 caracteres
- Chat: 1000 caracteres
- Bio coach: 500 caracteres

### 13. CSP verificado en producción
Headers de seguridad confirmados activos en `diario-elite-marcial.vercel.app` vía DevTools. App funcionando sin errores de CSP.

---

## Columnas de tablas añadidas

```sql
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS stripe_customer_id TEXT,
  ADD COLUMN IF NOT EXISTS plan_activated_at TIMESTAMPTZ;
```

---

## Pendiente (Fase 2)

- Rate limiting server-side avanzado (más allá de Supabase Auth defaults)
- Logs de auditoría para acciones sensibles
- Penetration testing formal
- Validación server-side en Edge Functions (complementa maxLength del cliente)
- `maxLength` en el resto de inputs (107 inputs auditados, 7 críticos corregidos)

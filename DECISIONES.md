---
tags: [decisiones, arquitectura]
actualizado: 2026-07-14
---
# 📋 Registro de Decisiones — Élite Marcial

> Por qué el proyecto está construido como está.
> Contexto técnico → [[SESION_CONTEXTO]] | Patrones → [[GUIA_PATRONES]]

---

## D-01 — App.jsx monolítico (~18.500 líneas)

**Decisión:** Todo el frontend en un único archivo.

**Contexto:** El proyecto empezó como un prototipo rápido con Vite + React. Los componentes se fueron añadiendo en el mismo archivo porque era lo más simple para iterar rápido con Claude.

**Por qué no se refactorizó:** Refactorizar 18.500 líneas en múltiples archivos requeriría resolver todas las dependencias de closures, estados compartidos y funciones utilitarias que se referencian entre sí. El riesgo de introducir bugs es alto y el beneficio funcional es bajo.

**Consecuencia:** Hay que usar scripts Python para editar (ver D-02). El editor no puede abrir el archivo cómodamente pero no importa porque Claude lo gestiona.

**Revisitar cuando:** El proyecto tenga un equipo de más de 1 persona o cuando una feature nueva requiera componentes completamente aislados.

---

## D-02 — Scripts Python para editar App.jsx

**Decisión:** Nunca usar el Edit tool de Claude directamente sobre App.jsx. Siempre scripts Python con `str.replace()`.

**Por qué:** El Edit tool de Claude (que usa diff/patch) falla en archivos de más de ~5.000 líneas porque el contexto del match es demasiado grande o hay múltiples coincidencias parciales. Con Python, el control es explícito: si el ancla no existe → error inmediato, si hay más de una ocurrencia → error inmediato.

**Ventaja secundaria:** El script queda guardado en `patches/` como documentación de qué se cambió y por qué.

---

## D-03 — SQL trigger para crear perfil (no insert desde cliente)

**Decisión:** El perfil en `profiles` se crea automáticamente vía trigger de base de datos, no desde el código JavaScript del cliente.

**Por qué:** Supabase tiene email confirmation activado. Cuando un usuario hace `signUp()`, la respuesta incluye `data.session = null` hasta que confirme el email. Si el código cliente intenta hacer `profiles.insert()` en ese momento, RLS rechaza la operación porque no hay sesión activa → error 403.

**Alternativa descartada:** Desactivar email confirmation. Se descartó porque aumenta el riesgo de cuentas falsas y spam.

**Trigger SQL:**
```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, nombre, rol, plan)
  VALUES (new.id, new.email, split_part(new.email, '@', 1), 'atleta', 'atleta');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

---

## D-04 — Polling para detectar activación Stripe (no webhooks desde cliente)

**Decisión:** Después de redirigir desde el checkout de Stripe, el cliente hace polling a Supabase cada 2 segundos hasta detectar que `profile.plan` cambió.

**Por qué:** La app es una PWA sin servidor propio. Los webhooks de Stripe van a la Edge Function `stripe-webhook` → actualiza `profiles.plan`. El cliente no sabe cuándo ocurre esto, así que pregunta repetidamente.

**Duración del polling:** Hasta 80 segundos (40 intentos × 2s). Si no detecta cambio → muestra mensaje de error con enlace de soporte.

**Alternativa considerada:** Realtime subscription de Supabase en la fila del perfil. No se implementó porque añadía complejidad y el polling de 80s es suficientemente robusto.

---

## D-05 — Supabase como backend (no Firebase, no backend propio)

**Decisión:** Supabase como base de datos, auth, storage y funciones serverless.

**Por qué Supabase vs Firebase:**
- PostgreSQL con RLS nativo → políticas de seguridad en SQL, no en código
- SQL estándar → más potente para queries complejas (cruce de tablas, agregaciones)
- Edge Functions en Deno → para webhooks Stripe y envío de emails

**Por qué no backend propio (Express/FastAPI):**
- Coste adicional de servidor
- Más complejidad de deploy
- RLS de Supabase resuelve el 95% de los casos de autorización

---

## D-06 — Stripe links directos (no Stripe Elements embebido)

**Decisión:** Los botones de pago redirigen a Stripe Checkout hosted (URLs de buy.stripe.com), no a un formulario de pago embebido.

**Por qué:** Stripe Checkout managed no requiere manejar datos de tarjeta en el cliente (ni PCI compliance adicional). El flujo es: usuario hace clic → Stripe Checkout → pago → redirect back → polling detecta activación.

**Desventaja aceptada:** El usuario sale de la app para pagar. Experiencia menos fluida, pero más segura y simple de mantener.

---

## D-07 — Estado `coach_atleta` en español y 3 valores

**Decisión:** El campo `estado` en `coach_atleta` tiene valores `'pendiente'`, `'activo'`, `'inactivo'`.

**Por qué no inglés:** El proyecto empezó con valores en español y cambiarlos requeriría una migración de datos y actualizaciones en múltiples queries.

**Por qué no `aceptado`/`rechazado`:** Una refactorización a mitad del proyecto cambió los valores. Los archivos SQL en `supabase/` reflejan los valores actuales. Si se ve `'aceptado'` en algún sitio del código es un bug.

---

## D-08 — PWA sin service worker personalizado

**Decisión:** Vite genera el service worker básico. No hay lógica personalizada de caching o background sync.

**Por qué:** Las funcionalidades offline son mínimas (la app requiere conexión para Supabase). Un SW personalizado añadiría complejidad sin beneficio claro.

**Revisitar cuando:** Se quiera añadir modo offline real o push notifications sin depender del servidor.

---

## D-09 — Resend para emails transaccionales (no SendGrid/Mailgun)

**Decisión:** Todos los emails (bienvenida, reset password, sugerencias) pasan por Resend.

**Por qué:** API simple, dominio verificado (elitemarcial.com), integración directa con Supabase Auth Hooks. Plan gratuito suficiente para el volumen actual.

**Configuración:**
- Dominio verificado: `elitemarcial.com`
- From: `noreply@elitemarcial.com`
- API Key en Supabase secrets: `RESEND_API_KEY`

---

## D-10 — i18n manual (no react-i18next)

**Decisión:** Sistema de traducciones propio con un objeto `TRANSLATIONS` y funciones `t(key, lang)` / `tr(key)`.

**Por qué no una librería:**
- El proyecto empezó sin i18n y se añadió de forma incremental
- `react-i18next` requeriría refactorizar todos los componentes existentes
- El sistema actual es simple y suficiente para 3 idiomas

**Deuda técnica:** Los strings en el objeto `TRANSLATIONS` están en orden de inserción, no alfabético. Dificulta encontrar claves duplicadas. Aceptable por ahora.

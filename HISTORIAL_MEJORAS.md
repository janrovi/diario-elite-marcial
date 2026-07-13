---
tags: [historial]
fases: 7
commits_aprox: 51
actualizado: 2026-07-13
---
# 📋 Historial de mejoras — Élite Marcial

**Ver también:** [[PENDIENTE]] · [[SESION_CONTEXTO]] · [[MAPA_APP]]

---

## 🏗️ FASE 1 — Base PWA y Mobile (primeros commits)

| # | Qué | Estado |
|---|-----|--------|
| 1 | Primer commit — estructura base Vite + React | ✅ |
| 2 | PWA: vite-plugin-pwa, iconos, manifiesto | ✅ |
| 3 | Fix teclado móvil, ajuste safe area | ✅ |
| 4 | Logo escudo en header | ✅ |
| 5 | Push notifications + notificaciones campanita | ✅ |
| 6 | User data isolation (cada usuario ve solo sus datos) | ✅ |
| 7 | Service Worker autoUpdate — elimina ciclo de caché rota | ✅ |
| 8 | Avatar con compresión de imagen (800px JPEG) | ✅ |

---

## 📱 FASE 2 — Mobile UX (header, bottom nav, dropdowns)

| # | Qué | Estado |
|---|-----|--------|
| 9 | Header mobile: logo + nombre app visible, fondo acento rojo | ✅ |
| 10 | Bottom nav 5 items + drawer "Más" | ✅ |
| 11 | Dropdowns en mobile como bottom-sheets | ✅ |
| 12 | Notificaciones dropdown arriba en mobile | ✅ |
| 13 | Safe area fix (iOS) — header, coach, formularios | ✅ |
| 14 | Light mode: inputs, header contraste, auth toggle | ✅ |

---

## 🏆 FASE 3 — Club Fundador & Ecosistema

| # | Qué | Estado |
|---|-----|--------|
| 15 | Perfil público del coach (`/coach/:id`) | ✅ |
| 16 | Invitación a atletas desde banner coach | ✅ |
| 17 | @username, roadmap votable, muro fundadores, canal directo | ✅ |
| 18 | Club Fundador en panel coach (separado del nav diario) | ✅ |
| 19 | Changelog v2.1 / v2.2 en Club Fundador | ✅ |
| 20 | Club Fundador: changelog, roadmap Fase 3, categorías | ✅ |
| 21 | CoachFundadorPanel: changelog v2.3 / v2.4 | ✅ |

---

## 🔒 FASE 4 — Seguridad

| # | Qué | Estado |
|---|-----|--------|
| 22 | Headers HTTP: CSP, HSTS, X-Frame-Options, nosniff, Permissions-Policy | ✅ |
| 23 | Rate limiting login: bloqueo progresivo 5/10/15 intentos | ✅ |
| 24 | `handleActivate` usa polling en lugar de self-update de plan | ✅ |
| 25 | `.env` ignorado en git → `.env.example` | ✅ |
| 26 | Borrado de cuenta (RGPD) — Edge Function `delete-account` | ✅ |
| 27 | Anti-enumeración de email en registro (`signUp`) | ✅ |

---

## 💳 FASE 5 — Stripe & Suscripciones

| # | Qué | Estado |
|---|-----|--------|
| 28 | Cancelación automática de suscripción (`customer.subscription.deleted`) | ✅ |
| 29 | Edge Function `create-portal-session` — Stripe Customer Portal | ✅ |
| 30 | Portal de gestión visible solo para plan `coach` (no Fundador) | ✅ |
| 31 | `STRIPE_PRICE_*` env vars configuradas en Supabase | ✅ |

---

## 👤 FASE 6 — UX & Perfil de usuario

| # | Qué | Estado |
|---|-----|--------|
| 32 | Cambio de contraseña en menú de usuario (todos los planes) | ✅ |
| 33 | CoachFundadorPanel movido de Perfil → solo en Club | ✅ |
| 34 | Novedades v2.6: modal one-time al abrir la app | ✅ |
| 35 | Historial de novedades en menú usuario (no Fundadores) | ✅ |
| 36 | Tutoriales atleta y coach actualizados — v2.6 | ✅ |

---

## 📧 FASE 7 — Emails & Autenticación

| # | Qué | Estado |
|---|-----|--------|
| 37 | Fix: mensaje de éxito visible tras registro | ✅ |
| 38 | Fix: detectar email ya registrado (`identities.length === 0`) | ✅ |
| 39 | Fix: mensaje genérico en recuperación (anti-enumeración) | ✅ |
| 40 | SMTP configurado: Resend + `jan@elitemarcial.com` | ✅ |
| 41 | DKIM añadido a DNS Hostinger → dominio Verified en Resend | ✅ |
| 42 | Site URL corregida en Supabase (`localhost` → producción) | ✅ |
| 43 | `redirectTo` fijo a URL de producción en reset de contraseña | ✅ |
| 44 | Fix: formulario "nueva contraseña" aparece al clicar email de recuperación | ✅ |

---

## 📊 Resumen

| Fase | Área | Commits |
|------|------|---------|
| 1–2 | PWA + Mobile | ~20 |
| 3 | Club Fundador | ~8 |
| 4 | Seguridad | ~6 |
| 5 | Stripe | ~4 |
| 6 | UX & Perfil | ~5 |
| 7 | Emails & Auth | ~8 |
| **Total** | | **~51** |


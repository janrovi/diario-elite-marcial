with open("src/App.jsx", "r", encoding="utf-8") as f:
    src = f.read()

# ─────────────────────────────────────────────────────────
# NEW v2.9 entry for novedades modal (used in 2 places)
# ─────────────────────────────────────────────────────────
V29_ENTRY = '                { fecha:"7 Jul 2026", icon:"📊", titulo:"v2.9 — Panel Coach Command Center", items:["📊 Dashboard del equipo: HRW, sRPE, combates y fases de preparación en una tabla","🥊 Ficha atleta: bienestar 7 días, carga sRPE 4 semanas, banner combate","💾 Periodización guardada en Supabase — sin pérdida de datos al cambiar dispositivo","💬 Chat coach↔atleta en tiempo real","🗂 Vista atletas: navegación master-detail — equipo completo y ficha a pantalla completa"], badge:"new" },'

# ── 1. Novedades modal (coach view, showNovedadesHistory) ──
old1 = '                { fecha:"6 Jul 2026", icon:"🚀", titulo:"v2.8 — Preparación Inteligente", items:["📅 Plan de periodización de 12 semanas adaptado a tu combate","⚡ Alertas de sobrecarga sRPE con metodología de élite","🥊 Protocolo Fight Week — guía día a día + calculador de corte de peso","🧠 Check-in diario de bienestar (Hooper Wellness Index)","🌸 Protocolo hormonal — entrena según tu ciclo menstrual"], badge:"new" },\n                { fecha:"28 Jun 2026"'
new1 = V29_ENTRY + '\n                { fecha:"6 Jul 2026", icon:"🚀", titulo:"v2.8 — Preparación Inteligente", items:["📅 Plan de periodización de 12 semanas adaptado a tu combate","⚡ Alertas de sobrecarga sRPE con metodología de élite","🥊 Protocolo Fight Week — guía día a día + calculador de corte de peso","🧠 Check-in diario de bienestar (Hooper Wellness Index)","🌸 Protocolo hormonal — entrena según tu ciclo menstrual"] },\n                { fecha:"28 Jun 2026"'
assert src.count('{ fecha:"6 Jul 2026", icon:"🚀", titulo:"v2.8 — Preparación Inteligente"') >= 1, "FAIL 1: v2.8 entry not found"
src = src.replace(old1, new1)  # replaces both occurrences (same string appears in both modals)

# ─────────────────────────────────────────────────────────
# CHANGELOG 1: CoachFundadorView (line ~6456) — adds v2.8/v2.9 at top
# ─────────────────────────────────────────────────────────
old2 = '''  const CHANGELOG = [
    { version:"2.0", fecha:"Jun 2026", titulo:"Fase 2 completada — Push nativas & QA móvil", desc:"Notificaciones push nativas (Web Push API + VAPID + Edge Function). Nav inferior con panel 'Más'. Corrección iOS zoom en todos los inputs. Heatmap responsive. Módulo de lesiones con 35 zonas y 22 tipos específicos de artes marciales.", nuevo:true },'''
new2 = '''  const CHANGELOG = [
    { version:"2.9", fecha:"Jul 2026", titulo:"Panel Coach — Command Center & ficha atleta", desc:"Dashboard de equipo: HRW, sRPE, combates y fases de preparación. Ficha atleta con bienestar 7 días, carga 4 semanas y banner combate. Periodización en Supabase (sin pérdida de datos). Chat en tiempo real. Navegación master-detail.", nuevo:true },
    { version:"2.8", fecha:"Jul 2026", titulo:"Preparación Inteligente — sRPE, HRW, Fight Week, Periodización", desc:"Check-in diario HRW (Hooper Wellness Index). Alertas sRPE de sobrecarga (umbral 2.500). Protocolo Fight Week con guía día a día. Plan de periodización de 12 semanas. Protocolo hormonal. Fecha de combate sincronizada con el coach.", nuevo:false },
    { version:"2.7", fecha:"Jun 2026", titulo:"Auditoría de seguridad & Email de bienvenida", desc:"12 puntos de seguridad revisados y cerrados. Email de bienvenida automático. Mensajes coach↔atleta requieren conexión activa.", nuevo:false },
    { version:"2.0", fecha:"Jun 2026", titulo:"Fase 2 completada — Push nativas & QA móvil", desc:"Notificaciones push nativas (Web Push API + VAPID + Edge Function). Nav inferior con panel 'Más'. Corrección iOS zoom en todos los inputs. Heatmap responsive. Módulo de lesiones con 35 zonas y 22 tipos específicos de artes marciales.", nuevo:false },'''
assert old2 in src, "FAIL 2"
src = src.replace(old2, new2, 1)

# ─────────────────────────────────────────────────────────
# ROADMAP 1: CoachFundadorView (simple format)
# ─────────────────────────────────────────────────────────
old3 = '''  const ROADMAP = [
    { estado:"✅ Completado", titulo:"Notificaciones por email (Resend)", desc:"Sugerencias de Fundadores enviadas automáticamente vía Supabase Edge Functions + Resend. Función desplegada." },
    { estado:"✅ Completado", titulo:"Notificaciones en tiempo real", desc:"Notificaciones push in-app para mensajes, sesiones programadas, invitaciones y sesiones completadas." },
    { estado:"✅ Completado", titulo:"Push nativas del navegador (PWA)", desc:"Web Push API con VAPID, Edge Function send-push, service worker personalizado. Alertas del OS en móvil y desktop." },
    { estado:"✅ Completado", titulo:"QA & optimización móvil — Fase 2", desc:"iOS zoom corregido, nav con panel 'Más', heatmap responsive, módulo lesiones expandido, 15+ fixes de UX móvil." },
    { estado:"📋 Planificado", titulo:"App nativa iOS/Android", desc:"Versión nativa post-PWA con experiencia óptima en móvil y acceso biométrico." },
    { estado:"📋 Planificado", titulo:"Suscripciones recurrentes (Stripe)", desc:"Gestión de pagos para coaches: planes mensuales y anuales para sus atletas." },
    { estado:"💡 Evaluando", titulo:"IA de análisis de rendimiento", desc:"Recomendaciones personalizadas basadas en historial y biometría." },
    { estado:"💡 Evaluando", titulo:"Torneos y competiciones", desc:"Registro de resultados, historial de competición y ranking interno." },
    { estado:"💡 Evaluando", titulo:"Vídeos técnicos & comunidad", desc:"Biblioteca multimedia y red social entre atletas y coaches." },
  ];'''
new3 = '''  const ROADMAP = [
    { estado:"✅ Completado", titulo:"Notificaciones por email (Resend)", desc:"Sugerencias de Fundadores enviadas automáticamente vía Supabase Edge Functions + Resend." },
    { estado:"✅ Completado", titulo:"Push nativas del navegador (PWA)", desc:"Web Push API con VAPID, Edge Function send-push, service worker personalizado." },
    { estado:"✅ Completado", titulo:"Check-in HRW diario + alertas sRPE", desc:"Hooper Wellness Index (sueño + físico + mental). Alertas de sobrecarga semanal con umbral 2.500." },
    { estado:"✅ Completado", titulo:"Protocolo Fight Week + Periodización 12 semanas", desc:"Guía día a día para los 7 días previos al combate. Plan de 12 semanas con macros y mesos." },
    { estado:"✅ Completado", titulo:"Protocolo hormonal", desc:"Recomendaciones de entrenamiento según fase del ciclo menstrual." },
    { estado:"✅ Completado", titulo:"Panel Coach Command Center", desc:"Dashboard de equipo con HRW, sRPE, combates y fases. Ficha atleta con trends de bienestar y carga." },
    { estado:"✅ Completado", titulo:"Suscripciones Stripe + seguridad RGPD", desc:"Portal de gestión, cancelación automática, borrado de cuenta y 12 puntos de seguridad." },
    { estado:"🔨 En desarrollo", titulo:"@Username + perfil público del coach", desc:"Handle único. Página SEO en /coach/@username para captación orgánica." },
    { estado:"📋 Planificado", titulo:"App nativa iOS/Android", desc:"Versión nativa post-PWA con experiencia óptima en móvil y acceso biométrico." },
    { estado:"📋 Planificado", titulo:"Exportación de informes en PDF", desc:"Informe mensual por atleta y resumen de equipo descargable." },
    { estado:"💡 Evaluando", titulo:"IA de análisis de rendimiento (Claude API)", desc:"Recomendaciones personalizadas de carga, predicción de fatiga y prevención de lesiones." },
    { estado:"💡 Evaluando", titulo:"Torneos y competiciones", desc:"Registro de resultados, historial de competición y ranking interno." },
    { estado:"💡 Evaluando", titulo:"Feed de actividad & Comunidad", desc:"Retos semanales entre atletas del equipo y red social cerrada." },
  ];'''
assert old3 in src, "FAIL 3"
src = src.replace(old3, new3, 1)

# ─────────────────────────────────────────────────────────
# CHANGELOG 2: Main coach component (line ~6872)
# ─────────────────────────────────────────────────────────
old4 = '''  const CHANGELOG = [
    { version:"2.7", fecha:"Jun 2026", titulo:"Auditoría de seguridad completada & Email de bienvenida", desc:"Auditoría de seguridad completa — 12 puntos revisados y cerrados. Email de bienvenida automático al registrarse. Mensajes entre coach y atleta ahora requieren conexión activa. Novedades accesibles desde el menú.", nuevo:true },'''
new4 = '''  const CHANGELOG = [
    { version:"2.9", fecha:"Jul 2026", titulo:"Panel Coach — Command Center & ficha atleta", desc:"Dashboard del equipo con HRW, sRPE, combates y fases de preparación en una sola tabla. Ficha atleta con bienestar 7 días, carga sRPE 4 semanas y banner de combate. Periodización guardada en Supabase. Chat en tiempo real. Navegación master-detail.", nuevo:true },
    { version:"2.8", fecha:"Jul 2026", titulo:"Preparación Inteligente — sRPE, HRW, Fight Week, Periodización", desc:"Check-in diario HRW (Hooper Wellness Index). Alertas sRPE de sobrecarga. Protocolo Fight Week guía día a día. Plan de periodización de 12 semanas en Supabase. Protocolo hormonal. Fecha combate visible al coach.", nuevo:false },
    { version:"2.7", fecha:"Jun 2026", titulo:"Auditoría de seguridad completada & Email de bienvenida", desc:"Auditoría de seguridad completa — 12 puntos revisados y cerrados. Email de bienvenida automático al registrarse. Mensajes entre coach y atleta ahora requieren conexión activa.", nuevo:false },'''
assert old4 in src, "FAIL 4"
src = src.replace(old4, new4, 1)

# Update clMap for CHANGELOG 2
old5 = '''  const clMap = {
    "2.7":{ icon:"🛡️", color:"#10b981", tag:"Seguridad" },'''
new5 = '''  const clMap = {
    "2.9":{ icon:"📊", color:"#C41A1A", tag:"Coach" },
    "2.8":{ icon:"🚀", color:"#10b981", tag:"Atleta" },
    "2.7":{ icon:"🛡️", color:"#10b981", tag:"Seguridad" },'''
assert old5 in src, "FAIL 5"
src = src.replace(old5, new5, 1)

# ─────────────────────────────────────────────────────────
# ROADMAP_ITEMS 1 (main coach component, line ~6911)
# ─────────────────────────────────────────────────────────
old6 = '''  const ROADMAP_ITEMS = [
    { id:"stripe",       done:true,  estado:"✅", titulo:"Pagos & Suscripciones (Stripe)", desc:"3 planes con links directos." },
    { id:"push",         done:true,  estado:"✅", titulo:"Notificaciones push nativas", desc:"Web Push API + VAPID + Edge Function." },
    { id:"mobile",       done:true,  estado:"✅", titulo:"Mobile UX — iOS optimizado", desc:"Header safe area, bottom nav, paneles flotantes." },
    { id:"username",     done:false, estado:"🔨", titulo:"@Username + identidad", desc:"Handle único visible en la comunidad." },
    { id:"perfil-coach", done:false, estado:"🔨", titulo:"Perfil público del coach", desc:"Página SEO en /coach/@username." },
    { id:"videos",       done:false, estado:"📋", titulo:"Videos de técnicas", desc:"Embed YouTube/Vimeo en sesiones." },
    { id:"ia",           done:false, estado:"💡", titulo:"IA de rendimiento (Claude API)", desc:"Análisis del historial y predicción de fatiga." },
    { id:"comunidad",    done:false, estado:"💡", titulo:"Feed de actividad & Comunidad", desc:"Retos semanales entre atletas." },
    { id:"nativa",       done:false, estado:"💡", titulo:"App nativa iOS/Android", desc:"Versión nativa post-validación." },
  ];'''
new6 = '''  const ROADMAP_ITEMS = [
    { id:"stripe",       done:true,  estado:"✅", titulo:"Pagos & Suscripciones (Stripe)", desc:"3 planes con links directos. Portal self-service y cancelación automática." },
    { id:"push",         done:true,  estado:"✅", titulo:"Notificaciones push nativas", desc:"Web Push API + VAPID + Edge Function en Supabase." },
    { id:"mobile",       done:true,  estado:"✅", titulo:"Mobile UX — iOS optimizado", desc:"Header safe area, bottom nav, paneles flotantes." },
    { id:"hrw-srpe",     done:true,  estado:"✅", titulo:"HRW diario + alertas sRPE", desc:"Hooper Wellness Index. Alertas de sobrecarga semanal (umbral 2.500 u.a.)." },
    { id:"fightweek",    done:true,  estado:"✅", titulo:"Fight Week + Periodización 12 semanas", desc:"Protocolo día a día. Plan de 12 semanas con macros y mesos guardado en Supabase." },
    { id:"hormonal",     done:true,  estado:"✅", titulo:"Protocolo hormonal", desc:"Entrena según tu ciclo. Recomendaciones adaptadas a cada fase." },
    { id:"coach-dash",   done:true,  estado:"✅", titulo:"Panel Coach — Command Center", desc:"Dashboard de equipo completo. Ficha atleta con trends. Navegación master-detail." },
    { id:"username",     done:false, estado:"🔨", titulo:"@Username + perfil público del coach", desc:"Handle único. Página SEO /coach/@username para captación orgánica." },
    { id:"pdf-report",   done:false, estado:"📋", titulo:"Exportación informes PDF", desc:"Informe mensual por atleta y resumen de equipo." },
    { id:"videos",       done:false, estado:"📋", titulo:"Videos de técnicas", desc:"Embed YouTube/Vimeo en sesiones y biblioteca." },
    { id:"ia",           done:false, estado:"💡", titulo:"IA de rendimiento (Claude API)", desc:"Análisis del historial, recomendaciones de carga y predicción de fatiga." },
    { id:"comunidad",    done:false, estado:"💡", titulo:"Feed de actividad & Comunidad", desc:"Retos semanales entre atletas del equipo." },
    { id:"nativa",       done:false, estado:"💡", titulo:"App nativa iOS/Android", desc:"Versión nativa post-validación con biometría y offline avanzado." },
  ];'''
assert old6 in src, "FAIL 6"
src = src.replace(old6, new6, 1)

# ─────────────────────────────────────────────────────────
# CHANGELOG 3: MainApp athlete view (line ~14629)
# ─────────────────────────────────────────────────────────
old7 = '''          const CHANGELOG = [
            { version:"2.6", fecha:"Jun 2026", titulo:"Mejoras 23-25 Jun — Portal, seguridad & Club", desc:"Portal de gestión de suscripción para coaches. Cambio de contraseña desde el perfil. Club Fundador reorganizado. Seguimos en fase de consolidación en Vercel antes de lanzar la app nativa.", nuevo:true },'''
new7 = '''          const CHANGELOG = [
            { version:"2.9", fecha:"Jul 2026", titulo:"Panel Coach — Command Center & ficha atleta", desc:"Dashboard del equipo con HRW, sRPE, combates y fases. Ficha atleta con bienestar 7 días y carga 4 semanas. Periodización en Supabase. Navegación master-detail.", nuevo:true },
            { version:"2.8", fecha:"Jul 2026", titulo:"Preparación Inteligente — sRPE, HRW, Fight Week, Periodización", desc:"Check-in diario HRW (Hooper Wellness Index). Alertas sRPE. Protocolo Fight Week. Plan de periodización de 12 semanas. Protocolo hormonal. Fecha combate visible al coach.", nuevo:false },
            { version:"2.7", fecha:"Jun 2026", titulo:"Auditoría de seguridad & Email de bienvenida", desc:"12 puntos de seguridad revisados. Email de bienvenida automático. Mensajes coach↔atleta requieren conexión activa.", nuevo:false },
            { version:"2.6", fecha:"Jun 2026", titulo:"Mejoras 23-25 Jun — Portal, seguridad & Club", desc:"Portal de gestión de suscripción para coaches. Cambio de contraseña desde el perfil. Club Fundador reorganizado.", nuevo:false },'''
assert old7 in src, "FAIL 7"
src = src.replace(old7, new7, 1)

# Update clMap for CHANGELOG 3
old8 = '''          const clMap = {
            "2.4":{ icon:"✉️", color:"#10b981", tag:"Seguridad" },'''
new8 = '''          const clMap = {
            "2.9":{ icon:"📊", color:"#C41A1A", tag:"Coach" },
            "2.8":{ icon:"🚀", color:"#10b981", tag:"Atleta" },
            "2.7":{ icon:"🛡️", color:"#10b981", tag:"Seguridad" },
            "2.6":{ icon:"⚡", color:"#f59e0b", tag:"Portal" },
            "2.4":{ icon:"✉️", color:"#10b981", tag:"Seguridad" },'''
assert old8 in src, "FAIL 8"
src = src.replace(old8, new8, 1)

# ─────────────────────────────────────────────────────────
# ROADMAP_ITEMS 2: MainApp (line ~14658)
# ─────────────────────────────────────────────────────────
old9 = '''          const ROADMAP_ITEMS = [
            { id:"stripe",       done:true,  estado:"✅", titulo:"Pagos & Suscripciones (Stripe)", desc:"3 planes con links directos. Fundador, Coach Pro y Academia." },
            { id:"push",         done:true,  estado:"✅", titulo:"Notificaciones push nativas", desc:"Web Push API + VAPID + Edge Function en Supabase." },
            { id:"mobile",       done:true,  estado:"✅", titulo:"Mobile UX — iOS optimizado", desc:"Header safe area, bottom nav, paneles flotantes." },
            { id:"username",     done:false, estado:"🔨", titulo:"@Username + identidad", desc:"Handle único por usuario visible en la comunidad." },
            { id:"perfil-coach", done:false, estado:"🔨", titulo:"Perfil público del coach", desc:"Página SEO en /coach/@username para captación orgánica." },
            { id:"videos",       done:false, estado:"📋", titulo:"Videos de técnicas", desc:"Embed YouTube/Vimeo en sesiones y biblioteca." },
            { id:"ia",           done:false, estado:"💡", titulo:"IA de rendimiento (Claude API)", desc:"Análisis del historial, recomendaciones de carga y predicción de fatiga." },
            { id:"comunidad",    done:false, estado:"💡", titulo:"Feed de actividad & Comunidad", desc:"Retos semanales, actividad entre atletas del equipo." },
            { id:"nativa",       done:false, estado:"💡", titulo:"App nativa iOS/Android", desc:"Versión nativa post-validación con biometría y offline avanzado." },
          ];'''
new9 = '''          const ROADMAP_ITEMS = [
            { id:"stripe",       done:true,  estado:"✅", titulo:"Pagos & Suscripciones (Stripe)", desc:"3 planes. Portal self-service y cancelación automática." },
            { id:"push",         done:true,  estado:"✅", titulo:"Notificaciones push nativas", desc:"Web Push API + VAPID + Edge Function en Supabase." },
            { id:"mobile",       done:true,  estado:"✅", titulo:"Mobile UX — iOS optimizado", desc:"Header safe area, bottom nav, paneles flotantes." },
            { id:"hrw-srpe",     done:true,  estado:"✅", titulo:"HRW diario + alertas sRPE", desc:"Hooper Wellness Index. Alertas de sobrecarga (umbral 2.500 u.a.)." },
            { id:"fightweek",    done:true,  estado:"✅", titulo:"Fight Week + Periodización 12 semanas", desc:"Protocolo día a día. Plan de 12 semanas guardado en Supabase." },
            { id:"hormonal",     done:true,  estado:"✅", titulo:"Protocolo hormonal", desc:"Recomendaciones adaptadas a cada fase del ciclo menstrual." },
            { id:"coach-dash",   done:true,  estado:"✅", titulo:"Panel Coach — Command Center", desc:"Dashboard de equipo completo con HRW, sRPE, combates y fases." },
            { id:"username",     done:false, estado:"🔨", titulo:"@Username + perfil público del coach", desc:"Handle único. Página SEO /coach/@username." },
            { id:"pdf-report",   done:false, estado:"📋", titulo:"Exportación informes PDF", desc:"Informe mensual por atleta descargable." },
            { id:"videos",       done:false, estado:"📋", titulo:"Videos de técnicas", desc:"Embed YouTube/Vimeo en sesiones y biblioteca." },
            { id:"ia",           done:false, estado:"💡", titulo:"IA de rendimiento (Claude API)", desc:"Análisis del historial, recomendaciones de carga y predicción de fatiga." },
            { id:"comunidad",    done:false, estado:"💡", titulo:"Feed de actividad & Comunidad", desc:"Retos semanales, actividad entre atletas del equipo." },
            { id:"nativa",       done:false, estado:"💡", titulo:"App nativa iOS/Android", desc:"Versión nativa post-validación con biometría y offline avanzado." },
          ];'''
assert old9 in src, "FAIL 9"
src = src.replace(old9, new9, 1)

with open("src/App.jsx", "w", encoding="utf-8") as f:
    f.write(src)

print("ALL 9 PATCHES APPLIED OK")

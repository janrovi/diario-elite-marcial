# Despliegue Edge Function — Resend emails

## Requisitos
1. Cuenta en https://resend.com (gratis hasta 100 emails/día)
2. Supabase CLI instalado: `npm install -g supabase`
3. Dominio verificado en Resend (o usa `onboarding@resend.dev` para pruebas)

## Pasos

### 1. Obtener API key de Resend
- Entra en resend.com → API Keys → Create API Key
- Copia el key (formato: `re_xxxxxxxxx`)

### 2. Añadir el secret a Supabase
```bash
supabase secrets set RESEND_API_KEY=re_tu_api_key_aqui --project-ref jhudfgnfpgzjobskuhcr
```

### 3. (Opcional) Verificar dominio en Resend
- Resend → Domains → Add Domain → `elitemarcial.com`
- Añade los registros DNS que te indique
- Sin dominio verificado, cambia `FROM_EMAIL` en index.ts a `onboarding@resend.dev`

### 4. Desplegar la función
```bash
supabase functions deploy send-suggestion --project-ref jhudfgnfpgzjobskuhcr
```

### 5. Probar
Desde el panel Fundador → Sugerencias → envía cualquier texto.
El email llega a jan@elitemarcial.com en segundos.

## Notas
- El `FROM_EMAIL` en index.ts debe ser un dominio verificado en Resend
- Para pruebas sin dominio: cambia FROM a `onboarding@resend.dev`
- Logs: Supabase Dashboard → Edge Functions → send-suggestion → Logs

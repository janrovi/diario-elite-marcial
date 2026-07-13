---
tags: [patrones, referencia]
actualizado: 2026-07-14
---
# 🗺️ Guía de Patrones — Élite Marcial

> Referencia rápida para Claude: cómo hacer las cosas en este codebase.
> Para contexto general del proyecto → [[SESION_CONTEXTO]]
> Para decisiones de arquitectura → [[DECISIONES]]

---

## 1. Editar App.jsx

**REGLA:** NUNCA usar el Edit tool directamente sobre `src/App.jsx` (~18.500 líneas). SIEMPRE Python.

### Paso 0 — Verificar unicidad del ancla

Antes de escribir el script, confirmar que el string ancla es único:

```bash
python -c "
code = open('src/App.jsx', encoding='utf-8').read()
hits = code.count('TEXTO_QUE_VOY_A_USAR_COMO_ANCLA')
print(hits, 'ocurrencias')
"
```

Si hay más de 1 ocurrencia → buscar un contexto más amplio hasta que sea única.

### Paso 1 — Script de edición estándar

```python
# scripts/patch_nombre_feature.py
with open("src/App.jsx", "r", encoding="utf-8") as f:
    code = f.read()

BEFORE = """
TEXTO_ORIGINAL_EXACTO
"""

AFTER = """
TEXTO_NUEVO
"""

if BEFORE not in code:
    print("❌ Ancla no encontrada")
    exit(1)

hits = code.count(BEFORE)
if hits > 1:
    print(f"❌ Ancla ambigua ({hits} ocurrencias)")
    exit(1)

code = code.replace(BEFORE, AFTER)

with open("src/App.jsx", "w", encoding="utf-8") as f:
    f.write(code)

print("✅ OK")
```

Ejecutar desde el sandbox:
```bash
cd /sessions/.../mnt/diario-elite-marcial
python scripts/patch_nombre_feature.py
```

### Paso 2 — Verificar que no se rompió el JSX

```bash
node -e "require('./src/App.jsx')" 2>&1 | head -5
# Si hay errores de sintaxis, los mostrará. Si no hay output → OK (Node no entiende JSX, pero ve errores de parsing)
```

Mejor alternativa: mirar el output del navegador después del push.

### Encontrar secciones en App.jsx

Landmarks principales (buscar con `grep -n`):
```bash
grep -n "function MainApp" src/App.jsx
grep -n "function CoachApp" src/App.jsx
grep -n "function HomeView" src/App.jsx
grep -n "function AthleteCard" src/App.jsx
grep -n "const TRANSLATIONS" src/App.jsx
grep -n "const PRICES" src/App.jsx
grep -n "const DISC_GROUPS" src/App.jsx
```

### Insertar JSX antes del cierre de un componente

```python
BEFORE = """
      </div>
    </div>
  );
}
// FIN DEL COMPONENTE QUE BUSCO
"""
```

Si el componente usa Fragment (`<> ... </>`), el patrón es:
```python
BEFORE = """
    </>
  );
}
// FIN COMPONENTE"""
```

---

## 2. Añadir nueva tabla a Supabase

### SQL template completo

```sql
-- 1. Crear tabla
CREATE TABLE nombre_tabla (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  -- ... campos ...
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. RLS básico (atleta ve sus propios datos)
ALTER TABLE nombre_tabla ENABLE ROW LEVEL SECURITY;

CREATE POLICY "usuarios ven sus propios datos"
  ON nombre_tabla FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "usuarios insertan sus propios datos"
  ON nombre_tabla FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "usuarios actualizan sus propios datos"
  ON nombre_tabla FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "usuarios eliminan sus propios datos"
  ON nombre_tabla FOR DELETE
  USING (auth.uid() = user_id);

-- 3. Si el coach también debe ver los datos del atleta:
CREATE POLICY "coach ve datos de sus atletas"
  ON nombre_tabla FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM coach_atleta ca
      WHERE ca.coach_id = auth.uid()
        AND ca.atleta_id = nombre_tabla.user_id
        AND ca.estado = 'activo'
    )
  );
```

### Template query en App.jsx

```javascript
// Fetch en useEffect
const { data, error } = await supabase
  .from("nombre_tabla")
  .select("*")
  .eq("user_id", user.id)
  .order("created_at", { ascending: false });

if (error) console.error("nombre_tabla:", error.message);
else setMiEstado(data ?? []);

// Insert
const { error: insertErr } = await supabase
  .from("nombre_tabla")
  .insert({ user_id: user.id, campo: valor });
```

### Guardar el SQL en el repo

```bash
# Crear archivo en supabase/
# Commit junto con los cambios de App.jsx
```

---

## 3. Scope rules — coachProfile vs user

| Dónde estás | Qué tienes disponible |
|-------------|----------------------|
| `MainApp()` | `user`, `profile`, `coachProfile` (cuando coach) |
| `CoachApp()` | `user` (prop), `coachProfile` (prop), `profile` NO |
| `AthleteCard()` | `athlete` (datos del atleta), `coachProfile` (prop) |
| Componente standalone (ej: `ClubFundadorContent`) | Nada del closure → necesita `const lang = localStorage.getItem("em_lang") \|\| "es"` |

**Regla crítica:** En CoachApp y sus hijos, para el ID del coach usar `user?.id`, NO `coachProfile?.id` (coachProfile tiene el id del perfil, que puede diferir del auth UID en edge cases). Para RLS lo que importa es `auth.uid()` = `user.id`.

---

## 4. Sistema de traducciones — añadir nueva clave

```python
# En el script Python, hacer 3 replace: ES, EN, CA
# Buscar el ancla justo ANTES de donde quieres insertar

# ES (busca el bloque español)
code = code.replace(
  'clave_anterior:"Valor anterior en español",',
  'clave_anterior:"Valor anterior en español",\n    nueva_clave:"Valor en español",'
)

# EN
code = code.replace(
  'clave_anterior:"Previous value in English",',
  'clave_anterior:"Previous value in English",\n    nueva_clave:"Value in English",'
)

# CA
code = code.replace(
  'clave_anterior:"Valor anterior en català",',
  'clave_anterior:"Valor anterior en català",\n    nueva_clave:"Valor en català",'
)
```

Verificar que los 3 objetos de traducción tienen la clave antes de commitear.

---

## 5. Flujo de registro (signUp)

**NUNCA** hacer `profiles.insert()` después del signUp desde el cliente.

El perfil se crea automáticamente vía **trigger SQL** `on_auth_user_created`:
```sql
-- Trigger en auth.users
-- Cuando Supabase crea un usuario → inserta en public.profiles automáticamente
```

Por qué: con email confirmation activado, `data.session` es `null` después del signUp.
Si intentas hacer `.insert()` con session null → RLS rechaza → error 403.

**Flujo correcto:**
1. `supabase.auth.signUp(...)` → Supabase envía email de confirmación
2. Usuario hace clic en el link → la sesión se activa
3. El trigger ya creó el perfil en `profiles`

---

## 6. Debug patterns

### Supabase — RLS roto (datos no aparecen)

En el SQL Editor de Supabase, simular auth.uid() con el UUID del usuario:
```sql
-- Verificar si la policy permite acceso
SET request.jwt.claim.sub = 'UUID-DEL-USUARIO-AQUI';
SELECT * FROM nombre_tabla WHERE user_id = 'UUID-DEL-USUARIO-AQUI';
```

### Supabase — Error en Edge Function

Panel Supabase → Edge Functions → nombre_funcion → Logs.

### Stripe webhook — no se activa

1. Vercel → Functions → stripe-webhook → ver logs
2. Supabase → Edge Functions → stripe-webhook → Logs
3. Stripe Dashboard → Developers → Webhooks → ver intentos fallidos

### DevTools — error de auth

Red → buscar la petición que falla (recovery, token, etc.) → Response body → el error de Supabase está ahí en texto claro.

---

## 7. Git / PowerShell — recordatorios

```powershell
# PowerShell NO soporta && — siempre comandos en líneas separadas

# Si da error de HEAD.lock:
Remove-Item "C:\Users\janro\diario-elite-marcial\.git\HEAD.lock" -Force -ErrorAction SilentlyContinue

# Commit normal:
cd C:\Users\janro\diario-elite-marcial
git add -A
git commit -m "feat: descripción clara del cambio"
git push
```

Vercel despliega en ~60-90 segundos tras el push.

---

## 8. Patrones JSX en App.jsx

### Renderizado condicional seguro

```jsx
// Siempre con fallback null, nunca solo &&  con numbers
{condicion && <Componente />}          // ⚠️ si condicion=0 renderiza "0"
{condicion ? <Componente /> : null}    // ✅ seguro
{!!condicion && <Componente />}        // ✅ también ok
```

### Añadir tab nuevo a una vista con tabs

```javascript
// 1. Localizar el array de tabs (suele ser un const o inline)
const TABS = ["Resumen", "Sesiones", "Evolución"];

// 2. Añadir al array
const TABS = ["Resumen", "Sesiones", "Evolución", "Nuevo Tab"];

// 3. Añadir el bloque de contenido:
{activeTab === "Nuevo Tab" && (
  <div>
    {/* contenido nuevo */}
  </div>
)}
```

### Estado local en componente que ya existe

```javascript
// Buscar el bloque de useState del componente y añadir después del último:
const [miNuevoEstado, setMiNuevoEstado] = useState(null);
```

---

## 9. Checklist antes de commitear

- [ ] `node -e "..."` o abrir en navegador dev → sin errores de consola
- [ ] El str.replace tuvo exactamente 1 ocurrencia del ancla
- [ ] SQL guardado en `supabase/` si hay cambios de BD
- [ ] Traducciones añadidas en ES + EN + CA
- [ ] `git add -A` captura todos los archivos modificados

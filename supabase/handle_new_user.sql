-- Trigger: crear perfil automáticamente al registrar un usuario
-- Esto soluciona el bug de registro: cuando email confirmation está activada,
-- no hay sesión tras el signUp, por lo que el upsert del cliente falla por RLS.
-- El trigger se ejecuta server-side (SECURITY DEFINER) y no necesita sesión.
--
-- Ejecutar en Supabase SQL Editor

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, email, nombre, rol, plan)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(
      NEW.raw_user_meta_data->>'nombre',
      split_part(NEW.email, '@', 1)   -- fallback: parte local del email
    ),
    COALESCE(NEW.raw_user_meta_data->>'rol',  'atleta'),
    COALESCE(NEW.raw_user_meta_data->>'plan', 'free')
  )
  ON CONFLICT (id) DO NOTHING;  -- no sobreescribir si ya existe
  RETURN NEW;
END;
$$;

-- Recrear trigger (DROP IF EXISTS para idempotencia)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

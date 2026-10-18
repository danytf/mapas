-- H-12: historial del estado compartido de establecimientos.
--
-- establishment_app_state.state es un JSONB que el cliente reescribe completo en cada guardado.
-- Cuando dos usuarios de la misma provincia guardan sobre la misma fila, el último sobrescribe al
-- primero (H-11) y el audit_log solo conserva los nombres de los campos cambiados, no su contenido,
-- por lo que lo sobrescrito era irrecuperable.
--
-- Este cambio es aditivo: no modifica la tabla de estado, sus políticas ni el comportamiento de la
-- aplicación. Antes de cada UPDATE (con estado distinto) o DELETE guarda el estado anterior.
-- Se guarda solo el estado previo: el vigente está en la tabla y el siguiente histórico lo
-- contendrá como previo, así que la cadena completa se reconstruye sin duplicar tamaño.
--
-- Acceso: solo lectura para administradores. Nadie puede insertar, modificar ni borrar desde la
-- API; solo escribe el trigger (SECURITY DEFINER). Sin clave foránea a propósito: el historial
-- debe sobrevivir al borrado del establecimiento. No cubre user_app_state (estado personal con un
-- único escritor, sin conflicto entre usuarios).

CREATE TABLE public.establishment_app_state_history (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  establishment_id uuid NOT NULL,
  province_id uuid NOT NULL,
  operation text NOT NULL CHECK (operation IN ('UPDATE', 'DELETE')),
  old_state jsonb NOT NULL,
  old_updated_at timestamptz,
  old_updated_by uuid,
  changed_by uuid,
  changed_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX establishment_app_state_history_est_changed_idx
  ON public.establishment_app_state_history (establishment_id, changed_at DESC);

ALTER TABLE public.establishment_app_state_history ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public.establishment_app_state_history FROM PUBLIC, anon, authenticated;
GRANT SELECT ON public.establishment_app_state_history TO authenticated;

CREATE POLICY establishment_app_state_history_admin_read
  ON public.establishment_app_state_history
  FOR SELECT TO authenticated
  USING (public.is_admin());

CREATE FUNCTION public.record_establishment_app_state_history()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
BEGIN
  IF TG_OP = 'UPDATE' AND OLD.state IS NOT DISTINCT FROM NEW.state THEN
    RETURN NULL;
  END IF;

  INSERT INTO public.establishment_app_state_history
    (establishment_id, province_id, operation, old_state, old_updated_at, old_updated_by, changed_by)
  VALUES
    (OLD.establishment_id, OLD.province_id, TG_OP, OLD.state, OLD.updated_at, OLD.updated_by, (SELECT auth.uid()));

  RETURN NULL;
END;
$function$;

REVOKE ALL ON FUNCTION public.record_establishment_app_state_history() FROM PUBLIC, anon, authenticated;

CREATE TRIGGER record_establishment_app_state_history
  AFTER UPDATE OR DELETE ON public.establishment_app_state
  FOR EACH ROW EXECUTE FUNCTION public.record_establishment_app_state_history();

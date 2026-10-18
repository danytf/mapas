-- H-11: control de conflicto en el estado compartido de establecimientos.
--
-- establishment_app_state.state se reescribe completo en cada guardado. Sin control, cuando dos
-- usuarios de la misma provincia editan el mismo punto, el último en guardar pisa al anterior.
--
-- Se añade un contador de versión que mantiene la base de datos: 1 al crear la fila y +1 en cada
-- UPDATE. El cliente no puede fijarlo (el trigger sobrescribe cualquier valor enviado). La
-- aplicación guarda con «UPDATE ... WHERE version = <leída>» o con INSERT si no había fila; si no
-- se actualiza ninguna fila o el INSERT choca con la clave primaria, hay conflicto y no se pisa
-- nada.
--
-- Compatible con clientes anteriores: un upsert sin versión sigue funcionando y también incrementa
-- el contador, de modo que el cliente nuevo detecta esa escritura como conflicto.
-- Las filas existentes empiezan en 1. No cambia políticas, permisos ni el historial (H-12).

ALTER TABLE public.establishment_app_state
  ADD COLUMN version bigint NOT NULL DEFAULT 1;

ALTER TABLE public.establishment_app_state
  ADD CONSTRAINT establishment_app_state_version_positive CHECK (version >= 1);

CREATE FUNCTION public.set_establishment_app_state_version()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO ''
AS $function$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.version := 1;
  ELSE
    NEW.version := OLD.version + 1;
  END IF;
  RETURN NEW;
END;
$function$;

REVOKE ALL ON FUNCTION public.set_establishment_app_state_version() FROM PUBLIC, anon, authenticated;

CREATE TRIGGER set_establishment_app_state_version
  BEFORE INSERT OR UPDATE ON public.establishment_app_state
  FOR EACH ROW EXECUTE FUNCTION public.set_establishment_app_state_version();

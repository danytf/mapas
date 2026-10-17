-- Keep shared operational state bound to the master establishment and its actual province.
CREATE OR REPLACE FUNCTION public.guard_establishment_app_state()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO ''
AS $function$
DECLARE
  master_province_id uuid;
BEGIN
  SELECT e.province_id
    INTO master_province_id
    FROM public.establishments AS e
   WHERE e.id = NEW.establishment_id;

  IF master_province_id IS NULL THEN
    RAISE EXCEPTION 'No existe el establecimiento maestro del estado operativo'
      USING ERRCODE = '23503';
  END IF;

  IF NEW.province_id IS DISTINCT FROM master_province_id THEN
    RAISE EXCEPTION 'La provincia del estado operativo debe coincidir con la del establecimiento maestro'
      USING ERRCODE = '23514';
  END IF;

  IF TG_OP = 'UPDATE' THEN
    IF NEW.establishment_id IS DISTINCT FROM OLD.establishment_id
       OR NEW.province_id IS DISTINCT FROM OLD.province_id THEN
      RAISE EXCEPTION 'No se puede reasignar el estado operativo a otro establecimiento o provincia'
        USING ERRCODE = '42501';
    END IF;
    IF NEW.created_at IS DISTINCT FROM OLD.created_at THEN
      RAISE EXCEPTION 'No se puede modificar la fecha de creación del estado operativo'
        USING ERRCODE = '42501';
    END IF;
  END IF;

  IF (SELECT auth.uid()) IS NOT NULL THEN
    NEW.updated_by := (SELECT auth.uid());
  END IF;

  RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS guard_establishment_app_state ON public.establishment_app_state;
CREATE TRIGGER guard_establishment_app_state
BEFORE INSERT OR UPDATE ON public.establishment_app_state
FOR EACH ROW
EXECUTE FUNCTION public.guard_establishment_app_state();

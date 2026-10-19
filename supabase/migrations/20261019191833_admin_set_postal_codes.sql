-- Carga masiva de códigos postales para administradores: public.admin_set_postal_codes(p_items jsonb, p_only_empty boolean).
-- SECURITY INVOKER: se ejecuta con los permisos de quien llama, de modo que siguen mandando las políticas de fila y guard_sensitive_updates
-- (que ya exige un administrador identificado con JWT para tocar postal_code). No concede nada nuevo: solo evita repetir el cambio punto a punto.
-- Cada elemento es {"id": "<uuid>", "postal_code": "NNNNN"}. Solo se escribe si el código tiene 5 cifras y sus dos primeras coinciden con el código
-- de la provincia del punto; por defecto solo rellena los puntos sin código postal (p_only_empty = true). Devuelve {"actualizados": n, "omitidos": [...]}.
-- La versión de este fichero debe renombrarse a la que registre Supabase al aplicarla (list_migrations).

BEGIN;

CREATE OR REPLACE FUNCTION public.admin_set_postal_codes(p_items jsonb, p_only_empty boolean DEFAULT true)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  it jsonb;
  v_id uuid;
  v_cp text;
  v_rows integer;
  v_ok integer := 0;
  v_skip jsonb := '[]'::jsonb;
BEGIN
  IF NOT (SELECT public.is_admin()) THEN
    RAISE EXCEPTION 'No autorizado' USING ERRCODE = '42501';
  END IF;
  IF p_items IS NULL OR jsonb_typeof(p_items) <> 'array' THEN
    RAISE EXCEPTION 'Se esperaba un array JSON de {id, postal_code}' USING ERRCODE = '22023';
  END IF;
  IF jsonb_array_length(p_items) > 2000 THEN
    RAISE EXCEPTION 'Máximo 2000 elementos por llamada' USING ERRCODE = '22023';
  END IF;

  FOR it IN SELECT * FROM jsonb_array_elements(p_items) LOOP
    v_cp := it ->> 'postal_code';
    BEGIN
      v_id := (it ->> 'id')::uuid;
    EXCEPTION WHEN others THEN
      v_skip := v_skip || jsonb_build_object('item', it, 'motivo', 'id no válido');
      CONTINUE;
    END;
    IF v_cp IS NULL OR v_cp !~ '^[0-9]{5}$' THEN
      v_skip := v_skip || jsonb_build_object('id', v_id, 'motivo', 'código postal no válido');
      CONTINUE;
    END IF;

    UPDATE public.establishments e
    SET postal_code = v_cp
    FROM public.provinces p
    WHERE e.id = v_id
      AND p.id = e.province_id
      AND left(v_cp, 2) = p.code
      AND (NOT p_only_empty OR COALESCE(e.postal_code, '') = '');
    GET DIAGNOSTICS v_rows = ROW_COUNT;

    IF v_rows = 1 THEN
      v_ok := v_ok + 1;
    ELSE
      v_skip := v_skip || jsonb_build_object('id', v_id, 'postal_code', v_cp, 'motivo', 'no existe, ya tiene código postal o no coincide con su provincia');
    END IF;
  END LOOP;

  RETURN jsonb_build_object('actualizados', v_ok, 'omitidos', v_skip);
END;
$$;

REVOKE ALL ON FUNCTION public.admin_set_postal_codes(jsonb, boolean) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.admin_set_postal_codes(jsonb, boolean) TO authenticated;

COMMIT;

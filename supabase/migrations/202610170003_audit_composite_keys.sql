-- Improve audit traceability for rows with composite primary keys.
-- user_provinces uses (user_id, province_id), not a single id column.
-- Keep audit_log.record_id unchanged and include the composite key in details.

BEGIN;

CREATE OR REPLACE FUNCTION public.write_audit_log()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  old_data jsonb := '{}'::jsonb;
  new_data jsonb := '{}'::jsonb;
  row_data jsonb;
  field_name text;
  changed_fields jsonb := '[]'::jsonb;
  entity_id uuid;
  entity_establishment_id uuid;
  entity_province_id uuid;
  audit_details jsonb;
  audit_action text := lower(tg_op);
BEGIN
  IF tg_op <> 'INSERT' THEN
    old_data := to_jsonb(old);
  END IF;
  IF tg_op <> 'DELETE' THEN
    new_data := to_jsonb(new);
  END IF;
  row_data := CASE WHEN tg_op = 'DELETE' THEN old_data ELSE new_data END;

  entity_id := nullif(row_data ->> 'id', '')::uuid;
  entity_establishment_id := nullif(row_data ->> 'establishment_id', '')::uuid;
  entity_province_id := nullif(row_data ->> 'province_id', '')::uuid;

  IF entity_province_id IS NULL AND entity_establishment_id IS NOT NULL THEN
    SELECT e.province_id INTO entity_province_id
    FROM public.establishments e
    WHERE e.id = entity_establishment_id;
  END IF;

  IF tg_op = 'INSERT' THEN
    SELECT coalesce(jsonb_agg(k), '[]'::jsonb) INTO changed_fields
    FROM jsonb_object_keys(new_data) AS keys(k)
    WHERE k NOT IN ('created_at', 'updated_at');
  ELSIF tg_op = 'DELETE' THEN
    SELECT coalesce(jsonb_agg(k), '[]'::jsonb) INTO changed_fields
    FROM jsonb_object_keys(old_data) AS keys(k)
    WHERE k NOT IN ('created_at', 'updated_at');
  ELSE
    FOR field_name IN SELECT jsonb_object_keys(new_data)
    LOOP
      IF field_name NOT IN ('updated_at')
         AND old_data -> field_name IS DISTINCT FROM new_data -> field_name THEN
        changed_fields := changed_fields || jsonb_build_array(field_name);
      END IF;
    END LOOP;
  END IF;

  audit_details := jsonb_build_object('changed_fields', changed_fields);

  IF tg_table_name = 'user_provinces' THEN
    IF tg_op = 'UPDATE' THEN
      audit_details := audit_details || jsonb_build_object(
        'record_key_old',
        jsonb_build_object(
          'user_id', old_data ->> 'user_id',
          'province_id', old_data ->> 'province_id'
        ),
        'record_key_new',
        jsonb_build_object(
          'user_id', new_data ->> 'user_id',
          'province_id', new_data ->> 'province_id'
        )
      );
    ELSE
      audit_details := audit_details || jsonb_build_object(
        'record_key',
        jsonb_build_object(
          'user_id', row_data ->> 'user_id',
          'province_id', row_data ->> 'province_id'
        )
      );
    END IF;
  END IF;

  INSERT INTO public.audit_log
    (actor_id, action, table_name, record_id, province_id, details)
  VALUES (
    (SELECT auth.uid()),
    audit_action,
    tg_table_name,
    entity_id,
    entity_province_id,
    audit_details
  );

  IF tg_op = 'DELETE' THEN
    RETURN old;
  END IF;
  RETURN new;
END;
$$;

REVOKE ALL ON FUNCTION public.write_audit_log() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.write_audit_log() FROM authenticated;

COMMIT;

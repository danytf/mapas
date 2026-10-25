-- Municipios oficiales (código INE) de las provincias 51. Origen: OpenStreetMap (áreas administrativas de nivel 8 con ine:municipio), ODbL.
-- Inserta los que faltan y asigna el código INE a los existentes que no lo tienen. No cambia nombres ni borra nada.
-- 1 municipios. Transaccional e idempotente.

BEGIN;

CREATE TEMP TABLE _municipios (prov text, ine text, name text, norm text) ON COMMIT DROP;
INSERT INTO _municipios VALUES
  ('51', '51001', 'Ceuta', 'ceuta');

DO $$
DECLARE faltan text;
BEGIN
  SELECT string_agg(DISTINCT m.prov, ', ') INTO faltan FROM _municipios m
  WHERE NOT EXISTS (SELECT 1 FROM public.provinces p WHERE p.code = m.prov);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan provincias: %', faltan;
  END IF;
END;
$$;

INSERT INTO public.municipalities (province_id, name, normalized_name, official_code)
SELECT p.id, m.name, m.norm, m.ine
FROM _municipios m JOIN public.provinces p ON p.code = m.prov
ON CONFLICT (province_id, normalized_name) DO UPDATE
  SET official_code = EXCLUDED.official_code
  WHERE public.municipalities.official_code IS NULL;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.municipalities mu
  JOIN _municipios m ON mu.official_code = m.ine;
  IF n < 1 THEN
    RAISE EXCEPTION 'Se esperaban al menos 1 municipios con código INE, hay %', n;
  END IF;
END;
$$;

COMMIT;

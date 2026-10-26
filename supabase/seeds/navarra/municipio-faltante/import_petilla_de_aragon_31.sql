-- Municipio que faltaba en la carga de Navarra (provincia 31): Petilla de Aragón (INE 31203), enclave navarro dentro de Zaragoza, y su punto descartado.
-- Origen: OpenStreetMap (ODbL), extracto de Aragón, base 2026-10-25T21:21:21Z. Relación 344399 (nivel 8, ine:municipio=31203, wikidata Q984872).
-- No estaba en el extracto de Navarra y su Ayuntamiento (node/3878143316) se descartó en el lote de Aragón por ser de la provincia 31 (ver docs/CARGA_N2_NAVARRA.md).
-- Sin código postal: OpenStreetMap trae 50686, que es de Zaragoza y no se carga.
-- Transaccional e idempotente: si el municipio o el source_ref ya existen, no cambia nada. Aborta si falta la provincia o la categoría.

BEGIN;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.provinces WHERE code = '31') THEN
    RAISE EXCEPTION 'Falta la provincia 31.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE name = 'Entidad oficial') THEN
    RAISE EXCEPTION 'Falta la categoría Entidad oficial.';
  END IF;
END;
$$;

INSERT INTO public.municipalities (province_id, name, normalized_name, official_code)
SELECT p.id, 'Petilla de Aragón', 'petilla-de-aragon', '31203'
FROM public.provinces p WHERE p.code = '31'
ON CONFLICT (province_id, normalized_name) DO UPDATE
  SET official_code = EXCLUDED.official_code
  WHERE public.municipalities.official_code IS NULL;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Entidad oficial', 'catalogo-navarra:navarra-resto:node-3878143316', 'Ayuntamiento de Petilla de Aragón – Plaza de Navarra', NULL, '31203', 'Plaza de Navarra', NULL, 42.461534, -1.092616, 'address', 'openstreetmap:node/3878143316');

INSERT INTO public.establishments (
  province_id, municipality_id, category_id,
  name, normalized_name, subtype, address, postal_code,
  latitude, longitude, location_precision, location_source,
  source_ref, status
)
SELECT p.id, m.id, cat.id,
       c.name, lower(trim(c.name)), c.subtype, c.address, c.postal_code,
       c.latitude, c.longitude, c.location_precision, c.location_source,
       c.source_ref, 'active'
FROM _carga c
JOIN public.municipalities m ON m.official_code = c.muni_ine
JOIN public.provinces p ON p.id = m.province_id AND p.code = '31'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
  WHERE p.code = '31' AND m.official_code = '31203';
  IF n <> 1 THEN
    RAISE EXCEPTION 'Se esperaba 1 municipio 31203 en Navarra, hay %', n;
  END IF;
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 1 THEN
    RAISE EXCEPTION 'Se esperaba 1 punto de Petilla de Aragón, hay %', n;
  END IF;
END;
$$;

COMMIT;

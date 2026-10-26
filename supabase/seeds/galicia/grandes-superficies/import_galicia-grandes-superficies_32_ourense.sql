-- Carga de la categoría (varias) de Ourense (provincia 32), trozo de la carga de Andalucía.
-- Origen: galicia-grandes-superficies-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 4 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:node-4506485194', 'Decathlon Ourense – Rúa do Paseo', NULL, '32054', 'Rúa do Paseo 6', '32003', 42.33856, -7.86469, 'address', 'openstreetmap:node/4506485194'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-6564770890', 'Carrefour Ribadavia – Avenida de Redondela', NULL, '32069', 'Avenida de Redondela', NULL, 42.28449, -8.14678, 'address', 'openstreetmap:node/6564770890'),
  ('Leroy Merlin', 'catalogo-galicia:galicia-grandes-superficies:way-1104531268', 'Leroy Merlin Ourense', NULL, '32054', NULL, NULL, 42.35425, -7.90669, 'address', 'openstreetmap:way/1104531268'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-173778057', 'Carrefour Barbadás – Rúa da Aira', NULL, '32008', 'Rúa da Aira', NULL, 42.32159, -7.87587, 'address', 'openstreetmap:way/173778057');

DO $$
DECLARE faltan text;
BEGIN
  SELECT string_agg(DISTINCT c.categoria, ', ') INTO faltan FROM _carga c WHERE NOT EXISTS (SELECT 1 FROM public.categories k WHERE k.name = c.categoria);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan categorías: %', faltan;
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '32');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 32 con estos códigos INE: %', faltan;
  END IF;
END;
$$;

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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '32'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 4 THEN
    RAISE EXCEPTION 'Se esperaban 4 puntos de (varias) en Ourense, hay %', n;
  END IF;
END;
$$;

COMMIT;

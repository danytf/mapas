-- Carga de la categoría (varias) de Huelva (provincia 21), trozo de la carga de Andalucía.
-- Origen: grandes-superficies-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 4 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-1352649498', 'Decathlon Lepe – Calle Pablo VI', NULL, '21044', 'Calle Pablo VI', NULL, 37.25251, -7.19614, 'address', 'openstreetmap:way/1352649498'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-1352649533', 'Leroy Merlin Lepe', NULL, '21044', NULL, NULL, 37.25216, -7.19575, 'address', 'openstreetmap:way/1352649533'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-522598129', 'Leroy Merlin Huelva – Calle Miguel Ferrer', NULL, '21041', 'Calle Miguel Ferrer', NULL, 37.27022, -6.9185, 'address', 'openstreetmap:way/522598129'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-64868165', 'Decathlon Huelva', NULL, '21041', NULL, '21007', 37.30925, -6.88286, 'address', 'openstreetmap:way/64868165');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '21');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 21 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '21'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 4 THEN
    RAISE EXCEPTION 'Se esperaban 4 puntos de (varias) en Huelva, hay %', n;
  END IF;
END;
$$;

COMMIT;

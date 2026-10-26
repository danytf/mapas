-- Carga de la categoría (varias) de Lugo (provincia 27), trozo de la carga de Andalucía.
-- Origen: galicia-grandes-superficies-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 6 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Leroy Merlin', 'catalogo-galicia:galicia-grandes-superficies:node-1230643390', 'Leroy Merlin Lugo', NULL, '27028', NULL, NULL, 43.03815, -7.56993, 'address', 'openstreetmap:node/1230643390'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-12320761304', 'Carrefour Lugo – Paseo Palestina', NULL, '27028', 'Paseo Palestina', NULL, 43.00572, -7.57405, 'address', 'openstreetmap:node/12320761304'),
  ('MediaMarkt', 'catalogo-galicia:galicia-grandes-superficies:node-3042389963', 'MediaMarkt Lugo', NULL, '27028', NULL, '27003', 43.03754, -7.56867, 'address', 'openstreetmap:node/3042389963'),
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:way-173074369', 'Decathlon Ribadeo – Rúa Segundo Moreno Barcia', NULL, '27051', 'Rúa Segundo Moreno Barcia', '27700', 43.53981, -7.05808, 'address', 'openstreetmap:way/173074369'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-258669460', 'Carrefour Sarria – Rúa Benigno Quiroga', NULL, '27057', 'Rúa Benigno Quiroga 92', '27600', 42.77256, -7.41481, 'address', 'openstreetmap:way/258669460'),
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:way-387259179', 'Decathlon Lugo – Rúa Aller Ulloa Ramón María', NULL, '27028', 'Rúa Aller Ulloa Ramón María', '27003', 43.0371, -7.55297, 'address', 'openstreetmap:way/387259179');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '27');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 27 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '27'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 6 THEN
    RAISE EXCEPTION 'Se esperaban 6 puntos de (varias) en Lugo, hay %', n;
  END IF;
END;
$$;

COMMIT;

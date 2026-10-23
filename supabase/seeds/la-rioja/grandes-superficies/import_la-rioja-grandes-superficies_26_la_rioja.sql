-- Carga de la categoría (varias) de La Rioja (provincia 26), trozo de la carga de Andalucía.
-- Origen: la-rioja-grandes-superficies-la-rioja.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:39:03Z).
-- 14 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-la-rioja:la-rioja-grandes-superficies:node-11690372412', 'Carrefour Albelda de Iregua – Avenida la Rioja', NULL, '26005', 'Avenida la Rioja', '26120', 42.35912, -2.47372, 'address', 'openstreetmap:node/11690372412'),
  ('Carrefour', 'catalogo-la-rioja:la-rioja-grandes-superficies:node-13316222443', 'Carrefour Navarrete – Calle del Coso', NULL, '26105', 'Calle del Coso', '26370', 42.42892, -2.56243, 'address', 'openstreetmap:node/13316222443'),
  ('Carrefour', 'catalogo-la-rioja:la-rioja-grandes-superficies:node-1340275487', 'Carrefour Logroño – Avenida de La Rioja', NULL, '26089', 'Avenida de La Rioja 14', '26001', 42.46389, -2.4471, 'address', 'openstreetmap:node/1340275487'),
  ('Carrefour', 'catalogo-la-rioja:la-rioja-grandes-superficies:node-3848663126', 'Carrefour Arnedo – Calle de la República del Tchad', NULL, '26018', 'Calle de la República del Tchad', NULL, 42.22411, -2.10653, 'address', 'openstreetmap:node/3848663126'),
  ('Carrefour', 'catalogo-la-rioja:la-rioja-grandes-superficies:node-5043427794', 'Carrefour Logroño – Calle Madre de Dios', NULL, '26089', 'Calle Madre de Dios', NULL, 42.46366, -2.41989, 'address', 'openstreetmap:node/5043427794'),
  ('Carrefour', 'catalogo-la-rioja:la-rioja-grandes-superficies:node-5254400332', 'Carrefour Logroño – Calle Beatos Mena y Navarrete', NULL, '26089', 'Calle Beatos Mena y Navarrete 52', '26004', 42.46774, -2.43061, 'address', 'openstreetmap:node/5254400332'),
  ('Carrefour', 'catalogo-la-rioja:la-rioja-grandes-superficies:node-5254400333', 'Carrefour Logroño – Calle Oeste', NULL, '26089', 'Calle Oeste 13', '26005', 42.47028, -2.46236, 'address', 'openstreetmap:node/5254400333'),
  ('Carrefour', 'catalogo-la-rioja:la-rioja-grandes-superficies:node-5657235781', 'Carrefour Logroño – Calle Piqueras', NULL, '26089', 'Calle Piqueras', '26006', 42.45437, -2.42761, 'address', 'openstreetmap:node/5657235781'),
  ('Carrefour', 'catalogo-la-rioja:la-rioja-grandes-superficies:node-7864832556', 'Carrefour Logroño – Calle Juan Boscán', NULL, '26089', 'Calle Juan Boscán', '26006', 42.45624, -2.43781, 'address', 'openstreetmap:node/7864832556'),
  ('El Corte Inglés', 'catalogo-la-rioja:la-rioja-grandes-superficies:node-7868629278', 'El Corte Inglés Logroño – Calle Lérida', NULL, '26089', 'Calle Lérida 1', '26006', 42.4626, -2.42156, 'address', 'openstreetmap:node/7868629278'),
  ('Carrefour', 'catalogo-la-rioja:la-rioja-grandes-superficies:way-1352937084', 'Carrefour Villamediana de Iregua – Calle Gloria Fuertes', NULL, '26168', 'Calle Gloria Fuertes', '26142', 42.44739, -2.41845, 'address', 'openstreetmap:way/1352937084'),
  ('MediaMarkt', 'catalogo-la-rioja:la-rioja-grandes-superficies:way-258159179', 'MediaMarkt Logroño – Calle Lérida', NULL, '26089', 'Calle Lérida 4', '26006', 42.46202, -2.42137, 'address', 'openstreetmap:way/258159179'),
  ('Leroy Merlin', 'catalogo-la-rioja:la-rioja-grandes-superficies:way-517960290', 'Leroy Merlin Logroño', NULL, '26089', NULL, '26005', 42.45173, -2.47279, 'address', 'openstreetmap:way/517960290'),
  ('Decathlon', 'catalogo-la-rioja:la-rioja-grandes-superficies:way-95465448', 'Decathlon Logroño – Calle de Prado Viejo', NULL, '26089', 'Calle de Prado Viejo 68', '26005', 42.45312, -2.47318, 'address', 'openstreetmap:way/95465448');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '26');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 26 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '26'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 14 THEN
    RAISE EXCEPTION 'Se esperaban 14 puntos de (varias) en La Rioja, hay %', n;
  END IF;
END;
$$;

COMMIT;

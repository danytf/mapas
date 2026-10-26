-- Carga de la categoría (varias) de Murcia (provincia 30), trozo de la carga de Andalucía.
-- Origen: murcia-tiendas-murcia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-20T20:23:47Z).
-- 9 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-murcia:murcia-tiendas:node-10660894065', 'Kiwoko San Pedro del Pinatar', 'Mascotas', '30036', NULL, NULL, 37.82258, -0.80954, 'address', 'openstreetmap:node/10660894065'),
  ('Tiendas', 'catalogo-murcia:murcia-tiendas:node-11371406080', 'Kiwoko Lorca – Vereda de Enmedio', 'Mascotas', '30024', 'Vereda de Enmedio', '30813', 37.63556, -1.70029, 'address', 'openstreetmap:node/11371406080'),
  ('Tiendas', 'catalogo-murcia:murcia-tiendas:node-12422359091', 'Kiwoko Mazarrón', 'Mascotas', '30026', NULL, NULL, 37.57303, -1.27046, 'address', 'openstreetmap:node/12422359091'),
  ('Tiendas', 'catalogo-murcia:murcia-tiendas:node-13398245595', 'Tiendanimal Águilas – Calle Marisa La Comadrona', 'Mascotas', '30003', 'Calle Marisa La Comadrona', '30880', 37.41066, -1.56668, 'address', 'openstreetmap:node/13398245595'),
  ('Tiendas', 'catalogo-murcia:murcia-tiendas:node-13540512484', 'Tiendanimal Murcia – Camino de la Paloma', 'Mascotas', '30030', 'Camino de la Paloma', NULL, 37.93649, -1.15115, 'address', 'openstreetmap:node/13540512484'),
  ('Tiendas', 'catalogo-murcia:murcia-tiendas:node-13948435096', 'Kiwoko Murcia – Calle Molina de Segura', 'Mascotas', '30030', 'Calle Molina de Segura 10', '30007', 37.99189, -1.11327, 'address', 'openstreetmap:node/13948435096'),
  ('Tiendas', 'catalogo-murcia:murcia-tiendas:node-13954378522', 'Kiwoko Murcia', 'Mascotas', '30030', NULL, NULL, 38.03244, -1.14881, 'address', 'openstreetmap:node/13954378522'),
  ('Tiendas', 'catalogo-murcia:murcia-tiendas:node-1544085544', 'Mundo Animal Murcia – Calle San Roque', 'Mascotas', '30030', 'Calle San Roque', NULL, 37.93818, -1.16162, 'address', 'openstreetmap:node/1544085544'),
  ('Tiendas', 'catalogo-murcia:murcia-tiendas:way-1491513541', 'Guaw Cieza', 'Mascotas', '30019', NULL, NULL, 38.24388, -1.40857, 'address', 'openstreetmap:way/1491513541');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '30');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 30 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '30'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 9 THEN
    RAISE EXCEPTION 'Se esperaban 9 puntos de (varias) en Murcia, hay %', n;
  END IF;
END;
$$;

COMMIT;

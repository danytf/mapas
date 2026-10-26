-- Carga de la categoría (varias) de Zaragoza (provincia 50), trozo de la carga de Andalucía.
-- Origen: aragon-grandes-superficies-aragon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 16 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-12485150748', 'Carrefour Zaragoza – Avenida de Cataluña', NULL, '50297', 'Avenida de Cataluña', '50015', 41.66035, -0.86869, 'address', 'openstreetmap:node/12485150748'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-1267576457', 'Carrefour Zaragoza – Calle de María Zambrano', NULL, '50297', 'Calle de María Zambrano', '50018', 41.6757, -0.89003, 'address', 'openstreetmap:node/1267576457'),
  ('Leroy Merlin', 'catalogo-aragon:aragon-grandes-superficies:node-1273675307', 'Leroy Merlin Zaragoza – Avenida Isla de Murano', NULL, '50297', 'Avenida Isla de Murano', NULL, 41.61053, -0.89067, 'address', 'openstreetmap:node/1273675307'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-13076290020', 'Carrefour Ariza – Autovía del Nordeste Km. 197.2', NULL, '50034', 'Autovía del Nordeste Km. 197.2', '50220', 41.31155, -2.00259, 'address', 'openstreetmap:node/13076290020'),
  ('Decathlon', 'catalogo-aragon:aragon-grandes-superficies:node-13451281470', 'Decathlon Zaragoza – Calle Poetisa María Zambrano', NULL, '50297', 'Calle Poetisa María Zambrano 35', '50018', 41.66935, -0.8895, 'address', 'openstreetmap:node/13451281470'),
  ('MediaMarkt', 'catalogo-aragon:aragon-grandes-superficies:node-1486463919', 'MediaMarkt Zaragoza – Calle Teatro Malibrán', NULL, '50297', 'Calle Teatro Malibrán', NULL, 41.60925, -0.89109, 'address', 'openstreetmap:node/1486463919'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-473831541', 'Carrefour Zaragoza – Carretera de Logroño', NULL, '50297', 'Carretera de Logroño', NULL, 41.65952, -0.92246, 'address', 'openstreetmap:node/473831541'),
  ('Decathlon', 'catalogo-aragon:aragon-grandes-superficies:node-5630832343', 'Decathlon Zaragoza – Paseo de Sagasta', NULL, '50297', 'Paseo de Sagasta 10', '50008', 41.646, -0.88591, 'address', 'openstreetmap:node/5630832343'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:way-1263834924', 'Carrefour Calatayud', NULL, '50067', NULL, NULL, 41.35565, -1.62039, 'address', 'openstreetmap:way/1263834924'),
  ('IKEA', 'catalogo-aragon:aragon-grandes-superficies:way-135269145', 'IKEA Zaragoza – Calle Fernando Martínez Marqués', NULL, '50297', 'Calle Fernando Martínez Marqués', NULL, 41.60699, -0.89156, 'address', 'openstreetmap:way/135269145'),
  ('Decathlon', 'catalogo-aragon:aragon-grandes-superficies:way-182857477', 'Decathlon Zaragoza – Calle Mercader de Venecia', NULL, '50297', 'Calle Mercader de Venecia', NULL, 41.60766, -0.88473, 'address', 'openstreetmap:way/182857477'),
  ('El Corte Inglés', 'catalogo-aragon:aragon-grandes-superficies:way-184156001', 'El Corte Inglés Zaragoza – Avenida Isla de Murano', NULL, '50297', 'Avenida Isla de Murano', '50021', 41.6093, -0.88765, 'address', 'openstreetmap:way/184156001'),
  ('El Corte Inglés', 'catalogo-aragon:aragon-grandes-superficies:way-184188457', 'El Corte Inglés Zaragoza – Calle de San Miguel', NULL, '50297', 'Calle de San Miguel 2', '50001', 41.6509, -0.88156, 'address', 'openstreetmap:way/184188457'),
  ('Leroy Merlin', 'catalogo-aragon:aragon-grandes-superficies:way-462636861', 'Leroy Merlin Utebo', NULL, '50272', NULL, NULL, 41.70227, -1.00528, 'address', 'openstreetmap:way/462636861'),
  ('El Corte Inglés', 'catalogo-aragon:aragon-grandes-superficies:way-743749099', 'El Corte Inglés Zaragoza – Paseo de Sagasta', NULL, '50297', 'Paseo de Sagasta 3', '50008', 41.64531, -0.885, 'address', 'openstreetmap:way/743749099'),
  ('Decathlon', 'catalogo-aragon:aragon-grandes-superficies:way-815860875', 'Decathlon Zaragoza – Camino de la casilla del ferrocarril', NULL, '50297', 'Camino de la casilla del ferrocarril', NULL, 41.67663, -0.95086, 'address', 'openstreetmap:way/815860875');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '50');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 50 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '50'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 16 THEN
    RAISE EXCEPTION 'Se esperaban 16 puntos de (varias) en Zaragoza, hay %', n;
  END IF;
END;
$$;

COMMIT;

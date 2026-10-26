-- Carga de la categoría (varias) de Toledo (provincia 45), trozo de la carga de Andalucía.
-- Origen: castilla-la-mancha-grandes-superficies-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 13 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-12602156323', 'Carrefour Otero', NULL, '45126', NULL, NULL, 40.02241, -4.48688, 'address', 'openstreetmap:node/12602156323'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-13468129151', 'Carrefour Santa Olalla – Plaza Reyes de España', NULL, '45158', 'Plaza Reyes de España 1', '45530', 40.02421, -4.42926, 'address', 'openstreetmap:node/13468129151'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-6123365785', 'Carrefour Toledo – Calle Sillería', NULL, '45168', 'Calle Sillería 7', '45001', 39.86005, -4.02198, 'address', 'openstreetmap:node/6123365785'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-8726208617', 'Carrefour El Viso de San Juan – Camino de Illescas', NULL, '45199', 'Camino de Illescas', '45215', 40.1414, -3.91714, 'address', 'openstreetmap:node/8726208617'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-8900662935', 'Carrefour Toledo – Calle La Trinidad', NULL, '45168', 'Calle La Trinidad 5', '45002', 39.85705, -4.02572, 'address', 'openstreetmap:node/8900662935'),
  ('Decathlon', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-258171746', 'Decathlon Toledo – Carretera de Toledo a Bargas', NULL, '45168', 'Carretera de Toledo a Bargas', NULL, 39.90285, -4.01743, 'address', 'openstreetmap:way/258171746'),
  ('Leroy Merlin', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-258171747', 'Leroy Merlin Toledo', NULL, '45168', NULL, NULL, 39.90348, -4.01612, 'address', 'openstreetmap:way/258171747'),
  ('MediaMarkt', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-258171748', 'MediaMarkt Toledo', NULL, '45168', NULL, NULL, 39.9044, -4.01553, 'address', 'openstreetmap:way/258171748'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-644423969', 'Carrefour Talavera de la Reina – Carretera de Madrid', NULL, '45165', 'Carretera de Madrid 114', '45600', 39.96296, -4.7958, 'address', 'openstreetmap:way/644423969'),
  ('Decathlon', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-644423975', 'Decathlon Talavera de la Reina – Carretera de Madrid', NULL, '45165', 'Carretera de Madrid 114', '45600', 39.96668, -4.79498, 'address', 'openstreetmap:way/644423975'),
  ('MediaMarkt', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-644423985', 'MediaMarkt Talavera de la Reina – Carretera de Madrid', NULL, '45165', 'Carretera de Madrid 114', '45600', 39.96693, -4.79752, 'address', 'openstreetmap:way/644423985'),
  ('Leroy Merlin', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-644423988', 'Leroy Merlin Talavera de la Reina – Carretera de Madrid', NULL, '45165', 'Carretera de Madrid 114', '45600', 39.96549, -4.7985, 'address', 'openstreetmap:way/644423988'),
  ('El Corte Inglés', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-645764837', 'El Corte Inglés Talavera de la Reina – Avenida de Toledo', NULL, '45165', 'Avenida de Toledo 1', '45600', 39.96219, -4.82606, 'address', 'openstreetmap:way/645764837');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '45');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 45 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '45'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 13 THEN
    RAISE EXCEPTION 'Se esperaban 13 puntos de (varias) en Toledo, hay %', n;
  END IF;
END;
$$;

COMMIT;

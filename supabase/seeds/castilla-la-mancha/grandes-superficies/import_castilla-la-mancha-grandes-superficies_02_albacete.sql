-- Carga de la categoría (varias) de Albacete (provincia 02), trozo de la carga de Andalucía.
-- Origen: castilla-la-mancha-grandes-superficies-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 14 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-13227404941', 'Carrefour Albacete – Calle del Tinte', NULL, '02003', 'Calle del Tinte 56', '02002', 38.99202, -1.85211, 'address', 'openstreetmap:node/13227404941'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-13390696410', 'Carrefour Albacete – Avenida de España', NULL, '02003', 'Avenida de España 22', '02002', 38.98411, -1.854, 'address', 'openstreetmap:node/13390696410'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-13457898579', 'Carrefour Albacete – Calle General Méndez Parada', NULL, '02003', 'Calle General Méndez Parada', '02006', 38.98396, -1.86731, 'address', 'openstreetmap:node/13457898579'),
  ('IKEA', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-13461055197', 'IKEA Albacete – Calle Alcalde Conangla', NULL, '02003', 'Calle Alcalde Conangla 80', '02001', 38.99111, -1.84767, 'address', 'openstreetmap:node/13461055197'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-2324213062', 'Carrefour Albacete – Calle Iris', NULL, '02003', 'Calle Iris 8', '02005', 38.99792, -1.85482, 'address', 'openstreetmap:node/2324213062'),
  ('El Corte Inglés', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-2324213066', 'El Corte Inglés Albacete – Calle de la Caba', NULL, '02003', 'Calle de la Caba 9', '02001', 38.99337, -1.85796, 'address', 'openstreetmap:node/2324213066'),
  ('MediaMarkt', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-2942303567', 'MediaMarkt Albacete – Avenida de la Ilustración', NULL, '02003', 'Avenida de la Ilustración', NULL, 39.00894, -1.87733, 'address', 'openstreetmap:node/2942303567'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-4256128560', 'Carrefour Villarrobledo – Calle Isaac Peral', NULL, '02081', 'Calle Isaac Peral', NULL, 39.28501, -2.58018, 'address', 'openstreetmap:node/4256128560'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-6178449560', 'Carrefour El Ballestero – Calle del Arco', NULL, '02014', 'Calle del Arco', NULL, 38.84171, -2.45432, 'address', 'openstreetmap:node/6178449560'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-6285468965', 'Carrefour Albacete – Paseo de la Cuba', NULL, '02003', 'Paseo de la Cuba 36', '02005', 39.00499, -1.8599, 'address', 'openstreetmap:node/6285468965'),
  ('Leroy Merlin', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:relation-3624168', 'Leroy Merlin Albacete – Avenida Escritor Rodrigo Rubio', NULL, '02003', 'Avenida Escritor Rodrigo Rubio', NULL, 39.00971, -1.87616, 'address', 'openstreetmap:relation/3624168'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-1270143694', 'Carrefour Albacete – Calle Autovía', NULL, '02003', 'Calle Autovía 5', '02007', 39.01562, -1.8716, 'address', 'openstreetmap:way/1270143694'),
  ('Decathlon', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-130873903', 'Decathlon Albacete – Ctra. Madrid', NULL, '02003', 'Ctra. Madrid', '02007', 39.02485, -1.89006, 'address', 'openstreetmap:way/130873903'),
  ('El Corte Inglés', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-471719232', 'El Corte Inglés Albacete – Calle Hellín', NULL, '02003', 'Calle Hellín 32', '02008', 38.98257, -1.85425, 'address', 'openstreetmap:way/471719232');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '02');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 02 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '02'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 14 THEN
    RAISE EXCEPTION 'Se esperaban 14 puntos de (varias) en Albacete, hay %', n;
  END IF;
END;
$$;

COMMIT;

-- Carga de la categoría (varias) de Bizkaia (provincia 48), trozo de la carga de Andalucía.
-- Origen: pais-vasco-grandes-superficies-pais-vasco.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 38 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-10586999505', 'Carrefour Bermeo – Bizkaiko Jaurerria kalea', NULL, '48017', 'Bizkaiko Jaurerria kalea 26', '48370', 43.42117, -2.7301, 'address', 'openstreetmap:node/10586999505'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-10924154941', 'Carrefour Sestao – Gran Vía de José Antonio Aguirre', NULL, '48084', 'Gran Vía de José Antonio Aguirre 21', '48910', 43.3088, -3.00391, 'address', 'openstreetmap:node/10924154941'),
  ('Decathlon', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-12521053292', 'Decathlon Durango – Astolabide kalea', NULL, '48027', 'Astolabide kalea', '48200', 43.16418, -2.61936, 'address', 'openstreetmap:node/12521053292'),
  ('MediaMarkt', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-12636579480', 'MediaMarkt Basauri', NULL, '48015', NULL, '48970', 43.22859, -2.87405, 'address', 'openstreetmap:node/12636579480'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-12651829896', 'Carrefour Berriz', NULL, '48019', NULL, '48240', 43.16671, -2.58508, 'address', 'openstreetmap:node/12651829896'),
  ('Decathlon', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-13272216119', 'Decathlon Berango – Kesnea kalea', NULL, '48016', 'Kesnea kalea 2', '48640', 43.37089, -2.99497, 'address', 'openstreetmap:node/13272216119'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-14219004976', 'Carrefour Bilbao – Muxika eta Butroe kalea', NULL, '48020', 'Muxika eta Butroe kalea', '48007', 43.26817, -2.92687, 'address', 'openstreetmap:node/14219004976'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-14244107828', 'Carrefour Santurtzi – Antonio Alzaga etorbidea', NULL, '48082', 'Antonio Alzaga etorbidea', '48980', 43.32435, -3.02876, 'address', 'openstreetmap:node/14244107828'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-1851698832', 'Carrefour Bilbao – Donibane Plazatxoa 1A', NULL, '48020', 'Donibane Plazatxoa 1A', '48006', 43.25548, -2.92238, 'address', 'openstreetmap:node/1851698832'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-3440859476', 'Carrefour Bilbao – Jose Maria Olavarri kalea 2-4 bajo', NULL, '48020', 'Jose Maria Olavarri kalea 2-4 bajo', '48001', 43.26037, -2.92755, 'address', 'openstreetmap:node/3440859476'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-4262779991', 'Carrefour Getxo – Zubiko enparantza 1A', NULL, '48044', 'Zubiko enparantza 1A', '48930', 43.32374, -3.01518, 'address', 'openstreetmap:node/4262779991'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-4263054012', 'Carrefour Bilbao – Zingira kalea', NULL, '48020', 'Zingira kalea 6', '48007', 43.26307, -2.92291, 'address', 'openstreetmap:node/4263054012'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-4329062711', 'Carrefour Bakio – Ambietako goienkalea', NULL, '48012', 'Ambietako goienkalea', '48130', 43.42839, -2.80704, 'address', 'openstreetmap:node/4329062711'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-4402963589', 'Carrefour Zamudio – Calle Arbolantxa', NULL, '48905', 'Calle Arbolantxa 8', '48170', 43.28342, -2.86314, 'address', 'openstreetmap:node/4402963589'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-4701113369', 'Carrefour Bilbao – Jardines kalea', NULL, '48020', 'Jardines kalea', '48005', 43.25827, -2.92529, 'address', 'openstreetmap:node/4701113369'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-5102745997', 'Carrefour Ondarroa – Ibaiondo kalea', NULL, '48073', 'Ibaiondo kalea', '48700', 43.32062, -2.43194, 'address', 'openstreetmap:node/5102745997'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-514122016', 'Carrefour Bilbao – Zabalburu enparantza', NULL, '48020', 'Zabalburu enparantza 1', '48003', 43.25677, -2.93463, 'address', 'openstreetmap:node/514122016'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-6422909414', 'Carrefour Plentzia – Areatza kalea', NULL, '48077', 'Areatza kalea', '48630', 43.40835, -2.94445, 'address', 'openstreetmap:node/6422909414'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-6723408187', 'Carrefour Barakaldo – Ibarra kalea', NULL, '48013', 'Ibarra kalea 19', '48901', 43.29952, -2.98467, 'address', 'openstreetmap:node/6723408187'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-6912120900', 'Carrefour Basauri – Calle Madrid', NULL, '48015', 'Calle Madrid', '48970', 43.2393, -2.88728, 'address', 'openstreetmap:node/6912120900'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-6919039730', 'Carrefour Portugalete – Calle Barrengoitia kalea', NULL, '48078', 'Calle Barrengoitia kalea 20', '48920', 43.31556, -3.0162, 'address', 'openstreetmap:node/6919039730'),
  ('Leroy Merlin', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-7048803170', 'Leroy Merlin Durango – Astola auzoa', NULL, '48027', 'Astola auzoa 18', '48200', 43.16444, -2.6197, 'address', 'openstreetmap:node/7048803170'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-7221848807', 'Carrefour Derio – Mikel Deuna plaza', NULL, '48901', 'Mikel Deuna plaza 1', '48160', 43.29281, -2.88631, 'address', 'openstreetmap:node/7221848807'),
  ('MediaMarkt', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-7922215360', 'MediaMarkt Bilbao – Leizaola lehendakariaren kalea', NULL, '48020', 'Leizaola lehendakariaren kalea 2', '48011', 43.26781, -2.94105, 'address', 'openstreetmap:node/7922215360'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-8145835417', 'Carrefour Leioa – Avenida Iparragirre', NULL, '48054', 'Avenida Iparragirre 20', '48940', 43.32698, -2.99024, 'address', 'openstreetmap:node/8145835417'),
  ('Decathlon', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-868846512', 'Decathlon Bilbao – Villarias kalea', NULL, '48020', 'Villarias kalea 10', '48001', 43.26194, -2.92553, 'address', 'openstreetmap:node/868846512'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-9242628946', 'Carrefour Bilbao – Catalunya kalea', NULL, '48020', 'Catalunya kalea 1', '48015', 43.28331, -2.96331, 'address', 'openstreetmap:node/9242628946'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:node-9380121417', 'Carrefour Galdakao – Iturrondo plaza', NULL, '48036', 'Iturrondo plaza', '48960', 43.23132, -2.84156, 'address', 'openstreetmap:node/9380121417'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-107255122', 'Carrefour Sestao – Avenida de Babcock & Wilcox', NULL, '48084', 'Avenida de Babcock & Wilcox', '48910', 43.30105, -3.00329, 'address', 'openstreetmap:way/107255122'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-1252793336', 'Carrefour Urduliz – Atzeragaine', NULL, '48089', 'Atzeragaine 3', '48610', 43.37553, -2.95417, 'address', 'openstreetmap:way/1252793336'),
  ('Leroy Merlin', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-139877799', 'Leroy Merlin Barakaldo – Avenida La Ribera', NULL, '48013', 'Avenida La Ribera', '48903', 43.28777, -2.99998, 'address', 'openstreetmap:way/139877799'),
  ('Decathlon', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-143898368', 'Decathlon Barakaldo – Erribera etorbidea', NULL, '48013', 'Erribera etorbidea', NULL, 43.29044, -3.0056, 'address', 'openstreetmap:way/143898368'),
  ('MediaMarkt', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-276753438', 'MediaMarkt Barakaldo – Avenida La Ribera', NULL, '48013', 'Avenida La Ribera', '48902', 43.28912, -3.00287, 'address', 'openstreetmap:way/276753438'),
  ('Leroy Merlin', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-400935367', 'Leroy Merlin Basauri – Etxerre-Sektorea kalea', NULL, '48015', 'Etxerre-Sektorea kalea', NULL, 43.22838, -2.87247, 'address', 'openstreetmap:way/400935367'),
  ('Carrefour', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-40353330', 'Carrefour Erandio – Lataondo kalea', NULL, '48902', 'Lataondo kalea', NULL, 43.30161, -2.95343, 'address', 'openstreetmap:way/40353330'),
  ('El Corte Inglés', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-44016098', 'El Corte Inglés Bilbao – On Diego Lopez Haroko kale nagusia', NULL, '48020', 'On Diego Lopez Haroko kale nagusia 7', '48001', 43.26121, -2.9291, 'address', 'openstreetmap:way/44016098'),
  ('Leroy Merlin', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-501308990', 'Leroy Merlin Leioa – Barrio Peruri', NULL, '48054', 'Barrio Peruri 33', '48940', 43.34095, -2.99271, 'address', 'openstreetmap:way/501308990'),
  ('IKEA', 'catalogo-pais-vasco:pais-vasco-grandes-superficies:way-53087031', 'IKEA Barakaldo – Zubitxueta kalea', NULL, '48013', 'Zubitxueta kalea', NULL, 43.2915, -3.00687, 'address', 'openstreetmap:way/53087031');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '48');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 48 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '48'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 38 THEN
    RAISE EXCEPTION 'Se esperaban 38 puntos de (varias) en Bizkaia, hay %', n;
  END IF;
END;
$$;

COMMIT;

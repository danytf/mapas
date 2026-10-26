-- Carga de la categoría Estaciones de Araba/Álava (provincia 01), trozo de la carga de Andalucía.
-- Origen: estaciones-pais-vasco.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 17 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-pais-vasco:estaciones:node-11298591181', 'Estación de tren de Iñarratxu (Amurrio)', 'Tren', '01002', NULL, NULL, 43.03583, -3.00396, 'address', 'openstreetmap:node/11298591181'),
  ('catalogo-pais-vasco:estaciones:node-12771168075', 'Estación de tren de Areta (Llodio) – Geltoki kalea', 'Tren', '01036', 'Geltoki kalea 4', '01400', 43.14502, -2.94354, 'address', 'openstreetmap:node/12771168075'),
  ('catalogo-pais-vasco:estaciones:node-12771185440', 'Estación de tren de Amurrio – Dionisio Aldama kalea', 'Tren', '01002', 'Dionisio Aldama kalea', '01470', 43.04886, -3.00184, 'address', 'openstreetmap:node/12771185440'),
  ('catalogo-pais-vasco:estaciones:node-13691559903', 'Estación de autobuses de Vitoria-Gasteiz – Euskaltzaindiaren plaza', 'Autobús', '01059', 'Euskaltzaindiaren plaza', '01010', 42.85893, -2.68496, 'approximate', 'openstreetmap:node/13691559903'),
  ('catalogo-pais-vasco:estaciones:node-2041973720', 'Estación de tren de Inoso-Oiardo (Urkabustaiz)', 'Tren', '01054', NULL, NULL, 42.99269, -2.91555, 'address', 'openstreetmap:node/2041973720'),
  ('catalogo-pais-vasco:estaciones:node-2044176476', 'Estación de tren de Alegría-Dulantzi – Geltoki plaza', 'Tren', '01001', 'Geltoki plaza 3', '01240', 42.84904, -2.51463, 'address', 'openstreetmap:node/2044176476'),
  ('catalogo-pais-vasco:estaciones:node-2046477540', 'Estación de tren de Manzanos (Ribera Baja / Erriberabeitia) – Zadorra ibaiaren kalea', 'Tren', '01047', 'Zadorra ibaiaren kalea 10', '01220', 42.74274, -2.86734, 'address', 'openstreetmap:node/2046477540'),
  ('catalogo-pais-vasco:estaciones:node-2046477543', 'Estación de tren de Nanclares-Langraiz (Iruña Oka / Iruña de Oca) – Geltoki kalea', 'Tren', '01901', 'Geltoki kalea 7', '01230', 42.81603, -2.80485, 'address', 'openstreetmap:node/2046477543'),
  ('catalogo-pais-vasco:estaciones:node-2381701827', 'Estación de tren de Agurain-Salvatierra de Álava – Trebiño kalea', 'Tren', '01051', 'Trebiño kalea', '01200', 42.84631, -2.38889, 'address', 'openstreetmap:node/2381701827'),
  ('catalogo-pais-vasco:estaciones:node-29568804', 'Estación de tren de Vitoria-Gasteiz – Eduardo Dato kalea', 'Tren', '01059', 'Eduardo Dato kalea 46', '01005', 42.8413, -2.6727, 'address', 'openstreetmap:node/29568804'),
  ('catalogo-pais-vasco:estaciones:node-4396236530', 'Estación de tren de Araia (San Millán / Donemiliaga) – 21', 'Tren', '01053', '21', '01207', 42.86923, -2.30674, 'address', 'openstreetmap:node/4396236530'),
  ('catalogo-pais-vasco:estaciones:node-6074627183', 'Estación de tren de Amurrio Iparralde – Juan Aranoa kalea', 'Tren', '01002', 'Juan Aranoa kalea', '01470', 43.05767, -2.99619, 'address', 'openstreetmap:node/6074627183'),
  ('catalogo-pais-vasco:estaciones:node-6074646912', 'Estación de tren de Salbio (Amurrio) – Urieta kalea', 'Tren', '01002', 'Urieta kalea', NULL, 43.0744, -2.99945, 'address', 'openstreetmap:node/6074646912'),
  ('catalogo-pais-vasco:estaciones:node-6074657072', 'Estación de tren de Luiaondo (Ayala / Aiara) – Oloste kalea', 'Tren', '01010', 'Oloste kalea', NULL, 43.09354, -2.99953, 'address', 'openstreetmap:node/6074657072'),
  ('catalogo-pais-vasco:estaciones:node-6074666381', 'Estación de tren de Santa Kurutz Laudio/Santa Cruz de Llodio – 2', 'Tren', '01036', '2', '01400', 43.13292, -2.96961, 'address', 'openstreetmap:node/6074666381'),
  ('catalogo-pais-vasco:estaciones:node-6074703741', 'Estación de tren de Laudio/Llodio – Jose Matia kalea', 'Tren', '01036', 'Jose Matia kalea 2', '01400', 43.14225, -2.9605, 'address', 'openstreetmap:node/6074703741'),
  ('catalogo-pais-vasco:estaciones:way-489639101', 'Gasteizko autobus geltokia (Vitoria-Gasteiz) – Euskaltzaindiaren plaza', 'Autobús', '01059', 'Euskaltzaindiaren plaza', '01010', 42.85898, -2.68499, 'approximate', 'openstreetmap:way/489639101');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '01');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 01 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '01'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 17 THEN
    RAISE EXCEPTION 'Se esperaban 17 puntos de Estaciones en Araba/Álava, hay %', n;
  END IF;
END;
$$;

COMMIT;

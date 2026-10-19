-- Carga de la categoría Estaciones de Almería (provincia 04), trozo de la carga de Andalucía.
-- Origen: estaciones-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 19 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:estaciones:node-13201412154', 'Estación Adra', 'Autobús', '04003', NULL, NULL, 36.74714, -3.02002, 'address', 'openstreetmap:node/13201412154'),
  ('catalogo-andalucia:estaciones:node-2621533422', 'Autobuses Salidas (Almería)', 'Autobús', '04013', NULL, NULL, 36.84725, -2.37421, 'approximate', 'openstreetmap:node/2621533422'),
  ('catalogo-andalucia:estaciones:node-348597701', 'Estación de tren de Gádor', 'Tren', '04047', NULL, NULL, 36.9515, -2.48751, 'address', 'openstreetmap:node/348597701'),
  ('catalogo-andalucia:estaciones:node-7747872372', 'Estación de tren de Huércal-Viator (Huércal de Almería)', 'Tren', '04052', NULL, NULL, 36.88346, -2.43628, 'address', 'openstreetmap:node/7747872372'),
  ('catalogo-andalucia:estaciones:node-7747872375', 'Estación de tren de Gérgal', 'Tren', '04050', NULL, NULL, 37.10861, -2.59158, 'address', 'openstreetmap:node/7747872375'),
  ('catalogo-andalucia:estaciones:node-7747890740', 'Estación de tren de Abla y Abrucena', 'Tren', '04001', NULL, NULL, 37.16745, -2.78398, 'address', 'openstreetmap:node/7747890740'),
  ('catalogo-andalucia:estaciones:node-7747890743', 'Estación de tren de Fiñana', 'Tren', '04045', NULL, NULL, 37.18472, -2.83948, 'address', 'openstreetmap:node/7747890743'),
  ('catalogo-andalucia:estaciones:way-1006233607', 'Estación de tren de Los Tres Amigos (Bédar)', 'Tren', '04022', NULL, NULL, 37.18352, -1.9689, 'address', 'openstreetmap:way/1006233607'),
  ('catalogo-andalucia:estaciones:way-1073623248', 'Estación de Fines-Olula', 'Tren', '04044', NULL, NULL, 37.35855, -2.28292, 'address', 'openstreetmap:way/1073623248'),
  ('catalogo-andalucia:estaciones:way-1121877573', 'Estación de Autobuses de Vera', 'Autobús', '04100', NULL, NULL, 37.25238, -1.87117, 'address', 'openstreetmap:way/1121877573'),
  ('catalogo-andalucia:estaciones:way-1242658147', 'Estación de Autobuses de Mojácar – Avenida de Andalucía', 'Autobús', '04064', 'Avenida de Andalucía 22', '04638', 37.13689, -1.83755, 'address', 'openstreetmap:way/1242658147'),
  ('catalogo-andalucia:estaciones:way-1355144769', 'Antigua estación de Renfe (Cantoria)', 'Tren', '04031', NULL, NULL, 37.34637, -2.13891, 'address', 'openstreetmap:way/1355144769'),
  ('catalogo-andalucia:estaciones:way-232819817', 'Estación de tren de Pulpí', 'Tren', '04075', NULL, NULL, 37.39921, -1.7495, 'address', 'openstreetmap:way/232819817'),
  ('catalogo-andalucia:estaciones:way-232819819', 'Estación de tren de Jaravía (Pulpí)', 'Tren', '04075', NULL, NULL, 37.39243, -1.69304, 'address', 'openstreetmap:way/232819819'),
  ('catalogo-andalucia:estaciones:way-264281198', 'Estacion de Autobuses (Berja)', 'Autobús', '04029', NULL, NULL, 36.84089, -2.94734, 'address', 'openstreetmap:way/264281198'),
  ('catalogo-andalucia:estaciones:way-27152911', 'Estación Intermodal (Almería)', 'Autobús', '04013', NULL, NULL, 36.83523, -2.45552, 'address', 'openstreetmap:way/27152911'),
  ('catalogo-andalucia:estaciones:way-327920595', 'Estación de autobuses (Roquetas de Mar) – Avenida de Curro Romero', 'Autobús', '04079', 'Avenida de Curro Romero', NULL, 36.7676, -2.61614, 'address', 'openstreetmap:way/327920595'),
  ('catalogo-andalucia:estaciones:way-374774454', 'Estación de Autobuses de El Ejido', 'Autobús', '04902', NULL, NULL, 36.77313, -2.80794, 'address', 'openstreetmap:way/374774454'),
  ('catalogo-andalucia:estaciones:way-436090091', 'Estación de Autobuses de Cuevas del Almanzora', 'Autobús', '04035', NULL, NULL, 37.29172, -1.87814, 'address', 'openstreetmap:way/436090091');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '04');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 04 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '04'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 19 THEN
    RAISE EXCEPTION 'Se esperaban 19 puntos de Estaciones en Almería, hay %', n;
  END IF;
END;
$$;

COMMIT;

-- Carga de la categoría Estaciones de Córdoba (provincia 14), trozo de la carga de Andalucía.
-- Origen: estaciones-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 22 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:estaciones:node-1258460004', 'Estación de Autobuses de Cabra', 'Autobús', '14013', NULL, NULL, 37.47695, -4.44082, 'address', 'openstreetmap:node/1258460004'),
  ('catalogo-andalucia:estaciones:node-2043185471', 'Estación de tren de Rabanales (Córdoba)', 'Tren', '14021', NULL, NULL, 37.9126, -4.72063, 'address', 'openstreetmap:node/2043185471'),
  ('catalogo-andalucia:estaciones:node-2269474720', 'Estación de tren de Villanueva de Córdoba-Los Pedroches', 'Tren', '14069', NULL, NULL, 38.25524, -4.57142, 'address', 'openstreetmap:node/2269474720'),
  ('catalogo-andalucia:estaciones:node-2327544737', 'Estación de Autobuses (Priego de Córdoba)', 'Autobús', '14055', NULL, NULL, 37.43919, -4.20216, 'address', 'openstreetmap:node/2327544737'),
  ('catalogo-andalucia:estaciones:node-2440494212', 'Estación de autobuses de Baena', 'Autobús', '14007', NULL, NULL, 37.61886, -4.33008, 'address', 'openstreetmap:node/2440494212'),
  ('catalogo-andalucia:estaciones:node-3213014372', 'Estación de autobuses (Hinojosa del Duque)', 'Autobús', '14035', NULL, NULL, 38.49675, -5.14055, 'address', 'openstreetmap:node/3213014372'),
  ('catalogo-andalucia:estaciones:node-4540867496', 'Estación de autobuses de ARRIBAS SUR S.L. (Villaviciosa de Córdoba) – Calle Aceiteros', 'Autobús', '14073', 'Calle Aceiteros', '14300', 38.07245, -5.01579, 'approximate', 'openstreetmap:node/4540867496'),
  ('catalogo-andalucia:estaciones:node-5254650053', 'Estación de tren de El Higuerón (Córdoba)', 'Tren', '14021', NULL, NULL, 37.86703, -4.85047, 'address', 'openstreetmap:node/5254650053'),
  ('catalogo-andalucia:estaciones:node-7564281361', 'Estación de tren de Montilla', 'Tren', '14042', NULL, NULL, 37.579, -4.6337, 'address', 'openstreetmap:node/7564281361'),
  ('catalogo-andalucia:estaciones:node-7567516121', 'Estación de tren de Córdoba Julio Anguita', 'Tren', '14021', NULL, NULL, 37.88851, -4.78952, 'address', 'openstreetmap:node/7567516121'),
  ('catalogo-andalucia:estaciones:node-7567538147', 'Estación de tren de Puente Genil', 'Tren', '14056', NULL, NULL, 37.39592, -4.75278, 'address', 'openstreetmap:node/7567538147'),
  ('catalogo-andalucia:estaciones:node-7571619026', 'Estación de tren de Puente Genil-Herrera', 'Tren', '14056', NULL, NULL, 37.35892, -4.82223, 'address', 'openstreetmap:node/7571619026'),
  ('catalogo-andalucia:estaciones:node-7752653212', 'Estación de tren de Villa del Rio', 'Tren', '14066', NULL, NULL, 37.98129, -4.28369, 'address', 'openstreetmap:node/7752653212'),
  ('catalogo-andalucia:estaciones:node-7752653219', 'Estación de tren de Alcolea de Córdoba', 'Tren', '14021', NULL, NULL, 37.93298, -4.67481, 'address', 'openstreetmap:node/7752653219'),
  ('catalogo-andalucia:estaciones:node-7758175192', 'Estación de tren de Villarrubia de Córdoba', 'Tren', '14021', NULL, NULL, 37.84797, -4.91377, 'address', 'openstreetmap:node/7758175192'),
  ('catalogo-andalucia:estaciones:node-7758175194', 'Estación de tren de Posadas', 'Tren', '14053', NULL, NULL, 37.80415, -5.10592, 'address', 'openstreetmap:node/7758175194'),
  ('catalogo-andalucia:estaciones:node-7758175203', 'Estación de tren de Palma del Río', 'Tren', '14049', NULL, NULL, 37.71814, -5.29295, 'address', 'openstreetmap:node/7758175203'),
  ('catalogo-andalucia:estaciones:way-1041899260', 'ESTACIÓN DE AUTOBUSES (Puente Genil)', 'Autobús', '14056', NULL, NULL, 37.39602, -4.76274, 'address', 'openstreetmap:way/1041899260'),
  ('catalogo-andalucia:estaciones:way-288900722', 'Estación de autobuses de Montilla', 'Autobús', '14042', NULL, NULL, 37.57958, -4.64726, 'address', 'openstreetmap:way/288900722'),
  ('catalogo-andalucia:estaciones:way-351243242', 'Estación de Autobuses de Fuente Palmera', 'Autobús', '14030', NULL, NULL, 37.70528, -5.10627, 'address', 'openstreetmap:way/351243242'),
  ('catalogo-andalucia:estaciones:way-355717627', 'Estación de Autobuses (Lucena)', 'Autobús', '14038', NULL, NULL, 37.40834, -4.49373, 'address', 'openstreetmap:way/355717627'),
  ('catalogo-andalucia:estaciones:way-36349311', 'Estación de Autobuses de Córdoba', 'Autobús', '14021', NULL, NULL, 37.88944, -4.79024, 'address', 'openstreetmap:way/36349311');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '14');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 14 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '14'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 22 THEN
    RAISE EXCEPTION 'Se esperaban 22 puntos de Estaciones en Córdoba, hay %', n;
  END IF;
END;
$$;

COMMIT;

-- Carga de la categoría Estaciones de Huelva (provincia 21), trozo de la carga de Andalucía.
-- Origen: estaciones-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 29 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:estaciones:node-1283643485', 'Estación de tren de Zarandas-Naya (Minas de Riotinto)', 'Tren', '21049', NULL, NULL, 37.67151, -6.55769, 'address', 'openstreetmap:node/1283643485'),
  ('catalogo-andalucia:estaciones:node-2192841858', 'Estación de tren de Los Frailes (El Campillo)', 'Tren', '21018', NULL, NULL, 37.62836, -6.53691, 'address', 'openstreetmap:node/2192841858'),
  ('catalogo-andalucia:estaciones:node-2981344588', 'Estación de tren de Calañas', 'Tren', '21017', NULL, NULL, 37.65178, -6.87629, 'address', 'openstreetmap:node/2981344588'),
  ('catalogo-andalucia:estaciones:node-2981357671', 'Estación de tren de Valdelamusa (Cortegana)', 'Tren', '21025', NULL, NULL, 37.78718, -6.87388, 'address', 'openstreetmap:node/2981357671'),
  ('catalogo-andalucia:estaciones:node-3221905598', 'Estación de tren de San Juan del Puerto', 'Tren', '21064', NULL, NULL, 37.31186, -6.84096, 'address', 'openstreetmap:node/3221905598'),
  ('catalogo-andalucia:estaciones:node-5580567331', 'Estación de tren de Huelva', 'Tren', '21041', NULL, NULL, 37.25262, -6.94485, 'address', 'openstreetmap:node/5580567331'),
  ('catalogo-andalucia:estaciones:node-7779139634', 'Estación de tren de Escacena (Escacena del Campo)', 'Tren', '21032', NULL, NULL, 37.39772, -6.39208, 'address', 'openstreetmap:node/7779139634'),
  ('catalogo-andalucia:estaciones:node-7779139644', 'Estación de tren de La Palma del Condado', 'Tren', '21054', NULL, NULL, 37.39079, -6.55436, 'address', 'openstreetmap:node/7779139644'),
  ('catalogo-andalucia:estaciones:node-7788593121', 'Estación de tren de Gibraleón', 'Tren', '21035', NULL, NULL, 37.36789, -6.96215, 'address', 'openstreetmap:node/7788593121'),
  ('catalogo-andalucia:estaciones:node-7788593147', 'Estación de tren de Belmonte (Gibraleón)', 'Tren', '21035', NULL, NULL, 37.46184, -6.94763, 'address', 'openstreetmap:node/7788593147'),
  ('catalogo-andalucia:estaciones:node-7788593156', 'Estación de tren de El Cobujon (Calañas)', 'Tren', '21017', NULL, NULL, 37.51649, -6.95324, 'address', 'openstreetmap:node/7788593156'),
  ('catalogo-andalucia:estaciones:node-7788593167', 'Estación de tren de Los Milanos (Calañas)', 'Tren', '21017', NULL, NULL, 37.58618, -6.91977, 'address', 'openstreetmap:node/7788593167'),
  ('catalogo-andalucia:estaciones:node-7788690527', 'Estación de tren de El Tamujoso (El Cerro de Andévalo)', 'Tren', '21023', NULL, NULL, 37.72034, -6.90045, 'address', 'openstreetmap:node/7788690527'),
  ('catalogo-andalucia:estaciones:node-7788690530', 'Estación de tren de Almonaster - Cortegana (Almonaster la Real)', 'Tren', '21004', NULL, NULL, 37.90102, -6.79735, 'address', 'openstreetmap:node/7788690530'),
  ('catalogo-andalucia:estaciones:node-7788690533', 'Estación de tren de Jabugo-Galaroza', 'Tren', '21043', NULL, NULL, 37.92737, -6.77299, 'address', 'openstreetmap:node/7788690533'),
  ('catalogo-andalucia:estaciones:node-7788690536', 'Estación de tren de Cumbres Mayores', 'Tren', '21029', NULL, NULL, 38.05308, -6.6309, 'address', 'openstreetmap:node/7788690536'),
  ('catalogo-andalucia:estaciones:node-8901475192', 'Estación de tren de Talleres Mina (Minas de Riotinto)', 'Tren', '21049', NULL, NULL, 37.68874, -6.55988, 'address', 'openstreetmap:node/8901475192'),
  ('catalogo-andalucia:estaciones:node-9783898163', 'Estación de tren de Niebla-Puerta del Buey', 'Tren', '21053', NULL, NULL, 37.35842, -6.68136, 'address', 'openstreetmap:node/9783898163'),
  ('catalogo-andalucia:estaciones:relation-1432486', 'Estación de Autobuses de Huelva', 'Autobús', '21041', NULL, NULL, 37.25737, -6.95753, 'approximate', 'openstreetmap:relation/1432486'),
  ('catalogo-andalucia:estaciones:way-1111522686', 'Apeadero de Autobuses de Nerva', 'Autobús', '21052', NULL, NULL, 37.69857, -6.55418, 'address', 'openstreetmap:way/1111522686'),
  ('catalogo-andalucia:estaciones:way-1558924474', 'Estación de autobuses de Zafra (Huelva) – Avenida de Alemania', 'Autobús', '21041', 'Avenida de Alemania 3', '21001', 37.25769, -6.95657, 'approximate', 'openstreetmap:way/1558924474'),
  ('catalogo-andalucia:estaciones:way-185322647', 'Estación de Autobuses de Ayamonte', 'Autobús', '21010', NULL, NULL, 37.21474, -7.39933, 'address', 'openstreetmap:way/185322647'),
  ('catalogo-andalucia:estaciones:way-225560416', 'Estación de Autobuses (Isla Cristina)', 'Autobús', '21042', NULL, NULL, 37.20317, -7.32383, 'address', 'openstreetmap:way/225560416'),
  ('catalogo-andalucia:estaciones:way-401832294', 'Estación de Autobuses de Aracena – Avenida de Sevilla', 'Autobús', '21007', 'Avenida de Sevilla', '21200', 37.88862, -6.5574, 'address', 'openstreetmap:way/401832294'),
  ('catalogo-andalucia:estaciones:way-448143051', 'Estación de Autobuses de Lepe', 'Autobús', '21044', NULL, NULL, 37.25382, -7.19726, 'address', 'openstreetmap:way/448143051'),
  ('catalogo-andalucia:estaciones:way-62310591', 'Apeadero (Almonte)', 'Autobús', '21005', NULL, NULL, 37.00946, -6.56474, 'address', 'openstreetmap:way/62310591'),
  ('catalogo-andalucia:estaciones:way-931374864', 'Apeadero de Autobuses de Almonte', 'Autobús', '21005', NULL, NULL, 37.25748, -6.52018, 'address', 'openstreetmap:way/931374864'),
  ('catalogo-andalucia:estaciones:way-943312164', 'Apeadero de autobuses de Punta Umbría', 'Autobús', '21060', NULL, NULL, 37.18081, -6.96896, 'address', 'openstreetmap:way/943312164'),
  ('catalogo-andalucia:estaciones:way-998356506', 'Estación de tren de Villarrasa', 'Tren', '21077', NULL, NULL, 37.38688, -6.59848, 'address', 'openstreetmap:way/998356506');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '21');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 21 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '21'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 29 THEN
    RAISE EXCEPTION 'Se esperaban 29 puntos de Estaciones en Huelva, hay %', n;
  END IF;
END;
$$;

COMMIT;

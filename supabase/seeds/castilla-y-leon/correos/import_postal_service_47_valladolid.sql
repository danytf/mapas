-- Carga de la categoría Correos de Valladolid (provincia 47), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 27 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:postal_service:node-11339403828', 'Correos Fuensaldaña – Calle de la Madre María Jesús', NULL, '47066', 'Calle de la Madre María Jesús', '47194', 41.70683, -4.76602, 'address', 'openstreetmap:node/11339403828'),
  ('catalogo-castilla-y-leon:postal_service:node-1448528514', 'Correos Valladolid – Calle de Ultramar', NULL, '47186', 'Calle de Ultramar 3', '47006', 41.64021, -4.74074, 'address', 'openstreetmap:node/1448528514'),
  ('catalogo-castilla-y-leon:postal_service:node-1478313464', 'Correos Valladolid – Calle de Canterac', NULL, '47186', 'Calle de Canterac 25', '47012', 41.64101, -4.7188, 'address', 'openstreetmap:node/1478313464'),
  ('catalogo-castilla-y-leon:postal_service:node-1671932444', 'Correos Alcazarén – Plaza Mayor', NULL, '47005', 'Plaza Mayor 1', '47238', 41.37103, -4.67135, 'address', 'openstreetmap:node/1671932444'),
  ('catalogo-castilla-y-leon:postal_service:node-1681728997', 'Correos Pedrajas de San Esteban – Calle San Andrés', NULL, '47112', 'Calle San Andrés', NULL, 41.33874, -4.58208, 'address', 'openstreetmap:node/1681728997'),
  ('catalogo-castilla-y-leon:postal_service:node-1701705821', 'Correos Arroyo de la Encomienda – Avenida de Salamanca', NULL, '47010', 'Avenida de Salamanca', '47195', 41.62255, -4.77007, 'address', 'openstreetmap:node/1701705821'),
  ('catalogo-castilla-y-leon:postal_service:node-1783293351', 'Correos Olmedo – Plaza de Ulloa', NULL, '47104', 'Plaza de Ulloa', '47410', 41.2876, -4.68447, 'address', 'openstreetmap:node/1783293351'),
  ('catalogo-castilla-y-leon:postal_service:node-1988673312', 'Correos Valladolid – Avenida de Palencia', NULL, '47186', 'Avenida de Palencia 37', '47010', 41.66134, -4.71703, 'address', 'openstreetmap:node/1988673312'),
  ('catalogo-castilla-y-leon:postal_service:node-2678532102', 'Correos Laguna de Duero – Calle de las Huertas', NULL, '47076', 'Calle de las Huertas 21', '47140', 41.58256, -4.7243, 'address', 'openstreetmap:node/2678532102'),
  ('catalogo-castilla-y-leon:postal_service:node-3090444259', 'Correos Tordesillas – Calle Gutiérrez Mellado', NULL, '47165', 'Calle Gutiérrez Mellado 5', '47100', 41.50438, -5.00074, 'address', 'openstreetmap:node/3090444259'),
  ('catalogo-castilla-y-leon:postal_service:node-3419422894', 'Correos Medina del Campo – Calle de Simón Ruiz', NULL, '47085', 'Calle de Simón Ruiz 27', '47400', 41.30697, -4.91298, 'address', 'openstreetmap:node/3419422894'),
  ('catalogo-castilla-y-leon:postal_service:node-3440685964', 'Correos Mayorga – Plaza de Santiago', NULL, '47084', 'Plaza de Santiago 1', '47680', 42.16742, -5.26119, 'address', 'openstreetmap:node/3440685964'),
  ('catalogo-castilla-y-leon:postal_service:node-3998723771', 'Correos Valladolid – Avenida de Miguel Ángel Blanco', NULL, '47186', 'Avenida de Miguel Ángel Blanco 1', '47014', 41.64941, -4.73637, 'address', 'openstreetmap:node/3998723771'),
  ('catalogo-castilla-y-leon:postal_service:node-412216070', 'Correos Villalón de Campos – Calle Marceliano Serrano', NULL, '47214', 'Calle Marceliano Serrano', NULL, 42.10005, -5.03544, 'address', 'openstreetmap:node/412216070'),
  ('catalogo-castilla-y-leon:postal_service:node-4144545122', 'Correos Valladolid – Plaza de Marcos Fernández', NULL, '47186', 'Plaza de Marcos Fernández 2', '47014', 41.63612, -4.76049, 'address', 'openstreetmap:node/4144545122'),
  ('catalogo-castilla-y-leon:postal_service:node-4451173991', 'Correos Montemayor de Pililla – Calle Valcorba', NULL, '47093', 'Calle Valcorba', '47420', 41.50835, -4.45457, 'address', 'openstreetmap:node/4451173991'),
  ('catalogo-castilla-y-leon:postal_service:node-4698117925', 'Correos Peñafiel – Calle del Mercado Viejo', NULL, '47114', 'Calle del Mercado Viejo', '47300', 41.59679, -4.12057, 'address', 'openstreetmap:node/4698117925'),
  ('catalogo-castilla-y-leon:postal_service:node-6169778024', 'Correos Portillo – Plaza San Juan Evangelista', NULL, '47122', 'Plaza San Juan Evangelista 1', '47160', 41.47313, -4.59418, 'address', 'openstreetmap:node/6169778024'),
  ('catalogo-castilla-y-leon:postal_service:node-6380115451', 'Correos Campaspero – Calle Norte', NULL, '47030', 'Calle Norte 37', '47310', 41.49394, -4.19606, 'address', 'openstreetmap:node/6380115451'),
  ('catalogo-castilla-y-leon:postal_service:node-7064741205', 'Correos Valladolid – Calle de Sayago', NULL, '47186', 'Calle de Sayago', '47008', 41.62375, -4.74644, 'address', 'openstreetmap:node/7064741205'),
  ('catalogo-castilla-y-leon:postal_service:node-7173073506', 'Correos Arroyo de la Encomienda – Calle Francisco Vitoria', NULL, '47010', 'Calle Francisco Vitoria', '47195', 41.62054, -4.77752, 'address', 'openstreetmap:node/7173073506'),
  ('catalogo-castilla-y-leon:postal_service:node-7990080184', 'Correos Simancas – Calle Ermita', NULL, '47161', 'Calle Ermita', NULL, 41.5926, -4.82538, 'address', 'openstreetmap:node/7990080184'),
  ('catalogo-castilla-y-leon:postal_service:node-9153434081', 'Correos Valladolid – Calle Conde de Ribadeo', NULL, '47186', 'Calle Conde de Ribadeo 4', '47003', 41.65534, -4.72437, 'address', 'openstreetmap:node/9153434081'),
  ('catalogo-castilla-y-leon:postal_service:node-9462984667', 'Correos Castronuño – Calle Capitán Nolla', NULL, '47045', 'Calle Capitán Nolla 8', '47520', 41.38959, -5.26293, 'address', 'openstreetmap:node/9462984667'),
  ('catalogo-castilla-y-leon:postal_service:node-9538746219', 'Correos Santovenia de Pisuerga – Calle Real', NULL, '47155', 'Calle Real 47', '47155', 41.6924, -4.68818, 'address', 'openstreetmap:node/9538746219'),
  ('catalogo-castilla-y-leon:postal_service:way-179432469', 'Correos Zaratán – Plaza de Ronda', NULL, '47231', 'Plaza de Ronda 3', '47610', 41.65995, -4.78183, 'address', 'openstreetmap:way/179432469'),
  ('catalogo-castilla-y-leon:postal_service:way-60495510', 'Correos Valladolid – Plaza de la Rinconada', NULL, '47186', 'Plaza de la Rinconada', '47001', 41.65307, -4.72931, 'address', 'openstreetmap:way/60495510');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '47');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 47 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '47'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 27 THEN
    RAISE EXCEPTION 'Se esperaban 27 puntos de Correos en Valladolid, hay %', n;
  END IF;
END;
$$;

COMMIT;

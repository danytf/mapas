-- Carga de la categoría Correos de Cantabria (provincia 39), trozo de la carga de Andalucía.
-- Origen: postal_service-cantabria.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 30 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-cantabria:postal_service:node-10997145143', 'Correos Ampuero – Avenida Federico Somarriba', NULL, '39002', 'Avenida Federico Somarriba 5', '39840', 43.34385, -3.41802, 'address', 'openstreetmap:node/10997145143'),
  ('catalogo-cantabria:postal_service:node-11462196551', 'Correos Santander – Calle de Francisco Tomás y Valiente', NULL, '39075', 'Calle de Francisco Tomás y Valiente', '39011', 43.43709, -3.84024, 'address', 'openstreetmap:node/11462196551'),
  ('catalogo-cantabria:postal_service:node-12878586975', 'Correos Voto – Bádames', NULL, '39102', 'Bádames', '39764', 43.35559, -3.49799, 'address', 'openstreetmap:node/12878586975'),
  ('catalogo-cantabria:postal_service:node-13250006953', 'Correos Camargo – Calle de Juan XXIII', NULL, '39016', 'Calle de Juan XXIII 3', '39600', 43.41883, -3.84404, 'address', 'openstreetmap:node/13250006953'),
  ('catalogo-cantabria:postal_service:node-13314471122', 'Correos El Astillero – Calle de la Industria', NULL, '39008', 'Calle de la Industria 13', '39610', 43.39995, -3.82323, 'address', 'openstreetmap:node/13314471122'),
  ('catalogo-cantabria:postal_service:node-13709239252', 'Correos Arenas de Iguña – Barrio El Arrabal', NULL, '39004', 'Barrio El Arrabal', NULL, 43.18499, -4.04872, 'address', 'openstreetmap:node/13709239252'),
  ('catalogo-cantabria:postal_service:node-1545684028', 'Correos Reinosa – Plaza Manuel Llano Rebanal', NULL, '39059', 'Plaza Manuel Llano Rebanal 6', '39200', 42.99817, -4.14013, 'address', 'openstreetmap:node/1545684028'),
  ('catalogo-cantabria:postal_service:node-1912656973', 'Correos Potes – Calle de la Serna', NULL, '39055', 'Calle de la Serna 3', '39570', 43.15403, -4.62445, 'address', 'openstreetmap:node/1912656973'),
  ('catalogo-cantabria:postal_service:node-2091569777', 'Correos Laredo – Calle del Padre Ignacio Ellacuría', NULL, '39035', 'Calle del Padre Ignacio Ellacuría', '39770', 43.41036, -3.41697, 'address', 'openstreetmap:node/2091569777'),
  ('catalogo-cantabria:postal_service:node-2297583089', 'Correos Reocín – Barrio La Teja', NULL, '39060', 'Barrio La Teja', '39530', 43.35779, -4.08869, 'address', 'openstreetmap:node/2297583089'),
  ('catalogo-cantabria:postal_service:node-2302819312', 'Correos San Vicente de la Barquera – Paseo de la Barquera', NULL, '39080', 'Paseo de la Barquera', '39540', 43.38757, -4.39892, 'address', 'openstreetmap:node/2302819312'),
  ('catalogo-cantabria:postal_service:node-2309909425', 'Correos Piélagos – Avenida de Luis de la Concha', NULL, '39052', 'Avenida de Luis de la Concha', '39470', 43.35454, -3.95358, 'address', 'openstreetmap:node/2309909425'),
  ('catalogo-cantabria:postal_service:node-2725362843', 'Correos Ramales de la Victoria – Calle Trefilería', NULL, '39057', 'Calle Trefilería 5', '39850', 43.25688, -3.46612, 'address', 'openstreetmap:node/2725362843'),
  ('catalogo-cantabria:postal_service:node-2730157019', 'Correos Castro-Urdiales – Calle de Aranzal', NULL, '39020', 'Calle de Aranzal 11', '39700', 43.38384, -3.22372, 'address', 'openstreetmap:node/2730157019'),
  ('catalogo-cantabria:postal_service:node-2756042093', 'Correos Comillas – Marqués de Comillas', NULL, '39024', 'Marqués de Comillas 26', '39520', 43.38487, -4.29558, 'address', 'openstreetmap:node/2756042093'),
  ('catalogo-cantabria:postal_service:node-3042367082', 'Correos Villacarriedo – Barrio Villacarriedo', NULL, '39098', 'Barrio Villacarriedo', NULL, 43.22814, -3.81199, 'address', 'openstreetmap:node/3042367082'),
  ('catalogo-cantabria:postal_service:node-3267641335', 'Correos Valderredible – Plaza Valderredible', NULL, '39094', 'Plaza Valderredible 1', '39220', 42.80567, -3.94073, 'address', 'openstreetmap:node/3267641335'),
  ('catalogo-cantabria:postal_service:node-3300588865', 'Correos Ribamontán al Mar – Avenida de Trasmiera', NULL, '39061', 'Avenida de Trasmiera', '39140', 43.45337, -3.74266, 'address', 'openstreetmap:node/3300588865'),
  ('catalogo-cantabria:postal_service:node-4606092838', 'Correos Santander – Calle Vargas', NULL, '39075', 'Calle Vargas 73', '39010', 43.45849, -3.82546, 'address', 'openstreetmap:node/4606092838'),
  ('catalogo-cantabria:postal_service:node-5162281327', 'Correos Santoña – Calle Aro', NULL, '39079', 'Calle Aro 6', '39740', 43.44405, -3.45647, 'address', 'openstreetmap:node/5162281327'),
  ('catalogo-cantabria:postal_service:node-5555186599', 'Correos Santander – Calle de las Cruces', NULL, '39075', 'Calle de las Cruces 6', '39005', 43.47345, -3.78569, 'address', 'openstreetmap:node/5555186599'),
  ('catalogo-cantabria:postal_service:node-5834308787', 'Correos Los Corrales de Buelna – Calle Andalucía', NULL, '39025', 'Calle Andalucía 8', '39400', 43.25802, -4.06974, 'address', 'openstreetmap:node/5834308787'),
  ('catalogo-cantabria:postal_service:node-6193800057', 'Correos Noja – Avenida de Alcarite', NULL, '39047', 'Avenida de Alcarite', NULL, 43.48298, -3.52316, 'address', 'openstreetmap:node/6193800057'),
  ('catalogo-cantabria:postal_service:node-7775299954', 'Correos Castro-Urdiales – Calle Siglo XX', NULL, '39020', 'Calle Siglo XX', '39700', 43.38386, -3.21988, 'address', 'openstreetmap:node/7775299954'),
  ('catalogo-cantabria:postal_service:node-862133577', 'Correos Suances – Calle Ceballos', NULL, '39085', 'Calle Ceballos', '39340', 43.42684, -4.04207, 'address', 'openstreetmap:node/862133577'),
  ('catalogo-cantabria:postal_service:node-924264391', 'Correos Colindres – Calle de José María Alonso Blanco', NULL, '39023', 'Calle de José María Alonso Blanco 10', '39750', 43.39314, -3.45419, 'address', 'openstreetmap:node/924264391'),
  ('catalogo-cantabria:postal_service:node-9271772469', 'Correos Liérganes – Calle del Marqués de Valdecilla', NULL, '39037', 'Calle del Marqués de Valdecilla 8', '39722', 43.34186, -3.74232, 'address', 'openstreetmap:node/9271772469'),
  ('catalogo-cantabria:postal_service:way-1082650158', 'Correos Riotuerto – Paseo del Marqués de Valdecilla', NULL, '39064', 'Paseo del Marqués de Valdecilla 12', '39720', 43.35093, -3.70624, 'address', 'openstreetmap:way/1082650158'),
  ('catalogo-cantabria:postal_service:way-509979798', 'Correos Corvera de Toranzo – Avenida de Antonio Diego Manteca', NULL, '39026', 'Avenida de Antonio Diego Manteca', '39680', 43.19844, -3.92243, 'address', 'openstreetmap:way/509979798'),
  ('catalogo-cantabria:postal_service:way-705245419', 'Correos Santander – Plaza de Alfonso XIII', NULL, '39075', 'Plaza de Alfonso XIII', '39002', 43.46133, -3.80683, 'address', 'openstreetmap:way/705245419');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '39');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 39 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '39'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 30 THEN
    RAISE EXCEPTION 'Se esperaban 30 puntos de Correos en Cantabria, hay %', n;
  END IF;
END;
$$;

COMMIT;

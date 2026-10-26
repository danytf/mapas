-- Carga de la categoría Correos de Huesca (provincia 22), trozo de la carga de Andalucía.
-- Origen: postal_service-aragon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 26 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-aragon:postal_service:node-10047716447', 'Correos Bielsa – Calle Baja', NULL, '22057', 'Calle Baja', '22350', 42.6335, 0.21927, 'address', 'openstreetmap:node/10047716447'),
  ('catalogo-aragon:postal_service:node-10314578127', 'Correos Tardienta – Avenida José María Peleato', NULL, '22226', 'Avenida José María Peleato', NULL, 41.97774, -0.53717, 'address', 'openstreetmap:node/10314578127'),
  ('catalogo-aragon:postal_service:node-10592200648', 'Correos Almudévar – Calle Mayor', NULL, '22021', 'Calle Mayor', NULL, 42.04268, -0.58343, 'address', 'openstreetmap:node/10592200648'),
  ('catalogo-aragon:postal_service:node-1096300910', 'Correos Fraga – Calle de Caracas', NULL, '22112', 'Calle de Caracas 8', '22520', 41.52161, 0.33862, 'address', 'openstreetmap:node/1096300910'),
  ('catalogo-aragon:postal_service:node-12188500635', 'Correos Jaca – Calle de Correos', NULL, '22130', 'Calle de Correos 11', '22700', 42.56838, -0.55252, 'address', 'openstreetmap:node/12188500635'),
  ('catalogo-aragon:postal_service:node-12717107508', 'Correos Tamarite de Litera / Tamarit de Llitera – Plaza de la Inmaculada Concepción', NULL, '22225', 'Plaza de la Inmaculada Concepción 2', '22550', 41.86781, 0.42275, 'address', 'openstreetmap:node/12717107508'),
  ('catalogo-aragon:postal_service:node-1323636475', 'Correos Valle de Hecho – Calle Mayor', NULL, '22901', 'Calle Mayor', '22720', 42.73888, -0.75003, 'address', 'openstreetmap:node/1323636475'),
  ('catalogo-aragon:postal_service:node-14225203524', 'Correos Benasque – Plaza Ayuntamiento', NULL, '22054', 'Plaza Ayuntamiento', '22440', 42.60541, 0.52392, 'address', 'openstreetmap:node/14225203524'),
  ('catalogo-aragon:postal_service:node-1491228866', 'Correos Biescas – Plaza Ayuntamiento', NULL, '22059', 'Plaza Ayuntamiento 1', '22630', 42.62848, -0.32124, 'address', 'openstreetmap:node/1491228866'),
  ('catalogo-aragon:postal_service:node-1947907442', 'Correos Monzón – Avenida Lérida', NULL, '22158', 'Avenida Lérida 4', NULL, 41.91083, 0.19624, 'address', 'openstreetmap:node/1947907442'),
  ('catalogo-aragon:postal_service:node-2538259794', 'Correos Huesca/Uesca – Plaza de la Inmaculada', NULL, '22125', 'Plaza de la Inmaculada 2', '22003', 42.13873, -0.41075, 'address', 'openstreetmap:node/2538259794'),
  ('catalogo-aragon:postal_service:node-2889249311', 'Correos Ayerbe – Calle de Garlín', NULL, '22039', 'Calle de Garlín 2', '22800', 42.27477, -0.68654, 'address', 'openstreetmap:node/2889249311'),
  ('catalogo-aragon:postal_service:node-2894441574', 'Correos Broto – Avenida de Ordesa', NULL, '22069', 'Avenida de Ordesa 1', '22370', 42.60344, -0.12153, 'address', 'openstreetmap:node/2894441574'),
  ('catalogo-aragon:postal_service:node-3801991750', 'Correos Canfranc – Avenida de los Arañones', NULL, '22078', 'Avenida de los Arañones', '22880', 42.74719, -0.51572, 'address', 'openstreetmap:node/3801991750'),
  ('catalogo-aragon:postal_service:node-3843178614', 'Correos Sabiñánigo – Calle del Serrablo', NULL, '22199', 'Calle del Serrablo 92', '22600', 42.51825, -0.36466, 'address', 'openstreetmap:node/3843178614'),
  ('catalogo-aragon:postal_service:node-3856526861', 'Correos Panticosa – Calle de la Cruz', NULL, '22170', 'Calle de la Cruz 27', '22661', 42.72368, -0.28457, 'address', 'openstreetmap:node/3856526861'),
  ('catalogo-aragon:postal_service:node-428459118', 'Correos Albalate de Cinca – Calle Juan I de Aragón', NULL, '22007', 'Calle Juan I de Aragón', NULL, 41.72276, 0.14562, 'address', 'openstreetmap:node/428459118'),
  ('catalogo-aragon:postal_service:node-433581219', 'Correos Boltaña – Calle San Pablo', NULL, '22066', 'Calle San Pablo 8', '22340', 42.44579, 0.06767, 'address', 'openstreetmap:node/433581219'),
  ('catalogo-aragon:postal_service:node-513898724', 'Correos Fiscal – Calle Eras Altas', NULL, '22109', 'Calle Eras Altas', NULL, 42.49556, -0.12045, 'address', 'openstreetmap:node/513898724'),
  ('catalogo-aragon:postal_service:node-5649950945', 'Correos Aínsa-Sobrarbe/L''Aínsa-Sobrarbe – Avenida de Ordesa', NULL, '22907', 'Avenida de Ordesa 12', '22330', 42.41458, 0.13942, 'address', 'openstreetmap:node/5649950945'),
  ('catalogo-aragon:postal_service:node-5961007634', 'Correos Binéfar – Calle Antonio Sistac', NULL, '22061', 'Calle Antonio Sistac', '22500', 41.84847, 0.29325, 'address', 'openstreetmap:node/5961007634'),
  ('catalogo-aragon:postal_service:node-9562449887', 'Correos Plan – Calle Larga', NULL, '22182', 'Calle Larga', '22367', 42.58154, 0.3378, 'address', 'openstreetmap:node/9562449887'),
  ('catalogo-aragon:postal_service:node-9835703638', 'Correos Benabarre / Benavarri – Plaza Mayor', NULL, '22053', 'Plaza Mayor', '22580', 42.10614, 0.48117, 'address', 'openstreetmap:node/9835703638'),
  ('catalogo-aragon:postal_service:way-367628296', 'Correos Huesca/Uesca – Coso Alto', NULL, '22125', 'Coso Alto 16', '22002', 42.13766, -0.40902, 'address', 'openstreetmap:way/367628296'),
  ('catalogo-aragon:postal_service:way-427648860', 'Correos Torla-Ordesa – Calle A. Ruata', NULL, '22230', 'Calle A. Ruata', '22376', 42.62783, -0.11219, 'address', 'openstreetmap:way/427648860'),
  ('catalogo-aragon:postal_service:way-655709518', 'Correos Sallent de Gállego – Calle Bozocarro', NULL, '22204', 'Calle Bozocarro', '22640', 42.77195, -0.33215, 'address', 'openstreetmap:way/655709518');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '22');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 22 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '22'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 26 THEN
    RAISE EXCEPTION 'Se esperaban 26 puntos de Correos en Huesca, hay %', n;
  END IF;
END;
$$;

COMMIT;

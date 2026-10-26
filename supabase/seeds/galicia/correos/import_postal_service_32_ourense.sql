-- Carga de la categoría Correos de Ourense (provincia 32), trozo de la carga de Andalucía.
-- Origen: postal_service-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 32 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-galicia:postal_service:node-10699610606', 'Correos Ourense – Avenida de Marín', NULL, '32054', 'Avenida de Marín', '32001', 42.34965, -7.87017, 'address', 'openstreetmap:node/10699610606'),
  ('catalogo-galicia:postal_service:node-11175688562', 'Correos O Carballiño – Rúa de Faustino Santalices', NULL, '32019', 'Rúa de Faustino Santalices', '32500', 42.4293, -8.07593, 'address', 'openstreetmap:node/11175688562'),
  ('catalogo-galicia:postal_service:node-11304524470', 'Correos Esgos – Rúa da Souteira', NULL, '32031', 'Rúa da Souteira', '32720', 42.32528, -7.69648, 'address', 'openstreetmap:node/11304524470'),
  ('catalogo-galicia:postal_service:node-12739204720', 'Correos A Merca – Camiño do Campo de Fútbol', NULL, '32047', 'Camiño do Campo de Fútbol', NULL, 42.2192, -7.90858, 'address', 'openstreetmap:node/12739204720'),
  ('catalogo-galicia:postal_service:node-12752559199', 'Correos O Castro de Caldelas – Avenida de Ourense', NULL, '32023', 'Avenida de Ourense 22', '32760', 42.3739, -7.41844, 'address', 'openstreetmap:node/12752559199'),
  ('catalogo-galicia:postal_service:node-12964543035', 'Correos Viana do Bolo – Rúa de Santa Marta', NULL, '32086', 'Rúa de Santa Marta', '32550', 42.17991, -7.1117, 'address', 'openstreetmap:node/12964543035'),
  ('catalogo-galicia:postal_service:node-13140738199', 'Correos Quintela de Leirado – Leirado', NULL, '32066', 'Leirado', '32814', 42.1299, -8.08962, 'address', 'openstreetmap:node/13140738199'),
  ('catalogo-galicia:postal_service:node-13200832736', 'Correos Rairiz de Veiga – Praza do Concello', NULL, '32067', 'Praza do Concello', NULL, 42.08178, -7.83164, 'address', 'openstreetmap:node/13200832736'),
  ('catalogo-galicia:postal_service:node-13369933144', 'Correos Cortegada – Rúa Otero Novas', NULL, '32027', 'Rúa Otero Novas 1', NULL, 42.20621, -8.17141, 'address', 'openstreetmap:node/13369933144'),
  ('catalogo-galicia:postal_service:node-13438402319', 'Correos A Peroxa', NULL, '32059', NULL, '32150', 42.44056, -7.79426, 'address', 'openstreetmap:node/13438402319'),
  ('catalogo-galicia:postal_service:node-13784815605', 'Correos Leiro – Rúa Real', NULL, '32040', 'Rúa Real', NULL, 42.3714, -8.12635, 'address', 'openstreetmap:node/13784815605'),
  ('catalogo-galicia:postal_service:node-13935592846', 'Correos Cartelle – Praza do Toxal', NULL, '32020', 'Praza do Toxal', NULL, 42.22512, -8.01913, 'address', 'openstreetmap:node/13935592846'),
  ('catalogo-galicia:postal_service:node-14288064841', 'Correos Calvos de Randín – Camiño da Laborada', NULL, '32016', 'Camiño da Laborada', NULL, 41.94711, -7.89658, 'address', 'openstreetmap:node/14288064841'),
  ('catalogo-galicia:postal_service:node-1472245056', 'Correos Lobios – Rúa dos Comercios', NULL, '32042', 'Rúa dos Comercios', '32870', 41.90376, -8.08307, 'address', 'openstreetmap:node/1472245056'),
  ('catalogo-galicia:postal_service:node-1527972602', 'Correos A Rúa – Camiño da Lagúa', NULL, '32072', 'Camiño da Lagúa', '32350', 42.39347, -7.11065, 'address', 'openstreetmap:node/1527972602'),
  ('catalogo-galicia:postal_service:node-1704221840', 'Correos Ribadavia – Avenida de Redondela', NULL, '32069', 'Avenida de Redondela', '32400', 42.28536, -8.14513, 'address', 'openstreetmap:node/1704221840'),
  ('catalogo-galicia:postal_service:node-4505224420', 'Correos A Veiga – Rúa Nova', NULL, '32083', 'Rúa Nova', '32360', 42.25123, -7.02534, 'address', 'openstreetmap:node/4505224420'),
  ('catalogo-galicia:postal_service:node-4679355068', 'Correos A Gudiña – Travesía do Correo', NULL, '32034', 'Travesía do Correo', NULL, 42.06059, -7.14002, 'address', 'openstreetmap:node/4679355068'),
  ('catalogo-galicia:postal_service:node-5851420406', 'Correos Allariz – Rúa Oliveira', NULL, '32001', 'Rúa Oliveira 6', '32664', 42.18769, -7.80405, 'address', 'openstreetmap:node/5851420406'),
  ('catalogo-galicia:postal_service:node-6131061259', 'Correos O Barco de Valdeorras – Rúa Doutor Pérez Lista', NULL, '32009', 'Rúa Doutor Pérez Lista', '32300', 42.41498, -6.98257, 'address', 'openstreetmap:node/6131061259'),
  ('catalogo-galicia:postal_service:node-6341828316', 'Correos Celanova – Avenida de Francisco González Rey', NULL, '32024', 'Avenida de Francisco González Rey', '32800', 42.15415, -7.95486, 'address', 'openstreetmap:node/6341828316'),
  ('catalogo-galicia:postal_service:node-7127124752', 'Correos Cenlle – Praza de Barbantes', NULL, '32025', 'Praza de Barbantes', '32450', 42.33917, -8.01162, 'address', 'openstreetmap:node/7127124752'),
  ('catalogo-galicia:postal_service:node-8117334622', 'Correos San Xoán de Río – Camiño da Nogueira', NULL, '32070', 'Camiño da Nogueira', '32770', 42.37138, -7.29846, 'address', 'openstreetmap:node/8117334622'),
  ('catalogo-galicia:postal_service:way-1009272163', 'Correos A Pobra de Trives – Rúa Hermanos de La Salle', NULL, '32063', 'Rúa Hermanos de La Salle 12', '32780', 42.33786, -7.25249, 'address', 'openstreetmap:way/1009272163'),
  ('catalogo-galicia:postal_service:way-1013125286', 'Correos Maceda – Rúa do Castelo', NULL, '32043', 'Rúa do Castelo 2', '32700', 42.27064, -7.65387, 'address', 'openstreetmap:way/1013125286'),
  ('catalogo-galicia:postal_service:way-1534262531', 'Correos San Cristovo de Cea – Rua Lodairo', NULL, '32076', 'Rua Lodairo 1', '32130', 42.47538, -7.98464, 'address', 'openstreetmap:way/1534262531'),
  ('catalogo-galicia:postal_service:way-173527351', 'Correos Ourense – Avenida de Marín', NULL, '32054', 'Avenida de Marín', '32001', 42.3501, -7.87189, 'address', 'openstreetmap:way/173527351'),
  ('catalogo-galicia:postal_service:way-173740517', 'Correos Ourense – Calle Tras Alameda', NULL, '32054', 'Calle Tras Alameda', '32001', 42.33648, -7.86625, 'address', 'openstreetmap:way/173740517'),
  ('catalogo-galicia:postal_service:way-197261578', 'Correos Carballeda de Avia – Rúa Rosalía de Castro', NULL, '32018', 'Rúa Rosalía de Castro', NULL, 42.32025, -8.16545, 'address', 'openstreetmap:way/197261578'),
  ('catalogo-galicia:postal_service:way-249412399', 'Correos Verín – Rúa Irmáns La Salle', NULL, '32085', 'Rúa Irmáns La Salle', '32600', 41.93891, -7.43673, 'address', 'openstreetmap:way/249412399'),
  ('catalogo-galicia:postal_service:way-421803220', 'Correos Xinzo de Limia – Rúa do Cruceiro', NULL, '32032', 'Rúa do Cruceiro', NULL, 42.06435, -7.72446, 'address', 'openstreetmap:way/421803220'),
  ('catalogo-galicia:postal_service:way-587044868', 'Correos Nogueira de Ramuín – Camiño de Baldomar', NULL, '32052', 'Camiño de Baldomar', NULL, 42.41214, -7.72717, 'address', 'openstreetmap:way/587044868');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '32');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 32 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '32'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 32 THEN
    RAISE EXCEPTION 'Se esperaban 32 puntos de Correos en Ourense, hay %', n;
  END IF;
END;
$$;

COMMIT;

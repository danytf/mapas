-- Carga de la categoría Correos de Almería (provincia 04), trozo de la carga de Andalucía.
-- Origen: postal_service-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 35 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:postal_service:node-10017803879', 'Correos Roquetas de Mar – Avenida Rey Juan Carlos I', NULL, '04079', 'Avenida Rey Juan Carlos I', '04740', 36.76676, -2.60939, 'address', 'openstreetmap:node/10017803879'),
  ('catalogo-andalucia:postal_service:node-11498799837', 'Correos Mojácar – Avenida de Andalucía', NULL, '04064', 'Avenida de Andalucía 25', '04638', 37.13514, -1.83235, 'address', 'openstreetmap:node/11498799837'),
  ('catalogo-andalucia:postal_service:node-11532965733', 'Correos Mojácar – Plaza Frontón', NULL, '04064', 'Plaza Frontón 1', '04638', 37.14027, -1.85204, 'address', 'openstreetmap:node/11532965733'),
  ('catalogo-andalucia:postal_service:node-11575643136', 'Correos Mojácar – Calle Glorieta', NULL, '04064', 'Calle Glorieta 1', '04638', 37.14103, -1.85137, 'address', 'openstreetmap:node/11575643136'),
  ('catalogo-andalucia:postal_service:node-12198094076', 'Correos Garrucha – Calle de Hernán Cortés', NULL, '04049', 'Calle de Hernán Cortés 4', '04630', 37.17889, -1.82244, 'address', 'openstreetmap:node/12198094076'),
  ('catalogo-andalucia:postal_service:node-12399714484', 'Correos Cantoria – Calle San Cayetano', NULL, '04031', 'Calle San Cayetano', '04850', 37.35237, -2.19227, 'address', 'openstreetmap:node/12399714484'),
  ('catalogo-andalucia:postal_service:node-12430759662', 'Correos Almería – Calle San Juan', NULL, '04013', 'Calle San Juan', '04002', 36.83748, -2.47151, 'address', 'openstreetmap:node/12430759662'),
  ('catalogo-andalucia:postal_service:node-12431167724', 'Correos Roquetas de Mar – Avenida de Carlos III', NULL, '04079', 'Avenida de Carlos III', '04720', 36.8169, -2.56443, 'address', 'openstreetmap:node/12431167724'),
  ('catalogo-andalucia:postal_service:node-12612869915', 'Correos Canjáyar – Avenida de las Alpujarras', NULL, '04030', 'Avenida de las Alpujarras', '04459', 37.00925, -2.74069, 'address', 'openstreetmap:node/12612869915'),
  ('catalogo-andalucia:postal_service:node-1620480315', 'Correos Tíjola – Calle Jorquera', NULL, '04092', 'Calle Jorquera', '04880', 37.34549, -2.44065, 'address', 'openstreetmap:node/1620480315'),
  ('catalogo-andalucia:postal_service:node-1921489441', 'Correos Sorbas – Calle Tomás Valera', NULL, '04086', 'Calle Tomás Valera', '04270', 37.09725, -2.12247, 'address', 'openstreetmap:node/1921489441'),
  ('catalogo-andalucia:postal_service:node-2409738795', 'Correos Abla – Calle Adolfo Martinez', NULL, '04001', 'Calle Adolfo Martinez', '04510', 37.14399, -2.7773, 'address', 'openstreetmap:node/2409738795'),
  ('catalogo-andalucia:postal_service:node-2493407909', 'Correos Almería – Calle San Juan Bosco', NULL, '04013', 'Calle San Juan Bosco', '04005', 36.8426, -2.45594, 'address', 'openstreetmap:node/2493407909'),
  ('catalogo-andalucia:postal_service:node-2679642600', 'Correos Carboneras – Paseo maritimo', NULL, '04032', 'Paseo maritimo', '04140', 36.99676, -1.89086, 'address', 'openstreetmap:node/2679642600'),
  ('catalogo-andalucia:postal_service:node-2692568248', 'Correos Vícar – Calle Zurgena', NULL, '04102', 'Calle Zurgena', '04738', 36.8021, -2.64315, 'address', 'openstreetmap:node/2692568248'),
  ('catalogo-andalucia:postal_service:node-289013753', 'Correos Olula del Río – Cuesta del Cartero', NULL, '04069', 'Cuesta del Cartero', '04860', 37.35511, -2.29565, 'address', 'openstreetmap:node/289013753'),
  ('catalogo-andalucia:postal_service:node-3058917019', 'Correos Níjar – Calle Benahadux', NULL, '04066', 'Calle Benahadux', '04110', 36.93411, -2.13576, 'address', 'openstreetmap:node/3058917019'),
  ('catalogo-andalucia:postal_service:node-3085045370', 'Correos Níjar – Calle Costa Rica', NULL, '04066', 'Calle Costa Rica', '04117', 36.90547, -2.17661, 'address', 'openstreetmap:node/3085045370'),
  ('catalogo-andalucia:postal_service:node-321604371', 'Correos Almería – Calle Gibraltar Español', NULL, '04013', 'Calle Gibraltar Español 25', '04007', 36.82994, -2.45374, 'address', 'openstreetmap:node/321604371'),
  ('catalogo-andalucia:postal_service:node-4333638441', 'Correos Huércal-Overa – Avenida de Guillermo Reina', NULL, '04053', 'Avenida de Guillermo Reina', '04600', 37.39812, -1.94242, 'address', 'openstreetmap:node/4333638441'),
  ('catalogo-andalucia:postal_service:node-4481432559', 'Correos Almería – Calle Emilio Pérez', NULL, '04013', 'Calle Emilio Pérez', '04150', 36.78199, -2.2427, 'address', 'openstreetmap:node/4481432559'),
  ('catalogo-andalucia:postal_service:node-4650254194', 'Correos Adra – Carrera de Natalio Rivas', NULL, '04003', 'Carrera de Natalio Rivas 83', '04770', 36.74818, -3.01829, 'address', 'openstreetmap:node/4650254194'),
  ('catalogo-andalucia:postal_service:node-4962458897', 'Correos Cuevas del Almanzora – Calle Hospicio', NULL, '04035', 'Calle Hospicio', '04610', 37.2974, -1.87809, 'address', 'openstreetmap:node/4962458897'),
  ('catalogo-andalucia:postal_service:node-5985238813', 'Correos Almería – Calle Abedul', NULL, '04013', 'Calle Abedul', '04130', 36.85169, -2.3546, 'address', 'openstreetmap:node/5985238813'),
  ('catalogo-andalucia:postal_service:node-7196134382', 'Correos Dalías – Calle Rambla de Gracia', NULL, '04038', 'Calle Rambla de Gracia', '04750', 36.82141, -2.87064, 'address', 'openstreetmap:node/7196134382'),
  ('catalogo-andalucia:postal_service:node-7707318507', 'Correos Vélez-Rubio – Carrera del Carmen', NULL, '04099', 'Carrera del Carmen', '04820', 37.64795, -2.07544, 'address', 'openstreetmap:node/7707318507'),
  ('catalogo-andalucia:postal_service:node-8416247712', 'Correos Cantoria – Calle la Cuesta', NULL, '04031', 'Calle la Cuesta', '04815', 37.34971, -2.13309, 'address', 'openstreetmap:node/8416247712'),
  ('catalogo-andalucia:postal_service:node-8948583520', 'Correos Cuevas del Almanzora – Calle Maestros Don Paco y Doña Conchita', NULL, '04035', 'Calle Maestros Don Paco y Doña Conchita', '04617', 37.24761, -1.79886, 'address', 'openstreetmap:node/8948583520'),
  ('catalogo-andalucia:postal_service:node-8975075225', 'Correos Oria – Calle Almería', NULL, '04070', 'Calle Almería', NULL, 37.48521, -2.29518, 'address', 'openstreetmap:node/8975075225'),
  ('catalogo-andalucia:postal_service:node-9332384560', 'Correos Vera – Calle Mayor', NULL, '04100', 'Calle Mayor 7', '04620', 37.24739, -1.86877, 'address', 'openstreetmap:node/9332384560'),
  ('catalogo-andalucia:postal_service:way-1341775103', 'Correos Cantoria – Avenida de Oriente', NULL, '04031', 'Avenida de Oriente', '04850', 37.35315, -2.19052, 'address', 'openstreetmap:way/1341775103'),
  ('catalogo-andalucia:postal_service:way-300621965', 'Correos Tabernas – Avenida de las Angustias', NULL, '04088', 'Avenida de las Angustias 14', '04200', 37.0497, -2.39366, 'address', 'openstreetmap:way/300621965'),
  ('catalogo-andalucia:postal_service:way-303186838', 'Correos Níjar – Calle el Parque', NULL, '04066', 'Calle el Parque', '04100', 36.96476, -2.20823, 'address', 'openstreetmap:way/303186838'),
  ('catalogo-andalucia:postal_service:way-642610716', 'Correos Almería – Calle Tabernas', NULL, '04013', 'Calle Tabernas', '04006', 36.84262, -2.4377, 'address', 'openstreetmap:way/642610716'),
  ('catalogo-andalucia:postal_service:way-754573165', 'Correos Albox – Calle de Partaloa', NULL, '04006', 'Calle de Partaloa', '04800', 37.3862, -2.14762, 'address', 'openstreetmap:way/754573165');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 35 THEN
    RAISE EXCEPTION 'Se esperaban 35 puntos de Correos en Almería, hay %', n;
  END IF;
END;
$$;

COMMIT;

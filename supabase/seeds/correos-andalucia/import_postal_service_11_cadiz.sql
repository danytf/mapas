-- Carga de la categoría Correos de Cádiz (provincia 11), trozo de la carga de Andalucía.
-- Origen: postal_service-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 51 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:postal_service:node-10185824032', 'Correos Cádiz – Avenida María Auxiliadora', NULL, '11012', 'Avenida María Auxiliadora 3', '11009', 36.51378, -6.27973, 'address', 'openstreetmap:node/10185824032'),
  ('catalogo-andalucia:postal_service:node-1055488100', 'Correos Puerto Real – Plaza de Blas Infante', NULL, '11028', 'Plaza de Blas Infante', '11510', 36.52747, -6.18801, 'address', 'openstreetmap:node/1055488100'),
  ('catalogo-andalucia:postal_service:node-10574981647', 'Correos Medina Sidonia', NULL, '11023', NULL, '11170', 36.46496, -5.92753, 'address', 'openstreetmap:node/10574981647'),
  ('catalogo-andalucia:postal_service:node-10695939685', 'Correos Vejer de la Frontera – Avenida Rey Juan Carlos I', NULL, '11039', 'Avenida Rey Juan Carlos I', '11150', 36.2536, -5.97017, 'address', 'openstreetmap:node/10695939685'),
  ('catalogo-andalucia:postal_service:node-10790579171', 'Correos San Roque – Calle Doctor Fleming', NULL, '11033', 'Calle Doctor Fleming', '11314', 36.17821, -5.3788, 'address', 'openstreetmap:node/10790579171'),
  ('catalogo-andalucia:postal_service:node-10868369621', 'Correos Barbate – Calle de Camilo José Cela', NULL, '11007', 'Calle de Camilo José Cela', '11160', 36.19433, -5.91913, 'address', 'openstreetmap:node/10868369621'),
  ('catalogo-andalucia:postal_service:node-11116101898', 'Correos Tarifa – Calle Privilegios', NULL, '11035', 'Calle Privilegios', '11380', 36.01296, -5.60196, 'address', 'openstreetmap:node/11116101898'),
  ('catalogo-andalucia:postal_service:node-11118683005', 'Correos Rota – Calle Enríquez', NULL, '11030', 'Calle Enríquez', '11520', 36.63801, -6.33098, 'address', 'openstreetmap:node/11118683005'),
  ('catalogo-andalucia:postal_service:node-11133624906', 'Correos Benalup-Casas Viejas – Calle Malvasía', NULL, '11901', 'Calle Malvasía', '11190', 36.34484, -5.81581, 'address', 'openstreetmap:node/11133624906'),
  ('catalogo-andalucia:postal_service:node-1118474485', 'Correos Grazalema – Calle José María Jiménez', NULL, '11019', 'Calle José María Jiménez', '11610', 36.75857, -5.36625, 'address', 'openstreetmap:node/1118474485'),
  ('catalogo-andalucia:postal_service:node-11191413435', 'Correos Sanlúcar de Barrameda – Avenida del Cerro Falón', NULL, '11032', 'Avenida del Cerro Falón 6', '11540', 36.78216, -6.35332, 'address', 'openstreetmap:node/11191413435'),
  ('catalogo-andalucia:postal_service:node-11351497117', 'Correos San Roque – Calle Hortensia', NULL, '11033', 'Calle Hortensia', '11368', 36.20551, -5.41925, 'address', 'openstreetmap:node/11351497117'),
  ('catalogo-andalucia:postal_service:node-11663824829', 'Correos San Roque – Calle Pi y Margall', NULL, '11033', 'Calle Pi y Margall', '11313', 36.18169, -5.38733, 'address', 'openstreetmap:node/11663824829'),
  ('catalogo-andalucia:postal_service:node-1240950439', 'Correos Benaocaz – Calle Gorito', NULL, '11009', 'Calle Gorito', '11612', 36.7016, -5.42204, 'address', 'openstreetmap:node/1240950439'),
  ('catalogo-andalucia:postal_service:node-12459177997', 'Correos Algeciras – Calle de Teide', NULL, '11004', 'Calle de Teide', '11206', 36.08361, -5.49756, 'address', 'openstreetmap:node/12459177997'),
  ('catalogo-andalucia:postal_service:node-12643278404', 'Correos Trebujena – Calle Veracruz', NULL, '11037', 'Calle Veracruz', '11560', 36.87022, -6.17465, 'address', 'openstreetmap:node/12643278404'),
  ('catalogo-andalucia:postal_service:node-13136295601', 'Correos Chiclana de la Frontera – Alameda Solano', NULL, '11015', 'Alameda Solano', '11120', 36.42544, -6.14426, 'address', 'openstreetmap:node/13136295601'),
  ('catalogo-andalucia:postal_service:node-1880468527', 'Correos San Roque – Calle Almoraima', NULL, '11033', 'Calle Almoraima', '11360', 36.21081, -5.38491, 'address', 'openstreetmap:node/1880468527'),
  ('catalogo-andalucia:postal_service:node-2379095909', 'Correos Espera – Calle Libertad', NULL, '11017', 'Calle Libertad', '11648', 36.87216, -5.80681, 'address', 'openstreetmap:node/2379095909'),
  ('catalogo-andalucia:postal_service:node-2574155490', 'Correos El Bosque – Calle Ronda', NULL, '11011', 'Calle Ronda', '11670', 36.75963, -5.50429, 'address', 'openstreetmap:node/2574155490'),
  ('catalogo-andalucia:postal_service:node-3072245357', 'Correos Algeciras – Radio Algeciras', NULL, '11004', 'Radio Algeciras 2', '11201', 36.13076, -5.44682, 'address', 'openstreetmap:node/3072245357'),
  ('catalogo-andalucia:postal_service:node-324582676', 'Correos El Puerto de Santa María – Calle Aurora', NULL, '11027', 'Calle Aurora', '11500', 36.5945, -6.22752, 'address', 'openstreetmap:node/324582676'),
  ('catalogo-andalucia:postal_service:node-3255508838', 'Correos Jerez de la Frontera – Avenida de la Universidad', NULL, '11020', 'Avenida de la Universidad', '11405', 36.68581, -6.1209, 'address', 'openstreetmap:node/3255508838'),
  ('catalogo-andalucia:postal_service:node-3346633237', 'Correos San Roque – Calle Ledesma', NULL, '11033', 'Calle Ledesma', '11368', 36.21241, -5.4309, 'address', 'openstreetmap:node/3346633237'),
  ('catalogo-andalucia:postal_service:node-3355896398', 'Correos San Fernando – Calle Real', NULL, '11031', 'Calle Real 113', '11100', 36.46416, -6.19796, 'address', 'openstreetmap:node/3355896398'),
  ('catalogo-andalucia:postal_service:node-3741080218', 'Correos Rota – Calle Rabeta Ruta', NULL, '11030', 'Calle Rabeta Ruta', '11520', 36.62104, -6.36243, 'address', 'openstreetmap:node/3741080218'),
  ('catalogo-andalucia:postal_service:node-4682282525', 'Correos Puerto Serrano – Calle Enmedio', NULL, '11029', 'Calle Enmedio', NULL, 36.9234, -5.5456, 'address', 'openstreetmap:node/4682282525'),
  ('catalogo-andalucia:postal_service:node-4710322166', 'Correos Villamartín – Avenida del Guadalete', NULL, '11041', 'Avenida del Guadalete', '11650', 36.85949, -5.6468, 'address', 'openstreetmap:node/4710322166'),
  ('catalogo-andalucia:postal_service:node-4728160606', 'Correos Bornos – Calle Ancha', NULL, '11010', 'Calle Ancha', '11649', 36.81743, -5.74177, 'address', 'openstreetmap:node/4728160606'),
  ('catalogo-andalucia:postal_service:node-4732771507', 'Correos San José del Valle – Avenida de la Independencia', NULL, '11902', 'Avenida de la Independencia', NULL, 36.60649, -5.8014, 'address', 'openstreetmap:node/4732771507'),
  ('catalogo-andalucia:postal_service:node-4745607227', 'Correos Jerez de la Frontera – Calle Cuartel', NULL, '11020', 'Calle Cuartel', '11570', 36.64965, -5.9318, 'address', 'openstreetmap:node/4745607227'),
  ('catalogo-andalucia:postal_service:node-4757825214', 'Correos Jerez de la Frontera – Calle Consultorio', NULL, '11020', 'Calle Consultorio', '11570', 36.60785, -5.9443, 'address', 'openstreetmap:node/4757825214'),
  ('catalogo-andalucia:postal_service:node-4784819446', 'Correos Jerez de la Frontera – Calle San Jerónimo', NULL, '11020', 'Calle San Jerónimo', '11592', 36.75846, -6.03165, 'address', 'openstreetmap:node/4784819446'),
  ('catalogo-andalucia:postal_service:node-4805566781', 'Correos Paterna de Rivera – Calle Padre Félix', NULL, '11025', 'Calle Padre Félix', '11178', 36.52223, -5.86578, 'address', 'openstreetmap:node/4805566781'),
  ('catalogo-andalucia:postal_service:node-5380326274', 'Correos Ubrique – Avenida España', NULL, '11038', 'Avenida España', '11600', 36.67628, -5.44648, 'address', 'openstreetmap:node/5380326274'),
  ('catalogo-andalucia:postal_service:node-676942573', 'Correos Algeciras – Calle Ruiz Zorrilla', NULL, '11004', 'Calle Ruiz Zorrilla', '11202', 36.13038, -5.4521, 'address', 'openstreetmap:node/676942573'),
  ('catalogo-andalucia:postal_service:node-677219484', 'Correos Chiclana de la Frontera – Alameda Lora', NULL, '11015', 'Alameda Lora', '11130', 36.41891, -6.15011, 'address', 'openstreetmap:node/677219484'),
  ('catalogo-andalucia:postal_service:node-8400138710', 'Correos Villaluenga del Rosario – Calle Nuestra Sra. del Rosario', NULL, '11040', 'Calle Nuestra Sra. del Rosario 15', '11611', 36.69678, -5.3871, 'address', 'openstreetmap:node/8400138710'),
  ('catalogo-andalucia:postal_service:node-8916363248', 'Correos San Martín del Tesorillo – Calle de las Vegas', NULL, '11903', 'Calle de las Vegas', '11340', 36.34115, -5.32293, 'address', 'openstreetmap:node/8916363248'),
  ('catalogo-andalucia:postal_service:node-9322083298', 'Correos Olvera – Calle Mercado', NULL, '11024', 'Calle Mercado', '11690', 36.93523, -5.26352, 'address', 'openstreetmap:node/9322083298'),
  ('catalogo-andalucia:postal_service:node-9557806028', 'Correos Cádiz – Plaza Topete', NULL, '11012', 'Plaza Topete', '11001', 36.53112, -6.29763, 'address', 'openstreetmap:node/9557806028'),
  ('catalogo-andalucia:postal_service:node-9656585662', 'Correos Alcalá del Valle – Calle Nueva', NULL, '11002', 'Calle Nueva', '11693', 36.90504, -5.17202, 'address', 'openstreetmap:node/9656585662'),
  ('catalogo-andalucia:postal_service:node-9912584455', 'Correos Barbate – Calle Rinconete y Cortadillo', NULL, '11007', 'Calle Rinconete y Cortadillo', '11393', 36.13571, -5.84385, 'address', 'openstreetmap:node/9912584455'),
  ('catalogo-andalucia:postal_service:node-9965398345', 'Correos Conil de la Frontera – Calle Toneleros', NULL, '11014', 'Calle Toneleros', '11140', 36.27859, -6.08856, 'address', 'openstreetmap:node/9965398345'),
  ('catalogo-andalucia:postal_service:relation-14977915', 'Correos Jerez de la Frontera – Calle Veracruz', NULL, '11020', 'Calle Veracruz', '11402', 36.68302, -6.1357, 'address', 'openstreetmap:relation/14977915'),
  ('catalogo-andalucia:postal_service:way-1331120733', 'Correos San Roque – Avenida Profesor Tierno Galván', NULL, '11033', 'Avenida Profesor Tierno Galván', '11311', 36.29804, -5.30488, 'address', 'openstreetmap:way/1331120733'),
  ('catalogo-andalucia:postal_service:way-162535886', 'Correos Cádiz – Avenida del Estrecho', NULL, '11012', 'Avenida del Estrecho', '11011', 36.50224, -6.27122, 'address', 'openstreetmap:way/162535886'),
  ('catalogo-andalucia:postal_service:way-396625917', 'Correos Jerez de la Frontera – Avenida del Progreso', NULL, '11020', 'Avenida del Progreso', '11407', 36.70916, -6.12419, 'address', 'openstreetmap:way/396625917'),
  ('catalogo-andalucia:postal_service:way-430399923', 'Correos Los Barrios – Paseo de Coca', NULL, '11008', 'Paseo de Coca', '11370', 36.18288, -5.49326, 'address', 'openstreetmap:way/430399923'),
  ('catalogo-andalucia:postal_service:way-514873129', 'Correos La Línea de la Concepción – Plaza de la Constitución', NULL, '11022', 'Plaza de la Constitución', '11300', 36.16082, -5.34781, 'address', 'openstreetmap:way/514873129'),
  ('catalogo-andalucia:postal_service:way-756215756', 'Correos Los Barrios – Paseo Marítimo', NULL, '11008', 'Paseo Marítimo', '11379', 36.17609, -5.44018, 'address', 'openstreetmap:way/756215756');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '11');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 11 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '11'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 51 THEN
    RAISE EXCEPTION 'Se esperaban 51 puntos de Correos en Cádiz, hay %', n;
  END IF;
END;
$$;

COMMIT;

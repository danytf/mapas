-- Carga de la categoría Correos de Córdoba (provincia 14), trozo de la carga de Andalucía.
-- Origen: postal_service-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 50 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:postal_service:node-11972176969', 'Correos Córdoba – Calle Villa de Rota', NULL, '14021', 'Calle Villa de Rota', '14071', 37.88644, -4.79048, 'address', 'openstreetmap:node/11972176969'),
  ('catalogo-andalucia:postal_service:node-1262576986', 'Correos Zuheros – Calle Fotógrafo José Jiménez Poyato', NULL, '14075', 'Calle Fotógrafo José Jiménez Poyato', '14870', 37.54266, -4.31606, 'address', 'openstreetmap:node/1262576986'),
  ('catalogo-andalucia:postal_service:node-1413482571', 'Correos Carcabuey – Calle Pilar', NULL, '14015', 'Calle Pilar', '14810', 37.44341, -4.27327, 'address', 'openstreetmap:node/1413482571'),
  ('catalogo-andalucia:postal_service:node-1657406754', 'Correos Montalbán de Córdoba – Calle Ancha', NULL, '14040', 'Calle Ancha', '14548', 37.58195, -4.74996, 'address', 'openstreetmap:node/1657406754'),
  ('catalogo-andalucia:postal_service:node-1657908768', 'Correos Córdoba – Avenida de Libia', NULL, '14021', 'Avenida de Libia', '14007', 37.8914, -4.75744, 'address', 'openstreetmap:node/1657908768'),
  ('catalogo-andalucia:postal_service:node-2099724616', 'Correos Villa del Río – Calle Alta', NULL, '14066', 'Calle Alta', '14640', 37.98129, -4.29193, 'address', 'openstreetmap:node/2099724616'),
  ('catalogo-andalucia:postal_service:node-2738962685', 'Correos Córdoba – Calle el Nogal', NULL, '14021', 'Calle el Nogal 23', '14006', 37.89773, -4.78483, 'address', 'openstreetmap:node/2738962685'),
  ('catalogo-andalucia:postal_service:node-2924555614', 'Correos Montilla – Calle Puerta de Aguilar', NULL, '14042', 'Calle Puerta de Aguilar', '14550', 37.58628, -4.63978, 'address', 'openstreetmap:node/2924555614'),
  ('catalogo-andalucia:postal_service:node-2992998210', 'Correos Santaella – Gitanilla', NULL, '14060', 'Gitanilla', '14549', 37.52547, -4.91873, 'address', 'openstreetmap:node/2992998210'),
  ('catalogo-andalucia:postal_service:node-3212499305', 'Correos Hinojosa del Duque – Calle Fontanilla', NULL, '14035', 'Calle Fontanilla 3', '14270', 38.49928, -5.14567, 'address', 'openstreetmap:node/3212499305'),
  ('catalogo-andalucia:postal_service:node-3414873604', 'Correos Santa Eufemia – Plaza Mayor', NULL, '14061', 'Plaza Mayor', NULL, 38.59509, -4.90303, 'address', 'openstreetmap:node/3414873604'),
  ('catalogo-andalucia:postal_service:node-3421889099', 'Correos Villaralto – Calle Alfonso XIII', NULL, '14072', 'Calle Alfonso XIII', '14470', 38.45509, -4.98495, 'address', 'openstreetmap:node/3421889099'),
  ('catalogo-andalucia:postal_service:node-3428431282', 'Correos Guadalcázar – Calle María Auxiliadora', NULL, '14033', 'Calle María Auxiliadora', NULL, 37.75757, -4.94463, 'address', 'openstreetmap:node/3428431282'),
  ('catalogo-andalucia:postal_service:node-3430472380', 'Correos Cardeña – Travesía San Antonio', NULL, '14016', 'Travesía San Antonio', NULL, 38.27209, -4.32461, 'address', 'openstreetmap:node/3430472380'),
  ('catalogo-andalucia:postal_service:node-3441540761', 'Correos Monturque – Calle Santo Cristo', NULL, '14044', 'Calle Santo Cristo', '14510', 37.47218, -4.58237, 'address', 'openstreetmap:node/3441540761'),
  ('catalogo-andalucia:postal_service:node-3457922880', 'Correos Espiel – Calle Ánimas', NULL, '14026', 'Calle Ánimas', '14220', 38.18816, -5.01992, 'address', 'openstreetmap:node/3457922880'),
  ('catalogo-andalucia:postal_service:node-3461928139', 'Correos Dos Torres – Avenida de Torrefranca', NULL, '14023', 'Avenida de Torrefranca', '14460', 38.44661, -4.89509, 'address', 'openstreetmap:node/3461928139'),
  ('catalogo-andalucia:postal_service:node-3470110000', 'Correos El Viso – Plaza de la Constitución', NULL, '14074', 'Plaza de la Constitución', '14470', 38.48245, -4.95537, 'address', 'openstreetmap:node/3470110000'),
  ('catalogo-andalucia:postal_service:node-3473572447', 'Correos Pedro Abad – Calle Santa Rafaela María', NULL, '14050', 'Calle Santa Rafaela María', '14630', 37.96809, -4.45578, 'address', 'openstreetmap:node/3473572447'),
  ('catalogo-andalucia:postal_service:node-3475247800', 'Correos Cañete de las Torres – Plaza de España', NULL, '14014', 'Plaza de España', '14660', 37.8675, -4.31895, 'address', 'openstreetmap:node/3475247800'),
  ('catalogo-andalucia:postal_service:node-3483796291', 'Correos Espejo – Calle Piqueras', NULL, '14025', 'Calle Piqueras', NULL, 37.67997, -4.55101, 'address', 'openstreetmap:node/3483796291'),
  ('catalogo-andalucia:postal_service:node-3496957803', 'Correos Montemayor – Calle Juan Pedro Carmona', NULL, '14041', 'Calle Juan Pedro Carmona', '14530', 37.64895, -4.69851, 'address', 'openstreetmap:node/3496957803'),
  ('catalogo-andalucia:postal_service:node-3499406511', 'Correos Adamuz – Avenida de la Puerta de la Villa', NULL, '14001', 'Avenida de la Puerta de la Villa', '14430', 38.02645, -4.5218, 'address', 'openstreetmap:node/3499406511'),
  ('catalogo-andalucia:postal_service:node-3504784531', 'Correos El Carpio – Calle Concepción', NULL, '14018', 'Calle Concepción', '14620', 37.93959, -4.49629, 'address', 'openstreetmap:node/3504784531'),
  ('catalogo-andalucia:postal_service:node-3505545425', 'Correos Iznájar – Calle Obispo Rosales', NULL, '14037', 'Calle Obispo Rosales', '14970', 37.25654, -4.30895, 'address', 'openstreetmap:node/3505545425'),
  ('catalogo-andalucia:postal_service:node-3507320226', 'Correos Hornachuelos – Calle Antonio Machado', NULL, '14036', 'Calle Antonio Machado', '14740', 37.83073, -5.24192, 'address', 'openstreetmap:node/3507320226'),
  ('catalogo-andalucia:postal_service:node-3510923806', 'Correos Doña Mencía – Calle Federico García Lorca', NULL, '14022', 'Calle Federico García Lorca', '14860', 37.55368, -4.35725, 'address', 'openstreetmap:node/3510923806'),
  ('catalogo-andalucia:postal_service:node-3512306818', 'Correos Nueva Carteya – Avenida de la Constitución', NULL, '14046', 'Avenida de la Constitución', '14857', 37.58708, -4.47001, 'address', 'openstreetmap:node/3512306818'),
  ('catalogo-andalucia:postal_service:node-3539862227', 'Correos La Rambla – Calle Calleja del Campo', NULL, '14057', 'Calle Calleja del Campo', '14540', 37.60527, -4.74077, 'address', 'openstreetmap:node/3539862227'),
  ('catalogo-andalucia:postal_service:node-3545037111', 'Correos Bujalance – Avenida del Doctor Fleming', NULL, '14012', 'Avenida del Doctor Fleming', '14650', 37.8939, -4.38008, 'address', 'openstreetmap:node/3545037111'),
  ('catalogo-andalucia:postal_service:node-3551912530', 'Correos Almodóvar del Río – Calle Antonio Machado', NULL, '14005', 'Calle Antonio Machado', '14720', 37.81036, -5.01861, 'address', 'openstreetmap:node/3551912530'),
  ('catalogo-andalucia:postal_service:node-3556729719', 'Correos Castro del Río – Calle José del Río', NULL, '14019', 'Calle José del Río', '14840', 37.69206, -4.48231, 'address', 'openstreetmap:node/3556729719'),
  ('catalogo-andalucia:postal_service:node-3559186037', 'Correos Villanueva de Córdoba – Calle Real', NULL, '14069', 'Calle Real', '14440', 38.32111, -4.62778, 'address', 'openstreetmap:node/3559186037'),
  ('catalogo-andalucia:postal_service:node-3561610559', 'Correos Montoro – Calle el Santo', NULL, '14043', 'Calle el Santo', '14600', 38.02211, -4.38366, 'address', 'openstreetmap:node/3561610559'),
  ('catalogo-andalucia:postal_service:node-3568733627', 'Correos Fernán-Núñez – Calle Miguel Servet', NULL, '14027', 'Calle Miguel Servet', '14540', 37.6681, -4.72614, 'address', 'openstreetmap:node/3568733627'),
  ('catalogo-andalucia:postal_service:node-3569972893', 'Correos Fuente Palmera – Calle Carlos III', NULL, '14030', 'Calle Carlos III', '14120', 37.70509, -5.10386, 'address', 'openstreetmap:node/3569972893'),
  ('catalogo-andalucia:postal_service:node-3583931749', 'Correos Pozoblanco – Avenida de Villanueva de Córdoba', NULL, '14054', 'Avenida de Villanueva de Córdoba', '14400', 38.38127, -4.84703, 'address', 'openstreetmap:node/3583931749'),
  ('catalogo-andalucia:postal_service:node-3596191236', 'Correos Palma del Río – Calle Ruiz Muñoz', NULL, '14049', 'Calle Ruiz Muñoz', '14700', 37.7013, -5.28364, 'address', 'openstreetmap:node/3596191236'),
  ('catalogo-andalucia:postal_service:node-3617401579', 'Correos Lucena – Plaza de San Miguel', NULL, '14038', 'Plaza de San Miguel', '14900', 37.4085, -4.48442, 'address', 'openstreetmap:node/3617401579'),
  ('catalogo-andalucia:postal_service:node-423953035', 'Correos Córdoba – Calle de Los Omeyas', NULL, '14021', 'Calle de Los Omeyas 2', '14005', 37.88602, -4.79117, 'address', 'openstreetmap:node/423953035'),
  ('catalogo-andalucia:postal_service:node-4323113462', 'Correos Baena – Calle Nicolás Alcalá', NULL, '14007', 'Calle Nicolás Alcalá', '14850', 37.61586, -4.3239, 'address', 'openstreetmap:node/4323113462'),
  ('catalogo-andalucia:postal_service:node-4369417173', 'Correos Priego de Córdoba – Lozano Sidro', NULL, '14055', 'Lozano Sidro 5', '14800', 37.43759, -4.19803, 'address', 'openstreetmap:node/4369417173'),
  ('catalogo-andalucia:postal_service:node-5435599321', 'Correos Córdoba – Carretera de Madrid', NULL, '14021', 'Carretera de Madrid 132', '14610', 37.93372, -4.66964, 'address', 'openstreetmap:node/5435599321'),
  ('catalogo-andalucia:postal_service:node-5514760390', 'Correos Córdoba – Calle San Pablo', NULL, '14021', 'Calle San Pablo', '14002', 37.88593, -4.77502, 'address', 'openstreetmap:node/5514760390'),
  ('catalogo-andalucia:postal_service:node-6734905424', 'Correos Cabra – Avenida Pedro Iglesias', NULL, '14013', 'Avenida Pedro Iglesias', '14940', 37.47476, -4.44071, 'address', 'openstreetmap:node/6734905424'),
  ('catalogo-andalucia:postal_service:node-9807476143', 'Correos La Victoria – Calle Duque de Rivas', NULL, '14065', 'Calle Duque de Rivas', '14140', 37.68081, -4.85425, 'address', 'openstreetmap:node/9807476143'),
  ('catalogo-andalucia:postal_service:relation-19107394', 'Correos Córdoba – Calle Cruz Conde', NULL, '14021', 'Calle Cruz Conde', '14008', 37.88692, -4.78078, 'address', 'openstreetmap:relation/19107394'),
  ('catalogo-andalucia:postal_service:way-193395518', 'Correos Puente Genil – Calle Cruz del Estudiante', NULL, '14056', 'Calle Cruz del Estudiante 37', '14500', 37.38952, -4.76866, 'address', 'openstreetmap:way/193395518'),
  ('catalogo-andalucia:postal_service:way-341566544', 'Correos Moriles – Calle García de Leániz', NULL, '14045', 'Calle García de Leániz', '14510', 37.43687, -4.61108, 'address', 'openstreetmap:way/341566544'),
  ('catalogo-andalucia:postal_service:way-351700570', 'Correos La Carlota – Calle Doctor Fleming', NULL, '14017', 'Calle Doctor Fleming', '14100', 37.67357, -4.93304, 'address', 'openstreetmap:way/351700570');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 50 THEN
    RAISE EXCEPTION 'Se esperaban 50 puntos de Correos en Córdoba, hay %', n;
  END IF;
END;
$$;

COMMIT;

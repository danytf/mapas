-- Carga de la categoría Correos de Huelva (provincia 21), trozo de la carga de Andalucía.
-- Origen: postal_service-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 45 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:postal_service:node-10232933948', 'Correos Alosno – Calle Nueva', NULL, '21006', 'Calle Nueva', NULL, 37.54898, -7.11532, 'address', 'openstreetmap:node/10232933948'),
  ('catalogo-andalucia:postal_service:node-10728000708', 'Correos Zufre – Calle Vicente Ferrer Campos', NULL, '21079', 'Calle Vicente Ferrer Campos', NULL, 37.83321, -6.33979, 'address', 'openstreetmap:node/10728000708'),
  ('catalogo-andalucia:postal_service:node-10810936018', 'Correos El Cerro de Andévalo – Calle Doña Ramona Domínguez', NULL, '21023', 'Calle Doña Ramona Domínguez', NULL, 37.68247, -7.07295, 'address', 'openstreetmap:node/10810936018'),
  ('catalogo-andalucia:postal_service:node-10814214486', 'Correos El Cerro de Andévalo – Calle Calleja Grande', NULL, '21023', 'Calle Calleja Grande', NULL, 37.73466, -6.9388, 'address', 'openstreetmap:node/10814214486'),
  ('catalogo-andalucia:postal_service:node-11423468373', 'Correos Fuenteheridos – Calle Esperanza Bermúdez', NULL, '21033', 'Calle Esperanza Bermúdez', '21292', 37.90239, -6.66322, 'address', 'openstreetmap:node/11423468373'),
  ('catalogo-andalucia:postal_service:node-12543829046', 'Correos Lucena del Puerto – Calle Maestro Cristóbal Domínguez', NULL, '21046', 'Calle Maestro Cristóbal Domínguez', '21820', 37.30325, -6.72533, 'address', 'openstreetmap:node/12543829046'),
  ('catalogo-andalucia:postal_service:node-1712571095', 'Correos Moguer – Calle Almoraduj', NULL, '21050', 'Calle Almoraduj', '21130', 37.13813, -6.82898, 'address', 'openstreetmap:node/1712571095'),
  ('catalogo-andalucia:postal_service:node-1930311498', 'Correos Villablanca – Plaza de la Constitución', NULL, '21073', 'Plaza de la Constitución', '21590', 37.30364, -7.34139, 'address', 'openstreetmap:node/1930311498'),
  ('catalogo-andalucia:postal_service:node-2054483575', 'Correos Cumbres Mayores – Avenida de la Constitución', NULL, '21029', 'Avenida de la Constitución', '21380', 38.06042, -6.64375, 'address', 'openstreetmap:node/2054483575'),
  ('catalogo-andalucia:postal_service:node-2059372150', 'Correos Bonares – Plaza de Nuestra Señora de la Asunción', NULL, '21014', 'Plaza de Nuestra Señora de la Asunción 6', '21830', 37.3212, -6.68357, 'address', 'openstreetmap:node/2059372150'),
  ('catalogo-andalucia:postal_service:node-2194479992', 'Correos Aracena – Calle Juan del Cid', NULL, '21007', 'Calle Juan del Cid', '21200', 37.89319, -6.56463, 'address', 'openstreetmap:node/2194479992'),
  ('catalogo-andalucia:postal_service:node-2203494950', 'Correos Almonaster la Real – Calle Minarete', NULL, '21004', 'Calle Minarete', '21350', 37.87243, -6.78728, 'address', 'openstreetmap:node/2203494950'),
  ('catalogo-andalucia:postal_service:node-2343305279', 'Correos Isla Cristina – Avenida Federico Silva Muñoz', NULL, '21042', 'Avenida Federico Silva Muñoz', '21410', 37.19658, -7.32478, 'address', 'openstreetmap:node/2343305279'),
  ('catalogo-andalucia:postal_service:node-3612423957', 'Correos San Juan del Puerto – Callejón Tobalo', NULL, '21064', 'Callejón Tobalo 2', '21610', 37.316, -6.84007, 'address', 'openstreetmap:node/3612423957'),
  ('catalogo-andalucia:postal_service:node-3635666317', 'Correos Ayamonte – Calle Lusitania', NULL, '21010', 'Calle Lusitania', '21400', 37.21308, -7.40987, 'address', 'openstreetmap:node/3635666317'),
  ('catalogo-andalucia:postal_service:node-3760041559', 'Correos Santa Olalla del Cala – Plaza de la Constitución', NULL, '21069', 'Plaza de la Constitución', '21260', 37.90632, -6.22945, 'address', 'openstreetmap:node/3760041559'),
  ('catalogo-andalucia:postal_service:node-4030437514', 'Correos Almonte – Calle Sevilla', NULL, '21005', 'Calle Sevilla', '21730', 37.26348, -6.51664, 'address', 'openstreetmap:node/4030437514'),
  ('catalogo-andalucia:postal_service:node-4040683420', 'Correos Bollullos Par del Condado – Avenida de Mariano de Ayala', NULL, '21013', 'Avenida de Mariano de Ayala', '21710', 37.33873, -6.53549, 'address', 'openstreetmap:node/4040683420'),
  ('catalogo-andalucia:postal_service:node-4071665542', 'Correos Hinojos – Calle Juan Carlos I', NULL, '21040', 'Calle Juan Carlos I', NULL, 37.29194, -6.37964, 'address', 'openstreetmap:node/4071665542'),
  ('catalogo-andalucia:postal_service:node-4073998921', 'Correos Manzanilla – Calle Doctor Fléming', NULL, '21047', 'Calle Doctor Fléming', '21860', 37.38742, -6.42838, 'address', 'openstreetmap:node/4073998921'),
  ('catalogo-andalucia:postal_service:node-4083555980', 'Correos Niebla – Plaza de la Feria', NULL, '21053', 'Plaza de la Feria', '21830', 37.36039, -6.67792, 'address', 'openstreetmap:node/4083555980'),
  ('catalogo-andalucia:postal_service:node-4124071381', 'Correos Aljaraque – Calle Antonio Ponce', NULL, '21002', 'Calle Antonio Ponce', '21110', 37.27128, -7.02273, 'address', 'openstreetmap:node/4124071381'),
  ('catalogo-andalucia:postal_service:node-4126775149', 'Correos Minas de Riotinto – Calle Méndez Núñez', NULL, '21049', 'Calle Méndez Núñez', '21660', 37.69249, -6.59317, 'address', 'openstreetmap:node/4126775149'),
  ('catalogo-andalucia:postal_service:node-4136309455', 'Correos Nerva – Plaza Andalucía', NULL, '21052', 'Plaza Andalucía', '21670', 37.69586, -6.55028, 'address', 'openstreetmap:node/4136309455'),
  ('catalogo-andalucia:postal_service:node-4159798504', 'Correos Cala – Avenida de Andalucía', NULL, '21016', 'Avenida de Andalucía', '21270', 37.97166, -6.31563, 'address', 'openstreetmap:node/4159798504'),
  ('catalogo-andalucia:postal_service:node-4163522220', 'Correos Zalamea la Real – Calle Olmos', NULL, '21078', 'Calle Olmos', '21640', 37.67988, -6.65968, 'address', 'openstreetmap:node/4163522220'),
  ('catalogo-andalucia:postal_service:node-4170140810', 'Correos El Campillo – Plaza de los Mártires', NULL, '21018', 'Plaza de los Mártires', '21660', 37.6935, -6.62823, 'address', 'openstreetmap:node/4170140810'),
  ('catalogo-andalucia:postal_service:node-4187782205', 'Correos Cabezas Rubias – Calle Barranco de la Calzada', NULL, '21015', 'Calle Barranco de la Calzada', NULL, 37.72692, -7.08793, 'address', 'openstreetmap:node/4187782205'),
  ('catalogo-andalucia:postal_service:node-4355445200', 'Correos Santa Bárbara de Casa – Callejón Carnicería', NULL, '21068', 'Callejón Carnicería', '21570', 37.79722, -7.18809, 'address', 'openstreetmap:node/4355445200'),
  ('catalogo-andalucia:postal_service:node-4755117279', 'Correos Lepe – Avenida de Andalucía', NULL, '21044', 'Avenida de Andalucía 15', '21440', 37.25025, -7.20012, 'address', 'openstreetmap:node/4755117279'),
  ('catalogo-andalucia:postal_service:node-4879036453', 'Correos Gibraleón – Avenida de Andalucía', NULL, '21035', 'Avenida de Andalucía', '21500', 37.37572, -6.96898, 'address', 'openstreetmap:node/4879036453'),
  ('catalogo-andalucia:postal_service:node-5162599425', 'Correos Huelva – Avenida de Italia', NULL, '21041', 'Avenida de Italia 10', '21001', 37.25437, -6.95395, 'address', 'openstreetmap:node/5162599425'),
  ('catalogo-andalucia:postal_service:node-6159130613', 'Correos Rociana del Condado – Calle La Fuente', NULL, '21061', 'Calle La Fuente', '21720', 37.30922, -6.59941, 'address', 'openstreetmap:node/6159130613'),
  ('catalogo-andalucia:postal_service:node-6604663910', 'Correos Alájar – Calle Ánimas', NULL, '21001', 'Calle Ánimas', '21340', 37.87368, -6.66516, 'address', 'openstreetmap:node/6604663910'),
  ('catalogo-andalucia:postal_service:node-6845443698', 'Correos Huelva – Calle Licenciado', NULL, '21041', 'Calle Licenciado', '21006', 37.26047, -6.92919, 'address', 'openstreetmap:node/6845443698'),
  ('catalogo-andalucia:postal_service:node-6847001985', 'Correos San Silvestre de Guzmán – Plaza de España', NULL, '21066', 'Plaza de España 20', '21591', 37.38791, -7.35045, 'address', 'openstreetmap:node/6847001985'),
  ('catalogo-andalucia:postal_service:node-6881453786', 'Correos Aroche – Calle Ordóñez Valdés', NULL, '21008', 'Calle Ordóñez Valdés', '21240', 37.94439, -6.95249, 'address', 'openstreetmap:node/6881453786'),
  ('catalogo-andalucia:postal_service:node-8063853835', 'Correos Sanlúcar de Guadiana – Calle Danzadores', NULL, '21065', 'Calle Danzadores', '21595', 37.47322, -7.46746, 'address', 'openstreetmap:node/8063853835'),
  ('catalogo-andalucia:postal_service:node-9280029827', 'Correos El Granado – Calle Coso', NULL, '21037', 'Calle Coso', '21594', 37.52076, -7.41832, 'address', 'openstreetmap:node/9280029827'),
  ('catalogo-andalucia:postal_service:node-9299850711', 'Correos La Zarza-Perrunal – Calle Venus', NULL, '21902', 'Calle Venus', NULL, 37.71272, -6.85373, 'address', 'openstreetmap:node/9299850711'),
  ('catalogo-andalucia:postal_service:node-9700012414', 'Correos Villanueva de las Cruces – Calle Juan Ramón Jiménez', NULL, '21075', 'Calle Juan Ramón Jiménez', NULL, 37.62694, -7.02434, 'address', 'openstreetmap:node/9700012414'),
  ('catalogo-andalucia:postal_service:way-300295793', 'Correos Punta Umbría – Avenida Andalucía', NULL, '21060', 'Avenida Andalucía', '21100', 37.18137, -6.96738, 'address', 'openstreetmap:way/300295793'),
  ('catalogo-andalucia:postal_service:way-405889896', 'Correos La Palma del Condado – Plaza de Andalucía', NULL, '21054', 'Plaza de Andalucía', '21700', 37.39025, -6.55219, 'address', 'openstreetmap:way/405889896'),
  ('catalogo-andalucia:postal_service:way-409253096', 'Correos Moguer – Calle Triana', NULL, '21050', 'Calle Triana', '21800', 37.27509, -6.84077, 'address', 'openstreetmap:way/409253096'),
  ('catalogo-andalucia:postal_service:way-410938105', 'Correos Aljaraque – Calle Fragua', NULL, '21002', 'Calle Fragua', '21120', 37.27428, -6.98808, 'address', 'openstreetmap:way/410938105');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 45 THEN
    RAISE EXCEPTION 'Se esperaban 45 puntos de Correos en Huelva, hay %', n;
  END IF;
END;
$$;

COMMIT;

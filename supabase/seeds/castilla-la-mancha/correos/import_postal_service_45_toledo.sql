-- Carga de la categoría Correos de Toledo (provincia 45), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 46 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-la-mancha:postal_service:node-10239841071', 'Correos Talavera de la Reina – Plaza del Reloj', NULL, '45165', 'Plaza del Reloj 8', '45600', 39.9604, -4.83153, 'address', 'openstreetmap:node/10239841071'),
  ('catalogo-castilla-la-mancha:postal_service:node-11067340774', 'Correos Sonseca – Calle Mayor', NULL, '45163', 'Calle Mayor 30', '45100', 39.67467, -3.97479, 'address', 'openstreetmap:node/11067340774'),
  ('catalogo-castilla-la-mancha:postal_service:node-12164249957', 'Correos Cobeja – Plaza de la  Constitución', NULL, '45051', 'Plaza de la  Constitución 1', '45291', 40.02314, -3.85925, 'address', 'openstreetmap:node/12164249957'),
  ('catalogo-castilla-la-mancha:postal_service:node-1296366463', 'Correos Yepes – Calle San Pedro', NULL, '45202', 'Calle San Pedro', '45313', 39.90086, -3.62644, 'address', 'openstreetmap:node/1296366463'),
  ('catalogo-castilla-la-mancha:postal_service:node-13401119733', 'Correos Miguel Esteban – Calle Cantarranas', NULL, '45101', 'Calle Cantarranas', NULL, 39.52707, -3.07682, 'address', 'openstreetmap:node/13401119733'),
  ('catalogo-castilla-la-mancha:postal_service:node-13468129155', 'Correos Santa Olalla – Calle Camino de El Casar', NULL, '45158', 'Calle Camino de El Casar', NULL, 40.02408, -4.43171, 'address', 'openstreetmap:node/13468129155'),
  ('catalogo-castilla-la-mancha:postal_service:node-13531789713', 'Correos Carmena – Calle Monte', NULL, '45036', 'Calle Monte', NULL, 39.95808, -4.40278, 'address', 'openstreetmap:node/13531789713'),
  ('catalogo-castilla-la-mancha:postal_service:node-13541833831', 'Correos La Mata – Calle Padre Juan de Mariana', NULL, '45095', 'Calle Padre Juan de Mariana', NULL, 39.93834, -4.43776, 'address', 'openstreetmap:node/13541833831'),
  ('catalogo-castilla-la-mancha:postal_service:node-13574481718', 'Correos Cuerva – Plaza de la Constitución', NULL, '45055', 'Plaza de la Constitución 1', '45126', 39.66382, -4.21078, 'address', 'openstreetmap:node/13574481718'),
  ('catalogo-castilla-la-mancha:postal_service:node-14091892648', 'Correos Novés – Calle Candelaria', NULL, '45118', 'Calle Candelaria', NULL, 40.04212, -4.27324, 'address', 'openstreetmap:node/14091892648'),
  ('catalogo-castilla-la-mancha:postal_service:node-1637156252', 'Correos Toledo – Calle de la Plata', NULL, '45168', 'Calle de la Plata 1', '45001', 39.85934, -4.02465, 'address', 'openstreetmap:node/1637156252'),
  ('catalogo-castilla-la-mancha:postal_service:node-1678984446', 'Correos Toledo – Calle del Río Bullaque', NULL, '45168', 'Calle del Río Bullaque 24', '45007', 39.86522, -3.94887, 'address', 'openstreetmap:node/1678984446'),
  ('catalogo-castilla-la-mancha:postal_service:node-1907871136', 'Correos Villaluenga de la Sagra – Plaza Miguel de Cervantes', NULL, '45188', 'Plaza Miguel de Cervantes', '45520', 40.02784, -3.91409, 'address', 'openstreetmap:node/1907871136'),
  ('catalogo-castilla-la-mancha:postal_service:node-1908499579', 'Correos Fuensalida – Calle Venancio Moreno', NULL, '45066', 'Calle Venancio Moreno', '45510', 40.05417, -4.20892, 'address', 'openstreetmap:node/1908499579'),
  ('catalogo-castilla-la-mancha:postal_service:node-1934944411', 'Correos Cedillo del Condado – Calle San Antonio', NULL, '45047', 'Calle San Antonio', NULL, 40.11356, -3.92764, 'address', 'openstreetmap:node/1934944411'),
  ('catalogo-castilla-la-mancha:postal_service:node-2092738516', 'Correos Yuncos – Calle La Iglesia', NULL, '45205', 'Calle La Iglesia 15', '45210', 40.0859, -3.87437, 'address', 'openstreetmap:node/2092738516'),
  ('catalogo-castilla-la-mancha:postal_service:node-2284235638', 'Correos Méntrida – Calle Joaquín González', NULL, '45099', 'Calle Joaquín González', '45930', 40.23827, -4.19228, 'address', 'openstreetmap:node/2284235638'),
  ('catalogo-castilla-la-mancha:postal_service:node-2443082279', 'Correos Villatobas – Calle Mayor 9-11', NULL, '45198', 'Calle Mayor 9-11', '45310', 39.90129, -3.32341, 'address', 'openstreetmap:node/2443082279'),
  ('catalogo-castilla-la-mancha:postal_service:node-2490265670', 'Correos Mora – Calle Clavel', NULL, '45106', 'Calle Clavel', '45400', 39.68245, -3.77395, 'address', 'openstreetmap:node/2490265670'),
  ('catalogo-castilla-la-mancha:postal_service:node-2569468561', 'Correos Villaseca de la Sagra – Plaza Mayor', NULL, '45196', 'Plaza Mayor', '45360', 39.96191, -3.88314, 'address', 'openstreetmap:node/2569468561'),
  ('catalogo-castilla-la-mancha:postal_service:node-2627375469', 'Correos Ocaña – Calle Fernando Cadalso', NULL, '45121', 'Calle Fernando Cadalso 6', '45300', 39.95672, -3.49815, 'address', 'openstreetmap:node/2627375469'),
  ('catalogo-castilla-la-mancha:postal_service:node-2809700263', 'Correos Esquivias – Calle de Finados', NULL, '45064', 'Calle de Finados', NULL, 40.10213, -3.76918, 'address', 'openstreetmap:node/2809700263'),
  ('catalogo-castilla-la-mancha:postal_service:node-2844413750', 'Correos Borox – Calle de los Pajaritos', NULL, '45021', 'Calle de los Pajaritos', '45222', 40.07008, -3.73862, 'address', 'openstreetmap:node/2844413750'),
  ('catalogo-castilla-la-mancha:postal_service:node-3105973734', 'Correos Villacañas – Calle Echegaray', NULL, '45185', 'Calle Echegaray', '45860', 39.62468, -3.33499, 'address', 'openstreetmap:node/3105973734'),
  ('catalogo-castilla-la-mancha:postal_service:node-3155033877', 'Correos Tembleque – Calle del Hospital', NULL, '45166', 'Calle del Hospital', '45780', 39.69662, -3.50423, 'address', 'openstreetmap:node/3155033877'),
  ('catalogo-castilla-la-mancha:postal_service:node-3208798361', 'Correos La Villa de Don Fadrique – Avenida de Valencia', NULL, '45186', 'Avenida de Valencia', NULL, 39.6168, -3.21852, 'address', 'openstreetmap:node/3208798361'),
  ('catalogo-castilla-la-mancha:postal_service:node-3215766239', 'Correos Lillo – Calle de Alfonso González', NULL, '45084', 'Calle de Alfonso González 2', '45870', 39.72312, -3.30509, 'address', 'openstreetmap:node/3215766239'),
  ('catalogo-castilla-la-mancha:postal_service:node-3229854209', 'Correos Santa Cruz de la Zarza – Avenida de Magallanes', NULL, '45156', 'Avenida de Magallanes 7', '45370', 39.97667, -3.18853, 'address', 'openstreetmap:node/3229854209'),
  ('catalogo-castilla-la-mancha:postal_service:node-3265904678', 'Correos Los Navalmorales – Calle de Concepción', NULL, '45112', 'Calle de Concepción 20', '45140', 39.72424, -4.6429, 'address', 'openstreetmap:node/3265904678'),
  ('catalogo-castilla-la-mancha:postal_service:node-3532777627', 'Correos La Puebla de Almoradiel – Calle Juan Pablo II', NULL, '45135', 'Calle Juan Pablo II', NULL, 39.59914, -3.1171, 'address', 'openstreetmap:node/3532777627'),
  ('catalogo-castilla-la-mancha:postal_service:node-4413471089', 'Correos El Toboso – Calle Cervantes', NULL, '45167', 'Calle Cervantes', '45820', 39.51245, -2.99645, 'address', 'openstreetmap:node/4413471089'),
  ('catalogo-castilla-la-mancha:postal_service:node-4837330877', 'Correos Tembleque – Avenida de Andalucía', NULL, '45166', 'Avenida de Andalucía', NULL, 39.68893, -3.50305, 'address', 'openstreetmap:node/4837330877'),
  ('catalogo-castilla-la-mancha:postal_service:node-5320862309', 'Correos Camarena – Plaza Virgen de la Caridad', NULL, '45031', 'Plaza Virgen de la Caridad 1', '45180', 40.09307, -4.11942, 'address', 'openstreetmap:node/5320862309'),
  ('catalogo-castilla-la-mancha:postal_service:node-5824092901', 'Correos Talavera de la Reina – Avenida del Príncipe Felipe', NULL, '45165', 'Avenida del Príncipe Felipe', '45600', 39.96589, -4.8155, 'address', 'openstreetmap:node/5824092901'),
  ('catalogo-castilla-la-mancha:postal_service:node-6140081147', 'Correos Cobisa – Calle Pozo Dos Bocas', NULL, '45052', 'Calle Pozo Dos Bocas', '45111', 39.80488, -4.02361, 'address', 'openstreetmap:node/6140081147'),
  ('catalogo-castilla-la-mancha:postal_service:node-6687456412', 'Correos Dosbarrios – Calle de Noblejas', NULL, '45059', 'Calle de Noblejas', NULL, 39.88323, -3.48044, 'address', 'openstreetmap:node/6687456412'),
  ('catalogo-castilla-la-mancha:postal_service:node-6698840738', 'Correos Olías del Rey – Calle de Santa Bárbara', NULL, '45122', 'Calle de Santa Bárbara', '45280', 39.94453, -3.98771, 'address', 'openstreetmap:node/6698840738'),
  ('catalogo-castilla-la-mancha:postal_service:node-6760377796', 'Correos Talavera de la Reina – Ronda del Cañillo', NULL, '45165', 'Ronda del Cañillo 17', '45600', 39.95682, -4.83135, 'address', 'openstreetmap:node/6760377796'),
  ('catalogo-castilla-la-mancha:postal_service:node-7798631883', 'Correos Quintanar de la Orden – Calle Tejeros', NULL, '45142', 'Calle Tejeros', NULL, 39.59343, -3.04384, 'address', 'openstreetmap:node/7798631883'),
  ('catalogo-castilla-la-mancha:postal_service:node-8726200317', 'Correos El Viso de San Juan – Yuncos', NULL, '45199', 'Yuncos 3', '45215', 40.14117, -3.91848, 'address', 'openstreetmap:node/8726200317'),
  ('catalogo-castilla-la-mancha:postal_service:way-103427280', 'Correos Toledo – Calle del Duque de Lerma', NULL, '45168', 'Calle del Duque de Lerma 6', '45004', 39.86684, -4.02669, 'address', 'openstreetmap:way/103427280'),
  ('catalogo-castilla-la-mancha:postal_service:way-1167850946', 'Correos Nambroca – Calle Curato', NULL, '45107', 'Calle Curato 2', '45190', 39.79903, -3.9429, 'address', 'openstreetmap:way/1167850946'),
  ('catalogo-castilla-la-mancha:postal_service:way-149045019', 'Correos Almorox – Calle el Indiano', NULL, '45013', 'Calle el Indiano', '45900', 40.23418, -4.39117, 'address', 'openstreetmap:way/149045019'),
  ('catalogo-castilla-la-mancha:postal_service:way-260320464', 'Correos Consuegra – Calle Florinda', NULL, '45053', 'Calle Florinda 5', '45700', 39.46037, -3.60838, 'address', 'openstreetmap:way/260320464'),
  ('catalogo-castilla-la-mancha:postal_service:way-374050915', 'Correos Ajofrín – Plaza de la Constitución', NULL, '45001', 'Plaza de la Constitución', '45110', 39.71234, -3.98189, 'address', 'openstreetmap:way/374050915'),
  ('catalogo-castilla-la-mancha:postal_service:way-390698807', 'Correos Los Navalucillos – Callejón del Agua', NULL, '45113', 'Callejón del Agua 3', '45130', 39.66608, -4.64238, 'address', 'openstreetmap:way/390698807');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '45');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 45 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '45'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 46 THEN
    RAISE EXCEPTION 'Se esperaban 46 puntos de Correos en Toledo, hay %', n;
  END IF;
END;
$$;

COMMIT;

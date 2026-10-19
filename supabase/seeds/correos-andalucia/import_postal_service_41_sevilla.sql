-- Carga de la categoría Correos de Sevilla (provincia 41), trozo de la carga de Andalucía.
-- Origen: postal_service-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 75 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:postal_service:node-11265447302', 'Correos Paradas – Calle Wenceslao Fernández Flores', NULL, '41071', 'Calle Wenceslao Fernández Flores', '41610', 37.28774, -5.49979, 'address', 'openstreetmap:node/11265447302'),
  ('catalogo-andalucia:postal_service:node-1235353272', 'Correos Utrera – Calle Álvarez Quintero', NULL, '41095', 'Calle Álvarez Quintero', '41710', 37.18348, -5.7817, 'address', 'openstreetmap:node/1235353272'),
  ('catalogo-andalucia:postal_service:node-12539612356', 'Correos Pilas – Calle Luis de Medina', NULL, '41075', 'Calle Luis de Medina', '41840', 37.30137, -6.30018, 'address', 'openstreetmap:node/12539612356'),
  ('catalogo-andalucia:postal_service:node-12657426632', 'Correos La Algaba – Calle Rafael Alberti', NULL, '41007', 'Calle Rafael Alberti', '41980', 37.46269, -6.01028, 'address', 'openstreetmap:node/12657426632'),
  ('catalogo-andalucia:postal_service:node-12697370977', 'Correos La Puebla del Río – Calle La Niña', NULL, '41079', 'Calle La Niña', '41130', 37.26991, -6.06118, 'address', 'openstreetmap:node/12697370977'),
  ('catalogo-andalucia:postal_service:node-1270128045', 'Correos Dos Hermanas – Calle Doctor Caro Romero', NULL, '41038', 'Calle Doctor Caro Romero 6', '41701', 37.28278, -5.92296, 'address', 'openstreetmap:node/1270128045'),
  ('catalogo-andalucia:postal_service:node-12860733662', 'Correos Alanís – Calle M. Espinola Onorio', NULL, '41002', 'Calle M. Espinola Onorio', NULL, 38.03661, -5.71198, 'address', 'openstreetmap:node/12860733662'),
  ('catalogo-andalucia:postal_service:node-12883856127', 'Correos Aznalcázar – Calle Rosal', NULL, '41012', 'Calle Rosal', '41840', 37.3039, -6.24806, 'address', 'openstreetmap:node/12883856127'),
  ('catalogo-andalucia:postal_service:node-13067751991', 'Correos Cazalla de la Sierra – Calle Llana', NULL, '41032', 'Calle Llana', '41370', 37.93496, -5.75948, 'address', 'openstreetmap:node/13067751991'),
  ('catalogo-andalucia:postal_service:node-13875970978', 'Correos Camas – Calle Sevilla', NULL, '41021', 'Calle Sevilla', '41900', 37.39885, -6.03503, 'address', 'openstreetmap:node/13875970978'),
  ('catalogo-andalucia:postal_service:node-1445759081', 'Correos Lora de Estepa – Calle Pedrera', NULL, '41054', 'Calle Pedrera', '41564', 37.26564, -4.82999, 'address', 'openstreetmap:node/1445759081'),
  ('catalogo-andalucia:postal_service:node-1461575637', 'Correos El Pedroso – Plaza de España', NULL, '41073', 'Plaza de España', '41360', 37.84227, -5.76397, 'address', 'openstreetmap:node/1461575637'),
  ('catalogo-andalucia:postal_service:node-1694277513', 'Correos Villaverde del Río – Avenida de Nuestra Señora de Aguas Santas', NULL, '41101', 'Avenida de Nuestra Señora de Aguas Santas', '41318', 37.58865, -5.87539, 'address', 'openstreetmap:node/1694277513'),
  ('catalogo-andalucia:postal_service:node-1802249656', 'Correos Castilleja de la Cuesta – Calle Rafael Alberti', NULL, '41029', 'Calle Rafael Alberti', '41950', 37.38614, -6.05597, 'address', 'openstreetmap:node/1802249656'),
  ('catalogo-andalucia:postal_service:node-1869408074', 'Correos Sevilla – Avenida de las Ciencias', NULL, '41091', 'Avenida de las Ciencias 35', '41020', 37.39843, -5.92478, 'address', 'openstreetmap:node/1869408074'),
  ('catalogo-andalucia:postal_service:node-1904313379', 'Correos Tomares – Calle Virgen de los Dolores', NULL, '41093', 'Calle Virgen de los Dolores', '41940', 37.37485, -6.04125, 'address', 'openstreetmap:node/1904313379'),
  ('catalogo-andalucia:postal_service:node-1906721791', 'Correos Alcalá de Guadaíra – Calle Mairena', NULL, '41004', 'Calle Mairena', '41500', 37.33833, -5.84185, 'address', 'openstreetmap:node/1906721791'),
  ('catalogo-andalucia:postal_service:node-1920861282', 'Correos Morón de la Frontera – Plaza de la Inmaculada', NULL, '41065', 'Plaza de la Inmaculada', NULL, 37.1206, -5.45132, 'address', 'openstreetmap:node/1920861282'),
  ('catalogo-andalucia:postal_service:node-1942845728', 'Correos Sevilla – Plaza Corazón de María', NULL, '41091', 'Plaza Corazón de María', '41016', 37.38458, -5.90968, 'address', 'openstreetmap:node/1942845728'),
  ('catalogo-andalucia:postal_service:node-2338420787', 'Correos Dos Hermanas – Avenida Guadalquivir', NULL, '41038', 'Avenida Guadalquivir', '41702', 37.2876, -5.91526, 'address', 'openstreetmap:node/2338420787'),
  ('catalogo-andalucia:postal_service:node-2347217077', 'Correos Tomares – Plaza Príncipe de Asturias', NULL, '41093', 'Plaza Príncipe de Asturias', '41940', 37.37669, -6.04672, 'address', 'openstreetmap:node/2347217077'),
  ('catalogo-andalucia:postal_service:node-2384636603', 'Correos Marchena – Calle Santa Clara', NULL, '41060', 'Calle Santa Clara', '41620', 37.32786, -5.41636, 'address', 'openstreetmap:node/2384636603'),
  ('catalogo-andalucia:postal_service:node-2393753766', 'Correos Sevilla – Calle Virgen de Begoña', NULL, '41091', 'Calle Virgen de Begoña', '41010', 37.37765, -5.99939, 'address', 'openstreetmap:node/2393753766'),
  ('catalogo-andalucia:postal_service:node-2394420277', 'Correos El Viso del Alcor – Calle Huerta Viña Don Juan', NULL, '41102', 'Calle Huerta Viña Don Juan', '41520', 37.38504, -5.72654, 'address', 'openstreetmap:node/2394420277'),
  ('catalogo-andalucia:postal_service:node-2400978304', 'Correos Alcalá del Río – Calle Amanecer', NULL, '41005', 'Calle Amanecer', '41200', 37.51551, -5.98102, 'address', 'openstreetmap:node/2400978304'),
  ('catalogo-andalucia:postal_service:node-2898936312', 'Correos Almensilla – Calle Prado', NULL, '41010', 'Calle Prado', '41111', 37.30989, -6.11348, 'address', 'openstreetmap:node/2898936312'),
  ('catalogo-andalucia:postal_service:node-3299574781', 'Correos Coria del Río – Calle Carne', NULL, '41034', 'Calle Carne', '41100', 37.28754, -6.05095, 'address', 'openstreetmap:node/3299574781'),
  ('catalogo-andalucia:postal_service:node-3612492162', 'Correos Santiponce – Calle Guadalquivir', NULL, '41089', 'Calle Guadalquivir', '41970', 37.43368, -6.04411, 'address', 'openstreetmap:node/3612492162'),
  ('catalogo-andalucia:postal_service:node-3730771877', 'Correos La Puebla de Cazalla – Calle Moron', NULL, '41077', 'Calle Moron', '41540', 37.22252, -5.31333, 'address', 'openstreetmap:node/3730771877'),
  ('catalogo-andalucia:postal_service:node-3887118558', 'Correos Lora del Río – Avenida de Santa Ana', NULL, '41055', 'Avenida de Santa Ana', '41440', 37.6594, -5.52956, 'address', 'openstreetmap:node/3887118558'),
  ('catalogo-andalucia:postal_service:node-4147383057', 'Correos El Cuervo de Sevilla – Avenida de José Antonio Gallego', NULL, '41903', 'Avenida de José Antonio Gallego', '41749', 36.85566, -6.03838, 'address', 'openstreetmap:node/4147383057'),
  ('catalogo-andalucia:postal_service:node-4209343601', 'Correos Aznalcóllar – Calle Real', NULL, '41013', 'Calle Real', '41870', 37.5213, -6.26837, 'address', 'openstreetmap:node/4209343601'),
  ('catalogo-andalucia:postal_service:node-4212527129', 'Correos Castilleja de Guzmán – Plaza San Benito', NULL, '41028', 'Plaza San Benito', '41908', 37.40899, -6.05605, 'address', 'openstreetmap:node/4212527129'),
  ('catalogo-andalucia:postal_service:node-4214092608', 'Correos Fuentes de Andalucía – Calle Sol', NULL, '41042', 'Calle Sol', '41420', 37.46449, -5.34379, 'address', 'openstreetmap:node/4214092608'),
  ('catalogo-andalucia:postal_service:node-4225655561', 'Correos Los Corrales – Calle Feria', NULL, '41037', 'Calle Feria', '41657', 37.09965, -4.98097, 'address', 'openstreetmap:node/4225655561'),
  ('catalogo-andalucia:postal_service:node-422724955', 'Correos Sevilla – Avenida de la Cruz Roja', NULL, '41091', 'Avenida de la Cruz Roja', '41009', 37.4027, -5.98143, 'address', 'openstreetmap:node/422724955'),
  ('catalogo-andalucia:postal_service:node-4228661208', 'Correos Martín de la Jara – Plaza de Diamantino García', NULL, '41062', 'Plaza de Diamantino García', '41658', 37.10695, -4.9618, 'address', 'openstreetmap:node/4228661208'),
  ('catalogo-andalucia:postal_service:node-4230457341', 'Correos El Saucejo – Calle Juan Carrasco', NULL, '41090', 'Calle Juan Carrasco', '41650', 37.07046, -5.09409, 'address', 'openstreetmap:node/4230457341'),
  ('catalogo-andalucia:postal_service:node-4244803245', 'Correos Cañada Rosal – Calle Francia', NULL, '41901', 'Calle Francia', '41439', 37.59593, -5.2108, 'address', 'openstreetmap:node/4244803245'),
  ('catalogo-andalucia:postal_service:node-4250270935', 'Correos Tocina – Calle Reina Sofía', NULL, '41092', 'Calle Reina Sofía', '41340', 37.6068, -5.73421, 'address', 'openstreetmap:node/4250270935'),
  ('catalogo-andalucia:postal_service:node-4253183400', 'Correos Tocina – Avenida de Sevilla', NULL, '41092', 'Avenida de Sevilla', '41330', 37.59013, -5.7327, 'address', 'openstreetmap:node/4253183400'),
  ('catalogo-andalucia:postal_service:node-4256174779', 'Correos Alcolea del Río – Calle Virgen del Consuelo', NULL, '41006', 'Calle Virgen del Consuelo', '41449', 37.61402, -5.66574, 'address', 'openstreetmap:node/4256174779'),
  ('catalogo-andalucia:postal_service:node-4268392338', 'Correos Olivares – Calle Libertad', NULL, '41067', 'Calle Libertad', '41804', 37.41657, -6.15432, 'address', 'openstreetmap:node/4268392338'),
  ('catalogo-andalucia:postal_service:node-4280923180', 'Correos Salteras – Plaza del Consejo', NULL, '41085', 'Plaza del Consejo', '41909', 37.41846, -6.10906, 'address', 'openstreetmap:node/4280923180'),
  ('catalogo-andalucia:postal_service:node-4291182779', 'Correos Valencina de la Concepción – Calle Juan Ramón Jiménez', NULL, '41096', 'Calle Juan Ramón Jiménez', '41907', 37.41712, -6.07307, 'address', 'openstreetmap:node/4291182779'),
  ('catalogo-andalucia:postal_service:node-4296871846', 'Correos Villanueva del Ariscal – Calle Manuel Castaño Silva', NULL, '41098', 'Calle Manuel Castaño Silva', '41808', 37.39809, -6.14083, 'address', 'openstreetmap:node/4296871846'),
  ('catalogo-andalucia:postal_service:node-4309745585', 'Correos Espartinas – Avenida de Sevilla', NULL, '41040', 'Avenida de Sevilla', '41807', 37.38072, -6.12096, 'address', 'openstreetmap:node/4309745585'),
  ('catalogo-andalucia:postal_service:node-4321075445', 'Correos Burguillos – Calle Real', NULL, '41019', 'Calle Real', '41220', 37.58497, -5.96794, 'address', 'openstreetmap:node/4321075445'),
  ('catalogo-andalucia:postal_service:node-4355475171', 'Correos Cantillana – Calle San Francisco', NULL, '41023', 'Calle San Francisco', '41320', 37.60898, -5.82658, 'address', 'openstreetmap:node/4355475171'),
  ('catalogo-andalucia:postal_service:node-4361894236', 'Correos Castilblanco de los Arroyos – Avenida de España', NULL, '41027', 'Avenida de España', '41230', 37.67616, -5.98799, 'address', 'openstreetmap:node/4361894236'),
  ('catalogo-andalucia:postal_service:node-4464136889', 'Correos Sevilla – Calle Marianillo', NULL, '41091', 'Calle Marianillo 2', '41010', 37.38032, -6.00215, 'address', 'openstreetmap:node/4464136889'),
  ('catalogo-andalucia:postal_service:node-4585642318', 'Correos Villanueva del Río y Minas – Calle Santa Bárbara', NULL, '41099', 'Calle Santa Bárbara', '41350', 37.65904, -5.7124, 'address', 'openstreetmap:node/4585642318'),
  ('catalogo-andalucia:postal_service:node-4604375901', 'Correos Herrera – Calle Antequera', NULL, '41050', 'Calle Antequera', '41567', 37.36349, -4.84967, 'address', 'openstreetmap:node/4604375901'),
  ('catalogo-andalucia:postal_service:node-4612075275', 'Correos Casariche – Calle Nuestra Señora de la Encarnación', NULL, '41026', 'Calle Nuestra Señora de la Encarnación', '41580', 37.29548, -4.75939, 'address', 'openstreetmap:node/4612075275'),
  ('catalogo-andalucia:postal_service:node-4626359109', 'Correos Badolatosa – Calle Carnecería', NULL, '41014', 'Calle Carnecería', '41599', 37.30812, -4.67475, 'address', 'openstreetmap:node/4626359109'),
  ('catalogo-andalucia:postal_service:node-5258604096', 'Correos Arahal – Calle San Roque', NULL, '41011', 'Calle San Roque', '41600', 37.26312, -5.54695, 'address', 'openstreetmap:node/5258604096'),
  ('catalogo-andalucia:postal_service:node-5331619327', 'Correos Sevilla – Calle Jesús del Gran Poder', NULL, '41091', 'Calle Jesús del Gran Poder 86', '41002', 37.39832, -5.99482, 'address', 'openstreetmap:node/5331619327'),
  ('catalogo-andalucia:postal_service:node-5551556043', 'Correos Sevilla – Calle Juan Antonio Cavestany', NULL, '41091', 'Calle Juan Antonio Cavestany', '41018', 37.38938, -5.98149, 'address', 'openstreetmap:node/5551556043'),
  ('catalogo-andalucia:postal_service:node-5873085718', 'Correos El Palmar de Troya – Avenida de Utrera', NULL, '41904', 'Avenida de Utrera', '41719', 37.06262, -5.80466, 'address', 'openstreetmap:node/5873085718'),
  ('catalogo-andalucia:postal_service:node-7041192363', 'Correos San Juan de Aznalfarache', NULL, '41086', NULL, '41920', 37.3728, -6.0293, 'address', 'openstreetmap:node/7041192363'),
  ('catalogo-andalucia:postal_service:node-8473190113', 'Correos Castilleja del Campo – Calle San Miguel', NULL, '41030', 'Calle San Miguel 15', '41810', 37.38614, -6.33291, 'address', 'openstreetmap:node/8473190113'),
  ('catalogo-andalucia:postal_service:node-864119283', 'Correos Sevilla – Calle Cean Bermúdez', NULL, '41091', 'Calle Cean Bermúdez', '41005', 37.38016, -5.96615, 'address', 'openstreetmap:node/864119283'),
  ('catalogo-andalucia:postal_service:node-9844607649', 'Correos Mairena del Alcor – Calle Agustín Jiménez Jiménez-Vallejo', NULL, '41058', 'Calle Agustín Jiménez Jiménez-Vallejo 30', '41510', 37.37595, -5.74778, 'address', 'openstreetmap:node/9844607649'),
  ('catalogo-andalucia:postal_service:node-995959107', 'Correos Bormujos – Avenida de Almenilla', NULL, '41017', 'Avenida de Almenilla', '41930', 37.37065, -6.07945, 'address', 'openstreetmap:node/995959107'),
  ('catalogo-andalucia:postal_service:node-9976827288', 'Correos Sevilla – Calle Fernando Zobel', NULL, '41091', 'Calle Fernando Zobel', '41020', 37.4046, -5.94454, 'address', 'openstreetmap:node/9976827288'),
  ('catalogo-andalucia:postal_service:way-1125391703', 'Correos Lebrija – Calle Juan Pedro Vidal', NULL, '41053', 'Calle Juan Pedro Vidal', '41740', 36.91951, -6.07933, 'address', 'openstreetmap:way/1125391703'),
  ('catalogo-andalucia:postal_service:way-119583601', 'Correos Sevilla – Avenida de la Constitución', NULL, '41091', 'Avenida de la Constitución 32', '41004', 37.38476, -5.99424, 'address', 'openstreetmap:way/119583601'),
  ('catalogo-andalucia:postal_service:way-200571639', 'Correos Sevilla – Avenida de Las Razas', NULL, '41091', 'Avenida de Las Razas', '41011', 37.36852, -5.98986, 'address', 'openstreetmap:way/200571639'),
  ('catalogo-andalucia:postal_service:way-274847482', 'Correos Gines – Calle Comistra', NULL, '41047', 'Calle Comistra', '41960', 37.38393, -6.08122, 'address', 'openstreetmap:way/274847482'),
  ('catalogo-andalucia:postal_service:way-419763885', 'Correos Bollullos de la Mitación – Calle Antonino Ruiz López', NULL, '41016', 'Calle Antonino Ruiz López', '41110', 37.33929, -6.13877, 'address', 'openstreetmap:way/419763885'),
  ('catalogo-andalucia:postal_service:way-577605447', 'Correos Sevilla – Avenida de Finlandia', NULL, '41091', 'Avenida de Finlandia', '41012', 37.34412, -5.97721, 'address', 'openstreetmap:way/577605447'),
  ('catalogo-andalucia:postal_service:way-592734471', 'Correos Écija – Calle Emilio Castelar', NULL, '41039', 'Calle Emilio Castelar', '41400', 37.54142, -5.07656, 'address', 'openstreetmap:way/592734471'),
  ('catalogo-andalucia:postal_service:way-720846989', 'Correos La Rinconada – Plaza Alonso Cano', NULL, '41081', 'Plaza Alonso Cano', '41309', 37.48344, -5.94747, 'address', 'openstreetmap:way/720846989'),
  ('catalogo-andalucia:postal_service:way-72692154', 'Correos Sevilla – Efeso', NULL, '41091', 'Efeso', '41007', 37.3941, -5.96226, 'address', 'openstreetmap:way/72692154'),
  ('catalogo-andalucia:postal_service:way-755750590', 'Correos La Campana – Calle Palma', NULL, '41022', 'Calle Palma', '41429', 37.56992, -5.42605, 'address', 'openstreetmap:way/755750590');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '41');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 41 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '41'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 75 THEN
    RAISE EXCEPTION 'Se esperaban 75 puntos de Correos en Sevilla, hay %', n;
  END IF;
END;
$$;

COMMIT;

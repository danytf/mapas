-- Carga de la categoría Correos de Asturias (provincia 33), trozo de la carga de Andalucía.
-- Origen: postal_service-asturias.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 65 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-asturias:postal_service:node-10750754117', 'Correos Grado – Calle Eulogio Diaz Miranda', NULL, '33026', 'Calle Eulogio Diaz Miranda 2', '33820', 43.38947, -6.07035, 'address', 'openstreetmap:node/10750754117'),
  ('catalogo-asturias:postal_service:node-11105074200', 'Correos Cangas de Onís – Calle de Constantino González', NULL, '33012', 'Calle de Constantino González 4', '33550', 43.35113, -5.13029, 'address', 'openstreetmap:node/11105074200'),
  ('catalogo-asturias:postal_service:node-11217554564', 'Correos Peñamellera Baja – Trav. de Panes,', NULL, '33047', 'Trav. de Panes, 81', '33570', 43.32333, -4.58432, 'address', 'openstreetmap:node/11217554564'),
  ('catalogo-asturias:postal_service:node-11217832383', 'Correos Valdés – Calle Ramón Asenjo', NULL, '33034', 'Calle Ramón Asenjo 21', '33700', 43.54219, -6.53568, 'address', 'openstreetmap:node/11217832383'),
  ('catalogo-asturias:postal_service:node-11341915838', 'Correos Soto del Barco – Calle Doctor Luis Alarcos', NULL, '33069', 'Calle Doctor Luis Alarcos', '33125', 43.55985, -6.07572, 'address', 'openstreetmap:node/11341915838'),
  ('catalogo-asturias:postal_service:node-11378553395', 'Correos Samartín del Rei Aurelio – Avenida de La Constitución', NULL, '33060', 'Avenida de La Constitución 13', '33950', 43.2746, -5.60227, 'address', 'openstreetmap:node/11378553395'),
  ('catalogo-asturias:postal_service:node-1174759008', 'Correos Samartín del Rei Aurelio – Calle de Extremadura', NULL, '33060', 'Calle de Extremadura', NULL, 43.27286, -5.58803, 'address', 'openstreetmap:node/1174759008'),
  ('catalogo-asturias:postal_service:node-11910703081', 'Correos Oviedo – Calle Fray Ceferino (prolongación)', NULL, '33044', 'Calle Fray Ceferino (prolongación) 48', '33011', 43.36889, -5.84863, 'address', 'openstreetmap:node/11910703081'),
  ('catalogo-asturias:postal_service:node-11922984952', 'Correos Oviedo – Plaza de Eduardo Gota Losada', NULL, '33044', 'Plaza de Eduardo Gota Losada', '33005', 43.35929, -5.85555, 'address', 'openstreetmap:node/11922984952'),
  ('catalogo-asturias:postal_service:node-12084826963', 'Correos Mieres – Dr. Julio Rodríguez Vigil', NULL, '33037', 'Dr. Julio Rodríguez Vigil', '33640', 43.20508, -5.79112, 'address', 'openstreetmap:node/12084826963'),
  ('catalogo-asturias:postal_service:node-12206952237', 'Correos Piloña – Calle San Roque', NULL, '33049', 'Calle San Roque', '33583', 43.35939, -5.30667, 'address', 'openstreetmap:node/12206952237'),
  ('catalogo-asturias:postal_service:node-12398054975', 'Correos Avilés – Calle Río Nalón', NULL, '33004', 'Calle Río Nalón 3', NULL, 43.54809, -5.90003, 'address', 'openstreetmap:node/12398054975'),
  ('catalogo-asturias:postal_service:node-1259379844', 'Correos Oviedo – Carretera de la Estación', NULL, '33044', 'Carretera de la Estación', '33191', 43.35697, -5.91911, 'address', 'openstreetmap:node/1259379844'),
  ('catalogo-asturias:postal_service:node-13112505396', 'Correos Mieres – Calle Juanin de Mieres', NULL, '33037', 'Calle Juanin de Mieres 2', '33600', 43.25264, -5.77258, 'address', 'openstreetmap:node/13112505396'),
  ('catalogo-asturias:postal_service:node-13275142587', 'Correos Castrillón – Calle El Parque', NULL, '33016', 'Calle El Parque', NULL, 43.56401, -5.97419, 'address', 'openstreetmap:node/13275142587'),
  ('catalogo-asturias:postal_service:node-13343490103', 'Correos Riosa – C. La Fuente', NULL, '33058', 'C. La Fuente 1', NULL, 43.23016, -5.88182, 'address', 'openstreetmap:node/13343490103'),
  ('catalogo-asturias:postal_service:node-1398480798', 'Correos Llanera – AV PRUDENCIO GONZÁLEZ, 26.', NULL, '33035', 'AV PRUDENCIO GONZÁLEZ, 26.', '33424', 43.44058, -5.8522, 'address', 'openstreetmap:node/1398480798'),
  ('catalogo-asturias:postal_service:node-14081721493', 'Correos Parres – Calle de Evaristo Valle', NULL, '33045', 'Calle de Evaristo Valle', NULL, 43.38866, -5.18801, 'address', 'openstreetmap:node/14081721493'),
  ('catalogo-asturias:postal_service:node-1420380266', 'Correos San Tirso de Abres – Avenida de Galicia', NULL, '33063', 'Avenida de Galicia', '33774', 43.40926, -7.14291, 'address', 'openstreetmap:node/1420380266'),
  ('catalogo-asturias:postal_service:node-1545571084', 'Correos Oviedo – C/ El Cortijo', NULL, '33044', 'C/ El Cortijo', '33011', 43.38364, -5.82289, 'address', 'openstreetmap:node/1545571084'),
  ('catalogo-asturias:postal_service:node-1549213046', 'Correos Vegadeo – Calle Álvaro Fernández Suárez', NULL, '33074', 'Calle Álvaro Fernández Suárez', '33770', 43.46421, -7.04761, 'address', 'openstreetmap:node/1549213046'),
  ('catalogo-asturias:postal_service:node-1595327452', 'Correos Pravia – Avenida Carmen Miranda', NULL, '33051', 'Avenida Carmen Miranda', '33120', 43.48829, -6.11171, 'address', 'openstreetmap:node/1595327452'),
  ('catalogo-asturias:postal_service:node-1701349433', 'Correos Avilés – Calle Reyes Católicos', NULL, '33004', 'Calle Reyes Católicos', NULL, 43.53713, -5.90486, 'address', 'openstreetmap:node/1701349433'),
  ('catalogo-asturias:postal_service:node-1990847302', 'Correos Villaviciosa – Manuel Álvarez Miranda', NULL, '33076', 'Manuel Álvarez Miranda', '33300', 43.48216, -5.43195, 'address', 'openstreetmap:node/1990847302'),
  ('catalogo-asturias:postal_service:node-2047232156', 'Correos Ibias', NULL, '33028', NULL, '33810', 43.03949, -6.87263, 'address', 'openstreetmap:node/2047232156'),
  ('catalogo-asturias:postal_service:node-2078187221', 'Correos Siero – Calle La Estación', NULL, '33066', 'Calle La Estación 4', '33186', 43.38456, -5.70291, 'address', 'openstreetmap:node/2078187221'),
  ('catalogo-asturias:postal_service:node-2180102340', 'Correos Piloña – Calle Puente Nuevo', NULL, '33049', 'Calle Puente Nuevo 2', '33530', 43.34965, -5.36507, 'address', 'openstreetmap:node/2180102340'),
  ('catalogo-asturias:postal_service:node-2285953308', 'Correos Avilés', NULL, '33004', NULL, '33410', 43.54446, -5.93416, 'address', 'openstreetmap:node/2285953308'),
  ('catalogo-asturias:postal_service:node-2353316907', 'Correos Oviedo – Calle Celestino Zuazua', NULL, '33044', 'Calle Celestino Zuazua', NULL, 43.34715, -5.9687, 'address', 'openstreetmap:node/2353316907'),
  ('catalogo-asturias:postal_service:node-2353472207', 'Correos Oviedo – Calle Alonso Quintanilla', NULL, '33044', 'Calle Alonso Quintanilla 1', '33002', 43.36321, -5.84816, 'address', 'openstreetmap:node/2353472207'),
  ('catalogo-asturias:postal_service:node-2428429879', 'Correos Ribadesella – Calle de Manuel Fernández Junco', NULL, '33056', 'Calle de Manuel Fernández Junco 19', '33560', 43.46259, -5.0574, 'address', 'openstreetmap:node/2428429879'),
  ('catalogo-asturias:postal_service:node-2429284863', 'Correos Lena – Calle de Luis Menéndez Pidal', NULL, '33033', 'Calle de Luis Menéndez Pidal 14', '33630', 43.15923, -5.82828, 'address', 'openstreetmap:node/2429284863'),
  ('catalogo-asturias:postal_service:node-2439225981', 'Correos Navia – Calle As Veigas', NULL, '33041', 'Calle As Veigas 1', '33710', 43.54151, -6.72133, 'address', 'openstreetmap:node/2439225981'),
  ('catalogo-asturias:postal_service:node-2452581376', 'Correos Boal – Avenida de Asturias', NULL, '33007', 'Avenida de Asturias', '33720', 43.42816, -6.81929, 'address', 'openstreetmap:node/2452581376'),
  ('catalogo-asturias:postal_service:node-2586048302', 'Correos Gozón – Calle Avilés', NULL, '33025', 'Calle Avilés', '33440', 43.61531, -5.79388, 'address', 'openstreetmap:node/2586048302'),
  ('catalogo-asturias:postal_service:node-2681624147', 'Correos Carreño – Cai Pedro Herrero', NULL, '33014', 'Cai Pedro Herrero 3', '33430', 43.58924, -5.76406, 'address', 'openstreetmap:node/2681624147'),
  ('catalogo-asturias:postal_service:node-29020721', 'Correos Gijón – Calle Daoíz y Velarde', NULL, '33024', 'Calle Daoíz y Velarde 5', '33212', 43.53999, -5.68364, 'address', 'openstreetmap:node/29020721'),
  ('catalogo-asturias:postal_service:node-2964436491', 'Correos Langreo – Calle A', NULL, '33031', 'Calle A', NULL, 43.30401, -5.7023, 'address', 'openstreetmap:node/2964436491'),
  ('catalogo-asturias:postal_service:node-3006464304', 'Correos Morcín – Urb. Montsacro C9', NULL, '33038', 'Urb. Montsacro C9', '33162', 43.28249, -5.87813, 'address', 'openstreetmap:node/3006464304'),
  ('catalogo-asturias:postal_service:node-3029483134', 'Correos Cudillero – Calle Juan Antonio Bravo', NULL, '33021', 'Calle Juan Antonio Bravo', '33150', 43.55907, -6.15026, 'address', 'openstreetmap:node/3029483134'),
  ('catalogo-asturias:postal_service:node-30313025', 'Correos Gijón – Avenida de Castilla', NULL, '33024', 'Avenida de Castilla 11', '33203', 43.53656, -5.64725, 'address', 'openstreetmap:node/30313025'),
  ('catalogo-asturias:postal_service:node-3365939044', 'Correos Oviedo – Calle Miguel Ángel Blanco', NULL, '33044', 'Calle Miguel Ángel Blanco 21', '33013', 43.36272, -5.86087, 'address', 'openstreetmap:node/3365939044'),
  ('catalogo-asturias:postal_service:node-3437330096', 'Correos Gijón – Avenida Gaspar García Laviana', NULL, '33024', 'Avenida Gaspar García Laviana', '33210', 43.5272, -5.67505, 'address', 'openstreetmap:node/3437330096'),
  ('catalogo-asturias:postal_service:node-3649773439', 'Correos Ribadedeva – Calle La Plaza Bajo', NULL, '33055', 'Calle La Plaza Bajo', NULL, 43.37485, -4.54075, 'address', 'openstreetmap:node/3649773439'),
  ('catalogo-asturias:postal_service:node-3678423585', 'Correos Muros de Nalón – Calle Marqués de Muros', NULL, '33039', 'Calle Marqués de Muros', '33138', 43.5421, -6.10461, 'address', 'openstreetmap:node/3678423585'),
  ('catalogo-asturias:postal_service:node-4054227798', 'Correos Siero – Calle Ería del Hospital', NULL, '33066', 'Calle Ería del Hospital 5', '33510', 43.39213, -5.6631, 'address', 'openstreetmap:node/4054227798'),
  ('catalogo-asturias:postal_service:node-4109440451', 'Correos Colunga – Avenida de la Reconquista', NULL, '33019', 'Avenida de la Reconquista 15', '33320', 43.48466, -5.27131, 'address', 'openstreetmap:node/4109440451'),
  ('catalogo-asturias:postal_service:node-418751771', 'Correos Oviedo – Avenida de Torrelavega', NULL, '33044', 'Avenida de Torrelavega 56', '33010', 43.36473, -5.83224, 'address', 'openstreetmap:node/418751771'),
  ('catalogo-asturias:postal_service:node-4261505169', 'Correos Langreo – Avenida de la Constitución', NULL, '33031', 'Avenida de la Constitución 37', '33900', 43.29532, -5.68313, 'address', 'openstreetmap:node/4261505169'),
  ('catalogo-asturias:postal_service:node-4402246797', 'Correos Gijón – Avenida de El Llano', NULL, '33024', 'Avenida de El Llano 32', '33209', 43.53247, -5.66162, 'address', 'openstreetmap:node/4402246797'),
  ('catalogo-asturias:postal_service:node-4887259861', 'Correos Allande – Alcalde M Flórez', NULL, '33001', 'Alcalde M Flórez', NULL, 43.27239, -6.60858, 'address', 'openstreetmap:node/4887259861'),
  ('catalogo-asturias:postal_service:node-5016957721', 'Correos Belmonte de Miranda – Avenida del Puerto', NULL, '33005', 'Avenida del Puerto', '33830', 43.28285, -6.21862, 'address', 'openstreetmap:node/5016957721'),
  ('catalogo-asturias:postal_service:node-5262300405', 'Correos Avilés – Plaza de La Merced', NULL, '33004', 'Plaza de La Merced', '33401', 43.55841, -5.92399, 'address', 'openstreetmap:node/5262300405'),
  ('catalogo-asturias:postal_service:node-5404229715', 'Correos Noreña – Calle Portilla', NULL, '33042', 'Calle Portilla 7', '33180', 43.39275, -5.70726, 'address', 'openstreetmap:node/5404229715'),
  ('catalogo-asturias:postal_service:node-6176692830', 'Correos Aller – Calle Ramón Campal 9-11', NULL, '33002', 'Calle Ramón Campal 9-11', '33686', 43.16046, -5.62094, 'address', 'openstreetmap:node/6176692830'),
  ('catalogo-asturias:postal_service:node-6342862848', 'Correos Aller – Avenida de la Constitución', NULL, '33002', 'Avenida de la Constitución 28', '33670', 43.16932, -5.73791, 'address', 'openstreetmap:node/6342862848'),
  ('catalogo-asturias:postal_service:node-6711040060', 'Correos Taramundi – Avenida de Galicia', NULL, '33071', 'Avenida de Galicia 16', '33775', 43.36014, -7.10932, 'address', 'openstreetmap:node/6711040060'),
  ('catalogo-asturias:postal_service:node-8346178718', 'Correos Langreo – Calle Jesús Alonso Braga', NULL, '33031', 'Calle Jesús Alonso Braga 1', '33930', 43.30677, -5.69209, 'address', 'openstreetmap:node/8346178718'),
  ('catalogo-asturias:postal_service:node-8772930944', 'Correos Oviedo – Calle Manzanilla', NULL, '33044', 'Calle Manzanilla 22', NULL, 43.33243, -5.7731, 'address', 'openstreetmap:node/8772930944'),
  ('catalogo-asturias:postal_service:node-921332505', 'Correos Llanes – La Calluca', NULL, '33036', 'La Calluca', NULL, 43.42568, -4.81169, 'address', 'openstreetmap:node/921332505'),
  ('catalogo-asturias:postal_service:node-9730225970', 'Correos Salas – Avenida de Galicia', NULL, '33059', 'Avenida de Galicia 7', '33860', 43.40884, -6.26021, 'address', 'openstreetmap:node/9730225970'),
  ('catalogo-asturias:postal_service:way-114120689', 'Correos Llanes – Cueto Bajo', NULL, '33036', 'Cueto Bajo 1', '33500', 43.41841, -4.75371, 'address', 'openstreetmap:way/114120689'),
  ('catalogo-asturias:postal_service:way-289453950', 'Correos Gijón – Calle de Los Moros 53D', NULL, '33024', 'Calle de Los Moros 53D', '33205', 43.53984, -5.66273, 'address', 'openstreetmap:way/289453950'),
  ('catalogo-asturias:postal_service:way-370740362', 'Correos Soto del Barco – Plaza Herminio Noval', NULL, '33069', 'Plaza Herminio Noval 1', '33126', 43.53104, -6.07284, 'address', 'openstreetmap:way/370740362'),
  ('catalogo-asturias:postal_service:way-400525704', 'Correos Langreo – Polígono de Riaño', NULL, '33031', 'Polígono de Riaño 8', '33920', 43.32682, -5.72009, 'address', 'openstreetmap:way/400525704');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '33');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 33 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '33'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 65 THEN
    RAISE EXCEPTION 'Se esperaban 65 puntos de Correos en Asturias, hay %', n;
  END IF;
END;
$$;

COMMIT;

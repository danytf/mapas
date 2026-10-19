-- Carga de la categoría Correos de Jaén (provincia 23), trozo de la carga de Andalucía.
-- Origen: postal_service-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 73 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:postal_service:node-1184142243', 'Correos Quesada – Avenida de Almería', NULL, '23073', 'Avenida de Almería', '23480', 37.84359, -3.06704, 'address', 'openstreetmap:node/1184142243'),
  ('catalogo-andalucia:postal_service:node-1203005129', 'Correos Begíjar – Calle Egido', NULL, '23014', 'Calle Egido', '23520', 37.98573, -3.5333, 'address', 'openstreetmap:node/1203005129'),
  ('catalogo-andalucia:postal_service:node-13309021096', 'Correos Huelma – Calle Federico García Lorca', NULL, '23044', 'Calle Federico García Lorca 18', '23560', 37.6478, -3.45681, 'address', 'openstreetmap:node/13309021096'),
  ('catalogo-andalucia:postal_service:node-13380675141', 'Correos Villanueva del Arzobispo – Avenida de la Constitución', NULL, '23097', 'Avenida de la Constitución', '23330', 38.16976, -3.00935, 'address', 'openstreetmap:node/13380675141'),
  ('catalogo-andalucia:postal_service:node-13612855501', 'Correos Mengíbar – Calle Manuel de la Chica Saeta', NULL, '23061', 'Calle Manuel de la Chica Saeta 10', '23620', 37.96829, -3.8098, 'address', 'openstreetmap:node/13612855501'),
  ('catalogo-andalucia:postal_service:node-1738115271', 'Correos Jaén – Calle Coruña', NULL, '23050', 'Calle Coruña', '23005', 37.77841, -3.80006, 'address', 'openstreetmap:node/1738115271'),
  ('catalogo-andalucia:postal_service:node-1817680222', 'Correos Cambil – Calle Posadas', NULL, '23018', 'Calle Posadas', '23120', 37.67602, -3.56577, 'address', 'openstreetmap:node/1817680222'),
  ('catalogo-andalucia:postal_service:node-1923815595', 'Correos Navas de San Juan – Calle Real', NULL, '23063', 'Calle Real', '23240', 38.18354, -3.31711, 'address', 'openstreetmap:node/1923815595'),
  ('catalogo-andalucia:postal_service:node-1931462597', 'Correos Santo Tomé – Carretera de Villacarrillo', NULL, '23080', 'Carretera de Villacarrillo 2', '23311', 38.02896, -3.1004, 'address', 'openstreetmap:node/1931462597'),
  ('catalogo-andalucia:postal_service:node-2067301295', 'Correos Linares – Plaza San Francisco', NULL, '23055', 'Plaza San Francisco', '23700', 38.09449, -3.63199, 'address', 'openstreetmap:node/2067301295'),
  ('catalogo-andalucia:postal_service:node-2115198695', 'Correos La Guardia de Jaén – Calle Juan Montilla', NULL, '23038', 'Calle Juan Montilla', '23170', 37.74286, -3.69361, 'address', 'openstreetmap:node/2115198695'),
  ('catalogo-andalucia:postal_service:node-2408303668', 'Correos Cabra del Santo Cristo – Calle Río', NULL, '23017', 'Calle Río', '23550', 37.70521, -3.28551, 'address', 'openstreetmap:node/2408303668'),
  ('catalogo-andalucia:postal_service:node-2510123013', 'Correos Torre del Campo – Paseo de la Estación', NULL, '23086', 'Paseo de la Estación', '23640', 37.77277, -3.90032, 'address', 'openstreetmap:node/2510123013'),
  ('catalogo-andalucia:postal_service:node-2747086005', 'Correos Torreperogil – Calle Nueva', NULL, '23088', 'Calle Nueva', '23320', 38.03405, -3.2883, 'address', 'openstreetmap:node/2747086005'),
  ('catalogo-andalucia:postal_service:node-2772020223', 'Correos Cazorla – Calle Hilario Marcos', NULL, '23028', 'Calle Hilario Marcos', '23470', 37.91698, -3.00459, 'address', 'openstreetmap:node/2772020223'),
  ('catalogo-andalucia:postal_service:node-2772117195', 'Correos Peal de Becerro – Plaza del Ayuntamiento', NULL, '23066', 'Plaza del Ayuntamiento', '23460', 37.91358, -3.12153, 'address', 'openstreetmap:node/2772117195'),
  ('catalogo-andalucia:postal_service:node-2775095086', 'Correos Jódar – Calle General Fresneda', NULL, '23053', 'Calle General Fresneda 56', '23500', 37.84137, -3.35257, 'address', 'openstreetmap:node/2775095086'),
  ('catalogo-andalucia:postal_service:node-2776675637', 'Correos Jódar – Calle José Beltrán', NULL, '23053', 'Calle José Beltrán 5', '23500', 37.84393, -3.35183, 'address', 'openstreetmap:node/2776675637'),
  ('catalogo-andalucia:postal_service:node-3012411660', 'Correos Porcuna – Calle Doctor Fernán Pérez', NULL, '23069', 'Calle Doctor Fernán Pérez 12', '23790', 37.86968, -4.18545, 'address', 'openstreetmap:node/3012411660'),
  ('catalogo-andalucia:postal_service:node-3397234603', 'Correos Mancha Real – Calle Maestra', NULL, '23058', 'Calle Maestra 103', '23100', 37.78632, -3.61012, 'address', 'openstreetmap:node/3397234603'),
  ('catalogo-andalucia:postal_service:node-3404233454', 'Correos Torredonjimeno – Plaza de la Constitución', NULL, '23087', 'Plaza de la Constitución 12', '23650', 37.76578, -3.95806, 'address', 'openstreetmap:node/3404233454'),
  ('catalogo-andalucia:postal_service:node-3627427792', 'Correos Hinojares – Calle Baja', NULL, '23042', 'Calle Baja', '23486', 37.71545, -2.99758, 'address', 'openstreetmap:node/3627427792'),
  ('catalogo-andalucia:postal_service:node-3627457726', 'Correos Villarrodrigo – Calle Ancha', NULL, '23101', 'Calle Ancha', NULL, 38.4881, -2.63626, 'address', 'openstreetmap:node/3627457726'),
  ('catalogo-andalucia:postal_service:node-3639011191', 'Correos Hornos – Calle San Bartolomé', NULL, '23043', 'Calle San Bartolomé', '23293', 38.21762, -2.71922, 'address', 'openstreetmap:node/3639011191'),
  ('catalogo-andalucia:postal_service:node-3641247934', 'Correos Torres de Albánchez – Calle Isaac Albéniz', NULL, '23091', 'Calle Isaac Albéniz', '23391', 38.41472, -2.67829, 'address', 'openstreetmap:node/3641247934'),
  ('catalogo-andalucia:postal_service:node-3641336962', 'Correos Lupión – Calle Ramón y Cajal', NULL, '23057', 'Calle Ramón y Cajal', '23528', 37.99762, -3.54549, 'address', 'openstreetmap:node/3641336962'),
  ('catalogo-andalucia:postal_service:node-3647247130', 'Correos Iznatoraf – Calle Ministro Gómez de Llano', NULL, '23048', 'Calle Ministro Gómez de Llano', '23338', 38.15679, -3.03303, 'address', 'openstreetmap:node/3647247130'),
  ('catalogo-andalucia:postal_service:node-3649339870', 'Correos Villardompardo – Travesía Plaza del Llano', NULL, '23098', 'Travesía Plaza del Llano', NULL, 37.83843, -4.00178, 'address', 'openstreetmap:node/3649339870'),
  ('catalogo-andalucia:postal_service:node-3661561633', 'Correos Sorihuela del Guadalimar – Calle Ramón y Cajal', NULL, '23084', 'Calle Ramón y Cajal', NULL, 38.23963, -3.05433, 'address', 'openstreetmap:node/3661561633'),
  ('catalogo-andalucia:postal_service:node-3663428144', 'Correos Jimena – Calle Fuente', NULL, '23052', 'Calle Fuente', '23539', 37.84123, -3.47616, 'address', 'openstreetmap:node/3663428144'),
  ('catalogo-andalucia:postal_service:node-3664898191', 'Correos Chilluévar – Avenida de Andalucía', NULL, '23030', 'Avenida de Andalucía 6', '23477', 38.00152, -3.03107, 'address', 'openstreetmap:node/3664898191'),
  ('catalogo-andalucia:postal_service:node-3667578355', 'Correos Torres – Plaza de España', NULL, '23090', 'Plaza de España', '23540', 37.78606, -3.50975, 'address', 'openstreetmap:node/3667578355'),
  ('catalogo-andalucia:postal_service:node-3670686971', 'Correos Bélmez de la Moraleda – Calle Guzmán Merino', NULL, '23015', 'Calle Guzmán Merino', NULL, 37.72384, -3.38213, 'address', 'openstreetmap:node/3670686971'),
  ('catalogo-andalucia:postal_service:node-3680927313', 'Correos Segura de la Sierra – Calle Dolores', NULL, '23081', 'Calle Dolores', '23293', 38.24729, -2.72545, 'address', 'openstreetmap:node/3680927313'),
  ('catalogo-andalucia:postal_service:node-3682815415', 'Correos Orcera – Calle Wenceslao de la Cruz', NULL, '23065', 'Calle Wenceslao de la Cruz', '23370', 38.31772, -2.6609, 'address', 'openstreetmap:node/3682815415'),
  ('catalogo-andalucia:postal_service:node-3685389479', 'Correos Campillo de Arenas – Calle de la Virgen', NULL, '23019', 'Calle de la Virgen', '23140', 37.55487, -3.63537, 'address', 'openstreetmap:node/3685389479'),
  ('catalogo-andalucia:postal_service:node-3685473447', 'Correos Canena – Calle Estación', NULL, '23020', 'Calle Estación', '23430', 38.04787, -3.48477, 'address', 'openstreetmap:node/3685473447'),
  ('catalogo-andalucia:postal_service:node-3686077697', 'Correos Noalejo – Calle Santo Cristo', NULL, '23064', 'Calle Santo Cristo', '23140', 37.52945, -3.65354, 'address', 'openstreetmap:node/3686077697'),
  ('catalogo-andalucia:postal_service:node-3688365608', 'Correos Puente de Génave – Avenida de Andalucía', NULL, '23071', 'Avenida de Andalucía', '23350', 38.35637, -2.80293, 'address', 'openstreetmap:node/3688365608'),
  ('catalogo-andalucia:postal_service:node-3693784249', 'Correos Jabalquinto – Plaza del Ayuntamiento', NULL, '23049', 'Plaza del Ayuntamiento', NULL, 38.01969, -3.72431, 'address', 'openstreetmap:node/3693784249'),
  ('catalogo-andalucia:postal_service:node-3693997664', 'Correos Siles – Calle San Gregorio', NULL, '23082', 'Calle San Gregorio', '23380', 38.38727, -2.58238, 'address', 'openstreetmap:node/3693997664'),
  ('catalogo-andalucia:postal_service:node-3698357862', 'Correos La Puerta de Segura – Calle Juan José Moreno Mira', NULL, '23072', 'Calle Juan José Moreno Mira', '23360', 38.34806, -2.73748, 'address', 'openstreetmap:node/3698357862'),
  ('catalogo-andalucia:postal_service:node-3699700348', 'Correos Huesa – Avenida del Primero de Mayo', NULL, '23045', 'Avenida del Primero de Mayo', NULL, 37.76452, -3.07739, 'address', 'openstreetmap:node/3699700348'),
  ('catalogo-andalucia:postal_service:node-3704487784', 'Correos Baños de la Encina – Plaza de la Constitución', NULL, '23011', 'Plaza de la Constitución', '23711', 38.17084, -3.7747, 'address', 'openstreetmap:node/3704487784'),
  ('catalogo-andalucia:postal_service:node-3705219249', 'Correos Torreblascopedro – Calle Federico García Lorca', NULL, '23085', 'Calle Federico García Lorca', '23510', 37.99727, -3.63618, 'address', 'openstreetmap:node/3705219249'),
  ('catalogo-andalucia:postal_service:node-3707013825', 'Correos Bedmar y Garcíez – Plaza de la Constitución', NULL, '23902', 'Plaza de la Constitución', '23537', 37.82274, -3.4117, 'address', 'openstreetmap:node/3707013825'),
  ('catalogo-andalucia:postal_service:node-3710445139', 'Correos Guarromán – Calle Pósito', NULL, '23039', 'Calle Pósito', '23210', 38.18303, -3.68795, 'address', 'openstreetmap:node/3710445139'),
  ('catalogo-andalucia:postal_service:node-3710827107', 'Correos Ibros – Plaza del Ayuntamiento', NULL, '23046', 'Plaza del Ayuntamiento', '23450', 38.02269, -3.50254, 'address', 'openstreetmap:node/3710827107'),
  ('catalogo-andalucia:postal_service:node-3715073431', 'Correos Pegalajar – Calle Santa María', NULL, '23067', 'Calle Santa María', '23110', 37.7401, -3.64771, 'address', 'openstreetmap:node/3715073431'),
  ('catalogo-andalucia:postal_service:node-3718836223', 'Correos Fuensanta de Martos – Paseo de los Naranjos', NULL, '23034', 'Paseo de los Naranjos', NULL, 37.6478, -3.90496, 'address', 'openstreetmap:node/3718836223'),
  ('catalogo-andalucia:postal_service:node-3720277184', 'Correos Villanueva de la Reina – Calle Blas Infante', NULL, '23096', 'Calle Blas Infante', '23628', 38.00457, -3.91895, 'address', 'openstreetmap:node/3720277184'),
  ('catalogo-andalucia:postal_service:node-3721898446', 'Correos Santiago-Pontones – Calle Don Jaime', NULL, '23904', 'Calle Don Jaime', '23290', 38.11275, -2.55195, 'address', 'openstreetmap:node/3721898446'),
  ('catalogo-andalucia:postal_service:node-3728060345', 'Correos Jamilena – Calle Parras', NULL, '23051', 'Calle Parras', '23658', 37.74756, -3.91311, 'address', 'openstreetmap:node/3728060345'),
  ('catalogo-andalucia:postal_service:node-3728214943', 'Correos Castellar – Avenida de Pepe López', NULL, '23025', 'Avenida de Pepe López', '23260', 38.25496, -3.13254, 'address', 'openstreetmap:node/3728214943'),
  ('catalogo-andalucia:postal_service:node-3732019170', 'Correos Arjonilla – Avenida de Andalucía', NULL, '23007', 'Avenida de Andalucía', '23750', 37.97362, -4.10468, 'address', 'openstreetmap:node/3732019170'),
  ('catalogo-andalucia:postal_service:node-3741112239', 'Correos Lopera – Calle Juan Domingo Gálvez Pérez', NULL, '23056', 'Calle Juan Domingo Gálvez Pérez', '23780', 37.9435, -4.21465, 'address', 'openstreetmap:node/3741112239'),
  ('catalogo-andalucia:postal_service:node-3747549181', 'Correos Valdepeñas de Jaén – Plaza de la Constitución', NULL, '23093', 'Plaza de la Constitución', '23150', 37.59068, -3.82016, 'address', 'openstreetmap:node/3747549181'),
  ('catalogo-andalucia:postal_service:node-3913419960', 'Correos Hornos – Calle Horno', NULL, '23043', 'Calle Horno', '23293', 38.21636, -2.71999, 'address', 'openstreetmap:node/3913419960'),
  ('catalogo-andalucia:postal_service:node-3964608536', 'Correos Sabiote – Pasaje Torreones', NULL, '23075', 'Pasaje Torreones', '23410', 38.0689, -3.3061, 'address', 'openstreetmap:node/3964608536'),
  ('catalogo-andalucia:postal_service:node-4922113816', 'Correos Aldeaquemada – Plaza de Antonia Mª Antonaya Gallardo', NULL, '23004', 'Plaza de Antonia Mª Antonaya Gallardo', '23215', 38.41222, -3.37119, 'address', 'openstreetmap:node/4922113816'),
  ('catalogo-andalucia:postal_service:node-5261803510', 'Correos Martos – Plaza Almazara', NULL, '23060', 'Plaza Almazara', '23600', 37.72279, -3.97097, 'address', 'openstreetmap:node/5261803510'),
  ('catalogo-andalucia:postal_service:node-5538460693', 'Correos Alcalá la Real – Calle Veracruz', NULL, '23002', 'Calle Veracruz', '23680', 37.46283, -3.92383, 'address', 'openstreetmap:node/5538460693'),
  ('catalogo-andalucia:postal_service:node-6534398527', 'Correos Villatorres – Calle Pablo Iglesias', NULL, '23903', 'Calle Pablo Iglesias', '23630', 37.93995, -3.73046, 'address', 'openstreetmap:node/6534398527'),
  ('catalogo-andalucia:postal_service:way-123250501', 'Correos La Carolina – Plaza de Blas Infante', NULL, '23024', 'Plaza de Blas Infante', '23200', 38.27309, -3.61716, 'address', 'openstreetmap:way/123250501'),
  ('catalogo-andalucia:postal_service:way-237730587', 'Correos Jaén – Plaza de los Jardinillos', NULL, '23050', 'Plaza de los Jardinillos', '23004', 37.76919, -3.79046, 'address', 'openstreetmap:way/237730587'),
  ('catalogo-andalucia:postal_service:way-292500210', 'Correos Úbeda – Calle Trinidad', NULL, '23092', 'Calle Trinidad 4', '23400', 38.0121, -3.37115, 'address', 'openstreetmap:way/292500210'),
  ('catalogo-andalucia:postal_service:way-361053070', 'Correos Albanchez de Mágina – Avenida de Hútar', NULL, '23001', 'Avenida de Hútar', '23538', 37.79342, -3.46642, 'address', 'openstreetmap:way/361053070'),
  ('catalogo-andalucia:postal_service:way-363808060', 'Correos Arquillos – Avenida de Andalucía', NULL, '23008', 'Avenida de Andalucía', NULL, 38.18344, -3.42844, 'address', 'openstreetmap:way/363808060'),
  ('catalogo-andalucia:postal_service:way-550970721', 'Correos Bailén – Calle Doctor Fleming', NULL, '23010', 'Calle Doctor Fleming', '23710', 38.09716, -3.77451, 'address', 'openstreetmap:way/550970721'),
  ('catalogo-andalucia:postal_service:way-579785032', 'Correos Andújar – 12', NULL, '23005', '12', '23740', 38.03753, -4.05436, 'address', 'openstreetmap:way/579785032'),
  ('catalogo-andalucia:postal_service:way-677088263', 'Correos Linares – Avenida de Linares', NULL, '23055', 'Avenida de Linares', '23700', 38.07179, -3.58841, 'address', 'openstreetmap:way/677088263'),
  ('catalogo-andalucia:postal_service:way-709635899', 'Correos Baeza – Calle Julio Burell', NULL, '23009', 'Calle Julio Burell 19', '23440', 37.99328, -3.46583, 'address', 'openstreetmap:way/709635899'),
  ('catalogo-andalucia:postal_service:way-936825532', 'Correos Jaén – Calle Bélmez de la Moraleda', NULL, '23050', 'Calle Bélmez de la Moraleda', '23009', 37.79785, -3.78817, 'address', 'openstreetmap:way/936825532');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '23');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 23 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '23'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 73 THEN
    RAISE EXCEPTION 'Se esperaban 73 puntos de Correos en Jaén, hay %', n;
  END IF;
END;
$$;

COMMIT;

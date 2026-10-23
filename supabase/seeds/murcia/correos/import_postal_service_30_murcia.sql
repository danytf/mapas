-- Carga de la categoría Correos de Murcia (provincia 30), trozo de la carga de Andalucía.
-- Origen: postal_service-murcia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:38:36Z).
-- 50 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-murcia:postal_service:node-10095868638', 'Correos Murcia – Calle Pintor Pedro Flores', NULL, '30030', 'Calle Pintor Pedro Flores 8', NULL, 37.97504, -1.12758, 'address', 'openstreetmap:node/10095868638'),
  ('catalogo-murcia:postal_service:node-11336192671', 'Correos San Javier – Calle Correos', NULL, '30035', 'Calle Correos', NULL, 37.80626, -0.83463, 'address', 'openstreetmap:node/11336192671'),
  ('catalogo-murcia:postal_service:node-13465185812', 'Correos Cartagena – Calle Guillermo Villa', NULL, '30016', 'Calle Guillermo Villa', '30395', 37.71678, -0.92345, 'address', 'openstreetmap:node/13465185812'),
  ('catalogo-murcia:postal_service:node-1405078698', 'Correos Lorca – Calle Musso Valiente', NULL, '30024', 'Calle Musso Valiente', '30800', 37.67531, -1.69738, 'address', 'openstreetmap:node/1405078698'),
  ('catalogo-murcia:postal_service:node-1593122944', 'Correos Águilas – Plaza de Alfonso Escámez', NULL, '30003', 'Plaza de Alfonso Escámez', '30880', 37.40316, -1.57961, 'address', 'openstreetmap:node/1593122944'),
  ('catalogo-murcia:postal_service:node-1654353344', 'Correos Molina de Segura – Avenida de Gutiérrez Mellado', NULL, '30027', 'Avenida de Gutiérrez Mellado', NULL, 38.05869, -1.20985, 'address', 'openstreetmap:node/1654353344'),
  ('catalogo-murcia:postal_service:node-1704122156', 'Correos Beniel – Plaza Ramón y Cajal', NULL, '30010', 'Plaza Ramón y Cajal 9', '30130', 38.04611, -1.00133, 'address', 'openstreetmap:node/1704122156'),
  ('catalogo-murcia:postal_service:node-1708331635', 'Correos Murcia – Avenida Levante', NULL, '30030', 'Avenida Levante', '30100', 38.01222, -1.15386, 'address', 'openstreetmap:node/1708331635'),
  ('catalogo-murcia:postal_service:node-2058472199', 'Correos San Javier – Avenida Sandoval', NULL, '30035', 'Avenida Sandoval', NULL, 37.79742, -0.8059, 'address', 'openstreetmap:node/2058472199'),
  ('catalogo-murcia:postal_service:node-2432127493', 'Correos Jumilla – Calle Doctor Fleming', NULL, '30022', 'Calle Doctor Fleming 2', '30520', 38.47288, -1.32989, 'address', 'openstreetmap:node/2432127493'),
  ('catalogo-murcia:postal_service:node-2435276757', 'Correos Blanca – Calle Manuel de Falla', NULL, '30011', 'Calle Manuel de Falla', NULL, 38.17871, -1.3738, 'address', 'openstreetmap:node/2435276757'),
  ('catalogo-murcia:postal_service:node-2621046422', 'Correos Cartagena – Calle Jardines', NULL, '30016', 'Calle Jardines 2', NULL, 37.64, -1.00552, 'address', 'openstreetmap:node/2621046422'),
  ('catalogo-murcia:postal_service:node-2621046425', 'Correos Cartagena – Calle Submarino', NULL, '30016', 'Calle Submarino 63', '30300', 37.62601, -0.9891, 'address', 'openstreetmap:node/2621046425'),
  ('catalogo-murcia:postal_service:node-2650379588', 'Correos Lorquí – Calle La Cerca', NULL, '30025', 'Calle La Cerca', NULL, 38.08111, -1.25469, 'address', 'openstreetmap:node/2650379588'),
  ('catalogo-murcia:postal_service:node-2713645733', 'Correos Molina de Segura – Avenida de la Industria', NULL, '30027', 'Avenida de la Industria', NULL, 38.05154, -1.21523, 'address', 'openstreetmap:node/2713645733'),
  ('catalogo-murcia:postal_service:node-3928934438', 'Correos Murcia – Calle Alegría', NULL, '30030', 'Calle Alegría 4', '30158', 37.95532, -1.094, 'address', 'openstreetmap:node/3928934438'),
  ('catalogo-murcia:postal_service:node-3946262245', 'Correos Torre Pacheco – Calle José Jiménez', NULL, '30037', 'Calle José Jiménez', NULL, 37.7413, -0.95542, 'address', 'openstreetmap:node/3946262245'),
  ('catalogo-murcia:postal_service:node-4052430819', 'Correos Mazarrón – Plaza del Ayuntamiento', NULL, '30026', 'Plaza del Ayuntamiento', NULL, 37.59807, -1.31621, 'address', 'openstreetmap:node/4052430819'),
  ('catalogo-murcia:postal_service:node-4078871127', 'Correos Ceutí – Calle Chapí', NULL, '30018', 'Calle Chapí 1', '30562', 38.07911, -1.27861, 'address', 'openstreetmap:node/4078871127'),
  ('catalogo-murcia:postal_service:node-4352547081', 'Correos Murcia – Calle Cura Jiménez', NULL, '30030', 'Calle Cura Jiménez', '30580', 38.01297, -1.03515, 'address', 'openstreetmap:node/4352547081'),
  ('catalogo-murcia:postal_service:node-4777196652', 'Correos Caravaca de la Cruz – Avenida Maruja Garrido', NULL, '30015', 'Avenida Maruja Garrido', '30440', 38.10409, -1.86136, 'address', 'openstreetmap:node/4777196652'),
  ('catalogo-murcia:postal_service:node-4777196654', 'Correos Calasparra – Calle Santa Teresa', NULL, '30013', 'Calle Santa Teresa', NULL, 38.2286, -1.70257, 'address', 'openstreetmap:node/4777196654'),
  ('catalogo-murcia:postal_service:node-4797401863', 'Correos Cartagena – Calle Fernando Magallanes', NULL, '30016', 'Calle Fernando Magallanes 23', NULL, 37.71256, -0.99345, 'address', 'openstreetmap:node/4797401863'),
  ('catalogo-murcia:postal_service:node-4851617191', 'Correos Cartagena – Avenida Filipinas', NULL, '30016', 'Avenida Filipinas', '30366', 37.64677, -0.86819, 'address', 'openstreetmap:node/4851617191'),
  ('catalogo-murcia:postal_service:node-4851617192', 'Correos La Unión – Calle Méndez Núñez', NULL, '30041', 'Calle Méndez Núñez 1', NULL, 37.61781, -0.87613, 'address', 'openstreetmap:node/4851617192'),
  ('catalogo-murcia:postal_service:node-4851617193', 'Correos Cartagena', NULL, '30016', NULL, NULL, 37.60086, -0.80401, 'address', 'openstreetmap:node/4851617193'),
  ('catalogo-murcia:postal_service:node-4851617204', 'Correos Cartagena – Gran Vía de La Manga', NULL, '30016', 'Gran Vía de La Manga', NULL, 37.65915, -0.72263, 'address', 'openstreetmap:node/4851617204'),
  ('catalogo-murcia:postal_service:node-4980246217', 'Correos Puerto Lumbreras – Calle Augusto Vels', NULL, '30033', 'Calle Augusto Vels', '30890', 37.56287, -1.807, 'address', 'openstreetmap:node/4980246217'),
  ('catalogo-murcia:postal_service:node-5003642817', 'Correos Alhama de Murcia – Calle Jacinto Benavente', NULL, '30008', 'Calle Jacinto Benavente', NULL, 37.84824, -1.42576, 'address', 'openstreetmap:node/5003642817'),
  ('catalogo-murcia:postal_service:node-5016807803', 'Correos Fuente Álamo de Murcia – Plaza de San Agustín', NULL, '30021', 'Plaza de San Agustín 13', '30320', 37.72369, -1.16956, 'address', 'openstreetmap:node/5016807803'),
  ('catalogo-murcia:postal_service:node-5033284674', 'Correos Abanilla – Calle Encomienda', NULL, '30001', 'Calle Encomienda', NULL, 38.20632, -1.04269, 'address', 'openstreetmap:node/5033284674'),
  ('catalogo-murcia:postal_service:node-5036798169', 'Correos Abarán – Plaza de la Zarzuela', NULL, '30002', 'Plaza de la Zarzuela', '30550', 38.20558, -1.39627, 'address', 'openstreetmap:node/5036798169'),
  ('catalogo-murcia:postal_service:node-5041562015', 'Correos Albudeite – Calle Pleiteras', NULL, '30004', 'Calle Pleiteras', NULL, 38.03041, -1.38735, 'address', 'openstreetmap:node/5041562015'),
  ('catalogo-murcia:postal_service:node-5046887255', 'Correos Torre Pacheco – Calle Mayor', NULL, '30037', 'Calle Mayor', NULL, 37.79564, -1.01044, 'address', 'openstreetmap:node/5046887255'),
  ('catalogo-murcia:postal_service:node-5084469238', 'Correos Fortuna – Calle Sánchez Bautista', NULL, '30020', 'Calle Sánchez Bautista', NULL, 38.18056, -1.12382, 'address', 'openstreetmap:node/5084469238'),
  ('catalogo-murcia:postal_service:node-5122577170', 'Correos Mula – Calle Feria', NULL, '30029', 'Calle Feria', NULL, 38.03662, -1.49475, 'address', 'openstreetmap:node/5122577170'),
  ('catalogo-murcia:postal_service:node-5157777519', 'Correos Las Torres de Cotillas – Paseo de Fernández Jara', NULL, '30038', 'Paseo de Fernández Jara', NULL, 38.02884, -1.24096, 'address', 'openstreetmap:node/5157777519'),
  ('catalogo-murcia:postal_service:node-5162082293', 'Correos Pliego – Calle San Benito', NULL, '30032', 'Calle San Benito', NULL, 37.99063, -1.50837, 'address', 'openstreetmap:node/5162082293'),
  ('catalogo-murcia:postal_service:node-530975645', 'Correos Santomera – Calle Velázquez', NULL, '30901', 'Calle Velázquez', NULL, 38.05919, -1.04973, 'address', 'openstreetmap:node/530975645'),
  ('catalogo-murcia:postal_service:node-617136451', 'Correos Cartagena – Plaza de San Francisco', NULL, '30016', 'Plaza de San Francisco 9', '30201', 37.60247, -0.98386, 'address', 'openstreetmap:node/617136451'),
  ('catalogo-murcia:postal_service:node-674869062', 'Correos Murcia – Calle Rosalinda', NULL, '30030', 'Calle Rosalinda 31', '30833', 37.92849, -1.20984, 'address', 'openstreetmap:node/674869062'),
  ('catalogo-murcia:postal_service:node-7167738023', 'Correos Murcia – Trovedero Repuntín', NULL, '30030', 'Trovedero Repuntín 9', NULL, 37.99206, -1.1013, 'address', 'openstreetmap:node/7167738023'),
  ('catalogo-murcia:postal_service:node-7829285576', 'Correos Cehegín – Calle Poniente', NULL, '30017', 'Calle Poniente 1', '30430', 38.09356, -1.80063, 'address', 'openstreetmap:node/7829285576'),
  ('catalogo-murcia:postal_service:node-9376474056', 'Correos San Pedro del Pinatar – Avenida de las Salinas', NULL, '30036', 'Avenida de las Salinas', NULL, 37.83307, -0.78915, 'address', 'openstreetmap:node/9376474056'),
  ('catalogo-murcia:postal_service:way-223857617', 'Correos Campos del Río – Plaza del Reloj', NULL, '30014', 'Plaza del Reloj', NULL, 38.03908, -1.34855, 'address', 'openstreetmap:way/223857617'),
  ('catalogo-murcia:postal_service:way-27893505', 'Correos Murcia – Avenida Juan Carlos I', NULL, '30030', 'Avenida Juan Carlos I', '30008', 37.99266, -1.13179, 'address', 'openstreetmap:way/27893505'),
  ('catalogo-murcia:postal_service:way-302869624', 'Correos Cieza – Calle Mesones', NULL, '30019', 'Calle Mesones 23', '30530', 38.2375, -1.42407, 'address', 'openstreetmap:way/302869624'),
  ('catalogo-murcia:postal_service:way-524692126', 'Correos Lorquí – Plaza de España', NULL, '30025', 'Plaza de España', NULL, 38.10362, -1.23049, 'address', 'openstreetmap:way/524692126'),
  ('catalogo-murcia:postal_service:way-550631027', 'Correos Moratalla – Callejón de Los Almendros', NULL, '30028', 'Callejón de Los Almendros', '30440', 38.18677, -1.89289, 'address', 'openstreetmap:way/550631027'),
  ('catalogo-murcia:postal_service:way-637208307', 'Correos Aledo – Calle Fuensanta', NULL, '30006', 'Calle Fuensanta', NULL, 37.79463, -1.57379, 'address', 'openstreetmap:way/637208307');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '30');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 30 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '30'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 50 THEN
    RAISE EXCEPTION 'Se esperaban 50 puntos de Correos en Murcia, hay %', n;
  END IF;
END;
$$;

COMMIT;

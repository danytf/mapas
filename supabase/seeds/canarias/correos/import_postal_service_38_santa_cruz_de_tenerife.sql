-- Carga de la categoría Correos de Santa Cruz de Tenerife (provincia 38), trozo de la carga de Andalucía.
-- Origen: postal_service-canarias.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-21T20:21:46Z).
-- 66 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-canarias:postal_service:node-10035186651', 'Correos Santa Cruz de Tenerife – Avenida Islas Canarias', NULL, '38038', 'Avenida Islas Canarias 125', '38008', 28.46393, -16.27264, 'address', 'openstreetmap:node/10035186651'),
  ('catalogo-canarias:postal_service:node-10307586110', 'Correos Barlovento – Calle del Calvario', NULL, '38007', 'Calle del Calvario', NULL, 28.82812, -17.80405, 'address', 'openstreetmap:node/10307586110'),
  ('catalogo-canarias:postal_service:node-10915678501', 'Correos San Andrés y Sauces – Calle Alonso Pérez Diaz', NULL, '38033', 'Calle Alonso Pérez Diaz 22', '38720', 28.80327, -17.77434, 'address', 'openstreetmap:node/10915678501'),
  ('catalogo-canarias:postal_service:node-11052580144', 'Correos Santa Cruz de Tenerife – Avenida Víctor Zurita Soler', NULL, '38038', 'Avenida Víctor Zurita Soler', '38003', 28.45929, -16.25378, 'address', 'openstreetmap:node/11052580144'),
  ('catalogo-canarias:postal_service:node-12956693962', 'Correos Santa Cruz de La Palma – Avenida Los Indianos', NULL, '38037', 'Avenida Los Indianos', NULL, 28.67938, -17.76676, 'address', 'openstreetmap:node/12956693962'),
  ('catalogo-canarias:postal_service:node-1314483624', 'Correos Granadilla de Abona – Avenida Magallanes', NULL, '38017', 'Avenida Magallanes 21', '38612', 28.04661, -16.53668, 'address', 'openstreetmap:node/1314483624'),
  ('catalogo-canarias:postal_service:node-1319067015', 'Correos Los Silos – Calle la Estrella', NULL, '38042', 'Calle la Estrella 28', '38470', 28.36622, -16.81869, 'address', 'openstreetmap:node/1319067015'),
  ('catalogo-canarias:postal_service:node-1386852570', 'Correos San Cristóbal de La Laguna – Urbanización Montalmar', NULL, '38023', 'Urbanización Montalmar 1', '38250', 28.55407, -16.34471, 'address', 'openstreetmap:node/1386852570'),
  ('catalogo-canarias:postal_service:node-1433904509', 'Correos Santa Cruz de Tenerife – Rambla Añaza', NULL, '38038', 'Rambla Añaza 19', NULL, 28.42662, -16.29824, 'address', 'openstreetmap:node/1433904509'),
  ('catalogo-canarias:postal_service:node-1453214044', 'Correos Tegueste – Carretera de La Laguna a Punta del Hidalgo', NULL, '38046', 'Carretera de La Laguna a Punta del Hidalgo 192', NULL, 28.52076, -16.33678, 'address', 'openstreetmap:node/1453214044'),
  ('catalogo-canarias:postal_service:node-1470042381', 'Correos Arico – Calle Arena', NULL, '38005', 'Calle Arena 10', '38588', 28.16358, -16.43261, 'address', 'openstreetmap:node/1470042381'),
  ('catalogo-canarias:postal_service:node-1516408500', 'Correos Santa Cruz de Tenerife – Avenida Príncipes de España 6C', NULL, '38038', 'Avenida Príncipes de España 6C', NULL, 28.45487, -16.28457, 'address', 'openstreetmap:node/1516408500'),
  ('catalogo-canarias:postal_service:node-1554176168', 'Correos Santiago del Teide – Calle la Placeta', NULL, '38040', 'Calle la Placeta 21', '38690', 28.29719, -16.81581, 'address', 'openstreetmap:node/1554176168'),
  ('catalogo-canarias:postal_service:node-1621560276', 'Correos El Pinar de El Hierro – Calle el Roque', NULL, '38901', 'Calle el Roque 4', '38914', 27.70333, -17.9815, 'address', 'openstreetmap:node/1621560276'),
  ('catalogo-canarias:postal_service:node-1678223646', 'Correos Arafo – Calle Beato Párroco Don Vicente Jorge Dorta', NULL, '38004', 'Calle Beato Párroco Don Vicente Jorge Dorta 5', '38550', 28.34009, -16.41823, 'address', 'openstreetmap:node/1678223646'),
  ('catalogo-canarias:postal_service:node-1707472547', 'Correos Granadilla de Abona – Calle Topacio', NULL, '38017', 'Calle Topacio', NULL, 28.08488, -16.56089, 'address', 'openstreetmap:node/1707472547'),
  ('catalogo-canarias:postal_service:node-1878055191', 'Correos Arico – Carretera General del Sur', NULL, '38005', 'Carretera General del Sur 22', '38580', 28.16589, -16.50171, 'address', 'openstreetmap:node/1878055191'),
  ('catalogo-canarias:postal_service:node-1897523904', 'Correos San Juan de la Rambla – Calle El Sol', NULL, '38034', 'Calle El Sol 2', '38420', 28.39405, -16.64742, 'address', 'openstreetmap:node/1897523904'),
  ('catalogo-canarias:postal_service:node-2028531619', 'Correos Buenavista del Norte – Calle La Cruz', NULL, '38010', 'Calle La Cruz 3', '38489', 28.34491, -16.84614, 'address', 'openstreetmap:node/2028531619'),
  ('catalogo-canarias:postal_service:node-2076059020', 'Correos Santa Cruz de Tenerife – Calle de la Cruz', NULL, '38038', 'Calle de la Cruz 1', '38120', 28.5047, -16.19152, 'address', 'openstreetmap:node/2076059020'),
  ('catalogo-canarias:postal_service:node-2088653392', 'Correos Los Llanos de Aridane – Calle Real', NULL, '38024', 'Calle Real 6', '38760', 28.65892, -17.91352, 'address', 'openstreetmap:node/2088653392'),
  ('catalogo-canarias:postal_service:node-2132944252', 'Correos San Miguel de Abona – Calle Alfonso Mejías', NULL, '38035', 'Calle Alfonso Mejías', '38620', 28.09889, -16.61551, 'address', 'openstreetmap:node/2132944252'),
  ('catalogo-canarias:postal_service:node-2261337440', 'Correos Arona – Calle Luis Álvarez Cruz 6A', NULL, '38006', 'Calle Luis Álvarez Cruz 6A', '38630', 28.00869, -16.6541, 'address', 'openstreetmap:node/2261337440'),
  ('catalogo-canarias:postal_service:node-2298567396', 'Correos Frontera – Calle Tigaday', NULL, '38013', 'Calle Tigaday 23', '38913', 27.75248, -18.01603, 'address', 'openstreetmap:node/2298567396'),
  ('catalogo-canarias:postal_service:node-2511867049', 'Correos Alajeró – Avenida Marítima', NULL, '38003', 'Avenida Marítima', NULL, 28.02915, -17.19663, 'address', 'openstreetmap:node/2511867049'),
  ('catalogo-canarias:postal_service:node-2654306482', 'Correos Vilaflor – Plaza del Calvario', NULL, '38052', 'Plaza del Calvario', NULL, 28.15433, -16.63559, 'address', 'openstreetmap:node/2654306482'),
  ('catalogo-canarias:postal_service:node-2667284897', 'Correos Vilaflor – Carretera del Hoyo', NULL, '38052', 'Carretera del Hoyo 5', '38640', 28.12346, -16.67365, 'address', 'openstreetmap:node/2667284897'),
  ('catalogo-canarias:postal_service:node-2703138268', 'Correos Güímar – Calle Marrubial', NULL, '38020', 'Calle Marrubial 4', '38500', 28.31617, -16.41243, 'address', 'openstreetmap:node/2703138268'),
  ('catalogo-canarias:postal_service:node-2801252836', 'Correos San Cristóbal de La Laguna – Camino Tabares', NULL, '38023', 'Camino Tabares', '38330', 28.49714, -16.37838, 'address', 'openstreetmap:node/2801252836'),
  ('catalogo-canarias:postal_service:node-313344631', 'Correos Arona – Calle Cruz de San Antonio', NULL, '38006', 'Calle Cruz de San Antonio', '38640', 28.10056, -16.68078, 'address', 'openstreetmap:node/313344631'),
  ('catalogo-canarias:postal_service:node-315394501', 'Correos Valle Gran Rey – Calle La Palomera', NULL, '38049', 'Calle La Palomera 1', '38870', 28.08727, -17.33457, 'address', 'openstreetmap:node/315394501'),
  ('catalogo-canarias:postal_service:node-317814070', 'Correos Vallehermoso – Mayor', NULL, '38050', 'Mayor 1', '38840', 28.17873, -17.26641, 'address', 'openstreetmap:node/317814070'),
  ('catalogo-canarias:postal_service:node-319563728', 'Correos Hermigua – Carretera General', NULL, '38021', 'Carretera General 107', '38820', 28.16287, -17.19845, 'address', 'openstreetmap:node/319563728'),
  ('catalogo-canarias:postal_service:node-3403684649', 'Correos Granadilla de Abona', NULL, '38017', NULL, NULL, 28.04732, -16.57824, 'address', 'openstreetmap:node/3403684649'),
  ('catalogo-canarias:postal_service:node-392293649', 'Correos Fuencaliente de La Palma – Carretera General Los Canarios', NULL, '38014', 'Carretera General Los Canarios 48', '38740', 28.49331, -17.84233, 'address', 'openstreetmap:node/392293649'),
  ('catalogo-canarias:postal_service:node-4119154718', 'Correos Arona – Calle Roque de Jama', NULL, '38006', 'Calle Roque de Jama', '38650', 28.05416, -16.71645, 'address', 'openstreetmap:node/4119154718'),
  ('catalogo-canarias:postal_service:node-415254409', 'Correos Garafía – Plaza de Baltasar Martín', NULL, '38016', 'Plaza de Baltasar Martín', NULL, 28.83019, -17.94496, 'address', 'openstreetmap:node/415254409'),
  ('catalogo-canarias:postal_service:node-423006870', 'Correos La Matanza de Acentejo – Carretera General del Norte', NULL, '38025', 'Carretera General del Norte', '38370', 28.44859, -16.45687, 'address', 'openstreetmap:node/423006870'),
  ('catalogo-canarias:postal_service:node-5567846624', 'Correos Adeje – Avenida Eugenio Domínguez Alfonso', NULL, '38001', 'Avenida Eugenio Domínguez Alfonso 2', '38660', 28.0731, -16.73204, 'address', 'openstreetmap:node/5567846624'),
  ('catalogo-canarias:postal_service:node-5743262616', 'Correos Icod de los Vinos – Calle de San Sebastián', NULL, '38022', 'Calle de San Sebastián 15', '38430', 28.36716, -16.71995, 'address', 'openstreetmap:node/5743262616'),
  ('catalogo-canarias:postal_service:node-6328370912', 'Correos Breña Alta – Calle Treinta de Mayo', NULL, '38008', 'Calle Treinta de Mayo', NULL, 28.66273, -17.78849, 'address', 'openstreetmap:node/6328370912'),
  ('catalogo-canarias:postal_service:node-702681506', 'Correos Tazacorte – Calle Progreso', NULL, '38045', 'Calle Progreso 25', '38770', 28.64061, -17.93306, 'address', 'openstreetmap:node/702681506'),
  ('catalogo-canarias:postal_service:node-7200314465', 'Correos Puerto de la Cruz – Calle El Pozo', NULL, '38028', 'Calle El Pozo 14', '38400', 28.41451, -16.55399, 'address', 'openstreetmap:node/7200314465'),
  ('catalogo-canarias:postal_service:node-7773249359', 'Correos El Sauzal – Avenida Inmaculada Concepción', NULL, '38041', 'Avenida Inmaculada Concepción 38', '38360', 28.48, -16.43375, 'address', 'openstreetmap:node/7773249359'),
  ('catalogo-canarias:postal_service:node-8750116907', 'Correos Fasnia – Calle Emiliano Díaz Castro', NULL, '38012', 'Calle Emiliano Díaz Castro 26', '38570', 28.23562, -16.44002, 'address', 'openstreetmap:node/8750116907'),
  ('catalogo-canarias:postal_service:node-8888273140', 'Correos Santa Cruz de Tenerife – Avenida Veinticinco de Julio', NULL, '38038', 'Avenida Veinticinco de Julio', '38001', 28.47381, -16.2556, 'address', 'openstreetmap:node/8888273140'),
  ('catalogo-canarias:postal_service:node-9407387379', 'Correos Villa de Mazo – Carretera General', NULL, '38053', 'Carretera General', NULL, 28.6062, -17.78033, 'address', 'openstreetmap:node/9407387379'),
  ('catalogo-canarias:postal_service:way-1042076820', 'Correos La Orotava – Calle Viera', NULL, '38026', 'Calle Viera', '38300', 28.39057, -16.52567, 'address', 'openstreetmap:way/1042076820'),
  ('catalogo-canarias:postal_service:way-118601508', 'Correos San Cristóbal de La Laguna – Calle Santo Domingo', NULL, '38023', 'Calle Santo Domingo 18', '38201', 28.4862, -16.31318, 'address', 'openstreetmap:way/118601508'),
  ('catalogo-canarias:postal_service:way-121145750', 'Correos San Cristóbal de La Laguna – Calle Santa Catalina', NULL, '38023', 'Calle Santa Catalina 2', NULL, 28.46838, -16.28864, 'address', 'openstreetmap:way/121145750'),
  ('catalogo-canarias:postal_service:way-121669384', 'Correos San Cristóbal de La Laguna – Calle Dona', NULL, '38023', 'Calle Dona', '38108', 28.44898, -16.29854, 'address', 'openstreetmap:way/121669384'),
  ('catalogo-canarias:postal_service:way-146235682', 'Correos San Sebastián de la Gomera – Calle Real', NULL, '38036', 'Calle Real 58', '38800', 28.09379, -17.11203, 'address', 'openstreetmap:way/146235682'),
  ('catalogo-canarias:postal_service:way-161859249', 'Correos Breña Baja – Camino Del Rincón', NULL, '38009', 'Camino Del Rincón 1', '38712', 28.64661, -17.76698, 'address', 'openstreetmap:way/161859249'),
  ('catalogo-canarias:postal_service:way-215665867', 'Correos Santa Úrsula – Calle Tosca de la Iglesia', NULL, '38039', 'Calle Tosca de la Iglesia 47', '38390', 28.42334, -16.49022, 'address', 'openstreetmap:way/215665867'),
  ('catalogo-canarias:postal_service:way-237305803', 'Correos La Guancha – Rambla Cristóbal Barrios Rodríguez', NULL, '38018', 'Rambla Cristóbal Barrios Rodríguez', NULL, 28.37739, -16.65172, 'address', 'openstreetmap:way/237305803'),
  ('catalogo-canarias:postal_service:way-261128222', 'Correos Guía de Isora – Avenida Isora', NULL, '38019', 'Avenida Isora 47', '38680', 28.20836, -16.77998, 'address', 'openstreetmap:way/261128222'),
  ('catalogo-canarias:postal_service:way-321621313', 'Correos Valverde – Calle de Correos', NULL, '38048', 'Calle de Correos 3', '38900', 27.80967, -17.91534, 'address', 'openstreetmap:way/321621313'),
  ('catalogo-canarias:postal_service:way-351386581', 'Correos Guía de Isora – Calle San Juan', NULL, '38019', 'Calle San Juan 6', '38689', 28.23602, -16.79634, 'address', 'openstreetmap:way/351386581'),
  ('catalogo-canarias:postal_service:way-375442055', 'Correos Santiago del Teide – Avenida Quinto Centenario', NULL, '38040', 'Avenida Quinto Centenario 13', '38683', 28.23968, -16.84039, 'address', 'openstreetmap:way/375442055'),
  ('catalogo-canarias:postal_service:way-432985784', 'Correos El Rosario – Calle la Sardinera', NULL, '38032', 'Calle la Sardinera 18', '38290', 28.45006, -16.36797, 'address', 'openstreetmap:way/432985784'),
  ('catalogo-canarias:postal_service:way-459569941', 'Correos Garachico – Calle Martín Andujar', NULL, '38015', 'Calle Martín Andujar 1', '38460', 28.37264, -16.76445, 'address', 'openstreetmap:way/459569941'),
  ('catalogo-canarias:postal_service:way-610887448', 'Correos Güímar – Avenida Olof Palme', NULL, '38020', 'Avenida Olof Palme 115', '38508', 28.29171, -16.37808, 'address', 'openstreetmap:way/610887448'),
  ('catalogo-canarias:postal_service:way-719415271', 'Correos Los Realejos – Avenida Canarias', NULL, '38031', 'Avenida Canarias', '38410', 28.38281, -16.58427, 'address', 'openstreetmap:way/719415271'),
  ('catalogo-canarias:postal_service:way-73204257', 'Correos Santa Cruz de Tenerife – Calle General Gutiérrez', NULL, '38038', 'Calle General Gutiérrez 2', '38003', 28.46612, -16.2477, 'address', 'openstreetmap:way/73204257'),
  ('catalogo-canarias:postal_service:way-757710607', 'Correos Tacoronte – Carretera General del Norte', NULL, '38043', 'Carretera General del Norte', NULL, 28.47722, -16.41311, 'address', 'openstreetmap:way/757710607'),
  ('catalogo-canarias:postal_service:way-845724125', 'Correos Buenavista del Norte – Calle Verde', NULL, '38010', 'Calle Verde 3', '38480', 28.37145, -16.85029, 'address', 'openstreetmap:way/845724125');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '38');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 38 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '38'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 66 THEN
    RAISE EXCEPTION 'Se esperaban 66 puntos de Correos en Santa Cruz de Tenerife, hay %', n;
  END IF;
END;
$$;

COMMIT;

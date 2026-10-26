-- Carga de la categoría Estaciones de Zaragoza (provincia 50), trozo de la carga de Andalucía.
-- Origen: estaciones-aragon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 57 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-aragon:estaciones:node-1147563224', 'Estación de tren de Zaragoza-Miraflores – Avenida de Tenor Fleta', 'Tren', '50297', 'Avenida de Tenor Fleta', NULL, 41.63319, -0.86831, 'address', 'openstreetmap:node/1147563224'),
  ('catalogo-aragon:estaciones:node-11845561378', 'Estación de tren de María de Huerva – Calle Estación', 'Tren', '50163', 'Calle Estación', '50430', 41.54009, -0.99748, 'address', 'openstreetmap:node/11845561378'),
  ('catalogo-aragon:estaciones:node-12117550962', 'Estación de tren de Rueda de Jalón-Lumpiaque', 'Tren', '50228', NULL, NULL, 41.63922, -1.28168, 'address', 'openstreetmap:node/12117550962'),
  ('catalogo-aragon:estaciones:node-12117555757', 'Estación de tren de Terrer', 'Tren', '50253', NULL, NULL, 41.32219, -1.70847, 'address', 'openstreetmap:node/12117555757'),
  ('catalogo-aragon:estaciones:node-12117573477', 'Estación de tren de Salillas de Jalón – Avenida de la Estación', 'Tren', '50231', 'Avenida de la Estación', NULL, 41.56835, -1.32546, 'address', 'openstreetmap:node/12117573477'),
  ('catalogo-aragon:estaciones:node-12211306061', 'Estación de tren de Monreal de Ariza', 'Tren', '50172', NULL, NULL, 41.2987, -2.10982, 'address', 'openstreetmap:node/12211306061'),
  ('catalogo-aragon:estaciones:node-12231874903', 'Estación Central de Autobuses de Zaragoza – Calle de la Rioja', 'Autobús', '50297', 'Calle de la Rioja 33', '50017', 41.65947, -0.91135, 'address', 'openstreetmap:node/12231874903'),
  ('catalogo-aragon:estaciones:node-12550996847', 'Estación de tren de Plasencia de Jalón', 'Tren', '50211', NULL, NULL, 41.68962, -1.23436, 'address', 'openstreetmap:node/12550996847'),
  ('catalogo-aragon:estaciones:node-1314402001', 'Estación de tren de Cariñena – Avenida Estación', 'Tren', '50073', 'Avenida Estación', NULL, 41.3358, -1.22909, 'address', 'openstreetmap:node/1314402001'),
  ('catalogo-aragon:estaciones:node-13151168668', 'Estación de tren de Bubierca', 'Tren', '50058', NULL, NULL, 41.31717, -1.85549, 'address', 'openstreetmap:node/13151168668'),
  ('catalogo-aragon:estaciones:node-13378691482', 'Estación de tren de Favara (Fabara / Favara)', 'Tren', '50102', NULL, NULL, 41.23438, 0.14281, 'address', 'openstreetmap:node/13378691482'),
  ('catalogo-aragon:estaciones:node-13378956082', 'Estación de tren de Quinto – Camino de la Estación', 'Tren', '50222', 'Camino de la Estación', NULL, 41.41959, -0.49053, 'address', 'openstreetmap:node/13378956082'),
  ('catalogo-aragon:estaciones:node-13378966348', 'Estación de tren de La Zaida-Sástago – Carretera de Quinto de Ebro a Gandesa', 'Tren', '50296', 'Carretera de Quinto de Ebro a Gandesa', NULL, 41.32049, -0.42702, 'address', 'openstreetmap:node/13378966348'),
  ('catalogo-aragon:estaciones:node-13379272986', 'Estación de tren de Val de Pilas (Caspe)', 'Tren', '50074', NULL, NULL, 41.22955, 0.07606, 'address', 'openstreetmap:node/13379272986'),
  ('catalogo-aragon:estaciones:node-14243655839', 'Estación de tren de Embid de Jalón (Calatayud)', 'Tren', '50067', NULL, NULL, 41.42133, -1.59316, 'address', 'openstreetmap:node/14243655839'),
  ('catalogo-aragon:estaciones:node-1836639300', 'Estación de tren de Ricla-La Almunia – Calle Braulio Lausín Velilla', 'Tren', '50225', 'Calle Braulio Lausín Velilla', NULL, 41.50128, -1.40279, 'address', 'openstreetmap:node/1836639300'),
  ('catalogo-aragon:estaciones:node-1974345183', 'Estación de tren de Utebo – Ronda de Toledo', 'Tren', '50272', 'Ronda de Toledo', NULL, 41.71092, -0.99849, 'address', 'openstreetmap:node/1974345183'),
  ('catalogo-aragon:estaciones:node-2073025029', 'Estación de tren de Encinacorba – Calle de la Estación', 'Tren', '50098', 'Calle de la Estación', NULL, 41.28902, -1.27871, 'address', 'openstreetmap:node/2073025029'),
  ('catalogo-aragon:estaciones:node-2282080227', 'Estación de tren de Alhama de Aragón', 'Tren', '50020', NULL, NULL, 41.29451, -1.90429, 'address', 'openstreetmap:node/2282080227'),
  ('catalogo-aragon:estaciones:node-2282123376', 'Estación de tren de Ariza – Calle Marqués de Ariza', 'Tren', '50034', 'Calle Marqués de Ariza', NULL, 41.30943, -2.05996, 'address', 'openstreetmap:node/2282123376'),
  ('catalogo-aragon:estaciones:node-2386227009', 'Estación de tren de Paracuellos-Sabiñán (Paracuellos de la Ribera) – Carretera de A-1503 a la Estación de Ferrocarril de Paracuellos de la Ribera', 'Tren', '50202', 'Carretera de A-1503 a la Estación de Ferrocarril de Paracuellos de la Ribera', NULL, 41.42887, -1.56756, 'address', 'openstreetmap:node/2386227009'),
  ('catalogo-aragon:estaciones:node-2386248261', 'Estación de tren de Morés', 'Tren', '50177', NULL, NULL, 41.47855, -1.56625, 'address', 'openstreetmap:node/2386248261'),
  ('catalogo-aragon:estaciones:node-2386248277', 'Estación de tren de Morata de Jalón – Calle de la Estación', 'Tren', '50175', 'Calle de la Estación', NULL, 41.4755, -1.47857, 'address', 'openstreetmap:node/2386248277'),
  ('catalogo-aragon:estaciones:node-2400728055', 'Estación de tren de Épila', 'Tren', '50099', NULL, NULL, 41.60972, -1.30117, 'address', 'openstreetmap:node/2400728055'),
  ('catalogo-aragon:estaciones:node-26377368', 'Estación de tren de Gallur – Calle Virgen del Pilar', 'Tren', '50118', 'Calle Virgen del Pilar', NULL, 41.86709, -1.32133, 'address', 'openstreetmap:node/26377368'),
  ('catalogo-aragon:estaciones:node-4179891043', 'Estación de tren de Zaragoza-Goya – Avenida Francisco de Goya', 'Tren', '50297', 'Avenida Francisco de Goya 47', '50006', 41.64391, -0.89134, 'address', 'openstreetmap:node/4179891043'),
  ('catalogo-aragon:estaciones:node-4457701373', 'Estación de tren de Calatorao', 'Tren', '50068', NULL, NULL, 41.5287, -1.36081, 'address', 'openstreetmap:node/4457701373'),
  ('catalogo-aragon:estaciones:node-448128332', 'Estación de tren de Casetas (Zaragoza)', 'Tren', '50297', NULL, NULL, 41.72273, -1.02049, 'address', 'openstreetmap:node/448128332'),
  ('catalogo-aragon:estaciones:node-4586239561', 'Estación de tren de Zaragoza-Portillo – Calle de Manuel Escoriaza y Fabro', 'Tren', '50297', 'Calle de Manuel Escoriaza y Fabro', '50010', 41.65274, -0.8959, 'address', 'openstreetmap:node/4586239561'),
  ('catalogo-aragon:estaciones:node-4813092198', 'Estación de tren de Zaragoza-Delicias – Calle de la Rioja', 'Tren', '50297', 'Calle de la Rioja 33', '50017', 41.65857, -0.91139, 'address', 'openstreetmap:node/4813092198'),
  ('catalogo-aragon:estaciones:node-5288693384', 'Estación de tren de Sabiñán – Plaza de la Señoría', 'Tren', '50241', 'Plaza de la Señoría', NULL, 41.44406, -1.57115, 'address', 'openstreetmap:node/5288693384'),
  ('catalogo-aragon:estaciones:node-5749156246', 'Estación de tren de Fuentes de Ebro', 'Tren', '50115', NULL, NULL, 41.51524, -0.61838, 'address', 'openstreetmap:node/5749156246'),
  ('catalogo-aragon:estaciones:node-5784019615', 'Estación de tren de Nonaspe (Nonaspe / Nonasp) – 8', 'Tren', '50189', '8', '50794', 41.21373, 0.24239, 'address', 'openstreetmap:node/5784019615'),
  ('catalogo-aragon:estaciones:node-5937978999', 'Estación de tren de Ateca', 'Tren', '50038', NULL, NULL, 41.32438, -1.78529, 'address', 'openstreetmap:node/5937978999'),
  ('catalogo-aragon:estaciones:node-5939682666', 'Estación de tren de Cetina', 'Tren', '50081', NULL, NULL, 41.29604, -1.95994, 'address', 'openstreetmap:node/5939682666'),
  ('catalogo-aragon:estaciones:node-5940817283', 'Estación de tren de Longares', 'Tren', '50143', NULL, NULL, 41.40616, -1.1585, 'address', 'openstreetmap:node/5940817283'),
  ('catalogo-aragon:estaciones:node-5940842407', 'Estación de tren de Badules – Calle de las Escuelas', 'Tren', '50040', 'Calle de las Escuelas', NULL, 41.1398, -1.25156, 'address', 'openstreetmap:node/5940842407'),
  ('catalogo-aragon:estaciones:node-596122585', 'Estación de tren de Zuera – Plaza del Canfranc', 'Tren', '50298', 'Plaza del Canfranc', NULL, 41.87719, -0.76381, 'address', 'openstreetmap:node/596122585'),
  ('catalogo-aragon:estaciones:node-6172542869', 'Estación de Therpasa (Tarazona) – Avenida de Navarra', 'Autobús', '50251', 'Avenida de Navarra 17', '50500', 41.90594, -1.72513, 'address', 'openstreetmap:node/6172542869'),
  ('catalogo-aragon:estaciones:node-6186096066', 'Estación de tren de Grisén – Avenida de la Estación', 'Tren', '50123', 'Avenida de la Estación', NULL, 41.74526, -1.16585, 'address', 'openstreetmap:node/6186096066'),
  ('catalogo-aragon:estaciones:node-6186096068', 'Estación de tren de Purroy (Morés)', 'Tren', '50177', NULL, NULL, 41.47718, -1.54028, 'address', 'openstreetmap:node/6186096068'),
  ('catalogo-aragon:estaciones:node-6186096069', 'Estación de tren de Calatayud', 'Tren', '50067', NULL, NULL, 41.34636, -1.63842, 'address', 'openstreetmap:node/6186096069'),
  ('catalogo-aragon:estaciones:node-6245732030', 'Estación de tren de Luceni – Calle Río Cinca', 'Tren', '50147', 'Calle Río Cinca', NULL, 41.82615, -1.24401, 'address', 'openstreetmap:node/6245732030'),
  ('catalogo-aragon:estaciones:node-7444849167', 'Estación de tren de Arañales de Muel – Calle Alfar', 'Tren', '50181', 'Calle Alfar', NULL, 41.46913, -1.08621, 'address', 'openstreetmap:node/7444849167'),
  ('catalogo-aragon:estaciones:node-7590293222', 'Estación de tren de Villanueva de Gállego – Calle Las Balsas', 'Tren', '50288', 'Calle Las Balsas', NULL, 41.76539, -0.82216, 'address', 'openstreetmap:node/7590293222'),
  ('catalogo-aragon:estaciones:node-81326544', 'Estación de tren de Alagón – Calle de la Estación', 'Tren', '50008', 'Calle de la Estación', NULL, 41.77163, -1.11261, 'address', 'openstreetmap:node/81326544'),
  ('catalogo-aragon:estaciones:node-81326546', 'Estación de tren de Cabañas de Ebro – Avenida diputacion provincial', 'Tren', '50064', 'Avenida diputacion provincial', NULL, 41.78831, -1.1684, 'address', 'openstreetmap:node/81326546'),
  ('catalogo-aragon:estaciones:node-81326548', 'Estación de tren de Pedrola – Apeadero del tren de Pedrola', 'Tren', '50204', 'Apeadero del tren de Pedrola', NULL, 41.8051, -1.20194, 'address', 'openstreetmap:node/81326548'),
  ('catalogo-aragon:estaciones:node-8697630055', 'Estación de tren de Villarreal de Huerva', 'Tren', '50292', NULL, NULL, 41.19631, -1.2871, 'address', 'openstreetmap:node/8697630055'),
  ('catalogo-aragon:estaciones:node-8698895690', 'Estación de tren de Cuarte de Huerva (Zaragoza)', 'Tren', '50297', NULL, NULL, 41.5919, -0.94792, 'address', 'openstreetmap:node/8698895690'),
  ('catalogo-aragon:estaciones:node-8734265540', 'Estación de tren de Caspe – Camino del Ramblar', 'Tren', '50074', 'Camino del Ramblar', '50700', 41.23991, -0.04274, 'address', 'openstreetmap:node/8734265540'),
  ('catalogo-aragon:estaciones:way-1272417645', 'Estación de tren de C.I.M. Zaragoza – Camino Nuevo', 'Tren', '50297', 'Camino Nuevo', NULL, 41.67656, -0.94288, 'address', 'openstreetmap:way/1272417645'),
  ('catalogo-aragon:estaciones:way-1450852496', 'Estación de Autobuses de Calatayud – Calle Juan Cruz Melero', 'Autobús', '50067', 'Calle Juan Cruz Melero', NULL, 41.3557, -1.63939, 'address', 'openstreetmap:way/1450852496'),
  ('catalogo-aragon:estaciones:way-1485662665', 'Estacion Therpasa (Borja) – Calle Capuchinos', 'Autobús', '50055', 'Calle Capuchinos', NULL, 41.83222, -1.52945, 'address', 'openstreetmap:way/1485662665'),
  ('catalogo-aragon:estaciones:way-446595374', 'Estación de tren de Casilla de la Princesa (Fuendetodos)', 'Tren', '50114', NULL, NULL, 41.38597, -0.89271, 'address', 'openstreetmap:way/446595374'),
  ('catalogo-aragon:estaciones:way-614480289', 'Estación de tren de Villadoz', 'Tren', '50283', NULL, NULL, 41.16561, -1.27885, 'address', 'openstreetmap:way/614480289'),
  ('catalogo-aragon:estaciones:way-849562366', 'Estación de autobuses de Ejea de los Caballeros – Calle Estación', 'Autobús', '50095', 'Calle Estación', '50600', 42.12498, -1.14356, 'address', 'openstreetmap:way/849562366');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '50');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 50 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '50'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 57 THEN
    RAISE EXCEPTION 'Se esperaban 57 puntos de Estaciones en Zaragoza, hay %', n;
  END IF;
END;
$$;

COMMIT;

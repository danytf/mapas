-- Carga de la categoría Correos de Badajoz (provincia 06), trozo de la carga de Andalucía.
-- Origen: postal_service-extremadura.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:38:56Z).
-- 68 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:extremadura-correos:node-11244554598', 'Correos Valdelacalzada – Plaza de España', NULL, '06901', 'Plaza de España', NULL, 38.88996, -6.70035, 'address', 'openstreetmap:node/11244554598'),
  ('catalogo-andalucia:extremadura-correos:node-11449432166', 'Correos Cabeza del Buey – Calle Nueva', NULL, '06023', 'Calle Nueva', NULL, 38.72141, -5.21975, 'address', 'openstreetmap:node/11449432166'),
  ('catalogo-andalucia:extremadura-correos:node-11488962875', 'Correos Berlanga – Calle Ulpiano Vázquez', NULL, '06019', 'Calle Ulpiano Vázquez', NULL, 38.28195, -5.83037, 'address', 'openstreetmap:node/11488962875'),
  ('catalogo-andalucia:extremadura-correos:node-14178311371', 'Correos Mérida – Calle de Madrid', NULL, '06083', 'Calle de Madrid', '06800', 38.92097, -6.34563, 'address', 'openstreetmap:node/14178311371'),
  ('catalogo-andalucia:extremadura-correos:node-1660902570', 'Correos Almendralejo – Avenida de San Antonio, 24', NULL, '06011', 'Avenida de San Antonio, 24 24', '06200', 38.68409, -6.40416, 'address', 'openstreetmap:node/1660902570'),
  ('catalogo-andalucia:extremadura-correos:node-1888634894', 'Correos La Parra – Calle Santiago', NULL, '06099', 'Calle Santiago', NULL, 38.52082, -6.62142, 'address', 'openstreetmap:node/1888634894'),
  ('catalogo-andalucia:extremadura-correos:node-1902387511', 'Correos Guareña – Calle Malfeitos', NULL, '06060', 'Calle Malfeitos', NULL, 38.86091, -6.10117, 'address', 'openstreetmap:node/1902387511'),
  ('catalogo-andalucia:extremadura-correos:node-2003604787', 'Correos Badajoz – 4ª Avenida', NULL, '06015', '4ª Avenida', NULL, 38.82209, -6.95923, 'address', 'openstreetmap:node/2003604787'),
  ('catalogo-andalucia:extremadura-correos:node-2309799574', 'Correos Badajoz – Avenida Cristóbal Colón', NULL, '06015', 'Avenida Cristóbal Colón', '06005', 38.87619, -6.97644, 'address', 'openstreetmap:node/2309799574'),
  ('catalogo-andalucia:extremadura-correos:node-2423922970', 'Correos Zafra – Plaza de España', NULL, '06158', 'Plaza de España', '06300', 38.42303, -6.41635, 'address', 'openstreetmap:node/2423922970'),
  ('catalogo-andalucia:extremadura-correos:node-3017740127', 'Correos Alburquerque – Avenida Aurelio Cabrera', NULL, '06006', 'Avenida Aurelio Cabrera 63', '06510', 39.21942, -7.0039, 'address', 'openstreetmap:node/3017740127'),
  ('catalogo-andalucia:extremadura-correos:node-3032307859', 'Correos Llerena – Calle de la Corredera', NULL, '06074', 'Calle de la Corredera 2', '06900', 38.2359, -6.01302, 'address', 'openstreetmap:node/3032307859'),
  ('catalogo-andalucia:extremadura-correos:node-3373297748', 'Correos Azuaga – Plaza de La Merced', NULL, '06014', 'Plaza de La Merced 10', '06920', 38.25845, -5.67499, 'address', 'openstreetmap:node/3373297748'),
  ('catalogo-andalucia:extremadura-correos:node-5302292770', 'Correos Castuera – Plaza de España', NULL, '06036', 'Plaza de España', NULL, 38.72051, -5.54657, 'address', 'openstreetmap:node/5302292770'),
  ('catalogo-andalucia:extremadura-correos:node-5306430423', 'Correos Esparragosa de la Serena – Calle Emigrante', NULL, '06047', 'Calle Emigrante', NULL, 38.64872, -5.60584, 'address', 'openstreetmap:node/5306430423'),
  ('catalogo-andalucia:extremadura-correos:node-5325528562', 'Correos Esparragosa de Lares – Calle Marcial Gonzalez', NULL, '06048', 'Calle Marcial Gonzalez 11', '06620', 38.97446, -5.26831, 'address', 'openstreetmap:node/5325528562'),
  ('catalogo-andalucia:extremadura-correos:node-5337727140', 'Correos Segura de León – Calle Ramón y Cajal', NULL, '06124', 'Calle Ramón y Cajal', NULL, 38.12034, -6.52991, 'address', 'openstreetmap:node/5337727140'),
  ('catalogo-andalucia:extremadura-correos:node-5351628487', 'Correos Fregenal de la Sierra – Calle Marqués de Riocabado', NULL, '06050', 'Calle Marqués de Riocabado', NULL, 38.17075, -6.6557, 'address', 'openstreetmap:node/5351628487'),
  ('catalogo-andalucia:extremadura-correos:node-5357494215', 'Correos Higuera la Real – Plaza de la Constitución', NULL, '06067', 'Plaza de la Constitución', NULL, 38.14221, -6.68833, 'address', 'openstreetmap:node/5357494215'),
  ('catalogo-andalucia:extremadura-correos:node-5368678347', 'Correos Oliva de la Frontera – Avenida de Extremadura', NULL, '06093', 'Avenida de Extremadura', NULL, 38.2768, -6.91936, 'address', 'openstreetmap:node/5368678347'),
  ('catalogo-andalucia:extremadura-correos:node-5378729796', 'Correos Zalamea de la Serena – Calle Altillo', NULL, '06160', 'Calle Altillo', NULL, 38.65057, -5.65985, 'address', 'openstreetmap:node/5378729796'),
  ('catalogo-andalucia:extremadura-correos:node-5401215966', 'Correos Quintana de la Serena – Calle Severo Ochoa', NULL, '06109', 'Calle Severo Ochoa', NULL, 38.7414, -5.67076, 'address', 'openstreetmap:node/5401215966'),
  ('catalogo-andalucia:extremadura-correos:node-5412998182', 'Correos Campanario – Avenida de la Constitución', NULL, '06028', 'Avenida de la Constitución', NULL, 38.86246, -5.61905, 'address', 'openstreetmap:node/5412998182'),
  ('catalogo-andalucia:extremadura-correos:node-5448243717', 'Correos Puebla de Sancho Pérez – Calle Rincón', NULL, '06108', 'Calle Rincón', NULL, 38.39585, -6.40128, 'address', 'openstreetmap:node/5448243717'),
  ('catalogo-andalucia:extremadura-correos:node-5452096897', 'Correos Ribera del Fresno – Calle Fábrica', NULL, '06113', 'Calle Fábrica', NULL, 38.54942, -6.23906, 'address', 'openstreetmap:node/5452096897'),
  ('catalogo-andalucia:extremadura-correos:node-5464994574', 'Correos Villafranca de los Barros – Calle Carrera Chica', NULL, '06149', 'Calle Carrera Chica', '06220', 38.56114, -6.34182, 'address', 'openstreetmap:node/5464994574'),
  ('catalogo-andalucia:extremadura-correos:node-5554758530', 'Correos Santa Amalia – Calle Constitución', NULL, '06120', 'Calle Constitución', NULL, 39.01198, -6.01024, 'address', 'openstreetmap:node/5554758530'),
  ('catalogo-andalucia:extremadura-correos:node-5653664183', 'Correos Badajoz – Avenida Ricardo Carapeto Zambrano', NULL, '06015', 'Avenida Ricardo Carapeto Zambrano', '06008', 38.87885, -6.95637, 'address', 'openstreetmap:node/5653664183'),
  ('catalogo-andalucia:extremadura-correos:node-5659265948', 'Correos La Zarza – Calle Fuente', NULL, '06162', 'Calle Fuente', NULL, 38.81818, -6.21502, 'address', 'openstreetmap:node/5659265948'),
  ('catalogo-andalucia:extremadura-correos:node-5678269978', 'Correos Solana de los Barros – Calle Ladera', NULL, '06126', 'Calle Ladera', NULL, 38.72501, -6.53599, 'address', 'openstreetmap:node/5678269978'),
  ('catalogo-andalucia:extremadura-correos:node-5682985634', 'Correos Arroyo de San Serván – Calle Badajoz', NULL, '06012', 'Calle Badajoz', NULL, 38.85715, -6.45531, 'address', 'openstreetmap:node/5682985634'),
  ('catalogo-andalucia:extremadura-correos:node-5685990332', 'Correos Ahillones – Calle Real', NULL, '06003', 'Calle Real', '06940', 38.26019, -5.86502, 'address', 'openstreetmap:node/5685990332'),
  ('catalogo-andalucia:extremadura-correos:node-5693639819', 'Correos Alconera – Calle San Pedro', NULL, '06008', 'Calle San Pedro 2', '06393', 38.39861, -6.47667, 'address', 'openstreetmap:node/5693639819'),
  ('catalogo-andalucia:extremadura-correos:node-5709437863', 'Correos Burguillos del Cerro – Calle Batalla de La Albuera', NULL, '06022', 'Calle Batalla de La Albuera', NULL, 38.37855, -6.59017, 'address', 'openstreetmap:node/5709437863'),
  ('catalogo-andalucia:extremadura-correos:node-5712014398', 'Correos Calamonte – Calle Nueva', NULL, '06025', 'Calle Nueva', '06810', 38.88967, -6.38622, 'address', 'openstreetmap:node/5712014398'),
  ('catalogo-andalucia:extremadura-correos:node-5726367921', 'Correos Castilblanco – Calle Francisco Naveso', NULL, '06035', 'Calle Francisco Naveso', '06680', 39.28487, -5.09002, 'address', 'openstreetmap:node/5726367921'),
  ('catalogo-andalucia:extremadura-correos:node-5731000822', 'Correos La Codosera – Travesía Luz', NULL, '06037', 'Travesía Luz', NULL, 39.20675, -7.17237, 'address', 'openstreetmap:node/5731000822'),
  ('catalogo-andalucia:extremadura-correos:node-5760394797', 'Correos Fuente del Maestre – Calle Corredera', NULL, '06054', 'Calle Corredera', NULL, 38.52802, -6.44864, 'address', 'openstreetmap:node/5760394797'),
  ('catalogo-andalucia:extremadura-correos:node-5766405567', 'Correos La Garrovilla – Calle Rafael Alberti', NULL, '06058', 'Calle Rafael Alberti 4', '06870', 38.92128, -6.47582, 'address', 'openstreetmap:node/5766405567'),
  ('catalogo-andalucia:extremadura-correos:node-5776843931', 'Correos Herrera del Duque – Plaza de España', NULL, '06063', 'Plaza de España', NULL, 39.1664, -5.04885, 'address', 'openstreetmap:node/5776843931'),
  ('catalogo-andalucia:extremadura-correos:node-5784819228', 'Correos Higuera de Vargas – Calle Fuentecita', NULL, '06066', 'Calle Fuentecita', NULL, 38.4442, -6.9767, 'address', 'openstreetmap:node/5784819228'),
  ('catalogo-andalucia:extremadura-correos:node-5801087181', 'Correos Lobón – Plaza de España', NULL, '06072', 'Plaza de España 1', '06498', 38.85059, -6.62197, 'address', 'openstreetmap:node/5801087181'),
  ('catalogo-andalucia:extremadura-correos:node-5807612380', 'Correos Magacela – Calle Pedro de Valdivia', NULL, '06075', 'Calle Pedro de Valdivia', NULL, 38.89713, -5.73549, 'address', 'openstreetmap:node/5807612380'),
  ('catalogo-andalucia:extremadura-correos:node-5822428020', 'Correos La Morera – Plaza de España', NULL, '06089', 'Plaza de España', NULL, 38.54663, -6.65411, 'address', 'openstreetmap:node/5822428020'),
  ('catalogo-andalucia:extremadura-correos:node-5825523039', 'Correos La Nava de Santiago – Travesía Lirios', NULL, '06090', 'Travesía Lirios', NULL, 39.06306, -6.50748, 'address', 'openstreetmap:node/5825523039'),
  ('catalogo-andalucia:extremadura-correos:node-5830357784', 'Correos Navalvillar de Pela – Calle Felipe II', NULL, '06091', 'Calle Felipe II', NULL, 39.08976, -5.47016, 'address', 'openstreetmap:node/5830357784'),
  ('catalogo-andalucia:extremadura-correos:node-5834154791', 'Correos Nogales – Calle San Juan', NULL, '06092', 'Calle San Juan', NULL, 38.58771, -6.75229, 'address', 'openstreetmap:node/5834154791'),
  ('catalogo-andalucia:extremadura-correos:node-5841565315', 'Correos Puebla de Alcocer – Calle Fray Juan de la Puebla', NULL, '06102', 'Calle Fray Juan de la Puebla 4', '06630', 38.98529, -5.25796, 'address', 'openstreetmap:node/5841565315'),
  ('catalogo-andalucia:extremadura-correos:node-5871820312', 'Correos Santa Marta – Calle Molino', NULL, '06121', 'Calle Molino', NULL, 38.61612, -6.62756, 'address', 'openstreetmap:node/5871820312'),
  ('catalogo-andalucia:extremadura-correos:node-5884514391', 'Correos Los Santos de Maimona – Calle Teniente Valle', NULL, '06122', 'Calle Teniente Valle', '06320', 38.45002, -6.3852, 'address', 'openstreetmap:node/5884514391'),
  ('catalogo-andalucia:extremadura-correos:node-5891426009', 'Correos Siruela – Calle Hospital', NULL, '06125', 'Calle Hospital', NULL, 38.97616, -5.04879, 'address', 'openstreetmap:node/5891426009'),
  ('catalogo-andalucia:extremadura-correos:node-5894862184', 'Correos Talarrubias – Calle Ángel Utrero Calderón', NULL, '06127', 'Calle Ángel Utrero Calderón', NULL, 39.03524, -5.23658, 'address', 'openstreetmap:node/5894862184'),
  ('catalogo-andalucia:extremadura-correos:node-6030340792', 'Correos Valdecaballeros – Calle Peña', NULL, '06137', 'Calle Peña 2', '06689', 39.24285, -5.18972, 'address', 'openstreetmap:node/6030340792'),
  ('catalogo-andalucia:extremadura-correos:node-6044708044', 'Correos Valencia del Ventoso – Calle Isabel la Católica', NULL, '06141', 'Calle Isabel la Católica', NULL, 38.26562, -6.47465, 'address', 'openstreetmap:node/6044708044'),
  ('catalogo-andalucia:extremadura-correos:node-6066807305', 'Correos Valverde de Leganés – Calle Plaza', NULL, '06143', 'Calle Plaza', NULL, 38.67126, -6.98293, 'address', 'openstreetmap:node/6066807305'),
  ('catalogo-andalucia:extremadura-correos:node-6096486621', 'Correos Villanueva del Fresno – Plaza de España', NULL, '06154', 'Plaza de España', '06110', 38.37597, -7.16858, 'address', 'openstreetmap:node/6096486621'),
  ('catalogo-andalucia:extremadura-correos:node-6156407800', 'Correos Montijo – Calle Concepción Arenal', NULL, '06088', 'Calle Concepción Arenal', '06480', 38.90672, -6.61384, 'address', 'openstreetmap:node/6156407800'),
  ('catalogo-andalucia:extremadura-correos:node-6156423501', 'Correos Montijo – Calle de San Antonio', NULL, '06088', 'Calle de San Antonio', '06480', 38.90786, -6.61559, 'address', 'openstreetmap:node/6156423501'),
  ('catalogo-andalucia:extremadura-correos:node-6812331592', 'Correos Carmonita – Avenida de Extremadura', NULL, '06031', 'Avenida de Extremadura', '06488', 39.15451, -6.34112, 'address', 'openstreetmap:node/6812331592'),
  ('catalogo-andalucia:extremadura-correos:node-6865900037', 'Correos Olivenza – Calle Santa Engracia 1E', NULL, '06095', 'Calle Santa Engracia 1E', '06100', 38.68606, -7.09751, 'address', 'openstreetmap:node/6865900037'),
  ('catalogo-andalucia:extremadura-correos:node-911479107', 'Correos Fuente de Cantos – Calle Llerena', NULL, '06052', 'Calle Llerena 34', '06240', 38.2469, -6.30631, 'address', 'openstreetmap:node/911479107'),
  ('catalogo-andalucia:extremadura-correos:relation-9380430', 'Correos Badajoz – Paseo San Francisco', NULL, '06015', 'Paseo San Francisco 4', '06002', 38.87565, -6.97371, 'address', 'openstreetmap:relation/9380430'),
  ('catalogo-andalucia:extremadura-correos:way-1234892182', 'Correos Granja de Torrehermosa – Calle San Sebastían', NULL, '06059', 'Calle San Sebastían', NULL, 38.30855, -5.59431, 'address', 'openstreetmap:way/1234892182'),
  ('catalogo-andalucia:extremadura-correos:way-1316543966', 'Correos San Vicente de Alcántara – Avenida de Badajoz', NULL, '06123', 'Avenida de Badajoz 30', '06500', 39.36298, -7.13947, 'address', 'openstreetmap:way/1316543966'),
  ('catalogo-andalucia:extremadura-correos:way-549941280', 'Correos Monesterio – Carretera de Gijón a Sevilla', NULL, '06085', 'Carretera de Gijón a Sevilla 122', '06260', 38.09042, -6.27347, 'address', 'openstreetmap:way/549941280'),
  ('catalogo-andalucia:extremadura-correos:way-641300864', 'Correos Guadiana – Calle Nuestra Señora de la Soledad', NULL, '06903', 'Calle Nuestra Señora de la Soledad 12', '06186', 38.92886, -6.6913, 'address', 'openstreetmap:way/641300864'),
  ('catalogo-andalucia:extremadura-correos:way-926320759', 'Correos Zahínos – Calle Calvario', NULL, '06159', 'Calle Calvario', '06129', 38.32809, -6.954, 'address', 'openstreetmap:way/926320759'),
  ('catalogo-andalucia:extremadura-correos:way-986467860', 'Correos Don Benito – Calle Montón', NULL, '06044', 'Calle Montón', '06400', 38.95412, -5.86242, 'address', 'openstreetmap:way/986467860');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '06');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 06 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '06'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 68 THEN
    RAISE EXCEPTION 'Se esperaban 68 puntos de Correos en Badajoz, hay %', n;
  END IF;
END;
$$;

COMMIT;

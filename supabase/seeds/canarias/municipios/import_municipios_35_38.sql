-- Municipios oficiales (código INE) de las provincias 35,38. Origen: OpenStreetMap (áreas administrativas de nivel 8 con ine:municipio), ODbL.
-- Inserta los que faltan y asigna el código INE a los existentes que no lo tienen. No cambia nombres ni borra nada.
-- 88 municipios. Transaccional e idempotente.

BEGIN;

CREATE TEMP TABLE _municipios (prov text, ine text, name text, norm text) ON COMMIT DROP;
INSERT INTO _municipios VALUES
  ('35', '35001', 'Agaete', 'agaete'),
  ('35', '35002', 'Agüimes', 'aguimes'),
  ('35', '35003', 'Antigua', 'antigua'),
  ('35', '35004', 'Arrecife', 'arrecife'),
  ('35', '35005', 'Artenara', 'artenara'),
  ('35', '35006', 'Arucas', 'arucas'),
  ('35', '35007', 'Betancuria', 'betancuria'),
  ('35', '35008', 'Firgas', 'firgas'),
  ('35', '35009', 'Gáldar', 'galdar'),
  ('35', '35010', 'Haría', 'haria'),
  ('35', '35011', 'Ingenio', 'ingenio'),
  ('35', '35012', 'Mogán', 'mogan'),
  ('35', '35013', 'Moya', 'moya'),
  ('35', '35014', 'La Oliva', 'la-oliva'),
  ('35', '35015', 'Pájara', 'pajara'),
  ('35', '35016', 'Las Palmas de Gran Canaria', 'las-palmas-de-gran-canaria'),
  ('35', '35017', 'Puerto del Rosario', 'puerto-del-rosario'),
  ('35', '35018', 'San Bartolomé', 'san-bartolome'),
  ('35', '35019', 'San Bartolomé de Tirajana', 'san-bartolome-de-tirajana'),
  ('35', '35020', 'La Aldea de San Nicolás', 'la-aldea-de-san-nicolas'),
  ('35', '35021', 'Santa Brígida', 'santa-brigida'),
  ('35', '35022', 'Santa Lucía de Tirajana', 'santa-lucia-de-tirajana'),
  ('35', '35023', 'Santa María de Guía de Gran Canaria', 'santa-maria-de-guia-de-gran-canaria'),
  ('35', '35024', 'Teguise', 'teguise'),
  ('35', '35025', 'Tejeda', 'tejeda'),
  ('35', '35026', 'Telde', 'telde'),
  ('35', '35027', 'Teror', 'teror'),
  ('35', '35028', 'Tías', 'tias'),
  ('35', '35029', 'Tinajo', 'tinajo'),
  ('35', '35030', 'Tuineje', 'tuineje'),
  ('35', '35031', 'Valsequillo de Gran Canaria', 'valsequillo-de-gran-canaria'),
  ('35', '35032', 'Valleseco', 'valleseco'),
  ('35', '35033', 'Vega de San Mateo', 'vega-de-san-mateo'),
  ('35', '35034', 'Yaiza', 'yaiza'),
  ('38', '38001', 'Adeje', 'adeje'),
  ('38', '38002', 'Agulo', 'agulo'),
  ('38', '38003', 'Alajeró', 'alajero'),
  ('38', '38004', 'Arafo', 'arafo'),
  ('38', '38005', 'Arico', 'arico'),
  ('38', '38006', 'Arona', 'arona'),
  ('38', '38007', 'Barlovento', 'barlovento'),
  ('38', '38008', 'Breña Alta', 'brena-alta'),
  ('38', '38009', 'Breña Baja', 'brena-baja'),
  ('38', '38010', 'Buenavista del Norte', 'buenavista-del-norte'),
  ('38', '38011', 'Candelaria', 'candelaria'),
  ('38', '38012', 'Fasnia', 'fasnia'),
  ('38', '38013', 'Frontera', 'frontera'),
  ('38', '38014', 'Fuencaliente de La Palma', 'fuencaliente-de-la-palma'),
  ('38', '38015', 'Garachico', 'garachico'),
  ('38', '38016', 'Garafía', 'garafia'),
  ('38', '38017', 'Granadilla de Abona', 'granadilla-de-abona'),
  ('38', '38018', 'La Guancha', 'la-guancha'),
  ('38', '38019', 'Guía de Isora', 'guia-de-isora'),
  ('38', '38020', 'Güímar', 'guimar'),
  ('38', '38021', 'Hermigua', 'hermigua'),
  ('38', '38022', 'Icod de los Vinos', 'icod-de-los-vinos'),
  ('38', '38023', 'San Cristóbal de La Laguna', 'san-cristobal-de-la-laguna'),
  ('38', '38024', 'Los Llanos de Aridane', 'los-llanos-de-aridane'),
  ('38', '38025', 'La Matanza de Acentejo', 'la-matanza-de-acentejo'),
  ('38', '38026', 'La Orotava', 'la-orotava'),
  ('38', '38027', 'El Paso', 'el-paso'),
  ('38', '38028', 'Puerto de la Cruz', 'puerto-de-la-cruz'),
  ('38', '38029', 'Puntagorda', 'puntagorda'),
  ('38', '38030', 'Puntallana', 'puntallana'),
  ('38', '38031', 'Los Realejos', 'los-realejos'),
  ('38', '38032', 'El Rosario', 'el-rosario'),
  ('38', '38033', 'San Andrés y Sauces', 'san-andres-y-sauces'),
  ('38', '38034', 'San Juan de la Rambla', 'san-juan-de-la-rambla'),
  ('38', '38035', 'San Miguel de Abona', 'san-miguel-de-abona'),
  ('38', '38036', 'San Sebastián de la Gomera', 'san-sebastian-de-la-gomera'),
  ('38', '38037', 'Santa Cruz de La Palma', 'santa-cruz-de-la-palma'),
  ('38', '38038', 'Santa Cruz de Tenerife', 'santa-cruz-de-tenerife'),
  ('38', '38039', 'Santa Úrsula', 'santa-ursula'),
  ('38', '38040', 'Santiago del Teide', 'santiago-del-teide'),
  ('38', '38041', 'El Sauzal', 'el-sauzal'),
  ('38', '38042', 'Los Silos', 'los-silos'),
  ('38', '38043', 'Tacoronte', 'tacoronte'),
  ('38', '38044', 'El Tanque', 'el-tanque'),
  ('38', '38045', 'Tazacorte', 'tazacorte'),
  ('38', '38046', 'Tegueste', 'tegueste'),
  ('38', '38047', 'Tijarafe', 'tijarafe'),
  ('38', '38048', 'Valverde', 'valverde'),
  ('38', '38049', 'Valle Gran Rey', 'valle-gran-rey'),
  ('38', '38050', 'Vallehermoso', 'vallehermoso'),
  ('38', '38051', 'La Victoria de Acentejo', 'la-victoria-de-acentejo'),
  ('38', '38052', 'Vilaflor', 'vilaflor'),
  ('38', '38053', 'Villa de Mazo', 'villa-de-mazo'),
  ('38', '38901', 'El Pinar de El Hierro', 'el-pinar-de-el-hierro');

DO $$
DECLARE faltan text;
BEGIN
  SELECT string_agg(DISTINCT m.prov, ', ') INTO faltan FROM _municipios m
  WHERE NOT EXISTS (SELECT 1 FROM public.provinces p WHERE p.code = m.prov);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan provincias: %', faltan;
  END IF;
END;
$$;

INSERT INTO public.municipalities (province_id, name, normalized_name, official_code)
SELECT p.id, m.name, m.norm, m.ine
FROM _municipios m JOIN public.provinces p ON p.code = m.prov
ON CONFLICT (province_id, normalized_name) DO UPDATE
  SET official_code = EXCLUDED.official_code
  WHERE public.municipalities.official_code IS NULL;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.municipalities mu
  JOIN _municipios m ON mu.official_code = m.ine;
  IF n < 88 THEN
    RAISE EXCEPTION 'Se esperaban al menos 88 municipios con código INE, hay %', n;
  END IF;
END;
$$;

COMMIT;

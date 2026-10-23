-- Carga de la categoría Correos de Las Palmas (provincia 35), trozo de la carga de Andalucía.
-- Origen: postal_service-canarias.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-21T20:21:46Z).
-- 35 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-canarias:postal_service:node-1121523141', 'Correos Puerto del Rosario – Calle Canalejas', NULL, '35017', 'Calle Canalejas 13', '35600', 28.49486, -13.864, 'address', 'openstreetmap:node/1121523141'),
  ('catalogo-canarias:postal_service:node-11504514851', 'Correos Telde – Calle Estefanota', NULL, '35026', 'Calle Estefanota 15', NULL, 28.00822, -15.37794, 'address', 'openstreetmap:node/11504514851'),
  ('catalogo-canarias:postal_service:node-11751460154', 'Correos Las Palmas de Gran Canaria – Calle Echegaray', NULL, '35016', 'Calle Echegaray 58', '35011', 28.11496, -15.43352, 'address', 'openstreetmap:node/11751460154'),
  ('catalogo-canarias:postal_service:node-11888494315', 'Correos Tías – San Antonio', NULL, '35028', 'San Antonio', '35572', 28.95387, -13.65356, 'address', 'openstreetmap:node/11888494315'),
  ('catalogo-canarias:postal_service:node-13266933178', 'Correos Las Palmas de Gran Canaria – Calle Thomas Alva Edison', NULL, '35016', 'Calle Thomas Alva Edison 29', '35007', 28.13637, -15.43519, 'address', 'openstreetmap:node/13266933178'),
  ('catalogo-canarias:postal_service:node-1402497639', 'Correos Gáldar – Calle Antonio Padrón', NULL, '35009', 'Calle Antonio Padrón', '35460', 28.14533, -15.65482, 'address', 'openstreetmap:node/1402497639'),
  ('catalogo-canarias:postal_service:node-1404113382', 'Correos Santa María de Guía de Gran Canaria – Calle Marqués del Muni nº2', NULL, '35023', 'Calle Marqués del Muni nº2', NULL, 28.13896, -15.63272, 'address', 'openstreetmap:node/1404113382'),
  ('catalogo-canarias:postal_service:node-1524995971', 'Correos Agaete – Calle Concepción', NULL, '35001', 'Calle Concepción 2', '35480', 28.0992, -15.6993, 'address', 'openstreetmap:node/1524995971'),
  ('catalogo-canarias:postal_service:node-1599509286', 'Correos Mogán – Calle Explanada del Castillete', NULL, '35012', 'Calle Explanada del Castillete', '35138', 27.81834, -15.76567, 'address', 'openstreetmap:node/1599509286'),
  ('catalogo-canarias:postal_service:node-2089183260', 'Correos Agüimes – Calle Drago', NULL, '35002', 'Calle Drago', '35260', 27.90427, -15.44778, 'address', 'openstreetmap:node/2089183260'),
  ('catalogo-canarias:postal_service:node-2720733356', 'Correos Vega de San Mateo – Calle Principal', NULL, '35033', 'Calle Principal 37', '35320', 28.01086, -15.53287, 'address', 'openstreetmap:node/2720733356'),
  ('catalogo-canarias:postal_service:node-319112919', 'Correos La Oliva – Calle Bajos del Mejillón', NULL, '35014', 'Calle Bajos del Mejillón', '35660', 28.74019, -13.86905, 'address', 'openstreetmap:node/319112919'),
  ('catalogo-canarias:postal_service:node-3434026625', 'Correos Las Palmas de Gran Canaria – Parque Santa Catalina', NULL, '35016', 'Parque Santa Catalina', '35007', 28.13966, -15.43002, 'address', 'openstreetmap:node/3434026625'),
  ('catalogo-canarias:postal_service:node-344603683', 'Correos Las Palmas de Gran Canaria – Paseo de Lugo', NULL, '35016', 'Paseo de Lugo 19', '35004', 28.11796, -15.42481, 'address', 'openstreetmap:node/344603683'),
  ('catalogo-canarias:postal_service:node-4042708838', 'Correos Antigua – Avenida José Franchy Roca', NULL, '35003', 'Avenida José Franchy Roca', NULL, 28.39954, -13.85414, 'address', 'openstreetmap:node/4042708838'),
  ('catalogo-canarias:postal_service:node-435698972', 'Correos Las Palmas de Gran Canaria – Calle California', NULL, '35016', 'Calle California 21', '35010', 28.13169, -15.44277, 'address', 'openstreetmap:node/435698972'),
  ('catalogo-canarias:postal_service:node-447602304', 'Correos Las Palmas de Gran Canaria – Calle Bernardo de la Torre 30-32', NULL, '35016', 'Calle Bernardo de la Torre 30-32', '35007', 28.13735, -15.4344, 'address', 'openstreetmap:node/447602304'),
  ('catalogo-canarias:postal_service:node-4895449796', 'Correos San Bartolomé de Tirajana – Avda. de Tirajana', NULL, '35019', 'Avda. de Tirajana 39', '35100', 27.76291, -15.57923, 'address', 'openstreetmap:node/4895449796'),
  ('catalogo-canarias:postal_service:node-5084432141', 'Correos Las Palmas de Gran Canaria – Calle Granadera Canaria', NULL, '35016', 'Calle Granadera Canaria 28', '35001', 28.09675, -15.41448, 'address', 'openstreetmap:node/5084432141'),
  ('catalogo-canarias:postal_service:node-5202747216', 'Correos Las Palmas de Gran Canaria – Avenida José Mesa y López', NULL, '35016', 'Avenida José Mesa y López', '35007', 28.13491, -15.43157, 'address', 'openstreetmap:node/5202747216'),
  ('catalogo-canarias:postal_service:node-5206054221', 'Correos La Aldea de San Nicolás – Calle Real', NULL, '35020', 'Calle Real', '35470', 27.98435, -15.7801, 'address', 'openstreetmap:node/5206054221'),
  ('catalogo-canarias:postal_service:node-5336908823', 'Correos Santa Lucía de Tirajana – Calle Agaldar 85/87 bajo', NULL, '35022', 'Calle Agaldar 85/87 bajo', '35110', 27.84276, -15.44252, 'address', 'openstreetmap:node/5336908823'),
  ('catalogo-canarias:postal_service:node-5380348199', 'Correos Mogán – Calle San José', NULL, '35012', 'Calle San José', NULL, 27.88521, -15.72315, 'address', 'openstreetmap:node/5380348199'),
  ('catalogo-canarias:postal_service:node-569404727', 'Correos Pájara – Calle Buenavista', NULL, '35015', 'Calle Buenavista 5', '35625', 28.05169, -14.35135, 'address', 'openstreetmap:node/569404727'),
  ('catalogo-canarias:postal_service:node-599623300', 'Correos Tuineje – Avenida Paco Hierro', NULL, '35030', 'Avenida Paco Hierro 2a', '35620', 28.21185, -14.02163, 'address', 'openstreetmap:node/599623300'),
  ('catalogo-canarias:postal_service:node-602645817', 'Correos Las Palmas de Gran Canaria – Calle Molino de Viento', NULL, '35016', 'Calle Molino de Viento 9', '35003', 28.11377, -15.42201, 'address', 'openstreetmap:node/602645817'),
  ('catalogo-canarias:postal_service:node-6428286916', 'Correos Santa Lucía de Tirajana – Calle Silvestre Bello', NULL, '35022', 'Calle Silvestre Bello', NULL, 27.85447, -15.43865, 'address', 'openstreetmap:node/6428286916'),
  ('catalogo-canarias:postal_service:node-6760726489', 'Correos Tejeda – Ezequiel Sánchez', NULL, '35025', 'Ezequiel Sánchez 4', '35360', 27.99555, -15.61538, 'address', 'openstreetmap:node/6760726489'),
  ('catalogo-canarias:postal_service:node-7747110719', 'Correos Las Palmas de Gran Canaria – Calle Gordillo', NULL, '35016', 'Calle Gordillo 10', '35008', 28.14986, -15.42621, 'address', 'openstreetmap:node/7747110719'),
  ('catalogo-canarias:postal_service:node-9288359988', 'Correos Pájara – Calle La Parabola', NULL, '35015', 'Calle La Parabola 3', '35627', 28.16185, -14.23033, 'address', 'openstreetmap:node/9288359988'),
  ('catalogo-canarias:postal_service:node-9363869539', 'Correos Arrecife – Calle Manolo Millares 121D', NULL, '35004', 'Calle Manolo Millares 121D', '35500', 28.95935, -13.56031, 'address', 'openstreetmap:node/9363869539'),
  ('catalogo-canarias:postal_service:relation-11569030', 'Correos Las Palmas de Gran Canaria – Calle Telégrafos', NULL, '35016', 'Calle Telégrafos', '35011', 28.10291, -15.44737, 'address', 'openstreetmap:relation/11569030'),
  ('catalogo-canarias:postal_service:way-478352387', 'Correos Agüimes – Calle Moneiba', NULL, '35002', 'Calle Moneiba', NULL, 27.88089, -15.43256, 'address', 'openstreetmap:way/478352387'),
  ('catalogo-canarias:postal_service:way-548373731', 'Correos Yaiza – Calle Salida al Rubicon', NULL, '35034', 'Calle Salida al Rubicon', '35570', 28.95179, -13.76497, 'address', 'openstreetmap:way/548373731'),
  ('catalogo-canarias:postal_service:way-629467297', 'Correos Gáldar – Calle Salvador Dalí', NULL, '35009', 'Calle Salvador Dalí', NULL, 28.15351, -15.6919, 'address', 'openstreetmap:way/629467297');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '35');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 35 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '35'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 35 THEN
    RAISE EXCEPTION 'Se esperaban 35 puntos de Correos en Las Palmas, hay %', n;
  END IF;
END;
$$;

COMMIT;

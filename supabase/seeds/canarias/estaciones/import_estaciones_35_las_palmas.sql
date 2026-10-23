-- Carga de la categoría Estaciones de Las Palmas (provincia 35), trozo de la carga de Andalucía.
-- Origen: estaciones-canarias.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-21T20:21:46Z).
-- 31 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-canarias:estaciones:node-1891279583', 'Telde (Estación de guaguas) – Avenida Cabildo Insular', 'Autobús', '35026', 'Avenida Cabildo Insular', NULL, 27.99897, -15.41182, 'address', 'openstreetmap:node/1891279583'),
  ('catalogo-canarias:estaciones:node-2066755425', 'Estación Faro de Maspalomas (San Bartolomé de Tirajana) – Avenida de Cristóbal Colón', 'Autobús', '35019', 'Avenida de Cristóbal Colón', '35100', 27.73915, -15.59807, 'address', 'openstreetmap:node/2066755425'),
  ('catalogo-canarias:estaciones:node-4035648729', 'Estación de guaguas (Moya) – CALLE LUJAN PEREZ', 'Autobús', '35013', 'CALLE LUJAN PEREZ 6', NULL, 28.10841, -15.58354, 'approximate', 'openstreetmap:node/4035648729'),
  ('catalogo-canarias:estaciones:node-5609141622', 'Estación de autobuses de Guaguas La Pardilla (Telde) – Calle Azorín', 'Autobús', '35026', 'Calle Azorín', NULL, 28.00755, -15.41033, 'address', 'openstreetmap:node/5609141622'),
  ('catalogo-canarias:estaciones:node-6046113943', 'Estación de autobuses de Puerto Rico (Mogán) – Avenida de La Cornisa', 'Autobús', '35012', 'Avenida de La Cornisa', NULL, 27.78866, -15.71062, 'address', 'openstreetmap:node/6046113943'),
  ('catalogo-canarias:estaciones:node-6237667788', 'Estación de autobuses de Marquesina PA 23 UGAN (Pájara)', 'Autobús', '35015', NULL, NULL, 28.24113, -14.19796, 'address', 'openstreetmap:node/6237667788'),
  ('catalogo-canarias:estaciones:node-6266185277', 'Terminal Fred Olsen (Las Palmas de Gran Canaria) – Avenida de Los Consignatarios', 'Autobús', '35016', 'Avenida de Los Consignatarios', NULL, 28.14701, -15.42164, 'address', 'openstreetmap:node/6266185277'),
  ('catalogo-canarias:estaciones:node-629040610', 'Estación de autobuses de Costa Calma (Pájara) – Calle Playa de la Jaqueta', 'Autobús', '35015', 'Calle Playa de la Jaqueta', NULL, 28.16871, -14.22524, 'address', 'openstreetmap:node/629040610'),
  ('catalogo-canarias:estaciones:way-1311865511', 'Estación de autobuses de Castillo de La Luz (Las Palmas de Gran Canaria) – Calle Pérez Muñoz', 'Autobús', '35016', 'Calle Pérez Muñoz', '35008', 28.14819, -15.42604, 'address', 'openstreetmap:way/1311865511'),
  ('catalogo-canarias:estaciones:way-1515638931', 'El Cotillo Bus Station (La Oliva) – Calle Castillo del Rico', 'Autobús', '35014', 'Calle Castillo del Rico', NULL, 28.68078, -14.00849, 'address', 'openstreetmap:way/1515638931'),
  ('catalogo-canarias:estaciones:way-1516631780', 'Corralejo Bus Station (La Oliva) – Calle Bajos del Mejillón', 'Autobús', '35014', 'Calle Bajos del Mejillón', '35660', 28.74032, -13.87125, 'address', 'openstreetmap:way/1516631780'),
  ('catalogo-canarias:estaciones:way-1517518599', 'Gran Tarajal Bus Station (Tuineje) – Calle Doña Josefina la Maestra', 'Autobús', '35030', 'Calle Doña Josefina la Maestra', NULL, 28.2167, -14.01983, 'address', 'openstreetmap:way/1517518599'),
  ('catalogo-canarias:estaciones:way-1517647558', 'Puerto del Carmen Bus Station (Tías) – Calle Juan Carlos I', 'Autobús', '35028', 'Calle Juan Carlos I', NULL, 28.92837, -13.66465, 'address', 'openstreetmap:way/1517647558'),
  ('catalogo-canarias:estaciones:way-1523557883', 'Estación de Moya – CALLE LUJAN PEREZ', 'Autobús', '35013', 'CALLE LUJAN PEREZ 6', NULL, 28.10825, -15.58361, 'approximate', 'openstreetmap:way/1523557883'),
  ('catalogo-canarias:estaciones:way-1565562081', 'Estación de Guaguas Santa Catalina (Las Palmas de Gran Canaria)', 'Autobús', '35016', NULL, NULL, 28.13983, -15.42842, 'address', 'openstreetmap:way/1565562081'),
  ('catalogo-canarias:estaciones:way-194453847', 'Estación de Guaguas (Arrecife) – Rambla Medular', 'Autobús', '35004', 'Rambla Medular', '35500', 28.96753, -13.55209, 'address', 'openstreetmap:way/194453847'),
  ('catalogo-canarias:estaciones:way-194829417', 'Intercambiador de Guaguas (Arrecife) – Avenida Fred Olsen', 'Autobús', '35004', 'Avenida Fred Olsen', NULL, 28.95777, -13.56223, 'address', 'openstreetmap:way/194829417'),
  ('catalogo-canarias:estaciones:way-202524018', 'Estación de autobuses (San Bartolomé) – Aeropuerto', 'Autobús', '35018', 'Aeropuerto', NULL, 28.95293, -13.60875, 'address', 'openstreetmap:way/202524018'),
  ('catalogo-canarias:estaciones:way-266546773', 'Estación de Guaguas (San Mateo) (Vega de San Mateo) – Avenida del mercado', 'Autobús', '35033', 'Avenida del mercado', '35320', 28.00878, -15.53229, 'address', 'openstreetmap:way/266546773'),
  ('catalogo-canarias:estaciones:way-365053453', 'Estación de Teror (Global) – Calle El Hoyo', 'Autobús', '35027', 'Calle El Hoyo', '35330', 28.06088, -15.54522, 'address', 'openstreetmap:way/365053453'),
  ('catalogo-canarias:estaciones:way-401108411', 'Estación de Guaguas (Gáldar) – Calle Pedro de Argüello', 'Autobús', '35009', 'Calle Pedro de Argüello 10', '35460', 28.14443, -15.64948, 'address', 'openstreetmap:way/401108411'),
  ('catalogo-canarias:estaciones:way-415802986', 'Estación de Guaguas (Pájara) – Calle Cervantes', 'Autobús', '35015', 'Calle Cervantes', NULL, 28.05961, -14.35448, 'address', 'openstreetmap:way/415802986'),
  ('catalogo-canarias:estaciones:way-475031415', 'Estación de Guaguas Playa Blanca (Yaiza) – Avenida de Canarias', 'Autobús', '35034', 'Avenida de Canarias 30', '35580', 28.86447, -13.8316, 'address', 'openstreetmap:way/475031415'),
  ('catalogo-canarias:estaciones:way-562240059', 'Estación de autobuses de Puerto de Mogán – Avenida de Las Artes', 'Autobús', '35012', 'Avenida de Las Artes', '35138', 27.82073, -15.7625, 'address', 'openstreetmap:way/562240059'),
  ('catalogo-canarias:estaciones:way-565575178', 'Estación de guaguas de Firgas – Calle 18 de Julio', 'Autobús', '35008', 'Calle 18 de Julio', NULL, 28.10814, -15.56392, 'address', 'openstreetmap:way/565575178'),
  ('catalogo-canarias:estaciones:way-582380461', 'Estación de guaguas El Teatro (Las Palmas de Gran Canaria) – Calle Miguel de Cervantes', 'Autobús', '35016', 'Calle Miguel de Cervantes', '35002', 28.10441, -15.41352, 'address', 'openstreetmap:way/582380461'),
  ('catalogo-canarias:estaciones:way-583950632', 'Estación de Arucas – Calle Alcalde Francisco Ferrera', 'Autobús', '35006', 'Calle Alcalde Francisco Ferrera', '35400', 28.11868, -15.5268, 'address', 'openstreetmap:way/583950632'),
  ('catalogo-canarias:estaciones:way-584044810', 'Estación de guaguas de San Telmo (Las Palmas de Gran Canaria) – Avenida de Rafael Cabrera', 'Autobús', '35016', 'Avenida de Rafael Cabrera', NULL, 28.10892, -15.41559, 'address', 'openstreetmap:way/584044810'),
  ('catalogo-canarias:estaciones:way-626962259', 'Terminal Manuel Becerra (Las Palmas de Gran Canaria) – Calle La Naval', 'Autobús', '35016', 'Calle La Naval 197', NULL, 28.15012, -15.42231, 'address', 'openstreetmap:way/626962259'),
  ('catalogo-canarias:estaciones:way-638591387', 'Estación de transbordo de Tamaraceite (Las Palmas de Gran Canaria) – Calle Lucy Cabrera Suárez (Cantante Lírica)', 'Autobús', '35016', 'Calle Lucy Cabrera Suárez (Cantante Lírica)', '35018', 28.09886, -15.47947, 'address', 'openstreetmap:way/638591387'),
  ('catalogo-canarias:estaciones:way-85641278', 'Estación Insular de Guaguas (Puerto del Rosario) – Calle José Díaz Díaz (Pepito el de las Guaguas)', 'Autobús', '35017', 'Calle José Díaz Díaz (Pepito el de las Guaguas)', '35600', 28.50358, -13.86014, 'address', 'openstreetmap:way/85641278');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
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
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 31 THEN
    RAISE EXCEPTION 'Se esperaban 31 puntos de Estaciones en Las Palmas, hay %', n;
  END IF;
END;
$$;

COMMIT;

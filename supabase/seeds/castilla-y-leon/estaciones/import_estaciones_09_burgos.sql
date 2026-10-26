-- Carga de la categoría Estaciones de Burgos (provincia 09), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 29 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:estaciones:node-11583894859', 'Estación de tren de Espinosa de los Monteros – Calle la Estación', 'Tren', '09124', 'Calle la Estación 9', NULL, 43.07429, -3.53727, 'address', 'openstreetmap:node/11583894859'),
  ('catalogo-castilla-y-leon:estaciones:node-12495839163', 'Estación de tren de Cabañas de Virtus (Valle de Valdebezana)', 'Tren', '09413', NULL, NULL, 42.99637, -3.85841, 'address', 'openstreetmap:node/12495839163'),
  ('catalogo-castilla-y-leon:estaciones:node-12495839164', 'Estación de tren de Robredo-Ahedo (Merindad de Valdeporres) – Acceso Vía Ferrocarril FEVE', 'Tren', '09216', 'Acceso Vía Ferrocarril FEVE', NULL, 43.01904, -3.80931, 'address', 'openstreetmap:node/12495839164'),
  ('catalogo-castilla-y-leon:estaciones:node-12495839165', 'Estación de tren de Dosante-Cidad (Merindad de Valdeporres)', 'Tren', '09216', NULL, NULL, 43.0113, -3.75587, 'address', 'openstreetmap:node/12495839165'),
  ('catalogo-castilla-y-leon:estaciones:node-13021298528', 'Estación de tren de Burgos - Rosa Manzano – Avenida Princesa de Asturias', 'Tren', '09059', 'Avenida Princesa de Asturias', '09006', 42.37116, -3.66632, 'address', 'openstreetmap:node/13021298528'),
  ('catalogo-castilla-y-leon:estaciones:node-13653602041', 'Estación de tren de Miranda de Ebro – Plaza de la Estación', 'Tren', '09219', 'Plaza de la Estación', NULL, 42.6908, -2.94114, 'address', 'openstreetmap:node/13653602041'),
  ('catalogo-castilla-y-leon:estaciones:node-13654590000', 'Estación de tren de Soncillo (Valle de Valdebezana)', 'Tren', '09413', NULL, NULL, 43.00579, -3.84486, 'address', 'openstreetmap:node/13654590000'),
  ('catalogo-castilla-y-leon:estaciones:node-13654694401', 'Estación de tren de Sotoscueva (Merindad de Sotoscueva) – Carretera BU526 KM.22', 'Tren', '09215', 'Carretera BU526 KM.22', NULL, 43.04527, -3.68835, 'address', 'openstreetmap:node/13654694401'),
  ('catalogo-castilla-y-leon:estaciones:node-13809295632', 'Estación de Autobuses de Burgos – Calle Calatravas', 'Autobús', '09059', 'Calle Calatravas 3', '09002', 42.33797, -3.70111, 'address', 'openstreetmap:node/13809295632'),
  ('catalogo-castilla-y-leon:estaciones:node-1864468754', 'Estación de tren de Pedrosa (Merindad de Valdeporres) – Patio Andaluz', 'Tren', '09216', 'Patio Andaluz', '09574', 43.01234, -3.73781, 'address', 'openstreetmap:node/1864468754'),
  ('catalogo-castilla-y-leon:estaciones:node-1920075087', 'Estación de tren de Pancorbo – Calle Estación Ferrocarril', 'Tren', '09251', 'Calle Estación Ferrocarril', NULL, 42.6302, -3.11282, 'address', 'openstreetmap:node/1920075087'),
  ('catalogo-castilla-y-leon:estaciones:node-2046477536', 'Estación de tren de La Puebla de Arganzón – Calle de la Estación', 'Tren', '09276', 'Calle de la Estación', '09294', 42.76522, -2.83023, 'address', 'openstreetmap:node/2046477536'),
  ('catalogo-castilla-y-leon:estaciones:node-2296082661', 'Estación de autobuses de Briviesca – Avenida Doctor Félix Rodríguez de la Fuente', 'Autobús', '09056', 'Avenida Doctor Félix Rodríguez de la Fuente 3', '09240', 42.55199, -3.32049, 'address', 'openstreetmap:node/2296082661'),
  ('catalogo-castilla-y-leon:estaciones:node-2371681583', 'Estación de tren de Villaquirán (Villaquirán de los Infantes)', 'Tren', '09456', NULL, NULL, 42.21566, -3.99962, 'address', 'openstreetmap:node/2371681583'),
  ('catalogo-castilla-y-leon:estaciones:node-5680147299', 'Estación de tren de Bercedo-Montija (Merindad de Montija) – Calle Estación', 'Tren', '09214', 'Calle Estación 1', '09569', 43.0884, -3.45763, 'address', 'openstreetmap:node/5680147299'),
  ('catalogo-castilla-y-leon:estaciones:node-5703983534', 'Estación de tren de Quintana de los Prados (Espinosa de los Monteros) – Camino de los Mojones', 'Tren', '09124', 'Camino de los Mojones 32', NULL, 43.07993, -3.51151, 'address', 'openstreetmap:node/5703983534'),
  ('catalogo-castilla-y-leon:estaciones:node-5735465201', 'Estación de tren de Redondo (Merindad de Sotoscueva) – Poblado El Rebollar', 'Tren', '09215', 'Poblado El Rebollar', NULL, 43.06058, -3.61968, 'address', 'openstreetmap:node/5735465201'),
  ('catalogo-castilla-y-leon:estaciones:node-6036608781', 'Estación de tren de Mercadillo-Villasana (Valle de Mena)', 'Tren', '09410', NULL, NULL, 43.10554, -3.26295, 'address', 'openstreetmap:node/6036608781'),
  ('catalogo-castilla-y-leon:estaciones:node-6038383746', 'Estación de tren de Cadagua (Valle de Mena) – Poblado Cadagua', 'Tren', '09410', 'Poblado Cadagua', NULL, 43.06801, -3.34748, 'address', 'openstreetmap:node/6038383746'),
  ('catalogo-castilla-y-leon:estaciones:node-6189845315', 'Estación de tren de Ungo - Nava (Valle de Mena) – Calle Tarriba', 'Tren', '09410', 'Calle Tarriba', NULL, 43.15206, -3.26599, 'address', 'openstreetmap:node/6189845315'),
  ('catalogo-castilla-y-leon:estaciones:node-6566247833', 'Estación de tren de Arla Berrón (Valle de Mena)', 'Tren', '09410', NULL, NULL, 43.16671, -3.22762, 'address', 'openstreetmap:node/6566247833'),
  ('catalogo-castilla-y-leon:estaciones:node-6568552483', 'Estación de tren de Arija – Calle Arsenio Brachott', 'Tren', '09025', 'Calle Arsenio Brachott 30', '09570', 42.99121, -3.94463, 'address', 'openstreetmap:node/6568552483'),
  ('catalogo-castilla-y-leon:estaciones:node-9144790787', 'Estación de tren de Briviesca – Plaza de la Estación', 'Tren', '09056', 'Plaza de la Estación', NULL, 42.54273, -3.31908, 'address', 'openstreetmap:node/9144790787'),
  ('catalogo-castilla-y-leon:estaciones:way-111759325', 'Estación de Autobuses de Aranda de Duero – Avenida Valladolid', 'Autobús', '09018', 'Avenida Valladolid 38', '09400', 41.67022, -3.6949, 'address', 'openstreetmap:way/111759325'),
  ('catalogo-castilla-y-leon:estaciones:way-117015796', 'Estación de Autobuses de Medina de Pomar – Calle Velázquez', 'Autobús', '09209', 'Calle Velázquez 3', '09500', 42.93397, -3.48761, 'address', 'openstreetmap:way/117015796'),
  ('catalogo-castilla-y-leon:estaciones:way-192771994', 'Estación de Autobuses (Miranda de Ebro) – Ronda del Ferrocarril', 'Autobús', '09219', 'Ronda del Ferrocarril 42', NULL, 42.69043, -2.94016, 'address', 'openstreetmap:way/192771994'),
  ('catalogo-castilla-y-leon:estaciones:way-193046608', 'Estación de Autobuses de Villarcayo (Villarcayo de Merindad de Castilla la Vieja) – Calle San Roque', 'Autobús', '09903', 'Calle San Roque', '09550', 42.94276, -3.56726, 'address', 'openstreetmap:way/193046608'),
  ('catalogo-castilla-y-leon:estaciones:way-225046255', 'Estación de Autobuses de Lerma – Calle Bomberos Voluntarios', 'Autobús', '09194', 'Calle Bomberos Voluntarios', NULL, 42.02502, -3.76482, 'address', 'openstreetmap:way/225046255'),
  ('catalogo-castilla-y-leon:estaciones:way-331251400', 'Estación de Bujedo (Bugedo)', 'Tren', '09057', NULL, NULL, 42.64906, -3.01354, 'address', 'openstreetmap:way/331251400');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '09');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 09 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '09'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 29 THEN
    RAISE EXCEPTION 'Se esperaban 29 puntos de Estaciones en Burgos, hay %', n;
  END IF;
END;
$$;

COMMIT;

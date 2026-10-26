-- Carga de la categoría Estaciones de Albacete (provincia 02), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 18 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-la-mancha:estaciones:node-10922195561', 'Estación de tren de Caudete', 'Tren', '02025', NULL, NULL, 38.71627, -0.95957, 'address', 'openstreetmap:node/10922195561'),
  ('catalogo-castilla-la-mancha:estaciones:node-11016395831', 'Estación de tren de Albacete Los Llanos – Plaza Estación de Autobuses', 'Tren', '02003', 'Plaza Estación de Autobuses', NULL, 39.00011, -1.84735, 'address', 'openstreetmap:node/11016395831'),
  ('catalogo-castilla-la-mancha:estaciones:node-1126592624', 'Estación de tren de Almansa – Paseo de la Libertad', 'Tren', '02009', 'Paseo de la Libertad', NULL, 38.86765, -1.10557, 'address', 'openstreetmap:node/1126592624'),
  ('catalogo-castilla-la-mancha:estaciones:node-12582183548', 'Estación de tren de Hellin – Calle Guardaguja', 'Tren', '02037', 'Calle Guardaguja', NULL, 38.509, -1.68864, 'address', 'openstreetmap:node/12582183548'),
  ('catalogo-castilla-la-mancha:estaciones:node-13719620829', 'Estación de tren de Villarrobledo – Calle Juan Ferreira', 'Tren', '02081', 'Calle Juan Ferreira', NULL, 39.26072, -2.59851, 'address', 'openstreetmap:node/13719620829'),
  ('catalogo-castilla-la-mancha:estaciones:node-14068976236', 'Estación de Autobuses de Almansa – Calle Muelle', 'Autobús', '02009', 'Calle Muelle', NULL, 38.8686, -1.10619, 'address', 'openstreetmap:node/14068976236'),
  ('catalogo-castilla-la-mancha:estaciones:node-1438862436', 'Estación de autobuses (Albacete) – Calle Federico García Lorca', 'Autobús', '02003', 'Calle Federico García Lorca 5', '02001', 38.99859, -1.84724, 'approximate', 'openstreetmap:node/1438862436'),
  ('catalogo-castilla-la-mancha:estaciones:node-1492679575', 'Estación de tren de Minaya', 'Tren', '02048', NULL, NULL, 39.24065, -2.3485, 'address', 'openstreetmap:node/1492679575'),
  ('catalogo-castilla-la-mancha:estaciones:node-1702273020', 'Estación de tren de Villar de Chinchilla (Chinchilla de Montearagón)', 'Tren', '02029', NULL, NULL, 38.90609, -1.4897, 'address', 'openstreetmap:node/1702273020'),
  ('catalogo-castilla-la-mancha:estaciones:node-2170852034', 'Estación de tren de La Gineta – Calle Santa Ana', 'Tren', '02035', 'Calle Santa Ana', NULL, 39.11161, -2.00045, 'address', 'openstreetmap:node/2170852034'),
  ('catalogo-castilla-la-mancha:estaciones:node-2398452226', 'Estación de tren de La Roda de Albacete – Avenida Juan García y González', 'Tren', '02069', 'Avenida Juan García y González', NULL, 39.19932, -2.16292, 'address', 'openstreetmap:node/2398452226'),
  ('catalogo-castilla-la-mancha:estaciones:way-141428163', 'Estación de Autobuses de Albacete – Calle Federico García Lorca', 'Autobús', '02003', 'Calle Federico García Lorca 5', '02001', 38.99808, -1.84648, 'approximate', 'openstreetmap:way/141428163'),
  ('catalogo-castilla-la-mancha:estaciones:way-157986453', 'Estacion de Chinchilla Nueva (Chinchilla de Montearagón)', 'Tren', '02029', NULL, NULL, 38.89746, -1.7261, 'address', 'openstreetmap:way/157986453'),
  ('catalogo-castilla-la-mancha:estaciones:way-383142644', 'Estación de Autobuses (Hellín) – Avenida de la Constitución', 'Autobús', '02037', 'Avenida de la Constitución', '02400', 38.50872, -1.70546, 'address', 'openstreetmap:way/383142644'),
  ('catalogo-castilla-la-mancha:estaciones:way-452760085', 'Estación de Autobuses (Villarrobledo) – Avenida de los Reyes Católicos', 'Autobús', '02081', 'Avenida de los Reyes Católicos', NULL, 39.2609, -2.60078, 'address', 'openstreetmap:way/452760085'),
  ('catalogo-castilla-la-mancha:estaciones:way-552348101', 'Estación de Alpera', 'Tren', '02010', NULL, NULL, 38.93992, -1.25301, 'address', 'openstreetmap:way/552348101'),
  ('catalogo-castilla-la-mancha:estaciones:way-552368952', 'Estación de tren de Pozo Cañada (Chinchilla de Montearagón)', 'Tren', '02029', NULL, NULL, 38.80419, -1.72433, 'address', 'openstreetmap:way/552368952'),
  ('catalogo-castilla-la-mancha:estaciones:way-558470621', 'Estación de Autobuses (Tobarra) – Calle de las Ciencias', 'Autobús', '02074', 'Calle de las Ciencias', '02500', 38.58683, -1.6903, 'address', 'openstreetmap:way/558470621');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '02');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 02 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '02'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 18 THEN
    RAISE EXCEPTION 'Se esperaban 18 puntos de Estaciones en Albacete, hay %', n;
  END IF;
END;
$$;

COMMIT;

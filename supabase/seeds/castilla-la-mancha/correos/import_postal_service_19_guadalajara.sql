-- Carga de la categoría Correos de Guadalajara (provincia 19), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 15 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-la-mancha:postal_service:node-10862162306', 'Correos Azuqueca de Henares – Calle Comendador', NULL, '19046', 'Calle Comendador 10', '19200', 40.5652, -3.2657, 'address', 'openstreetmap:node/10862162306'),
  ('catalogo-castilla-la-mancha:postal_service:node-1635287080', 'Correos Guadalajara – Avenida de Eduardo Guitián', NULL, '19130', 'Avenida de Eduardo Guitián', NULL, 40.62307, -3.16714, 'address', 'openstreetmap:node/1635287080'),
  ('catalogo-castilla-la-mancha:postal_service:node-1635287086', 'Correos Guadalajara – Calle de Alvargómez de Ciudad Real', NULL, '19130', 'Calle de Alvargómez de Ciudad Real', '19002', 40.62623, -3.16261, 'address', 'openstreetmap:node/1635287086'),
  ('catalogo-castilla-la-mancha:postal_service:node-1835213047', 'Correos Pastrana – Plaza del Ayuntamiento', NULL, '19212', 'Plaza del Ayuntamiento 1', '19100', 40.41725, -2.92455, 'address', 'openstreetmap:node/1835213047'),
  ('catalogo-castilla-la-mancha:postal_service:node-2311808695', 'Correos El Casar – Calle Juan Carlos I', NULL, '19071', 'Calle Juan Carlos I', '19170', 40.70348, -3.42839, 'address', 'openstreetmap:node/2311808695'),
  ('catalogo-castilla-la-mancha:postal_service:node-2694405875', 'Correos Yunquera de Henares – Calle Mayor', NULL, '19331', 'Calle Mayor 9', '19210', 40.7536, -3.1655, 'address', 'openstreetmap:node/2694405875'),
  ('catalogo-castilla-la-mancha:postal_service:node-3796493452', 'Correos Molina de Aragón – Calle de los Adarves', NULL, '19190', 'Calle de los Adarves 14', '19300', 40.843, -1.8871, 'address', 'openstreetmap:node/3796493452'),
  ('catalogo-castilla-la-mancha:postal_service:node-4427375190', 'Correos Pinilla de Jadraque – Plaza del Ayuntamiento', NULL, '19218', 'Plaza del Ayuntamiento', NULL, 41.02011, -2.94334, 'address', 'openstreetmap:node/4427375190'),
  ('catalogo-castilla-la-mancha:postal_service:node-4428666289', 'Correos Atienza – Plaza de Bruno Pascual', NULL, '19044', 'Plaza de Bruno Pascual 12', '19270', 41.19938, -2.8703, 'address', 'openstreetmap:node/4428666289'),
  ('catalogo-castilla-la-mancha:postal_service:node-4862438894', 'Correos Jadraque – Calle de Bilbaíno Contreras', NULL, '19156', 'Calle de Bilbaíno Contreras', '19240', 40.92612, -2.92667, 'address', 'openstreetmap:node/4862438894'),
  ('catalogo-castilla-la-mancha:postal_service:node-5643886594', 'Correos Marchamalo – Calle Senda de Alcor', NULL, '19171', 'Calle Senda de Alcor', NULL, 40.66853, -3.19757, 'address', 'openstreetmap:node/5643886594'),
  ('catalogo-castilla-la-mancha:postal_service:node-5644221112', 'Correos Cabanillas del Campo – Plaza del Pueblo', NULL, '19058', 'Plaza del Pueblo 1', '19171', 40.63663, -3.23384, 'address', 'openstreetmap:node/5644221112'),
  ('catalogo-castilla-la-mancha:postal_service:node-5819301963', 'Correos Sacedón – Calle de la Playa', NULL, '19245', 'Calle de la Playa 10', '19120', 40.48212, -2.73116, 'address', 'openstreetmap:node/5819301963'),
  ('catalogo-castilla-la-mancha:postal_service:node-9366875426', 'Correos Torrejón del Rey – Calle La Coruña', NULL, '19280', 'Calle La Coruña', NULL, 40.64225, -3.33419, 'address', 'openstreetmap:node/9366875426'),
  ('catalogo-castilla-la-mancha:postal_service:way-1428865242', 'Correos Mondéjar – Calle Madrid', NULL, '19192', 'Calle Madrid', '19110', 40.32514, -3.11212, 'address', 'openstreetmap:way/1428865242');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '19');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 19 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '19'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 15 THEN
    RAISE EXCEPTION 'Se esperaban 15 puntos de Correos en Guadalajara, hay %', n;
  END IF;
END;
$$;

COMMIT;

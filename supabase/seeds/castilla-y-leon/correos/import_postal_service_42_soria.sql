-- Carga de la categoría Correos de Soria (provincia 42), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 7 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:postal_service:node-10229699394', 'Correos Berlanga de Duero – Calle Galápagos', NULL, '42035', 'Calle Galápagos 2', '42360', 41.46762, -2.86288, 'address', 'openstreetmap:node/10229699394'),
  ('catalogo-castilla-y-leon:postal_service:node-2600750996', 'Correos Almazán – Calle Tirso de Molina', NULL, '42020', 'Calle Tirso de Molina 10', '42200', 41.48649, -2.52954, 'address', 'openstreetmap:node/2600750996'),
  ('catalogo-castilla-y-leon:postal_service:node-350121344', 'Correos Soria – Paseo del Espolón', NULL, '42173', 'Paseo del Espolón 6', '42001', 41.76454, -2.46978, 'address', 'openstreetmap:node/350121344'),
  ('catalogo-castilla-y-leon:postal_service:node-5133840917', 'Correos San Leonardo de Yagüe – Calle Picos de Urbión', NULL, '42164', 'Calle Picos de Urbión 5', '42140', 41.83, -3.06767, 'address', 'openstreetmap:node/5133840917'),
  ('catalogo-castilla-y-leon:postal_service:node-5613587854', 'Correos Gómara – Plaza Mayor', NULL, '42096', 'Plaza Mayor 1', '42120', 41.62363, -2.22464, 'address', 'openstreetmap:node/5613587854'),
  ('catalogo-castilla-y-leon:postal_service:node-6796049374', 'Correos Duruelo de la Sierra – Calle Nicolás Asenjo', NULL, '42078', 'Calle Nicolás Asenjo', NULL, 41.95401, -2.93139, 'address', 'openstreetmap:node/6796049374'),
  ('catalogo-castilla-y-leon:postal_service:node-7726631584', 'Correos Vinuesa – Calle Mostola', NULL, '42215', 'Calle Mostola', NULL, 41.90951, -2.764, 'address', 'openstreetmap:node/7726631584');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '42');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 42 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '42'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 7 THEN
    RAISE EXCEPTION 'Se esperaban 7 puntos de Correos en Soria, hay %', n;
  END IF;
END;
$$;

COMMIT;

-- Carga de la categoría Correos de Albacete (provincia 02), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 19 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-la-mancha:postal_service:node-12702460495', 'Correos Bienservida – Calle Calzada', NULL, '02016', 'Calle Calzada', NULL, 38.51639, -2.60934, 'address', 'openstreetmap:node/12702460495'),
  ('catalogo-castilla-la-mancha:postal_service:node-1492004386', 'Correos Villarrobledo – Travesía Don Pedro', NULL, '02081', 'Travesía Don Pedro', '02600', 39.26707, -2.6042, 'address', 'openstreetmap:node/1492004386'),
  ('catalogo-castilla-la-mancha:postal_service:node-1567267922', 'Correos Albacete – Avenida Cronista Mateos y Sotos', NULL, '02003', 'Avenida Cronista Mateos y Sotos 8', '02005', 39.00393, -1.86383, 'address', 'openstreetmap:node/1567267922'),
  ('catalogo-castilla-la-mancha:postal_service:node-1799468339', 'Correos Molinicos – C/ Nueva', NULL, '02049', 'C/ Nueva', '02440', 38.46625, -2.24008, 'address', 'openstreetmap:node/1799468339'),
  ('catalogo-castilla-la-mancha:postal_service:node-1866951143', 'Correos Villamalea – Calle Cuatro Esquinas', NULL, '02079', 'Calle Cuatro Esquinas', '02270', 39.36023, -1.59942, 'address', 'openstreetmap:node/1866951143'),
  ('catalogo-castilla-la-mancha:postal_service:node-2918592102', 'Correos Albacete – Calle G', NULL, '02003', 'Calle G 3', '02007', 39.01166, -1.87745, 'address', 'openstreetmap:node/2918592102'),
  ('catalogo-castilla-la-mancha:postal_service:node-3294325561', 'Correos La Roda – Avenida de Ramón y Cajal', NULL, '02069', 'Avenida de Ramón y Cajal 42', '02630', 39.20433, -2.15783, 'address', 'openstreetmap:node/3294325561'),
  ('catalogo-castilla-la-mancha:postal_service:node-4468308413', 'Correos Yeste – Calle San Bartolomé', NULL, '02086', 'Calle San Bartolomé', '02480', 38.36821, -2.31834, 'address', 'openstreetmap:node/4468308413'),
  ('catalogo-castilla-la-mancha:postal_service:node-4474351162', 'Correos Nerpio – Plaza Mayor', NULL, '02055', 'Plaza Mayor', '02530', 38.14776, -2.30195, 'address', 'openstreetmap:node/4474351162'),
  ('catalogo-castilla-la-mancha:postal_service:node-4487494546', 'Correos Casas-Ibáñez – Calle La Recueja', NULL, '02024', 'Calle La Recueja', NULL, 39.2849, -1.47139, 'address', 'openstreetmap:node/4487494546'),
  ('catalogo-castilla-la-mancha:postal_service:node-4490977834', 'Correos Hellín – Calle Alcalde Víctor Serena', NULL, '02037', 'Calle Alcalde Víctor Serena', '02400', 38.50989, -1.6983, 'address', 'openstreetmap:node/4490977834'),
  ('catalogo-castilla-la-mancha:postal_service:node-4716530195', 'Correos Lezuza – Calle Bonillo', NULL, '02043', 'Calle Bonillo', '02160', 38.94933, -2.35694, 'address', 'openstreetmap:node/4716530195'),
  ('catalogo-castilla-la-mancha:postal_service:node-6289854290', 'Correos Tobarra – Calle Turbula', NULL, '02074', 'Calle Turbula', '02500', 38.58849, -1.6895, 'address', 'openstreetmap:node/6289854290'),
  ('catalogo-castilla-la-mancha:postal_service:node-7175602979', 'Correos Alpera – Calle Seda', NULL, '02010', 'Calle Seda 1', NULL, 38.95992, -1.23085, 'address', 'openstreetmap:node/7175602979'),
  ('catalogo-castilla-la-mancha:postal_service:node-7616085874', 'Correos Ossa de Montiel – Avenida del Príncipe de Asturias', NULL, '02057', 'Avenida del Príncipe de Asturias 32', '02611', 38.96589, -2.74598, 'address', 'openstreetmap:node/7616085874'),
  ('catalogo-castilla-la-mancha:postal_service:way-1122159833', 'Correos Robledo – Plaza Mayor', NULL, '02068', 'Plaza Mayor 1', NULL, 38.75801, -2.45021, 'address', 'openstreetmap:way/1122159833'),
  ('catalogo-castilla-la-mancha:postal_service:way-141428450', 'Correos Albacete – Calle Dionisio Guardiola', NULL, '02003', 'Calle Dionisio Guardiola 10', '02003', 38.99216, -1.85745, 'address', 'openstreetmap:way/141428450'),
  ('catalogo-castilla-la-mancha:postal_service:way-450557064', 'Correos Chinchilla de Montearagón – Plaza de España', NULL, '02029', 'Plaza de España', NULL, 38.9217, -1.72612, 'address', 'openstreetmap:way/450557064'),
  ('catalogo-castilla-la-mancha:postal_service:way-525407863', 'Correos Balazote – Calle Cervantes', NULL, '02012', 'Calle Cervantes', NULL, 38.88513, -2.15212, 'address', 'openstreetmap:way/525407863');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 19 THEN
    RAISE EXCEPTION 'Se esperaban 19 puntos de Correos en Albacete, hay %', n;
  END IF;
END;
$$;

COMMIT;

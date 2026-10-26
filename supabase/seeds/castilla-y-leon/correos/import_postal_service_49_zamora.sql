-- Carga de la categoría Correos de Zamora (provincia 49), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 13 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:postal_service:node-10106358679', 'Correos San Cristóbal de Entreviñas – Calle Calvario', NULL, '49187', 'Calle Calvario 1', '49690', 42.04666, -5.63511, 'address', 'openstreetmap:node/10106358679'),
  ('catalogo-castilla-y-leon:postal_service:node-12476432482', 'Correos Zamora – Calle de Jiménez de Quesada', NULL, '49275', 'Calle de Jiménez de Quesada 4', '49029', 41.514, -5.7376, 'address', 'openstreetmap:node/12476432482'),
  ('catalogo-castilla-y-leon:postal_service:node-1422118609', 'Correos Puebla de Sanabria – Calle Arrabal', NULL, '49166', 'Calle Arrabal 35', NULL, 42.05146, -6.63355, 'address', 'openstreetmap:node/1422118609'),
  ('catalogo-castilla-y-leon:postal_service:node-1988329123', 'Correos Morales del Vino – Calle Cabaña', NULL, '49127', 'Calle Cabaña', NULL, 41.44637, -5.73011, 'address', 'openstreetmap:node/1988329123'),
  ('catalogo-castilla-y-leon:postal_service:node-1997449099', 'Correos Galende – Plaza del Mercado de El Puente', NULL, '49085', 'Plaza del Mercado de El Puente 23', NULL, 42.08546, -6.64126, 'address', 'openstreetmap:node/1997449099'),
  ('catalogo-castilla-y-leon:postal_service:node-3312580298', 'Correos Villaralbo – Calle Iglesia', NULL, '49261', 'Calle Iglesia', NULL, 41.49177, -5.6826, 'address', 'openstreetmap:node/3312580298'),
  ('catalogo-castilla-y-leon:postal_service:node-3336645546', 'Correos Villalpando – Plaza de San Nicolás', NULL, '49250', 'Plaza de San Nicolás 3', '49630', 41.86459, -5.41189, 'address', 'openstreetmap:node/3336645546'),
  ('catalogo-castilla-y-leon:postal_service:node-4540282320', 'Correos Mombuey – Plaza Ayuntamiento', NULL, '49121', 'Plaza Ayuntamiento', NULL, 42.02396, -6.33201, 'address', 'openstreetmap:node/4540282320'),
  ('catalogo-castilla-y-leon:postal_service:node-6356108680', 'Correos Fuentelapeña – Calle Don Claudio Moyano Samaniego', NULL, '49080', 'Calle Don Claudio Moyano Samaniego', NULL, 41.25299, -5.38235, 'address', 'openstreetmap:node/6356108680'),
  ('catalogo-castilla-y-leon:postal_service:node-6452773454', 'Correos Bermillo de Sayago – Calle Las Catañas', NULL, '49023', 'Calle Las Catañas', NULL, 41.36617, -6.10977, 'address', 'openstreetmap:node/6452773454'),
  ('catalogo-castilla-y-leon:postal_service:node-972438065', 'Correos Zamora – Calle de Santa Clara', NULL, '49275', 'Calle de Santa Clara 15', '49001', 41.50548, -5.74358, 'address', 'openstreetmap:node/972438065'),
  ('catalogo-castilla-y-leon:postal_service:way-324362378', 'Correos Toro – Calle Vicente Gonzalez', NULL, '49219', 'Calle Vicente Gonzalez', '49800', 41.52269, -5.38988, 'address', 'openstreetmap:way/324362378'),
  ('catalogo-castilla-y-leon:postal_service:way-431773937', 'Correos Benavente – Calle Santa Cruz', NULL, '49021', 'Calle Santa Cruz 20', '49600', 42.00281, -5.67666, 'address', 'openstreetmap:way/431773937');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '49');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 49 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '49'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 13 THEN
    RAISE EXCEPTION 'Se esperaban 13 puntos de Correos en Zamora, hay %', n;
  END IF;
END;
$$;

COMMIT;

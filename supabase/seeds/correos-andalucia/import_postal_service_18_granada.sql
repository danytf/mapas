-- Carga de la categoría Correos de Granada (provincia 18), trozo de la carga de Andalucía.
-- Origen: postal_service-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 2 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-andalucia:postal_service:node-12660772896', 'Correos Orce – Calle Tiendas', NULL, '18146', 'Calle Tiendas', '18858', 37.72143, -2.47905, 'address', 'openstreetmap:node/12660772896'),
  ('catalogo-andalucia:postal_service:node-4947455094', 'Correos Puebla de Don Fadrique – Avenida Juan Carlos I', NULL, '18164', 'Avenida Juan Carlos I', '18820', 37.95915, -2.43687, 'address', 'openstreetmap:node/4947455094');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '18');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 18 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '18'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 2 THEN
    RAISE EXCEPTION 'Se esperaban 2 puntos de Correos en Granada, hay %', n;
  END IF;
END;
$$;

COMMIT;

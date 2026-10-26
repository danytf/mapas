-- Carga de la categoría (varias) de Zamora (provincia 49), trozo de la carga de Andalucía.
-- Origen: castilla-y-leon-grandes-superficies-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 5 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-1413222352', 'Carrefour Galende – Carretera Ilanes-Puente', NULL, '49085', 'Carretera Ilanes-Puente', '49350', 42.08364, -6.64378, 'address', 'openstreetmap:node/1413222352'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-5679765217', 'Carrefour Zamora – Plaza del Maestro Haedo', NULL, '49275', 'Plaza del Maestro Haedo 11', '49003', 41.50381, -5.74507, 'address', 'openstreetmap:node/5679765217'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-6353349083', 'Carrefour Zamora – Calle de San Blas', NULL, '49275', 'Calle de San Blas', NULL, 41.51425, -5.74758, 'address', 'openstreetmap:node/6353349083'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-9167560955', 'Carrefour Puebla de Sanabria – Calle del Padre Vicente Salgado', NULL, '49166', 'Calle del Padre Vicente Salgado 23', '49300', 42.05474, -6.62998, 'address', 'openstreetmap:node/9167560955'),
  ('Decathlon', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-413273854', 'Decathlon Zamora – Calle Siega', NULL, '49275', 'Calle Siega', '49024', 41.5221, -5.75689, 'address', 'openstreetmap:way/413273854');

DO $$
DECLARE faltan text;
BEGIN
  SELECT string_agg(DISTINCT c.categoria, ', ') INTO faltan FROM _carga c WHERE NOT EXISTS (SELECT 1 FROM public.categories k WHERE k.name = c.categoria);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan categorías: %', faltan;
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
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 5 THEN
    RAISE EXCEPTION 'Se esperaban 5 puntos de (varias) en Zamora, hay %', n;
  END IF;
END;
$$;

COMMIT;

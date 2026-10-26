-- Carga de la categoría (varias) de Palencia (provincia 34), trozo de la carga de Andalucía.
-- Origen: castilla-y-leon-grandes-superficies-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 6 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-13049916617', 'Carrefour Palencia – Avenida Comunidad Europea', NULL, '34120', 'Avenida Comunidad Europea', NULL, 42.00766, -4.51149, 'address', 'openstreetmap:node/13049916617'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-1667146275', 'Carrefour Palencia – Calle Pedro Romero', NULL, '34120', 'Calle Pedro Romero', '34001', 42.01064, -4.53442, 'address', 'openstreetmap:node/1667146275'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-2102998469', 'Carrefour Palencia – Calle Francisco Vighi', NULL, '34120', 'Calle Francisco Vighi', '34004', 41.99182, -4.51639, 'address', 'openstreetmap:node/2102998469'),
  ('Leroy Merlin', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-3265048719', 'Leroy Merlin Palencia – Avenida de Brasilia', NULL, '34120', 'Avenida de Brasilia 5', '34004', 42.01254, -4.51847, 'address', 'openstreetmap:node/3265048719'),
  ('Decathlon', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-7912013086', 'Decathlon Palencia – Calle Marcos de Celis', NULL, '34120', 'Calle Marcos de Celis', '34004', 42.01316, -4.52052, 'address', 'openstreetmap:node/7912013086'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-8242141987', 'Carrefour Palencia – CARRETERA N-611 KM 10.9', NULL, '34120', 'CARRETERA N-611 KM 10.9', '34003', 42.02079, -4.52851, 'address', 'openstreetmap:node/8242141987');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '34');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 34 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '34'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 6 THEN
    RAISE EXCEPTION 'Se esperaban 6 puntos de (varias) en Palencia, hay %', n;
  END IF;
END;
$$;

COMMIT;

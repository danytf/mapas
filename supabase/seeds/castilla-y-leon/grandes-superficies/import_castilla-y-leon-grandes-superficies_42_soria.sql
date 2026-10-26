-- Carga de la categoría (varias) de Soria (provincia 42), trozo de la carga de Andalucía.
-- Origen: castilla-y-leon-grandes-superficies-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 3 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-4454087949', 'Carrefour San Leonardo de Yagüe – Calle Concepción', NULL, '42164', 'Calle Concepción 36', '42140', 41.83034, -3.06691, 'address', 'openstreetmap:node/4454087949'),
  ('Leroy Merlin', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-1323087857', 'Leroy Merlin Soria – Travesía F-2', NULL, '42173', 'Travesía F-2', NULL, 41.77546, -2.48582, 'address', 'openstreetmap:way/1323087857'),
  ('Decathlon', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-563656856', 'Decathlon Golmayo – Calle de la Música', NULL, '42095', 'Calle de la Música', NULL, 41.77202, -2.50047, 'address', 'openstreetmap:way/563656856');

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
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 3 THEN
    RAISE EXCEPTION 'Se esperaban 3 puntos de (varias) en Soria, hay %', n;
  END IF;
END;
$$;

COMMIT;

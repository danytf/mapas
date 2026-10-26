-- Carga de la categoría (varias) de Salamanca (provincia 37), trozo de la carga de Andalucía.
-- Origen: castilla-y-leon-tiendas-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 3 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-castilla-y-leon:castilla-y-leon-tiendas:node-9462552071', 'Mundo Animal Ciudad Rodrigo – Calle San Marcial', 'Mascotas', '37107', 'Calle San Marcial 3', '37500', 40.59785, -6.5275, 'address', 'openstreetmap:node/9462552071'),
  ('Tiendas', 'catalogo-castilla-y-leon:castilla-y-leon-tiendas:way-1137961379', 'Tiendanimal Santa Marta de Tormes – Avenida E. Leclerc', 'Mascotas', '37294', 'Avenida E. Leclerc', '37188', 40.9473, -5.64089, 'address', 'openstreetmap:way/1137961379'),
  ('Tiendas', 'catalogo-castilla-y-leon:castilla-y-leon-tiendas:way-72863393', 'Kiwoko Santa Marta de Tormes – Calle Virgen de la Macarena', 'Mascotas', '37294', 'Calle Virgen de la Macarena', NULL, 40.94831, -5.65073, 'address', 'openstreetmap:way/72863393');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '37');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 37 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '37'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 3 THEN
    RAISE EXCEPTION 'Se esperaban 3 puntos de (varias) en Salamanca, hay %', n;
  END IF;
END;
$$;

COMMIT;

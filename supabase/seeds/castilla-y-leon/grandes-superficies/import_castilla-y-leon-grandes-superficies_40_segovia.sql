-- Carga de la categoría (varias) de Segovia (provincia 40), trozo de la carga de Andalucía.
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
  ('Decathlon', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-10925840813', 'Decathlon Segovia – Calle de Juan Bravo', NULL, '40194', 'Calle de Juan Bravo 14', '40001', 40.94902, -4.12258, 'address', 'openstreetmap:node/10925840813'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-11866685356', 'Carrefour Segovia – Calle Guadarrama', NULL, '40194', 'Calle Guadarrama', '40006', 40.92135, -4.11337, 'address', 'openstreetmap:node/11866685356'),
  ('IKEA', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-11866685365', 'IKEA Segovia – Acceso Centro Comercial Luz de Castilla', NULL, '40194', 'Acceso Centro Comercial Luz de Castilla', '40006', 40.9207, -4.11251, 'address', 'openstreetmap:node/11866685365'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-9485895512', 'Carrefour Cantalejo – Calle Sepúlveda', NULL, '40040', 'Calle Sepúlveda 49', '40320', 41.25875, -3.92155, 'address', 'openstreetmap:node/9485895512'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-347765020', 'Carrefour El Espinar – Avenida Castilla y León', NULL, '40076', 'Avenida Castilla y León', NULL, 40.72003, -4.24092, 'address', 'openstreetmap:way/347765020');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '40');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 40 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '40'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 5 THEN
    RAISE EXCEPTION 'Se esperaban 5 puntos de (varias) en Segovia, hay %', n;
  END IF;
END;
$$;

COMMIT;

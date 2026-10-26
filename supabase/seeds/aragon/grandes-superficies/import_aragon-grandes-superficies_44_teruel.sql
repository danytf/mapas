-- Carga de la categoría (varias) de Teruel (provincia 44), trozo de la carga de Andalucía.
-- Origen: aragon-grandes-superficies-aragon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 5 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-11893677690', 'Carrefour Teruel – Paseo del Óvalo', NULL, '44216', 'Paseo del Óvalo 4', '44001', 40.34127, -1.1079, 'address', 'openstreetmap:node/11893677690'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-13061294660', 'Carrefour Valderrobres / Vall de Roures – Calle de San Rafael', NULL, '44246', 'Calle de San Rafael 2', '44580', 40.87236, 0.15093, 'address', 'openstreetmap:node/13061294660'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-13686852721', 'Carrefour Teruel – Avenida de Sagunto', NULL, '44216', 'Avenida de Sagunto 9', '44002', 40.33617, -1.10402, 'address', 'openstreetmap:node/13686852721'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:node-14303532647', 'Carrefour La Puebla de Valverde – AUTOVIA A-23 KM.', NULL, '44192', 'AUTOVIA A-23 KM. 100', NULL, 40.21959, -0.94038, 'address', 'openstreetmap:node/14303532647'),
  ('Carrefour', 'catalogo-aragon:aragon-grandes-superficies:way-845459039', 'Carrefour Caminreal – AUTOVIA A-23 KM.', NULL, '44056', 'AUTOVIA A-23 KM. 176', NULL, 40.83767, -1.30662, 'address', 'openstreetmap:way/845459039');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '44');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 44 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '44'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 5 THEN
    RAISE EXCEPTION 'Se esperaban 5 puntos de (varias) en Teruel, hay %', n;
  END IF;
END;
$$;

COMMIT;

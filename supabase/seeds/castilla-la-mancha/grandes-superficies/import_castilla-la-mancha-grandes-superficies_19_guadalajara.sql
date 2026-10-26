-- Carga de la categoría (varias) de Guadalajara (provincia 19), trozo de la carga de Andalucía.
-- Origen: castilla-la-mancha-grandes-superficies-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 4 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:node-11136198405', 'Carrefour Albalate de Zorita – Travesía Iglesia', NULL, '19006', 'Travesía Iglesia', NULL, 40.30695, -2.84294, 'address', 'openstreetmap:node/11136198405'),
  ('Leroy Merlin', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-380106665', 'Leroy Merlin Guadalajara – Calle de Trafalgar', NULL, '19130', 'Calle de Trafalgar', '19004', 40.62835, -3.18706, 'address', 'openstreetmap:way/380106665'),
  ('El Corte Inglés', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-383306368', 'El Corte Inglés Guadalajara – Avenida de Eduardo Guitián', NULL, '19130', 'Avenida de Eduardo Guitián', NULL, 40.62271, -3.1669, 'address', 'openstreetmap:way/383306368'),
  ('Carrefour', 'catalogo-castilla-la-mancha:castilla-la-mancha-grandes-superficies:way-710619108', 'Carrefour El Casar – Glorieta Doctor José Solano Aliende', NULL, '19071', 'Glorieta Doctor José Solano Aliende', NULL, 40.68803, -3.45517, 'address', 'openstreetmap:way/710619108');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '19');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 19 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '19'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 4 THEN
    RAISE EXCEPTION 'Se esperaban 4 puntos de (varias) en Guadalajara, hay %', n;
  END IF;
END;
$$;

COMMIT;

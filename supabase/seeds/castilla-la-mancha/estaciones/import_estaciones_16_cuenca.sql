-- Carga de la categoría Estaciones de Cuenca (provincia 16), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 4 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-la-mancha:estaciones:node-10592347455', 'Estación de tren de Cuenca-Fernando Zóbel', 'Tren', '16078', NULL, NULL, 40.03397, -2.14369, 'address', 'openstreetmap:node/10592347455'),
  ('catalogo-castilla-la-mancha:estaciones:node-4414461591', 'Estación de Autobuses (San Clemente) – Avenida de la Guardia Civil', 'Autobús', '16190', 'Avenida de la Guardia Civil', NULL, 39.40003, -2.43371, 'address', 'openstreetmap:node/4414461591'),
  ('catalogo-castilla-la-mancha:estaciones:way-179377995', 'Estación de Tarancón – Glorieta de la Estación', 'Tren', '16203', 'Glorieta de la Estación', NULL, 40.0065, -3.00978, 'address', 'openstreetmap:way/179377995'),
  ('catalogo-castilla-la-mancha:estaciones:way-850149053', 'Estación de autobuses de Cuenca – Plaza de la Ajedrea', 'Autobús', '16078', 'Plaza de la Ajedrea 1', '16004', 40.06679, -2.13534, 'address', 'openstreetmap:way/850149053');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '16');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 16 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '16'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 4 THEN
    RAISE EXCEPTION 'Se esperaban 4 puntos de Estaciones en Cuenca, hay %', n;
  END IF;
END;
$$;

COMMIT;

-- Carga de la categoría (varias) de Cádiz (provincia 11), trozo de la carga de Andalucía.
-- Origen: grandes-superficies-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 13 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-11975691989', 'MediaMarkt Los Barrios – Calle Cabotaje', NULL, '11008', 'Calle Cabotaje', '11379', 36.18852, -5.43244, 'address', 'openstreetmap:node/11975691989'),
  ('IKEA', 'catalogo-andalucia:grandes-superficies:node-12142807117', 'IKEA Algeciras', NULL, '11004', NULL, NULL, 36.13522, -5.46293, 'address', 'openstreetmap:node/12142807117'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-9555910517', 'Decathlon Cádiz – Calle Columela', NULL, '11012', 'Calle Columela', NULL, 36.53083, -6.29722, 'address', 'openstreetmap:node/9555910517'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-143857632', 'El Corte Inglés Cádiz – Avenida de las Cortes de Cádiz', NULL, '11012', 'Avenida de las Cortes de Cádiz', NULL, 36.5213, -6.27723, 'address', 'openstreetmap:way/143857632'),
  ('IKEA', 'catalogo-andalucia:grandes-superficies:way-143885440', 'IKEA Jerez de la Frontera', NULL, '11020', NULL, NULL, 36.69712, -6.16217, 'address', 'openstreetmap:way/143885440'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-204666475', 'Decathlon El Puerto de Santa María – Calle Luis M. Fernandez', NULL, '11027', 'Calle Luis M. Fernandez', '11500', 36.58634, -6.21834, 'address', 'openstreetmap:way/204666475'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-224738727', 'El Corte Inglés Jerez de la Frontera', NULL, '11020', NULL, NULL, 36.70416, -6.11566, 'address', 'openstreetmap:way/224738727'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-396625918', 'Leroy Merlin Jerez de la Frontera – Avenida Bergantín', NULL, '11020', 'Avenida Bergantín', NULL, 36.7092, -6.12727, 'address', 'openstreetmap:way/396625918'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-472227679', 'Decathlon Los Barrios – Calle Galera', NULL, '11008', 'Calle Galera', NULL, 36.18883, -5.43406, 'address', 'openstreetmap:way/472227679'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-481849128', 'Leroy Merlin Los Barrios – Avenida de los Empresarios', NULL, '11008', 'Avenida de los Empresarios', NULL, 36.18206, -5.43831, 'address', 'openstreetmap:way/481849128'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:way-502660315', 'MediaMarkt Puerto Real', NULL, '11028', NULL, NULL, 36.46924, -6.16955, 'address', 'openstreetmap:way/502660315'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-502660316', 'Leroy Merlin Puerto Real', NULL, '11028', NULL, NULL, 36.46916, -6.17044, 'address', 'openstreetmap:way/502660316'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-51368846', 'El Corte Inglés Algeciras – Calle Estadio', NULL, '11004', 'Calle Estadio', NULL, 36.139, -5.44838, 'address', 'openstreetmap:way/51368846');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '11');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 11 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '11'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 13 THEN
    RAISE EXCEPTION 'Se esperaban 13 puntos de (varias) en Cádiz, hay %', n;
  END IF;
END;
$$;

COMMIT;

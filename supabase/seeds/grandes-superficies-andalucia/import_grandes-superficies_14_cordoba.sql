-- Carga de la categoría (varias) de Córdoba (provincia 14), trozo de la carga de Andalucía.
-- Origen: grandes-superficies-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 16 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12319010840', 'Carrefour Córdoba – Calle Deanes', NULL, '14021', 'Calle Deanes 5', NULL, 37.88005, -4.78108, 'address', 'openstreetmap:node/12319010840'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12570978904', 'Carrefour Córdoba – Calle Jesús y María', NULL, '14021', 'Calle Jesús y María', NULL, 37.88397, -4.77996, 'address', 'openstreetmap:node/12570978904'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:node-13099130976', 'El Corte Inglés Córdoba – Avenida Ronda de los Tejares', NULL, '14021', 'Avenida Ronda de los Tejares', NULL, 37.88769, -4.7829, 'address', 'openstreetmap:node/13099130976'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-443924559', 'Carrefour Córdoba – Calle Margarita Xirgú', NULL, '14021', 'Calle Margarita Xirgú', '14011', 37.8961, -4.79164, 'address', 'openstreetmap:node/443924559'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-5537552710', 'Carrefour Córdoba – Calle del Doctor Ruiz Maya', NULL, '14021', 'Calle del Doctor Ruiz Maya', NULL, 37.87805, -4.78905, 'address', 'openstreetmap:node/5537552710'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-6272823325', 'Carrefour Córdoba – Calle San Fernando', NULL, '14021', 'Calle San Fernando', NULL, 37.88017, -4.77554, 'address', 'openstreetmap:node/6272823325'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-6282728257', 'Carrefour Córdoba – Calle Pedro López', NULL, '14021', 'Calle Pedro López', NULL, 37.88428, -4.77541, 'address', 'openstreetmap:node/6282728257'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-9984065361', 'MediaMarkt Córdoba – Los Patios de Azahara', NULL, '14021', 'Los Patios de Azahara', NULL, 37.8765, -4.83777, 'address', 'openstreetmap:node/9984065361'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:way-180105552', 'El Corte Inglés Córdoba – Carretera Santa María de Trassierra', NULL, '14021', 'Carretera Santa María de Trassierra', NULL, 37.89454, -4.80872, 'address', 'openstreetmap:way/180105552'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-194515289', 'Carrefour Puente Genil – Calle Mimosa', NULL, '14056', 'Calle Mimosa', NULL, 37.39772, -4.7629, 'address', 'openstreetmap:way/194515289'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-194515292', 'Decathlon Puente Genil – Calle Montalbán', NULL, '14056', 'Calle Montalbán', NULL, 37.3972, -4.7658, 'address', 'openstreetmap:way/194515292'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-232568735', 'Carrefour Baena – Calle Hazas del Relos', NULL, '14007', 'Calle Hazas del Relos', NULL, 37.62158, -4.30836, 'address', 'openstreetmap:way/232568735'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-409525276', 'Decathlon Córdoba – Calle Compositor Bellini', NULL, '14021', 'Calle Compositor Bellini', NULL, 37.87567, -4.83417, 'address', 'openstreetmap:way/409525276'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-409525565', 'Leroy Merlin Córdoba – Carretera de Palma del Río', NULL, '14021', 'Carretera de Palma del Río', NULL, 37.8772, -4.83548, 'address', 'openstreetmap:way/409525565'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-689291057', 'Carrefour Lucena – Calle Elena Castrillo Castrillo', NULL, '14038', 'Calle Elena Castrillo Castrillo', NULL, 37.41536, -4.50684, 'address', 'openstreetmap:way/689291057'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-97090768', 'Carrefour Córdoba – Calle Oro', NULL, '14021', 'Calle Oro', NULL, 37.8935, -4.74775, 'address', 'openstreetmap:way/97090768');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '14');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 14 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '14'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 16 THEN
    RAISE EXCEPTION 'Se esperaban 16 puntos de (varias) en Córdoba, hay %', n;
  END IF;
END;
$$;

COMMIT;

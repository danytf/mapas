-- Carga de la categoría (varias) de Almería (provincia 04), trozo de la carga de Andalucía.
-- Origen: grandes-superficies-andalucia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-17T20:20:51Z).
-- 22 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-10068320480', 'Carrefour Níjar – Calle Isabel la Católica Norte', NULL, '04066', 'Calle Isabel la Católica Norte', NULL, 36.93848, -2.13427, 'address', 'openstreetmap:node/10068320480'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:node-10273465532', 'Decathlon Huércal de Almería – Calle Rosita', NULL, '04052', 'Calle Rosita', NULL, 36.86737, -2.44449, 'address', 'openstreetmap:node/10273465532'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-10650339601', 'Carrefour Pulpí – Avenida de Europa', NULL, '04075', 'Avenida de Europa', NULL, 37.34577, -1.68645, 'address', 'openstreetmap:node/10650339601'),
  ('IKEA', 'catalogo-andalucia:grandes-superficies:node-11302523083', 'IKEA Almería', NULL, '04013', NULL, NULL, 36.85395, -2.46888, 'address', 'openstreetmap:node/11302523083'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-11500755788', 'Carrefour Mojácar – Paraje Los Gurullos', NULL, '04064', 'Paraje Los Gurullos', '04638', 37.13854, -1.84004, 'address', 'openstreetmap:node/11500755788'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-11584554540', 'Carrefour Almería – Avenida Cabo de Gata', NULL, '04013', 'Avenida Cabo de Gata 86', '04007', 36.83063, -2.45469, 'address', 'openstreetmap:node/11584554540'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-12424528546', 'Carrefour Pulpí – Calle Columbia', NULL, '04075', 'Calle Columbia', NULL, 37.36079, -1.66392, 'address', 'openstreetmap:node/12424528546'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2094641454', 'Carrefour Roquetas de Mar – Carretera de Alicún', NULL, '04079', 'Carretera de Alicún', NULL, 36.77434, -2.61441, 'address', 'openstreetmap:node/2094641454'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2095205508', 'Carrefour Roquetas de Mar – Carretera de Alicún', NULL, '04079', 'Carretera de Alicún', NULL, 36.77038, -2.61291, 'address', 'openstreetmap:node/2095205508'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2574272149', 'Carrefour El Ejido', NULL, '04902', NULL, NULL, 36.75198, -2.80579, 'address', 'openstreetmap:node/2574272149'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:node-2665197234', 'Leroy Merlin Roquetas de Mar – Carretera de Alicún', NULL, '04079', 'Carretera de Alicún', '04740', 36.77542, -2.61319, 'address', 'openstreetmap:node/2665197234'),
  ('El Corte Inglés', 'catalogo-andalucia:grandes-superficies:node-2688074907', 'El Corte Inglés El Ejido – Paseo de Pedro Ponce', NULL, '04902', 'Paseo de Pedro Ponce', NULL, 36.77287, -2.80567, 'address', 'openstreetmap:node/2688074907'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-2757383494', 'Carrefour Almería – Avenida Federico García Lorca', NULL, '04013', 'Avenida Federico García Lorca 8', '04004', 36.83564, -2.46163, 'address', 'openstreetmap:node/2757383494'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-3421390872', 'Carrefour Almería – Paseo de Almería', NULL, '04013', 'Paseo de Almería', '04003', 36.84018, -2.46379, 'address', 'openstreetmap:node/3421390872'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-4141416067', 'MediaMarkt Roquetas de Mar – Carretera de Alicún', NULL, '04079', 'Carretera de Alicún', NULL, 36.77306, -2.61293, 'address', 'openstreetmap:node/4141416067'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-4639367190', 'Carrefour Adra – Autovía del Mediterráneo', NULL, '04003', 'Autovía del Mediterráneo 391', '04770', 36.76488, -2.9856, 'address', 'openstreetmap:node/4639367190'),
  ('MediaMarkt', 'catalogo-andalucia:grandes-superficies:node-6333465856', 'MediaMarkt Almería – Calle Ciudad de Buenos Aires', NULL, '04013', 'Calle Ciudad de Buenos Aires', NULL, 36.86069, -2.43459, 'address', 'openstreetmap:node/6333465856'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:node-8975075236', 'Carrefour Oria – Calle Calvario', NULL, '04070', 'Calle Calvario', NULL, 37.48528, -2.28792, 'address', 'openstreetmap:node/8975075236'),
  ('Leroy Merlin', 'catalogo-andalucia:grandes-superficies:way-1556714727', 'Leroy Merlin Almería – Calle Arquitecto Luis Pastor', NULL, '04013', 'Calle Arquitecto Luis Pastor', NULL, 36.86033, -2.43635, 'address', 'openstreetmap:way/1556714727'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-198458093', 'Carrefour Almería – Avenida Nuestra Señora de Montserrat', NULL, '04013', 'Avenida Nuestra Señora de Montserrat', NULL, 36.84133, -2.44379, 'address', 'openstreetmap:way/198458093'),
  ('Carrefour', 'catalogo-andalucia:grandes-superficies:way-261091899', 'Carrefour Vícar', NULL, '04102', NULL, NULL, 36.81658, -2.60164, 'address', 'openstreetmap:way/261091899'),
  ('Decathlon', 'catalogo-andalucia:grandes-superficies:way-261092139', 'Decathlon Vícar – 12', NULL, '04102', '12', NULL, 36.81712, -2.60095, 'address', 'openstreetmap:way/261092139');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '04');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 04 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '04'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 22 THEN
    RAISE EXCEPTION 'Se esperaban 22 puntos de (varias) en Almería, hay %', n;
  END IF;
END;
$$;

COMMIT;

-- Carga de la categoría (varias) de Badajoz (provincia 06), trozo de la carga de Andalucía.
-- Origen: extremadura-grandes-superficies-extremadura.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:38:56Z).
-- 30 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-10293822137', 'Carrefour Zafra', NULL, '06158', NULL, NULL, 38.43392, -6.42181, 'address', 'openstreetmap:node/10293822137'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-10779469832', 'Carrefour Mérida – Avenida Juan Carlos I', NULL, '06083', 'Avenida Juan Carlos I', '06800', 38.92324, -6.32929, 'address', 'openstreetmap:node/10779469832'),
  ('MediaMarkt', 'catalogo-andalucia:extremadura-grandes-superficies:node-11176813261', 'MediaMarkt Badajoz – Calle Santiago Soutillo', NULL, '06015', 'Calle Santiago Soutillo', NULL, 38.88498, -7.02031, 'address', 'openstreetmap:node/11176813261'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-11959908853', 'Carrefour Badajoz – Avenida Pardaleras', NULL, '06015', 'Avenida Pardaleras 4', '06003', 38.87293, -6.97081, 'address', 'openstreetmap:node/11959908853'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-14297389601', 'Carrefour Mérida – Avenida Lusitania', NULL, '06083', 'Avenida Lusitania 15', '06800', 38.91133, -6.33652, 'address', 'openstreetmap:node/14297389601'),
  ('Leroy Merlin', 'catalogo-andalucia:extremadura-grandes-superficies:node-2411991245', 'Leroy Merlin Mérida – Calle Clara Campoamor Rodríguez', NULL, '06083', 'Calle Clara Campoamor Rodríguez', '06800', 38.90676, -6.35107, 'address', 'openstreetmap:node/2411991245'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-431557517', 'Carrefour Mérida – Avenida de Portugal', NULL, '06083', 'Avenida de Portugal', '06800', 38.90584, -6.36118, 'address', 'openstreetmap:node/431557517'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-4393859789', 'Carrefour Mérida – Calle San Salvador', NULL, '06083', 'Calle San Salvador 1', '06800', 38.91651, -6.3478, 'address', 'openstreetmap:node/4393859789'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-5551529611', 'Carrefour Badajoz – Ronda del Pilar', NULL, '06015', 'Ronda del Pilar', '06002', 38.87604, -6.96786, 'address', 'openstreetmap:node/5551529611'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-5551529618', 'Carrefour Badajoz – Avenida Villanueva', NULL, '06015', 'Avenida Villanueva 5', '06005', 38.87205, -6.97682, 'address', 'openstreetmap:node/5551529618'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-5649852803', 'Carrefour Badajoz – Avenida Ricardo Carapeto Zambrano', NULL, '06015', 'Avenida Ricardo Carapeto Zambrano 40', '06008', 38.87908, -6.95968, 'address', 'openstreetmap:node/5649852803'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-5709437866', 'Carrefour Burguillos del Cerro – Calle Luis Noval', NULL, '06022', 'Calle Luis Noval', NULL, 38.38003, -6.59123, 'address', 'openstreetmap:node/5709437866'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-5777176835', 'Carrefour Herrera del Duque – Calle Feria', NULL, '06063', 'Calle Feria', NULL, 39.17098, -5.05282, 'address', 'openstreetmap:node/5777176835'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-6156504929', 'Carrefour Montijo – Calle Arriba', NULL, '06088', 'Calle Arriba', '06480', 38.91036, -6.61685, 'address', 'openstreetmap:node/6156504929'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-6226000143', 'Carrefour Badajoz – Calle Jacobo Rodríguez Pereira', NULL, '06015', 'Calle Jacobo Rodríguez Pereira 21', '06010', 38.86801, -6.97365, 'address', 'openstreetmap:node/6226000143'),
  ('El Corte Inglés', 'catalogo-andalucia:extremadura-grandes-superficies:node-7049581997', 'El Corte Inglés Badajoz – Avenida de Elvas', NULL, '06015', 'Avenida de Elvas', '06002', 38.87756, -6.97221, 'address', 'openstreetmap:node/7049581997'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:node-9981297606', 'Carrefour Badajoz – Calle Francisco Vaca Morales', NULL, '06015', 'Calle Francisco Vaca Morales 6', '06011', 38.86544, -6.98504, 'address', 'openstreetmap:node/9981297606'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:relation-16671170', 'Carrefour Badajoz – Avenida Juan Carlos I', NULL, '06015', 'Avenida Juan Carlos I 16', '06001', 38.87878, -6.97335, 'address', 'openstreetmap:relation/16671170'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:way-1214094049', 'Carrefour Talavera la Real – Calle Salvador Dalí', NULL, '06128', 'Calle Salvador Dalí', NULL, 38.87343, -6.76705, 'address', 'openstreetmap:way/1214094049'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:way-122541982', 'Carrefour Badajoz', NULL, '06015', NULL, NULL, 38.8603, -6.97003, 'address', 'openstreetmap:way/122541982'),
  ('El Corte Inglés', 'catalogo-andalucia:extremadura-grandes-superficies:way-122545841', 'El Corte Inglés Badajoz – Avenida Enrique Segura Otaño', NULL, '06015', 'Avenida Enrique Segura Otaño 2', '06004', 38.87273, -6.97511, 'address', 'openstreetmap:way/122545841'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:way-237543086', 'Carrefour Villanueva de la Serena', NULL, '06153', NULL, NULL, 38.97138, -5.80999, 'address', 'openstreetmap:way/237543086'),
  ('Leroy Merlin', 'catalogo-andalucia:extremadura-grandes-superficies:way-237543096', 'Leroy Merlin Villanueva de la Serena – Calle Camino del Cerro de la Horca', NULL, '06153', 'Calle Camino del Cerro de la Horca', NULL, 38.96872, -5.80805, 'address', 'openstreetmap:way/237543096'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:way-298398346', 'Carrefour Almendralejo – Calle José Barrio Bardón', NULL, '06011', 'Calle José Barrio Bardón', '06200', 38.693, -6.41185, 'address', 'openstreetmap:way/298398346'),
  ('Decathlon', 'catalogo-andalucia:extremadura-grandes-superficies:way-370164724', 'Decathlon Mérida – Calle Almería', NULL, '06083', 'Calle Almería 2', '06800', 38.9214, -6.37396, 'address', 'openstreetmap:way/370164724'),
  ('Decathlon', 'catalogo-andalucia:extremadura-grandes-superficies:way-413840560', 'Decathlon Badajoz – Calle María de Molina', NULL, '06015', 'Calle María de Molina', '06006', 38.88017, -7.01368, 'address', 'openstreetmap:way/413840560'),
  ('Leroy Merlin', 'catalogo-andalucia:extremadura-grandes-superficies:way-413850113', 'Leroy Merlin Badajoz – Calle Nevero Dos', NULL, '06015', 'Calle Nevero Dos', NULL, 38.90268, -6.99742, 'address', 'openstreetmap:way/413850113'),
  ('Decathlon', 'catalogo-andalucia:extremadura-grandes-superficies:way-574182112', 'Decathlon Villanueva de la Serena – Carretera de Don Benito', NULL, '06153', 'Carretera de Don Benito', NULL, 38.9693, -5.8091, 'address', 'openstreetmap:way/574182112'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:way-704304129', 'Carrefour Mérida – CARRETERA N-VA KM.', NULL, '06083', 'CARRETERA N-VA KM. 340', '06800', 38.91514, -6.33188, 'address', 'openstreetmap:way/704304129'),
  ('Carrefour', 'catalogo-andalucia:extremadura-grandes-superficies:way-913987821', 'Carrefour Badajoz – Calle Juan Simeón Vidarte', NULL, '06015', 'Calle Juan Simeón Vidarte', '06011', 38.86696, -6.98911, 'address', 'openstreetmap:way/913987821');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '06');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 06 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '06'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 30 THEN
    RAISE EXCEPTION 'Se esperaban 30 puntos de (varias) en Badajoz, hay %', n;
  END IF;
END;
$$;

COMMIT;

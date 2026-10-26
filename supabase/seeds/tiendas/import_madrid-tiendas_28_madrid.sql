-- Carga de la categoría (varias) de Madrid (provincia 28), trozo de la carga de Andalucía.
-- Origen: madrid-tiendas-madrid.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 32 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-10606501228', 'Tiendanimal Madrid – Calle de Ayacucho', 'Mascotas', '28079', 'Calle de Ayacucho', '28043', 40.46968, -3.63998, 'address', 'openstreetmap:node/10606501228'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-11083618899', 'Tiendanimal Leganés', 'Mascotas', '28074', NULL, '28916', 40.3399, -3.73643, 'address', 'openstreetmap:node/11083618899'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-11099180090', 'Tiendanimal Madrid – Calle de López de Hoyos', 'Mascotas', '28079', 'Calle de López de Hoyos 98', '28002', 40.44331, -3.67509, 'address', 'openstreetmap:node/11099180090'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-11412513798', 'Kiwoko Rivas-Vaciamadrid – Calle de Guillermo Marconi', 'Mascotas', '28123', 'Calle de Guillermo Marconi', NULL, 40.33585, -3.53282, 'address', 'openstreetmap:node/11412513798'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-11663957066', 'Tiendanimal Colmenar Viejo – Avenida de la Tejera', 'Mascotas', '28045', 'Avenida de la Tejera', NULL, 40.65917, -3.75626, 'address', 'openstreetmap:node/11663957066'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-11684501907', 'Tiendanimal Majadahonda – Calle Manzano', 'Mascotas', '28080', 'Calle Manzano', '28220', 40.45466, -3.87407, 'address', 'openstreetmap:node/11684501907'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-11769640549', 'Guaw Madrid – Avenida Pablo Neruda', 'Mascotas', '28079', 'Avenida Pablo Neruda 91', '28018', 40.38093, -3.66216, 'address', 'openstreetmap:node/11769640549'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-11769723780', 'Kiwoko Madrid – Calle de Candilejas', 'Mascotas', '28079', 'Calle de Candilejas', '28018', 40.38167, -3.66379, 'address', 'openstreetmap:node/11769723780'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-11916229192', 'Kiwoko Madrid – Calle de Alcalá', 'Mascotas', '28079', 'Calle de Alcalá 157', '28009', 40.42553, -3.67445, 'address', 'openstreetmap:node/11916229192'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-12707221655', 'Guaw Madrid – Ronda de Atocha', 'Mascotas', '28079', 'Ronda de Atocha 18', '28012', 40.40663, -3.69736, 'address', 'openstreetmap:node/12707221655'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-13039854812', 'Miscota Madrid – Avenida de la Ciudad de Barcelona', 'Mascotas', '28079', 'Avenida de la Ciudad de Barcelona 222', '28007', 40.39884, -3.67056, 'address', 'openstreetmap:node/13039854812'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-3480343599', 'Miscota Madrid – Paseo de las Acacias', 'Mascotas', '28079', 'Paseo de las Acacias 22', '28005', 40.40388, -3.70717, 'address', 'openstreetmap:node/3480343599'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-4621851030', 'Kiwoko Madrid – Calle de Arrastaria', 'Mascotas', '28079', 'Calle de Arrastaria', '28022', 40.447, -3.58678, 'address', 'openstreetmap:node/4621851030'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-4711200891', 'Kiwoko Madrid – Avenida de los Toreros', 'Mascotas', '28079', 'Avenida de los Toreros 27', '28028', 40.43196, -3.66892, 'address', 'openstreetmap:node/4711200891'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-4798634324', 'Guaw Majadahonda – Calle Ciruela', 'Mascotas', '28080', 'Calle Ciruela 22', '28222', 40.45347, -3.87133, 'address', 'openstreetmap:node/4798634324'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-4943762121', 'Tiendanimal.com Alcalá de Henares – Calle de Humanes', 'Mascotas', '28005', 'Calle de Humanes 1', '28805', 40.50511, -3.32743, 'address', 'openstreetmap:node/4943762121'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-4966795021', 'Kiwoko Pozuelo de Alarcón – Calle de Guadalupe Muñoz Sampedro', 'Mascotas', '28115', 'Calle de Guadalupe Muñoz Sampedro', NULL, 40.39761, -3.78365, 'address', 'openstreetmap:node/4966795021'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-5139727727', 'Guaw Fuenlabrada – Calle de la Comunidad de Madrid', 'Mascotas', '28058', 'Calle de la Comunidad de Madrid 15', '28944', 40.27829, -3.7965, 'address', 'openstreetmap:node/5139727727'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-5576464140', 'TiendAnimal Majadahonda – Calle de los Matemáticos', 'Mascotas', '28080', 'Calle de los Matemáticos', '28220', 40.48869, -3.89767, 'address', 'openstreetmap:node/5576464140'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-6022985786', 'Guaw Madrid – Paseo de Santa María de la Cabeza', 'Mascotas', '28079', 'Paseo de Santa María de la Cabeza 75', '28045', 40.39842, -3.70138, 'address', 'openstreetmap:node/6022985786'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-6222199606', 'Kiwoko Torrejón de Ardoz', 'Mascotas', '28148', NULL, NULL, 40.47628, -3.47945, 'address', 'openstreetmap:node/6222199606'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-6277497644', 'Tiendanimal Rivas-Vaciamadrid – Calle del Torno', 'Mascotas', '28123', 'Calle del Torno 35', '28522', 40.3514, -3.54053, 'address', 'openstreetmap:node/6277497644'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-6572922161', 'TiendAnimal Torrejón de Ardoz – Avenida de la Constitución', 'Mascotas', '28148', 'Avenida de la Constitución 102', '28850', 40.45731, -3.46955, 'address', 'openstreetmap:node/6572922161'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-7090930475', 'Tiendanimal Madrid – Calle de Navaridas', 'Mascotas', '28079', 'Calle de Navaridas 9', '28022', 40.44457, -3.58115, 'address', 'openstreetmap:node/7090930475'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-9350656024', 'Kiwoko Torrejón de Ardoz', 'Mascotas', '28148', NULL, NULL, 40.47279, -3.44272, 'address', 'openstreetmap:node/9350656024'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-9529907828', 'Kiwoko Madrid – Calle de Bravo Murillo', 'Mascotas', '28079', 'Calle de Bravo Murillo 194', '28020', 40.45521, -3.70242, 'address', 'openstreetmap:node/9529907828'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:node-9984613371', 'Kiwoko Coslada – Avenida de José Gárate', 'Mascotas', '28049', 'Avenida de José Gárate', '28823', 40.42826, -3.55176, 'address', 'openstreetmap:node/9984613371'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:way-1074630676', 'Tiendanimal Rivas-Vaciamadrid – Calle de Thomas Edison', 'Mascotas', '28123', 'Calle de Thomas Edison', NULL, 40.33505, -3.52654, 'address', 'openstreetmap:way/1074630676'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:way-193617661', 'Kiwoko Alcorcón – Avenida de Europa', 'Mascotas', '28007', 'Avenida de Europa', NULL, 40.3491, -3.85047, 'address', 'openstreetmap:way/193617661'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:way-209683354', 'Kiwoko San Fernando de Henares', 'Mascotas', '28130', NULL, NULL, 40.44666, -3.52341, 'address', 'openstreetmap:way/209683354'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:way-446717747', 'Kiwoko Leganés – Calle de la Medicina', 'Mascotas', '28074', 'Calle de la Medicina', '28918', 40.34331, -3.75972, 'address', 'openstreetmap:way/446717747'),
  ('Tiendas', 'catalogo-madrid:madrid-tiendas:way-503622637', 'Kiwoko Alcalá de Henares – Calle la Vega de Henares', 'Mascotas', '28005', 'Calle la Vega de Henares', '28805', 40.50492, -3.32948, 'address', 'openstreetmap:way/503622637');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '28');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 28 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '28'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 32 THEN
    RAISE EXCEPTION 'Se esperaban 32 puntos de (varias) en Madrid, hay %', n;
  END IF;
END;
$$;

COMMIT;

-- Carga de la categoría (varias) de Salamanca (provincia 37), trozo de la carga de Andalucía.
-- Origen: castilla-y-leon-grandes-superficies-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 23 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-1434900841', 'Carrefour Salamanca – Calle Toro', NULL, '37274', 'Calle Toro 82', '37002', 40.96815, -5.66075, 'address', 'openstreetmap:node/1434900841'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-1561093663', 'Carrefour Salamanca – Paseo de la Estación 118,120', NULL, '37274', 'Paseo de la Estación 118,120', '37004', 40.97185, -5.64963, 'address', 'openstreetmap:node/1561093663'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-2162880322', 'Carrefour Salamanca – Calle Gran Vía', NULL, '37274', 'Calle Gran Vía 50', '37001', 40.96392, -5.66152, 'address', 'openstreetmap:node/2162880322'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-2270029542', 'Carrefour Fuentes de Oñoro – Avenida de Europa', NULL, '37140', 'Avenida de Europa 43', '37480', 40.60354, -6.81993, 'address', 'openstreetmap:node/2270029542'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-2779249026', 'Carrefour Salamanca – Calle Rúa Mayor 35,37', NULL, '37274', 'Calle Rúa Mayor 35,37', '37001', 40.96271, -5.66545, 'address', 'openstreetmap:node/2779249026'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-2779249043', 'Carrefour Salamanca – Avenida de Portugal', NULL, '37274', 'Avenida de Portugal 117', '37006', 40.97246, -5.66387, 'address', 'openstreetmap:node/2779249043'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-3255508217', 'Carrefour Salamanca – Paseo de Carmelitas', NULL, '37274', 'Paseo de Carmelitas 11', '37002', 40.96957, -5.66467, 'address', 'openstreetmap:node/3255508217'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-3600022741', 'Carrefour Salamanca – Calle de María Auxiliadora', NULL, '37274', 'Calle de María Auxiliadora 25', '37005', 40.97001, -5.65902, 'address', 'openstreetmap:node/3600022741'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-3891671458', 'Carrefour Cabrerizos – Ronda de las Eras', NULL, '37067', 'Ronda de las Eras 23', '37193', 40.97933, -5.60857, 'address', 'openstreetmap:node/3891671458'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-4613213606', 'Carrefour Salamanca – Avenida de los Comuneros', NULL, '37274', 'Avenida de los Comuneros 6', '37003', 40.9685, -5.65332, 'address', 'openstreetmap:node/4613213606'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-4883365731', 'Carrefour Vitigudino – Calle Pedro Velasco', NULL, '37376', 'Calle Pedro Velasco 49', '37210', 41.00936, -6.43135, 'address', 'openstreetmap:node/4883365731'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-6228170474', 'Carrefour Carbajosa de la Sagrada – Calle Rafael', NULL, '37085', 'Calle Rafael 20', '37188', 40.93538, -5.6478, 'address', 'openstreetmap:node/6228170474'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-6379676959', 'Carrefour Carbajosa de la Sagrada – Avenida de Carbajosa', NULL, '37085', 'Avenida de Carbajosa 33', '37188', 40.94721, -5.65701, 'address', 'openstreetmap:node/6379676959'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-6562786425', 'Carrefour Salamanca – Avenida de Alfonso VI', NULL, '37274', 'Avenida de Alfonso VI 15', '37005', 40.97571, -5.66048, 'address', 'openstreetmap:node/6562786425'),
  ('IKEA', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-7059883736', 'IKEA Santa Marta de Tormes – Avenida de Salamanca', NULL, '37294', 'Avenida de Salamanca', '37900', 40.95056, -5.64949, 'address', 'openstreetmap:node/7059883736'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-7069393930', 'Carrefour Salamanca – Paseo de Canalejas', NULL, '37274', 'Paseo de Canalejas 84', '37001', 40.9645, -5.65836, 'address', 'openstreetmap:node/7069393930'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:node-9950616417', 'Carrefour Salamanca – Avenida Filiberto Villalobos', NULL, '37274', 'Avenida Filiberto Villalobos 71', '37007', 40.97027, -5.67459, 'address', 'openstreetmap:node/9950616417'),
  ('Leroy Merlin', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-163019641', 'Leroy Merlin Santa Marta de Tormes – Calle Virgen de la Macarena', NULL, '37294', 'Calle Virgen de la Macarena', NULL, 40.94925, -5.65205, 'address', 'openstreetmap:way/163019641'),
  ('MediaMarkt', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-163019645', 'MediaMarkt Santa Marta de Tormes – Calle Virgen del Amparo', NULL, '37294', 'Calle Virgen del Amparo', NULL, 40.9481, -5.64991, 'address', 'openstreetmap:way/163019645'),
  ('El Corte Inglés', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-42893733', 'El Corte Inglés Salamanca – Calle de María Auxiliadora 71,85', NULL, '37274', 'Calle de María Auxiliadora 71,85', '37005', 40.97372, -5.65739, 'address', 'openstreetmap:way/42893733'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-44309588', 'Carrefour Salamanca – Avenida Agustinos Recoletos', NULL, '37274', 'Avenida Agustinos Recoletos 1', '37005', 40.9804, -5.66447, 'address', 'openstreetmap:way/44309588'),
  ('Carrefour', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-484431950', 'Carrefour Pedrosillo el Ralo – Pedrosillo el Ralo a SA-804 por Gomecello', NULL, '37238', 'Pedrosillo el Ralo a SA-804 por Gomecello', NULL, 41.05499, -5.54342, 'address', 'openstreetmap:way/484431950'),
  ('Decathlon', 'catalogo-castilla-y-leon:castilla-y-leon-grandes-superficies:way-59010514', 'Decathlon Carbajosa de la Sagrada – Avenida E. Leclerc', NULL, '37085', 'Avenida E. Leclerc 3', '37188', 40.94619, -5.64101, 'address', 'openstreetmap:way/59010514');

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
  IF n <> 23 THEN
    RAISE EXCEPTION 'Se esperaban 23 puntos de (varias) en Salamanca, hay %', n;
  END IF;
END;
$$;

COMMIT;

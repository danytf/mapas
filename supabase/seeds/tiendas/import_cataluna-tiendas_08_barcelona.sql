-- Carga de la categoría (varias) de Barcelona (provincia 08), trozo de la carga de Andalucía.
-- Origen: cataluna-tiendas-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 20 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-10175872733', 'miscota Barcelona – Carrer de Còrsega', 'Mascotas', '08019', 'Carrer de Còrsega', '08037', 41.39992, 2.16362, 'address', 'openstreetmap:node/10175872733'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-10712988030', 'Kiwoko Sant Pere de Ribes – Rambla del Garraf', 'Mascotas', '08231', 'Rambla del Garraf', '08812', 41.23731, 1.75308, 'address', 'openstreetmap:node/10712988030'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-10717604466', 'Kiwoko Gavà – Carrer del Progrès', 'Mascotas', '08089', 'Carrer del Progrès 69', '08850', 41.29504, 2.0075, 'address', 'openstreetmap:node/10717604466'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-11265524734', 'Kiwoko Barcelona – Avinguda Diagonal', 'Mascotas', '08019', 'Avinguda Diagonal', '08019', 41.40993, 2.21523, 'address', 'openstreetmap:node/11265524734'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-11695517341', 'Kiwoko Vic – Carretera de Sant Hipòlit de Voltregà 61A', 'Mascotas', '08298', 'Carretera de Sant Hipòlit de Voltregà 61A', '08500', 41.94356, 2.25263, 'address', 'openstreetmap:node/11695517341'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-14166622614', 'Tiendanimal Sabadell – Centre Comercial Via Sabadell', 'Mascotas', '08187', 'Centre Comercial Via Sabadell', '08205', 41.51232, 2.10686, 'address', 'openstreetmap:node/14166622614'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-3048083033', 'Kiwoko Barcelona – Rambla del Poblenou', 'Mascotas', '08019', 'Rambla del Poblenou 50', '08005', 41.40022, 2.20259, 'address', 'openstreetmap:node/3048083033'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-4487196269', 'Tiendanimal Sant Feliu de Llobregat – Carretera de Laureà Miró 369-363', 'Mascotas', '08211', 'Carretera de Laureà Miró 369-363', '08980', 41.38709, 2.04026, 'address', 'openstreetmap:node/4487196269'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-5864094593', 'miscota Barcelona – Carrer del Consell de Cent', 'Mascotas', '08019', 'Carrer del Consell de Cent 375', '08009', 41.39363, 2.16885, 'address', 'openstreetmap:node/5864094593'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-7011813146', 'Tiendanimal Lliçà d''Amunt', 'Mascotas', '08107', NULL, '08186', 41.60422, 2.25935, 'address', 'openstreetmap:node/7011813146'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-8806371425', 'Miscota Barcelona – Carrer de Balmes', 'Mascotas', '08019', 'Carrer de Balmes 65', '08008', 41.39013, 2.16134, 'address', 'openstreetmap:node/8806371425'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-8806371426', 'Miscota Barcelona – Carrer de Balmes', 'Mascotas', '08019', 'Carrer de Balmes 177', '08006', 41.39633, 2.15323, 'address', 'openstreetmap:node/8806371426'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-8939342340', 'Kiwoko Barcelona – Carrer d''Aribau 21-21B', 'Mascotas', '08019', 'Carrer d''Aribau 21-21B', '08011', 41.38685, 2.16121, 'address', 'openstreetmap:node/8939342340'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-9938081184', 'Kiwoko Sant Boi de Llobregat – Carrer dels Hortells 6-8', 'Mascotas', '08200', 'Carrer dels Hortells 6-8', '08830', 41.32818, 2.04748, 'address', 'openstreetmap:node/9938081184'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:node-9938081185', 'tiendanimal Sant Boi de Llobregat – Carrer de les Alberedes', 'Mascotas', '08200', 'Carrer de les Alberedes 17', '08830', 41.32866, 2.04762, 'address', 'openstreetmap:node/9938081185'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:way-1091779666', 'Kiwoko Terrassa – Av. del Vallès', 'Mascotas', '08279', 'Av. del Vallès 484', '08227', 41.56267, 2.03482, 'address', 'openstreetmap:way/1091779666'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:way-1119486440', 'Tiendanimal Vilanova i la Geltrú – Carrer de l''Acer', 'Mascotas', '08307', 'Carrer de l''Acer', '08800', 41.23776, 1.72891, 'address', 'openstreetmap:way/1119486440'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:way-1526542578', 'Kiwoko el Prat de Llobregat', 'Mascotas', '08169', NULL, '08940', 41.34757, 2.07693, 'address', 'openstreetmap:way/1526542578'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:way-198136795', 'Tiendanimal Mataró – RD PAISOS CATALANS', 'Mascotas', '08121', 'RD PAISOS CATALANS 15', '08304', 41.55393, 2.43739, 'address', 'openstreetmap:way/198136795'),
  ('Tiendas', 'catalogo-cataluna:cataluna-tiendas:way-651587083', 'Tiendanimal Esplugues de Llobregat – Carrer de Sant Mateu', 'Mascotas', '08077', 'Carrer de Sant Mateu 9', '08950', 41.37689, 2.09842, 'address', 'openstreetmap:way/651587083');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '08');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 08 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '08'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 20 THEN
    RAISE EXCEPTION 'Se esperaban 20 puntos de (varias) en Barcelona, hay %', n;
  END IF;
END;
$$;

COMMIT;

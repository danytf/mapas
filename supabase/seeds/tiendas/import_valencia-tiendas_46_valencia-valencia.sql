-- Carga de la categoría (varias) de Valencia/València (provincia 46), trozo de la carga de Andalucía.
-- Origen: valencia-tiendas-valencia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 17 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-12090071839', 'miscota València – Carrer del Pare Urbà', 'Mascotas', '46250', 'Carrer del Pare Urbà 6', '46009', 39.489, -0.37488, 'address', 'openstreetmap:node/12090071839'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-12227868242', 'Miscota Xàtiva – Vicent Boix', 'Mascotas', '46145', 'Vicent Boix 1', '46800', 38.99085, -0.52389, 'address', 'openstreetmap:node/12227868242'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-12311508926', 'Kiwoko València – Carrer del Comte de Salvatierra', 'Mascotas', '46250', 'Carrer del Comte de Salvatierra 9', '46004', 39.47093, -0.36893, 'address', 'openstreetmap:node/12311508926'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-12702279971', 'Kiwoko Xàtiva – Carrer Braçal de les Dones', 'Mascotas', '46145', 'Carrer Braçal de les Dones', NULL, 38.99553, -0.52853, 'address', 'openstreetmap:node/12702279971'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-13078295325', 'miscota València – Avinguda de França', 'Mascotas', '46250', 'Avinguda de França 67', '46023', 39.45823, -0.34396, 'address', 'openstreetmap:node/13078295325'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-13207667301', 'Miscota Mislata – Avinguda de Gregorio Gea', 'Mascotas', '46169', 'Avinguda de Gregorio Gea 33', '46920', 39.47364, -0.41652, 'address', 'openstreetmap:node/13207667301'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-13752111961', 'GUAW Tavernes de la Valldigna – Avinguda de la Valldigna', 'Mascotas', '46238', 'Avinguda de la Valldigna 80', '46760', 39.06924, -0.27391, 'address', 'openstreetmap:node/13752111961'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-2000312986', 'Kiwoko la Pobla de Vallbona – Carrer d''Ada Lovelace', 'Mascotas', '46202', 'Carrer d''Ada Lovelace', NULL, 39.57908, -0.53305, 'address', 'openstreetmap:node/2000312986'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-3764626450', 'Kiwoko Burjassot – Avenida de la Ilustración', 'Mascotas', '46078', 'Avenida de la Ilustración 6', '46100', 39.49917, -0.4087, 'address', 'openstreetmap:node/3764626450'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-8085905739', 'Tiendanimal Alfafar – Avinguda dels Reis Catòlics', 'Mascotas', '46022', 'Avinguda dels Reis Catòlics', NULL, 39.4181, -0.3787, 'address', 'openstreetmap:node/8085905739'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-9071378142', 'Miscota Alaquàs – Avinguda Dos de Maig', 'Mascotas', '46005', 'Avinguda Dos de Maig 9', '46970', 39.45883, -0.46335, 'address', 'openstreetmap:node/9071378142'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-9137820813', 'Kiwoko Massalfassar', 'Mascotas', '46163', NULL, NULL, 39.55335, -0.30259, 'address', 'openstreetmap:node/9137820813'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-9514441561', 'Miscota Burjassot – Carretera de Llíria', 'Mascotas', '46078', 'Carretera de Llíria 20', '46100', 39.50892, -0.41303, 'address', 'openstreetmap:node/9514441561'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:way-1233828234', 'Miscota Massanassa – Avenida de la Generalitat Valenciana', 'Mascotas', '46165', 'Avenida de la Generalitat Valenciana 18', '46470', 39.41259, -0.38675, 'address', 'openstreetmap:way/1233828234'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:way-150282521', 'Tiendanimal Burjassot – Camí Vell de Beniferri', 'Mascotas', '46078', 'Camí Vell de Beniferri', '46100', 39.50077, -0.40443, 'address', 'openstreetmap:way/150282521'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:way-677106132', 'Kiwoko Aldaia – Avinguda de les Comarques del País Valencià', 'Mascotas', '46021', 'Avinguda de les Comarques del País Valencià', NULL, 39.47361, -0.48532, 'address', 'openstreetmap:way/677106132'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:way-999510877', 'Tiendanimal Sagunt / Sagunto – Avinguda de les Moreries', 'Mascotas', '46220', 'Avinguda de les Moreries', NULL, 39.67278, -0.2638, 'address', 'openstreetmap:way/999510877');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '46');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 46 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '46'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 17 THEN
    RAISE EXCEPTION 'Se esperaban 17 puntos de (varias) en Valencia/València, hay %', n;
  END IF;
END;
$$;

COMMIT;

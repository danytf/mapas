-- Carga de la categoría (varias) de Castellón/Castelló (provincia 12), trozo de la carga de Andalucía.
-- Origen: valencia-grandes-superficies-valencia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 17 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:node-10005194774', 'MediaMarkt Vinaròs – Carrer dels Cordellers', NULL, '12138', 'Carrer dels Cordellers', '12500', 40.45545, 0.45078, 'address', 'openstreetmap:node/10005194774'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-10245252429', 'Carrefour Vinaròs – Carrer dels Cerers', NULL, '12138', 'Carrer dels Cerers', NULL, 40.45368, 0.45122, 'address', 'openstreetmap:node/10245252429'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-10693547202', 'Carrefour Castelló de la Plana / Castellón de la Plana – Carrer de José María Guinot Galán', NULL, '12040', 'Carrer de José María Guinot Galán', NULL, 39.98408, -0.01913, 'address', 'openstreetmap:node/10693547202'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-13516582353', 'Carrefour Nules – CARRETERA N-340 KM.', NULL, '12082', 'CARRETERA N-340 KM. 957', NULL, 39.85774, -0.15088, 'address', 'openstreetmap:node/13516582353'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-3101838115', 'Carrefour Castelló de la Plana / Castellón de la Plana – Carrer Major', NULL, '12040', 'Carrer Major', '12001', 39.9858, -0.03629, 'address', 'openstreetmap:node/3101838115'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-321384712', 'Carrefour Castelló de la Plana / Castellón de la Plana – Carrer de Beatriz Guttmann Goldberger', NULL, '12040', 'Carrer de Beatriz Guttmann Goldberger 1', '12004', 39.99189, -0.03066, 'address', 'openstreetmap:node/321384712'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-1013295069', 'Carrefour Castelló de la Plana / Castellón de la Plana – Avinguda de Ribesalbes', NULL, '12040', 'Avinguda de Ribesalbes', NULL, 39.97926, -0.06808, 'address', 'openstreetmap:way/1013295069'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-1149494549', 'Carrefour Castelló de la Plana / Castellón de la Plana – Carrer de Torralba del Pinar', NULL, '12040', 'Carrer de Torralba del Pinar', NULL, 39.98187, -0.0186, 'address', 'openstreetmap:way/1149494549'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-1271816836', 'Leroy Merlin Castelló de la Plana / Castellón de la Plana', NULL, '12040', NULL, '12006', 39.97421, -0.06289, 'address', 'openstreetmap:way/1271816836'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-21901476', 'Carrefour Vila-real – Carrer Bárbara Royo', NULL, '12135', 'Carrer Bárbara Royo', NULL, 39.92844, -0.10405, 'address', 'openstreetmap:way/21901476'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:way-22193315', 'El Corte Inglés Castelló de la Plana / Castellón de la Plana – Plaça d''Espanya', NULL, '12040', 'Plaça d''Espanya', '12002', 39.98782, -0.04788, 'address', 'openstreetmap:way/22193315'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-572892685', 'Decathlon Vinaròs – Carrer dels Dauradors', NULL, '12138', 'Carrer dels Dauradors', '12500', 40.45521, 0.45297, 'address', 'openstreetmap:way/572892685'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-639141486', 'Decathlon Onda – Carretera d''Onda', NULL, '12084', 'Carretera d''Onda', NULL, 39.949, -0.17469, 'address', 'openstreetmap:way/639141486'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-779135634', 'Decathlon Castelló de la Plana / Castellón de la Plana – Avinguda d''Europa', NULL, '12040', 'Avinguda d''Europa', NULL, 39.9755, -0.0714, 'address', 'openstreetmap:way/779135634'),
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:way-779135635', 'MediaMarkt Castelló de la Plana / Castellón de la Plana – Avinguda d''Europa', NULL, '12040', 'Avinguda d''Europa', NULL, 39.97751, -0.06943, 'address', 'openstreetmap:way/779135635'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:way-779135882', 'El Corte Inglés Castelló de la Plana / Castellón de la Plana – Carrer de França', NULL, '12040', 'Carrer de França', NULL, 39.97428, -0.07129, 'address', 'openstreetmap:way/779135882'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-982266416', 'Leroy Merlin Vinaròs – Carrer dels Artesans', NULL, '12138', 'Carrer dels Artesans', NULL, 40.45586, 0.45388, 'address', 'openstreetmap:way/982266416');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '12');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 12 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '12'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 17 THEN
    RAISE EXCEPTION 'Se esperaban 17 puntos de (varias) en Castellón/Castelló, hay %', n;
  END IF;
END;
$$;

COMMIT;

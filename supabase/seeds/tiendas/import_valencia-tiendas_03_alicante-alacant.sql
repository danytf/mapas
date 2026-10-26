-- Carga de la categoría (varias) de Alicante/Alacant (provincia 03), trozo de la carga de Andalucía.
-- Origen: valencia-tiendas-valencia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 11 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-10665631795', 'Tiendanimal Orihuela', 'Mascotas', '03099', NULL, NULL, 37.93128, -0.73656, 'address', 'openstreetmap:node/10665631795'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-11212553134', 'Kiwoko Elx / Elche – Avenida de Crevillente', 'Mascotas', '03065', 'Avenida de Crevillente 29', '03205', 38.25908, -0.72599, 'address', 'openstreetmap:node/11212553134'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-13946112727', 'Tiendanimal Torrevieja – Rosa Mazón Valero', 'Mascotas', '03133', 'Rosa Mazón Valero 7', '03184', 37.99023, -0.68666, 'address', 'openstreetmap:node/13946112727'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-3738705237', 'Kiwoko Finestrat – Carrer Alacant', 'Mascotas', '03069', 'Carrer Alacant', '03509', 38.53993, -0.17613, 'address', 'openstreetmap:node/3738705237'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-5255490559', 'Kiwoko Torrevieja – Calle Joaquín García Sánchez', 'Mascotas', '03133', 'Calle Joaquín García Sánchez', '03184', 37.99532, -0.68872, 'address', 'openstreetmap:node/5255490559'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-7892394715', 'Tiendanimal - Alicante Alacant / Alicante – Carrer de Benidoleig', 'Mascotas', '03014', 'Carrer de Benidoleig', '03112', 38.37532, -0.50614, 'address', 'openstreetmap:node/7892394715'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:node-8958319954', 'Miscota Calp – Malta', 'Mascotas', '03047', 'Malta', '03710', 38.64462, 0.05496, 'address', 'openstreetmap:node/8958319954'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:way-192948971', 'Miscota Ondara – Avinguda Costa Blanca', 'Mascotas', '03095', 'Avinguda Costa Blanca 4', '03760', 38.81686, 0.02042, 'address', 'openstreetmap:way/192948971'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:way-653711747', 'Tiendanimal Finestrat – Avinguda Federico Garcia Lorca', 'Mascotas', '03069', 'Avinguda Federico Garcia Lorca 20', '03509', 38.53945, -0.17302, 'address', 'openstreetmap:way/653711747'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:way-676746819', 'Kiwoko Sant Joan d''Alacant – Avinguda de Miguel Hernández', 'Mascotas', '03119', 'Avinguda de Miguel Hernández', NULL, 38.40669, -0.4254, 'address', 'openstreetmap:way/676746819'),
  ('Tiendas', 'catalogo-valencia:valencia-tiendas:way-717626190', 'Kiwoko Ondara – Carrer Castell de Castells', 'Mascotas', '03095', 'Carrer Castell de Castells', '03760', 38.81716, 0.01988, 'address', 'openstreetmap:way/717626190');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '03');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 03 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '03'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 11 THEN
    RAISE EXCEPTION 'Se esperaban 11 puntos de (varias) en Alicante/Alacant, hay %', n;
  END IF;
END;
$$;

COMMIT;

-- Carga de la categoría (varias) de Lleida (provincia 25), trozo de la carga de Andalucía.
-- Origen: cataluna-grandes-superficies-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 14 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-10542503159', 'Carrefour Juneda – Carrer Major', NULL, '25119', 'Carrer Major 44', '25430', 41.54814, 0.82524, 'address', 'openstreetmap:node/10542503159'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-1156477283', 'Carrefour Lleida – Gran Passeig de Ronda', NULL, '25120', 'Gran Passeig de Ronda 63', '25006', 41.61715, 0.61283, 'address', 'openstreetmap:node/1156477283'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-12398695684', 'Decathlon Lleida – Carrer de Miquel Batllori 6,8', NULL, '25120', 'Carrer de Miquel Batllori 6,8', '25001', 41.60552, 0.62927, 'address', 'openstreetmap:node/12398695684'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:node-12475850648', 'IKEA Lleida – Carrer de Pi i Margall', NULL, '25120', 'Carrer de Pi i Margall 3', '25004', 41.61947, 0.62875, 'address', 'openstreetmap:node/12475850648'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:node-13042133727', 'IKEA Lleida – Rambla de Ferran', NULL, '25120', 'Rambla de Ferran 39', '25007', 41.61897, 0.63094, 'address', 'openstreetmap:node/13042133727'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-3225179632', 'Carrefour Vallfogona de Balaguer – Carrer de la Carretera', NULL, '25240', 'Carrer de la Carretera 4', '25617', 41.78748, 0.82612, 'address', 'openstreetmap:node/3225179632'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-4545084827', 'Carrefour Espot – C-13 Benzinera Cepsa - La Torrassa', NULL, '25082', 'C-13 Benzinera Cepsa - La Torrassa', '25597', 42.57715, 1.13923, 'address', 'openstreetmap:node/4545084827'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-5458645468', 'Carrefour Lleida – Avinguda de l''Alcalde Rovira Roure', NULL, '25120', 'Avinguda de l''Alcalde Rovira Roure 3', '25006', 41.61981, 0.61867, 'address', 'openstreetmap:node/5458645468'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-5498766368', 'Carrefour Lleida – Carrer de la Mariola', NULL, '25120', 'Carrer de la Mariola 6', '25003', 41.61223, 0.61329, 'address', 'openstreetmap:node/5498766368'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-6295153185', 'Carrefour Lleida – Carrer del Cronista Muntaner', NULL, '25120', 'Carrer del Cronista Muntaner 21', '25001', 41.61096, 0.63443, 'address', 'openstreetmap:node/6295153185'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-6736864007', 'Carrefour Naut Aran – C-28 29,5', NULL, '25025', 'C-28 29,5', '25599', 42.70011, 0.86268, 'address', 'openstreetmap:node/6736864007'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-202322062', 'Carrefour Lleida – N-240', NULL, '25120', 'N-240 96', NULL, 41.63215, 0.59259, 'address', 'openstreetmap:way/202322062'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:way-288445034', 'MediaMarkt Lleida – Avinguda del President Josep Irla', NULL, '25120', 'Avinguda del President Josep Irla 1', '25001', 41.60682, 0.63258, 'address', 'openstreetmap:way/288445034'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-879507171', 'Carrefour Vila-sana – A-2', NULL, '25252', 'A-2', '25245', 41.64346, 0.93144, 'address', 'openstreetmap:way/879507171');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '25');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 25 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '25'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 14 THEN
    RAISE EXCEPTION 'Se esperaban 14 puntos de (varias) en Lleida, hay %', n;
  END IF;
END;
$$;

COMMIT;

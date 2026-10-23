-- Carga de la categoría (varias) de Santa Cruz de Tenerife (provincia 38), trozo de la carga de Andalucía.
-- Origen: canarias-grandes-superficies-canarias.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-21T20:21:46Z).
-- 16 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('IKEA', 'catalogo-canarias:canarias-grandes-superficies:node-10081723522', 'IKEA San Cristóbal de La Laguna – Calle Aceviño', NULL, '38023', 'Calle Aceviño', NULL, 28.45973, -16.30684, 'address', 'openstreetmap:node/10081723522'),
  ('Carrefour', 'catalogo-canarias:canarias-grandes-superficies:node-11394974679', 'Carrefour Icod de los Vinos', NULL, '38022', NULL, NULL, 28.37882, -16.7007, 'address', 'openstreetmap:node/11394974679'),
  ('MediaMarkt', 'catalogo-canarias:canarias-grandes-superficies:node-12144055345', 'MediaMarkt Adeje', NULL, '38001', NULL, '38670', 28.12266, -16.74485, 'address', 'openstreetmap:node/12144055345'),
  ('Decathlon', 'catalogo-canarias:canarias-grandes-superficies:node-13447808739', 'Decathlon Adeje – Parque Comercial Adeje Shopping', NULL, '38001', 'Parque Comercial Adeje Shopping', '38670', 28.12261, -16.74453, 'address', 'openstreetmap:node/13447808739'),
  ('MediaMarkt', 'catalogo-canarias:canarias-grandes-superficies:node-1385067582', 'MediaMarkt Santa Cruz de Tenerife – Avenida Tres de Mayo', NULL, '38038', 'Avenida Tres de Mayo', '38003', 28.45878, -16.25593, 'address', 'openstreetmap:node/1385067582'),
  ('Decathlon', 'catalogo-canarias:canarias-grandes-superficies:node-14131684436', 'Decathlon Santa Cruz de Tenerife – Calle del Castillo', NULL, '38038', 'Calle del Castillo', '38003', 28.46732, -16.2531, 'address', 'openstreetmap:node/14131684436'),
  ('Carrefour', 'catalogo-canarias:canarias-grandes-superficies:node-301234636', 'Carrefour Santa Cruz de Tenerife – Avenida Manuel Hermoso Rojas', NULL, '38038', 'Avenida Manuel Hermoso Rojas', '38005', 28.45732, -16.25877, 'address', 'openstreetmap:node/301234636'),
  ('IKEA', 'catalogo-canarias:canarias-grandes-superficies:node-6183444322', 'IKEA San Miguel de Abona – Avenida Siete Islas Canarias', NULL, '38035', 'Avenida Siete Islas Canarias', '38639', 28.05372, -16.61249, 'address', 'openstreetmap:node/6183444322'),
  ('Leroy Merlin', 'catalogo-canarias:canarias-grandes-superficies:way-1005928318', 'Leroy Merlin Adeje', NULL, '38001', NULL, NULL, 28.12142, -16.74621, 'address', 'openstreetmap:way/1005928318'),
  ('IKEA', 'catalogo-canarias:canarias-grandes-superficies:way-120163703', 'IKEA Breña Alta – Calle España', NULL, '38008', 'Calle España', NULL, 28.67308, -17.78821, 'address', 'openstreetmap:way/120163703'),
  ('Leroy Merlin', 'catalogo-canarias:canarias-grandes-superficies:way-123204059', 'Leroy Merlin San Cristóbal de La Laguna – Calle El Vecino', NULL, '38023', 'Calle El Vecino', NULL, 28.45794, -16.30775, 'address', 'openstreetmap:way/123204059'),
  ('Decathlon', 'catalogo-canarias:canarias-grandes-superficies:way-28672918', 'Decathlon San Cristóbal de La Laguna – Vía de Servicio', NULL, '38023', 'Vía de Servicio', NULL, 28.46158, -16.30462, 'address', 'openstreetmap:way/28672918'),
  ('Leroy Merlin', 'catalogo-canarias:canarias-grandes-superficies:way-37766257', 'Leroy Merlin La Orotava – Calle Molinos de Gofio', NULL, '38026', 'Calle Molinos de Gofio', '38312', 28.39393, -16.54774, 'address', 'openstreetmap:way/37766257'),
  ('El Corte Inglés', 'catalogo-canarias:canarias-grandes-superficies:way-53265905', 'El Corte Inglés Santa Cruz de Tenerife – Avenida Tres de Mayo', NULL, '38038', 'Avenida Tres de Mayo 7', '38003', 28.45918, -16.25415, 'address', 'openstreetmap:way/53265905'),
  ('Carrefour', 'catalogo-canarias:canarias-grandes-superficies:way-75420744', 'Carrefour Santa Cruz de Tenerife – Rambla Bentacayse, Calle Bentagay', NULL, '38038', 'Rambla Bentacayse, Calle Bentagay', NULL, 28.42676, -16.3011, 'address', 'openstreetmap:way/75420744'),
  ('MediaMarkt', 'catalogo-canarias:canarias-grandes-superficies:way-79044669', 'MediaMarkt Santa Cruz de Tenerife – PG IND. AÑAZA PARC-39, S.N.', NULL, '38038', 'PG IND. AÑAZA PARC-39, S.N.', NULL, 28.42613, -16.29994, 'address', 'openstreetmap:way/79044669');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '38');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 38 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '38'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 16 THEN
    RAISE EXCEPTION 'Se esperaban 16 puntos de (varias) en Santa Cruz de Tenerife, hay %', n;
  END IF;
END;
$$;

COMMIT;

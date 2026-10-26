-- Carga de la categoría (varias) de Pontevedra (provincia 36), trozo de la carga de Andalucía.
-- Origen: galicia-grandes-superficies-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 20 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('MediaMarkt', 'catalogo-galicia:galicia-grandes-superficies:node-10270894311', 'MediaMarkt Vigo – Estrada Vella de Madrid,', NULL, '36057', 'Estrada Vella de Madrid, 158', '36313', 42.21685, -8.68529, 'address', 'openstreetmap:node/10270894311'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-11296173807', 'Carrefour Vigo – Rúa Anduriña', NULL, '36057', 'Rúa Anduriña', '36214', 42.22292, -8.70853, 'address', 'openstreetmap:node/11296173807'),
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:node-11892186258', 'Decathlon Nigrán – Rúa da Barreira', NULL, '36035', 'Rúa da Barreira', NULL, 42.13273, -8.79572, 'address', 'openstreetmap:node/11892186258'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-12674353529', 'Carrefour Moaña – Rúa das Barxas', NULL, '36029', 'Rúa das Barxas', '36950', 42.28761, -8.73406, 'address', 'openstreetmap:node/12674353529'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-1704835657', 'Carrefour Lalín', NULL, '36024', NULL, NULL, 42.66882, -8.10213, 'address', 'openstreetmap:node/1704835657'),
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:node-1724682907', 'Decathlon Vigo – Autovía do Atlántico', NULL, '36057', 'Autovía do Atlántico', '36313', 42.2166, -8.68389, 'address', 'openstreetmap:node/1724682907'),
  ('Leroy Merlin', 'catalogo-galicia:galicia-grandes-superficies:node-3790916896', 'Leroy Merlin Mos', NULL, '36033', NULL, NULL, 42.17087, -8.62059, 'address', 'openstreetmap:node/3790916896'),
  ('El Corte Inglés', 'catalogo-galicia:galicia-grandes-superficies:node-4085365763', 'El Corte Inglés Vigo – Rúa de Urzáiz', NULL, '36057', 'Rúa de Urzáiz 9', '36201', 42.23537, -8.71931, 'address', 'openstreetmap:node/4085365763'),
  ('MediaMarkt', 'catalogo-galicia:galicia-grandes-superficies:node-4085406900', 'MediaMarkt Vigo – Rúa Cánovas del Castillo', NULL, '36057', 'Rúa Cánovas del Castillo 1', '36202', 42.24081, -8.72827, 'address', 'openstreetmap:node/4085406900'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-6149538954', 'Carrefour Vigo – Avenida das Camelias', NULL, '36057', 'Avenida das Camelias 115', '36211', 42.22492, -8.72961, 'address', 'openstreetmap:node/6149538954'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:node-6616477138', 'Carrefour Vigo – Travesía de Vigo', NULL, '36057', 'Travesía de Vigo', '36207', 42.24357, -8.69565, 'address', 'openstreetmap:node/6616477138'),
  ('Decathlon', 'catalogo-galicia:galicia-grandes-superficies:node-9993770674', 'Decathlon Vigo – Vía Norte', NULL, '36057', 'Vía Norte 10', '36204', 42.23432, -8.71279, 'address', 'openstreetmap:node/9993770674'),
  ('Leroy Merlin', 'catalogo-galicia:galicia-grandes-superficies:way-1281235928', 'Leroy Merlin Nigrán – Rúa das Pontes', NULL, '36035', 'Rúa das Pontes', NULL, 42.133, -8.79966, 'address', 'openstreetmap:way/1281235928'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-1362899590', 'Carrefour Meis – CTRA- PO 531, PK', NULL, '36028', 'CTRA- PO 531, PK 16', '36616', 42.55167, -8.7061, 'address', 'openstreetmap:way/1362899590'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-142937947', 'Carrefour Baiona – Camiño Real', NULL, '36003', 'Camiño Real', NULL, 42.11014, -8.83219, 'address', 'openstreetmap:way/142937947'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-1571734238', 'Carrefour Vigo – Rua do Miradoiro', NULL, '36057', 'Rua do Miradoiro 2', '36210', 42.22084, -8.72482, 'address', 'openstreetmap:way/1571734238'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-360205913', 'Carrefour Sanxenxo', NULL, '36051', NULL, NULL, 42.41165, -8.81291, 'address', 'openstreetmap:way/360205913'),
  ('El Corte Inglés', 'catalogo-galicia:galicia-grandes-superficies:way-371755861', 'El Corte Inglés Vigo – Avenida da Gran Vía', NULL, '36057', 'Avenida da Gran Vía 28', '36204', 42.23199, -8.71699, 'address', 'openstreetmap:way/371755861'),
  ('Carrefour', 'catalogo-galicia:galicia-grandes-superficies:way-679061056', 'Carrefour Pontevedra – Rúa San Blas', NULL, '36038', 'Rúa San Blas', '36143', 42.41762, -8.64563, 'address', 'openstreetmap:way/679061056'),
  ('Leroy Merlin', 'catalogo-galicia:galicia-grandes-superficies:way-779535725', 'Leroy Merlin Vigo – Camiño do Caramuxo', NULL, '36057', 'Camiño do Caramuxo', NULL, 42.20491, -8.75847, 'address', 'openstreetmap:way/779535725');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '36');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 36 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '36'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 20 THEN
    RAISE EXCEPTION 'Se esperaban 20 puntos de (varias) en Pontevedra, hay %', n;
  END IF;
END;
$$;

COMMIT;

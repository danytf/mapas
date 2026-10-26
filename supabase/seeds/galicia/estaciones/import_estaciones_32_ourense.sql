-- Carga de la categoría Estaciones de Ourense (provincia 32), trozo de la carga de Andalucía.
-- Origen: estaciones-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 25 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-galicia:estaciones:node-10554286687', 'Estación de tren de O Carballiño – Rúa Vicente Risco', 'Tren', '32019', 'Rúa Vicente Risco', NULL, 42.43152, -8.06866, 'address', 'openstreetmap:node/10554286687'),
  ('catalogo-galicia:estaciones:node-12546448453', 'Estación de tren de A Gudiña-Porta de Galicia – Rúa de Viana', 'Tren', '32034', 'Rúa de Viana', NULL, 42.06376, -7.13437, 'address', 'openstreetmap:node/12546448453'),
  ('catalogo-galicia:estaciones:node-12589930093', 'Estación de tren de Sobradelo (Carballeda de Valdeorras) – Estrada de Éntoma', 'Tren', '32017', 'Estrada de Éntoma', '32330', 42.41477, -6.91194, 'address', 'openstreetmap:node/12589930093'),
  ('catalogo-galicia:estaciones:node-12593234166', 'Estación de tren de O Irixo', 'Tren', '32035', NULL, NULL, 42.51962, -8.10484, 'address', 'openstreetmap:node/12593234166'),
  ('catalogo-galicia:estaciones:node-12759737324', 'Estación de tren de Covas (Rubiá)', 'Tren', '32073', NULL, NULL, 42.47525, -6.83082, 'address', 'openstreetmap:node/12759737324'),
  ('catalogo-galicia:estaciones:node-13370314589', 'Estación de tren de A Friela-Maside – Pasaxe da Friela', 'Tren', '32045', 'Pasaxe da Friela', NULL, 42.41142, -8.02896, 'address', 'openstreetmap:node/13370314589'),
  ('catalogo-galicia:estaciones:node-13473968936', 'Estación de tren de Ourense-San Francisco – Rúa da Pena Nofre', 'Tren', '32054', 'Rúa da Pena Nofre', '32005', 42.33259, -7.86071, 'address', 'openstreetmap:node/13473968936'),
  ('catalogo-galicia:estaciones:node-13522163528', 'Estación de tren de Ribadavia – Rúa do Consello', 'Tren', '32069', 'Rúa do Consello', NULL, 42.29304, -8.13902, 'address', 'openstreetmap:node/13522163528'),
  ('catalogo-galicia:estaciones:node-13753836213', 'Estación de tren de O Barco de Valdeorras – Rúa Eloi Rodríguez Barrios', 'Tren', '32009', 'Rúa Eloi Rodríguez Barrios', '32300', 42.41826, -6.98505, 'address', 'openstreetmap:node/13753836213'),
  ('catalogo-galicia:estaciones:node-13753836215', 'Estación de tren de A Rúa-Petín – Rúa Doutor Vila', 'Tren', '32072', 'Rúa Doutor Vila', NULL, 42.39261, -7.11325, 'address', 'openstreetmap:node/13753836215'),
  ('catalogo-galicia:estaciones:node-14106323728', 'Estación de tren de Barbantes (Cenlle) – Estación', 'Tren', '32025', 'Estación', '32450', 42.33851, -8.01146, 'address', 'openstreetmap:node/14106323728'),
  ('catalogo-galicia:estaciones:node-14317276510', 'Estación de tren de Os Peares (A Peroxa)', 'Tren', '32059', NULL, NULL, 42.45111, -7.7355, 'address', 'openstreetmap:node/14317276510'),
  ('catalogo-galicia:estaciones:node-1842017741', 'Estación de tren de Ourense-Empalme – Rúa de Eulogio Gómez Franqueira', 'Tren', '32054', 'Rúa de Eulogio Gómez Franqueira', '32001', 42.35069, -7.87255, 'address', 'openstreetmap:node/1842017741'),
  ('catalogo-galicia:estaciones:node-1876310708', 'Estación de tren de Vilamartín de Valdeorras – Rúa Dona Consuelo', 'Tren', '32088', 'Rúa Dona Consuelo', NULL, 42.41152, -7.06142, 'address', 'openstreetmap:node/1876310708'),
  ('catalogo-galicia:estaciones:node-6090258617', 'Estación de tren de Barra de Miño (Coles)', 'Tren', '32026', NULL, NULL, 42.40104, -7.80251, 'address', 'openstreetmap:node/6090258617'),
  ('catalogo-galicia:estaciones:node-9521835894', 'Estación de autobuses de A Gudiña – Camiño das Quintas', 'Autobús', '32034', 'Camiño das Quintas', NULL, 42.06043, -7.13244, 'address', 'openstreetmap:node/9521835894'),
  ('catalogo-galicia:estaciones:relation-2506551', 'Estación de Autobuses de Ribadavia – Rúa Irmáns Álvarez Araújo', 'Autobús', '32069', 'Rúa Irmáns Álvarez Araújo', NULL, 42.29143, -8.13903, 'address', 'openstreetmap:relation/2506551'),
  ('catalogo-galicia:estaciones:way-1425278580', 'Estacion autobuses (Viana do Bolo) – Estrada A Gudiña - A Rúa', 'Autobús', '32086', 'Estrada A Gudiña - A Rúa', '32550', 42.1824, -7.11153, 'address', 'openstreetmap:way/1425278580'),
  ('catalogo-galicia:estaciones:way-1531698788', 'Estación de Autobuses do Carballiño – Rúa Tras Campo da Feira', 'Autobús', '32019', 'Rúa Tras Campo da Feira', '32500', 42.43297, -8.08079, 'address', 'openstreetmap:way/1531698788'),
  ('catalogo-galicia:estaciones:way-188834747', 'Estación de Autobuses de Ourense – Rúa de Eulogio Gómez Franqueira', 'Autobús', '32054', 'Rúa de Eulogio Gómez Franqueira', '32001', 42.35084, -7.87424, 'address', 'openstreetmap:way/188834747'),
  ('catalogo-galicia:estaciones:way-201191481', 'Estación de Autobuses do Barco de Valdeorras – Rúa Río Galir', 'Autobús', '32009', 'Rúa Río Galir', '32300', 42.41826, -6.99449, 'address', 'openstreetmap:way/201191481'),
  ('catalogo-galicia:estaciones:way-241788631', 'Estación de autobuses de Verín – Rúa das Flores', 'Autobús', '32085', 'Rúa das Flores', NULL, 41.93982, -7.43392, 'address', 'openstreetmap:way/241788631'),
  ('catalogo-galicia:estaciones:way-287516799', 'Estación de tren de Quereño (Rubiá) – Rúa da Estación', 'Tren', '32073', 'Rúa da Estación', NULL, 42.42067, -6.82956, 'address', 'openstreetmap:way/287516799'),
  ('catalogo-galicia:estaciones:way-509340628', 'Estación de Autobuses de Celanova – Rúa do Muíño', 'Autobús', '32024', 'Rúa do Muíño', '32800', 42.14943, -7.95645, 'address', 'openstreetmap:way/509340628'),
  ('catalogo-galicia:estaciones:way-616892786', 'Estación de Autobuses Allariz – Rúa Emilia Pardo Bazán', 'Autobús', '32001', 'Rúa Emilia Pardo Bazán 38', NULL, 42.18817, -7.7999, 'address', 'openstreetmap:way/616892786');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '32');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 32 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '32'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 25 THEN
    RAISE EXCEPTION 'Se esperaban 25 puntos de Estaciones en Ourense, hay %', n;
  END IF;
END;
$$;

COMMIT;

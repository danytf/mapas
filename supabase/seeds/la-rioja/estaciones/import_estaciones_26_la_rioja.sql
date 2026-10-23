-- Carga de la categoría Estaciones de La Rioja (provincia 26), trozo de la carga de Andalucía.
-- Origen: estaciones-la-rioja.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:39:03Z).
-- 21 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-la-rioja:estaciones:node-13676298387', 'Nueva Estación de Logroño – Calle Miguel Delibes', 'Autobús', '26089', 'Calle Miguel Delibes', NULL, 42.45753, -2.4427, 'approximate', 'openstreetmap:node/13676298387'),
  ('catalogo-la-rioja:estaciones:node-13676298388', 'Estación de autobuses de Santo Domingo de la Calzada – Plaza San Jerónimo Hermosilla', 'Autobús', '26138', 'Plaza San Jerónimo Hermosilla', '26250', 42.43911, -2.95315, 'approximate', 'openstreetmap:node/13676298388'),
  ('catalogo-la-rioja:estaciones:node-1536500006', 'Estación de tren de Haro – Calle de la Estación', 'Tren', '26071', 'Calle de la Estación', '26200', 42.58371, -2.84913, 'address', 'openstreetmap:node/1536500006'),
  ('catalogo-la-rioja:estaciones:node-2089759574', 'Estación de tren de Recajo (Agoncillo) – Urbanicacion Aguas Mansas', 'Tren', '26002', 'Urbanicacion Aguas Mansas', NULL, 42.44985, -2.33699, 'address', 'openstreetmap:node/2089759574'),
  ('catalogo-la-rioja:estaciones:node-2089761594', 'Estación de tren de Agoncillo – Calle Cesar Sierra', 'Tren', '26002', 'Calle Cesar Sierra', NULL, 42.44355, -2.29167, 'address', 'openstreetmap:node/2089761594'),
  ('catalogo-la-rioja:estaciones:node-2090074703', 'Estación de tren de Alcanadre – Calle Cuesta del Soto', 'Tren', '26007', 'Calle Cuesta del Soto', NULL, 42.40759, -2.12197, 'address', 'openstreetmap:node/2090074703'),
  ('catalogo-la-rioja:estaciones:node-2090086360', 'Estación de tren de Arrúbal', 'Tren', '26019', NULL, NULL, 42.43086, -2.25608, 'address', 'openstreetmap:node/2090086360'),
  ('catalogo-la-rioja:estaciones:node-2091426364', 'Estación de tren de Calahorra – Plaza Intermodal', 'Tren', '26036', 'Plaza Intermodal', NULL, 42.3107, -1.95782, 'address', 'openstreetmap:node/2091426364'),
  ('catalogo-la-rioja:estaciones:node-2091429119', 'Estación de tren de Rincón de Soto – Avenida del Príncipe Felipe', 'Tren', '26125', 'Avenida del Príncipe Felipe', NULL, 42.23005, -1.84786, 'address', 'openstreetmap:node/2091429119'),
  ('catalogo-la-rioja:estaciones:node-2091431019', 'Estación de tren de Alfaro – Avenida de la Via', 'Tren', '26011', 'Avenida de la Via', NULL, 42.18661, -1.74814, 'address', 'openstreetmap:node/2091431019'),
  ('catalogo-la-rioja:estaciones:node-215850055', 'Estación de autobuses de Alfaro – Paseo del Ninfeo', 'Autobús', '26011', 'Paseo del Ninfeo', NULL, 42.17944, -1.7587, 'address', 'openstreetmap:node/215850055'),
  ('catalogo-la-rioja:estaciones:node-2459459539', 'Estación de tren de Logroño – Avenida de Colón', 'Tren', '26089', 'Avenida de Colón 83', NULL, 42.45757, -2.44082, 'address', 'openstreetmap:node/2459459539'),
  ('catalogo-la-rioja:estaciones:node-2538448854', 'Terminal de autobuses de Nájera – Carretera de Uruñuela', 'Autobús', '26102', 'Carretera de Uruñuela', '26300', 42.41889, -2.72499, 'address', 'openstreetmap:node/2538448854'),
  ('catalogo-la-rioja:estaciones:node-2552558953', 'Estación de Autobuses (Arnedo) – Avenida de los Reyes Católicos', 'Autobús', '26018', 'Avenida de los Reyes Católicos', '26580', 42.22404, -2.10237, 'address', 'openstreetmap:node/2552558953'),
  ('catalogo-la-rioja:estaciones:node-633438677', 'Estación de Autobuses de Calahorra – Calle Doctor Fleming', 'Autobús', '26036', 'Calle Doctor Fleming', '26500', 42.30213, -1.96456, 'address', 'openstreetmap:node/633438677'),
  ('catalogo-la-rioja:estaciones:way-119256892', 'Estacion de Autobuses Santo Domingo (Santo Domingo de la Calzada) – Plaza San Jerónimo Hermosilla', 'Autobús', '26138', 'Plaza San Jerónimo Hermosilla', '26250', 42.43911, -2.95314, 'approximate', 'openstreetmap:way/119256892'),
  ('catalogo-la-rioja:estaciones:way-199100282', 'Estación de autobús de Calahorra – Plaza Intermodal', 'Autobús', '26036', 'Plaza Intermodal', NULL, 42.31058, -1.95799, 'address', 'openstreetmap:way/199100282'),
  ('catalogo-la-rioja:estaciones:way-279110607', 'Nueva Estación de Autobuses (Logroño) – Calle Miguel Delibes', 'Autobús', '26089', 'Calle Miguel Delibes', NULL, 42.45759, -2.44267, 'approximate', 'openstreetmap:way/279110607'),
  ('catalogo-la-rioja:estaciones:way-53197073', 'Estación de Autobuses de Haro – Calle Castilla', 'Autobús', '26071', 'Calle Castilla', NULL, 42.57363, -2.8532, 'address', 'openstreetmap:way/53197073'),
  ('catalogo-la-rioja:estaciones:way-755539286', 'Estación de Autobuses (Ezcaray) – Calle Barbadillo Vitoria', 'Autobús', '26061', 'Calle Barbadillo Vitoria', NULL, 42.32873, -3.01411, 'address', 'openstreetmap:way/755539286'),
  ('catalogo-la-rioja:estaciones:way-89799237', 'Estación de autobuses de Nájera – Paseo San Julián', 'Autobús', '26102', 'Paseo San Julián 1', '26300', 42.41671, -2.73197, 'address', 'openstreetmap:way/89799237');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '26');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 26 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '26'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 21 THEN
    RAISE EXCEPTION 'Se esperaban 21 puntos de Estaciones en La Rioja, hay %', n;
  END IF;
END;
$$;

COMMIT;

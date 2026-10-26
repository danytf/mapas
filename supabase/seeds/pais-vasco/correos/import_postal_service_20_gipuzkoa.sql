-- Carga de la categoría Correos de Gipuzkoa (provincia 20), trozo de la carga de Andalucía.
-- Origen: postal_service-pais-vasco.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 38 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-pais-vasco:postal_service:node-11999121192', 'Correos Eskoriatza – Jose Arana kalea', NULL, '20034', 'Jose Arana kalea 2', '20540', 43.01724, -2.52718, 'address', 'openstreetmap:node/11999121192'),
  ('catalogo-pais-vasco:postal_service:node-12058542261', 'Correos Bergara – Ibargarai hiribidea', NULL, '20074', 'Ibargarai hiribidea 21', '20570', 43.11442, -2.4162, 'address', 'openstreetmap:node/12058542261'),
  ('catalogo-pais-vasco:postal_service:node-12377258626', 'Correos Getaria – Aldamar kalea', NULL, '20039', 'Aldamar kalea 2', '20808', 43.30266, -2.2044, 'address', 'openstreetmap:node/12377258626'),
  ('catalogo-pais-vasco:postal_service:node-12656012790', 'Correos Deba – Ifar kalea', NULL, '20029', 'Ifar kalea 14', '20820', 43.29569, -2.35281, 'address', 'openstreetmap:node/12656012790'),
  ('catalogo-pais-vasco:postal_service:node-12874734748', 'Correos Urnieta – Maximo Yurramendi kalea', NULL, '20072', 'Maximo Yurramendi kalea 2', '20130', 43.2482, -1.99019, 'address', 'openstreetmap:node/12874734748'),
  ('catalogo-pais-vasco:postal_service:node-13347694601', 'Correos Donostia / San Sebastián – Zarautz kalea', NULL, '20069', 'Zarautz kalea 51', '20018', 43.3084, -2.00683, 'address', 'openstreetmap:node/13347694601'),
  ('catalogo-pais-vasco:postal_service:node-13731775691', 'Correos Astigarraga – Kale Nagusia', NULL, '20903', 'Kale Nagusia 3', '20115', 43.28053, -1.94982, 'address', 'openstreetmap:node/13731775691'),
  ('catalogo-pais-vasco:postal_service:node-13844419867', 'Correos Donostia / San Sebastián – Antonio Gaztañeta kalea', NULL, '20069', 'Antonio Gaztañeta kalea 2', '20018', 43.31106, -2.00817, 'address', 'openstreetmap:node/13844419867'),
  ('catalogo-pais-vasco:postal_service:node-1404356866', 'Correos Pasaia – Euskadi etorbidea', NULL, '20064', 'Euskadi etorbidea', '20110', 43.32213, -1.93631, 'address', 'openstreetmap:node/1404356866'),
  ('catalogo-pais-vasco:postal_service:node-14094871484', 'Correos Zestoa – Euskal Herria plaza', NULL, '20027', 'Euskal Herria plaza 1', '20740', 43.23961, -2.25782, 'address', 'openstreetmap:node/14094871484'),
  ('catalogo-pais-vasco:postal_service:node-1595966051', 'Correos Donostia / San Sebastián – Urdaneta kalea', NULL, '20069', 'Urdaneta kalea 7', '20006', 43.31627, -1.98075, 'address', 'openstreetmap:node/1595966051'),
  ('catalogo-pais-vasco:postal_service:node-1695902245', 'Correos Zumarraga – Elizkale', NULL, '20080', 'Elizkale 3', '20700', 43.08921, -2.31273, 'address', 'openstreetmap:node/1695902245'),
  ('catalogo-pais-vasco:postal_service:node-1745450756', 'Correos Villabona – Kale Berria', NULL, '20075', 'Kale Berria 64', '20150', 43.18645, -2.05275, 'address', 'openstreetmap:node/1745450756'),
  ('catalogo-pais-vasco:postal_service:node-2136431242', 'Correos Arrasate / Mondragón – Otalora lizentziaduna kalea', NULL, '20055', 'Otalora lizentziaduna kalea 3', '20500', 43.06656, -2.4875, 'address', 'openstreetmap:node/2136431242'),
  ('catalogo-pais-vasco:postal_service:node-2296077072', 'Correos Hondarribia – 1', NULL, '20036', '1', '20280', 43.3661, -1.79294, 'address', 'openstreetmap:node/2296077072'),
  ('catalogo-pais-vasco:postal_service:node-2447721011', 'Correos Hernani – Gartzia Goldaratz kalea', NULL, '20040', 'Gartzia Goldaratz kalea 4', '20120', 43.26805, -1.97253, 'address', 'openstreetmap:node/2447721011'),
  ('catalogo-pais-vasco:postal_service:node-2922316934', 'Correos Soraluze-Placencia de las Armas – Santa Ana kalea', NULL, '20065', 'Santa Ana kalea 14', '20590', 43.17388, -2.41307, 'address', 'openstreetmap:node/2922316934'),
  ('catalogo-pais-vasco:postal_service:node-295541858', 'Correos Mutriku – Barrenkale', NULL, '20056', 'Barrenkale 1', '20830', 43.30679, -2.38541, 'address', 'openstreetmap:node/295541858'),
  ('catalogo-pais-vasco:postal_service:node-3260414161', 'Correos Irun – Luis Mariano', NULL, '20045', 'Luis Mariano 45', '20302', 43.33942, -1.79424, 'address', 'openstreetmap:node/3260414161'),
  ('catalogo-pais-vasco:postal_service:node-3358548551', 'Correos Donostia / San Sebastián – Colon pasealekua', NULL, '20069', 'Colon pasealekua 28', '20002', 43.32394, -1.97561, 'address', 'openstreetmap:node/3358548551'),
  ('catalogo-pais-vasco:postal_service:node-372891642', 'Correos Errenteria – Morrongilleta kalea', NULL, '20067', 'Morrongilleta kalea 5', '20100', 43.31219, -1.9018, 'address', 'openstreetmap:node/372891642'),
  ('catalogo-pais-vasco:postal_service:node-3981895489', 'Correos Zarautz – Foruen kalea', NULL, '20079', 'Foruen kalea 7', '20800', 43.28432, -2.17603, 'address', 'openstreetmap:node/3981895489'),
  ('catalogo-pais-vasco:postal_service:node-4372450003', 'Correos Irun – Luis de Uranzu', NULL, '20045', 'Luis de Uranzu 11', '20301', 43.34179, -1.80097, 'address', 'openstreetmap:node/4372450003'),
  ('catalogo-pais-vasco:postal_service:node-5223885448', 'Correos Elgoibar – San Inazio kalea', NULL, '20032', 'San Inazio kalea 2', '20870', 43.2137, -2.41725, 'address', 'openstreetmap:node/5223885448'),
  ('catalogo-pais-vasco:postal_service:node-537789951', 'Correos Beasain – Nafarroa etorbidea', NULL, '20019', 'Nafarroa etorbidea 9', '20200', 43.0468, -2.20062, 'address', 'openstreetmap:node/537789951'),
  ('catalogo-pais-vasco:postal_service:node-55506624', 'Correos Eibar – Julian Etxeberria kalea', NULL, '20030', 'Julian Etxeberria kalea 1', '20600', 43.18634, -2.47071, 'address', 'openstreetmap:node/55506624'),
  ('catalogo-pais-vasco:postal_service:node-561228298', 'Correos Zumaia – Patxita Etxezarreta kalea', NULL, '20081', 'Patxita Etxezarreta kalea 21', '20750', 43.29408, -2.2547, 'address', 'openstreetmap:node/561228298'),
  ('catalogo-pais-vasco:postal_service:node-5697813131', 'Correos Ordizia – Filipinak kalea', NULL, '20076', 'Filipinak kalea 15', '20240', 43.05666, -2.17515, 'address', 'openstreetmap:node/5697813131'),
  ('catalogo-pais-vasco:postal_service:node-5868715495', 'Correos Lasarte-Oria – Geltoki kalea', NULL, '20902', 'Geltoki kalea 10', '20160', 43.26972, -2.02171, 'address', 'openstreetmap:node/5868715495'),
  ('catalogo-pais-vasco:postal_service:node-5868721057', 'Correos Andoain – Kale Nagusia 31B', NULL, '20009', 'Kale Nagusia 31B', '20140', 43.21666, -2.02127, 'address', 'openstreetmap:node/5868721057'),
  ('catalogo-pais-vasco:postal_service:node-7725029087', 'Correos Donostia / San Sebastián – Santesteban musikaria', NULL, '20069', 'Santesteban musikaria 3', '20011', 43.30609, -1.97406, 'address', 'openstreetmap:node/7725029087'),
  ('catalogo-pais-vasco:postal_service:node-809826521', 'Correos Lazkao – Elosegi kalea 19B', NULL, '20049', 'Elosegi kalea 19B', '20210', 43.03532, -2.18665, 'address', 'openstreetmap:node/809826521'),
  ('catalogo-pais-vasco:postal_service:node-945455435', 'Correos Antzuola – Herriko plaza', NULL, '20011', 'Herriko plaza 8', '20577', 43.09864, -2.38113, 'address', 'openstreetmap:node/945455435'),
  ('catalogo-pais-vasco:postal_service:node-9645999947', 'Correos Usurbil – Kontseju Zaharra kalea', NULL, '20073', 'Kontseju Zaharra kalea 11', '20170', 43.27114, -2.05024, 'address', 'openstreetmap:node/9645999947'),
  ('catalogo-pais-vasco:postal_service:node-9990824117', 'Correos Alegia – San Juan kalea', NULL, '20005', 'San Juan kalea 45', '20260', 43.10086, -2.09746, 'address', 'openstreetmap:node/9990824117'),
  ('catalogo-pais-vasco:postal_service:way-169277949', 'Correos Donostia / San Sebastián – Portuetxe bidea', NULL, '20069', 'Portuetxe bidea', '20018', 43.30103, -2.02084, 'address', 'openstreetmap:way/169277949'),
  ('catalogo-pais-vasco:postal_service:way-42792571', 'Correos Tolosa – Nafarroa etorbidea', NULL, '20071', 'Nafarroa etorbidea 6', '20400', 43.13462, -2.07541, 'address', 'openstreetmap:way/42792571'),
  ('catalogo-pais-vasco:postal_service:way-45452252', 'Correos Oñati – Unibertsitate etorbidea', NULL, '20059', 'Unibertsitate etorbidea 9', '20560', 43.03419, -2.41637, 'address', 'openstreetmap:way/45452252');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '20');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 20 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '20'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 38 THEN
    RAISE EXCEPTION 'Se esperaban 38 puntos de Correos en Gipuzkoa, hay %', n;
  END IF;
END;
$$;

COMMIT;

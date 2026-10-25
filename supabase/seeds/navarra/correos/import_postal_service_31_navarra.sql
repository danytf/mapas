-- Carga de la categoría Correos de Navarra (provincia 31), trozo de la carga de Andalucía.
-- Origen: postal_service-navarra.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-24T20:20:51Z).
-- 33 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-navarra:postal_service:node-10180297291', 'Correos Galar – Calle Z kalea', NULL, '31109', 'Calle Z kalea', '31191', 42.78356, -1.63331, 'address', 'openstreetmap:node/10180297291'),
  ('catalogo-navarra:postal_service:node-10650206922', 'Correos Irurtzun – San Martin kalea', NULL, '31904', 'San Martin kalea 1', NULL, 42.91953, -1.82854, 'address', 'openstreetmap:node/10650206922'),
  ('catalogo-navarra:postal_service:node-10749106103', 'Correos Pamplona / Iruña – Calle Amaya', NULL, '31201', 'Calle Amaya 33', '31004', 42.81017, -1.63441, 'address', 'openstreetmap:node/10749106103'),
  ('catalogo-navarra:postal_service:node-1187517541', 'Correos Altsasu / Alsasua – Zubeztia 41-43-45', NULL, '31010', 'Zubeztia 41-43-45', '31800', 42.89621, -2.16702, 'address', 'openstreetmap:node/1187517541'),
  ('catalogo-navarra:postal_service:node-13006242212', 'Correos Orkoien – Etxauriko errepidea', NULL, '31906', 'Etxauriko errepidea', '31160', 42.82245, -1.69587, 'address', 'openstreetmap:node/13006242212'),
  ('catalogo-navarra:postal_service:node-13057797408', 'Correos Pamplona / Iruña – Avenida Sancho el Fuerte', NULL, '31201', 'Avenida Sancho el Fuerte 69', '31007', 42.80962, -1.65603, 'address', 'openstreetmap:node/13057797408'),
  ('catalogo-navarra:postal_service:node-13229985372', 'Correos Tudela – Calle Juan Antonio Fernández', NULL, '31232', 'Calle Juan Antonio Fernández 4', '31500', 42.05814, -1.60069, 'address', 'openstreetmap:node/13229985372'),
  ('catalogo-navarra:postal_service:node-13421655149', 'Correos Tudela – Avenida de Zaragoza', NULL, '31232', 'Avenida de Zaragoza 65', '31500', 42.05413, -1.59765, 'address', 'openstreetmap:node/13421655149'),
  ('catalogo-navarra:postal_service:node-13744460204', 'Correos Leitza – Elgoien kalea', NULL, '31149', 'Elgoien kalea 9', '31880', 43.07839, -1.91531, 'address', 'openstreetmap:node/13744460204'),
  ('catalogo-navarra:postal_service:node-14085028701', 'Correos Sangüesa / Zangoza – Fermin Lubian karrika', NULL, '31216', 'Fermin Lubian karrika 17', '31400', 42.57594, -1.2804, 'address', 'openstreetmap:node/14085028701'),
  ('catalogo-navarra:postal_service:node-1675803939', 'Correos Baztan – Santiago karrika', NULL, '31050', 'Santiago karrika', '31700', 43.1422, -1.52124, 'address', 'openstreetmap:node/1675803939'),
  ('catalogo-navarra:postal_service:node-1714871970', 'Correos Barañáin / Barañain – Iruñeko etorbidea', NULL, '31901', 'Iruñeko etorbidea 4', '31010', 42.80479, -1.67503, 'address', 'openstreetmap:node/1714871970'),
  ('catalogo-navarra:postal_service:node-2101308775', 'Correos Castillonuevo / Gazteluberri – Calle Mayor', NULL, '31071', 'Calle Mayor 6', '31454', 42.6785, -1.04412, 'address', 'openstreetmap:node/2101308775'),
  ('catalogo-navarra:postal_service:node-2225289305', 'Correos Pamplona / Iruña – Calle Concejo de Sagaseta', NULL, '31201', 'Calle Concejo de Sagaseta 1', '31016', 42.80947, -1.61352, 'address', 'openstreetmap:node/2225289305'),
  ('catalogo-navarra:postal_service:node-2377306037', 'Correos Berriozar – Calle Etxaburua kalea', NULL, '31903', 'Calle Etxaburua kalea 14', '31013', 42.83417, -1.67126, 'address', 'openstreetmap:node/2377306037'),
  ('catalogo-navarra:postal_service:node-250232939', 'Correos Pamplona / Iruña – Calle Juslarrocha kalea', NULL, '31201', 'Calle Juslarrocha kalea', '31014', 42.82724, -1.64982, 'address', 'openstreetmap:node/250232939'),
  ('catalogo-navarra:postal_service:node-3020573433', 'Correos Zizur Mayor / Zizur Nagusia – Calle Idoia', NULL, '31907', 'Calle Idoia 1', '31180', 42.78853, -1.69244, 'address', 'openstreetmap:node/3020573433'),
  ('catalogo-navarra:postal_service:node-3221524342', 'Correos Pamplona / Iruña – Paseo Sarasate', NULL, '31201', 'Paseo Sarasate 9', '31002', 42.81504, -1.64485, 'address', 'openstreetmap:node/3221524342'),
  ('catalogo-navarra:postal_service:node-3397391620', 'Correos Lodosa – Paseo Central', NULL, '31157', 'Paseo Central 18', '31580', 42.42451, -2.08178, 'address', 'openstreetmap:node/3397391620'),
  ('catalogo-navarra:postal_service:node-3412942108', 'Correos Mendavia – Travesía Río Mayor', NULL, '31165', 'Travesía Río Mayor', '31587', 42.4435, -2.19718, 'address', 'openstreetmap:node/3412942108'),
  ('catalogo-navarra:postal_service:node-350625516', 'Correos Villava / Atarrabia – Calle Oianpea', NULL, '31258', 'Calle Oianpea 5', '31610', 42.8329, -1.60886, 'address', 'openstreetmap:node/350625516'),
  ('catalogo-navarra:postal_service:node-3599342578', 'Correos Olite / Erriberri – El Portillo', NULL, '31191', 'El Portillo 3', '31390', 42.48153, -1.65178, 'address', 'openstreetmap:node/3599342578'),
  ('catalogo-navarra:postal_service:node-4062357997', 'Correos Cintruénigo – Calle Barón De La Torre', NULL, '31072', 'Calle Barón De La Torre', '31592', 42.08131, -1.80746, 'address', 'openstreetmap:node/4062357997'),
  ('catalogo-navarra:postal_service:node-4076984907', 'Correos Corella – Calle Laurel', NULL, '31077', 'Calle Laurel', '31591', 42.11622, -1.78727, 'address', 'openstreetmap:node/4076984907'),
  ('catalogo-navarra:postal_service:node-4872727868', 'Correos Estella-Lizarra – Paseo de la Inmaculada', NULL, '31097', 'Paseo de la Inmaculada', '31200', 42.67071, -2.03106, 'address', 'openstreetmap:node/4872727868'),
  ('catalogo-navarra:postal_service:node-4913749928', 'Correos Ribaforada – Calle Caballeros Templarios', NULL, '31208', 'Calle Caballeros Templarios 12a', '31550', 41.99695, -1.51039, 'address', 'openstreetmap:node/4913749928'),
  ('catalogo-navarra:postal_service:node-4918923048', 'Correos Tafalla – Calle San Isidro', NULL, '31227', 'Calle San Isidro 5', '31300', 42.52568, -1.67814, 'address', 'openstreetmap:node/4918923048'),
  ('catalogo-navarra:postal_service:node-5172863029', 'Correos Los Arcos – Calle la Serna', NULL, '31029', 'Calle la Serna 14', '31210', 42.56724, -2.19061, 'address', 'openstreetmap:node/5172863029'),
  ('catalogo-navarra:postal_service:node-6376169785', 'Correos Viana – Plaza del Coso', NULL, '31251', 'Plaza del Coso', '31230', 42.51505, -2.36956, 'address', 'openstreetmap:node/6376169785'),
  ('catalogo-navarra:postal_service:node-6681683333', 'Correos Etxalar – Iñarreta Kalea', NULL, '31082', 'Iñarreta Kalea 3', '31760', 43.23421, -1.63821, 'address', 'openstreetmap:node/6681683333'),
  ('catalogo-navarra:postal_service:node-6802865485', 'Correos Bera – Bidasoa karrika', NULL, '31250', 'Bidasoa karrika', '31780', 43.28024, -1.68774, 'address', 'openstreetmap:node/6802865485'),
  ('catalogo-navarra:postal_service:node-6959310254', 'Correos Pamplona / Iruña – Calle de Santesteban', NULL, '31201', 'Calle de Santesteban 8', '31015', 42.82605, -1.62991, 'address', 'openstreetmap:node/6959310254'),
  ('catalogo-navarra:postal_service:way-438264653', 'Correos Doneztebe / Santesteban – Merkatu Plaza', NULL, '31221', 'Merkatu Plaza', '31740', 43.13072, -1.6721, 'address', 'openstreetmap:way/438264653');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '31');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 31 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '31'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 33 THEN
    RAISE EXCEPTION 'Se esperaban 33 puntos de Correos en Navarra, hay %', n;
  END IF;
END;
$$;

COMMIT;

-- Carga de la categoría Correos de Pontevedra (provincia 36), trozo de la carga de Andalucía.
-- Origen: postal_service-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 42 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-galicia:postal_service:node-10239125095', 'Correos Vigo – Avenida do Alcalde Portanet', NULL, '36057', 'Avenida do Alcalde Portanet', '36213', 42.21131, -8.73548, 'address', 'openstreetmap:node/10239125095'),
  ('catalogo-galicia:postal_service:node-10649596579', 'Correos Pontevedra – Rúa do Espincelo', NULL, '36038', 'Rúa do Espincelo', '36003', 42.42435, -8.6457, 'address', 'openstreetmap:node/10649596579'),
  ('catalogo-galicia:postal_service:node-10951963921', 'Correos Forcarei – Rúa da Regueira', NULL, '36018', 'Rúa da Regueira', NULL, 42.59296, -8.35098, 'address', 'openstreetmap:node/10951963921'),
  ('catalogo-galicia:postal_service:node-10994681015', 'Correos Silleda – Rúa Trasdeza', NULL, '36052', 'Rúa Trasdeza 55', '36540', 42.69787, -8.24835, 'address', 'openstreetmap:node/10994681015'),
  ('catalogo-galicia:postal_service:node-11607737225', 'Correos Catoira – Rúa do concello', NULL, '36010', 'Rúa do concello 9', '36612', 42.66627, -8.72301, 'address', 'openstreetmap:node/11607737225'),
  ('catalogo-galicia:postal_service:node-12093775416', 'Correos Mondariz – Rúa San Gregorio', NULL, '36030', 'Rúa San Gregorio', '36870', 42.2325, -8.45579, 'address', 'openstreetmap:node/12093775416'),
  ('catalogo-galicia:postal_service:node-12307243392', 'Correos Ponte Caldelas – Rúa José López Boullosa', NULL, '36043', 'Rúa José López Boullosa', NULL, 42.38911, -8.49807, 'address', 'openstreetmap:node/12307243392'),
  ('catalogo-galicia:postal_service:node-12537174380', 'Correos Caldas de Reis – San Roque', NULL, '36005', 'San Roque 50', '36650', 42.60766, -8.64491, 'address', 'openstreetmap:node/12537174380'),
  ('catalogo-galicia:postal_service:node-12612835007', 'Correos Forcarei – Rúa do Ambulatorio', NULL, '36018', 'Rúa do Ambulatorio', NULL, 42.53845, -8.3024, 'address', 'openstreetmap:node/12612835007'),
  ('catalogo-galicia:postal_service:node-12994423913', 'Correos Redondela – Avenida de Vigo', NULL, '36045', 'Avenida de Vigo 137', '36320', 42.26715, -8.6719, 'address', 'openstreetmap:node/12994423913'),
  ('catalogo-galicia:postal_service:node-1430036836', 'Correos Bueu – Rúa de Eduardo Vincenti', NULL, '36004', 'Rúa de Eduardo Vincenti 27', '36930', 42.32583, -8.78468, 'address', 'openstreetmap:node/1430036836'),
  ('catalogo-galicia:postal_service:node-14312523145', 'Correos Dozón', NULL, '36016', NULL, NULL, 42.56686, -8.04657, 'address', 'openstreetmap:node/14312523145'),
  ('catalogo-galicia:postal_service:node-14318662272', 'Correos Gondomar – Rúa da Cruz de Mera', NULL, '36021', 'Rúa da Cruz de Mera 2', '36380', 42.1125, -8.76049, 'address', 'openstreetmap:node/14318662272'),
  ('catalogo-galicia:postal_service:node-1482909656', 'Correos Marín – Rúa Lameira', NULL, '36026', 'Rúa Lameira', NULL, 42.3932, -8.70474, 'address', 'openstreetmap:node/1482909656'),
  ('catalogo-galicia:postal_service:node-1594467697', 'Correos Ponteareas – Rúa Azorín', NULL, '36042', 'Rúa Azorín', '36860', 42.17101, -8.50568, 'address', 'openstreetmap:node/1594467697'),
  ('catalogo-galicia:postal_service:node-1654126277', 'Correos Vigo – Praza de Compostela', NULL, '36057', 'Praza de Compostela 3', '36201', 42.23885, -8.7234, 'address', 'openstreetmap:node/1654126277'),
  ('catalogo-galicia:postal_service:node-1694924199', 'Correos Redondela – Rúa Casto San Pedro', NULL, '36045', 'Rúa Casto San Pedro 8', '36800', 42.28248, -8.6096, 'address', 'openstreetmap:node/1694924199'),
  ('catalogo-galicia:postal_service:node-1704854825', 'Correos Lalín – Rúa Pintor Laxeiro', NULL, '36024', 'Rúa Pintor Laxeiro', '36500', 42.65969, -8.10962, 'address', 'openstreetmap:node/1704854825'),
  ('catalogo-galicia:postal_service:node-1722847369', 'Correos A Estrada – Rúa Serafín Pazo', NULL, '36017', 'Rúa Serafín Pazo 41', NULL, 42.68762, -8.4877, 'address', 'openstreetmap:node/1722847369'),
  ('catalogo-galicia:postal_service:node-1734197792', 'Correos Vigo – Rúa de Alexandre Bóveda', NULL, '36057', 'Rúa de Alexandre Bóveda 2', '36210', 42.21236, -8.74119, 'address', 'openstreetmap:node/1734197792'),
  ('catalogo-galicia:postal_service:node-1784743955', 'Correos Vigo – Rúa da Coruña', NULL, '36057', 'Rúa da Coruña 48', '36208', 42.22347, -8.73495, 'address', 'openstreetmap:node/1784743955'),
  ('catalogo-galicia:postal_service:node-1815411610', 'Correos A Estrada – Avenida de América', NULL, '36017', 'Avenida de América 4', '36680', 42.68919, -8.49417, 'address', 'openstreetmap:node/1815411610'),
  ('catalogo-galicia:postal_service:node-1846795464', 'Correos O Grove – Avenida Ourense', NULL, '36022', 'Avenida Ourense', '36980', 42.49147, -8.85925, 'address', 'openstreetmap:node/1846795464'),
  ('catalogo-galicia:postal_service:node-2211121566', 'Correos Soutomaior – Avenida Castelao', NULL, '36053', 'Avenida Castelao 25', '36690', 42.34238, -8.60973, 'address', 'openstreetmap:node/2211121566'),
  ('catalogo-galicia:postal_service:node-2392823856', 'Correos Moaña – Rúa Fragata Villa de Madrid', NULL, '36029', 'Rúa Fragata Villa de Madrid 2', '36950', 42.27665, -8.73869, 'address', 'openstreetmap:node/2392823856'),
  ('catalogo-galicia:postal_service:node-2403912216', 'Correos O Rosal – Rúa Xulio Sesto', NULL, '36048', 'Rúa Xulio Sesto 70', '36770', 41.93863, -8.83459, 'address', 'openstreetmap:node/2403912216'),
  ('catalogo-galicia:postal_service:node-2464170136', 'Correos Cangas de Morrazo – Rúa Ferrol', NULL, '36008', 'Rúa Ferrol 2', '36940', 42.26478, -8.78016, 'address', 'openstreetmap:node/2464170136'),
  ('catalogo-galicia:postal_service:node-3429422591', 'Correos Tui – Rúa de Martínez Padín', NULL, '36055', 'Rúa de Martínez Padín 12', '36700', 42.0483, -8.64661, 'address', 'openstreetmap:node/3429422591'),
  ('catalogo-galicia:postal_service:node-3682735184', 'Correos Vigo – Rúa Genaro de la Fuente 44-46', NULL, '36057', 'Rúa Genaro de la Fuente 44-46', '36205', 42.23166, -8.70183, 'address', 'openstreetmap:node/3682735184'),
  ('catalogo-galicia:postal_service:node-3689043517', 'Correos Sanxenxo – Rúa do Progreso', NULL, '36051', 'Rúa do Progreso', '36960', 42.40162, -8.8036, 'address', 'openstreetmap:node/3689043517'),
  ('catalogo-galicia:postal_service:node-3727943337', 'Correos Tomiño – Praza da Mina', NULL, '36054', 'Praza da Mina', '36740', 41.99093, -8.74534, 'address', 'openstreetmap:node/3727943337'),
  ('catalogo-galicia:postal_service:node-3944641051', 'Correos Vilagarcía de Arousa – Alcalde Rey Daviña', NULL, '36060', 'Alcalde Rey Daviña 6', '36600', 42.59648, -8.76569, 'address', 'openstreetmap:node/3944641051'),
  ('catalogo-galicia:postal_service:node-4612835090', 'Correos Salceda de Caselas – Rúa Vigo 14 Portal', NULL, '36049', 'Rúa Vigo 14 Portal 3', '36470', 42.09965, -8.55674, 'address', 'openstreetmap:node/4612835090'),
  ('catalogo-galicia:postal_service:node-5269488722', 'Correos A Guarda – Rúa Oia', NULL, '36023', 'Rúa Oia', '36780', 41.90365, -8.87018, 'address', 'openstreetmap:node/5269488722'),
  ('catalogo-galicia:postal_service:node-5829863135', 'Correos Vigo – Rúa de Tomás Alonso', NULL, '36057', 'Rúa de Tomás Alonso 236', '36208', 42.2243, -8.75228, 'address', 'openstreetmap:node/5829863135'),
  ('catalogo-galicia:postal_service:node-6093006196', 'Correos Vila de Cruces – Praza de Paco Lareo', NULL, '36059', 'Praza de Paco Lareo', '36590', 42.79403, -8.16975, 'address', 'openstreetmap:node/6093006196'),
  ('catalogo-galicia:postal_service:node-6147797083', 'Correos Mos – Avenida de Peinador', NULL, '36033', 'Avenida de Peinador', '36416', 42.20886, -8.65473, 'address', 'openstreetmap:node/6147797083'),
  ('catalogo-galicia:postal_service:node-954657331', 'Correos O Porriño – Rúa O Pinar', NULL, '36039', 'Rúa O Pinar 19', '36400', 42.15983, -8.61559, 'address', 'openstreetmap:node/954657331'),
  ('catalogo-galicia:postal_service:node-9974472818', 'Correos Salvaterra de Miño – Rúa Raíña dona Urraca', NULL, '36050', 'Rúa Raíña dona Urraca 3', '36450', 42.08257, -8.49806, 'address', 'openstreetmap:node/9974472818'),
  ('catalogo-galicia:postal_service:way-1363600038', 'Correos Meis', NULL, '36028', NULL, NULL, 42.51398, -8.70649, 'address', 'openstreetmap:way/1363600038'),
  ('catalogo-galicia:postal_service:way-158594291', 'Correos Pontevedra – Rúa da Oliva', NULL, '36038', 'Rúa da Oliva 19', '36001', 42.43002, -8.64478, 'address', 'openstreetmap:way/158594291'),
  ('catalogo-galicia:postal_service:way-797568730', 'Correos Pontevedra – Avenida de Lugo', NULL, '36038', 'Avenida de Lugo 86', '36004', 42.43409, -8.62208, 'address', 'openstreetmap:way/797568730');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
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
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 42 THEN
    RAISE EXCEPTION 'Se esperaban 42 puntos de Correos en Pontevedra, hay %', n;
  END IF;
END;
$$;

COMMIT;

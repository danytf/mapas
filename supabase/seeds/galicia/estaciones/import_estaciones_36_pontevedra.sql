-- Carga de la categoría Estaciones de Pontevedra (provincia 36), trozo de la carga de Andalucía.
-- Origen: estaciones-galicia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 39 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-galicia:estaciones:node-12229427555', 'Estación de tren de As Neves', 'Tren', '36034', NULL, NULL, 42.07541, -8.4201, 'address', 'openstreetmap:node/12229427555'),
  ('catalogo-galicia:estaciones:node-12769236781', 'Estación de tren de Sela (Arbo)', 'Tren', '36001', NULL, NULL, 42.09214, -8.35596, 'address', 'openstreetmap:node/12769236781'),
  ('catalogo-galicia:estaciones:node-12819737430', 'Estación de tren de Vigo-Urzáiz – Praza da Estación', 'Tren', '36057', 'Praza da Estación', '36201', 42.23496, -8.7119, 'address', 'openstreetmap:node/12819737430'),
  ('catalogo-galicia:estaciones:node-12819737452', 'Estación de tren de O Porriño – Rúa Progreso', 'Tren', '36039', 'Rúa Progreso 27', '36400', 42.16414, -8.62217, 'address', 'openstreetmap:node/12819737452'),
  ('catalogo-galicia:estaciones:node-13716624631', 'Estación de tren de Redondela AV – Rúa Os Eidos', 'Tren', '36045', 'Rúa Os Eidos', '36800', 42.28456, -8.60363, 'address', 'openstreetmap:node/13716624631'),
  ('catalogo-galicia:estaciones:node-13716624633', 'Estación de tren de Salvaterra de Miño – Rúa das Pesqueiras', 'Tren', '36050', 'Rúa das Pesqueiras', '36450', 42.08171, -8.49522, 'address', 'openstreetmap:node/13716624633'),
  ('catalogo-galicia:estaciones:node-13717398211', 'Estación de tren de Caldelas de Tui', 'Tren', '36055', NULL, NULL, 42.0557, -8.56641, 'address', 'openstreetmap:node/13717398211'),
  ('catalogo-galicia:estaciones:node-13717398240', 'Estación de tren de Arbo', 'Tren', '36001', NULL, NULL, 42.10694, -8.30008, 'address', 'openstreetmap:node/13717398240'),
  ('catalogo-galicia:estaciones:node-13808097212', 'Estación de Autobuses de Vigo (EI) – Prazada estación', 'Autobús', '36057', 'Prazada estación 1', '36201', 42.23481, -8.71367, 'address', 'openstreetmap:node/13808097212'),
  ('catalogo-galicia:estaciones:node-14072946437', 'Estación de tren de Chapela (Redondela) – Rúa José Fernando López', 'Tren', '36045', 'Rúa José Fernando López 6', '36320', 42.26886, -8.67176, 'address', 'openstreetmap:node/14072946437'),
  ('catalogo-galicia:estaciones:node-1692189268', 'Estación de tren de Arcade (Soutomaior) – Rúa Rosalía de Castro', 'Tren', '36053', 'Rúa Rosalía de Castro', NULL, 42.34041, -8.61067, 'address', 'openstreetmap:node/1692189268'),
  ('catalogo-galicia:estaciones:node-1876244569', 'Estación de tren de Redondela-A Picota – Rúa Vilaflores', 'Tren', '36045', 'Rúa Vilaflores 6', '36800', 42.28675, -8.60729, 'address', 'openstreetmap:node/1876244569'),
  ('catalogo-galicia:estaciones:node-1998751056', 'Estación de tren de Lalín', 'Tren', '36024', NULL, NULL, 42.63244, -8.14286, 'address', 'openstreetmap:node/1998751056'),
  ('catalogo-galicia:estaciones:node-2509635080', 'Estación de Autobuses (Cangas de Morrazo) – Avenida Eduardo Vicenti', 'Autobús', '36008', 'Avenida Eduardo Vicenti', '36940', 42.26192, -8.78468, 'address', 'openstreetmap:node/2509635080'),
  ('catalogo-galicia:estaciones:node-3006639152', 'Estación de tren de A Portela (Barro)', 'Tren', '36002', NULL, NULL, 42.5177, -8.65435, 'address', 'openstreetmap:node/3006639152'),
  ('catalogo-galicia:estaciones:node-3008422794', 'Estación de Autobuses de Sanxenxo – Circunvalación de Sanxenxo', 'Autobús', '36051', 'Circunvalación de Sanxenxo', '36960', 42.4067, -8.81299, 'address', 'openstreetmap:node/3008422794'),
  ('catalogo-galicia:estaciones:node-3014214982', 'Estación de tren de Pontevedra-Universidade', 'Tren', '36038', NULL, NULL, 42.43898, -8.63033, 'address', 'openstreetmap:node/3014214982'),
  ('catalogo-galicia:estaciones:node-338879384', 'Estación de tren de Tui', 'Tren', '36055', NULL, '36700', 42.0566, -8.64326, 'approximate', 'openstreetmap:node/338879384'),
  ('catalogo-galicia:estaciones:node-338888796', 'Estación de tren de Louredo-Valos (Mos)', 'Tren', '36033', NULL, NULL, 42.23436, -8.59691, 'address', 'openstreetmap:node/338888796'),
  ('catalogo-galicia:estaciones:node-420539798', 'Estación de tren de Cesantes (Redondela) – Rúa dos Castiñeiros', 'Tren', '36045', 'Rúa dos Castiñeiros', NULL, 42.31021, -8.61644, 'address', 'openstreetmap:node/420539798'),
  ('catalogo-galicia:estaciones:node-453651815', 'Estación de tren de Pontevedra – Rúa Ramón Otero Pedrayo', 'Tren', '36038', 'Rúa Ramón Otero Pedrayo', '36003', 42.42168, -8.6354, 'address', 'openstreetmap:node/453651815'),
  ('catalogo-galicia:estaciones:way-1008221309', 'Estación de autobuses de Buses Avenida da Mariña - Rotonda (Vilagarcía de Arousa) – Rúa Conde de Vallellano', 'Autobús', '36060', 'Rúa Conde de Vallellano 11', '36600', 42.59607, -8.76736, 'address', 'openstreetmap:way/1008221309'),
  ('catalogo-galicia:estaciones:way-1329651260', 'Estación de Autobuses de Gondomar – Avenida de Curros Enríquez', 'Autobús', '36021', 'Avenida de Curros Enríquez', '36380', 42.10934, -8.7642, 'address', 'openstreetmap:way/1329651260'),
  ('catalogo-galicia:estaciones:way-1378449859', 'Estación de autobuses de Praza de Galicia (Pontevedra) – Avenida do Xeneral Antero Rubín', 'Autobús', '36038', 'Avenida do Xeneral Antero Rubín 3', '36001', 42.42783, -8.64452, 'address', 'openstreetmap:way/1378449859'),
  ('catalogo-galicia:estaciones:way-141812901', 'Estación de tren de Vigo-Guixar – Rúa Areal', 'Tren', '36057', 'Rúa Areal', '36201', 42.23925, -8.71202, 'address', 'openstreetmap:way/141812901'),
  ('catalogo-galicia:estaciones:way-145872076', 'Estación de Autobuses de Ponteareas – Rúa do Castañal', 'Autobús', '36042', 'Rúa do Castañal 15', '36860', 42.17552, -8.50122, 'address', 'openstreetmap:way/145872076'),
  ('catalogo-galicia:estaciones:way-1563259574', 'Estación de Autobuses de Tui – Prolongaci��n/Continuaci��n Alcalde Casal Aboy', 'Autobús', '36055', 'Prolongaci��n/Continuaci��n Alcalde Casal Aboy', '36700', 42.05294, -8.64589, 'address', 'openstreetmap:way/1563259574'),
  ('catalogo-galicia:estaciones:way-163424010', 'Estación de tren de Redondela – Aldea Portela', 'Tren', '36045', 'Aldea Portela 83', '36800', 42.28603, -8.61942, 'address', 'openstreetmap:way/163424010'),
  ('catalogo-galicia:estaciones:way-175467627', 'Estación de Autobuses da Estrada – Rúa do Matadoiro', 'Autobús', '36017', 'Rúa do Matadoiro 16', '36680', 42.68712, -8.48595, 'address', 'openstreetmap:way/175467627'),
  ('catalogo-galicia:estaciones:way-213840225', 'Estación de tren de Guillarei (Tui) – Estrada da Estación de Tren de Guillarei', 'Tren', '36055', 'Estrada da Estación de Tren de Guillarei', NULL, 42.06567, -8.62254, 'address', 'openstreetmap:way/213840225'),
  ('catalogo-galicia:estaciones:way-235059312', 'Estación de Autobuses de Pontevedra – Rúa da Estación', 'Autobús', '36038', 'Rúa da Estación 10', '36003', 42.42075, -8.63734, 'address', 'openstreetmap:way/235059312'),
  ('catalogo-galicia:estaciones:way-273549688', 'Estación Autobuses de Vilagarcía (Vilagarcía de Arousa) – Rúa Santa Lucía', 'Autobús', '36060', 'Rúa Santa Lucía', NULL, 42.5999, -8.76183, 'address', 'openstreetmap:way/273549688'),
  ('catalogo-galicia:estaciones:way-362307110', 'Estación de Autobuses de Cambados – Paseo Marítimo', 'Autobús', '36006', 'Paseo Marítimo', '36630', 42.51492, -8.81598, 'address', 'openstreetmap:way/362307110'),
  ('catalogo-galicia:estaciones:way-371688434', 'Estación de Autobuses de Lalín – Avenida da Estación', 'Autobús', '36024', 'Avenida da Estación 8', '36500', 42.65706, -8.11369, 'address', 'openstreetmap:way/371688434'),
  ('catalogo-galicia:estaciones:way-391681629', 'Estación de tren de Vilagarcía de Arousa – Rúa Doutor Moreira Casal', 'Tren', '36060', 'Rúa Doutor Moreira Casal', NULL, 42.60199, -8.76228, 'address', 'openstreetmap:way/391681629'),
  ('catalogo-galicia:estaciones:way-407540419', 'Estación de Autobuses de O Grove – Avenida de Beiramar', 'Autobús', '36022', 'Avenida de Beiramar', '36980', 42.49561, -8.86124, 'address', 'openstreetmap:way/407540419'),
  ('catalogo-galicia:estaciones:way-533271333', 'Estación de tren de A Pousa-Crecente', 'Tren', '36014', NULL, NULL, 42.13668, -8.23489, 'address', 'openstreetmap:way/533271333'),
  ('catalogo-galicia:estaciones:way-630158383', 'Estación de tren de Catoira – Praza do Doutor José R. Vázquez', 'Tren', '36010', 'Praza do Doutor José R. Vázquez', NULL, 42.67224, -8.72537, 'address', 'openstreetmap:way/630158383'),
  ('catalogo-galicia:estaciones:way-738202043', 'Estación de tren de Pontecesures – Rúa da Estación', 'Tren', '36044', 'Rúa da Estación', NULL, 42.72293, -8.65216, 'address', 'openstreetmap:way/738202043');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
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
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 39 THEN
    RAISE EXCEPTION 'Se esperaban 39 puntos de Estaciones en Pontevedra, hay %', n;
  END IF;
END;
$$;

COMMIT;

-- Carga de la categoría Correos de Tarragona (provincia 43), trozo de la carga de Andalucía.
-- Origen: postal_service-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 35 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-cataluna:postal_service:node-11074256500', 'Correos Altafulla – Carrer del Mar', NULL, '43012', 'Carrer del Mar 1', '43893', 41.13997, 1.37489, 'address', 'openstreetmap:node/11074256500'),
  ('catalogo-cataluna:postal_service:node-11622155638', 'Correos Santa Bàrbara – Carrer de Sant Antoni', NULL, '43138', 'Carrer de Sant Antoni 13', '43570', 40.71706, 0.497, 'address', 'openstreetmap:node/11622155638'),
  ('catalogo-cataluna:postal_service:node-1224796715', 'Correos Vila-seca – Plaça dels Països Catalans', NULL, '43171', 'Plaça dels Països Catalans 3', '43480', 41.10752, 1.14951, 'address', 'openstreetmap:node/1224796715'),
  ('catalogo-cataluna:postal_service:node-12825529343', 'Correos Riudoms – Carrer de la Muralla de la Font Nova', NULL, '43129', 'Carrer de la Muralla de la Font Nova 52', '43330', 41.13957, 1.05178, 'address', 'openstreetmap:node/12825529343'),
  ('catalogo-cataluna:postal_service:node-12890385501', 'Correos les Borges del Camp – Carrer de la Verge de la Riera 23-25', NULL, '43031', 'Carrer de la Verge de la Riera 23-25', '43350', 41.17079, 1.02048, 'address', 'openstreetmap:node/12890385501'),
  ('catalogo-cataluna:postal_service:node-13070302193', 'Correos Calafell – Carrer de Pablo Neruda', NULL, '43037', 'Carrer de Pablo Neruda 2', '43882', 41.19303, 1.60363, 'address', 'openstreetmap:node/13070302193'),
  ('catalogo-cataluna:postal_service:node-13285852893', 'Correos Tarragona – Carrer Eivissa', NULL, '43148', 'Carrer Eivissa 20', '43005', 41.11422, 1.24277, 'address', 'openstreetmap:node/13285852893'),
  ('catalogo-cataluna:postal_service:node-1341083911', 'Correos la Ràpita – Carrer Gorria', NULL, '43136', 'Carrer Gorria', '43540', 40.61739, 0.59167, 'address', 'openstreetmap:node/1341083911'),
  ('catalogo-cataluna:postal_service:node-13936432155', 'Correos la Sénia – Carrer de Maragall', NULL, '43044', 'Carrer de Maragall 11', '43560', 40.63524, 0.28375, 'address', 'openstreetmap:node/13936432155'),
  ('catalogo-cataluna:postal_service:node-1663015312', 'Correos l''Ametlla de Mar – Avinguda del Batlle Josep Pijoan', NULL, '43013', 'Avinguda del Batlle Josep Pijoan 28', '43860', 40.88555, 0.8032, 'address', 'openstreetmap:node/1663015312'),
  ('catalogo-cataluna:postal_service:node-1673766893', 'Correos Salou – Entrada Parking', NULL, '43905', 'Entrada Parking', '43840', 41.07647, 1.13326, 'address', 'openstreetmap:node/1673766893'),
  ('catalogo-cataluna:postal_service:node-1940665049', 'Correos Albinyana – Carrer de la Torreta', NULL, '43002', 'Carrer de la Torreta 19', '43716', 41.24546, 1.49152, 'address', 'openstreetmap:node/1940665049'),
  ('catalogo-cataluna:postal_service:node-2062490843', 'Correos Alforja – Plaça de les Monges', NULL, '43009', 'Plaça de les Monges', '43365', 41.21142, 0.97536, 'address', 'openstreetmap:node/2062490843'),
  ('catalogo-cataluna:postal_service:node-2088679121', 'Correos Valls – Carrer Xiquets de Valls', NULL, '43161', 'Carrer Xiquets de Valls 3', '43800', 41.28712, 1.25547, 'address', 'openstreetmap:node/2088679121'),
  ('catalogo-cataluna:postal_service:node-2121433229', 'Correos Alcover – Carrer de la Llibertat', NULL, '43005', 'Carrer de la Llibertat 3', '43460', 41.26085, 1.17115, 'address', 'openstreetmap:node/2121433229'),
  ('catalogo-cataluna:postal_service:node-2174958502', 'Correos el Perelló – Plaça de Jaume II', NULL, '43104', 'Plaça de Jaume II 3', '43519', 40.87548, 0.71264, 'address', 'openstreetmap:node/2174958502'),
  ('catalogo-cataluna:postal_service:node-2276804903', 'Correos Tarragona – Carrer de Sant Pau', NULL, '43148', 'Carrer de Sant Pau', '43007', 41.13923, 1.25334, 'address', 'openstreetmap:node/2276804903'),
  ('catalogo-cataluna:postal_service:node-2320714934', 'Correos Amposta – Avinguda de Catalunya', NULL, '43014', 'Avinguda de Catalunya 2', '43870', 40.70404, 0.57897, 'address', 'openstreetmap:node/2320714934'),
  ('catalogo-cataluna:postal_service:node-2416998084', 'Correos Llorenç del Penedès – Plaça de la Vila', NULL, '43074', 'Plaça de la Vila 1', '43712', 41.28291, 1.55288, 'address', 'openstreetmap:node/2416998084'),
  ('catalogo-cataluna:postal_service:node-2440203541', 'Correos Cunit – Avinguda de Barcelona', NULL, '43051', 'Avinguda de Barcelona 64', '43881', 41.19673, 1.62402, 'address', 'openstreetmap:node/2440203541'),
  ('catalogo-cataluna:postal_service:node-3495120181', 'Correos Montblanc – Carrer d''Aguiló', NULL, '43086', 'Carrer d''Aguiló 8', '43400', 41.37681, 1.16484, 'address', 'openstreetmap:node/3495120181'),
  ('catalogo-cataluna:postal_service:node-4377962758', 'Correos Calafell – Avinguda de Mossèn Jaume Soler', NULL, '43037', 'Avinguda de Mossèn Jaume Soler 19', '43820', 41.18874, 1.56981, 'address', 'openstreetmap:node/4377962758'),
  ('catalogo-cataluna:postal_service:node-4648647013', 'Correos Reus – Plaça de la Llibertat', NULL, '43123', 'Plaça de la Llibertat 12', '43201', 41.15909, 1.10613, 'address', 'openstreetmap:node/4648647013'),
  ('catalogo-cataluna:postal_service:node-4648647014', 'Correos Reus – Carrer de Bahía Blanca 5-7', NULL, '43123', 'Carrer de Bahía Blanca 5-7', '43205', 41.14579, 1.10832, 'address', 'openstreetmap:node/4648647014'),
  ('catalogo-cataluna:postal_service:node-5071310783', 'Correos Horta de Sant Joan – Carrer de Navarra', NULL, '43071', 'Carrer de Navarra', '43596', 40.95427, 0.31252, 'address', 'openstreetmap:node/5071310783'),
  ('catalogo-cataluna:postal_service:node-5353490007', 'Correos Vandellòs i l''Hospitalet de l''Infant – Carrer del Tarragonès', NULL, '43162', 'Carrer del Tarragonès', '43890', 40.99475, 0.92214, 'address', 'openstreetmap:node/5353490007'),
  ('catalogo-cataluna:postal_service:node-5788253456', 'Correos la Selva del Camp – Raval de Sant Pere', NULL, '43145', 'Raval de Sant Pere', NULL, 41.21631, 1.1385, 'address', 'openstreetmap:node/5788253456'),
  ('catalogo-cataluna:postal_service:node-6211313566', 'Correos Vilaverd – carrer de les Escoles', NULL, '43172', 'carrer de les Escoles', NULL, 41.33735, 1.17721, 'address', 'openstreetmap:node/6211313566'),
  ('catalogo-cataluna:postal_service:node-6769062225', 'Correos la Secuita – Carrer Catalunya', NULL, '43144', 'Carrer Catalunya 4', '43765', 41.20535, 1.2801, 'address', 'openstreetmap:node/6769062225'),
  ('catalogo-cataluna:postal_service:node-6833341569', 'Correos Deltebre – Avinguda Esportiva', NULL, '43901', 'Avinguda Esportiva 140', NULL, 40.71957, 0.72945, 'address', 'openstreetmap:node/6833341569'),
  ('catalogo-cataluna:postal_service:node-777010545', 'Correos Alcanar – Carretera nova', NULL, '43004', 'Carretera nova', '43530', 40.54189, 0.479, 'address', 'openstreetmap:node/777010545'),
  ('catalogo-cataluna:postal_service:way-1097535602', 'Correos Tarragona – Carrer Lleida', NULL, '43148', 'Carrer Lleida 7', '43001', 41.11518, 1.24929, 'address', 'openstreetmap:way/1097535602'),
  ('catalogo-cataluna:postal_service:way-722044766', 'Correos Sant Jaume dels Domenys – Plaça de Joan Roig', NULL, '43137', 'Plaça de Joan Roig 2', '43713', 41.29919, 1.5588, 'address', 'openstreetmap:way/722044766'),
  ('catalogo-cataluna:postal_service:way-741185878', 'Correos l''Espluga de Francolí – Carrer d''Àngel Guimerà', NULL, '43054', 'Carrer d''Àngel Guimerà 6', '43440', 41.39456, 1.09894, 'address', 'openstreetmap:way/741185878'),
  ('catalogo-cataluna:postal_service:way-755758528', 'Correos el Vendrell – la Rambla', NULL, '43163', 'la Rambla 33', '43700', 41.22145, 1.53743, 'address', 'openstreetmap:way/755758528');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '43');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 43 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '43'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 35 THEN
    RAISE EXCEPTION 'Se esperaban 35 puntos de Correos en Tarragona, hay %', n;
  END IF;
END;
$$;

COMMIT;

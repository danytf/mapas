-- Carga de la categoría Estaciones de Girona (provincia 17), trozo de la carga de Andalucía.
-- Origen: estaciones-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 48 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-cataluna:estaciones:node-10688847495', 'Estación de autobuses de Teisa 1920 (Banyoles) – Avinguda Països Catalans', 'Autobús', '17015', 'Avinguda Països Catalans 23', '17820', 42.1171, 2.76418, 'address', 'openstreetmap:node/10688847495'),
  ('catalogo-cataluna:estaciones:node-1914054304', 'Estación de tren de Figueres Vilafant', 'Tren', '17221', NULL, NULL, 42.2647, 2.94268, 'address', 'openstreetmap:node/1914054304'),
  ('catalogo-cataluna:estaciones:node-1996338625', 'Estación de tren de Colera – Carrer de l''estació', 'Tren', '17054', 'Carrer de l''estació', NULL, 42.407, 3.15418, 'address', 'openstreetmap:node/1996338625'),
  ('catalogo-cataluna:estaciones:node-1998634565', 'Estación de tren de Llançà – Plaça de l''Estació', 'Tren', '17092', 'Plaça de l''Estació', '17490', 42.3668, 3.14916, 'address', 'openstreetmap:node/1998634565'),
  ('catalogo-cataluna:estaciones:node-2412639596', 'Estación de tren de Urtx-Alp (Fontanals de Cerdanya) – Camí de l''Estació', 'Tren', '17069', 'Camí de l''Estació', NULL, 42.3765, 1.89683, 'address', 'openstreetmap:node/2412639596'),
  ('catalogo-cataluna:estaciones:node-2483779639', 'Estación de tren de Fornells de la Selva – Carrer Caterina Albert', 'Tren', '17073', 'Carrer Caterina Albert', NULL, 41.93497, 2.80947, 'address', 'openstreetmap:node/2483779639'),
  ('catalogo-cataluna:estaciones:node-2725830566', 'Estación de tren de Toses – Carrer Major', 'Tren', '17201', 'Carrer Major', NULL, 42.32075, 2.01513, 'address', 'openstreetmap:node/2725830566'),
  ('catalogo-cataluna:estaciones:node-3167917957', 'Estació d''Autobusos de Torroella de Montgrí – Carrer d''Enric Morera', 'Autobús', '17199', 'Carrer d''Enric Morera', NULL, 42.04185, 3.13033, 'address', 'openstreetmap:node/3167917957'),
  ('catalogo-cataluna:estaciones:node-3337905451', 'Estació d''autobusos (Girona) – Plaça d''Espanya', 'Autobús', '17079', 'Plaça d''Espanya', '17002', 41.97881, 2.81591, 'address', 'openstreetmap:node/3337905451'),
  ('catalogo-cataluna:estaciones:node-5330131966', 'Estación de tren de Bordils - Juià – C-66 Carretera Besalú-Banyoles-Girona-Palamós', 'Tren', '17087', 'C-66 Carretera Besalú-Banyoles-Girona-Palamós', NULL, 42.03698, 2.9153, 'address', 'openstreetmap:node/5330131966'),
  ('catalogo-cataluna:estaciones:node-5334025975', 'Estación de tren de Riudellots de la Selva – Carrer Estació', 'Tren', '17150', 'Carrer Estació', NULL, 41.89616, 2.81174, 'address', 'openstreetmap:node/5334025975'),
  ('catalogo-cataluna:estaciones:node-5418197107', 'Estación de tren de Portbou – Carrer del Mercat', 'Tren', '17138', 'Carrer del Mercat 1', '17497', 42.4248, 3.15801, 'address', 'openstreetmap:node/5418197107'),
  ('catalogo-cataluna:estaciones:node-5419793198', 'Estación de tren de Ribes-Enllaç (Ribes de Freser) – Eix Pirinenc', 'Tren', '17145', 'Eix Pirinenc', NULL, 42.29973, 2.16606, 'approximate', 'openstreetmap:node/5419793198'),
  ('catalogo-cataluna:estaciones:node-5419793235', 'Estación de tren de Ribes de Freser – Eix Pirinenc', 'Tren', '17145', 'Eix Pirinenc', NULL, 42.29919, 2.16546, 'approximate', 'openstreetmap:node/5419793235'),
  ('catalogo-cataluna:estaciones:node-5419793251', 'Estación de tren de Queralbs', 'Tren', '17043', NULL, NULL, 42.35138, 2.16559, 'address', 'openstreetmap:node/5419793251'),
  ('catalogo-cataluna:estaciones:node-5419793252', 'Estación de tren de Ribes-Vila (Ribes de Freser) – Carrer de la Mare de Déu de Gràcia', 'Tren', '17145', 'Carrer de la Mare de Déu de Gràcia', '17534', 42.30862, 2.17168, 'address', 'openstreetmap:node/5419793252'),
  ('catalogo-cataluna:estaciones:node-5420064209', 'Estación de tren de Puigcerdà – Carrer de l''Estació', 'Tren', '17141', 'Carrer de l''Estació', '17520', 42.42937, 1.92456, 'address', 'openstreetmap:node/5420064209'),
  ('catalogo-cataluna:estaciones:node-5420064211', 'Estación de tren de Planoles – Carrer de l''Estació', 'Tren', '17134', 'Carrer de l''Estació', '17535', 42.31431, 2.09979, 'address', 'openstreetmap:node/5420064211'),
  ('catalogo-cataluna:estaciones:node-5420064986', 'Estación de tren de la Molina (Alp) – Avinguda d''Alp', 'Tren', '17006', 'Avinguda d''Alp 8', '17537', 42.34452, 1.95581, 'address', 'openstreetmap:node/5420064986'),
  ('catalogo-cataluna:estaciones:node-5420065123', 'Estación de tren de Campdevànol – Plaça de l''Estació', 'Tren', '17036', 'Plaça de l''Estació', '17530', 42.22165, 2.16577, 'address', 'openstreetmap:node/5420065123'),
  ('catalogo-cataluna:estaciones:node-5420065124', 'Estación de tren de Ripoll – Carrer del Progrés', 'Tren', '17147', 'Carrer del Progrés', '17500', 42.19551, 2.19616, 'address', 'openstreetmap:node/5420065124'),
  ('catalogo-cataluna:estaciones:node-7403526266', 'Estación de tren de Maçanet Massanes (Maçanet de la Selva)', 'Tren', '17103', NULL, NULL, 41.77217, 2.67338, 'address', 'openstreetmap:node/7403526266'),
  ('catalogo-cataluna:estaciones:node-7403526277', 'Estación de tren de Blanes – Avinguda de l''Estació', 'Tren', '17023', 'Avinguda de l''Estació', NULL, 41.67334, 2.76901, 'address', 'openstreetmap:node/7403526277'),
  ('catalogo-cataluna:estaciones:node-7403579018', 'Estación de tren de Sils – Plaça de l''estació', 'Tren', '17193', 'Plaça de l''estació', '17410', 41.80748, 2.74501, 'address', 'openstreetmap:node/7403579018'),
  ('catalogo-cataluna:estaciones:node-7482996472', 'Estación de tren de Riells i Viabrea - Breda – Avinguda de Mossèn Pere Ribot', 'Tren', '17146', 'Avinguda de Mossèn Pere Ribot', NULL, 41.72649, 2.56869, 'address', 'openstreetmap:node/7482996472'),
  ('catalogo-cataluna:estaciones:node-7482996482', 'Estación de tren de Hostalric – Carrer de Bonaventura Codina', 'Tren', '17083', 'Carrer de Bonaventura Codina', NULL, 41.7479, 2.63167, 'address', 'openstreetmap:node/7482996482'),
  ('catalogo-cataluna:estaciones:node-7490586749', 'Estación de tren de Celrà – Carrer de Joan Miró', 'Tren', '17049', 'Carrer de Joan Miró', '17460', 42.02732, 2.87485, 'address', 'openstreetmap:node/7490586749'),
  ('catalogo-cataluna:estaciones:node-7490586752', 'Estación de tren de Girona – Parc Central de Rafael Masó i Valentí', 'Tren', '17079', 'Parc Central de Rafael Masó i Valentí 1', '17002', 41.97917, 2.81629, 'address', 'openstreetmap:node/7490586752'),
  ('catalogo-cataluna:estaciones:node-7490586755', 'Estación de tren de Caldes de Malavella – Avinguda del Doctor Furest', 'Tren', '17033', 'Avinguda del Doctor Furest', NULL, 41.84116, 2.80057, 'address', 'openstreetmap:node/7490586755'),
  ('catalogo-cataluna:estaciones:node-7504525657', 'Estación de tren de Vilamalla – Camí de l''Estació', 'Tren', '17226', 'Camí de l''Estació', NULL, 42.21637, 2.97803, 'address', 'openstreetmap:node/7504525657'),
  ('catalogo-cataluna:estaciones:node-7504603522', 'Estación de tren de Sant Miquel de Fluvià – Carrer del Forn Romà', 'Tren', '17175', 'Carrer del Forn Romà', NULL, 42.17229, 2.98933, 'address', 'openstreetmap:node/7504603522'),
  ('catalogo-cataluna:estaciones:node-7504603523', 'Estación de tren de Camallera (Saus, Camallera i Llampaies) – Carrer de l''Estació', 'Tren', '17187', 'Carrer de l''Estació', '17465', 42.12222, 2.96561, 'address', 'openstreetmap:node/7504603523'),
  ('catalogo-cataluna:estaciones:node-7504603546', 'Estación de tren de Sant Jordi Desvalls – Carrer de l''Estació', 'Tren', '17166', 'Carrer de l''Estació', NULL, 42.06828, 2.96476, 'address', 'openstreetmap:node/7504603546'),
  ('catalogo-cataluna:estaciones:node-7504603570', 'Estación de tren de Flaçà – Plaça de l''Estació del Carrilet', 'Tren', '17067', 'Plaça de l''Estació del Carrilet', '17463', 42.04749, 2.95717, 'address', 'openstreetmap:node/7504603570'),
  ('catalogo-cataluna:estaciones:node-7512362047', 'Estación de tren de Vilajuïga – Passeig de l''Estació', 'Tren', '17223', 'Passeig de l''Estació', NULL, 42.32515, 3.0863, 'address', 'openstreetmap:node/7512362047'),
  ('catalogo-cataluna:estaciones:node-7512362062', 'Estación de tren de Figueres – Plaça Estació', 'Tren', '17066', 'Plaça Estació', '17600', 42.26501, 2.96897, 'address', 'openstreetmap:node/7512362062'),
  ('catalogo-cataluna:estaciones:node-7527423071', 'Estación de tren de Núria (Queralbs)', 'Tren', '17043', NULL, NULL, 42.39727, 2.15487, 'address', 'openstreetmap:node/7527423071'),
  ('catalogo-cataluna:estaciones:way-1099806074', 'Estación de autobuses de Cadaques – Riera de Sant Vicenç', 'Autobús', '17032', 'Riera de Sant Vicenç', '17488', 42.28973, 3.27266, 'address', 'openstreetmap:way/1099806074'),
  ('catalogo-cataluna:estaciones:way-1288154966', 'Estació d''autobusos de la Bibsal d''Empordà (la Bisbal d''Empordà) – Carretera de Cruilles', 'Autobús', '17022', 'Carretera de Cruilles', NULL, 41.96265, 3.03404, 'address', 'openstreetmap:way/1288154966'),
  ('catalogo-cataluna:estaciones:way-1513155142', 'Palamós - Estació d''autobusos – Carrer de Francesca Janoher', 'Autobús', '17118', 'Carrer de Francesca Janoher', NULL, 41.85442, 3.12661, 'address', 'openstreetmap:way/1513155142'),
  ('catalogo-cataluna:estaciones:way-164920340', 'Terminal Sant Feliu de Guíxols – Carrer dels Enamorats', 'Autobús', '17160', 'Carrer dels Enamorats', NULL, 41.78077, 3.02267, 'address', 'openstreetmap:way/164920340'),
  ('catalogo-cataluna:estaciones:way-167677073', 'Estació d''Autobusos de Palafrugell – Carrer de Lluís Companys', 'Autobús', '17117', 'Carrer de Lluís Companys', '17200', 41.91586, 3.15814, 'address', 'openstreetmap:way/167677073'),
  ('catalogo-cataluna:estaciones:way-222348469', 'Estació d''Autobusos de Ripoll – Carrer del Progrés', 'Autobús', '17147', 'Carrer del Progrés', '17500', 42.19697, 2.19527, 'address', 'openstreetmap:way/222348469'),
  ('catalogo-cataluna:estaciones:way-347069023', 'Estació d''autobusos (Santa Coloma de Farners) – Carrer Sant Sebastià', 'Autobús', '17180', 'Carrer Sant Sebastià 91', NULL, 41.86145, 2.6675, 'address', 'openstreetmap:way/347069023'),
  ('catalogo-cataluna:estaciones:way-356274525', 'Tossa de Mar estació d''autobusos – Carrer de Lluís Companys', 'Autobús', '17202', 'Carrer de Lluís Companys', '17320', 41.72111, 2.92761, 'address', 'openstreetmap:way/356274525'),
  ('catalogo-cataluna:estaciones:way-742277247', 'Estació d''autobusos (Sant Hilari Sacalm) – Carrer de Joan Serrallonga', 'Autobús', '17164', 'Carrer de Joan Serrallonga', '17403', 41.87822, 2.5084, 'address', 'openstreetmap:way/742277247'),
  ('catalogo-cataluna:estaciones:way-86454289', 'Estació d''autobusos de Figueres – Carrer de Joan Reglà', 'Autobús', '17066', 'Carrer de Joan Reglà', '17600', 42.26438, 2.96744, 'address', 'openstreetmap:way/86454289'),
  ('catalogo-cataluna:estaciones:way-946479955', 'Estació de busos (Roses) – Riera Ginjolers', 'Autobús', '17152', 'Riera Ginjolers', '17480', 42.26488, 3.18063, 'address', 'openstreetmap:way/946479955');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '17');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 17 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '17'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 48 THEN
    RAISE EXCEPTION 'Se esperaban 48 puntos de Estaciones en Girona, hay %', n;
  END IF;
END;
$$;

COMMIT;

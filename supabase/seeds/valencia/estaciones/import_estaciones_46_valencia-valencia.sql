-- Carga de la categoría Estaciones de Valencia/València (provincia 46), trozo de la carga de Andalucía.
-- Origen: estaciones-valencia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 71 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-valencia:estaciones:node-1013407340', 'Estación de tren de Massalfassar', 'Tren', '46163', NULL, NULL, 39.55568, -0.31812, 'address', 'openstreetmap:node/1013407340'),
  ('catalogo-valencia:estaciones:node-10186542246', 'Estación de tren de la Pobla del Duc', 'Tren', '46200', NULL, NULL, 38.91529, -0.44584, 'address', 'openstreetmap:node/10186542246'),
  ('catalogo-valencia:estaciones:node-1064038509', 'Estación de tren de Requena - Utiel', 'Tren', '46213', NULL, NULL, 39.52175, -1.13473, 'address', 'openstreetmap:node/1064038509'),
  ('catalogo-valencia:estaciones:node-1067401293', 'Estación de tren de Albuixech – Carrer de l''Apeadero', 'Tren', '46014', 'Carrer de l''Apeadero', NULL, 39.5431, -0.32053, 'address', 'openstreetmap:node/1067401293'),
  ('catalogo-valencia:estaciones:node-10922195557', 'Estación de tren de Xeraco – Avinguda Hort Mandarí', 'Tren', '46143', 'Avinguda Hort Mandarí', NULL, 39.02621, -0.21498, 'address', 'openstreetmap:node/10922195557'),
  ('catalogo-valencia:estaciones:node-10922195558', 'Estación de tren de Gandia – Plaça parc de l''estació', 'Tren', '46131', 'Plaça parc de l''estació', '46701', 38.97035, -0.18006, 'address', 'openstreetmap:node/10922195558'),
  ('catalogo-valencia:estaciones:node-1113636763', 'Estación de tren de Circuit Ricardo Tormo (Cheste) – Carretera de Cheste a Loriguilla', 'Tren', '46109', 'Carretera de Cheste a Loriguilla', '46380', 39.4955, -0.62556, 'address', 'openstreetmap:node/1113636763'),
  ('catalogo-valencia:estaciones:node-13648571953', 'Estación de tren de Xàtiva – Carrer Ausiàs March', 'Tren', '46145', 'Carrer Ausiàs March', NULL, 38.99225, -0.52468, 'address', 'openstreetmap:node/13648571953'),
  ('catalogo-valencia:estaciones:node-137562911', 'Estación de tren de el Romaní (Sollana) – Plaça Mare de Déu d''Aigües Vives', 'Tren', '46233', 'Plaça Mare de Déu d''Aigües Vives', NULL, 39.30296, -0.39407, 'address', 'openstreetmap:node/137562911'),
  ('catalogo-valencia:estaciones:node-14243510920', 'Estación de tren de València Cabanyal – Avinguda de Blasco Ibáñez', 'Tren', '46250', 'Avinguda de Blasco Ibáñez', '46022', 39.47011, -0.33459, 'address', 'openstreetmap:node/14243510920'),
  ('catalogo-valencia:estaciones:node-14287115776', 'Estación de tren de Utiel – Plaza Estación', 'Tren', '46249', 'Plaza Estación 5', '46300', 39.57062, -1.20246, 'address', 'openstreetmap:node/14287115776'),
  ('catalogo-valencia:estaciones:node-1590401840', 'Estación de autobuses de Gandient (Sueca) – Carrer de Polinyà', 'Autobús', '46235', 'Carrer de Polinyà', NULL, 39.20386, -0.31655, 'address', 'openstreetmap:node/1590401840'),
  ('catalogo-valencia:estaciones:node-2379638924', 'Estación de tren de Benigànim – Carrer Pintor Gomar', 'Tren', '46062', 'Carrer Pintor Gomar', NULL, 38.93833, -0.45323, 'address', 'openstreetmap:node/2379638924'),
  ('catalogo-valencia:estaciones:node-359544261', 'Estación de tren de Gilet – Plaça de l''Església', 'Tren', '46134', 'Plaça de l''Església', NULL, 39.67941, -0.32066, 'address', 'openstreetmap:node/359544261'),
  ('catalogo-valencia:estaciones:node-366942270', 'Estación de tren de Algimia-Ciudad (Algímia d''Alfara) – Carrer del Picaio', 'Tren', '46030', 'Carrer del Picaio', NULL, 39.75296, -0.36577, 'address', 'openstreetmap:node/366942270'),
  ('catalogo-valencia:estaciones:node-3973025564', 'Estación de tren de Catarroja – Ronda de l''Est', 'Tren', '46094', 'Ronda de l''Est', '46470', 39.40007, -0.39919, 'address', 'openstreetmap:node/3973025564'),
  ('catalogo-valencia:estaciones:node-3973025583', 'Estación de tren de Massanassa – Carrer Federico Garcia Lorca', 'Tren', '46165', 'Carrer Federico Garcia Lorca 18', '46470', 39.40917, -0.39532, 'address', 'openstreetmap:node/3973025583'),
  ('catalogo-valencia:estaciones:node-3973594599', 'Estación de tren de Alfafar - Benetússer – Carrer Estació', 'Tren', '46022', 'Carrer Estació 1', '46910', 39.42233, -0.39259, 'address', 'openstreetmap:node/3973594599'),
  ('catalogo-valencia:estaciones:node-3973594649', 'Estación de tren de Silla – Passeig de l''Albereda', 'Tren', '46230', 'Passeig de l''Albereda 16', NULL, 39.36176, -0.41494, 'address', 'openstreetmap:node/3973594649'),
  ('catalogo-valencia:estaciones:node-3974050269', 'Estación de tren de Sollana – Carretera de València', 'Tren', '46233', 'Carretera de València', NULL, 39.27928, -0.37906, 'address', 'openstreetmap:node/3974050269'),
  ('catalogo-valencia:estaciones:node-3974050289', 'Estación de tren de Sueca – Avinguda del Ferrocarril', 'Tren', '46235', 'Avinguda del Ferrocarril', '46410', 39.2058, -0.30799, 'address', 'openstreetmap:node/3974050289'),
  ('catalogo-valencia:estaciones:node-3974050309', 'Estación de tren de Cullera – Carrer de Sueca', 'Tren', '46105', 'Carrer de Sueca', NULL, 39.17794, -0.26349, 'address', 'openstreetmap:node/3974050309'),
  ('catalogo-valencia:estaciones:node-4004837188', 'Estación de tren de Platja i Grau de Gandia – Avinguda d''Europa', 'Tren', '46131', 'Avinguda d''Europa', NULL, 38.99022, -0.16242, 'address', 'openstreetmap:node/4004837188'),
  ('catalogo-valencia:estaciones:node-421812400', 'Estación de tren de Venta Mina-Siete Aguas', 'Tren', '46229', NULL, '46392', 39.45427, -0.87021, 'address', 'openstreetmap:node/421812400'),
  ('catalogo-valencia:estaciones:node-421888307', 'Estación de tren de Siete Aguas', 'Tren', '46229', NULL, NULL, 39.45739, -0.90201, 'address', 'openstreetmap:node/421888307'),
  ('catalogo-valencia:estaciones:node-421931324', 'Estación de tren de El Rebollar (Requena)', 'Tren', '46213', NULL, NULL, 39.47736, -1.0117, 'address', 'openstreetmap:node/421931324'),
  ('catalogo-valencia:estaciones:node-500847066', 'Estación de tren de Moixent (Moixent / Mogente) – Carrer Gandia', 'Tren', '46170', 'Carrer Gandia', NULL, 38.87813, -0.75309, 'address', 'openstreetmap:node/500847066'),
  ('catalogo-valencia:estaciones:node-500857327', 'Estación de tren de Alzira – Carrer l''Estació', 'Tren', '46017', 'Carrer l''Estació', NULL, 39.1532, -0.45068, 'address', 'openstreetmap:node/500857327'),
  ('catalogo-valencia:estaciones:node-500857328', 'Estación de tren de Algemesí – Ronda del Calvari', 'Tren', '46029', 'Ronda del Calvari 1', '46680', 39.19315, -0.44093, 'address', 'openstreetmap:node/500857328'),
  ('catalogo-valencia:estaciones:node-500857331', 'Estación de tren de L''Ènova - Manuel', 'Tren', '46119', NULL, NULL, 39.0502, -0.47733, 'address', 'openstreetmap:node/500857331'),
  ('catalogo-valencia:estaciones:node-500857332', 'Estación de tren de La Pobla Llarga – Carrer Barri de l''Estació', 'Tren', '46203', 'Carrer Barri de l''Estació', '46670', 39.08329, -0.46963, 'address', 'openstreetmap:node/500857332'),
  ('catalogo-valencia:estaciones:node-503196005', 'Estación de tren de Les Valls (Sagunt / Sagunto) – Camí Vell d''Almenara', 'Tren', '46220', 'Camí Vell d''Almenara', NULL, 39.71926, -0.23965, 'address', 'openstreetmap:node/503196005'),
  ('catalogo-valencia:estaciones:node-5180084622', 'Estación de tren de el Genovés – Carrer de Sant Joan', 'Tren', '46132', 'Carrer de Sant Joan', NULL, 38.97458, -0.48516, 'address', 'openstreetmap:node/5180084622'),
  ('catalogo-valencia:estaciones:node-5180084624', 'Estación de tren de Montaverner – Ronda del Tren', 'Tren', '46173', 'Ronda del Tren', NULL, 38.88406, -0.4915, 'address', 'openstreetmap:node/5180084624'),
  ('catalogo-valencia:estaciones:node-5180084625', 'Estación de tren de Bufali – Carrer del l''Estació', 'Tren', '46075', 'Carrer del l''Estació', NULL, 38.86736, -0.51048, 'address', 'openstreetmap:node/5180084625'),
  ('catalogo-valencia:estaciones:node-5180084626', 'Estación de tren de Agullent', 'Tren', '46004', NULL, NULL, 38.83056, -0.5512, 'address', 'openstreetmap:node/5180084626'),
  ('catalogo-valencia:estaciones:node-5180084627', 'Estación de tren de Ontinyent', 'Tren', '46184', NULL, NULL, 38.80941, -0.60247, 'address', 'openstreetmap:node/5180084627'),
  ('catalogo-valencia:estaciones:node-688952420', 'Estación de tren de Tavernes de la Valldigna – Carrer de la Partida', 'Tren', '46238', 'Carrer de la Partida', '46760', 39.07899, -0.22614, 'address', 'openstreetmap:node/688952420'),
  ('catalogo-valencia:estaciones:node-7221315770', 'Estación de tren de Roca-Cúper (Meliana) – Carrer de Sant Isidre', 'Tren', '46166', 'Carrer de Sant Isidre', NULL, 39.52649, -0.32371, 'address', 'openstreetmap:node/7221315770'),
  ('catalogo-valencia:estaciones:node-7221315771', 'Estación de tren de El Puig (el Puig de Santa Maria) – Carrer de l''Estació', 'Tren', '46204', 'Carrer de l''Estació', NULL, 39.58819, -0.3119, 'address', 'openstreetmap:node/7221315771'),
  ('catalogo-valencia:estaciones:node-7221315772', 'Estación de tren de Puçol – Carrer de la Font de Mora', 'Tren', '46205', 'Carrer de la Font de Mora', NULL, 39.62049, -0.3031, 'address', 'openstreetmap:node/7221315772'),
  ('catalogo-valencia:estaciones:node-7221315773', 'Estación de tren de Sagunt (Sagunt / Sagunto) – Carrer de Honorio Maura', 'Tren', '46220', 'Carrer de Honorio Maura', NULL, 39.67567, -0.27142, 'address', 'openstreetmap:node/7221315773'),
  ('catalogo-valencia:estaciones:node-7229825437', 'Estación de tren de València - La Font de Sant Lluís', 'Tren', '46250', NULL, '46026', 39.44153, -0.37146, 'address', 'openstreetmap:node/7229825437'),
  ('catalogo-valencia:estaciones:node-7246471727', 'Estación de tren de València Joaquín Sorolla – Carrer de Francisco Largo Caballero', 'Tren', '46250', 'Carrer de Francisco Largo Caballero', '46007', 39.46005, -0.38121, 'address', 'openstreetmap:node/7246471727'),
  ('catalogo-valencia:estaciones:node-7246471728', 'València - Estació del Nord – Carrer de Xàtiva', 'Tren', '46250', 'Carrer de Xàtiva 24', '46007', 39.46691, -0.37719, 'address', 'openstreetmap:node/7246471728'),
  ('catalogo-valencia:estaciones:node-7731911225', 'Estación de tren de Albaida', 'Tren', '46006', NULL, NULL, 38.84468, -0.52241, 'address', 'openstreetmap:node/7731911225'),
  ('catalogo-valencia:estaciones:node-838494405', 'Estación de tren de Aldaia – Carrer de Luis Portabella', 'Tren', '46021', 'Carrer de Luis Portabella', NULL, 39.46096, -0.46375, 'address', 'openstreetmap:node/838494405'),
  ('catalogo-valencia:estaciones:relation-13038871', 'Estació d''autobusos Alzira – Carrer de Santo Domingo de Guzmán', 'Autobús', '46017', 'Carrer de Santo Domingo de Guzmán 6', '46600', 39.14833, -0.44128, 'address', 'openstreetmap:relation/13038871'),
  ('catalogo-valencia:estaciones:way-1070270383', 'Estación de tren de Loriguilla - Reva – 18', 'Tren', '46148', '18', '46393', 39.48567, -0.56738, 'address', 'openstreetmap:way/1070270383'),
  ('catalogo-valencia:estaciones:way-1079273858', 'Estación de tren de Alberic – Carrer d''Alcàntera de Xúquer', 'Tren', '46011', 'Carrer d''Alcàntera de Xúquer', NULL, 39.11702, -0.5235, 'address', 'openstreetmap:way/1079273858'),
  ('catalogo-valencia:estaciones:way-118251593', 'Estación de Autobuses de València – Avenida Menéndez Pidal', 'Autobús', '46250', 'Avenida Menéndez Pidal 11', '46009', 39.48117, -0.38838, 'address', 'openstreetmap:way/118251593'),
  ('catalogo-valencia:estaciones:way-1232256971', 'Estación de tren de Carcaixent – Plaça Glorieta de l''Estació', 'Tren', '46083', 'Plaça Glorieta de l''Estació', NULL, 39.12051, -0.45455, 'address', 'openstreetmap:way/1232256971'),
  ('catalogo-valencia:estaciones:way-1232256975', 'Estación de tren de l''Alcúdia de Crespins – Plaça Mariano Benlliure', 'Tren', '46020', 'Plaça Mariano Benlliure', '46690', 38.96917, -0.58651, 'address', 'openstreetmap:way/1232256975'),
  ('catalogo-valencia:estaciones:way-1232256978', 'Estación de tren de Montesa', 'Tren', '46174', NULL, NULL, 38.94256, -0.64166, 'address', 'openstreetmap:way/1232256978'),
  ('catalogo-valencia:estaciones:way-1295673595', 'Estación de tren de Albal – Carrer del Riu Albaida', 'Tren', '46007', 'Carrer del Riu Albaida', NULL, 39.3915, -0.40276, 'address', 'openstreetmap:way/1295673595'),
  ('catalogo-valencia:estaciones:way-1430577213', 'Estació d''Autobusos de Xàtiva – Carrer de Don Carlos Sarthou', 'Autobús', '46145', 'Carrer de Don Carlos Sarthou', NULL, 38.99233, -0.52162, 'address', 'openstreetmap:way/1430577213'),
  ('catalogo-valencia:estaciones:way-1431213574', 'Estació d''Autobusos d''Ontinyent – Avinguda de Benicadell', 'Autobús', '46184', 'Avinguda de Benicadell', NULL, 38.82138, -0.59683, 'address', 'openstreetmap:way/1431213574'),
  ('catalogo-valencia:estaciones:way-233639794', 'Estación de tren de València Sud', 'Tren', '46250', NULL, NULL, 39.44084, -0.41093, 'address', 'openstreetmap:way/233639794'),
  ('catalogo-valencia:estaciones:way-239575904', 'Estació d''Autobusos de Gandia – Plaça parc de l''estació', 'Autobús', '46131', 'Plaça parc de l''estació', '46701', 38.97062, -0.18016, 'address', 'openstreetmap:way/239575904'),
  ('catalogo-valencia:estaciones:way-261880273', 'Estación de tren de València - Sant Isidre – Carrer dels Gremis', 'Tren', '46250', 'Carrer dels Gremis', '46014', 39.45124, -0.40503, 'address', 'openstreetmap:way/261880273'),
  ('catalogo-valencia:estaciones:way-410233142', 'Estación de tren de Benifaió - Almussafes – Plaça de l''Estació', 'Tren', '46060', 'Plaça de l''Estació 15', '46450', 39.2842, -0.42999, 'address', 'openstreetmap:way/410233142'),
  ('catalogo-valencia:estaciones:way-473559642', 'Estación de tren de Vallada', 'Tren', '46251', NULL, NULL, 38.91134, -0.68533, 'address', 'openstreetmap:way/473559642'),
  ('catalogo-valencia:estaciones:way-549815360', 'Parada de autobus (Manuel) – Carrer les Foies', 'Autobús', '46160', 'Carrer les Foies 1', '46660', 39.05231, -0.49566, 'approximate', 'openstreetmap:way/549815360'),
  ('catalogo-valencia:estaciones:way-639191099', 'Estación de tren de San Antonio de Requena – Calle Ferrocarril', 'Tren', '46213', 'Calle Ferrocarril 4', '46390', 39.52221, -1.15038, 'address', 'openstreetmap:way/639191099'),
  ('catalogo-valencia:estaciones:way-652089933', 'Estación de tren de Xirivella - Alqueries – Plaça de la Comare Rosario Soler', 'Tren', '46110', 'Plaça de la Comare Rosario Soler 2', '46950', 39.4626, -0.43222, 'address', 'openstreetmap:way/652089933'),
  ('catalogo-valencia:estaciones:way-656119181', 'Estación de tren de Chiva – Avenida de la Estación', 'Tren', '46111', 'Avenida de la Estación 8', '46370', 39.47105, -0.72292, 'address', 'openstreetmap:way/656119181'),
  ('catalogo-valencia:estaciones:way-659253286', 'Estación de tren de Buñol – Carretera de la Estación', 'Tren', '46077', 'Carretera de la Estación', '46360', 39.4271, -0.7874, 'address', 'openstreetmap:way/659253286'),
  ('catalogo-valencia:estaciones:way-659646337', 'Estación de tren de Cheste – Calle de Godelleta', 'Tren', '46109', 'Calle de Godelleta 38', '46380', 39.49078, -0.68627, 'address', 'openstreetmap:way/659646337'),
  ('catalogo-valencia:estaciones:way-718974447', 'Estación de tren de Estivella - Albalat dels Tarongers', 'Tren', '46120', NULL, NULL, 39.70629, -0.34822, 'address', 'openstreetmap:way/718974447'),
  ('catalogo-valencia:estaciones:way-809554606', 'Estación de tren de Requena – Calle Ferrocarril 2B', 'Tren', '46213', 'Calle Ferrocarril 2B', '46340', 39.49115, -1.10466, 'address', 'openstreetmap:way/809554606'),
  ('catalogo-valencia:estaciones:way-889391004', 'Estación de tren de Albalat dels Sorells – Carrer d''en Codinats', 'Tren', '46009', 'Carrer d''en Codinats', NULL, 39.54533, -0.34798, 'address', 'openstreetmap:way/889391004');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '46');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 46 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '46'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 71 THEN
    RAISE EXCEPTION 'Se esperaban 71 puntos de Estaciones en Valencia/València, hay %', n;
  END IF;
END;
$$;

COMMIT;

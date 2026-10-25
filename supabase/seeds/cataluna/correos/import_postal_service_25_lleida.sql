-- Carga de la categoría Correos de Lleida (provincia 25), trozo de la carga de Andalucía.
-- Origen: postal_service-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 44 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-cataluna:postal_service:node-10124718252', 'Correos Aitona – Avinguda 27 de gener', NULL, '25038', 'Avinguda 27 de gener 69', '25182', 41.4955, 0.4607, 'address', 'openstreetmap:node/10124718252'),
  ('catalogo-cataluna:postal_service:node-10131365607', 'Correos Bell-lloc d''Urgell – Plaça Catalunya', NULL, '25048', 'Plaça Catalunya 14', '25220', 41.63019, 0.78136, 'address', 'openstreetmap:node/10131365607'),
  ('catalogo-cataluna:postal_service:node-10133857785', 'Correos Artesa de Lleida – Carrer Nou', NULL, '25033', 'Carrer Nou 32', '25150', 41.55259, 0.70239, 'address', 'openstreetmap:node/10133857785'),
  ('catalogo-cataluna:postal_service:node-10731520815', 'Correos Montellà i Martinet – Carrer de la Cerdanya', NULL, '25139', 'Carrer de la Cerdanya', '25724', 42.36019, 1.69496, 'address', 'openstreetmap:node/10731520815'),
  ('catalogo-cataluna:postal_service:node-11151125405', 'Correos Rialp – avinguda de la Generalitat', NULL, '25183', 'avinguda de la Generalitat', '25594', 42.444, 1.13403, 'address', 'openstreetmap:node/11151125405'),
  ('catalogo-cataluna:postal_service:node-11248467129', 'Correos Ponts – Avinguda del Passeig', NULL, '25172', 'Avinguda del Passeig 26', '25740', 41.91441, 1.18616, 'address', 'openstreetmap:node/11248467129'),
  ('catalogo-cataluna:postal_service:node-11816207692', 'Correos Verdú – Carrer de Sant Pere Claver', NULL, '25242', 'Carrer de Sant Pere Claver 9', '25340', 41.61059, 1.14315, 'address', 'openstreetmap:node/11816207692'),
  ('catalogo-cataluna:postal_service:node-11987214590', 'Correos Bellvís – Plaça de la Verge de les Sogues', NULL, '25052', 'Plaça de la Verge de les Sogues 18', '25142', 41.67267, 0.81781, 'address', 'openstreetmap:node/11987214590'),
  ('catalogo-cataluna:postal_service:node-12092239144', 'Correos Artesa de Segre – Carrer de Balmes', NULL, '25034', 'Carrer de Balmes 25', '25730', 41.89546, 1.04459, 'address', 'openstreetmap:node/12092239144'),
  ('catalogo-cataluna:postal_service:node-12098702998', 'Correos Linyola – Carrer de Pons i Arola', NULL, '25122', 'Carrer de Pons i Arola 26', '25240', 41.70958, 0.9027, 'address', 'openstreetmap:node/12098702998'),
  ('catalogo-cataluna:postal_service:node-12254732438', 'Correos Almenar – Carrer Espadós', NULL, '25021', 'Carrer Espadós 2', '25126', 41.79702, 0.56842, 'address', 'openstreetmap:node/12254732438'),
  ('catalogo-cataluna:postal_service:node-12547891119', 'Correos Anglesola – Carrer de Montmassat', NULL, '25027', 'Carrer de Montmassat 2', '25320', 41.65918, 1.08295, 'address', 'openstreetmap:node/12547891119'),
  ('catalogo-cataluna:postal_service:node-12554470786', 'Correos Bellpuig – Avinguda d''Urgell', NULL, '25050', 'Avinguda d''Urgell 14', '25250', 41.62866, 1.00809, 'address', 'openstreetmap:node/12554470786'),
  ('catalogo-cataluna:postal_service:node-12560495698', 'Correos Juneda – Carrer de La Font', NULL, '25119', 'Carrer de La Font 6', '25430', 41.54783, 0.82535, 'address', 'openstreetmap:node/12560495698'),
  ('catalogo-cataluna:postal_service:node-12912776809', 'Correos Golmés – Carrer el Pla', NULL, '25099', 'Carrer el Pla 4', '25241', 41.63382, 0.93755, 'address', 'openstreetmap:node/12912776809'),
  ('catalogo-cataluna:postal_service:node-13283162599', 'Correos Llardecans – Plaça dels Arbres', NULL, '25125', 'Plaça dels Arbres 2', '25186', 41.37395, 0.55052, 'address', 'openstreetmap:node/13283162599'),
  ('catalogo-cataluna:postal_service:node-13383854045', 'Correos Alguaire – Plaça de l''Església', NULL, '25016', 'Plaça de l''Església 15', '25125', 41.73647, 0.58301, 'address', 'openstreetmap:node/13383854045'),
  ('catalogo-cataluna:postal_service:node-1352199473', 'Correos la Seu d''Urgell – Carrer Josep de Zulueta', NULL, '25203', 'Carrer Josep de Zulueta', '25700', 42.35574, 1.45579, 'address', 'openstreetmap:node/1352199473'),
  ('catalogo-cataluna:postal_service:node-13577428534', 'Correos Gimenells i el Pla de la Font – Carrer del Doctor Sarrat', NULL, '25912', 'Carrer del Doctor Sarrat 5', '25112', 41.65274, 0.38964, 'address', 'openstreetmap:node/13577428534'),
  ('catalogo-cataluna:postal_service:node-13588531436', 'Correos Térmens – Plaça de Catalunya', NULL, '25220', 'Plaça de Catalunya 1', '25670', 41.71716, 0.76023, 'address', 'openstreetmap:node/13588531436'),
  ('catalogo-cataluna:postal_service:node-13629847746', 'Correos Benavent de Segrià – Avinguda de Lleida', NULL, '25053', 'Avinguda de Lleida 4', '25132', 41.69458, 0.63417, 'address', 'openstreetmap:node/13629847746'),
  ('catalogo-cataluna:postal_service:node-1378714474', 'Correos Torres de Segre – Carrer Segrià', NULL, '25232', 'Carrer Segrià 10', '25170', 41.53477, 0.51221, 'address', 'openstreetmap:node/1378714474'),
  ('catalogo-cataluna:postal_service:node-1394799772', 'Correos Tremp – Carrer de Francesc Macià', NULL, '25234', 'Carrer de Francesc Macià 4', '25620', 42.16584, 0.89575, 'address', 'openstreetmap:node/1394799772'),
  ('catalogo-cataluna:postal_service:node-14165213433', 'Correos Vilanova de la Barca – Carrer de l''Església', NULL, '25254', 'Carrer de l''Església 27', '25690', 41.69068, 0.72867, 'address', 'openstreetmap:node/14165213433'),
  ('catalogo-cataluna:postal_service:node-14297435679', 'Correos Oliana – Avinguda de l''Alt Urgell', NULL, '25149', 'Avinguda de l''Alt Urgell 46', '25790', 42.06873, 1.31321, 'address', 'openstreetmap:node/14297435679'),
  ('catalogo-cataluna:postal_service:node-1469265618', 'Correos Sort – Avinguda de la Diputació', NULL, '25209', 'Avinguda de la Diputació 3', '25560', 42.40993, 1.12902, 'address', 'openstreetmap:node/1469265618'),
  ('catalogo-cataluna:postal_service:node-1471040917', 'Correos Esterri d''Àneu – Carrer de Sant Vicenç', NULL, '25086', 'Carrer de Sant Vicenç', '25580', 42.62565, 1.12416, 'address', 'openstreetmap:node/1471040917'),
  ('catalogo-cataluna:postal_service:node-1543150813', 'Correos Solsona – Carrer dels Dominics', NULL, '25207', 'Carrer dels Dominics 14', '25280', 41.99605, 1.5195, 'address', 'openstreetmap:node/1543150813'),
  ('catalogo-cataluna:postal_service:node-1709797187', 'Correos Cervera – Passeig de Jaume Balmes', NULL, '25072', 'Passeig de Jaume Balmes 12', '25200', 41.67078, 1.27549, 'address', 'openstreetmap:node/1709797187'),
  ('catalogo-cataluna:postal_service:node-2475747658', 'Correos la Pobla de Segur – Carrer de la Indústria', NULL, '25171', 'Carrer de la Indústria 1', '25500', 42.24925, 0.96644, 'address', 'openstreetmap:node/2475747658'),
  ('catalogo-cataluna:postal_service:node-2605235057', 'Correos Vielha e Mijaran – Carrer de Molières', NULL, '25243', 'Carrer de Molières 2', '25530', 42.70201, 0.80126, 'address', 'openstreetmap:node/2605235057'),
  ('catalogo-cataluna:postal_service:node-3115586927', 'Correos Mollerussa – Passeig del Compositor Beethoven 5A', NULL, '25137', 'Passeig del Compositor Beethoven 5A', '25230', 41.62835, 0.89102, 'address', 'openstreetmap:node/3115586927'),
  ('catalogo-cataluna:postal_service:node-3202475530', 'Correos Sant Guim de Freixenet – Plaça del Doctor Perelló', NULL, '25192', 'Plaça del Doctor Perelló 12', '25270', 41.65594, 1.41832, 'address', 'openstreetmap:node/3202475530'),
  ('catalogo-cataluna:postal_service:node-3387621794', 'Correos Alpicat – Carrer de Lleida', NULL, '25023', 'Carrer de Lleida 117', '25110', 41.66352, 0.55657, 'address', 'openstreetmap:node/3387621794'),
  ('catalogo-cataluna:postal_service:node-3446298596', 'Correos Lleida – Carrer de Segòvia', NULL, '25120', 'Carrer de Segòvia 8', '25006', 41.6185, 0.61327, 'address', 'openstreetmap:node/3446298596'),
  ('catalogo-cataluna:postal_service:node-4328072295', 'Correos Lladorre – Carrer Major', NULL, '25123', 'Carrer Major 7', '25576', 42.62131, 1.24954, 'address', 'openstreetmap:node/4328072295'),
  ('catalogo-cataluna:postal_service:node-4340809909', 'Correos Balaguer – Plaça de Manuel Marín', NULL, '25040', 'Plaça de Manuel Marín 1', '25600', 41.78907, 0.80462, 'address', 'openstreetmap:node/4340809909'),
  ('catalogo-cataluna:postal_service:node-5128662980', 'Correos Àger – Carrer de la Font', NULL, '25002', 'Carrer de la Font 19', '25691', 42.00148, 0.76246, 'address', 'openstreetmap:node/5128662980'),
  ('catalogo-cataluna:postal_service:node-5284300999', 'Correos Guissona – Plaça de la Plana', NULL, '25110', 'Plaça de la Plana 1', '25210', 41.78236, 1.2852, 'address', 'openstreetmap:node/5284300999'),
  ('catalogo-cataluna:postal_service:node-6749914473', 'Correos Alcarràs – Carrer Ricard Vinyes', NULL, '25011', 'Carrer Ricard Vinyes 2', '25180', 41.56706, 0.52265, 'address', 'openstreetmap:node/6749914473'),
  ('catalogo-cataluna:postal_service:node-9202399075', 'Correos les Borges Blanques – Carrer de Sant Jaume', NULL, '25058', 'Carrer de Sant Jaume 1', '25400', 41.52004, 0.8696, 'address', 'openstreetmap:node/9202399075'),
  ('catalogo-cataluna:postal_service:way-145242262', 'Correos Lleida – Rambla de Ferran', NULL, '25120', 'Rambla de Ferran 16', '25007', 41.61729, 0.63017, 'address', 'openstreetmap:way/145242262'),
  ('catalogo-cataluna:postal_service:way-254847540', 'Correos Vielha e Mijaran – Carrer Sarriulera', NULL, '25243', 'Carrer Sarriulera 4', '25530', 42.70159, 0.79536, 'address', 'openstreetmap:way/254847540'),
  ('catalogo-cataluna:postal_service:way-959877094', 'Correos Bossòst – Passeg Grauèr d''Eduard Aunós', NULL, '25059', 'Passeg Grauèr d''Eduard Aunós 1', '25550', 42.78458, 0.69274, 'address', 'openstreetmap:way/959877094');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '25');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 25 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '25'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 44 THEN
    RAISE EXCEPTION 'Se esperaban 44 puntos de Correos en Lleida, hay %', n;
  END IF;
END;
$$;

COMMIT;

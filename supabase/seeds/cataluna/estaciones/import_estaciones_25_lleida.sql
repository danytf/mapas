-- Carga de la categoría Estaciones de Lleida (provincia 25), trozo de la carga de Andalucía.
-- Origen: estaciones-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 41 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-cataluna:estaciones:node-11358276488', 'Estació de Busos de Juneda – Carrer de Josep Anselm Clavé', 'Autobús', '25119', 'Carrer de Josep Anselm Clavé 84', '25430', 41.54653, 0.82213, 'address', 'openstreetmap:node/11358276488'),
  ('catalogo-cataluna:estaciones:node-11739285301', 'Estación de tren de Polígon industrial del Segre (Lleida) – Camí de Granyena', 'Tren', '25120', 'Camí de Granyena', NULL, 41.62288, 0.65294, 'address', 'openstreetmap:node/11739285301'),
  ('catalogo-cataluna:estaciones:node-1227263538', 'La Seu d''Urgell estació d''autobusos – avinguda Guillem Graell', 'Autobús', '25203', 'avinguda Guillem Graell 16', '25700', 42.35984, 1.45976, 'address', 'openstreetmap:node/1227263538'),
  ('catalogo-cataluna:estaciones:node-12547037424', 'Estación de tren de Raimat (Lleida)', 'Tren', '25120', NULL, NULL, 41.68697, 0.47476, 'address', 'openstreetmap:node/12547037424'),
  ('catalogo-cataluna:estaciones:node-13595844127', 'Estación de tren de Bell-lloc d''Urgell – Carrer de l''Estació', 'Tren', '25048', 'Carrer de l''Estació', '25220', 41.63175, 0.7816, 'address', 'openstreetmap:node/13595844127'),
  ('catalogo-cataluna:estaciones:node-13612915186', 'Estació d''autobusos de Lleida – Carrer del Princep de Viana', 'Autobús', '25120', 'Carrer del Princep de Viana 12', '25004', 41.62123, 0.63193, 'address', 'openstreetmap:node/13612915186'),
  ('catalogo-cataluna:estaciones:node-13681470657', 'Estación de tren de Mollerussa – Plaça de l''Estació', 'Tren', '25137', 'Plaça de l''Estació 4', '25230', 41.63195, 0.89688, 'address', 'openstreetmap:node/13681470657'),
  ('catalogo-cataluna:estaciones:node-13722093708', 'Estación de tren de Tàrrega – Carrer del Segle XX', 'Tren', '25217', 'Carrer del Segle XX 4', '25300', 41.65031, 1.13883, 'address', 'openstreetmap:node/13722093708'),
  ('catalogo-cataluna:estaciones:node-13722093709', 'Estación de tren de Bellpuig – Avinguda de Lleida', 'Tren', '25050', 'Avinguda de Lleida 16', '25250', 41.6326, 1.01297, 'address', 'openstreetmap:node/13722093709'),
  ('catalogo-cataluna:estaciones:node-14310088433', 'Estación de tren de Vilanova de la Sal (les Avellanes i Santa Linya)', 'Tren', '25037', NULL, NULL, 41.91206, 0.83039, 'address', 'openstreetmap:node/14310088433'),
  ('catalogo-cataluna:estaciones:node-14311003416', 'Estación de tren de Tremp – Carrer de Montllobar', 'Tren', '25234', 'Carrer de Montllobar 20', '25620', 42.16737, 0.89098, 'address', 'openstreetmap:node/14311003416'),
  ('catalogo-cataluna:estaciones:node-1834393194', 'Estación de tren de Àger', 'Tren', '25002', NULL, NULL, 42.00681, 0.85173, 'address', 'openstreetmap:node/1834393194'),
  ('catalogo-cataluna:estaciones:node-2128339709', 'Estación de tren de Sant Llorenç de Montgai (Camarasa) – Carrer de l''Estació', 'Tren', '25062', 'Carrer de l''Estació', NULL, 41.86641, 0.83263, 'address', 'openstreetmap:node/2128339709'),
  ('catalogo-cataluna:estaciones:node-2143686198', 'Estación de tren de la Pobla de Segur – Avinguda de l''Estació', 'Tren', '25171', 'Avinguda de l''Estació 15', '25500', 42.24, 0.96616, 'address', 'openstreetmap:node/2143686198'),
  ('catalogo-cataluna:estaciones:node-2195656639', 'Estación de tren de Cellers-Llimiana (Castell de Mur) – Carrer de Sant Miquel del Congost', 'Tren', '25904', 'Carrer de Sant Miquel del Congost 9', '25631', 42.05865, 0.88284, 'address', 'openstreetmap:node/2195656639'),
  ('catalogo-cataluna:estaciones:node-2242865261', 'Estación de tren de Golmés – Passeig de l''Estació', 'Tren', '25099', 'Passeig de l''Estació 5', '25241', 41.63592, 0.93086, 'address', 'openstreetmap:node/2242865261'),
  ('catalogo-cataluna:estaciones:node-2242865272', 'Estación de tren de Castellnou de Seana – Passeig de l''Estació', 'Tren', '25068', 'Passeig de l''Estació', NULL, 41.63738, 0.96797, 'address', 'openstreetmap:node/2242865272'),
  ('catalogo-cataluna:estaciones:node-2242865298', 'Estación de tren de Anglesola – Carrer de l''Estació', 'Tren', '25027', 'Carrer de l''Estació 55', '25320', 41.6464, 1.07898, 'address', 'openstreetmap:node/2242865298'),
  ('catalogo-cataluna:estaciones:node-2242865342', 'Estación de tren de Sant Guim de Freixenet – Carrer Major', 'Tren', '25192', 'Carrer Major 20', '25270', 41.65585, 1.42063, 'address', 'openstreetmap:node/2242865342'),
  ('catalogo-cataluna:estaciones:node-2242865371', 'Estación de tren de Cervera – Plaça de l''Estació', 'Tren', '25072', 'Plaça de l''Estació', '25200', 41.6737, 1.27472, 'address', 'openstreetmap:node/2242865371'),
  ('catalogo-cataluna:estaciones:node-2726030723', 'Estación de tren de Juneda – Carrer d''Enric Prat de la Riba', 'Tren', '25119', 'Carrer d''Enric Prat de la Riba 217', '25430', 41.54392, 0.82552, 'address', 'openstreetmap:node/2726030723'),
  ('catalogo-cataluna:estaciones:node-3954388458', 'Estación de tren de Balaguer – Carrer de la Noguera Pallaresa 33-35', 'Tren', '25040', 'Carrer de la Noguera Pallaresa 33-35', '25600', 41.78927, 0.81485, 'address', 'openstreetmap:node/3954388458'),
  ('catalogo-cataluna:estaciones:node-4774251842', 'Estación de tren de Guàrdia de Tremp (Castell de Mur)', 'Tren', '25904', NULL, NULL, 42.10138, 0.88808, 'address', 'openstreetmap:node/4774251842'),
  ('catalogo-cataluna:estaciones:node-4973964140', 'Estación de tren de Salàs de Pallars – Camí de l''Estació', 'Tren', '25190', 'Camí de l''Estació', NULL, 42.20684, 0.94046, 'address', 'openstreetmap:node/4973964140'),
  ('catalogo-cataluna:estaciones:node-5420775292', 'Estación de tren de Santa Linya (les Avellanes i Santa Linya)', 'Tren', '25037', NULL, NULL, 41.93186, 0.85252, 'address', 'openstreetmap:node/5420775292'),
  ('catalogo-cataluna:estaciones:node-5420775299', 'Estación de tren de Gerb (Os de Balaguer) – Camí del Segre', 'Tren', '25156', 'Camí del Segre', '25614', 41.8233, 0.81204, 'address', 'openstreetmap:node/5420775299'),
  ('catalogo-cataluna:estaciones:node-5420775821', 'Estación de tren de Vallfogona de Balaguer', 'Tren', '25240', NULL, NULL, 41.75575, 0.80559, 'address', 'openstreetmap:node/5420775821'),
  ('catalogo-cataluna:estaciones:node-5420775824', 'Estación de tren de Térmens – Passeig de Pau Casals', 'Tren', '25220', 'Passeig de Pau Casals 41', '25670', 41.71653, 0.76304, 'address', 'openstreetmap:node/5420775824'),
  ('catalogo-cataluna:estaciones:node-5420775829', 'Estación de tren de Vilanova de la Barca – Carrer del Ferrocarril', 'Tren', '25254', 'Carrer del Ferrocarril 9', '25690', 41.68736, 0.72791, 'address', 'openstreetmap:node/5420775829'),
  ('catalogo-cataluna:estaciones:node-5420775833', 'Estación de tren de Alcoletge – Camí de Grenyana', 'Tren', '25012', 'Camí de Grenyana', NULL, 41.65428, 0.68575, 'address', 'openstreetmap:node/5420775833'),
  ('catalogo-cataluna:estaciones:node-5420881259', 'Estación de tren de Palau de Noguera (Talarn) – Carrer E', 'Tren', '25215', 'Carrer E', '25633', 42.14692, 0.89243, 'address', 'openstreetmap:node/5420881259'),
  ('catalogo-cataluna:estaciones:node-5451675809', 'Estación de tren de les Borges Blanques – Carrer de l''Estació', 'Tren', '25058', 'Carrer de l''Estació 2', '25400', 41.52141, 0.87791, 'address', 'openstreetmap:node/5451675809'),
  ('catalogo-cataluna:estaciones:node-5451678226', 'Estación de tren de la Floresta – Camí de les Teixeres', 'Tren', '25092', 'Camí de les Teixeres', NULL, 41.50417, 0.92442, 'address', 'openstreetmap:node/5451678226'),
  ('catalogo-cataluna:estaciones:node-7487337013', 'Estación de tren de Lleida-Pirineus – Plaça de Ramon Berenguer IV', 'Tren', '25120', 'Plaça de Ramon Berenguer IV', '25007', 41.62073, 0.63304, 'address', 'openstreetmap:node/7487337013'),
  ('catalogo-cataluna:estaciones:node-8512301839', 'Estación de autobuses de Balaguer – Avinguda dels Països Catalans 17,19', 'Autobús', '25040', 'Avinguda dels Països Catalans 17,19', '25600', 41.7878, 0.80754, 'address', 'openstreetmap:node/8512301839'),
  ('catalogo-cataluna:estaciones:way-1301619786', 'Tremp (estació d''autobusos) – Carrer de Montllobar', 'Autobús', '25234', 'Carrer de Montllobar 26', '25620', 42.16765, 0.89175, 'address', 'openstreetmap:way/1301619786'),
  ('catalogo-cataluna:estaciones:way-159712166', 'Estació d''autobusos de Tàrrega – Carrer de les Santes Espines', 'Autobús', '25217', 'Carrer de les Santes Espines 24', '25300', 41.65033, 1.13807, 'address', 'openstreetmap:way/159712166'),
  ('catalogo-cataluna:estaciones:way-204359002', 'La Pobla de Segur - Estació d’autobusos – Carrer de la Font', 'Autobús', '25171', 'Carrer de la Font 8', '25500', 42.24655, 0.96745, 'address', 'openstreetmap:way/204359002'),
  ('catalogo-cataluna:estaciones:way-566164668', 'Estación de tren de Vinaixa – Carretera de l''Albi 34G', 'Tren', '25255', 'Carretera de l''Albi 34G', '25440', 41.4251, 0.97035, 'address', 'openstreetmap:way/566164668'),
  ('catalogo-cataluna:estaciones:way-566174509', 'Estación de tren de Puigverd de Lleida - Artesa de Lleida – 27', 'Tren', '25182', '27', '25153', 41.55369, 0.7334, 'address', 'openstreetmap:way/566174509'),
  ('catalogo-cataluna:estaciones:way-566303685', 'Estació d''autobusos de Mollerussa – Carrer de la Indústria', 'Autobús', '25137', 'Carrer de la Indústria', '25230', 41.63219, 0.89665, 'address', 'openstreetmap:way/566303685');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
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
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 41 THEN
    RAISE EXCEPTION 'Se esperaban 41 puntos de Estaciones en Lleida, hay %', n;
  END IF;
END;
$$;

COMMIT;

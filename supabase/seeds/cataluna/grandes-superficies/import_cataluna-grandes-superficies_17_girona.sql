-- Carga de la categoría (varias) de Girona (provincia 17), trozo de la carga de Andalucía.
-- Origen: cataluna-grandes-superficies-cataluna.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 36 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:node-10304033979', 'MediaMarkt Lloret de Mar – Avinguda de les Alegríes', NULL, '17095', 'Avinguda de les Alegríes 11', '17310', 41.70475, 2.83476, 'address', 'openstreetmap:node/10304033979'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:node-11014104568', 'IKEA Girona – Carrer de Sant Joan Baptista de La Salle', NULL, '17079', 'Carrer de Sant Joan Baptista de La Salle 38', '17002', 41.97805, 2.81825, 'address', 'openstreetmap:node/11014104568'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-11183722509', 'Carrefour Sant Feliu de Guíxols – Carrer de la Rutlla', NULL, '17160', 'Carrer de la Rutlla', '17220', 41.78242, 3.03001, 'address', 'openstreetmap:node/11183722509'),
  ('El Corte Inglés', 'catalogo-cataluna:cataluna-grandes-superficies:node-12379222974', 'El Corte Inglés Girona – Carrer de Santa Maria 1-3', NULL, '17079', 'Carrer de Santa Maria 1-3', '17003', 41.96829, 2.81393, 'address', 'openstreetmap:node/12379222974'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:node-12488746899', 'IKEA Celrà – Carrer Tramuntana', NULL, '17049', 'Carrer Tramuntana', NULL, 42.03487, 2.88973, 'address', 'openstreetmap:node/12488746899'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-13062969979', 'Carrefour Garrigàs – AUTOPISTA AP-7 (MRG.IZDO.) KM.', NULL, '17075', 'AUTOPISTA AP-7 (MRG.IZDO.) KM. 35', NULL, 42.17381, 2.93195, 'address', 'openstreetmap:node/13062969979'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-13541465183', 'Carrefour Calonge i Sant Antoni – Carrer de Llevantí de Mar', NULL, '17034', 'Carrer de Llevantí de Mar 64', NULL, 41.8432, 3.09325, 'address', 'openstreetmap:node/13541465183'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:node-14059121301', 'Decathlon Puigcerdà – Carrer de Pons i Gasch', NULL, '17141', 'Carrer de Pons i Gasch 4', '17520', 42.43426, 1.92794, 'address', 'openstreetmap:node/14059121301'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-1789681742', 'Carrefour Castell d''Aro, Platja d''Aro i s''Agaró – Avinguda de Castell d''Aro', NULL, '17048', 'Avinguda de Castell d''Aro', '17250', 41.81685, 3.06044, 'address', 'openstreetmap:node/1789681742'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-1790772905', 'Carrefour Palafrugell – Avinguda de les Corts Catalanes', NULL, '17117', 'Avinguda de les Corts Catalanes 1', '17124', 41.91126, 3.16725, 'address', 'openstreetmap:node/1790772905'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-2411783593', 'Carrefour Girona – Carrer de Francesc Artau', NULL, '17079', 'Carrer de Francesc Artau 2', '17005', 41.97861, 2.81285, 'address', 'openstreetmap:node/2411783593'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-4382160389', 'Carrefour Lloret de Mar – Avinguda America', NULL, '17095', 'Avinguda America 41', '17310', 41.69899, 2.83186, 'address', 'openstreetmap:node/4382160389'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-4430412589', 'Carrefour Lloret de Mar – Carrer de la Riera', NULL, '17095', 'Carrer de la Riera 31', '17310', 41.69843, 2.84335, 'address', 'openstreetmap:node/4430412589'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-447767171', 'Carrefour Puigcerdà – Eix Pirinenc', NULL, '17141', 'Eix Pirinenc', NULL, 42.42679, 1.92104, 'address', 'openstreetmap:node/447767171'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:node-4554093472', 'MediaMarkt Castell d''Aro, Platja d''Aro i s''Agaró – Avinguda s''Agaró', NULL, '17048', 'Avinguda s''Agaró', '17249', 41.80481, 3.05426, 'address', 'openstreetmap:node/4554093472'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-492667703', 'Carrefour Figueres', NULL, '17066', NULL, NULL, 42.26879, 3.0015, 'address', 'openstreetmap:node/492667703'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-5848640686', 'Carrefour Roses – Carrer Cap Norfeu', NULL, '17152', 'Carrer Cap Norfeu 5', '17480', 42.2609, 3.17991, 'address', 'openstreetmap:node/5848640686'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:node-814747316', 'Carrefour Girona – Avinguda de França 42-44', NULL, '17079', 'Avinguda de França 42-44', '17007', 41.99567, 2.8199, 'address', 'openstreetmap:node/814747316'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:node-9657991530', 'IKEA Girona – Carrer de Joan Maragall', NULL, '17079', 'Carrer de Joan Maragall 21', '17002', 41.97965, 2.82157, 'address', 'openstreetmap:node/9657991530'),
  ('IKEA', 'catalogo-cataluna:cataluna-grandes-superficies:relation-1011728', 'IKEA Girona – Carrer d''Astúries', NULL, '17079', 'Carrer d''Astúries 61', '17003', 41.95492, 2.80875, 'address', 'openstreetmap:relation/1011728'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-116729148', 'Decathlon Figueres – Avinguda del Parc del Manol', NULL, '17066', 'Avinguda del Parc del Manol', '17600', 42.26618, 2.99706, 'address', 'openstreetmap:way/116729148'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:way-116729155', 'Leroy Merlin Figueres – Avinguda del Parc del Manol', NULL, '17066', 'Avinguda del Parc del Manol', NULL, 42.26606, 2.99616, 'address', 'openstreetmap:way/116729155'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-162238917', 'Carrefour Olot – Avinguda de Santa Coloma', NULL, '17114', 'Avinguda de Santa Coloma 78', '17800', 42.1704, 2.47631, 'address', 'openstreetmap:way/162238917'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-170969558', 'Carrefour Torroella de Montgrí – Camí dels Molins', NULL, '17199', 'Camí dels Molins', NULL, 42.03715, 3.12791, 'address', 'openstreetmap:way/170969558'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-188437912', 'Carrefour Sant Feliu de Guíxols – Carrer de la Indústria', NULL, '17160', 'Carrer de la Indústria 58', '17220', 41.78389, 3.03453, 'address', 'openstreetmap:way/188437912'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-200724523', 'Carrefour l''Escala – Carrer del Puig', NULL, '17062', 'Carrer del Puig 5', '17130', 42.11563, 3.1291, 'address', 'openstreetmap:way/200724523'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-201830066', 'Carrefour Sant Feliu de Guíxols – CARRETERA C-253 KM 41.3', NULL, '17160', 'CARRETERA C-253 KM 41.3', NULL, 41.79156, 3.04699, 'address', 'openstreetmap:way/201830066'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:way-295790416', 'Leroy Merlin Castell d''Aro, Platja d''Aro i s''Agaró – Carrer Santiago Russinyo', NULL, '17048', 'Carrer Santiago Russinyo', '17249', 41.8052, 3.05329, 'address', 'openstreetmap:way/295790416'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-40773994', 'Decathlon Castell d''Aro, Platja d''Aro i s''Agaró – Carrer de Santiago Rusiñol', NULL, '17048', 'Carrer de Santiago Rusiñol', '17249', 41.80694, 3.05379, 'address', 'openstreetmap:way/40773994'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-448305588', 'Carrefour Roses – Carrer Avet', NULL, '17152', 'Carrer Avet', '17480', 42.27129, 3.15055, 'address', 'openstreetmap:way/448305588'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-63920404', 'Decathlon Girona – Par Comercial Mas Gri', NULL, '17079', 'Par Comercial Mas Gri', '17003', 41.95972, 2.81117, 'address', 'openstreetmap:way/63920404'),
  ('El Corte Inglés', 'catalogo-cataluna:cataluna-grandes-superficies:way-63932612', 'El Corte Inglés Girona – Carrer de Barcelona 106-110', NULL, '17079', 'Carrer de Barcelona 106-110', '17003', 41.97103, 2.81416, 'address', 'openstreetmap:way/63932612'),
  ('MediaMarkt', 'catalogo-cataluna:cataluna-grandes-superficies:way-63935829', 'MediaMarkt Girona – Carrer Victoria Gasteiz', NULL, '17079', 'Carrer Victoria Gasteiz 8', '17003', 41.95856, 2.81138, 'address', 'openstreetmap:way/63935829'),
  ('Leroy Merlin', 'catalogo-cataluna:cataluna-grandes-superficies:way-690578958', 'Leroy Merlin Girona – Carrer d''Astúries', NULL, '17079', 'Carrer d''Astúries 66', '17003', 41.95437, 2.80985, 'address', 'openstreetmap:way/690578958'),
  ('Decathlon', 'catalogo-cataluna:cataluna-grandes-superficies:way-855654500', 'Decathlon Blanes – Avinguda Parlament de Catalunya', NULL, '17023', 'Avinguda Parlament de Catalunya 38', '17300', 41.68256, 2.7919, 'address', 'openstreetmap:way/855654500'),
  ('Carrefour', 'catalogo-cataluna:cataluna-grandes-superficies:way-906173518', 'Carrefour Vilamalla', NULL, '17226', NULL, NULL, 42.2297, 2.9903, 'address', 'openstreetmap:way/906173518');

DO $$
DECLARE faltan text;
BEGIN
  SELECT string_agg(DISTINCT c.categoria, ', ') INTO faltan FROM _carga c WHERE NOT EXISTS (SELECT 1 FROM public.categories k WHERE k.name = c.categoria);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan categorías: %', faltan;
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
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 36 THEN
    RAISE EXCEPTION 'Se esperaban 36 puntos de (varias) en Girona, hay %', n;
  END IF;
END;
$$;

COMMIT;

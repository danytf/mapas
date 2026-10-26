-- Carga de la categoría (varias) de Alicante/Alacant (provincia 03), trozo de la carga de Andalucía.
-- Origen: valencia-grandes-superficies-valencia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 68 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-10263037164', 'Carrefour Sant Vicent del Raspeig / San Vicente del Raspeig', NULL, '03122', NULL, NULL, 38.38069, -0.5057, 'address', 'openstreetmap:node/10263037164'),
  ('IKEA', 'catalogo-valencia:valencia-grandes-superficies:node-10291767322', 'IKEA Ondara – Avenida Costa Blanca', NULL, '03095', 'Avenida Costa Blanca', '03760', 38.81725, 0.02251, 'address', 'openstreetmap:node/10291767322'),
  ('IKEA', 'catalogo-valencia:valencia-grandes-superficies:node-10665631755', 'IKEA Orihuela', NULL, '03099', NULL, NULL, 37.93139, -0.73659, 'address', 'openstreetmap:node/10665631755'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-10674284584', 'Carrefour Guardamar del Segura – Avinguda del Port', NULL, '03076', 'Avinguda del Port', '03140', 38.09579, -0.6615, 'address', 'openstreetmap:node/10674284584'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-10676857828', 'Carrefour Sant Joan d''Alacant', NULL, '03119', NULL, '03550', 38.40648, -0.42349, 'address', 'openstreetmap:node/10676857828'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-10996228782', 'Carrefour Torrevieja – Calle Huerto', NULL, '03133', 'Calle Huerto 4', '03181', 37.97738, -0.68742, 'address', 'openstreetmap:node/10996228782'),
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:node-11212553135', 'MediaMarkt Elx / Elche – Avenida de Crevillente', NULL, '03065', 'Avenida de Crevillente 29', '03205', 38.2589, -0.72594, 'address', 'openstreetmap:node/11212553135'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-11398183008', 'Carrefour Xàbia / Jávea – Avinguda de la Fontana', NULL, '03082', 'Avinguda de la Fontana', '03730', 38.77436, 0.18828, 'address', 'openstreetmap:node/11398183008'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-12083985781', 'Carrefour Alacant / Alicante – Avinguda de la Condomina', NULL, '03014', 'Avinguda de la Condomina 51', '03016', 38.36365, -0.43462, 'address', 'openstreetmap:node/12083985781'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-12407341296', 'Carrefour Finestrat', NULL, '03069', NULL, NULL, 38.53683, -0.17601, 'address', 'openstreetmap:node/12407341296'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-12409428711', 'Carrefour Alacant / Alicante – Carrer de la Llar Provincial Antonio Fernández Valenzuela', NULL, '03014', 'Carrer de la Llar Provincial Antonio Fernández Valenzuela', NULL, 38.38574, -0.44986, 'address', 'openstreetmap:node/12409428711'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-13313211601', 'Carrefour Torrevieja – Avenida Denia', NULL, '03133', 'Avenida Denia', NULL, 37.9688, -0.74322, 'address', 'openstreetmap:node/13313211601'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-13391192599', 'Carrefour Benidorm – Calle Esperanto', NULL, '03031', 'Calle Esperanto 23', '03502', 38.54171, -0.12093, 'address', 'openstreetmap:node/13391192599'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-13610274557', 'Carrefour Alacant / Alicante – Rambla de Méndez Núñez', NULL, '03014', 'Rambla de Méndez Núñez', '03002', 38.34704, -0.48408, 'address', 'openstreetmap:node/13610274557'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:node-13946112728', 'Leroy Merlin Torrevieja – Rosa Mazón Valero', NULL, '03133', 'Rosa Mazón Valero 7', '03184', 37.98993, -0.68654, 'address', 'openstreetmap:node/13946112728'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:node-1477930868', 'El Corte Inglés Elx / Elche – Avenida Alcalde Ramón Pastor', NULL, '03065', 'Avenida Alcalde Ramón Pastor 2', '03293', 38.25821, -0.71374, 'address', 'openstreetmap:node/1477930868'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-1735176738', 'Carrefour Petrer', NULL, '03104', NULL, NULL, 38.48771, -0.77503, 'address', 'openstreetmap:node/1735176738'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:node-1935850778', 'Leroy Merlin Orihuela', NULL, '03099', NULL, NULL, 37.92941, -0.73695, 'address', 'openstreetmap:node/1935850778'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:node-2282092078', 'Decathlon Orihuela – Calle Jade', NULL, '03099', 'Calle Jade', NULL, 37.92873, -0.73563, 'address', 'openstreetmap:node/2282092078'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-2318188057', 'Carrefour Novelda – avenida de Jesús Navarro Jover', NULL, '03093', 'avenida de Jesús Navarro Jover 1', NULL, 38.38843, -0.7557, 'address', 'openstreetmap:node/2318188057'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-232774781', 'Carrefour Alacant / Alicante – Carrer de José García Sellés', NULL, '03014', 'Carrer de José García Sellés 2', '03015', 38.36662, -0.46916, 'address', 'openstreetmap:node/232774781'),
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:node-2330623809', 'MediaMarkt Orihuela – Calle Jade', NULL, '03099', 'Calle Jade', NULL, 37.93023, -0.73493, 'address', 'openstreetmap:node/2330623809'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:node-253449513', 'Leroy Merlin Alacant / Alicante – Calle Vistahermosa Provisional', NULL, '03014', 'Calle Vistahermosa Provisional 5', '03015', 38.37047, -0.46804, 'address', 'openstreetmap:node/253449513'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-2591245171', 'Carrefour Orihuela – Plaza Nueva', NULL, '03099', 'Plaza Nueva 4', '03300', 38.08459, -0.94754, 'address', 'openstreetmap:node/2591245171'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-2593802560', 'Carrefour Teulada – Camí de la Font Santa', NULL, '03128', 'Camí de la Font Santa', '03725', 38.71168, 0.13219, 'address', 'openstreetmap:node/2593802560'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:node-3074113402', 'Leroy Merlin Cocentaina', NULL, '03056', NULL, NULL, 38.732, -0.44294, 'address', 'openstreetmap:node/3074113402'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-3181668682', 'Carrefour Alacant / Alicante – Plaça de Gabriel Miró', NULL, '03014', 'Plaça de Gabriel Miró 3', '03001', 38.343, -0.48478, 'address', 'openstreetmap:node/3181668682'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-4113906615', 'Carrefour Alacant / Alicante – Plaça de l''Ajuntament', NULL, '03014', 'Plaça de l''Ajuntament 2', '03002', 38.34517, -0.48087, 'address', 'openstreetmap:node/4113906615'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-4114343706', 'Carrefour Alacant / Alicante – Carrer de Calderón de la Barca', NULL, '03014', 'Carrer de Calderón de la Barca 8', '03004', 38.34876, -0.48586, 'address', 'openstreetmap:node/4114343706'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-4417769955', 'Carrefour Santa Pola – Carretera Elx - Santa Pola', NULL, '03121', 'Carretera Elx - Santa Pola', NULL, 38.19711, -0.56221, 'address', 'openstreetmap:node/4417769955'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:node-4952639622', 'Decathlon Elx / Elche', NULL, '03065', NULL, NULL, 38.25752, -0.72932, 'address', 'openstreetmap:node/4952639622'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-5170274885', 'Carrefour Alacant / Alicante – Carrer del Professor Manuel Sala', NULL, '03014', 'Carrer del Professor Manuel Sala', '03003', 38.33891, -0.49185, 'address', 'openstreetmap:node/5170274885'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-559131730', 'Carrefour Cocentaina', NULL, '03056', NULL, NULL, 38.73145, -0.44352, 'address', 'openstreetmap:node/559131730'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-5710685704', 'Carrefour Benidorm – avenida del Mediterráneo - Avinguda del Mediterranio', NULL, '03031', 'avenida del Mediterráneo - Avinguda del Mediterranio 43', '03503', 38.53616, -0.11213, 'address', 'openstreetmap:node/5710685704'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-583595761', 'Carrefour Ondara – Avinguda Costa Blanca', NULL, '03095', 'Avinguda Costa Blanca 1', '03760', 38.81795, 0.02254, 'address', 'openstreetmap:node/583595761'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-595055285', 'Carrefour Alacant / Alicante – Carrer de José María Hernández Mata', NULL, '03014', 'Carrer de José María Hernández Mata', '03007', 38.34184, -0.51753, 'address', 'openstreetmap:node/595055285'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-622957347', 'Carrefour Orihuela – calle Gustavo Adolfo Bécquer', NULL, '03099', 'calle Gustavo Adolfo Bécquer', '03189', 37.89955, -0.75238, 'address', 'openstreetmap:node/622957347'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-6393642889', 'Carrefour Alacant / Alicante – Carrer de Girona', NULL, '03014', 'Carrer de Girona 1', '03001', 38.34489, -0.48373, 'address', 'openstreetmap:node/6393642889'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-6542100580', 'Carrefour Santa Pola – Carrer d''Orà', NULL, '03121', 'Carrer d''Orà 12', '03130', 38.19039, -0.55066, 'address', 'openstreetmap:node/6542100580'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-6545927676', 'Carrefour Alacant / Alicante – Carrer d''Amadeu de Saboia', NULL, '03014', 'Carrer d''Amadeu de Saboia', '03012', 38.35935, -0.48055, 'address', 'openstreetmap:node/6545927676'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-6627511497', 'Carrefour Alacant / Alicante – Carretera d''Ocaña', NULL, '03014', 'Carretera d''Ocaña', NULL, 38.34414, -0.53862, 'address', 'openstreetmap:node/6627511497'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-7712913068', 'Carrefour Guardamar del Segura – Carrer Major', NULL, '03076', 'Carrer Major 4', '03140', 38.09056, -0.65462, 'address', 'openstreetmap:node/7712913068'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:node-992925682', 'Carrefour Finestrat – Avinguda Marina Baixa', NULL, '03069', 'Avinguda Marina Baixa', '03509', 38.52566, -0.16698, 'address', 'openstreetmap:node/992925682'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-1052527829', 'Carrefour la Vila Joiosa / Villajoyosa', NULL, '03139', NULL, NULL, 38.49893, -0.25199, 'address', 'openstreetmap:way/1052527829'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-1076996043', 'Carrefour Xàbia / Jávea – AVENIDA DEL PLA', NULL, '03082', 'AVENIDA DEL PLA 77', NULL, 38.78487, 0.17882, 'address', 'openstreetmap:way/1076996043'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-112575122', 'Carrefour Dénia – Partida Madrigueres Sud', NULL, '03063', 'Partida Madrigueres Sud 4', '03700', 38.83816, 0.0947, 'address', 'openstreetmap:way/112575122'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-1146447663', 'Carrefour Orihuela – CARRETERA N-332 KM 52.1', NULL, '03099', 'CARRETERA N-332 KM 52.1', NULL, 37.94342, -0.71802, 'address', 'openstreetmap:way/1146447663'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-1147713764', 'Carrefour Alacant / Alicante – Carrer de Federico Mayo', NULL, '03014', 'Carrer de Federico Mayo', '03008', 38.33794, -0.50043, 'address', 'openstreetmap:way/1147713764'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-1147926241', 'Leroy Merlin Calp – Partida Estación I 1-A', NULL, '03047', 'Partida Estación I 1-A', NULL, 38.64668, 0.03439, 'address', 'openstreetmap:way/1147926241'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-1153893062', 'Leroy Merlin Ondara – Carrer Sagra', NULL, '03095', 'Carrer Sagra 28', '03760', 38.81814, 0.01743, 'address', 'openstreetmap:way/1153893062'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-1308500466', 'Leroy Merlin Ondara – Avinguda Costa Blanca', NULL, '03095', 'Avinguda Costa Blanca', '03760', 38.81597, 0.02156, 'address', 'openstreetmap:way/1308500466'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:way-20929398', 'El Corte Inglés Alacant / Alicante – Carrer del General O''Donnell', NULL, '03014', 'Carrer del General O''Donnell 3', '03003', 38.34403, -0.49007, 'address', 'openstreetmap:way/20929398'),
  ('El Corte Inglés', 'catalogo-valencia:valencia-grandes-superficies:way-20929405', 'El Corte Inglés Alacant / Alicante – Avinguda de Maisonnave', NULL, '03014', 'Avinguda de Maisonnave', '03003', 38.34304, -0.49335, 'address', 'openstreetmap:way/20929405'),
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:way-23410921', 'MediaMarkt Alacant / Alicante – Avinguda d''Antonio Ramos Carratalá', NULL, '03014', 'Avinguda d''Antonio Ramos Carratalá', '03015', 38.36971, -0.46821, 'address', 'openstreetmap:way/23410921'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-24288090', 'Decathlon Alacant / Alicante – Carrer de Benidoleig', NULL, '03014', 'Carrer de Benidoleig', NULL, 38.37592, -0.50657, 'address', 'openstreetmap:way/24288090'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-25850074', 'Leroy Merlin Sant Joan d''Alacant – Avinguda de Miguel Hernández', NULL, '03119', 'Avinguda de Miguel Hernández', NULL, 38.40507, -0.42582, 'address', 'openstreetmap:way/25850074'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-26436677', 'Carrefour Torrevieja – Avenida Rosa Mazón Valero', NULL, '03133', 'Avenida Rosa Mazón Valero', NULL, 37.99153, -0.68613, 'address', 'openstreetmap:way/26436677'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-28520166', 'Carrefour Elx / Elche – Carrer de les Mates', NULL, '03065', 'Carrer de les Mates', NULL, 38.25778, -0.72751, 'address', 'openstreetmap:way/28520166'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-295306171', 'Carrefour Santa Pola – Carrer de Tarragona', NULL, '03121', 'Carrer de Tarragona', NULL, 38.19917, -0.562, 'address', 'openstreetmap:way/295306171'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-300286052', 'Decathlon Cocentaina – Avinguda Circumval·lació', NULL, '03056', 'Avinguda Circumval·lació', NULL, 38.72491, -0.45109, 'address', 'openstreetmap:way/300286052'),
  ('MediaMarkt', 'catalogo-valencia:valencia-grandes-superficies:way-368900470', 'MediaMarkt Finestrat – Avinguda del País Valencià', NULL, '03069', 'Avinguda del País Valencià', NULL, 38.53763, -0.1791, 'address', 'openstreetmap:way/368900470'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-392432888', 'Leroy Merlin Elx / Elche – Carrer Almansa', NULL, '03065', 'Carrer Almansa', NULL, 38.27801, -0.72255, 'address', 'openstreetmap:way/392432888'),
  ('Leroy Merlin', 'catalogo-valencia:valencia-grandes-superficies:way-524991854', 'Leroy Merlin Finestrat – Carrer Rei Jaume I', NULL, '03069', 'Carrer Rei Jaume I', NULL, 38.53383, -0.17125, 'address', 'openstreetmap:way/524991854'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-636256480', 'Decathlon Finestrat – Carrer Astúries', NULL, '03069', 'Carrer Astúries', NULL, 38.53584, -0.17988, 'address', 'openstreetmap:way/636256480'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-653363351', 'Carrefour Finestrat – Carrer Rei Jaume I', NULL, '03069', 'Carrer Rei Jaume I', NULL, 38.53457, -0.16956, 'address', 'openstreetmap:way/653363351'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-707872736', 'Carrefour Torrevieja – Carretera N-332 Km 63.3', NULL, '03133', 'Carretera N-332 Km 63.3', NULL, 38.02312, -0.65671, 'address', 'openstreetmap:way/707872736'),
  ('Carrefour', 'catalogo-valencia:valencia-grandes-superficies:way-711668100', 'Carrefour Guardamar del Segura – Avinguda de Cervantes', NULL, '03076', 'Avinguda de Cervantes', '03140', 38.07625, -0.65067, 'address', 'openstreetmap:way/711668100'),
  ('Decathlon', 'catalogo-valencia:valencia-grandes-superficies:way-996349688', 'Decathlon Ondara – Carrer Sagra', NULL, '03095', 'Carrer Sagra 26', '03760', 38.81833, 0.01839, 'address', 'openstreetmap:way/996349688');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '03');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 03 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '03'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 68 THEN
    RAISE EXCEPTION 'Se esperaban 68 puntos de (varias) en Alicante/Alacant, hay %', n;
  END IF;
END;
$$;

COMMIT;

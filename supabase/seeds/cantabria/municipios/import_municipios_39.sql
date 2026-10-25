-- Municipios oficiales (código INE) de las provincias 39. Origen: OpenStreetMap (áreas administrativas de nivel 8 con ine:municipio), ODbL.
-- Inserta los que faltan y asigna el código INE a los existentes que no lo tienen. No cambia nombres ni borra nada.
-- 102 municipios. Transaccional e idempotente.

BEGIN;

CREATE TEMP TABLE _municipios (prov text, ine text, name text, norm text) ON COMMIT DROP;
INSERT INTO _municipios VALUES
  ('39', '39001', 'Alfoz de Lloredo', 'alfoz-de-lloredo'),
  ('39', '39002', 'Ampuero', 'ampuero'),
  ('39', '39003', 'Anievas', 'anievas'),
  ('39', '39004', 'Arenas de Iguña', 'arenas-de-iguna'),
  ('39', '39005', 'Argoños', 'argonos'),
  ('39', '39006', 'Arnuero', 'arnuero'),
  ('39', '39007', 'Arredondo', 'arredondo'),
  ('39', '39008', 'El Astillero', 'el-astillero'),
  ('39', '39009', 'Bárcena de Cicero', 'barcena-de-cicero'),
  ('39', '39010', 'Bárcena de Pie de Concha', 'barcena-de-pie-de-concha'),
  ('39', '39011', 'Bareyo', 'bareyo'),
  ('39', '39012', 'Cabezón de la Sal', 'cabezon-de-la-sal'),
  ('39', '39013', 'Cabezón de Liébana', 'cabezon-de-liebana'),
  ('39', '39014', 'Cabuérniga', 'cabuerniga'),
  ('39', '39015', 'Camaleño', 'camaleno'),
  ('39', '39016', 'Camargo', 'camargo'),
  ('39', '39017', 'Campoo de Yuso', 'campoo-de-yuso'),
  ('39', '39018', 'Cartes', 'cartes'),
  ('39', '39019', 'Castañeda', 'castaneda'),
  ('39', '39020', 'Castro-Urdiales', 'castro-urdiales'),
  ('39', '39021', 'Cieza', 'cieza'),
  ('39', '39022', 'Cillorigo de Liébana', 'cillorigo-de-liebana'),
  ('39', '39023', 'Colindres', 'colindres'),
  ('39', '39024', 'Comillas', 'comillas'),
  ('39', '39025', 'Los Corrales de Buelna', 'los-corrales-de-buelna'),
  ('39', '39026', 'Corvera de Toranzo', 'corvera-de-toranzo'),
  ('39', '39027', 'Campoo de Enmedio', 'campoo-de-enmedio'),
  ('39', '39028', 'Entrambasaguas', 'entrambasaguas'),
  ('39', '39029', 'Escalante', 'escalante'),
  ('39', '39030', 'Guriezo', 'guriezo'),
  ('39', '39031', 'Hazas de Cesto', 'hazas-de-cesto'),
  ('39', '39032', 'Hermandad de Campoo de Suso', 'hermandad-de-campoo-de-suso'),
  ('39', '39033', 'Herrerías', 'herrerias'),
  ('39', '39034', 'Lamasón', 'lamason'),
  ('39', '39035', 'Laredo', 'laredo'),
  ('39', '39036', 'Liendo', 'liendo'),
  ('39', '39037', 'Liérganes', 'lierganes'),
  ('39', '39038', 'Limpias', 'limpias'),
  ('39', '39039', 'Luena', 'luena'),
  ('39', '39040', 'Marina de Cudeyo', 'marina-de-cudeyo'),
  ('39', '39041', 'Mazcuerras', 'mazcuerras'),
  ('39', '39042', 'Medio Cudeyo', 'medio-cudeyo'),
  ('39', '39043', 'Meruelo', 'meruelo'),
  ('39', '39044', 'Miengo', 'miengo'),
  ('39', '39045', 'Miera', 'miera'),
  ('39', '39046', 'Molledo', 'molledo'),
  ('39', '39047', 'Noja', 'noja'),
  ('39', '39048', 'Penagos', 'penagos'),
  ('39', '39049', 'Peñarrubia', 'penarrubia'),
  ('39', '39050', 'Pesaguero', 'pesaguero'),
  ('39', '39051', 'Pesquera', 'pesquera'),
  ('39', '39052', 'Piélagos', 'pielagos'),
  ('39', '39053', 'Polaciones', 'polaciones'),
  ('39', '39054', 'Polanco', 'polanco'),
  ('39', '39055', 'Potes', 'potes'),
  ('39', '39056', 'Puente Viesgo', 'puente-viesgo'),
  ('39', '39057', 'Ramales de la Victoria', 'ramales-de-la-victoria'),
  ('39', '39058', 'Rasines', 'rasines'),
  ('39', '39059', 'Reinosa', 'reinosa'),
  ('39', '39060', 'Reocín', 'reocin'),
  ('39', '39061', 'Ribamontán al Mar', 'ribamontan-al-mar'),
  ('39', '39062', 'Ribamontán al Monte', 'ribamontan-al-monte'),
  ('39', '39063', 'Rionansa', 'rionansa'),
  ('39', '39064', 'Riotuerto', 'riotuerto'),
  ('39', '39065', 'Las Rozas de Valdearroyo', 'las-rozas-de-valdearroyo'),
  ('39', '39066', 'Ruente', 'ruente'),
  ('39', '39067', 'Ruesga', 'ruesga'),
  ('39', '39068', 'Ruiloba', 'ruiloba'),
  ('39', '39069', 'San Felices de Buelna', 'san-felices-de-buelna'),
  ('39', '39070', 'San Miguel de Aguayo', 'san-miguel-de-aguayo'),
  ('39', '39071', 'San Pedro del Romeral', 'san-pedro-del-romeral'),
  ('39', '39072', 'San Roque de Riomiera', 'san-roque-de-riomiera'),
  ('39', '39073', 'Santa Cruz de Bezana', 'santa-cruz-de-bezana'),
  ('39', '39074', 'Santa María de Cayón', 'santa-maria-de-cayon'),
  ('39', '39075', 'Santander', 'santander'),
  ('39', '39076', 'Santillana del Mar', 'santillana-del-mar'),
  ('39', '39077', 'Santiurde de Reinosa', 'santiurde-de-reinosa'),
  ('39', '39078', 'Santiurde de Toranzo', 'santiurde-de-toranzo'),
  ('39', '39079', 'Santoña', 'santona'),
  ('39', '39080', 'San Vicente de la Barquera', 'san-vicente-de-la-barquera'),
  ('39', '39081', 'Saro', 'saro'),
  ('39', '39082', 'Selaya', 'selaya'),
  ('39', '39083', 'Soba', 'soba'),
  ('39', '39084', 'Solórzano', 'solorzano'),
  ('39', '39085', 'Suances', 'suances'),
  ('39', '39086', 'Los Tojos', 'los-tojos'),
  ('39', '39087', 'Torrelavega', 'torrelavega'),
  ('39', '39088', 'Tresviso', 'tresviso'),
  ('39', '39089', 'Tudanca', 'tudanca'),
  ('39', '39090', 'Udías', 'udias'),
  ('39', '39091', 'Valdáliga', 'valdaliga'),
  ('39', '39092', 'Valdeolea', 'valdeolea'),
  ('39', '39093', 'Valdeprado del Río', 'valdeprado-del-rio'),
  ('39', '39094', 'Valderredible', 'valderredible'),
  ('39', '39095', 'Val de San Vicente', 'val-de-san-vicente'),
  ('39', '39096', 'Vega de Liébana', 'vega-de-liebana'),
  ('39', '39097', 'Vega de Pas', 'vega-de-pas'),
  ('39', '39098', 'Villacarriedo', 'villacarriedo'),
  ('39', '39099', 'Villaescusa', 'villaescusa'),
  ('39', '39100', 'Villafufre', 'villafufre'),
  ('39', '39101', 'Valle de Villaverde', 'valle-de-villaverde'),
  ('39', '39102', 'Voto', 'voto');

DO $$
DECLARE faltan text;
BEGIN
  SELECT string_agg(DISTINCT m.prov, ', ') INTO faltan FROM _municipios m
  WHERE NOT EXISTS (SELECT 1 FROM public.provinces p WHERE p.code = m.prov);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan provincias: %', faltan;
  END IF;
END;
$$;

INSERT INTO public.municipalities (province_id, name, normalized_name, official_code)
SELECT p.id, m.name, m.norm, m.ine
FROM _municipios m JOIN public.provinces p ON p.code = m.prov
ON CONFLICT (province_id, normalized_name) DO UPDATE
  SET official_code = EXCLUDED.official_code
  WHERE public.municipalities.official_code IS NULL;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.municipalities mu
  JOIN _municipios m ON mu.official_code = m.ine;
  IF n < 102 THEN
    RAISE EXCEPTION 'Se esperaban al menos 102 municipios con código INE, hay %', n;
  END IF;
END;
$$;

COMMIT;

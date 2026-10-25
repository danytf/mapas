-- Municipios oficiales (código INE) de las provincias 07. Origen: OpenStreetMap (áreas administrativas de nivel 8 con ine:municipio), ODbL.
-- Inserta los que faltan y asigna el código INE a los existentes que no lo tienen. No cambia nombres ni borra nada.
-- 67 municipios. Transaccional e idempotente.

BEGIN;

CREATE TEMP TABLE _municipios (prov text, ine text, name text, norm text) ON COMMIT DROP;
INSERT INTO _municipios VALUES
  ('07', '07001', 'Alaró', 'alaro'),
  ('07', '07002', 'Alaior', 'alaior'),
  ('07', '07003', 'Alcúdia', 'alcudia'),
  ('07', '07004', 'Algaida', 'algaida'),
  ('07', '07005', 'Andratx', 'andratx'),
  ('07', '07006', 'Artà', 'arta'),
  ('07', '07007', 'Banyalbufar', 'banyalbufar'),
  ('07', '07008', 'Binissalem', 'binissalem'),
  ('07', '07009', 'Búger', 'buger'),
  ('07', '07010', 'Bunyola', 'bunyola'),
  ('07', '07011', 'Calvià', 'calvia'),
  ('07', '07012', 'Campanet', 'campanet'),
  ('07', '07013', 'Campos', 'campos'),
  ('07', '07014', 'Capdepera', 'capdepera'),
  ('07', '07015', 'Ciutadella', 'ciutadella'),
  ('07', '07016', 'Consell', 'consell'),
  ('07', '07017', 'Costitx', 'costitx'),
  ('07', '07018', 'Deià', 'deia'),
  ('07', '07019', 'Escorca', 'escorca'),
  ('07', '07020', 'Esporles', 'esporles'),
  ('07', '07021', 'Estellencs', 'estellencs'),
  ('07', '07022', 'Felanitx', 'felanitx'),
  ('07', '07023', 'Ferreries', 'ferreries'),
  ('07', '07024', 'Formentera', 'formentera'),
  ('07', '07025', 'Fornalutx', 'fornalutx'),
  ('07', '07026', 'Eivissa', 'eivissa'),
  ('07', '07027', 'Inca', 'inca'),
  ('07', '07028', 'Lloret de Vistalegre', 'lloret-de-vistalegre'),
  ('07', '07029', 'Lloseta', 'lloseta'),
  ('07', '07030', 'Llubí', 'llubi'),
  ('07', '07031', 'Llucmajor', 'llucmajor'),
  ('07', '07032', 'Maó', 'mao'),
  ('07', '07033', 'Manacor', 'manacor'),
  ('07', '07034', 'Mancor de la Vall', 'mancor-de-la-vall'),
  ('07', '07035', 'Maria de la Salut', 'maria-de-la-salut'),
  ('07', '07036', 'Marratxí', 'marratxi'),
  ('07', '07037', 'es Mercadal', 'es-mercadal'),
  ('07', '07038', 'Montuïri', 'montuiri'),
  ('07', '07039', 'Muro', 'muro'),
  ('07', '07040', 'Palma', 'palma'),
  ('07', '07041', 'Petra', 'petra'),
  ('07', '07042', 'Pollença', 'pollenca'),
  ('07', '07043', 'Porreres', 'porreres'),
  ('07', '07044', 'sa Pobla', 'sa-pobla'),
  ('07', '07045', 'Puigpunyent', 'puigpunyent'),
  ('07', '07046', 'Sant Antoni de Portmany', 'sant-antoni-de-portmany'),
  ('07', '07047', 'Sencelles', 'sencelles'),
  ('07', '07048', 'Sant Josep de sa Talaia', 'sant-josep-de-sa-talaia'),
  ('07', '07049', 'Sant Joan', 'sant-joan'),
  ('07', '07050', 'Sant Joan de Labritja', 'sant-joan-de-labritja'),
  ('07', '07051', 'Sant Llorenç des Cardassar', 'sant-llorenc-des-cardassar'),
  ('07', '07052', 'Sant Lluís', 'sant-lluis'),
  ('07', '07053', 'Santa Eugènia', 'santa-eugenia'),
  ('07', '07054', 'Santa Eulària des Riu', 'santa-eularia-des-riu'),
  ('07', '07055', 'Santa Margalida', 'santa-margalida'),
  ('07', '07056', 'Santa Maria del Camí', 'santa-maria-del-cami'),
  ('07', '07057', 'Santanyí', 'santanyi'),
  ('07', '07058', 'Selva', 'selva'),
  ('07', '07059', 'ses Salines', 'ses-salines'),
  ('07', '07060', 'Sineu', 'sineu'),
  ('07', '07061', 'Sóller', 'soller'),
  ('07', '07062', 'Son Servera', 'son-servera'),
  ('07', '07063', 'Valldemossa', 'valldemossa'),
  ('07', '07064', 'es Castell', 'es-castell'),
  ('07', '07065', 'Vilafranca de Bonany', 'vilafranca-de-bonany'),
  ('07', '07901', 'Ariany', 'ariany'),
  ('07', '07902', 'es Migjorn Gran', 'es-migjorn-gran');

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
  IF n < 67 THEN
    RAISE EXCEPTION 'Se esperaban al menos 67 municipios con código INE, hay %', n;
  END IF;
END;
$$;

COMMIT;

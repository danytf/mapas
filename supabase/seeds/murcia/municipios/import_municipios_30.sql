-- Municipios oficiales (código INE) de las provincias 30. Origen: OpenStreetMap (áreas administrativas de nivel 8 con ine:municipio), ODbL.
-- Inserta los que faltan y asigna el código INE a los existentes que no lo tienen. No cambia nombres ni borra nada.
-- 45 municipios. Transaccional e idempotente.

BEGIN;

CREATE TEMP TABLE _municipios (prov text, ine text, name text, norm text) ON COMMIT DROP;
INSERT INTO _municipios VALUES
  ('30', '30001', 'Abanilla', 'abanilla'),
  ('30', '30002', 'Abarán', 'abaran'),
  ('30', '30003', 'Águilas', 'aguilas'),
  ('30', '30004', 'Albudeite', 'albudeite'),
  ('30', '30005', 'Alcantarilla', 'alcantarilla'),
  ('30', '30006', 'Aledo', 'aledo'),
  ('30', '30007', 'Alguazas', 'alguazas'),
  ('30', '30008', 'Alhama de Murcia', 'alhama-de-murcia'),
  ('30', '30009', 'Archena', 'archena'),
  ('30', '30010', 'Beniel', 'beniel'),
  ('30', '30011', 'Blanca', 'blanca'),
  ('30', '30012', 'Bullas', 'bullas'),
  ('30', '30013', 'Calasparra', 'calasparra'),
  ('30', '30014', 'Campos del Río', 'campos-del-rio'),
  ('30', '30015', 'Caravaca de la Cruz', 'caravaca-de-la-cruz'),
  ('30', '30016', 'Cartagena', 'cartagena'),
  ('30', '30017', 'Cehegín', 'cehegin'),
  ('30', '30018', 'Ceutí', 'ceuti'),
  ('30', '30019', 'Cieza', 'cieza'),
  ('30', '30020', 'Fortuna', 'fortuna'),
  ('30', '30021', 'Fuente Álamo de Murcia', 'fuente-alamo-de-murcia'),
  ('30', '30022', 'Jumilla', 'jumilla'),
  ('30', '30023', 'Librilla', 'librilla'),
  ('30', '30024', 'Lorca', 'lorca'),
  ('30', '30025', 'Lorquí', 'lorqui'),
  ('30', '30026', 'Mazarrón', 'mazarron'),
  ('30', '30027', 'Molina de Segura', 'molina-de-segura'),
  ('30', '30028', 'Moratalla', 'moratalla'),
  ('30', '30029', 'Mula', 'mula'),
  ('30', '30030', 'Murcia', 'murcia'),
  ('30', '30031', 'Ojós', 'ojos'),
  ('30', '30032', 'Pliego', 'pliego'),
  ('30', '30033', 'Puerto Lumbreras', 'puerto-lumbreras'),
  ('30', '30034', 'Ricote', 'ricote'),
  ('30', '30035', 'San Javier', 'san-javier'),
  ('30', '30036', 'San Pedro del Pinatar', 'san-pedro-del-pinatar'),
  ('30', '30037', 'Torre Pacheco', 'torre-pacheco'),
  ('30', '30038', 'Las Torres de Cotillas', 'las-torres-de-cotillas'),
  ('30', '30039', 'Totana', 'totana'),
  ('30', '30040', 'Ulea', 'ulea'),
  ('30', '30041', 'La Unión', 'la-union'),
  ('30', '30042', 'Villanueva del Río Segura', 'villanueva-del-rio-segura'),
  ('30', '30043', 'Yecla', 'yecla'),
  ('30', '30901', 'Santomera', 'santomera'),
  ('30', '30902', 'Los Alcázares', 'los-alcazares');

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
  IF n < 45 THEN
    RAISE EXCEPTION 'Se esperaban al menos 45 municipios con código INE, hay %', n;
  END IF;
END;
$$;

COMMIT;

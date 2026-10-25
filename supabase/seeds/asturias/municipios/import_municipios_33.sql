-- Municipios oficiales (código INE) de las provincias 33. Origen: OpenStreetMap (áreas administrativas de nivel 8 con ine:municipio), ODbL.
-- Inserta los que faltan y asigna el código INE a los existentes que no lo tienen. No cambia nombres ni borra nada.
-- 78 municipios. Transaccional e idempotente.

BEGIN;

CREATE TEMP TABLE _municipios (prov text, ine text, name text, norm text) ON COMMIT DROP;
INSERT INTO _municipios VALUES
  ('33', '33001', 'Allande', 'allande'),
  ('33', '33002', 'Aller', 'aller'),
  ('33', '33003', 'Amieva', 'amieva'),
  ('33', '33004', 'Avilés', 'aviles'),
  ('33', '33005', 'Belmonte de Miranda', 'belmonte-de-miranda'),
  ('33', '33006', 'Bimenes', 'bimenes'),
  ('33', '33007', 'Boal', 'boal'),
  ('33', '33008', 'Cabrales', 'cabrales'),
  ('33', '33009', 'Cabranes', 'cabranes'),
  ('33', '33010', 'Candamo', 'candamo'),
  ('33', '33011', 'Cangas del Narcea', 'cangas-del-narcea'),
  ('33', '33012', 'Cangas de Onís', 'cangas-de-onis'),
  ('33', '33013', 'Caravia', 'caravia'),
  ('33', '33014', 'Carreño', 'carreno'),
  ('33', '33015', 'Caso', 'caso'),
  ('33', '33016', 'Castrillón', 'castrillon'),
  ('33', '33017', 'Castropol', 'castropol'),
  ('33', '33018', 'Coaña', 'coana'),
  ('33', '33019', 'Colunga', 'colunga'),
  ('33', '33020', 'Corvera de Asturias', 'corvera-de-asturias'),
  ('33', '33021', 'Cudillero', 'cudillero'),
  ('33', '33022', 'Degaña', 'degana'),
  ('33', '33023', 'El Franco', 'el-franco'),
  ('33', '33024', 'Gijón', 'gijon'),
  ('33', '33025', 'Gozón', 'gozon'),
  ('33', '33026', 'Grado', 'grado'),
  ('33', '33027', 'Grandas de Salime', 'grandas-de-salime'),
  ('33', '33028', 'Ibias', 'ibias'),
  ('33', '33029', 'Illano', 'illano'),
  ('33', '33030', 'Illas', 'illas'),
  ('33', '33031', 'Langreo', 'langreo'),
  ('33', '33032', 'Laviana', 'laviana'),
  ('33', '33033', 'Lena', 'lena'),
  ('33', '33034', 'Valdés', 'valdes'),
  ('33', '33035', 'Llanera', 'llanera'),
  ('33', '33036', 'Llanes', 'llanes'),
  ('33', '33037', 'Mieres', 'mieres'),
  ('33', '33038', 'Morcín', 'morcin'),
  ('33', '33039', 'Muros de Nalón', 'muros-de-nalon'),
  ('33', '33040', 'Nava', 'nava'),
  ('33', '33041', 'Navia', 'navia'),
  ('33', '33042', 'Noreña', 'norena'),
  ('33', '33043', 'Onís', 'onis'),
  ('33', '33044', 'Oviedo', 'oviedo'),
  ('33', '33045', 'Parres', 'parres'),
  ('33', '33046', 'Peñamellera Alta', 'penamellera-alta'),
  ('33', '33047', 'Peñamellera Baja', 'penamellera-baja'),
  ('33', '33048', 'Pesoz', 'pesoz'),
  ('33', '33049', 'Piloña', 'pilona'),
  ('33', '33050', 'Ponga', 'ponga'),
  ('33', '33051', 'Pravia', 'pravia'),
  ('33', '33052', 'Proaza', 'proaza'),
  ('33', '33053', 'Quirós', 'quiros'),
  ('33', '33054', 'Las Regueras', 'las-regueras'),
  ('33', '33055', 'Ribadedeva', 'ribadedeva'),
  ('33', '33056', 'Ribadesella', 'ribadesella'),
  ('33', '33057', 'Ribera de Arriba', 'ribera-de-arriba'),
  ('33', '33058', 'Riosa', 'riosa'),
  ('33', '33059', 'Salas', 'salas'),
  ('33', '33060', 'Samartín del Rei Aurelio', 'samartin-del-rei-aurelio'),
  ('33', '33061', 'San Martín de Oscos', 'san-martin-de-oscos'),
  ('33', '33062', 'Santa Eulalia de Oscos', 'santa-eulalia-de-oscos'),
  ('33', '33063', 'San Tirso de Abres', 'san-tirso-de-abres'),
  ('33', '33064', 'Santo Adriano', 'santo-adriano'),
  ('33', '33065', 'Sariego', 'sariego'),
  ('33', '33066', 'Siero', 'siero'),
  ('33', '33067', 'Sobrescobio', 'sobrescobio'),
  ('33', '33068', 'Somiedo', 'somiedo'),
  ('33', '33069', 'Soto del Barco', 'soto-del-barco'),
  ('33', '33070', 'Tapia de Casariego', 'tapia-de-casariego'),
  ('33', '33071', 'Taramundi', 'taramundi'),
  ('33', '33072', 'Teverga', 'teverga'),
  ('33', '33073', 'Tineo', 'tineo'),
  ('33', '33074', 'Vegadeo', 'vegadeo'),
  ('33', '33075', 'Villanueva de Oscos', 'villanueva-de-oscos'),
  ('33', '33076', 'Villaviciosa', 'villaviciosa'),
  ('33', '33077', 'Villayón', 'villayon'),
  ('33', '33078', 'Yernes y Tameza', 'yernes-y-tameza');

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
  IF n < 78 THEN
    RAISE EXCEPTION 'Se esperaban al menos 78 municipios con código INE, hay %', n;
  END IF;
END;
$$;

COMMIT;

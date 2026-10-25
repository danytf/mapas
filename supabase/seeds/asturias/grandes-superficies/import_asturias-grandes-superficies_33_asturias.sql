-- Carga de la categoría (varias) de Asturias (provincia 33), trozo de la carga de Andalucía.
-- Origen: asturias-grandes-superficies-asturias.json (OpenStreetMap, ODbL, consulta del 2026-10-25, base 2026-10-24T20:20:51Z).
-- 40 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  categoria text, source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-10087373351', 'Carrefour Oviedo – Avenida Fundación Príncipe de Asturias', NULL, '33044', 'Avenida Fundación Príncipe de Asturias 3', '33012', 43.36385, -5.85941, 'address', 'openstreetmap:node/10087373351'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-10099303317', 'Carrefour Oviedo – Plaza de la Paz', NULL, '33044', 'Plaza de la Paz 8', '33006', 43.35648, -5.85733, 'address', 'openstreetmap:node/10099303317'),
  ('El Corte Inglés', 'catalogo-asturias:asturias-grandes-superficies:node-10121446280', 'El Corte Inglés Oviedo – Calle General Elorza', NULL, '33044', 'Calle General Elorza 75', '33002', 43.36645, -5.84915, 'address', 'openstreetmap:node/10121446280'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-10661168005', 'Carrefour Oviedo – Avenida de Galicia', NULL, '33044', 'Avenida de Galicia', '33005', 43.3612, -5.85482, 'address', 'openstreetmap:node/10661168005'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-10707718806', 'Carrefour Avilés – Calle Doctor Severo Ochoa', NULL, '33004', 'Calle Doctor Severo Ochoa 9', '33402', 43.55412, -5.92898, 'address', 'openstreetmap:node/10707718806'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-10881949224', 'Carrefour Gijón – Camino de Cabueñes', NULL, '33024', 'Camino de Cabueñes 38', NULL, 43.53396, -5.62057, 'address', 'openstreetmap:node/10881949224'),
  ('Decathlon', 'catalogo-asturias:asturias-grandes-superficies:node-10886216982', 'Decathlon Siero', NULL, '33066', NULL, NULL, 43.41233, -5.79577, 'address', 'openstreetmap:node/10886216982'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-11099726454', 'Carrefour Gijón – Calle La Merced', NULL, '33024', 'Calle La Merced 48', '33201', 43.53969, -5.66144, 'address', 'openstreetmap:node/11099726454'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-11104191858', 'Carrefour Colunga – AUTOVIA A8 KM 347.5', NULL, '33019', 'AUTOVIA A8 KM 347.5', NULL, 43.48264, -5.28298, 'address', 'openstreetmap:node/11104191858'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-11197716465', 'Carrefour Corvera de Asturias – El Pedréu', NULL, '33020', 'El Pedréu 50', '33468', 43.54652, -5.87078, 'address', 'openstreetmap:node/11197716465'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-11206100444', 'Carrefour Pravia – Calle Bances y Valdés', NULL, '33051', 'Calle Bances y Valdés', '33120', 43.48903, -6.11436, 'address', 'openstreetmap:node/11206100444'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-11330547381', 'Carrefour Llanes – Cueto Bajo', NULL, '33036', 'Cueto Bajo 1', '33500', 43.418, -4.75368, 'address', 'openstreetmap:node/11330547381'),
  ('Leroy Merlin', 'catalogo-asturias:asturias-grandes-superficies:node-11359765202', 'Leroy Merlin Oviedo – Calle Posada Herrera', NULL, '33044', 'Calle Posada Herrera', '33002', 43.36414, -5.84874, 'address', 'openstreetmap:node/11359765202'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-12090794837', 'Carrefour Mieres – Oviedo-Campomanes', NULL, '33037', 'Oviedo-Campomanes', NULL, 43.22854, -5.78127, 'address', 'openstreetmap:node/12090794837'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-12192531088', 'Carrefour Gijón – Carretera de la Carbonera', NULL, '33024', 'Carretera de la Carbonera 183', '33210', 43.52565, -5.66737, 'address', 'openstreetmap:node/12192531088'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-12641006508', 'Carrefour Gijón – Calle Poeta Angel González Muñíz', NULL, '33024', 'Calle Poeta Angel González Muñíz 18', '33204', 43.52906, -5.64168, 'address', 'openstreetmap:node/12641006508'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-12643576727', 'Carrefour Ribadesella – Calle Oscura', NULL, '33056', 'Calle Oscura 11', '33560', 43.46097, -5.06035, 'address', 'openstreetmap:node/12643576727'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-12645107502', 'Carrefour Ribadedeva', NULL, '33055', NULL, NULL, 43.38118, -4.56529, 'address', 'openstreetmap:node/12645107502'),
  ('MediaMarkt', 'catalogo-asturias:asturias-grandes-superficies:node-13672491168', 'MediaMarkt Gijón – Autovía Oviedo - Gijón/Xixón (Autovía Industrial)', NULL, '33024', 'Autovía Oviedo - Gijón/Xixón (Autovía Industrial)', NULL, 43.5101, -5.69221, 'address', 'openstreetmap:node/13672491168'),
  ('El Corte Inglés', 'catalogo-asturias:asturias-grandes-superficies:node-2353481028', 'El Corte Inglés Oviedo – Calle Uría / Cai Uría', NULL, '33044', 'Calle Uría / Cai Uría 9', '33003', 43.36398, -5.85156, 'address', 'openstreetmap:node/2353481028'),
  ('El Corte Inglés', 'catalogo-asturias:asturias-grandes-superficies:node-3440808478', 'El Corte Inglés Siero – Calle Florencio Rodríguez', NULL, '33066', 'Calle Florencio Rodríguez', '33510', 43.39291, -5.65933, 'address', 'openstreetmap:node/3440808478'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-5519479592', 'Carrefour Oviedo – Calle Padre Suárez', NULL, '33044', 'Calle Padre Suárez 42', '33008', 43.35493, -5.84385, 'address', 'openstreetmap:node/5519479592'),
  ('Decathlon', 'catalogo-asturias:asturias-grandes-superficies:node-5655953328', 'Decathlon Oviedo – Calle Uría / Cai Uría', NULL, '33044', 'Calle Uría / Cai Uría', '33003', 43.36357, -5.85086, 'address', 'openstreetmap:node/5655953328'),
  ('Decathlon', 'catalogo-asturias:asturias-grandes-superficies:node-5901608494', 'Decathlon Gijón – Calle de Los Moros', NULL, '33024', 'Calle de Los Moros 50', '33206', 43.53987, -5.66327, 'address', 'openstreetmap:node/5901608494'),
  ('Decathlon', 'catalogo-asturias:asturias-grandes-superficies:node-6593127791', 'Decathlon Corvera de Asturias', NULL, '33020', NULL, NULL, 43.5474, -5.86899, 'address', 'openstreetmap:node/6593127791'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-673425747', 'Carrefour Oviedo – Calle Rosa María Menéndez López', NULL, '33044', 'Calle Rosa María Menéndez López', '33011', 43.37132, -5.83132, 'address', 'openstreetmap:node/673425747'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-8240355214', 'Carrefour Gijón – Plaza de San Miguel', NULL, '33024', 'Plaza de San Miguel 5', '33202', 43.53974, -5.65721, 'address', 'openstreetmap:node/8240355214'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-8266114444', 'Carrefour Gijón – Calle Anselmo Solar', NULL, '33024', 'Calle Anselmo Solar', NULL, 43.52471, -5.64133, 'address', 'openstreetmap:node/8266114444'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:node-9826478227', 'Carrefour Tapia de Casariego – N-634 KM 548.5', NULL, '33070', 'N-634 KM 548.5', NULL, 43.54224, -6.98369, 'address', 'openstreetmap:node/9826478227'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:way-1282038885', 'Carrefour Tineo – Carretera El Crucero - La Florida', NULL, '33073', 'Carretera El Crucero - La Florida', NULL, 43.34236, -6.38983, 'address', 'openstreetmap:way/1282038885'),
  ('El Corte Inglés', 'catalogo-asturias:asturias-grandes-superficies:way-13038007', 'El Corte Inglés Gijón – Calle Ramón Areces', NULL, '33024', 'Calle Ramón Areces', '33211', 43.52425, -5.6791, 'address', 'openstreetmap:way/13038007'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:way-1330493559', 'Carrefour Grado – N-634 KM 431.3', NULL, '33026', 'N-634 KM 431.3', '33820', 43.39346, -6.06419, 'address', 'openstreetmap:way/1330493559'),
  ('Leroy Merlin', 'catalogo-asturias:asturias-grandes-superficies:way-173874810', 'Leroy Merlin Gijón – Avenida de Roces', NULL, '33024', 'Avenida de Roces', NULL, 43.51302, -5.6648, 'address', 'openstreetmap:way/173874810'),
  ('Decathlon', 'catalogo-asturias:asturias-grandes-superficies:way-173877815', 'Decathlon Gijón – Calle Antonio Gaudí i Cornet', NULL, '33024', 'Calle Antonio Gaudí i Cornet', '33211', 43.50867, -5.69069, 'address', 'openstreetmap:way/173877815'),
  ('Leroy Merlin', 'catalogo-asturias:asturias-grandes-superficies:way-23678209', 'Leroy Merlin Llanera', NULL, '33035', NULL, '33690', 43.4154, -5.79922, 'address', 'openstreetmap:way/23678209'),
  ('El Corte Inglés', 'catalogo-asturias:asturias-grandes-superficies:way-36350396', 'El Corte Inglés Avilés – Carretera de Grado', NULL, '33004', 'Carretera de Grado', '33410', 43.54334, -5.93493, 'address', 'openstreetmap:way/36350396'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:way-4813769', 'Carrefour Gijón – Avenida de José Manuel Palacio', NULL, '33024', 'Avenida de José Manuel Palacio', NULL, 43.53605, -5.69571, 'address', 'openstreetmap:way/4813769'),
  ('IKEA', 'catalogo-asturias:asturias-grandes-superficies:way-51261908', 'IKEA Siero – Calle Paredes', NULL, '33066', 'Calle Paredes', NULL, 43.38788, -5.80575, 'address', 'openstreetmap:way/51261908'),
  ('Carrefour', 'catalogo-asturias:asturias-grandes-superficies:way-55226965', 'Carrefour Siero', NULL, '33066', NULL, NULL, 43.41383, -5.79587, 'address', 'openstreetmap:way/55226965'),
  ('MediaMarkt', 'catalogo-asturias:asturias-grandes-superficies:way-76939118', 'MediaMarkt Siero – C.C. Parque Principado', NULL, '33066', 'C.C. Parque Principado', NULL, 43.39245, -5.79871, 'address', 'openstreetmap:way/76939118');

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
                    WHERE m.official_code = c.muni_ine AND p.code = '33');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 33 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '33'
JOIN public.categories cat ON cat.name = c.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 40 THEN
    RAISE EXCEPTION 'Se esperaban 40 puntos de (varias) en Asturias, hay %', n;
  END IF;
END;
$$;

COMMIT;

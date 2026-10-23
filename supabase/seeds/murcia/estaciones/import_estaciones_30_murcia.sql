-- Carga de la categoría Estaciones de Murcia (provincia 30), trozo de la carga de Andalucía.
-- Origen: estaciones-murcia.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-20T23:38:36Z).
-- 49 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-murcia:estaciones:node-1151623443', 'Estación de tren de Alcantarilla', 'Tren', '30005', NULL, NULL, 37.9665, -1.20816, 'address', 'openstreetmap:node/1151623443'),
  ('catalogo-murcia:estaciones:node-13017334754', 'Estación de tren de Murcia del Carmen – Calle Industria', 'Tren', '30030', 'Calle Industria', NULL, 37.97451, -1.13059, 'address', 'openstreetmap:node/13017334754'),
  ('catalogo-murcia:estaciones:node-13519909369', 'Estación de tren de Hospital (Cartagena)', 'Tren', '30016', NULL, NULL, 37.60508, -0.961, 'address', 'openstreetmap:node/13519909369'),
  ('catalogo-murcia:estaciones:node-13672734924', 'Estación de tren de Alumbres (Cartagena)', 'Tren', '30016', NULL, NULL, 37.60994, -0.91509, 'address', 'openstreetmap:node/13672734924'),
  ('catalogo-murcia:estaciones:node-2487151778', 'Estación de tren de Los Nietos (Cartagena) – Calle Galán', 'Tren', '30016', 'Calle Galán', NULL, 37.65186, -0.79707, 'address', 'openstreetmap:node/2487151778'),
  ('catalogo-murcia:estaciones:node-2674576493', 'Estación de tren de Torre Pacheco – Calle San Mateo', 'Tren', '30037', 'Calle San Mateo 2', NULL, 37.74694, -0.96706, 'address', 'openstreetmap:node/2674576493'),
  ('catalogo-murcia:estaciones:node-3988336612', 'Estación de tren de La Unión – Calle de la Gabriela', 'Tren', '30041', 'Calle de la Gabriela', NULL, 37.61558, -0.87514, 'address', 'openstreetmap:node/3988336612'),
  ('catalogo-murcia:estaciones:node-3988336613', 'Estación de tren de Abrevadero (Cartagena) – Carretera a La Unión', 'Tren', '30016', 'Carretera a La Unión', NULL, 37.6097, -0.93183, 'address', 'openstreetmap:node/3988336613'),
  ('catalogo-murcia:estaciones:node-4719846969', 'Estación de tren de Los Nietos-Pescadería (Cartagena) – Calle Santa Teresa', 'Tren', '30016', 'Calle Santa Teresa', NULL, 37.64934, -0.78789, 'address', 'openstreetmap:node/4719846969'),
  ('catalogo-murcia:estaciones:node-4777196655', 'Estación de tren de Cieza – Calle de la Estación', 'Tren', '30019', 'Calle de la Estación', NULL, 38.24669, -1.42167, 'address', 'openstreetmap:node/4777196655'),
  ('catalogo-murcia:estaciones:node-4777196945', 'Estación de Autobuses de Cieza – Calle Luis Braille', 'Autobús', '30019', 'Calle Luis Braille', NULL, 38.24077, -1.41324, 'address', 'openstreetmap:node/4777196945'),
  ('catalogo-murcia:estaciones:node-4853400117', 'Estación de tren de Las Torres de Cotillas', 'Tren', '30038', NULL, NULL, 38.03142, -1.23762, 'address', 'openstreetmap:node/4853400117'),
  ('catalogo-murcia:estaciones:node-4853402444', 'Estación de tren de Archena-Fortuna (Molina de Segura)', 'Tren', '30027', NULL, NULL, 38.13138, -1.23588, 'address', 'openstreetmap:node/4853402444'),
  ('catalogo-murcia:estaciones:node-5342838752', 'Estación de tren de Blanca - Abaran – Calle del Pino', 'Tren', '30011', 'Calle del Pino', NULL, 38.22303, -1.32516, 'address', 'openstreetmap:node/5342838752'),
  ('catalogo-murcia:estaciones:node-5342875135', 'Estación de tren de Alguazas-Molina – Mercado Semanal de Alguazas', 'Tren', '30007', 'Mercado Semanal de Alguazas', '30560', 38.05176, -1.24539, 'address', 'openstreetmap:node/5342875135'),
  ('catalogo-murcia:estaciones:node-5342946982', 'Estación de tren de La Palma - Pozo Estrecho (Cartagena)', 'Tren', '30016', NULL, NULL, 37.69975, -0.97787, 'address', 'openstreetmap:node/5342946982'),
  ('catalogo-murcia:estaciones:node-617134268', 'Estación de tren de Cartagena – Plaza de Méjico', 'Tren', '30016', 'Plaza de Méjico', '30203', 37.60503, -0.97497, 'address', 'openstreetmap:node/617134268'),
  ('catalogo-murcia:estaciones:node-617137035', 'Estación de Autobuses de Cartagena – Calle Trovero Marín', 'Autobús', '30016', 'Calle Trovero Marín', '30202', 37.60288, -0.9766, 'address', 'openstreetmap:node/617137035'),
  ('catalogo-murcia:estaciones:node-674720434', 'Estación de Autobuses de Murcia – Calle Sierra de la Pila', 'Autobús', '30030', 'Calle Sierra de la Pila', '30005', 37.98616, -1.1395, 'address', 'openstreetmap:node/674720434'),
  ('catalogo-murcia:estaciones:node-717295164', 'Estación de tren de Media Legua (Cartagena) – Calle Vía Apia', 'Tren', '30016', 'Calle Vía Apia', NULL, 37.60786, -0.95368, 'address', 'openstreetmap:node/717295164'),
  ('catalogo-murcia:estaciones:node-717295373', 'Estación de tren de Vista Alegre (Cartagena) – Carretera a La Unión', 'Tren', '30016', 'Carretera a La Unión', NULL, 37.60927, -0.94412, 'address', 'openstreetmap:node/717295373'),
  ('catalogo-murcia:estaciones:node-737198383', 'Estación de tren de Balsicas Mar Menor (Torre Pacheco) – Calle Mar Menor', 'Tren', '30037', 'Calle Mar Menor', NULL, 37.8188, -0.95094, 'address', 'openstreetmap:node/737198383'),
  ('catalogo-murcia:estaciones:node-748286092', 'Estación de tren de La Esperanza (La Unión) – Avenida de Portmán', 'Tren', '30041', 'Avenida de Portmán', NULL, 37.61381, -0.89137, 'address', 'openstreetmap:node/748286092'),
  ('catalogo-murcia:estaciones:node-748286107', 'Estación de tren de La Unión Vieja – Calle Gabriel', 'Tren', '30041', 'Calle Gabriel', NULL, 37.61545, -0.88162, 'address', 'openstreetmap:node/748286107'),
  ('catalogo-murcia:estaciones:node-748286582', 'Estación de tren de Sierra Minera (La Unión) – Carretera a Los Blancos y Cabo de Palos', 'Tren', '30041', 'Carretera a Los Blancos y Cabo de Palos', NULL, 37.61983, -0.86484, 'address', 'openstreetmap:node/748286582'),
  ('catalogo-murcia:estaciones:node-748286712', 'Estación de tren de Llano del Beal (Cartagena) – Calle Zorrilla', 'Tren', '30016', 'Calle Zorrilla', '30381', 37.62603, -0.8362, 'address', 'openstreetmap:node/748286712'),
  ('catalogo-murcia:estaciones:node-748286774', 'Estación de tren de El Estrecho (Cartagena)', 'Tren', '30016', NULL, NULL, 37.62755, -0.82959, 'address', 'openstreetmap:node/748286774'),
  ('catalogo-murcia:estaciones:node-748851631', 'Estación de tren de Los Nietos Viejos (Cartagena) – Avenida del Progreso', 'Tren', '30016', 'Avenida del Progreso', NULL, 37.64695, -0.79151, 'address', 'openstreetmap:node/748851631'),
  ('catalogo-murcia:estaciones:way-1019783064', 'Estación de Autobuses de Caravaca (Caravaca de la Cruz) – Calle Maestro Pelayo Gallego', 'Autobús', '30015', 'Calle Maestro Pelayo Gallego', NULL, 38.09882, -1.86607, 'address', 'openstreetmap:way/1019783064'),
  ('catalogo-murcia:estaciones:way-108008475', 'Estación de tren de Águilas-El Labradorcico – Avenida de José Jiménez Ruano', 'Tren', '30003', 'Avenida de José Jiménez Ruano', NULL, 37.41182, -1.58607, 'address', 'openstreetmap:way/108008475'),
  ('catalogo-murcia:estaciones:way-112557999', 'Estación de autobuses de Águilas – Calle Papa Juan Pablo II', 'Autobús', '30003', 'Calle Papa Juan Pablo II', NULL, 37.40977, -1.57316, 'address', 'openstreetmap:way/112557999'),
  ('catalogo-murcia:estaciones:way-112558000', 'Estación de tren de Águilas – Calle Papa Juan Pablo II', 'Tren', '30003', 'Calle Papa Juan Pablo II', NULL, 37.40979, -1.57254, 'address', 'openstreetmap:way/112558000'),
  ('catalogo-murcia:estaciones:way-126854529', 'Estación de tren de Lorca Sutullena – Plaza de Carruajes', 'Tren', '30024', 'Plaza de Carruajes', NULL, 37.67193, -1.69632, 'address', 'openstreetmap:way/126854529'),
  ('catalogo-murcia:estaciones:way-165407427', 'Estación de tren de Lorca San Diego – Calle Canal de San Diego', 'Tren', '30024', 'Calle Canal de San Diego', NULL, 37.6807, -1.68562, 'address', 'openstreetmap:way/165407427'),
  ('catalogo-murcia:estaciones:way-173207485', 'Estación de tren de La Hoya (Lorca) – Carretera de Hinojar', 'Tren', '30024', 'Carretera de Hinojar', NULL, 37.70393, -1.59549, 'address', 'openstreetmap:way/173207485'),
  ('catalogo-murcia:estaciones:way-188928596', 'Estación de autobuses de Lorca – Calle José Espinosa Pomares', 'Autobús', '30024', 'Calle José Espinosa Pomares', NULL, 37.67139, -1.69671, 'address', 'openstreetmap:way/188928596'),
  ('catalogo-murcia:estaciones:way-191073013', 'Estación de Autobuses de Yecla – Avenida de la Feria', 'Autobús', '30043', 'Avenida de la Feria', '30510', 38.6168, -1.10686, 'address', 'openstreetmap:way/191073013'),
  ('catalogo-murcia:estaciones:way-223004032', 'Estación de Autobuses de San Pedro del Pinatar – Calle Mediterráneo', 'Autobús', '30036', 'Calle Mediterráneo', NULL, 37.83732, -0.78709, 'address', 'openstreetmap:way/223004032'),
  ('catalogo-murcia:estaciones:way-223915527', 'Estación de tren de Alhama de Murcia – Calle Estación', 'Tren', '30008', 'Calle Estación', NULL, 37.84935, -1.41449, 'address', 'openstreetmap:way/223915527'),
  ('catalogo-murcia:estaciones:way-228596806', 'Estación de tren de Puerto Lumbreras', 'Tren', '30033', NULL, NULL, 37.58099, -1.7319, 'address', 'openstreetmap:way/228596806'),
  ('catalogo-murcia:estaciones:way-230884427', 'Estación de autobuses Los Alcázares – Avenida José Sazatornil', 'Autobús', '30902', 'Avenida José Sazatornil', NULL, 37.72971, -0.86135, 'address', 'openstreetmap:way/230884427'),
  ('catalogo-murcia:estaciones:way-258510011', 'Estacion de Autobuses de Torre Pacheco – Calle Victoriano Jiménez Soto', 'Autobús', '30037', 'Calle Victoriano Jiménez Soto 64', '30700', 37.74148, -0.96022, 'address', 'openstreetmap:way/258510011'),
  ('catalogo-murcia:estaciones:way-262530351', 'Estación de tren de Beniel – Calle Severo Ochoa', 'Tren', '30010', 'Calle Severo Ochoa', NULL, 38.04715, -0.99549, 'address', 'openstreetmap:way/262530351'),
  ('catalogo-murcia:estaciones:way-305627405', 'Terminal de Autobuses Puerto de Mazarrón – Calle Sierra del Algarrobo', 'Autobús', '30026', 'Calle Sierra del Algarrobo', '30860', 37.56703, -1.2624, 'address', 'openstreetmap:way/305627405'),
  ('catalogo-murcia:estaciones:way-328490518', 'Estación de autobuses (Jumilla) – Paseo Poeta Lorenzo Guardiola', 'Autobús', '30022', 'Paseo Poeta Lorenzo Guardiola', '30520', 38.47134, -1.32668, 'address', 'openstreetmap:way/328490518'),
  ('catalogo-murcia:estaciones:way-337649138', 'Estación de autobuses (Molina de Segura) – Pasaje Compositor Antonio López Almagro', 'Autobús', '30027', 'Pasaje Compositor Antonio López Almagro', '30500', 38.05812, -1.21355, 'address', 'openstreetmap:way/337649138'),
  ('catalogo-murcia:estaciones:way-515849238', 'Estación de Autobuses (Abarán) – Calle Almazara', 'Autobús', '30002', 'Calle Almazara', NULL, 38.19991, -1.39796, 'address', 'openstreetmap:way/515849238'),
  ('catalogo-murcia:estaciones:way-526830003', 'Estación de Autobuses (Mula) – Calle Cristo Crucificado', 'Autobús', '30029', 'Calle Cristo Crucificado', NULL, 38.03707, -1.49168, 'address', 'openstreetmap:way/526830003'),
  ('catalogo-murcia:estaciones:way-845360189', 'Estación de Autobuses de Cehegín – Calle Ceramistas', 'Autobús', '30017', 'Calle Ceramistas 1', '30430', 38.09116, -1.80218, 'address', 'openstreetmap:way/845360189');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '30');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 30 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '30'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 49 THEN
    RAISE EXCEPTION 'Se esperaban 49 puntos de Estaciones en Murcia, hay %', n;
  END IF;
END;
$$;

COMMIT;

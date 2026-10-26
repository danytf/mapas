-- Carga de la categoría Estaciones de Ciudad Real (provincia 13), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-la-mancha.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 29 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-la-mancha:estaciones:node-13717016710', 'Estación de tren de Ciudad Real – Avenida de Europa', 'Tren', '13034', 'Avenida de Europa 1', '13005', 38.98487, -3.91314, 'address', 'openstreetmap:node/13717016710'),
  ('catalogo-castilla-la-mancha:estaciones:node-13805392228', 'Estación de Autobuses (Malagón) – Carretera de Torralba', 'Autobús', '13052', 'Carretera de Torralba 20', NULL, 39.16469, -3.85002, 'address', 'openstreetmap:node/13805392228'),
  ('catalogo-castilla-la-mancha:estaciones:node-2052060244', 'Estación de tren de Almuradiel-Viso del Marques – Calle San Antonio', 'Tren', '13016', 'Calle San Antonio', NULL, 38.51436, -3.50194, 'address', 'openstreetmap:node/2052060244'),
  ('catalogo-castilla-la-mancha:estaciones:node-2389630162', 'Estación de tren de Santa Cruz de Mudela – Paseo Castela', 'Tren', '13077', 'Paseo Castela', NULL, 38.64459, -3.45135, 'address', 'openstreetmap:node/2389630162'),
  ('catalogo-castilla-la-mancha:estaciones:node-2397422303', 'Estación de tren de Socuéllamos', 'Tren', '13078', NULL, NULL, 39.27854, -2.77539, 'address', 'openstreetmap:node/2397422303'),
  ('catalogo-castilla-la-mancha:estaciones:node-247377447', 'Estación de tren de Brazatortas - Veredas', 'Tren', '13024', NULL, NULL, 38.66886, -4.31665, 'address', 'openstreetmap:node/247377447'),
  ('catalogo-castilla-la-mancha:estaciones:node-2518537266', 'Estación de tren de Daimiel – Avenida de las Comunidades', 'Tren', '13039', 'Avenida de las Comunidades', NULL, 39.06141, -3.60408, 'address', 'openstreetmap:node/2518537266'),
  ('catalogo-castilla-la-mancha:estaciones:node-2519683289', 'Estación de tren de Almagro – Ronda de la Estación', 'Tren', '13013', 'Ronda de la Estación', NULL, 38.89551, -3.70965, 'address', 'openstreetmap:node/2519683289'),
  ('catalogo-castilla-la-mancha:estaciones:node-5254727527', 'Estación de tren de Guadalmez - Los Pedroches', 'Tren', '13046', NULL, NULL, 38.69929, -4.92948, 'address', 'openstreetmap:node/5254727527'),
  ('catalogo-castilla-la-mancha:estaciones:node-5264398542', 'Estación de autobuses de Villanueva de la Fuente – Avenida de Castilla La Mancha', 'Autobús', '13092', 'Avenida de Castilla La Mancha', NULL, 38.69443, -2.69685, 'address', 'openstreetmap:node/5264398542'),
  ('catalogo-castilla-la-mancha:estaciones:node-539006238', 'Estación de tren de Almadenejos - Almadén – Carretera Almadenejos-Almadén', 'Tren', '13012', 'Carretera Almadenejos-Almadén', NULL, 38.74044, -4.73031, 'address', 'openstreetmap:node/539006238'),
  ('catalogo-castilla-la-mancha:estaciones:node-6286777369', 'Estación de Autobuses (Argamasilla de Alba) – Calle Santa María', 'Autobús', '13019', 'Calle Santa María', NULL, 39.1286, -3.10301, 'address', 'openstreetmap:node/6286777369'),
  ('catalogo-castilla-la-mancha:estaciones:node-6766511991', 'Estación de tren de Alcázar de San Juan – Avenida de Álvarez Guerra', 'Tren', '13005', 'Avenida de Álvarez Guerra 21', NULL, 39.39566, -3.20537, 'address', 'openstreetmap:node/6766511991'),
  ('catalogo-castilla-la-mancha:estaciones:node-7752700240', 'Estación de tren de Cinco Casas (Alcázar de San Juan) – Calle Virgen de las Nieves', 'Tren', '13005', 'Calle Virgen de las Nieves', NULL, 39.16888, -3.23305, 'address', 'openstreetmap:node/7752700240'),
  ('catalogo-castilla-la-mancha:estaciones:node-7752700243', 'Estación de tren de Manzanares – Calle Roberto Muñoz', 'Tren', '13053', 'Calle Roberto Muñoz', NULL, 39.0059, -3.3706, 'address', 'openstreetmap:node/7752700243'),
  ('catalogo-castilla-la-mancha:estaciones:node-7752700244', 'Estación de tren de Valdepeñas – Paseo de la Estación', 'Tren', '13087', 'Paseo de la Estación', NULL, 38.76328, -3.39614, 'address', 'openstreetmap:node/7752700244'),
  ('catalogo-castilla-la-mancha:estaciones:node-8072630141', 'Estación de tren de Campo de Criptana – Avenida Juan Carlos I', 'Tren', '13028', 'Avenida Juan Carlos I', NULL, 39.39438, -3.1177, 'address', 'openstreetmap:node/8072630141'),
  ('catalogo-castilla-la-mancha:estaciones:node-9893687907', 'Estación de tren de Puertollano – Calle del Muelle', 'Tren', '13071', 'Calle del Muelle', '13500', 38.69129, -4.11194, 'address', 'openstreetmap:node/9893687907'),
  ('catalogo-castilla-la-mancha:estaciones:way-155856964', 'Estación de Autobuses (Puertollano) – Avenida de Ciudad Real', 'Autobús', '13071', 'Avenida de Ciudad Real 1', '13500', 38.69571, -4.10902, 'address', 'openstreetmap:way/155856964'),
  ('catalogo-castilla-la-mancha:estaciones:way-174682334', 'Estación de Autobuses (Almadén) – Plaza Manuel de Falla', 'Autobús', '13011', 'Plaza Manuel de Falla 18', NULL, 38.77425, -4.83632, 'address', 'openstreetmap:way/174682334'),
  ('catalogo-castilla-la-mancha:estaciones:way-292606043', 'Estación de Autobuses (Almagro) – Calle Ejido de Calatrava', 'Autobús', '13013', 'Calle Ejido de Calatrava', NULL, 38.88958, -3.70631, 'address', 'openstreetmap:way/292606043'),
  ('catalogo-castilla-la-mancha:estaciones:way-292800347', 'Estación de autobuses (Manzanares) – Calle Bautista de la Concepción', 'Autobús', '13053', 'Calle Bautista de la Concepción', NULL, 39.00644, -3.36762, 'address', 'openstreetmap:way/292800347'),
  ('catalogo-castilla-la-mancha:estaciones:way-344367707', 'Estación de Autobuses de Ciudad Real – Calle Residencial Alarcos IV', 'Autobús', '13034', 'Calle Residencial Alarcos IV', '13004', 38.97925, -3.93025, 'address', 'openstreetmap:way/344367707'),
  ('catalogo-castilla-la-mancha:estaciones:way-349813586', 'Estación de Autobuses (Alcázar de San Juan) – Avenida de la Constitución', 'Autobús', '13005', 'Avenida de la Constitución', NULL, 39.39304, -3.21832, 'address', 'openstreetmap:way/349813586'),
  ('catalogo-castilla-la-mancha:estaciones:way-373291203', 'Estación de Autobuses de Valdepeñas – Calle de la Feria del Vino', 'Autobús', '13087', 'Calle de la Feria del Vino', NULL, 38.76371, -3.39529, 'address', 'openstreetmap:way/373291203'),
  ('catalogo-castilla-la-mancha:estaciones:way-553705642', 'Estación Autobuses (Tomelloso) – Calle Madrid', 'Autobús', '13082', 'Calle Madrid 1', '13700', 39.16399, -3.01736, 'address', 'openstreetmap:way/553705642'),
  ('catalogo-castilla-la-mancha:estaciones:way-556090302', 'Estación de Autobuses (Bolaños de Calatrava) – Calle Ronda de todos los Mártires', 'Autobús', '13023', 'Calle Ronda de todos los Mártires', NULL, 38.90319, -3.668, 'address', 'openstreetmap:way/556090302'),
  ('catalogo-castilla-la-mancha:estaciones:way-734132315', 'Estación de Autobuses (Socuéllamos) – Calle Alpujarra', 'Autobús', '13078', 'Calle Alpujarra', '13630', 39.28384, -2.80142, 'address', 'openstreetmap:way/734132315'),
  ('catalogo-castilla-la-mancha:estaciones:way-903224377', 'Estación de Autobuses (La Solana) – Avenida de la Constitución', 'Autobús', '13079', 'Avenida de la Constitución', '13240', 38.94101, -3.24702, 'address', 'openstreetmap:way/903224377');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '13');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 13 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '13'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 29 THEN
    RAISE EXCEPTION 'Se esperaban 29 puntos de Estaciones en Ciudad Real, hay %', n;
  END IF;
END;
$$;

COMMIT;

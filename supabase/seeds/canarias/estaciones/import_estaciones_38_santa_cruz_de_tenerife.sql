-- Carga de la categoría Estaciones de Santa Cruz de Tenerife (provincia 38), trozo de la carga de Andalucía.
-- Origen: estaciones-canarias.json (OpenStreetMap, ODbL, consulta del 2026-10-19, base 2026-10-21T20:21:46Z).
-- 25 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-canarias:estaciones:node-2652526891', 'Estación de autobuses de Loro Parque Gratis Express (Puerto de la Cruz) – Calle del Bergantín', 'Autobús', '38028', 'Calle del Bergantín', NULL, 28.40837, -16.56605, 'address', 'openstreetmap:node/2652526891'),
  ('catalogo-canarias:estaciones:node-3315443961', 'Estación de autobuses de LOS CRISTIANOS (Arona) – Avenida de Juan Carlos I', 'Autobús', '38006', 'Avenida de Juan Carlos I', '38650', 28.05425, -16.712, 'address', 'openstreetmap:node/3315443961'),
  ('catalogo-canarias:estaciones:node-585485493', 'Antigua Estacion de Guaguas (Arafo) – Avenida de los Reyes de España', 'Autobús', '38004', 'Avenida de los Reyes de España 23', '38550', 28.33842, -16.41968, 'address', 'openstreetmap:node/585485493'),
  ('catalogo-canarias:estaciones:way-120519097', 'Estación de Guaguas (Valle Gran Rey) – Carretera General Valle Gran Rey', 'Autobús', '38049', 'Carretera General Valle Gran Rey', NULL, 28.09369, -17.33537, 'address', 'openstreetmap:way/120519097'),
  ('catalogo-canarias:estaciones:way-122873035', 'Estación de Guaguas de Candelaria – Calle Crugiola', 'Autobús', '38011', 'Calle Crugiola', NULL, 28.3628, -16.36754, 'address', 'openstreetmap:way/122873035'),
  ('catalogo-canarias:estaciones:way-1243740638', 'PB Bus (Granadilla de Abona)', 'Autobús', '38017', NULL, NULL, 28.04933, -16.57495, 'address', 'openstreetmap:way/1243740638'),
  ('catalogo-canarias:estaciones:way-1244160374', 'PB Bus (Granadilla de Abona)', 'Autobús', '38017', NULL, NULL, 28.04833, -16.57783, 'address', 'openstreetmap:way/1244160374'),
  ('catalogo-canarias:estaciones:way-135741474', 'Estación de autobuses de Alajero', 'Autobús', '38003', NULL, NULL, 28.06993, -17.23806, 'address', 'openstreetmap:way/135741474'),
  ('catalogo-canarias:estaciones:way-159229366', 'Intercambiador de la Laguna (San Cristóbal de La Laguna) – Avenida Ángel Guimerá Jorge', 'Autobús', '38023', 'Avenida Ángel Guimerá Jorge', NULL, 28.48028, -16.31702, 'address', 'openstreetmap:way/159229366'),
  ('catalogo-canarias:estaciones:way-201172994', 'Estación de Guaguas de Los Llanos (Los Llanos de Aridane) – Calle Ramón Poll', 'Autobús', '38024', 'Calle Ramón Poll', '38760', 28.66061, -17.91594, 'address', 'openstreetmap:way/201172994'),
  ('catalogo-canarias:estaciones:way-215056766', 'Estación de Guaguas de La Orotava – Calle San Juan Bosco', 'Autobús', '38026', 'Calle San Juan Bosco', NULL, 28.39355, -16.51952, 'address', 'openstreetmap:way/215056766'),
  ('catalogo-canarias:estaciones:way-215056767', 'Estación de Guaguas Playa de las Américas (Adeje) – Avenida de los Pueblos', 'Autobús', '38001', 'Avenida de los Pueblos', NULL, 28.07156, -16.72797, 'address', 'openstreetmap:way/215056767'),
  ('catalogo-canarias:estaciones:way-215056768', 'Estación de Guaguas de Buenavista del Norte – Calle Cancela', 'Autobús', '38010', 'Calle Cancela', '38480', 28.37043, -16.84832, 'address', 'openstreetmap:way/215056768'),
  ('catalogo-canarias:estaciones:way-215056773', 'Estación de Guaguas de Guía de Isora – Avenida Isora', 'Autobús', '38019', 'Avenida Isora 5', '38680', 28.20773, -16.77606, 'address', 'openstreetmap:way/215056773'),
  ('catalogo-canarias:estaciones:way-215056775', 'Estación de Guaguas de Güímar – Avenida de Santa Cruz', 'Autobús', '38020', 'Avenida de Santa Cruz 47', '38500', 28.3189, -16.40858, 'address', 'openstreetmap:way/215056775'),
  ('catalogo-canarias:estaciones:way-215056778', 'Estación de Guaguas de Icod (Icod de los Vinos) – Calle Francisco Miranda', 'Autobús', '38022', 'Calle Francisco Miranda 4', '38430', 28.36934, -16.71984, 'address', 'openstreetmap:way/215056778'),
  ('catalogo-canarias:estaciones:way-215056780', 'Estación de Guaguas de Tacoronte – Calle César Manrique', 'Autobús', '38043', 'Calle César Manrique', NULL, 28.47546, -16.41576, 'address', 'openstreetmap:way/215056780'),
  ('catalogo-canarias:estaciones:way-251369871', 'Estación de Guaguas San Sebastián (San Sebastián de la Gomera) – Avenida Quinto Centenario', 'Autobús', '38036', 'Avenida Quinto Centenario 3', '38800', 28.09184, -17.11373, 'address', 'openstreetmap:way/251369871'),
  ('catalogo-canarias:estaciones:way-304515655', 'Terminal de Guaguas El Pinar (El Pinar de El Hierro) – Calle Pino', 'Autobús', '38901', 'Calle Pino 72', '38914', 27.70183, -17.9809, 'address', 'openstreetmap:way/304515655'),
  ('catalogo-canarias:estaciones:way-52323659', 'Estación de Guaguas Valverde – Calle El Molino', 'Autobús', '38048', 'Calle El Molino 5d', '38900', 27.8048, -17.91368, 'address', 'openstreetmap:way/52323659'),
  ('catalogo-canarias:estaciones:way-53165366', 'Estación de Frontera – Calle la Corredera', 'Autobús', '38013', 'Calle la Corredera 11', '38911', 27.75434, -18.01114, 'address', 'openstreetmap:way/53165366'),
  ('catalogo-canarias:estaciones:way-548838026', 'Estación de autobuses de Parada Preferente de Guaguas Muelle de San Sebastián (San Sebastián de la Gomera) – Paseo de Fred Olsen', 'Autobús', '38036', 'Paseo de Fred Olsen', NULL, 28.08818, -17.10686, 'approximate', 'openstreetmap:way/548838026'),
  ('catalogo-canarias:estaciones:way-552312011', 'Estación de autobuses de Hospital (Breña Alta) – Calle Europa', 'Autobús', '38008', 'Calle Europa', NULL, 28.67422, -17.79036, 'address', 'openstreetmap:way/552312011'),
  ('catalogo-canarias:estaciones:way-612987014', 'Estación de autobuses de Loro Parque Gratis Express (Puerto de la Cruz) – C. de San Telmo, 30', 'Autobús', '38028', 'C. de San Telmo, 30 30', '38400', 28.41741, -16.54524, 'address', 'openstreetmap:way/612987014'),
  ('catalogo-canarias:estaciones:way-765572215', 'Estación de autobuses de Puerto de la Cruz – Paseo Hermanos Fernández Perdigón', 'Autobús', '38028', 'Paseo Hermanos Fernández Perdigón', '38400', 28.41339, -16.55466, 'address', 'openstreetmap:way/765572215');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '38');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 38 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '38'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 25 THEN
    RAISE EXCEPTION 'Se esperaban 25 puntos de Estaciones en Santa Cruz de Tenerife, hay %', n;
  END IF;
END;
$$;

COMMIT;

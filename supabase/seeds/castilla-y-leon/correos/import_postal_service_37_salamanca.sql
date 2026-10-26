-- Carga de la categoría Correos de Salamanca (provincia 37), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 24 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:postal_service:node-1618530531', 'Correos Guijuelo – Calle Nueva de la Iglesia', NULL, '37156', 'Calle Nueva de la Iglesia', NULL, 40.55571, -5.67319, 'address', 'openstreetmap:node/1618530531'),
  ('catalogo-castilla-y-leon:postal_service:node-1739098994', 'Correos Vilvestre – Plaza Mayor', NULL, '37350', 'Plaza Mayor 1', '37258', 41.1046, -6.72643, 'address', 'openstreetmap:node/1739098994'),
  ('catalogo-castilla-y-leon:postal_service:node-1763998632', 'Correos Vitigudino – Calle de Vidal González', NULL, '37376', 'Calle de Vidal González 3', '37210', 41.00772, -6.43592, 'address', 'openstreetmap:node/1763998632'),
  ('catalogo-castilla-y-leon:postal_service:node-3600030690', 'Correos Alba de Tormes – Carretera de Peñaranda', NULL, '37008', 'Carretera de Peñaranda 27', '37800', 40.82594, -5.50928, 'address', 'openstreetmap:node/3600030690'),
  ('catalogo-castilla-y-leon:postal_service:node-4194347142', 'Correos Ciudad Rodrigo – Calle San Juan', NULL, '37107', 'Calle San Juan 17', '37500', 40.59639, -6.5331, 'address', 'openstreetmap:node/4194347142'),
  ('catalogo-castilla-y-leon:postal_service:node-4733684180', 'Correos Vitigudino – Calle de Vidal González', NULL, '37376', 'Calle de Vidal González 22', '37210', 41.00706, -6.43649, 'address', 'openstreetmap:node/4733684180'),
  ('catalogo-castilla-y-leon:postal_service:node-4755465871', 'Correos Villamayor – Calle Sur', NULL, '37354', 'Calle Sur', NULL, 41.00011, -5.69799, 'address', 'openstreetmap:node/4755465871'),
  ('catalogo-castilla-y-leon:postal_service:node-4851617146', 'Correos Peñaranda de Bracamonte – Calle del Carmen', NULL, '37246', 'Calle del Carmen 20', '37300', 40.90065, -5.20027, 'address', 'openstreetmap:node/4851617146'),
  ('catalogo-castilla-y-leon:postal_service:node-4851617186', 'Correos Lumbrales – Carretera de la Estación', NULL, '37173', 'Carretera de la Estación 75', '37240', 40.93619, -6.71806, 'address', 'openstreetmap:node/4851617186'),
  ('catalogo-castilla-y-leon:postal_service:node-5062573951', 'Correos Masueco – Plaza El Jardín', NULL, '37184', 'Plaza El Jardín 1', NULL, 41.20334, -6.58901, 'address', 'openstreetmap:node/5062573951'),
  ('catalogo-castilla-y-leon:postal_service:node-524872496', 'Correos Salamanca – Calle del Maestro Soler 26-28', NULL, '37274', 'Calle del Maestro Soler 26-28', '37008', 40.95289, -5.66424, 'address', 'openstreetmap:node/524872496'),
  ('catalogo-castilla-y-leon:postal_service:node-618648003', 'Correos Salamanca – Calle de León Felipe', NULL, '37274', 'Calle de León Felipe 12', '37007', 40.97135, -5.66843, 'address', 'openstreetmap:node/618648003'),
  ('catalogo-castilla-y-leon:postal_service:node-618648007', 'Correos Salamanca – Avenida de París 2-4', NULL, '37274', 'Avenida de París 2-4', '37004', 40.97275, -5.64896, 'address', 'openstreetmap:node/618648007'),
  ('catalogo-castilla-y-leon:postal_service:node-6334332003', 'Correos Macotera – Calle Honda', NULL, '37174', 'Calle Honda 1', '37310', 40.83071, -5.28589, 'address', 'openstreetmap:node/6334332003'),
  ('catalogo-castilla-y-leon:postal_service:node-651500735', 'Correos Santa Marta de Tormes – Calle Carlos III', NULL, '37294', 'Calle Carlos III 2', '37900', 40.94963, -5.63155, 'address', 'openstreetmap:node/651500735'),
  ('catalogo-castilla-y-leon:postal_service:node-770198894', 'Correos Salamanca – Avenida de Portugal', NULL, '37274', 'Avenida de Portugal 75', '37005', 40.97148, -5.65968, 'address', 'openstreetmap:node/770198894'),
  ('catalogo-castilla-y-leon:postal_service:relation-912519', 'Correos Salamanca – Calle Gran Vía 25,29', NULL, '37274', 'Calle Gran Vía 25,29', '37001', 40.96659, -5.65947, 'address', 'openstreetmap:relation/912519'),
  ('catalogo-castilla-y-leon:postal_service:way-277990180', 'Correos Cilleros de la Bastida – Calle Fuente Nogal', NULL, '37104', 'Calle Fuente Nogal', NULL, 40.57593, -6.06018, 'address', 'openstreetmap:way/277990180'),
  ('catalogo-castilla-y-leon:postal_service:way-279496884', 'Correos Tamames – Avenida de Salamanca', NULL, '37316', 'Avenida de Salamanca 77', '37600', 40.65645, -6.10473, 'address', 'openstreetmap:way/279496884'),
  ('catalogo-castilla-y-leon:postal_service:way-409559863', 'Correos Fuentes de Oñoro – Plaza de Europa', NULL, '37140', 'Plaza de Europa 1', '37480', 40.60556, -6.82386, 'address', 'openstreetmap:way/409559863'),
  ('catalogo-castilla-y-leon:postal_service:way-493233101', 'Correos Ledesma – Calle La Ronda', NULL, '37170', 'Calle La Ronda 1', NULL, 41.0891, -5.9981, 'address', 'openstreetmap:way/493233101'),
  ('catalogo-castilla-y-leon:postal_service:way-53493553', 'Correos Béjar – Travesía Santa Ana', NULL, '37046', 'Travesía Santa Ana 4', '37700', 40.38541, -5.7665, 'address', 'openstreetmap:way/53493553'),
  ('catalogo-castilla-y-leon:postal_service:way-661225742', 'Correos La Fuente de San Esteban – Plaza de España', NULL, '37135', 'Plaza de España', '37200', 40.80174, -6.25859, 'address', 'openstreetmap:way/661225742'),
  ('catalogo-castilla-y-leon:postal_service:way-670207580', 'Correos Robleda – Calle Paz', NULL, '37269', 'Calle Paz 5', '37521', 40.38465, -6.60894, 'address', 'openstreetmap:way/670207580');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '37');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 37 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '37'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 24 THEN
    RAISE EXCEPTION 'Se esperaban 24 puntos de Correos en Salamanca, hay %', n;
  END IF;
END;
$$;

COMMIT;

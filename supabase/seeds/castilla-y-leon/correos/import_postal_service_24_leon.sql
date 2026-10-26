-- Carga de la categoría Correos de León (provincia 24), trozo de la carga de Andalucía.
-- Origen: postal_service-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 20 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:postal_service:node-10103549608', 'Correos Villaquejida – Calle Carretera', NULL, '24221', 'Calle Carretera 51', '24235', 42.14446, -5.59992, 'address', 'openstreetmap:node/10103549608'),
  ('catalogo-castilla-y-leon:postal_service:node-11323334291', 'Correos Toreno – Plaza Mayor', NULL, '24169', 'Plaza Mayor 1', '24450', 42.69774, -6.51312, 'address', 'openstreetmap:node/11323334291'),
  ('catalogo-castilla-y-leon:postal_service:node-11383826144', 'Correos Fabero – Calle Gil y Carrasco', NULL, '24070', 'Calle Gil y Carrasco 12', '24420', 42.76627, -6.62677, 'address', 'openstreetmap:node/11383826144'),
  ('catalogo-castilla-y-leon:postal_service:node-12137160529', 'Correos Congosto – Carretera Antigua N-VI', NULL, '24057', 'Carretera Antigua N-VI', NULL, 42.58921, -6.51987, 'address', 'openstreetmap:node/12137160529'),
  ('catalogo-castilla-y-leon:postal_service:node-12469934681', 'Correos Cistierna – Avenida Constitución', NULL, '24056', 'Avenida Constitución', '24800', 42.80555, -5.12966, 'address', 'openstreetmap:node/12469934681'),
  ('catalogo-castilla-y-leon:postal_service:node-13289057926', 'Correos León – Avenida Doctor Fleming', NULL, '24089', 'Avenida Doctor Fleming 37', '24009', 42.59714, -5.58528, 'address', 'openstreetmap:node/13289057926'),
  ('catalogo-castilla-y-leon:postal_service:node-13831572301', 'Correos Valverde de la Virgen – Calle la Basílica', NULL, '24189', 'Calle la Basílica', '24198', 42.58045, -5.64111, 'address', 'openstreetmap:node/13831572301'),
  ('catalogo-castilla-y-leon:postal_service:node-1667145515', 'Correos La Pola de Gordón – Plaza mayor', NULL, '24114', 'Plaza mayor', '24600', 42.8548, -5.67026, 'address', 'openstreetmap:node/1667145515'),
  ('catalogo-castilla-y-leon:postal_service:node-1803601769', 'Correos Santa María del Páramo – Travesía de Cirilo Santos', NULL, '24157', 'Travesía de Cirilo Santos', '24240', 42.3542, -5.75067, 'address', 'openstreetmap:node/1803601769'),
  ('catalogo-castilla-y-leon:postal_service:node-1895699962', 'Correos Cacabelos – Calle los Morales', NULL, '24030', 'Calle los Morales 5', '24540', 42.5987, -6.72427, 'address', 'openstreetmap:node/1895699962'),
  ('catalogo-castilla-y-leon:postal_service:node-2543537986', 'Correos Villafranca del Bierzo – Calle del Agua', NULL, '24209', 'Calle del Agua 49', '24500', 42.60639, -6.81083, 'address', 'openstreetmap:node/2543537986'),
  ('catalogo-castilla-y-leon:postal_service:node-4934988621', 'Correos Camponaraya – Avenida Camino de Santiago', NULL, '24034', 'Avenida Camino de Santiago 176', NULL, 42.57715, -6.66396, 'address', 'openstreetmap:node/4934988621'),
  ('catalogo-castilla-y-leon:postal_service:node-6182324968', 'Correos Riaño – Avenida Valcayo', NULL, '24130', 'Avenida Valcayo 12', '24900', 42.97573, -5.00591, 'address', 'openstreetmap:node/6182324968'),
  ('catalogo-castilla-y-leon:postal_service:node-6646337962', 'Correos León – Avenida País Leonés', NULL, '24089', 'Avenida País Leonés 3', '24010', 42.61109, -5.594, 'address', 'openstreetmap:node/6646337962'),
  ('catalogo-castilla-y-leon:postal_service:node-6932083136', 'Correos Bembibre – Calle Río Boeza', NULL, '24014', 'Calle Río Boeza 10', '24300', 42.61543, -6.41883, 'address', 'openstreetmap:node/6932083136'),
  ('catalogo-castilla-y-leon:postal_service:node-778485886', 'Correos Astorga – Calle Señor Ovalle', NULL, '24008', 'Calle Señor Ovalle 10', '24700', 42.45499, -6.05195, 'address', 'openstreetmap:node/778485886'),
  ('catalogo-castilla-y-leon:postal_service:node-963596054', 'Correos Sahagún – Calle Regina Franco', NULL, '24139', 'Calle Regina Franco', '24320', 42.37129, -5.02947, 'address', 'openstreetmap:node/963596054'),
  ('catalogo-castilla-y-leon:postal_service:way-129716079', 'Correos Ponferrada – Calle General Vives', NULL, '24115', 'Calle General Vives 1', '24400', 42.54693, -6.59128, 'address', 'openstreetmap:way/129716079'),
  ('catalogo-castilla-y-leon:postal_service:way-181774230', 'Correos La Robla – Calle Mayor', NULL, '24134', 'Calle Mayor 1', '24640', 42.80339, -5.62876, 'address', 'openstreetmap:way/181774230'),
  ('catalogo-castilla-y-leon:postal_service:way-45821651', 'Correos León – Avenida Independencia', NULL, '24089', 'Avenida Independencia 27', '24003', 42.59465, -5.57109, 'address', 'openstreetmap:way/45821651');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'postal_service' AND name = 'Correos') THEN
    RAISE EXCEPTION 'Falta la categoría Correos.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '24');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 24 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '24'
JOIN public.categories cat ON cat.code = 'postal_service'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 20 THEN
    RAISE EXCEPTION 'Se esperaban 20 puntos de Correos en León, hay %', n;
  END IF;
END;
$$;

COMMIT;

-- Carga de la categoría Estaciones de Salamanca (provincia 37), trozo de la carga de Andalucía.
-- Origen: estaciones-castilla-y-leon.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 21 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-castilla-y-leon:estaciones:node-10805162798', 'Estación de tren de La Alamedilla (Salamanca) – Calle Espronceda', 'Tren', '37274', 'Calle Espronceda 2', '37003', 40.96676, -5.65626, 'address', 'openstreetmap:node/10805162798'),
  ('catalogo-castilla-y-leon:estaciones:node-12594036573', 'Estación de tren de Cantalapiedra – Calle Cardillares', 'Tren', '37081', 'Calle Cardillares', NULL, 41.13362, -5.18312, 'address', 'openstreetmap:node/12594036573'),
  ('catalogo-castilla-y-leon:estaciones:node-13644071839', 'Estación de tren de Aldealengua – Avenida de Salamanca', 'Tren', '37016', 'Avenida de Salamanca 37', '37350', 40.97971, -5.55317, 'address', 'openstreetmap:node/13644071839'),
  ('catalogo-castilla-y-leon:estaciones:node-13644818966', 'Estación de tren de Peñaranda de Bracamonte – Ronda de la Estación', 'Tren', '37246', 'Ronda de la Estación 13', '37300', 40.89793, -5.20648, 'address', 'openstreetmap:node/13644818966'),
  ('catalogo-castilla-y-leon:estaciones:node-13644818967', 'Estación de tren de Villar de Gallimazo – Camino Estación', 'Tren', '37358', 'Camino Estación 22', '37320', 40.95195, -5.29607, 'address', 'openstreetmap:node/13644818967'),
  ('catalogo-castilla-y-leon:estaciones:node-14141879023', 'Estación de Autobuses de Bejar – Paseo de Cervantes', 'Autobús', '37046', 'Paseo de Cervantes', '37700', 40.38411, -5.76123, 'address', 'openstreetmap:node/14141879023'),
  ('catalogo-castilla-y-leon:estaciones:node-2203343273', 'Estación de tren de Babilafuente – SA-810 a SA-804', 'Tren', '37038', 'SA-810 a SA-804', NULL, 40.97228, -5.43053, 'address', 'openstreetmap:node/2203343273'),
  ('catalogo-castilla-y-leon:estaciones:node-2203343275', 'Estación de tren de San Morales', 'Tren', '37288', NULL, NULL, 40.98411, -5.49276, 'address', 'openstreetmap:node/2203343275'),
  ('catalogo-castilla-y-leon:estaciones:node-2327649925', 'Estación de tren de Pitiegua', 'Tren', '37254', NULL, NULL, 41.06379, -5.47414, 'address', 'openstreetmap:node/2327649925'),
  ('catalogo-castilla-y-leon:estaciones:node-3108409389', 'Estación de autobuses de El Caseto (Buenamadre) – Calle Lino', 'Autobús', '37059', 'Calle Lino', '37209', 40.85636, -6.24963, 'address', 'openstreetmap:node/3108409389'),
  ('catalogo-castilla-y-leon:estaciones:node-3734358313', 'Estación de Autobuses de la Presa del Águeda (El Bodón) – Barrio de la Presa', 'Autobús', '37054', 'Barrio de la Presa', NULL, 40.44831, -6.57943, 'address', 'openstreetmap:node/3734358313'),
  ('catalogo-castilla-y-leon:estaciones:node-4448930346', 'Estación de tren de Salamanca – Calle de la Radio', 'Tren', '37274', 'Calle de la Radio', '37003', 40.97138, -5.64863, 'address', 'openstreetmap:node/4448930346'),
  ('catalogo-castilla-y-leon:estaciones:node-540372481', 'Estación de tren de Gomecello – Calle Barreros', 'Tren', '37152', 'Calle Barreros 18', '37420', 41.04231, -5.54116, 'address', 'openstreetmap:node/540372481'),
  ('catalogo-castilla-y-leon:estaciones:node-594262575', 'Estación de tren de El Pedroso de la Armuña', 'Tren', '37239', NULL, NULL, 41.07987, -5.40664, 'address', 'openstreetmap:node/594262575'),
  ('catalogo-castilla-y-leon:estaciones:node-602413543', 'Estación de tren de Moriscos – Castellanos de Moriscos a Moriscos', 'Tren', '37207', 'Castellanos de Moriscos a Moriscos', NULL, 41.01184, -5.58454, 'address', 'openstreetmap:node/602413543'),
  ('catalogo-castilla-y-leon:estaciones:way-158296971', 'Estación de Autobuses (Peñaranda de Bracamonte) – Avenida de Los Jardines', 'Autobús', '37246', 'Avenida de Los Jardines 1', '37300', 40.89804, -5.20271, 'address', 'openstreetmap:way/158296971'),
  ('catalogo-castilla-y-leon:estaciones:way-31865049', 'Estación de Autobuses de Guijuelo – Calle Teso de la Feria', 'Autobús', '37156', 'Calle Teso de la Feria', '37770', 40.56043, -5.67025, 'address', 'openstreetmap:way/31865049'),
  ('catalogo-castilla-y-leon:estaciones:way-334454156', 'Estación de Autobuses de Alba de Tormes – Avenida Juan Pablo II', 'Autobús', '37008', 'Avenida Juan Pablo II 20', '37800', 40.82269, -5.51527, 'address', 'openstreetmap:way/334454156'),
  ('catalogo-castilla-y-leon:estaciones:way-339792387', 'Estación de autobuses de Salamanca – Avenida Filiberto Villalobos', 'Autobús', '37274', 'Avenida Filiberto Villalobos 71', '37007', 40.97, -5.67555, 'address', 'openstreetmap:way/339792387'),
  ('catalogo-castilla-y-leon:estaciones:way-418812600', 'Estación de autobuses de Ciudad Rodrigo – Calle Campo de Toledo', 'Autobús', '37107', 'Calle Campo de Toledo 18', '37500', 40.60114, -6.53195, 'address', 'openstreetmap:way/418812600'),
  ('catalogo-castilla-y-leon:estaciones:way-69961121', 'Estación de Autobuses de Vitigudino – Calle Portales de Santa Ana', 'Autobús', '37376', 'Calle Portales de Santa Ana 6', '37210', 41.00559, -6.43673, 'address', 'openstreetmap:way/69961121');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
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
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 21 THEN
    RAISE EXCEPTION 'Se esperaban 21 puntos de Estaciones en Salamanca, hay %', n;
  END IF;
END;
$$;

COMMIT;

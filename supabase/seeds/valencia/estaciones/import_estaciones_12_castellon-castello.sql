-- Carga de la categoría Estaciones de Castellón/Castelló (provincia 12), trozo de la carga de Andalucía.
-- Origen: estaciones-valencia.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 27 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-valencia:estaciones:node-1113085650', 'Estación de tren de Benicarló - Peníscola – Plaça de l''Estació', 'Tren', '12027', 'Plaça de l''Estació', NULL, 40.42767, 0.41516, 'address', 'openstreetmap:node/1113085650'),
  ('catalogo-valencia:estaciones:node-13894649638', 'Estación de tren de Castelló (Castelló de la Plana / Castellón de la Plana) – Carrer del Pintor Oliet', 'Tren', '12040', 'Carrer del Pintor Oliet 17', NULL, 39.98828, -0.05231, 'address', 'openstreetmap:node/13894649638'),
  ('catalogo-valencia:estaciones:node-1736213352', 'Estació d''Autobusos de la Vall d''Uixó – Avinguda de l''Agricultor', 'Autobús', '12126', 'Avinguda de l''Agricultor 26', '12600', 39.82147, -0.22917, 'address', 'openstreetmap:node/1736213352'),
  ('catalogo-valencia:estaciones:node-241896202', 'Estación de tren de Orpesa (Orpesa / Oropesa del Mar) – Plaça de l''Estació', 'Tren', '12085', 'Plaça de l''Estació', NULL, 40.09229, 0.14, 'address', 'openstreetmap:node/241896202'),
  ('catalogo-valencia:estaciones:node-246824210', 'Estación de tren de Borriana - Les Alqueries (Borriana / Burriana) – Plaça Estació del Nord', 'Tren', '12032', 'Plaça Estació del Nord', '12530', 39.8965, -0.10405, 'address', 'openstreetmap:node/246824210'),
  ('catalogo-valencia:estaciones:node-246824211', 'Estación de tren de Almassora – Carrer de l''Estació', 'Tren', '12009', 'Carrer de l''Estació', '12550', 39.95488, -0.07692, 'address', 'openstreetmap:node/246824211'),
  ('catalogo-valencia:estaciones:node-259183803', 'Estación de tren de Les Palmes (Castelló de la Plana / Castellón de la Plana) – Camí de Sant Francesc', 'Tren', '12040', 'Camí de Sant Francesc', NULL, 40.02337, -0.00161, 'address', 'openstreetmap:node/259183803'),
  ('catalogo-valencia:estaciones:node-358501945', 'Estación de tren de Barracas – Avenida Estación', 'Tren', '12020', 'Avenida Estación', NULL, 40.01156, -0.69642, 'address', 'openstreetmap:node/358501945'),
  ('catalogo-valencia:estaciones:node-4338272266', 'Estación de tren de Santa Magdalena de Pulpis', 'Tren', '12102', NULL, NULL, 40.35859, 0.29359, 'approximate', 'openstreetmap:node/4338272266'),
  ('catalogo-valencia:estaciones:node-503189462', 'Estación de tren de Segorbe - Arrabal – Calle Esperanza', 'Tren', '12104', 'Calle Esperanza', NULL, 39.85453, -0.49385, 'address', 'openstreetmap:node/503189462'),
  ('catalogo-valencia:estaciones:node-7221024117', 'Estación de tren de Alcalà de Xivert – Carrer de Carrascar', 'Tren', '12004', 'Carrer de Carrascar', NULL, 40.30465, 0.22868, 'address', 'openstreetmap:node/7221024117'),
  ('catalogo-valencia:estaciones:node-7221024125', 'Estación de tren de Vinaròs – Plaça de l''Estació', 'Tren', '12138', 'Plaça de l''Estació', NULL, 40.47175, 0.45545, 'address', 'openstreetmap:node/7221024125'),
  ('catalogo-valencia:estaciones:node-7221315774', 'Estación de tren de Almenara – Camí Vell d''Almenara', 'Tren', '12011', 'Camí Vell d''Almenara', NULL, 39.74867, -0.21822, 'address', 'openstreetmap:node/7221315774'),
  ('catalogo-valencia:estaciones:node-7221315775', 'Estación de tren de La Llosa – Plaça de les Escoles', 'Tren', '12074', 'Plaça de les Escoles', NULL, 39.76777, -0.20297, 'address', 'openstreetmap:node/7221315775'),
  ('catalogo-valencia:estaciones:node-7221315776', 'Estación de tren de Xilxes (Xilxes / Chilches) – Plaça de la Comunitat Valenciana', 'Tren', '12053', 'Plaça de la Comunitat Valenciana', NULL, 39.78278, -0.19031, 'address', 'openstreetmap:node/7221315776'),
  ('catalogo-valencia:estaciones:node-7221315777', 'Estación de tren de Nules - La Vilavella – Senda Olivereta', 'Tren', '12082', 'Senda Olivereta', NULL, 39.85297, -0.15224, 'address', 'openstreetmap:node/7221315777'),
  ('catalogo-valencia:estaciones:node-7221315778', 'Estación de tren de Vila-real – Carrer d''Ana Nebot López', 'Tren', '12135', 'Carrer d''Ana Nebot López', NULL, 39.93296, -0.09653, 'address', 'openstreetmap:node/7221315778'),
  ('catalogo-valencia:estaciones:node-8060137197', 'Estación de tren de Caudiel – Avenida de la Estación', 'Tren', '12043', 'Avenida de la Estación', NULL, 39.94728, -0.5722, 'address', 'openstreetmap:node/8060137197'),
  ('catalogo-valencia:estaciones:node-917059169', 'Estación de tren de Moncofa (Nules) – el Caminàs', 'Tren', '12082', 'el Caminàs', NULL, 39.82088, -0.16236, 'address', 'openstreetmap:node/917059169'),
  ('catalogo-valencia:estaciones:way-1230530875', 'Estación de tren de Torreblanca', 'Tren', '12117', NULL, NULL, 40.21219, 0.19901, 'address', 'openstreetmap:way/1230530875'),
  ('catalogo-valencia:estaciones:way-297133811', 'Estación de tren de Navajas – Calle de la Constitución', 'Tren', '12081', 'Calle de la Constitución', NULL, 39.8744, -0.50593, 'address', 'openstreetmap:way/297133811'),
  ('catalogo-valencia:estaciones:way-343218077', 'Estación de tren de Segorbe - Ciudad – Explanada de la Estación', 'Tren', '12104', 'Explanada de la Estación', NULL, 39.84706, -0.48235, 'address', 'openstreetmap:way/343218077'),
  ('catalogo-valencia:estaciones:way-561189401', 'Estació de Santa Madalena de Pulpis (Santa Magdalena de Pulpis)', 'Tren', '12102', NULL, NULL, 40.35848, 0.29372, 'approximate', 'openstreetmap:way/561189401'),
  ('catalogo-valencia:estaciones:way-658305797', 'Estación de tren de Jérica - Viver – Calle de Tres Eras', 'Tren', '12071', 'Calle de Tres Eras', NULL, 39.91496, -0.56939, 'address', 'openstreetmap:way/658305797'),
  ('catalogo-valencia:estaciones:way-658519992', 'Estación de Soneja – Calle de Sagunto', 'Tren', '12106', 'Calle de Sagunto', NULL, 39.81256, -0.43178, 'address', 'openstreetmap:way/658519992'),
  ('catalogo-valencia:estaciones:way-800511864', 'Estación de tren de Benicàssim (Benicàssim / Benicasim) – Avinguda de la Mediterrània', 'Tren', '12028', 'Avinguda de la Mediterrània', NULL, 40.05805, 0.05777, 'address', 'openstreetmap:way/800511864'),
  ('catalogo-valencia:estaciones:way-914476653', 'Estació d''autobusos de Vinaròs – Carrer del Vint-i-nou de Setembre', 'Autobús', '12138', 'Carrer del Vint-i-nou de Setembre', NULL, 40.4788, 0.47607, 'address', 'openstreetmap:way/914476653');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '12');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 12 con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '12'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 27 THEN
    RAISE EXCEPTION 'Se esperaban 27 puntos de Estaciones en Castellón/Castelló, hay %', n;
  END IF;
END;
$$;

COMMIT;

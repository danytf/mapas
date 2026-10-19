-- Altas puntuales en Granada a petición del titular (19/10/2026), para completar su lista de favoritos de trabajo.
-- Origen: OpenStreetMap (ODbL), fichero de Andalucía del 17/10/2026; direcciones aportadas por el titular donde OpenStreetMap no las trae.
-- 5 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial. Transaccional: si falta una categoría o un municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _alta (
  source_ref text, name text, categoria text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _alta VALUES
  ('catalogo-granada:peticion-titular:way-1094446065', 'Hospital Materno-Infantil (H.U. Virgen de las Nieves)', 'Hospital', '18087', 'Avenida de las Fuerzas Armadas 2', NULL, 37.18877, -3.61101, 'address', 'openstreetmap:way/1094446065'),
  ('catalogo-granada:peticion-titular:way-210585690', 'Consultas Externas Materno-Infantil (H.U. Virgen de las Nieves)', 'Hospital', '18087', 'Calle Doctor Azpitarte, s/n', '18012', 37.18925, -3.60906, 'address', 'openstreetmap:way/210585690'),
  ('catalogo-granada:peticion-titular:way-205384276', 'CS Las Gabias', 'Centro de salud', '18905', 'Plaza Montes Jovellar', NULL, 37.13380, -3.66713, 'address', 'openstreetmap:way/205384276'),
  ('catalogo-granada:peticion-titular:way-393376361', 'CS Padul', 'Centro de salud', '18150', 'Calle Real 28', NULL, 37.02530, -3.62838, 'approximate', 'openstreetmap:way/393376361'),
  ('catalogo-granada:peticion-titular:node-484320044', 'Lidl – Ctra. de Málaga, 53', 'Supermercado', '18087', 'Ctra. de Málaga, 53', '18015', 37.18870, -3.62107, 'address', 'openstreetmap:node/484320044');

DO $$
DECLARE faltan text;
BEGIN
  SELECT string_agg(DISTINCT a.categoria, ', ') INTO faltan FROM _alta a WHERE NOT EXISTS (SELECT 1 FROM public.categories c WHERE c.name = a.categoria);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan categorías: %', faltan;
  END IF;
  SELECT string_agg(DISTINCT a.muni_ine, ', ') INTO faltan FROM _alta a
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id WHERE m.official_code = a.muni_ine AND p.code = '18');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de Granada con estos códigos INE: %', faltan;
  END IF;
END;
$$;

INSERT INTO public.establishments (
  province_id, municipality_id, category_id,
  name, normalized_name, address, postal_code,
  latitude, longitude, location_precision, location_source,
  source_ref, status
)
SELECT m.province_id, m.id, c.id,
       a.name, lower(trim(a.name)), a.address, a.postal_code,
       a.latitude, a.longitude, a.location_precision, a.location_source,
       a.source_ref, 'active'
FROM _alta a
JOIN public.municipalities m ON m.official_code = a.muni_ine
JOIN public.categories c ON c.name = a.categoria
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _alta);
  IF n <> 5 THEN
    RAISE EXCEPTION 'Se esperaban 5 puntos, hay %', n;
  END IF;
END;
$$;

COMMIT;

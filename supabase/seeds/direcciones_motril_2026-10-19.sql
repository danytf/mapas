-- Direcciones de 3 puntos de Motril facilitadas por el titular el 19/10/2026 (solo cambia address).
-- Cada cambio solo se aplica si la dirección actual es la indicada; aborta sin cambios si no se actualizan exactamente 3 filas.

BEGIN;

CREATE TEMP TABLE _dir (id uuid, anterior text, address text) ON COMMIT DROP;
INSERT INTO _dir VALUES
  ('7942f502-4364-4ae5-b9d2-a2b671cab7ac', 'Calle Arrecife 9', 'C. Arrecife, 9'),
  ('711e58d2-510d-45f4-86ad-a266bcf9b55d', 'Calle Paseros 6', 'C. Paseros, 6'),
  ('a840c41b-bf7b-4c16-aa51-0fec1ad1cb7b', 'Carretera de Almería, N-340, km 12', 'Urbanización La Perla de Andalucía, Carretera de Almería');

DO $$
DECLARE n integer;
BEGIN
  UPDATE public.establishments e SET address = d.address
  FROM _dir d WHERE e.id = d.id AND e.address = d.anterior;
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 3 THEN RAISE EXCEPTION 'Se esperaban 3 direcciones actualizadas, hay %', n; END IF;
END;
$$;

COMMIT;

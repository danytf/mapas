-- Calles de grandes superficies (Andalucía) que OpenStreetMap no traía, tomadas de Nominatim inverso (vía más cercana, orientativa).
-- 12 puntos. Solo rellena la dirección si está vacía; no toca nada más. Se descartan autovías, autopistas, circunvalaciones, códigos de carretera y accesos.
-- Transaccional: si no se actualizan exactamente 12 filas, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _calles (source_ref text, address text) ON COMMIT DROP;

INSERT INTO _calles VALUES
  ('catalogo-andalucia:grandes-superficies:node-12478716001', 'Carretera del Mediterráneo'),
  ('catalogo-andalucia:grandes-superficies:node-12527079687', 'Calle Las Lanzas'),
  ('catalogo-andalucia:grandes-superficies:node-2574272149', 'Camino del Copo'),
  ('catalogo-andalucia:grandes-superficies:node-8151312695', 'Carretera de Bailén a Motril'),
  ('catalogo-andalucia:grandes-superficies:way-1352649533', 'Calle José Arrayás Mora'),
  ('catalogo-andalucia:grandes-superficies:way-143885440', 'Ronda de la Luz'),
  ('catalogo-andalucia:grandes-superficies:way-224738727', 'Calle Menta'),
  ('catalogo-andalucia:grandes-superficies:way-502660315', 'Calle Dorada'),
  ('catalogo-andalucia:grandes-superficies:way-502660316', 'Calle Dorada'),
  ('catalogo-andalucia:grandes-superficies:way-51368847', 'Avenida de Asia'),
  ('catalogo-andalucia:grandes-superficies:way-607957106', 'Calle Bailaora Ana Maria'),
  ('catalogo-andalucia:grandes-superficies:way-64868165', 'Avenida de la Fresa de Huelva');

DO $$
DECLARE n integer;
BEGIN
  UPDATE public.establishments e
  SET address = c.address
  FROM _calles c
  WHERE e.source_ref = c.source_ref AND coalesce(e.address, '') = '';
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 12 THEN
    RAISE EXCEPTION 'Se esperaban 12 calles actualizadas, hay %', n;
  END IF;
END;
$$;

COMMIT;

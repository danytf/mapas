-- Direcciones de grandes superficies (Andalucía) facilitadas por el titular el 19/10/2026 para los puntos que quedaban sin calle.
-- 14 puntos. Solo rellena la dirección si está vacía; no toca nada más. El código postal no va aquí (lo escribe un administrador desde la ficha).
-- Transaccional: si no se actualizan exactamente 14 filas, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _calles (source_ref text, address text) ON COMMIT DROP;

INSERT INTO _calles VALUES
  ('catalogo-andalucia:grandes-superficies:node-11302523083', 'C/ José Manuel Gómez Angulo, 58'),
  ('catalogo-andalucia:grandes-superficies:node-12853328983', 'Av. Manilva, 1'),
  ('catalogo-andalucia:grandes-superficies:node-1457162876', 'Parque Comercial ''Las Tiendas De'),
  ('catalogo-andalucia:grandes-superficies:node-2131539012', 'Carretera De Bailén A, Carr. Bailén-Motril, Km. 37, 500'),
  ('catalogo-andalucia:grandes-superficies:node-2645223332', 'Centro Comercial N4, Av. del Genil, s/n'),
  ('catalogo-andalucia:grandes-superficies:node-912049203', 'C. Poeta Muñoz San Román, s/n'),
  ('catalogo-andalucia:grandes-superficies:node-912084443', 'Cº de las Erillas, s/n'),
  ('catalogo-andalucia:grandes-superficies:way-1264584551', 'N-340, Km 106, 25'),
  ('catalogo-andalucia:grandes-superficies:way-1264590949', 'Ctra. Cádiz-Málaga, Km. 112, 9'),
  ('catalogo-andalucia:grandes-superficies:way-219492365', 'Ctra. Sevilla-Málaga, km 1'),
  ('catalogo-andalucia:grandes-superficies:way-261091899', 'Parque Comercial Viapark, Carr. de Cádiz, Salida 800'),
  ('catalogo-andalucia:grandes-superficies:way-322625755', 'C. Ojén'),
  ('catalogo-andalucia:grandes-superficies:way-669303734', 'Carr. Bailén-Motril, S/N'),
  ('catalogo-andalucia:grandes-superficies:way-91315402', 'Ctra. de Utrera, Km. 1');

DO $$
DECLARE n integer;
BEGIN
  UPDATE public.establishments e
  SET address = c.address
  FROM _calles c
  WHERE e.source_ref = c.source_ref AND coalesce(e.address, '') = '';
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 14 THEN
    RAISE EXCEPTION 'Se esperaban 14 direcciones actualizadas, hay %', n;
  END IF;
END;
$$;

COMMIT;

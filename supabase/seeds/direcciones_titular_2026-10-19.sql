-- Direcciones facilitadas por el titular el 19/10/2026: 8 puntos sin dirección (Correos y Estaciones) y 2 correcciones de grandes superficies.
-- Solo cambia address. Las 8 altas solo rellenan si está vacío; las 2 correcciones solo se aplican si la dirección actual es la indicada.
-- Transaccional: si no se actualizan exactamente 8 + 2 filas, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _vacias (source_ref text, address text) ON COMMIT DROP;
INSERT INTO _vacias VALUES
  ('catalogo-andalucia:estaciones:node-1014650979', 'Calle Francia, s/n (Polígono Industrial Trocadero)'),
  ('catalogo-andalucia:estaciones:node-1567648473', 'Carretera A-4, Salida 628'),
  ('catalogo-andalucia:estaciones:node-1738646773', 'Pl. de la Estación, s/n'),
  ('catalogo-andalucia:estaciones:node-191262271', 'Avenida Kansas City, s/n'),
  ('catalogo-andalucia:estaciones:way-122968564', 'C. Glorieta Derecha, 1'),
  ('catalogo-andalucia:postal_service:node-10574981647', 'Av. del Santísimo, S/N'),
  ('catalogo-andalucia:postal_service:node-7041192363', 'Av. de Palomares, 2'),
  ('catalogo-andalucia:postal_service:node-7883472734', 'Pl. José Bergamín, S/N');

CREATE TEMP TABLE _correcciones (source_ref text, anterior text, address text) ON COMMIT DROP;
INSERT INTO _correcciones VALUES
  ('catalogo-andalucia:grandes-superficies:node-1457162876', 'Parque Comercial ''Las Tiendas De', 'Parque Comercial ''Las Tiendas de Arcos'''),
  ('catalogo-andalucia:grandes-superficies:node-8975075236', 'Calle Calvario', 'Av. de Andalucía, 62');

DO $$
DECLARE n integer; m integer;
BEGIN
  UPDATE public.establishments e SET address = c.address
  FROM _vacias c WHERE e.source_ref = c.source_ref AND coalesce(e.address, '') = '';
  GET DIAGNOSTICS n = ROW_COUNT;
  IF n <> 8 THEN RAISE EXCEPTION 'Se esperaban 8 direcciones nuevas, hay %', n; END IF;
  UPDATE public.establishments e SET address = c.address
  FROM _correcciones c WHERE e.source_ref = c.source_ref AND e.address = c.anterior;
  GET DIAGNOSTICS m = ROW_COUNT;
  IF m <> 2 THEN RAISE EXCEPTION 'Se esperaban 2 correcciones, hay %', m; END IF;
END;
$$;

COMMIT;

"""Genera el SQL que rellena la calle de un lote ya cargado, a partir de validados.json y direcciones.json (completar_direcciones.py).
Uso: python generar_direcciones.py <validados.json> <direcciones.json> <categoria (code)> <salida.sql>
- Solo rellena campos que estan a NULL (COALESCE): no pisa direcciones ni codigos postales existentes ni ediciones hechas desde la app.
- Nominatim devuelve la via mas cercana, no una direccion postal: se descartan los nombres que no son una calle (carriles, accesos, salidas, rotondas, vias de servicio); 
- El codigo postal NO se actualiza: guard_sensitive_updates solo permite a un no administrador cambiar address y ubicacion, y no se elude. Se deja el que ya trae el punto.
- No cambia el nombre, las coordenadas ni la precision. Idempotente. Una transaccion; comprueba al final cuantas filas quedan sin direccion."""
import json
import re
import sys

validados, direcciones, cod, salida = sys.argv[1:5]
val = {r["osm"]: r for r in json.load(open(validados, encoding="utf-8"))}
dirs = json.load(open(direcciones, encoding="utf-8"))
NO_CALLE = re.compile(r"^(carril|veh[ií]culos|salida|acceso)\b|\bcarril (bici|taxi|de servicio)\b|rotonda|servicio", re.I)
descartadas = []
q = lambda v: "NULL" if not v else "'" + str(v).replace("'", "''") + "'"
filas = []
for osm, d in sorted(dirs.items()):
    r = val[osm]
    calle = None if r["calle"] else (d["calle"] or None)
    if calle and NO_CALLE.search(calle):
        descartadas.append((osm, calle))
        calle = None
    if calle:
        filas.append((r["source_ref"], calle))
vals = ",\n".join("  (%s, %s)" % (q(a), q(b)) for a, b in filas)
sql = f"""-- Completa la calle de la categoria {cod} (lote de Andalucia) con datos de Nominatim (inverso, OpenStreetMap, ODbL).
-- {len(filas)} filas con algun dato. Solo rellena address cuando es NULL; no cambia nombre, coordenadas, precision ni codigo postal. Idempotente.

BEGIN;

CREATE TEMP TABLE _dir (source_ref text, address text) ON COMMIT DROP;

INSERT INTO _dir VALUES
{vals};

UPDATE public.establishments e
SET address = d.address
FROM _dir d
WHERE e.source_ref = d.source_ref
  AND e.address IS NULL;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments WHERE source_ref IN (SELECT source_ref FROM _dir);
  IF n <> {len(filas)} THEN
    RAISE EXCEPTION 'Se esperaban {len(filas)} puntos, hay %', n;
  END IF;
END;
$$;

COMMIT;
"""
open(salida, "w", encoding="utf-8", newline="\n").write(sql)
for o, c in descartadas:
    print("calle descartada:", o, "|", c)
print(len(filas), "filas con calle")

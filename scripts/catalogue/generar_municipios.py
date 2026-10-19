"""Genera el SQL de carga de municipios oficiales (código INE) a partir de la salida de referencia.py.
Uso: python generar_municipios.py <ref.json> <provincias separadas por comas, p. ej. 04,11,14,18,21,23,29,41> <salida.sql>
- Inserta los municipios que faltan (por provincia y nombre normalizado) con su código INE.
- Si el municipio ya existe en la base sin código INE, se lo asigna; nunca cambia nombres ni borra nada.
- Transaccional e idempotente. El nombre normalizado usa la misma regla que el resto del catálogo (guiones, sin acentos)."""
import json
import re
import sys
import unicodedata


def slug(s):
    s = unicodedata.normalize("NFD", s)
    s = "".join(c for c in s if unicodedata.category(c) != "Mn")
    return re.sub(r"^-+|-+$", "", re.sub(r"[^a-z0-9]+", "-", s.lower()))


ref = json.load(open(sys.argv[1], encoding="utf-8"))
provs = sys.argv[2].split(",")
filas = []
for ine, m in sorted(ref["municipios"].items()):
    if m["provincia"] in provs:
        filas.append((m["provincia"], ine, m["name"], slug(m["name"])))
vistos = set()
for p, ine, name, nn in filas:
    if (p, nn) in vistos:
        raise SystemExit("Nombre normalizado repetido en la provincia %s: %s" % (p, nn))
    vistos.add((p, nn))
q = lambda v: "'" + v.replace("'", "''") + "'"
valores = ",\n".join("  (%s, %s, %s, %s)" % (q(p), q(ine), q(name), q(nn)) for p, ine, name, nn in filas)
sql = """-- Municipios oficiales (código INE) de las provincias %(provs)s. Origen: OpenStreetMap (áreas administrativas de nivel 8 con ine:municipio), ODbL.
-- Inserta los que faltan y asigna el código INE a los existentes que no lo tienen. No cambia nombres ni borra nada.
-- %(n)d municipios. Transaccional e idempotente.

BEGIN;

CREATE TEMP TABLE _municipios (prov text, ine text, name text, norm text) ON COMMIT DROP;
INSERT INTO _municipios VALUES
%(valores)s;

DO $$
DECLARE faltan text;
BEGIN
  SELECT string_agg(DISTINCT m.prov, ', ') INTO faltan FROM _municipios m
  WHERE NOT EXISTS (SELECT 1 FROM public.provinces p WHERE p.code = m.prov);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan provincias: %%', faltan;
  END IF;
END;
$$;

INSERT INTO public.municipalities (province_id, name, normalized_name, official_code)
SELECT p.id, m.name, m.norm, m.ine
FROM _municipios m JOIN public.provinces p ON p.code = m.prov
ON CONFLICT (province_id, normalized_name) DO UPDATE
  SET official_code = EXCLUDED.official_code
  WHERE public.municipalities.official_code IS NULL;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.municipalities mu
  JOIN _municipios m ON mu.official_code = m.ine;
  IF n < %(n)d THEN
    RAISE EXCEPTION 'Se esperaban al menos %(n)d municipios con código INE, hay %%', n;
  END IF;
END;
$$;

COMMIT;
""" % {"provs": ",".join(provs), "n": len(filas), "valores": valores}
open(sys.argv[3], "w", encoding="utf-8").write(sql)
por = {}
for p, *_ in filas:
    por[p] = por.get(p, 0) + 1
print("Filas:", len(filas), por)

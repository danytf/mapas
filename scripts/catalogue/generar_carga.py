"""Genera el fichero de origen (JSON) y el script SQL de carga de una categoría a partir de candidatos ya revisados.
Uso: python generar_carga.py <candidatos.json> --categoria "Tiendas" --codigo tiendas --prefijo catalogo-granada --subtipo Mascotas
       --provincia-ine 18 --provincia-nombre Granada --criterio "texto" --osm-base 2026-10-18T23:41:47Z
       --json-salida supabase/seeds/tiendas-granada.json --sql-salida supabase/seeds/import_tiendas_granada.sql
Cada candidato debe traer: osm, name, street, postcode, lat, lon, ine, municipio (salida de buscar.py y enriquecer.py).
- source_ref = <prefijo>:<codigo>:<nombre-municipio>:<municipio>:<calle>, único; location_source = openstreetmap:<tipo>/<id>.
- Carga transaccional e idempotente (ON CONFLICT DO NOTHING); aborta sin cambios si falta la provincia, la categoría o algún municipio."""
import argparse
import json
import re
import unicodedata


def slug(s):
    s = unicodedata.normalize("NFD", s)
    s = "".join(c for c in s if unicodedata.category(c) != "Mn")
    return re.sub(r"^-+|-+$", "", re.sub(r"[^a-z0-9]+", "-", s.lower()))


ap = argparse.ArgumentParser()
ap.add_argument("candidatos")
ap.add_argument("--categoria", required=True)
ap.add_argument("--codigo", required=True)
ap.add_argument("--prefijo", required=True)
ap.add_argument("--subtipo", default=None)
ap.add_argument("--provincia-ine", required=True)
ap.add_argument("--provincia-nombre", required=True)
ap.add_argument("--criterio", required=True)
ap.add_argument("--osm-base", required=True)
ap.add_argument("--fecha", default="2026-10-19")
ap.add_argument("--json-salida", required=True)
ap.add_argument("--sql-salida", required=True)
a = ap.parse_args()

cand = json.load(open(a.candidatos, encoding="utf-8"))
filas = []
for c in cand:
    calle = c["street"]
    name0 = c["name"] + " " + c["municipio"]
    filas.append({
        "source_ref": ":".join([a.prefijo, a.codigo, slug(name0), slug(c["municipio"]), slug(calle)]),
        "name": name0 + " – " + re.sub(r" \d+[a-z]?$", "", calle),
        "category": a.categoria, "subtype": a.subtipo, "municipality": c["municipio"], "municipality_ine": c["ine"],
        "address": calle, "postal_code": c["postcode"] or None, "latitude": round(c["lat"], 5), "longitude": round(c["lon"], 5),
        "location_precision": "address", "location_source": "openstreetmap:" + c["osm"], "province": a.provincia_nombre, "status": "active"})
refs = [f["source_ref"] for f in filas]
if len(set(refs)) != len(refs):
    raise SystemExit("source_ref duplicados")

json.dump({
    "format_version": 1, "source": "openstreetmap",
    "source_license": "ODbL 1.0 (c) OpenStreetMap contributors, https://www.openstreetmap.org/copyright",
    "queried_at": a.fecha, "osm_base_timestamp": a.osm_base, "selection_criteria": a.criterio,
    "province": a.provincia_nombre, "establishments": filas}, open(a.json_salida, "w", encoding="utf-8"), ensure_ascii=False, indent=2)
open(a.json_salida, "a", encoding="utf-8").write("\n")

q = lambda v: "NULL" if v is None else "'" + str(v).replace("'", "''") + "'"
vals = ",\n".join("  (" + ", ".join([q(f["source_ref"]), q(f["name"]), q(f["subtype"]), q(f["municipality_ine"]), q(f["address"]), q(f["postal_code"]),
                                    str(f["latitude"]), str(f["longitude"]), q(f["location_precision"]), q(f["location_source"])]) + ")" for f in filas)
n = len(filas)
sql = f"""-- Carga de la categoría {a.categoria} de {a.provincia_nombre}.
-- Origen: {a.json_salida.split('supabase/')[-1] if 'supabase/' in a.json_salida else a.json_salida} (OpenStreetMap, ODbL, consulta del {a.fecha}).
-- {n} filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la provincia, la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
{vals};

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.provinces WHERE code = '{a.provincia_ine}') THEN
    RAISE EXCEPTION 'Falta la provincia {a.provincia_ine}.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = '{a.codigo}' AND name = '{a.categoria}') THEN
    RAISE EXCEPTION 'Falta la categoría {a.categoria}.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m WHERE m.official_code = c.muni_ine);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id
JOIN public.categories cat ON cat.code = '{a.codigo}'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments WHERE source_ref LIKE '{a.prefijo}:{a.codigo}:%';
  IF n <> {n} THEN
    RAISE EXCEPTION 'Se esperaban {n} puntos de {a.categoria}, hay %', n;
  END IF;
END;
$$;

COMMIT;
"""
open(a.sql_salida, "w", encoding="utf-8").write(sql)
for f in filas:
    print(f["location_precision"], f["name"], "|", f["municipality"], "|", f["address"], "|", f["postal_code"], "|", f["location_source"])

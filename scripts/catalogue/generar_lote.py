"""Genera, a partir de validados.json (salida de validar.py), el JSON de origen y un script SQL por provincia (trozo) de una categoria.
Uso: python generar_lote.py <validados.json> <categoria.json> --osm-base <ISO> --dir-salida supabase/seeds/<categoria>-andalucia [--fecha AAAA-MM-DD]
- Un fichero SQL por provincia (codigo INE de 2 cifras), cada uno transaccional e idempotente (ON CONFLICT DO NOTHING).
- Aborta sin cambios si falta la categoria o algun municipio por codigo INE oficial. Comprueba el recuento del trozo al final.
- No crea provincias ni municipios (los datos de referencia son la fase N0). La provincia se toma del municipio."""
import argparse
import json
import os
from collections import defaultdict

PROV = {"01": "Araba/Álava", "02": "Albacete", "04": "Almería", "06": "Badajoz", "07": "Illes Balears", "08": "Barcelona", "10": "Cáceres", "11": "Cádiz", "13": "Ciudad Real", "14": "Córdoba", "16": "Cuenca", "17": "Girona", "18": "Granada", "19": "Guadalajara", "20": "Gipuzkoa", "21": "Huelva", "22": "Huesca", "23": "Jaén", "25": "Lleida", "26": "La Rioja", "28": "Madrid", "29": "Málaga", "30": "Murcia", "31": "Navarra", "33": "Asturias", "35": "Las Palmas", "38": "Santa Cruz de Tenerife", "39": "Cantabria", "41": "Sevilla", "43": "Tarragona", "44": "Teruel", "45": "Toledo", "48": "Bizkaia", "50": "Zaragoza", "51": "Ceuta", "52": "Melilla"}

ap = argparse.ArgumentParser()
ap.add_argument("validados")
ap.add_argument("categoria")
ap.add_argument("--osm-base", required=True)
ap.add_argument("--fecha", default="2026-10-19")
ap.add_argument("--dir-salida", required=True)
ap.add_argument("--sufijo", default="-andalucia", help="sufijo del fichero de origen, p. ej. -extremadura")
a = ap.parse_args()
SUFIJO = a.sufijo

defn = json.load(open(a.categoria, encoding="utf-8"))
filas = json.load(open(a.validados, encoding="utf-8"))
cod, cat = defn["codigo"], defn.get("categoria") or "(varias)"
os.makedirs(a.dir_salida, exist_ok=True)
def origen_ubicacion(f):
    # Coordenadas facilitadas por el titular (copiadas de Google Maps): el campo osm lleva ya el origen completo.
    return f["osm"] if f["osm"].startswith("manual_google_maps") else "openstreetmap:" + f["osm"]


q = lambda v: "NULL" if v in (None, "") else "'" + str(v).replace("'", "''") + "'"

por_prov = defaultdict(list)
for f in filas:
    por_prov[f["ine"][:2]].append(f)

json.dump({
    "format_version": 1, "source": "openstreetmap",
    "source_license": "ODbL 1.0 (c) OpenStreetMap contributors, https://www.openstreetmap.org/copyright",
    "queried_at": a.fecha, "osm_base_timestamp": a.osm_base, "selection_criteria": defn["criterio"],
    "province": "Andalucía",
    "establishments": [{
        "source_ref": f["source_ref"], "name": f["nombre"], "category": f.get("categoria") or cat, "subtype": f["subtipo"], "municipality": f["municipio"],
        "municipality_ine": f["ine"], "address": f["calle"] or None, "postal_code": f["cp"] or None, "latitude": round(f["lat"], 5), "longitude": round(f["lon"], 5),
        "location_precision": f["precision"], "location_source": origen_ubicacion(f), "province": PROV[f["ine"][:2]], "status": "active",
        **({"review_reason": f["revisar"]} if f["revisar"] else {})} for f in sorted(filas, key=lambda f: f["source_ref"])]},
    open(os.path.join(a.dir_salida, cod + SUFIJO + ".json"), "w", encoding="utf-8", newline="\n"), ensure_ascii=False, indent=1)
open(os.path.join(a.dir_salida, cod + SUFIJO + ".json"), "a", encoding="utf-8", newline="\n").write("\n")

for ine, grupo in sorted(por_prov.items()):
    nombre = PROV[ine]
    n = len(grupo)
    multi = not defn.get("categoria")  # definicion de varias categorias: cada fila lleva la suya
    vals = ",\n".join("  (" + ", ".join(([q(f["categoria"])] if multi else []) + [q(f["source_ref"]), q(f["nombre"]), q(f["subtipo"]), q(f["ine"]), q(f["calle"]), q(f["cp"]),
                                         str(round(f["lat"], 5)), str(round(f["lon"], 5)), q(f["precision"]), q(origen_ubicacion(f))]) + ")"
                      for f in sorted(grupo, key=lambda f: f["source_ref"]))
    sql = f"""-- Carga de la categoría {cat} de {nombre} (provincia {ine}), trozo de la carga de Andalucía.
-- Origen: {cod}{SUFIJO}.json (OpenStreetMap, ODbL, consulta del {a.fecha}, base {a.osm_base}).
-- {n} filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

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
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = '{cod}' AND name = '{cat}') THEN
    RAISE EXCEPTION 'Falta la categoría {cat}.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '{ine}');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia {ine} con estos códigos INE: %', faltan;
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
JOIN public.provinces p ON p.id = m.province_id AND p.code = '{ine}'
JOIN public.categories cat ON cat.code = '{cod}'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> {n} THEN
    RAISE EXCEPTION 'Se esperaban {n} puntos de {cat} en {nombre}, hay %', n;
  END IF;
END;
$$;

COMMIT;
"""
    if multi:
        sql = sql.replace("CREATE TEMP TABLE _carga (\n  source_ref text,", "CREATE TEMP TABLE _carga (\n  categoria text, source_ref text,")
        sql = sql.replace(f"""  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = '{cod}' AND name = '{cat}') THEN
    RAISE EXCEPTION 'Falta la categoría {cat}.';
  END IF;""", """  SELECT string_agg(DISTINCT c.categoria, ', ') INTO faltan FROM _carga c WHERE NOT EXISTS (SELECT 1 FROM public.categories k WHERE k.name = c.categoria);
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan categorías: %', faltan;
  END IF;""")
        sql = sql.replace(f"JOIN public.categories cat ON cat.code = '{cod}'", "JOIN public.categories cat ON cat.name = c.categoria")
        assert "cat.code" not in sql and "categoria text" in sql, "plantilla de varias categorias no aplicada"
    open(os.path.join(a.dir_salida, f"import_{cod}_{ine}_{nombre.lower().replace('í', 'i').replace('á', 'a').replace('é', 'e').replace('ó', 'o').replace('ú', 'u').replace(' ', '_').replace('/', '-')}.sql"), "w", encoding="utf-8", newline="\n").write(sql)
    print(ine, nombre, n)

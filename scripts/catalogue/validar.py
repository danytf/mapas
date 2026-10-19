"""Control de calidad de un lote extraido con extraer.py: decide que entra, que se descarta y que entra "por revisar", y genera el informe.
Uso: python validar.py <candidatos.json> <categoria.json> <existentes.json> <salida_dir> [--seed N] [--direcciones direcciones.json]
- existentes.json: puntos ya en la base de la misma categoria [{"s": location_source, "t": subtipo, "lat":.., "lon":.., "n": nombre}] (consulta de solo lectura).
- Reglas: provincia en excluir_provincias -> descarta (ya cubierta) salvo los ids de incluir_excepciones; sin nombre (si nombre_obligatorio) -> descarta; ya existe (mismo location_source, o mismo subtipo a menos de distancia_existente_m) -> descarta;
  duplicado en el lote (mismo subtipo y mismo nombre normalizado a menos de distancia_duplicado_m) -> se conserva uno (prefiere nodo, luego con calle);
  nombre dudoso (nombre_sospechoso_regex) -> entra por revisar; el municipio se anade al nombre si no aparece en el;
  mismo subtipo a menos de 150 m con otro nombre -> entra "por revisar" (approximate) como posible duplicado.
- Salida en <salida_dir>: validados.json (lo que se cargaria), excepciones.csv (todo lo descartado o por revisar, con motivo), informe.md."""
import csv
import json
import math
import os
import random
import re
import sys
import unicodedata
from collections import Counter, defaultdict


def norm(s):
    s = unicodedata.normalize("NFD", s)
    return re.sub(r"[^a-z0-9]+", "", "".join(c for c in s if unicodedata.category(c) != "Mn").lower())


def dist(a, b):
    p = math.pi / 180
    x = (b["lon"] - a["lon"]) * p * math.cos((a["lat"] + b["lat"]) / 2 * p)
    y = (b["lat"] - a["lat"]) * p
    return 6371000 * math.hypot(x, y)


cand_p, def_p, exi_p, out = sys.argv[1:5]
semilla = int(sys.argv[sys.argv.index("--seed") + 1]) if "--seed" in sys.argv else 1
dir_p = sys.argv[sys.argv.index("--direcciones") + 1] if "--direcciones" in sys.argv else None
defn = json.load(open(def_p, encoding="utf-8"))
cand = json.load(open(cand_p, encoding="utf-8"))["elementos"]
exi = json.load(open(exi_p, encoding="utf-8"))
d_dup, d_exi = defn["distancia_duplicado_m"], defn["distancia_existente_m"]
ya_nombre = re.compile(defn.get("nombre_ya_descriptivo", r"estaci[oó]n|apeadero|intercambiador|terminal|autob|\bbus\b"), re.I)
plantilla = defn.get("nombre", {})
d_rev = defn.get("distancia_revisar_m", 150)
nombre_obligatorio = defn.get("nombre_obligatorio", True)
no_calle = re.compile(defn["calle_no_valida_regex"], re.I) if defn.get("calle_no_valida_regex") else None
direcciones = json.load(open(dir_p, encoding="utf-8")) if dir_p else {}
sospechoso = re.compile(defn["nombre_sospechoso_regex"], re.I) if defn.get("nombre_sospechoso_regex") else None
os.makedirs(out, exist_ok=True)

for r in cand:
    t = r["tags"]
    r["nombre_osm"] = (t.get("name") or "").strip()
    r["calle"] = " ".join(x for x in (t.get("addr:street"), t.get("addr:housenumber")) if x)
    r["cp"] = t.get("addr:postcode", "")
    r["final"] = "incluir" if r["decision"] == "incluir" else "descartar"
    r["motivo_final"] = r["motivo"]
    r["revisar"] = None
    nom = direcciones.get(r["osm"])
    if nom and not r["calle"] and nom.get("calle") and not (no_calle and no_calle.search(nom["calle"])):
        r["calle"] = nom["calle"]
        r["calle_origen"] = "nominatim"
    if nom and not r["cp"] and nom.get("cp"):
        r["cp"] = nom["cp"]
        r["cp_origen"] = "nominatim"


def kr(x):
    # Para definiciones de varias categorias se compara por categoria; para el resto, por subtipo.
    return x.get("categoria") or x["subtipo"]


def ke(e):
    return e.get("c") or e["t"]


def descarta(r, motivo):
    r["final"], r["motivo_final"] = "descartar", motivo


for r in [r for r in cand if r["final"] == "incluir"]:
    if r["ine"] and r["ine"][:2] in defn.get("excluir_provincias", []) and r["osm"] not in defn.get("incluir_excepciones", []):
        descarta(r, "provincia ya cubierta por el catalogo revisado a mano (%s)" % r["ine"][:2])
    elif nombre_obligatorio and not r["nombre_osm"]:
        descarta(r, "sin nombre en OpenStreetMap")

for r in [r for r in cand if r["final"] == "incluir"]:
    for e in exi:
        if e["s"] == "openstreetmap:" + r["osm"]:
            descarta(r, "ya existe en la base (mismo identificador de OpenStreetMap)")
            break
        if ke(e) == kr(r) and dist(r, e) <= d_exi:
            descarta(r, "ya existe en la base a %d m: %s" % (dist(r, e), e["n"]))
            break

# duplicados dentro del lote: mejor primero (nodo antes que area, con calle antes que sin calle, id menor)
orden = sorted([r for r in cand if r["final"] == "incluir"], key=lambda r: (not r["osm"].startswith("node"), not r["calle"], r["osm"]))
guardados = []
for r in orden:
    for g in guardados:
        if kr(g) == kr(r) and (defn.get("duplicado_ignora_nombre") or norm(g["nombre_osm"]) == norm(r["nombre_osm"])) and dist(g, r) <= d_dup:
            descarta(r, "duplicado en el lote de %s (%d m)" % (g["osm"], dist(g, r)))
            break
    else:
        guardados.append(r)
guardados.sort(key=lambda r: r["osm"])

# posibles duplicados con otro nombre -> por revisar
for i, a in enumerate(guardados):
    for b in guardados[i + 1:]:
        if kr(a) == kr(b) and dist(a, b) <= d_rev:
            for x, y in ((a, b), (b, a)):
                x["revisar"] = (x["revisar"] + "; " if x["revisar"] else "") + "posible duplicado de %s (%s) a %d m" % (y["osm"], y["nombre_osm"], dist(a, b))

for r in guardados:
    n = r["nombre_osm"]
    if defn.get("nombre_por_categoria") and r.get("categoria") in defn["nombre_por_categoria"]:
        n = defn["nombre_por_categoria"][r["categoria"]].format(municipio=r["municipio"])
    elif defn.get("nombre_fijo"):
        n = defn["nombre_fijo"].format(municipio=r["municipio"])
    elif r["subtipo"] in plantilla and not ya_nombre.search(n):
        n = plantilla[r["subtipo"]].format(nombre=n)
    if not defn.get("nombre_fijo") and not defn.get("nombre_por_categoria") and norm(r["municipio"]) not in norm(n):
        n += " (" + r["municipio"] + ")"
    if sospechoso and r["nombre_osm"] and sospechoso.search(r["nombre_osm"]):
        r["revisar"] = (r["revisar"] + "; " if r["revisar"] else "") + "nombre dudoso en OpenStreetMap: " + r["nombre_osm"]
    r["nombre"] = n + (" – " + re.sub(r" \d+[a-z]?$", "", r["calle"]) if r["calle"] else "")
    r["precision"] = "approximate" if r["revisar"] else "address"
    r["source_ref"] = "catalogo-andalucia:%s:%s" % (defn["codigo"], r["osm"].replace("/", "-"))
refs = [r["source_ref"] for r in guardados]
assert len(set(refs)) == len(refs), "source_ref duplicados"

json.dump([{k: r.get(k) for k in ("source_ref", "nombre", "subtipo", "categoria", "ine", "municipio", "calle", "cp", "lat", "lon", "precision", "osm", "revisar")} for r in guardados],
          open(os.path.join(out, "validados.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
with open(os.path.join(out, "excepciones.csv"), "w", encoding="utf-8-sig", newline="") as f:
    w = csv.writer(f, delimiter=";")
    w.writerow(["tipo", "osm", "subtipo", "nombre", "municipio", "lat", "lon", "motivo"])
    for r in cand:
        if r["final"] == "descartar":
            w.writerow(["descartado", r["osm"], r["subtipo"], r["nombre_osm"], r["municipio"] or "", r["lat"], r["lon"], r["motivo_final"]])
        elif r["revisar"]:
            w.writerow(["por revisar", r["osm"], r["subtipo"], r["nombre"], r["municipio"], r["lat"], r["lon"], r["revisar"]])

prov = {"04": "Almería", "11": "Cádiz", "14": "Córdoba", "18": "Granada", "21": "Huelva", "23": "Jaén", "29": "Málaga", "41": "Sevilla"}
cnt = defaultdict(Counter)
for r in guardados:
    cnt[r["ine"][:2]][r["subtipo"] or r.get("categoria")] += 1
desc = Counter(re.sub(r"\d+ m|de (node|way|relation)/\d+|: .*", "", r["motivo_final"]).strip() for r in cand if r["final"] == "descartar")
rnd = random.Random(semilla)
muestra = rnd.sample(guardados, min(15, len(guardados)))
L = ["# Informe del lote: %s (Andalucía)" % (defn.get("categoria") or ", ".join(sorted({r["categoria"] for r in defn["reglas"]}))), "",
     "Origen: OpenStreetMap (ODbL 1.0, © colaboradores de OpenStreetMap). Criterio: " + defn["criterio"], "",
     "- Elementos extraídos: %d. Entran: %d (por revisar: %d). Descartados: %d." % (len(cand), len(guardados), sum(1 for r in guardados if r["revisar"]), len(cand) - len(guardados)), "",
     "## Entran por provincia", ""]
subs = sorted({(r["subtipo"] or r.get("categoria")) for r in guardados if (r["subtipo"] or r.get("categoria"))})
L += ["| Provincia | " + " | ".join(subs + ["Total"]) + " |", "|---|" + "---|" * (len(subs) + 1)]
for p in sorted(cnt):
    L.append("| %s | " % prov.get(p, p) + " | ".join([str(cnt[p][s]) for s in subs] + [str(sum(cnt[p].values()))]) + " |")
L += ["| **Total** | " + " | ".join([str(sum(c[s] for c in cnt.values())) for s in subs] + [str(len(guardados))]) + " |", "", "## Descartados por motivo", ""]
L += ["- %s: %d" % (k, v) for k, v in desc.most_common()]
L += ["", "## Datos que faltan en lo que entra", "",
      "- Sin calle (OpenStreetMap no la trae): %d de %d. El campo dirección queda vacío; no se inventa." % (sum(1 for r in guardados if not r["calle"]), len(guardados)),
      "- Sin código postal: %d de %d." % (sum(1 for r in guardados if not r["cp"]), len(guardados)),
      "- Calle completada con Nominatim (via mas cercana, orientativa): %d de %d." % (sum(1 for r in guardados if r.get("calle_origen")), len(guardados)),
      "- " + defn.get("nota_informe", "OpenStreetMap puede estar incompleto o desactualizado."), "",
      "## Muestra aleatoria (semilla %d)" % semilla, "", "| Nombre | Subtipo | Municipio | Coordenadas | Origen |", "|---|---|---|---|---|"]
for r in sorted(muestra, key=lambda r: r["nombre"]):
    L.append("| %s | %s | %s | %s, %s | %s |" % (r["nombre"], (r["subtipo"] or r.get("categoria") or "-"), r["municipio"], r["lat"], r["lon"], r["osm"]))
open(os.path.join(out, "informe.md"), "w", encoding="utf-8").write("\n".join(L) + "\n")
print("\n".join(L))

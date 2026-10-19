"""Extrae provincias y municipios (código INE, nombre y geometría) de un fichero .osm.pbf de OpenStreetMap.
Uso: python referencia.py <fichero.osm.pbf> <salida.json> [nombres_bd.txt]
- Municipio: área administrativa de nivel 8 con etiqueta ine:municipio (5 dígitos: 2 de provincia + 3 de municipio).
- Se deduplica por código INE (un municipio puede venir en varias áreas) conservando la unión de geometrías.
- Si se pasa nombres_bd.txt (un municipio por línea, de una provincia de la base), se comparan por nombre normalizado.
La salida contiene las geometrías en WKT; no se guarda en el repositorio (carpeta de trabajo)."""
import json
import re
import sys
import unicodedata
from collections import defaultdict

import osmium
import shapely.wkb as wkblib
from shapely.ops import unary_union

wkbfab = osmium.geom.WKBFactory()


def norm(s):
    s = unicodedata.normalize("NFD", s)
    s = "".join(c for c in s if unicodedata.category(c) != "Mn")
    return re.sub(r"[^a-z0-9]+", "", s.lower())


class Ref(osmium.SimpleHandler):
    def __init__(self):
        super().__init__()
        self.muni = defaultdict(lambda: {"names": set(), "geoms": [], "osm": set()})
        self.prov = {}
        self.sin_ine = 0

    def area(self, a):
        t = a.tags
        if t.get("boundary") != "administrative":
            return
        nivel = t.get("admin_level")
        try:
            geom = wkblib.loads(wkbfab.create_multipolygon(a), hex=True)
        except Exception:
            return
        if nivel == "8":
            ine = t.get("ine:municipio")
            if not ine:
                self.sin_ine += 1
                return
            m = self.muni[ine]
            m["names"].add(t.get("name", ""))
            m["geoms"].append(geom)
            m["osm"].add(("relation" if not a.from_way() else "way") + "/" + str(a.orig_id()))
        elif nivel == "6" and t.get("ine:provincia"):
            self.prov[t["ine:provincia"]] = {"name": t.get("name", ""), "geom": geom.wkt}


h = Ref()
h.apply_file(sys.argv[1], locations=True)
munis = {}
for ine, m in h.muni.items():
    g = unary_union(m["geoms"])
    munis[ine] = {"ine": ine, "provincia": ine[:2], "name": sorted(m["names"])[0], "osm": sorted(m["osm"]), "wkt": g.wkt}
por_prov = defaultdict(int)
for ine in munis:
    por_prov[ine[:2]] += 1
print("Provincias con INE en el fichero:", {k: v["name"] for k, v in sorted(h.prov.items())})
print("Municipios (códigos INE distintos):", len(munis), "| por provincia:", dict(sorted(por_prov.items())))
print("Áreas de nivel 8 sin ine:municipio (ignoradas):", h.sin_ine)
print("Áreas duplicadas por código INE:", sum(1 for m in h.muni.values() if len(m["geoms"]) > 1))
if len(sys.argv) > 3:
    bd = [l.strip() for l in open(sys.argv[3], encoding="utf-8") if l.strip()]
    prov = sys.argv[3] and None
    nb = {norm(x): x for x in bd}
    prov_cod = sorted({v["provincia"] for v in munis.values()})
    objetivo = [p for p in prov_cod if p == "18"] or prov_cod
    nos = {norm(v["name"]): v for v in munis.values() if v["provincia"] in objetivo}
    print("Comparación con la base (provincia 18):")
    print("  OSM:", len(nos), "| BD:", len(nb), "| coinciden por nombre:", len(set(nos) & set(nb)))
    print("  Solo en OSM:", sorted(nos[k]["name"] + " [" + nos[k]["ine"] + "]" for k in set(nos) - set(nb)))
    print("  Solo en BD:", sorted(nb[k] for k in set(nb) - set(nos)))
json.dump({"provincias": h.prov, "municipios": munis}, open(sys.argv[2], "w", encoding="utf-8"), ensure_ascii=False)
print("Escrito", sys.argv[2])

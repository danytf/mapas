"""Extrae de un fichero .osm.pbf los candidatos de una categoria (definicion JSON) y les asigna municipio y provincia oficiales (INE) por geometria.
Uso: python extraer.py <fichero.osm.pbf> <ref.json> <categoria.json> <candidatos.json>
- Aplica las reglas de la definicion (etiquetas que entran, exclusiones) sobre nodos y areas; para las areas usa un punto representativo.
- No decide duplicados ni calidad (eso es validar.py): guarda cada elemento con su decision de extraccion ('incluir' o 'descartar' con motivo).
- Solo lectura. No escribe en la base."""
import json
import re
import sys

import osmium
import shapely.wkb as wkblib
import shapely.wkt as wktlib
from shapely.prepared import prep
from shapely.strtree import STRtree

pbf, refpath, defpath, salida = sys.argv[1:5]
defn = json.load(open(defpath, encoding="utf-8"))
ref = json.load(open(refpath, encoding="utf-8"))
munis = [(ine, m["name"], wktlib.loads(m["wkt"])) for ine, m in sorted(ref["municipios"].items())]
arbol = STRtree([g for _, _, g in munis])
preps = [prep(g) for _, _, g in munis]
wkbfab = osmium.geom.WKBFactory()
ETIQ = ["name", "brand", "operator", "network", "official_name", "addr:street", "addr:housenumber", "addr:city", "addr:postcode",
        "usage", "railway:traffic_mode", "service", "opening_hours", "website", "wikidata", "ref", "disused", "abandoned", "public_transport", "station",
        "subway", "light_rail", "tram", "train", "bus"]


def municipio(pt):
    for i in arbol.query(pt):
        if preps[i].contains(pt):
            return munis[i][0], munis[i][1]
    return None, None


def regla(tags):
    for r in defn["reglas"]:
        if all(tags.get(k) in v for k, v in r["etiquetas"].items()):
            return r
    return None


class Extraer(osmium.SimpleHandler):
    def __init__(self):
        super().__init__()
        self.res = []

    def _anota(self, tipo, oid, tags, pt):
        r = regla(tags)
        if not r:
            return
        motivo = None
        for k, v in r.get("excluir_si", {}).items():
            if tags.get(k) in v:
                motivo = motivo or "etiqueta %s=%s" % (k, tags.get(k))
        for k in defn.get("excluir_claves", []):
            if k in tags:
                motivo = motivo or "etiqueta %s" % k
        fl = defn.get("excluir_flags")
        if fl and r["subtipo"] in fl.get("subtipos", []):
            for k in fl["cualquiera"]:
                if tags.get(k) == "yes" and tags.get(fl["salvo"]) != "yes":
                    motivo = motivo or "etiqueta %s=yes sin %s=yes" % (k, fl["salvo"])
            rx = fl.get("operador_regex")
            if rx and re.search(rx, tags.get("operator", "") + " " + tags.get("network", ""), re.I) and tags.get(fl["salvo"]) != "yes":
                motivo = motivo or "operador o red de metro/tranvia"
        ine, mname = municipio(pt)
        if not ine and not motivo:
            motivo = "fuera de los municipios oficiales cargados"
        self.res.append({
            "osm": tipo + "/" + str(oid), "subtipo": r["subtipo"], "ine": ine, "municipio": mname,
            "lat": round(pt.y, 6), "lon": round(pt.x, 6),
            "tags": {k: tags[k] for k in ETIQ if k in tags},
            "decision": "descartar" if motivo else "incluir", "motivo": motivo})

    def node(self, n):
        if regla(n.tags):
            self._anota("node", n.id, n.tags, wkblib.loads(wkbfab.create_point(n), hex=True))

    def area(self, a):
        if not regla(a.tags):
            return
        try:
            c = wkblib.loads(wkbfab.create_multipolygon(a), hex=True).representative_point()
        except Exception:
            return
        self._anota("way" if a.from_way() else "relation", a.orig_id(), a.tags, c)


h = Extraer()
h.apply_file(pbf, locations=True)
# Un way cerrado aparece como way (area) y tambien como nodo/way sin area: se deduplica por id de OSM
vistos, res = set(), []
for r in sorted(h.res, key=lambda r: r["osm"]):
    if r["osm"] not in vistos:
        vistos.add(r["osm"])
        res.append(r)
json.dump({"categoria": defn["codigo"], "elementos": res}, open(salida, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print(len(res), "elementos;", sum(r["decision"] == "incluir" for r in res), "incluidos;", sum(r["decision"] == "descartar" for r in res), "descartados")

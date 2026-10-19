"""Busca puntos en un fichero .osm.pbf dentro de una provincia y asigna el municipio oficial (INE) por geometría.
Uso: python buscar.py <fichero.osm.pbf> <ref.json> <código provincia INE> <etiqueta=valor[,valor...]> [regex_nombre] [salida.json]
Ejemplo: python buscar.py andalucia.osm.pbf ref-andalucia.json 18 shop=pet "tiendanimal|kiwoko" out.json
- Mira nodos y áreas (edificios); para las áreas usa el centroide.
- Solo cuenta lo que cae dentro del polígono de la provincia y dentro de un municipio oficial.
- Imprime los candidatos con su origen (tipo/id de OpenStreetMap), etiquetas útiles y municipio. No escribe en la base."""
import json
import re
import sys

import osmium
import shapely.wkb as wkblib
import shapely.wkt as wktlib
from shapely.prepared import prep
from shapely.strtree import STRtree

pbf, refpath, prov, filtro = sys.argv[1:5]
rx = re.compile(sys.argv[5], re.I) if len(sys.argv) > 5 and sys.argv[5] else None
salida = sys.argv[6] if len(sys.argv) > 6 else None
clave, _, valores = filtro.partition("=")
valores = set(valores.split(",")) if valores else None

ref = json.load(open(refpath, encoding="utf-8"))
polis = [(ine, wktlib.loads(m["wkt"]), m["name"]) for ine, m in ref["municipios"].items() if m["provincia"] == prov]
geoms = [g for _, g, _ in polis]
arbol = STRtree(geoms)
preps = [prep(g) for g in geoms]
wkbfab = osmium.geom.WKBFactory()


def municipio(pt):
    for i in arbol.query(pt):
        if preps[i].contains(pt):
            return polis[i][0], polis[i][2]
    return None, None


class Buscar(osmium.SimpleHandler):
    def __init__(self):
        super().__init__()
        self.res = []

    def _anota(self, tipo, oid, tags, pt):
        if tags.get(clave) is None or (valores and tags.get(clave) not in valores):
            return
        nombre = tags.get("name", "")
        marca = tags.get("brand", "")
        if rx and not (rx.search(nombre) or rx.search(marca) or rx.search(tags.get("operator", ""))):
            return
        ine, mname = municipio(pt)
        if not ine:
            return
        self.res.append({
            "osm": tipo + "/" + str(oid), "name": nombre, "brand": marca, "tipo": tags.get(clave),
            "street": " ".join(x for x in (tags.get("addr:street"), tags.get("addr:housenumber")) if x),
            "city": tags.get("addr:city", ""), "postcode": tags.get("addr:postcode", ""),
            "lat": round(pt.y, 6), "lon": round(pt.x, 6), "ine": ine, "municipio": mname,
            "website": tags.get("website", ""), "opening_hours": tags.get("opening_hours", "")})

    def node(self, n):
        if clave in n.tags:
            self._anota("node", n.id, n.tags, wkblib.loads(wkbfab.create_point(n), hex=True))

    def area(self, a):
        if clave in a.tags:
            try:
                c = wkblib.loads(wkbfab.create_multipolygon(a), hex=True).representative_point()
            except Exception:
                return
            self._anota("way" if a.from_way() else "relation", a.orig_id(), a.tags, c)


h = Buscar()
h.apply_file(pbf, locations=True)
res = sorted(h.res, key=lambda r: (r["municipio"], r["name"]))
print(len(res), "candidatos en la provincia", prov)
for r in res:
    print(" | ".join([r["osm"], r["name"] or "(sin nombre)", r["brand"], r["tipo"], r["street"] or "-", r["municipio"], str(r["lat"]) + "," + str(r["lon"])]))
if salida:
    json.dump(res, open(salida, "w", encoding="utf-8"), ensure_ascii=False, indent=1)

"""Completa la calle de un lote validado (validados.json) con la via con nombre mas cercana del propio fichero .osm.pbf, sin servicios externos.
Uso: python completar_direcciones_local.py <fichero.osm.pbf> <validados.json> <direcciones.json> [--max-m 120]
- Solo considera calles con nombre (highway = primary, secondary, tertiary, unclassified, residential, living_street, pedestrian); no pistas ni vias de servicio.
- Solo rellena los puntos sin calle y solo si la via esta a menos de --max-m metros. Es la via mas cercana, no una direccion postal verificada.
- Salida compatible con validar.py --direcciones: {osm: {"calle": ..., "cp": "", "origen": "osm-local", "metros": ...}}. Codigo postal no se completa."""
import json
import math
import sys

import osmium
import shapely.wkb as wkblib
from shapely.geometry import Point
from shapely.ops import nearest_points
from shapely.strtree import STRtree


def metros(lat1, lon1, lat2, lon2):
    p = math.pi / 180
    x = (lon2 - lon1) * p * math.cos((lat1 + lat2) / 2 * p)
    y = (lat2 - lat1) * p
    return 6371000 * math.hypot(x, y)


pbf, val_p, out_p = sys.argv[1:4]
max_m = float(sys.argv[sys.argv.index("--max-m") + 1]) if "--max-m" in sys.argv else 120.0
filas = json.load(open(val_p, encoding="utf-8"))
pend = [r for r in filas if not r["calle"]]
print(len(pend), "puntos sin calle", flush=True)
CLASES = {"primary", "secondary", "tertiary", "unclassified", "residential", "living_street", "pedestrian"}
# Cajas alrededor de los puntos para quedarse solo con las vias cercanas (ahorra memoria).
grado = max_m / 111000.0 * 1.6
cajas = [(r["lat"] - grado, r["lat"] + grado, r["lon"] - grado * 1.3, r["lon"] + grado * 1.3) for r in pend]
wkbfab = osmium.geom.WKBFactory()


class H(osmium.SimpleHandler):
    def __init__(self):
        super().__init__()
        self.geoms, self.nombres = [], []

    def way(self, w):
        t = w.tags
        if t.get("highway") not in CLASES or "name" not in t:
            return
        try:
            n0 = w.nodes[0].location
            if not n0.valid():
                return
        except Exception:
            return
        lat, lon = n0.lat, n0.lon
        if not any(c[0] <= lat <= c[1] and c[2] <= lon <= c[3] for c in cajas):
            return
        try:
            g = wkblib.loads(wkbfab.create_linestring(w), hex=True)
        except Exception:
            return
        self.geoms.append(g)
        self.nombres.append(t["name"])


h = H()
h.apply_file(pbf, locations=True)
print(len(h.geoms), "vias cercanas a algun punto", flush=True)
arbol = STRtree(h.geoms)
res = {}
for r in pend:
    p = Point(r["lon"], r["lat"])
    cerca = arbol.query(p.buffer(grado))
    mejor, md = None, None
    for i in cerca:
        q = nearest_points(h.geoms[i], p)[0]
        d = metros(r["lat"], r["lon"], q.y, q.x)
        if md is None or d < md:
            mejor, md = i, d
    if mejor is not None and md <= max_m:
        res[r["osm"]] = {"calle": h.nombres[mejor], "cp": "", "origen": "osm-local", "metros": round(md)}
json.dump(res, open(out_p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print(len(res), "calles asignadas de", len(pend))

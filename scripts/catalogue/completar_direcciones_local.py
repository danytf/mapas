"""Completa calle y codigo postal de un lote validado (validados.json) con datos del propio fichero .osm.pbf, sin servicios externos.
Uso: python completar_direcciones_local.py <fichero.osm.pbf> <validados.json> <direcciones.json> [--max-m 120] [--max-cp-m 150] [--max-dir-m 60]
- Calle: primero la del punto con direccion (addr:street) mas cercano a menos de --max-dir-m (suele ser el mismo edificio); si no, la via con nombre
  mas cercana a menos de --max-m (highway = primary, secondary, tertiary, unclassified, residential, living_street, pedestrian; no pistas ni vias de servicio).
- Codigo postal: el addr:postcode del punto o edificio con direccion mas cercano a menos de --max-cp-m. Solo se acepta si tiene 5 cifras y empieza por el
  codigo de la provincia del punto. No se inventa: si no hay, queda vacio y se anota.
- Solo rellena los puntos que no tienen calle o no tienen codigo postal. Es lo mas cercano, no una direccion postal verificada.
- Salida compatible con validar.py --direcciones: {osm: {"calle", "cp", "origen": "osm-local", "metros_calle", "metros_cp"}}."""
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


def opcion(nombre, defecto):
    return float(sys.argv[sys.argv.index(nombre) + 1]) if nombre in sys.argv else defecto


pbf, val_p, out_p = sys.argv[1:4]
max_m, max_cp, max_dir = opcion("--max-m", 120.0), opcion("--max-cp-m", 150.0), opcion("--max-dir-m", 60.0)
filas = json.load(open(val_p, encoding="utf-8"))
pend = [r for r in filas if not r["calle"] or not r["cp"]]
print(len(pend), "puntos sin calle o sin codigo postal", flush=True)
CLASES = {"primary", "secondary", "tertiary", "unclassified", "residential", "living_street", "pedestrian"}
# Cajas alrededor de los puntos para quedarse solo con lo cercano (ahorra memoria).
radio = max(max_m, max_cp, max_dir)
grado = radio / 111000.0 * 1.6
cajas = [(r["lat"] - grado, r["lat"] + grado, r["lon"] - grado * 1.3, r["lon"] + grado * 1.3) for r in pend]
cajas.sort()
wkbfab = osmium.geom.WKBFactory()


def cerca(lat, lon):
    return any(c[0] <= lat <= c[1] and c[2] <= lon <= c[3] for c in cajas)


class H(osmium.SimpleHandler):
    def __init__(self):
        super().__init__()
        self.vias, self.vnombres = [], []
        self.dirs = []  # (lat, lon, calle, cp)

    def _dir(self, lat, lon, t):
        cp, calle = t.get("addr:postcode", ""), t.get("addr:street", "")
        if (cp or calle) and cerca(lat, lon):
            num = t.get("addr:housenumber", "")
            self.dirs.append((lat, lon, (calle + (" " + num if num else "")).strip(), cp))

    def node(self, n):
        t = n.tags
        if "addr:postcode" in t or "addr:street" in t:
            try:
                if n.location.valid():
                    self._dir(n.location.lat, n.location.lon, t)
            except Exception:
                pass

    def way(self, w):
        t = w.tags
        try:
            n0 = w.nodes[0].location
            if not n0.valid():
                return
        except Exception:
            return
        lat, lon = n0.lat, n0.lon
        if "addr:postcode" in t or "addr:street" in t:
            self._dir(lat, lon, t)
        if t.get("highway") in CLASES and "name" in t and cerca(lat, lon):
            try:
                g = wkblib.loads(wkbfab.create_linestring(w), hex=True)
            except Exception:
                return
            self.vias.append(g)
            self.vnombres.append(t["name"])


h = H()
h.apply_file(pbf, locations=True)
print(len(h.dirs), "puntos con direccion y", len(h.vias), "vias cercanas", flush=True)
arbol_v = STRtree(h.vias) if h.vias else None
arbol_d = STRtree([Point(d[1], d[0]) for d in h.dirs]) if h.dirs else None
g_cp = radio / 111000.0
res = {}
n_calle = n_cp = 0
for r in pend:
    p = Point(r["lon"], r["lat"])
    sal = {"calle": "", "cp": "", "origen": "osm-local"}
    if arbol_d is not None:
        cand = []
        for i in arbol_d.query(p.buffer(g_cp * 1.5)):
            d = h.dirs[i]
            cand.append((metros(r["lat"], r["lon"], d[0], d[1]), d))
        cand.sort(key=lambda x: x[0])
        if not r["calle"]:
            for m, d in cand:
                if m <= max_dir and d[2] and d[2].split(" ")[0]:
                    sal["calle"], sal["metros_calle"] = d[2], round(m)
                    break
        if not r["cp"]:
            for m, d in cand:
                if m <= max_cp and len(d[3]) == 5 and d[3].isdigit() and d[3][:2] == r["ine"][:2]:
                    sal["cp"], sal["metros_cp"] = d[3], round(m)
                    break
    if not r["calle"] and not sal["calle"] and arbol_v is not None:
        mejor, md = None, None
        for i in arbol_v.query(p.buffer(g_cp)):
            q = nearest_points(h.vias[i], p)[0]
            dd = metros(r["lat"], r["lon"], q.y, q.x)
            if md is None or dd < md:
                mejor, md = i, dd
        if mejor is not None and md <= max_m:
            sal["calle"], sal["metros_calle"] = h.vnombres[mejor], round(md)
    if sal["calle"]:
        n_calle += 1
    if sal["cp"]:
        n_cp += 1
    if sal["calle"] or sal["cp"]:
        res[r["osm"]] = sal
json.dump(res, open(out_p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print(n_calle, "calles y", n_cp, "codigos postales asignados de", len(pend))

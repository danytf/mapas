"""Completa el codigo postal de los puntos sin el de un municipio de codigo unico, a partir de lo observado en el propio lote.
Uso: python inferir_cp_municipio.py <validados.json> <direcciones.json> [--min-puntos 3]
- Para cada municipio cuenta los codigos postales de los puntos que ya lo tienen (de OpenStreetMap o de la direccion mas cercana). Si hay al menos
  --min-puntos observaciones y todas coinciden, ese es el codigo del municipio y se asigna a los puntos que no lo tienen (origen «municipio-unico»).
- Si el municipio tiene varios codigos o pocas observaciones, no se asigna nada: va a la lista de excepciones. No se inventa.
- Anade o actualiza entradas de <direcciones.json> (se conserva la calle ya calculada)."""
import collections
import json
import sys

val_p, dir_p = sys.argv[1:3]
minimo = int(sys.argv[sys.argv.index("--min-puntos") + 1]) if "--min-puntos" in sys.argv else 3
filas = json.load(open(val_p, encoding="utf-8"))
dirs = json.load(open(dir_p, encoding="utf-8"))
obs = collections.defaultdict(collections.Counter)
for r in filas:
    cp = r["cp"] or dirs.get(r["osm"], {}).get("cp", "")
    if cp:
        obs[r["ine"]][cp] += 1
unico = {ine: next(iter(c)) for ine, c in obs.items() if len(c) == 1 and sum(c.values()) >= minimo}
n = 0
for r in filas:
    if r["cp"] or dirs.get(r["osm"], {}).get("cp"):
        continue
    cp = unico.get(r["ine"])
    if cp and cp[:2] == r["ine"][:2]:
        d = dirs.setdefault(r["osm"], {"calle": "", "cp": "", "origen": "osm-local"})
        d["cp"], d["origen_cp"] = cp, "municipio-unico"
        n += 1
json.dump(dirs, open(dir_p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print(len(unico), "municipios de codigo unico;", n, "codigos postales asignados")

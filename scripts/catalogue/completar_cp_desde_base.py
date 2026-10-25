"""Sugiere el codigo postal de los puntos activos que no lo tienen, con Nominatim inverso.
Uso: python completar_cp_desde_base.py <salida.json> [--prov 39] [--con-calle]
- --prov limita a una provincia (codigo de 2 cifras). --con-calle incluye tambien los puntos sin direccion, aunque tengan codigo postal.
- Pide la cadena de conexion sin eco (no se guarda) y lee con psql, en solo lectura, id, nombre, provincia, municipio y coordenadas de los puntos activos sin codigo postal.
- 1 peticion cada 1,2 s con User-Agent identificado (politica de uso de Nominatim). Reanudable: guarda cada respuesta en <salida.json> y no repite las ya hechas.
- Solo sugiere codigos de 5 cifras cuyas dos primeras cifras coinciden con la provincia del punto. No escribe nada en la base.
- Salida: {id: {"nombre", "provincia", "municipio", "cp", "calle"}} (cp vacio si Nominatim no devuelve uno valido)."""
import getpass
import json
import os
import subprocess
import sys
import time
import urllib.request

UA = "mapas-wesser-carga/1.0 (danytf@gmail.com)"
salida = sys.argv[1]
prov_f = sys.argv[sys.argv.index("--prov") + 1] if "--prov" in sys.argv else None
con_calle = "--con-calle" in sys.argv
conn = getpass.getpass("Cadena de conexion de Supabase (no se muestra ni se guarda): ")
sql = ("select coalesce(json_agg(json_build_object('id', e.id, 'nombre', e.name, 'prov', p.code, 'municipio', m.name, 'lat', e.latitude, 'lon', e.longitude) order by p.code, m.name, e.name), '[]') "
       "from establishments e join provinces p on p.id = e.province_id join municipalities m on m.id = e.municipality_id "
       "where e.status = 'active' and (coalesce(e.postal_code, '') = ''" + (" or coalesce(e.address, '') = ''" if con_calle else "") + ")"
       + ((" and p.code = '%s'" % prov_f) if prov_f and prov_f.isdigit() else ""))
r = subprocess.run(["psql", conn, "-Atq", "-c", sql], capture_output=True, text=True, encoding="utf-8")
del conn
if r.returncode != 0:
    sys.exit("psql fallo: " + r.stderr.strip()[:300])
filas = json.loads(r.stdout)
hecho = json.load(open(salida, encoding="utf-8")) if os.path.exists(salida) else {}
pend = [f for f in filas if f["id"] not in hecho]
print(len(filas), "puntos sin codigo postal;", len(pend), "por consultar", flush=True)
for i, f in enumerate(pend, 1):
    url = "https://nominatim.openstreetmap.org/reverse?format=jsonv2&addressdetails=1&zoom=18&lat=%s&lon=%s" % (f["lat"], f["lon"])
    try:
        d = json.load(urllib.request.urlopen(urllib.request.Request(url, headers={"User-Agent": UA}), timeout=30))
        a = d.get("address", {})
        cp = a.get("postcode", "")
        if not (len(cp) == 5 and cp.isdigit() and cp[:2] == f["prov"]):
            cp = ""
        hecho[f["id"]] = {"nombre": f["nombre"], "provincia": f["prov"], "municipio": f["municipio"], "cp": cp, "calle": a.get("road", "")}
    except Exception as e:
        print("Error en", f["id"], e, flush=True)
        time.sleep(5)
        continue
    json.dump(hecho, open(salida, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    if i % 50 == 0:
        print(i, "/", len(pend), flush=True)
    time.sleep(1.2)
print("Hecho:", sum(1 for v in hecho.values() if v["cp"]), "con codigo postal sugerido de", len(hecho))

"""Completa calle y codigo postal de un lote validado (validados.json) con Nominatim inverso, sin pisar lo que ya trae OpenStreetMap.
Uso: python completar_direcciones.py <validados.json> <direcciones.json>
- Solo consulta los puntos sin calle o sin codigo postal; 1 peticion cada 1,2 s con User-Agent identificado (politica de uso de Nominatim).
- Reanudable: guarda cada respuesta en <direcciones.json> (clave = id de OpenStreetMap) y no repite las ya hechas.
- Salida: {osm: {"calle": ..., "cp": ..., "origen": "nominatim"}} solo con lo que Nominatim devuelve. Calle = campo `road`; nunca se inventa."""
import json
import os
import sys
import time
import urllib.request

UA = "mapas-wesser-carga/1.0 (danytf@gmail.com)"
filas = json.load(open(sys.argv[1], encoding="utf-8"))
salida = sys.argv[2]
hecho = json.load(open(salida, encoding="utf-8")) if os.path.exists(salida) else {}
pend = [r for r in filas if (not r["calle"] or not r["cp"]) and r["osm"] not in hecho]
print(len(pend), "por consultar;", len(hecho), "ya hechos", flush=True)
for i, r in enumerate(pend, 1):
    url = "https://nominatim.openstreetmap.org/reverse?format=jsonv2&addressdetails=1&zoom=18&lat=%s&lon=%s" % (r["lat"], r["lon"])
    try:
        d = json.load(urllib.request.urlopen(urllib.request.Request(url, headers={"User-Agent": UA}), timeout=30))
        a = d.get("address", {})
        hecho[r["osm"]] = {"calle": a.get("road", ""), "cp": a.get("postcode", ""), "origen": "nominatim"}
    except Exception as e:
        print("Error en", r["osm"], e, flush=True)
        time.sleep(5)
        continue
    json.dump(hecho, open(salida, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    if i % 25 == 0:
        print(i, "/", len(pend), flush=True)
    time.sleep(1.2)
print("Fin:", len(hecho), "respuestas guardadas en", salida)

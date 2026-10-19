"""Completa calle y código postal de candidatos (salida de buscar.py) con Nominatim inverso, a ritmo suave.
Uso: python enriquecer.py <candidatos.json> <salida.json>
Reglas: solo consulta los candidatos sin calle o sin código postal; 1 petición por segundo con User-Agent identificado
(política de uso de Nominatim). Nunca sobrescribe lo que ya trae OpenStreetMap."""
import json
import sys
import time
import urllib.request

UA = "mapas-wesser-carga/1.0 (danytf@gmail.com)"
filas = json.load(open(sys.argv[1], encoding="utf-8"))
for r in filas:
    if r["street"] and r["postcode"]:
        continue
    url = "https://nominatim.openstreetmap.org/reverse?format=jsonv2&addressdetails=1&zoom=18&lat=%s&lon=%s" % (r["lat"], r["lon"])
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    try:
        d = json.load(urllib.request.urlopen(req, timeout=30))
    except Exception as e:
        print("Error en", r["osm"], e)
        continue
    a = d.get("address", {})
    if not r["street"]:
        r["street"] = a.get("road", "")
        r["street_origen"] = "nominatim"
    if not r["postcode"]:
        r["postcode"] = a.get("postcode", "")
    time.sleep(1.2)
json.dump(filas, open(sys.argv[2], "w", encoding="utf-8"), ensure_ascii=False, indent=1)
for r in filas:
    print(" | ".join([r["osm"], r["name"], r["municipio"], r["street"] or "-", r["postcode"] or "-"]))

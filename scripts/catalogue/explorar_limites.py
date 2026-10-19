"""Exploración de los límites administrativos de un fichero .osm.pbf (solo lectura, sin datos del repositorio).
Uso: python explorar_limites.py <fichero.osm.pbf>
Cuenta las áreas administrativas por nivel y enseña etiquetas de ejemplo, para decidir cómo extraer provincias y municipios."""
import sys
from collections import Counter, defaultdict

import osmium


class Limites(osmium.SimpleHandler):
    def __init__(self):
        super().__init__()
        self.por_nivel = Counter()
        self.ejemplos = defaultdict(list)
        self.con_ine = Counter()

    def area(self, a):
        t = a.tags
        if t.get("boundary") != "administrative":
            return
        nivel = t.get("admin_level", "?")
        self.por_nivel[nivel] += 1
        if "ine:municipio" in t or "ine:provincia" in t:
            self.con_ine[nivel] += 1
        if len(self.ejemplos[nivel]) < 3:
            self.ejemplos[nivel].append({k: t.get(k) for k in ("name", "ine:municipio", "ine:provincia", "ref:ine", "wikidata", "admin_level") if t.get(k)})


h = Limites()
h.apply_file(sys.argv[1], locations=True)
print("Áreas administrativas por admin_level:", dict(sorted(h.por_nivel.items())))
print("Con código INE por nivel:", dict(h.con_ine))
for n in sorted(h.ejemplos):
    print("nivel", n, h.ejemplos[n])

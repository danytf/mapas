// Contornos de provincias (PROV_GEO): 52 provincias, polígonos válidos y dentro de España. Comprobación estática de index.html.
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";
const html = readFileSync(process.argv[2] || "index.html", "utf8");
const i = html.indexOf("const PROV_GEO = ");
assert.ok(i > 0, "Falta PROV_GEO");
const fin = html.indexOf(";\n", i);
const geo = JSON.parse(html.slice(i + "const PROV_GEO = ".length, fin));
const claves = Object.keys(geo);
assert.equal(claves.length, 52, "Debe haber 52 provincias, hay " + claves.length);
for (const [k, polys] of Object.entries(geo)) {
  assert.ok(polys.length > 0, k + ": sin polígonos");
  for (const poly of polys) for (const ring of poly) {
    assert.ok(ring.length >= 4, k + ": anillo con menos de 4 puntos");
    assert.deepEqual(ring[0], ring[ring.length - 1], k + ": anillo sin cerrar");
    for (const [lon, lat] of ring) assert.ok(lon > -19 && lon < 5.5 && lat > 27 && lat < 44.5, k + ": coordenada fuera de España (" + lon + "," + lat + ")");
  }
}
for (const n of ["Granada", "Almería", "Sevilla", "Alicante/Alacant", "Valencia/València", "Araba/Álava", "Illes Balears", "Santa Cruz de Tenerife", "Ceuta", "Melilla"]) assert.ok(claves.includes(n), "Falta la provincia " + n);
assert.ok(/function resaltaProvincia\(\)/.test(html) && /resaltaProvincia\(\);/.test(html.slice(html.indexOf("const refilter"))), "refilter debe llamar a resaltaProvincia");
console.log("Contornos de provincias: 52 provincias, polígonos cerrados y dentro de España.");

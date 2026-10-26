// Vista del mapa: encuadre general sin las islas lejanas, atajos de zona y agrupaciones por densidad.
// Prueba estática sobre index.html (con la lógica de zonas ejecutada de verdad). Ejecución: node scripts/test-mapa-vista.mjs
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const html = readFileSync(process.argv[2] || "index.html", "utf8");

// 1) Las zonas: se extrae el código real de index.html y se ejecuta.
const mReg = html.match(/const REGIONES = \[[\s\S]*?\n\];\nconst regionDe = [\s\S]*?\n\};/);
assert.ok(mReg, "Faltan REGIONES y regionDe en index.html");
const { REGIONES, regionDe } = new Function(mReg[0] + "\nreturn { REGIONES, regionDe };")();
assert.deepEqual(REGIONES.map((r) => r.id), ["peninsula", "canarias", "baleares"], "Las zonas deben ser península, Canarias y Baleares (Ceuta y Melilla cuentan como península)");

// Hechos geográficos (no datos del catálogo).
const casos = {
  "Madrid": [40.42, -3.70, "peninsula"], "Sevilla": [37.39, -5.99, "peninsula"], "Barcelona": [41.39, 2.17, "peninsula"], "A Coruña": [43.37, -8.40, "peninsula"],
  "Almería": [36.84, -2.46, "peninsula"], "Girona": [41.98, 2.82, "peninsula"], "Algeciras": [36.13, -5.45, "peninsula"],
  "Santa Cruz de Tenerife": [28.47, -16.25, "canarias"], "Las Palmas de Gran Canaria": [28.12, -15.43, "canarias"], "Arrecife": [28.96, -13.55, "canarias"], "El Hierro": [27.75, -18.0, "canarias"],
  "Palma": [39.57, 2.65, "baleares"], "Ibiza": [38.91, 1.43, "baleares"], "Mahón": [39.89, 4.26, "baleares"],
  "Ceuta (cuenta como península)": [35.89, -5.32, "peninsula"], "Melilla (cuenta como península)": [35.29, -2.94, "peninsula"]
};
for (const [n, [lat, lon, esperada]] of Object.entries(casos)) assert.equal(regionDe(lat, lon), esperada, n + " debe caer en " + esperada);

// 2) La vista general no incluye Canarias si hay otros puntos, y los atajos solo salen si hay dos o más zonas con puntos.
const fit = html.match(/function fitAll\(\) \{[\s\S]*?\n\}/);
assert.ok(fit, "Falta fitAll");
assert.ok(/regionDe\(p\.lat, p\.lng\) !== "canarias"/.test(fit[0]) && /principales\.length \? principales : pts/.test(fit[0]), "fitAll debe encuadrar sin Canarias salvo que solo haya Canarias");
assert.ok(/regionesEl\.hidden = vis\.length < 2/.test(html), "Los atajos deben ocultarse con una sola zona");
assert.ok(/regionesEl\.setAttribute\("role", "group"\)[\s\S]*?aria-label/.test(html), "El grupo de atajos debe tener rol y nombre accesible");
assert.ok(/options: \{ position: "topleft" \}, onAdd: \(\) => regionesEl/.test(html), "Los atajos son un control de Leaflet bajo el zoom (arriba a la izquierda)");
const pinta = html.match(/function pintaRegiones\(\) \{[\s\S]*?\n\}/);
assert.ok(pinta && /textContent = r\.nombre/.test(pinta[0]) && !/innerHTML/.test(pinta[0]), "Los atajos se crean con textContent, no con innerHTML");
assert.ok(/<button|createElement\("button"\)/.test(pinta[0]) && /b\.type = "button"/.test(pinta[0]), "Cada atajo es un botón nativo");

// 3) Las agrupaciones tienen cuatro niveles de densidad con color y tamaño propios.
const ic = html.match(/iconCreateFunction: \(cl\) => \{[\s\S]*?\n  \}/);
assert.ok(ic, "Falta iconCreateFunction");
assert.ok(/n >= 1000 \? 4 : n >= 100 \? 3 : n >= 10 \? 2 : 1/.test(ic[0]), "Los niveles deben ser 1, 10, 100 y 1000");
assert.ok(/\[0, 34, 42, 52, 62\]\[nivel\]/.test(ic[0]), "Cada nivel tiene un tamaño creciente");
for (const n of [1, 2, 3, 4]) assert.ok(new RegExp("\\.cl\\.n" + n + " \\{ background:").test(html), "Falta el color del nivel " + n);
const radio = Number((html.match(/maxClusterRadius: (\d+)/) || [])[1]);
assert.ok(radio >= 58 && radio <= 80, "El radio de agrupación debe dejar sitio al mayor círculo (62 px) sin que se pisen");

console.log("test-mapa-vista: OK (" + Object.keys(casos).length + " lugares en su zona; vista general, atajos y 4 niveles de agrupación)");

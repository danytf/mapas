// Límites del mapa: el mapa no se puede arrastrar fuera de un recuadro que contiene España entera.
// Prueba estática sobre index.html. Ejecución: node scripts/test-mapa-limites.mjs
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const html = readFileSync(process.argv[2] || "index.html", "utf8");

// 1) El mapa se crea con los límites, el zoom mínimo y la viscosidad máxima.
const m = html.match(/const SPAIN_BOUNDS = L\.latLngBounds\(\[\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*\]\s*,\s*\[\s*(-?[\d.]+)\s*,\s*(-?[\d.]+)\s*\]\s*\);/);
assert.ok(m, "Falta la constante SPAIN_BOUNDS con los cuatro números del recuadro");
const [sur, oeste, norte, este] = m.slice(1).map(Number);
assert.ok(sur < norte && oeste < este, "El recuadro debe ir de suroeste a noreste");
assert.match(
  html,
  /const map = L\.map\("map", \{[^}]*minZoom: 5[^}]*maxBounds: SPAIN_BOUNDS[^}]*maxBoundsViscosity: 1(\.0)?[^}]*\}\)/,
  "El mapa debe crearse con minZoom 5, maxBounds: SPAIN_BOUNDS y maxBoundsViscosity 1"
);
assert.ok(html.indexOf("const SPAIN_BOUNDS") < html.indexOf('const map = L.map("map"'), "SPAIN_BOUNDS debe declararse antes de crear el mapa");

// 2) El recuadro contiene los extremos geográficos de España (hechos geográficos, no datos del catálogo).
const dentro = (lat, lon) => lat >= sur && lat <= norte && lon >= oeste && lon <= este;
const extremos = {
  "Estaca de Bares (norte de la península)": [43.79, -7.69],
  "Punta de Tarifa (sur de la península)": [36.0, -5.61],
  "Cabo Touriñán (oeste de la península)": [43.05, -9.3],
  "Cap de Creus (este de la península)": [42.32, 3.32],
  "Cap de Cavalleria (Menorca)": [40.09, 4.09],
  "Formentera": [38.7, 1.45],
  "Punta de Orchilla (El Hierro, oeste de Canarias)": [27.7, -18.16],
  "La Restinga (El Hierro, sur de Canarias)": [27.64, -17.98],
  "Alegranza (norte de Canarias)": [29.4, -13.5],
  "Punta de Jandía (Fuerteventura, este de Canarias)": [28.06, -14.5],
  "Ceuta": [35.89, -5.31],
  "Melilla": [35.29, -2.94],
  "Islas Chafarinas": [35.18, -2.43],
  "Isla de Alborán": [35.94, -3.04],
};
for (const [nombre, [lat, lon]] of Object.entries(extremos)) {
  assert.ok(dentro(lat, lon), nombre + " queda fuera del recuadro del mapa");
}

// 3) El recuadro no es absurdamente grande: no incluye el centro de Europa ni América.
assert.ok(!dentro(48.85, 2.35), "París no debería caber en el recuadro");
assert.ok(!dentro(40.7, -74.0), "Nueva York no debería caber en el recuadro");
assert.ok(norte - sur < 20 && este - oeste < 30, "El recuadro es demasiado grande");

console.log("test-mapa-limites: OK (recuadro " + sur + "," + oeste + " a " + norte + "," + este + "; " + Object.keys(extremos).length + " extremos de España dentro)");

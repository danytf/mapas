// Regresión estática: ningún texto de la interfaz baja de 12 px (DESIGN.md, escala tipográfica).
// Única excepción: la atribución legal de Leaflet/OpenStreetMap, que la librería controla.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const css = html.slice(html.indexOf("<style>"), html.indexOf("</style>"));
const pequenos = css.split("\n").filter((l) => /font-size:\s*(\d|1[01])(\.\d+)?px/.test(l) && !/\.leaflet-control-attribution/.test(l));
assert.deepEqual(pequenos.map((l) => l.trim().slice(0, 80)), [], "Hay texto de menos de 12 px en el CSS");

const resto = html.slice(html.indexOf("</style>"));
const enLinea = resto.match(/font-size:\s*(\d|1[01])(\.\d+)?px/g) || [];
assert.deepEqual(enLinea, [], "Hay texto de menos de 12 px en estilos en línea");

console.log("Texto mínimo de 12 px: comprobaciones estáticas correctas.");

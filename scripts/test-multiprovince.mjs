// Prueba del uso en varias provincias (H-20 y H-21): la app no debe depender de Granada.
// Extrae las funciones de index.html y las ejecuta con puntos de varias provincias, y comprueba que no
// quedan en el código los valores fijos de Granada (recuadros, vista, municipio por defecto, nombre del CSV).
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const slice = (from, to, includeTo = false) => {
  const a = html.indexOf(from);
  assert.ok(a >= 0, "No se encuentra en index.html: " + from);
  const b = html.indexOf(to, a);
  assert.ok(b > a, "No se encuentra el final: " + to);
  return html.slice(a, includeTo ? b + to.length : b);
};

// --- Código extraído -------------------------------------------------------------------------------------
const code = [
  slice("const SPAIN_AREAS", "z.lonMax);", true),
  slice("const townOf = ", "\n"),
  slice("function parseCoords(t) {", "async function setLoc("),
  slice("function defaultTown() {", "function readForm() {"),
  slice("const slugName = ", '$("#csv").addEventListener'),
  slice("function searchViewbox() {", "let fitTimer")
].join("\n");

function world(centers, cache = {}) {
  return runInNewContext(
    "var CENTERS = " + JSON.stringify(centers) + "; var cache = " + JSON.stringify(cache) + "; var isOut = () => false;\n" + code +
    "\n({ inSpain, townOf, parseCoords, defaultTown, exportScopeName, searchViewbox, slugName, SPAIN_CENTER })"
  );
}
const pt = (id, province, extra = {}) => ({ id, name: "P" + id, province, ...extra });

// --- inSpain: toda España, nada fuera ---------------------------------------------------------------------
const w0 = world([]);
for (const [nombre, lat, lon] of [["Granada", 37.1773, -3.5986], ["Madrid", 40.4168, -3.7038], ["Barcelona", 41.3874, 2.1686],
  ["A Coruña", 43.3623, -8.4115], ["Almería este (Vera)", 37.2, -1.86], ["Palma", 39.5696, 2.6502],
  ["Las Palmas", 28.1235, -15.4363], ["Melilla", 35.2923, -2.9381], ["Ceuta", 35.8894, -5.3213]]) {
  assert.equal(w0.inSpain(lat, lon), true, nombre + " debe estar dentro");
}
for (const [nombre, lat, lon] of [["París", 48.8566, 2.3522], ["Rabat", 34.02, -6.84], ["Atlántico entre Canarias y la Península", 33, -12], ["Golfo de Guinea", 0, 0], ["Nueva York", 40.71, -74.0], ["Latitud y longitud cambiadas (Granada)", -3.6, 37.17]]) {
  assert.equal(w0.inSpain(lat, lon), false, nombre + " debe estar fuera");
}
for (const bad of [[NaN, -3], [37, Infinity], ["37", "-3"], [null, null], [undefined, 1]]) {
  assert.equal(w0.inSpain(...bad), false, "Valor no numérico rechazado: " + JSON.stringify(bad));
}
assert.deepEqual(Array.from(w0.SPAIN_CENTER), [40.2, -3.7]);

// --- parseCoords: acepta coordenadas de cualquier provincia ------------------------------------------------
assert.deepEqual(Array.from(w0.parseCoords("https://www.google.com/maps/@40.4168,-3.7038,17z")), [40.4168, -3.7038]);
assert.deepEqual(Array.from(w0.parseCoords("37.2000, -1.8600")), [37.2, -1.86]);
assert.equal(w0.parseCoords("48.8566, 2.3522"), null, "París fuera de España");
assert.equal(w0.parseCoords("no son coordenadas"), null);

// --- townOf ----------------------------------------------------------------------------------------------
assert.equal(w0.townOf({ town: "Armilla", province: "Granada" }), "Armilla");
assert.equal(w0.townOf({ province: "Almería" }), "Almería");
assert.equal(w0.townOf({}), "Sin municipio");

// --- defaultTown: solo si el usuario ve una única provincia -----------------------------------------------
assert.equal(world([pt(1, "Granada"), pt(2, "Granada")]).defaultTown(), "Granada");
assert.equal(world([pt(1, "Almería")]).defaultTown(), "Almería");
assert.equal(world([pt(1, "Granada"), pt(2, "Almería")]).defaultTown(), "", "con dos provincias no se supone ninguna");
assert.equal(world([]).defaultTown(), "");
assert.equal(world([pt(1, "Granada"), pt(2, "Madrid", { custom: true })]).defaultTown(), "Granada", "los puntos personales no cuentan");

// --- Nombre de los ficheros exportados ---------------------------------------------------------------------
assert.equal(world([pt(1, "Granada")]).exportScopeName(), "granada");
assert.equal(world([pt(1, "Granada"), pt(2, "Almería"), pt(3, "Granada")]).exportScopeName(), "almeria-granada");
assert.equal(world([pt(1, "Granada"), pt(2, "Almería"), pt(3, "Jaén")]).exportScopeName(), "almeria-granada-jaen");
assert.equal(world([pt(1, "Granada"), pt(2, "Almería"), pt(3, "Jaén"), pt(4, "Cádiz")]).exportScopeName(), "varias-provincias");
assert.equal(world([]).exportScopeName(), "mapa");
assert.equal(world([pt(1, "Araba/Álava")]).exportScopeName(), "araba-alava");
assert.equal(world([pt(1, "A Coruña")]).exportScopeName(), "a-coruna");
assert.equal(world([pt(1, "Granada"), pt(2, "Madrid", { custom: true })]).exportScopeName(), "granada");

// --- Área de búsqueda de «Ubicar por dirección» ---------------------------------------------------------------
assert.equal(world([]).searchViewbox(), "", "sin puntos no hay área (se busca en toda España)");
{
  const w = world([pt(1, "Almería"), pt(2, "Almería"), pt(3, "Granada")], { 1: { lat: 36.84, lon: -2.46 }, 2: { lat: 37.25, lon: -1.86 }, 3: { lat: 37.18, lon: -3.6 } });
  const [izq, arr, der, aba] = w.searchViewbox().split(",").map(Number);
  assert.ok(izq < -3.6 && der > -1.86 && arr > 37.25 && aba < 36.84, "el área cubre todos los puntos con margen: " + w.searchViewbox());
  assert.ok(izq > -3.9 && der < -1.6 && arr < 37.6 && aba > 36.5, "el margen es acotado: " + w.searchViewbox());
}
{
  // Los puntos personales y los quitados no definen el área.
  const w = world([pt(1, "Granada", { custom: true }), pt(2, "Granada")], { 1: { lat: 40.4, lon: -3.7 }, 2: { lat: 37.18, lon: -3.6 } });
  const [izq, , der] = w.searchViewbox().split(",").map(Number);
  assert.ok(der < -3.0 && izq > -4.0, "el punto personal de Madrid no amplía el área: " + w.searchViewbox());
}

// --- Valores fijos de Granada que no deben volver -----------------------------------------------------------
const prohibidos = [
  [/\|\| "Granada"/, 'municipio por defecto «|| "Granada"»'],
  [/"Granada"\s*\)\s*\)?\s*;?\s*\n?.*VIEWBOX|const VIEWBOX/, "recuadro de búsqueda fijo (VIEWBOX)"],
  [/lat < 36\.5|lat > 38\.3|lon < -4\.6|lon > -2\.2|la >= 36\.5/, "recuadro de coordenadas de Granada"],
  [/setView\(\[37\.1773/, "vista inicial en Granada"],
  [/permisos-captacion-granada\.csv/, "nombre fijo del CSV"],
  [/\$\("#n-town"\)\.value = "Granada"|id="n-town" value="Granada"/, "municipio «Granada» fijo en el formulario"],
  [/async function locateAll/, "geocodificación masiva en el navegador (locateAll)"]
];
for (const [re, que] of prohibidos) assert.ok(!re.test(html), "Vuelve a aparecer un valor fijo de Granada: " + que);

console.log("test-multiprovince: OK (inSpain, parseCoords, townOf, defaultTown, nombre del CSV, área de búsqueda y sin valores fijos de Granada)");

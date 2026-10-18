// Regresión de rendimiento con muchos puntos (H-27). Con 50.000 puntos la carga del mapa tardaba minutos por un
// coste cuadrático en renderList y por añadir los marcadores uno a uno. El comportamiento real en el navegador se
// mide con scripts/dev/mock-supabase.mjs (ver docs/AUDITORIA_FASE_D_2026-10-18.md); aquí se comprueba lo que se
// puede comprobar sin navegador: la equivalencia y el coste de normalizePersonalRefs y que no vuelven los patrones lentos.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("const personalStateKey = ");
const b = html.indexOf("const isOut = ", a);
assert.ok(a >= 0 && b > a, "No se encuentra normalizePersonalRefs en index.html");
const trozo = html.slice(a, b);
assert.ok(trozo.includes("const normalizePersonalRefs = "), "No se encuentra normalizePersonalRefs");

function mundo(centers) {
  return runInNewContext("var CENTERS = " + JSON.stringify(centers) + ";\n" + trozo + "\n({ normalizePersonalRefs, personalStateKey })");
}
// Versión anterior (recorría todos los puntos por cada referencia), como referencia de equivalencia.
function anterior(centers, value, personalStateKey) {
  return new Set((Array.isArray(value) ? value : []).filter((x) => typeof x === "string").map((ref) => {
    const c = centers.find((item) => item.databaseId && (ref === item.name || ref === ("est:" + item.databaseId)));
    return c ? personalStateKey(c) : ref;
  }));
}
const igual = (x, y) => JSON.stringify([...x].sort()) === JSON.stringify([...y].sort());

// --- Equivalencia con la versión anterior en casos variados ---------------------------------------------------
const centros = [
  { id: 1, name: "Hospital A", databaseId: "uuid-a" }, { id: 2, name: "Centro B", databaseId: "uuid-b" },
  { id: 3, name: "Punto personal", custom: true }, { id: 4, name: "Hospital A", databaseId: "uuid-c" }, { id: 5, name: "Sin id" }
];
const w = mundo(centros);
const entradas = [
  ["Hospital A", "est:uuid-b", "Punto personal", "Sin id", "no existe", "est:uuid-zzz", "custom:Punto personal", "est:uuid-c"],
  [], ["Hospital A", "Hospital A"], ["est:uuid-a", "est:uuid-a"], [1, null, undefined, {}, "Centro B"], "no es una lista", null, undefined
];
for (const e of entradas) assert.ok(igual(w.normalizePersonalRefs(e), anterior(centros, e, w.personalStateKey)), "Resultado distinto para " + JSON.stringify(e));
// El nombre repetido se resuelve en el primer punto con identificador, como antes.
assert.ok(w.normalizePersonalRefs(["Hospital A"]).has("est:uuid-a") && !w.normalizePersonalRefs(["Hospital A"]).has("est:uuid-c"));

// --- Coste: 50.000 puntos y 3.000 referencias deben resolverse en bien menos de un segundo (antes, ~150 millones de comparaciones) ---
const muchos = Array.from({ length: 50000 }, (_, i) => ({ id: i + 1, name: "Punto " + i, databaseId: "uuid-" + i }));
const wm = mundo(muchos);
const refs = Array.from({ length: 3000 }, (_, i) => (i % 2 ? "est:uuid-" + (i * 13) % 50000 : "Punto " + (i * 7) % 50000));
const t0 = Date.now();
const r = wm.normalizePersonalRefs(refs);
const ms = Date.now() - t0;
assert.ok(r.size > 2000, "Resultado inesperado");
assert.ok(ms < 1000, "normalizePersonalRefs tarda " + ms + " ms con 50.000 puntos y 3.000 referencias: ha vuelto un coste cuadrático");

// --- Patrones lentos que no deben volver ---------------------------------------------------------------------------
const prohibidos = [
  [/CENTERS\.find\(\(x\) => x\.id === \+li\.dataset\.id\)/, "búsqueda lineal por elemento de la lista (cuadrática) en renderList"],
  [/CENTERS\.forEach\(makeMarker\)/, "marcadores añadidos uno a uno (usar makeMarkers)"],
  [/cluster\.addLayer\(markers\[c\.id\]\)/, "marcador añadido individualmente dentro de renderList"],
  [/cluster\.removeLayer\(markers\[c\.id\]\)/, "marcador quitado individualmente dentro de renderList"]
];
for (const [re, que] of prohibidos) assert.ok(!re.test(html), "Vuelve a aparecer: " + que);
const requeridos = [
  ["const LIST_PAGE = 1000;", "lista lateral paginada (1.000 puntos por página)"],
  ["cluster.addLayers(toAdd)", "marcadores visibles añadidos en bloque"],
  ["cluster.removeLayers(toRemove)", "marcadores ocultos quitados en bloque"],
  ["cluster.addLayers(nuevos)", "marcadores nuevos añadidos en bloque"],
  ["listLimit = Math.ceil((idx + 1) / LIST_PAGE) * LIST_PAGE;", "la lista se amplía para incluir un punto elegido en el mapa"],
  ['boton.textContent = "Mostrar "', "botón «Mostrar más»"]
];
for (const [texto, que] of requeridos) assert.ok(html.includes(texto), "Falta: " + que);

console.log("test-list-performance: OK (normalizePersonalRefs equivalente y " + ms + " ms con 50.000 puntos; sin patrones lentos)");

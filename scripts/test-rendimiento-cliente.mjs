// Rendimiento del cliente con muchos puntos (39.000): lo que se comprueba sin navegador.
// 1) Equivalencia: las rutas rápidas de permOf, estadoOf, histOf, seguimientoDue y hasPersonalRef dan lo mismo que las versiones anteriores
//    (ejecutadas aquí como referencia) para puntos sin expediente, con expedientes variados y con conjuntos personales vacíos o con datos.
// 2) Forma del código: la carga no calcula dos veces filtros, indicadores y lista; refreshSelects cuenta categorías y estados en una pasada;
//    checkLogros calcula las insignias una vez; las cuatro listas personales comparten un índice; refreshCounts evalúa las condiciones
//    comunes una vez por punto. La medida real (Chrome contra el Supabase simulado con 39.000 puntos) está en el informe del PR.
// Uso: node scripts/test-rendimiento-cliente.mjs [index.html]
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const linea = (inicio) => { const i = html.indexOf(inicio); assert.ok(i >= 0, "No se encuentra: " + inicio); const f = html.indexOf("\n", i); return html.slice(i, f); };
const trozo = (desde, hasta) => { const a = html.indexOf(desde), b = html.indexOf(hasta, a); assert.ok(a >= 0 && b > a, "No se encuentra el tramo " + desde + " … " + hasta); return html.slice(a, b); };
const cuerpoFuncion = (firma) => { const a = html.indexOf(firma); assert.ok(a >= 0, "No se encuentra " + firma); let i = html.indexOf("{", a), n = 0; for (; i < html.length; i++) { if (html[i] === "{") n++; else if (html[i] === "}" && --n === 0) break; } return html.slice(a, i + 1); };

// ---------------------------------------------------------------------------------------------------------------------------
// 1) Equivalencia con las versiones anteriores
const nuevo = [
  linea("const permitKey = "), linea("const personalStateKey = "), linea("const hasPersonalRef = "),
  linea("const PERM_SIN = "), linea("const permOf = "),
  trozo("const TZ_NEGOCIO = ", "/* Expedientes de un punto en forma uniforme")
].join("\n");
const anterior = `
const hasPersonalRefAnt = (set, c) => set.has(personalStateKey(c)) || set.has(c.name);
const permOfAnt = (c) => permits[permitKey(c)] || { estado: "sin", fecha: "", contacto: "", notas: "", valoracion: 0 };
const histOfAnt = (c) => ((permits[permitKey(c)] && permits[permitKey(c)].historial) || []).slice().sort((a, b) => (b.desde || "").localeCompare(a.desde || ""));
const estadoOfAnt = (c) => estadoCalc(permOfAnt(c));
const seguimientoDueAnt = (c) => { const p = permOfAnt(c), d = [segCalc(p), p.seguimiento, p.segPunto && p.segPunto.fecha].filter(Boolean).sort()[0]; return d && d <= today() ? d : ""; };
`;
const mundo = runInNewContext("var permits = {};\n" + nuevo + "\n" + anterior + "\n({ get permits() { return permits; }, set permits(v) { permits = v; }, permitKey, personalStateKey, hasPersonalRef, hasPersonalRefAnt, PERM_SIN, permOf, permOfAnt, histOf, histOfAnt, estadoOf, estadoOfAnt, seguimientoDue, seguimientoDueAnt, today, addDays })");
const hoy = mundo.today(), d = (k) => mundo.addDays(hoy, k);

const puntos = Array.from({ length: 40 }, (_, i) => i % 7 === 6 ? { id: i + 1, name: "Personal " + i, custom: true } : { id: i + 1, name: "Punto " + i, databaseId: "uuid-" + i });
const expedientes = {
  sinFechas: { estado: "solicitado", fecha: d(-3) },
  vacio: {},
  solicitudPendiente: { solicitudes: [{ desde: d(1), hasta: d(9), seg: d(-1), ong: "AECC", captadores: 2 }] },
  solicitudCaducada: { solicitudes: [{ desde: d(-20), hasta: d(-10), ong: "WWF" }] },
  denegada: { solicitudes: [{ desde: d(1), hasta: d(5), res: "denegada" }] },
  vigente: { estado: "concedido", historial: [{ desde: d(-5), hasta: d(10), captadores: 3, ong: "Cruz Roja" }, { desde: d(-40), hasta: d(-30), captadores: 1 }] },
  futura: { historial: [{ desde: d(5), hasta: d(15), captadores: 2 }] },
  terminada: { historial: [{ desde: d(-30), hasta: d(-20) }] },
  cancelada: { historial: [{ desde: d(-5), hasta: d(10), cancelada: true }] },
  seguimientoPunto: { seguimiento: d(-2) }, seguimientoFuturo: { seguimiento: d(4) },
  segPunto: { segPunto: { fecha: d(0), resp: "x" } }, valorado: { valoracion: 4, contacto: "a" }
};
const nombres = Object.keys(expedientes);
let comparaciones = 0;
const iguales = (a, b, msg) => { assert.deepStrictEqual(a, b, msg); comparaciones++; };
// Sin ningún expediente (lo habitual: casi todo el catálogo) y con un expediente cada vez, para cada tipo de punto.
const escenarios = [{}];
nombres.forEach((n) => escenarios.push(Object.fromEntries(puntos.filter((_, i) => i % 3 === nombres.indexOf(n) % 3).map((c) => [mundo.permitKey(c), expedientes[n]]))));
escenarios.push(Object.fromEntries(puntos.map((c, i) => [mundo.permitKey(c), expedientes[nombres[i % nombres.length]]])));
for (const [k, esc] of escenarios.entries()) {
  mundo.permits = esc;
  for (const c of puntos) {
    const ref = "escenario " + k + ", punto " + c.id;
    iguales(mundo.permOf(c), mundo.permOfAnt(c), "permOf: " + ref);
    iguales(mundo.estadoOf(c), mundo.estadoOfAnt(c), "estadoOf: " + ref);
    iguales(mundo.histOf(c), mundo.histOfAnt(c), "histOf: " + ref);
    iguales(!!mundo.seguimientoDue(c), !!mundo.seguimientoDueAnt(c), "seguimientoDue (verdad): " + ref);
    iguales(mundo.seguimientoDue(c) || "", mundo.seguimientoDueAnt(c) || "", "seguimientoDue: " + ref);
  }
}
// El estado por defecto es un único objeto congelado: nadie puede modificarlo sin querer.
mundo.permits = {};
assert.ok(Object.isFrozen(mundo.PERM_SIN), "PERM_SIN debe estar congelado");
assert.strictEqual(mundo.permOf(puntos[0]), mundo.PERM_SIN, "permOf debe devolver el estado por defecto compartido");
assert.deepStrictEqual({ ...mundo.PERM_SIN }, { estado: "sin", fecha: "", contacto: "", notas: "", valoracion: 0 });
// Ninguna parte de la aplicación asigna sobre el resultado de permOf (el objeto compartido es de solo lectura).
assert.ok(!/permOf\([^)]*\)\.[A-Za-z_]+\s*=[^=]/.test(html), "Alguna parte asigna una propiedad sobre el resultado de permOf");

// Conjuntos personales: vacíos (atajo), con la clave del punto, con el nombre heredado y con ambos.
for (const c of puntos) {
  const claves = [new Set(), new Set([mundo.personalStateKey(c)]), new Set([c.name]), new Set(["otra", "est:uuid-zzz"]), new Set([mundo.personalStateKey(puntos[1]), c.name])];
  for (const s of claves) iguales(mundo.hasPersonalRef(s, c), mundo.hasPersonalRefAnt(s, c), "hasPersonalRef de " + c.name);
}

// ---------------------------------------------------------------------------------------------------------------------------
// 2) Forma del código
const sync = cuerpoFuncion("async function syncCatalogueFromSupabase()");
const trasMarcadores = sync.slice(sync.indexOf("makeMarkers(CENTERS);"), sync.indexOf("window.mapaSession.catalogueReady = true;"));
assert.ok(trasMarcadores.includes("makeMarkers(CENTERS);") && trasMarcadores.includes("fitAll()"), "syncCatalogueFromSupabase debe crear los marcadores y encuadrar el mapa");
assert.ok(!/refreshSelects\(\)/.test(trasMarcadores) && !/renderList\(\)/.test(trasMarcadores),
  "syncCatalogueFromSupabase no debe volver a calcular filtros, indicadores ni lista: lo hace loadPersonalState justo después, con el estado personal ya aplicado");
assert.ok(trasMarcadores.includes("window.mapaListLoading = false;"), "El estado «cargando» de la lista debe terminar al cargar el catálogo");
const personal = cuerpoFuncion("async function loadPersonalState()");
const finPersonal = personal.slice(personal.lastIndexOf("makeMarkers(CENTERS);"));
for (const llamada of ["refreshSelects();", "renderList();", "gamTile();", "checkLogros();"]) assert.ok(finPersonal.includes(llamada), "loadPersonalState debe terminar con " + llamada);
// Ambos accesos (formulario y sesión guardada) llaman a loadPersonalState tras el catálogo: ninguno deja la pantalla sin lista.
assert.strictEqual((html.match(/syncCatalogueFromSupabase\(\)\)/g) || []).length, 2, "Cambió el número de llamadas a syncCatalogueFromSupabase");
assert.strictEqual((html.match(/await syncCatalogueFromSupabase\(\)\) throw[^\n]*\n\s*await loadPersonalState\(\);/g) || []).length, 2, "Tras el catálogo debe cargarse siempre el estado personal");

const logros = cuerpoFuncion("function checkLogros()");
assert.strictEqual((logros.match(/logrosCalc\(\)/g) || []).length, 1, "checkLogros debe calcular las insignias una sola vez");

const selects = cuerpoFuncion("function refreshSelects()");
assert.ok(/porTipo/.test(selects) && /porEstado/.test(selects), "refreshSelects debe contar categorías y estados en una pasada");
assert.ok(!/vis\.filter\(\(c\) => c\.tipo === t\)/.test(selects), "refreshSelects vuelve a recorrer todos los puntos por cada categoría");
assert.ok(!/vis\.filter\(\(c\) => estadoOf\(c\) === k\)/.test(selects), "refreshSelects vuelve a recorrer todos los puntos por cada estado");
assert.ok(!/vis\.some\(/.test(selects), "refreshSelects vuelve a recorrer todos los puntos para la leyenda");

assert.ok(/let indiceRefs = null;/.test(html) && personal.split("indiceRefs = null;").length === 3, "loadPersonalState debe reiniciar el índice de referencias antes y después de las cuatro listas personales");
const normaliza = cuerpoFuncion("const normalizePersonalRefs = (value) =>");
assert.ok(normaliza.includes("if (!refs.length) return new Set();") && normaliza.includes("if (!indiceRefs)"), "normalizePersonalRefs debe construir el índice solo si hace falta y compartirlo");

const contadores = cuerpoFuncion("function refreshCounts()");
assert.ok(contadores.includes("CENTERS.filter((c) => coincideComun(c, f))") && contadores.includes("coincide(c, f, clave, true)"), "refreshCounts debe evaluar las condiciones comunes una vez por punto");

console.log("test-rendimiento-cliente: OK (" + comparaciones + " comparaciones de equivalencia; carga sin cálculo duplicado, una pasada por categoría/estado, insignias una vez, índice compartido, contadores con condiciones comunes una vez)");

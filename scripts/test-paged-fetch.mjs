// Prueba de la carga paginada de index.html (H-23): fetchAllRows nunca devuelve una lista incompleta.
// Usa un cliente simulado que imita a PostgREST: orden y filtro por clave, límite, total exacto en la
// primera petición y un tope de filas por petición (Max rows) que recorta sin avisar.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const start = html.indexOf("const fetchAllRows = async");
const end = html.indexOf("// Guarda una fila del estado compartido", start);
assert.ok(start >= 0 && end > start, "No se pudo extraer fetchAllRows del HTML");
const { fetchAllRows } = runInNewContext(html.slice(start, end) + "\n({ fetchAllRows })");

const makeId = (i) => "00000000-0000-4000-8000-" + String(i).padStart(12, "0");

// Tabla simulada. opts: { maxRows, failOnRequest, omitCount, mutate(requestNumber, rows) }.
function mockSource(allRows, opts = {}) {
  const log = { requests: 0, pageSizes: [] };
  let rows = allRows.slice();
  const buildQuery = (selectOpts) => {
    const q = { order: null, gt: null, limit: null, wantCount: Boolean(selectOpts && selectOpts.count === "exact") };
    const api = {
      order(col) { q.order = col; return api; },
      gt(col, v) { q.gt = { col, v }; return api; },
      limit(n) { q.limit = n; return api; },
      then(resolve, reject) {
        log.requests++;
        if (opts.mutate) rows = opts.mutate(log.requests, rows) || rows;
        if (opts.failOnRequest === log.requests) return Promise.resolve({ data: null, error: { message: "fallo simulado" } }).then(resolve, reject);
        let out = rows.slice().sort((a, b) => (a[q.order] < b[q.order] ? -1 : a[q.order] > b[q.order] ? 1 : 0));
        const total = out.length;
        if (q.gt) out = out.filter((r) => r[q.gt.col] > q.gt.v);
        const cap = Math.min(q.limit ?? Infinity, opts.maxRows ?? Infinity);
        out = out.slice(0, cap);
        log.pageSizes.push(out.length);
        return Promise.resolve({ data: out, error: null, count: q.wantCount && !opts.omitCount ? total : null }).then(resolve, reject);
      }
    };
    return api;
  };
  return { buildQuery: (o) => buildQuery(o), log };
}

const table = (n) => Array.from({ length: n }, (_, i) => ({ id: makeId(i + 1), name: "P" + (i + 1) }));
const noDupes = (rows) => new Set(rows.map((r) => r.id)).size === rows.length;

// 0. Control del simulador: la lectura anterior (una sola petición con limit(5000)) contra un tope de
// 1.000 filas devolvía 1.000 de 2.500 filas sin ningún error. Es el fallo de H-23.
{
  const s = mockSource(table(2500), { maxRows: 1000 });
  const { data, error } = await s.buildQuery().order("id").limit(5000);
  assert.equal(error, null); assert.equal(data.length, 1000, "el simulador debe recortar a Max rows sin avisar");
}
// 1. Menos filas que el tope: una sola petición.
{
  const s = mockSource(table(791), { maxRows: 1000 });
  const rows = await fetchAllRows(s.buildQuery, "id");
  assert.equal(rows.length, 791); assert.equal(s.log.requests, 1);
}
// 2. Más filas que el tope (el fallo de H-23): se leen todas, sin duplicados, en orden.
{
  const s = mockSource(table(2500), { maxRows: 1000 });
  const rows = await fetchAllRows(s.buildQuery, "id");
  assert.equal(rows.length, 2500); assert.ok(noDupes(rows)); assert.equal(s.log.requests, 3);
  assert.equal(JSON.stringify(rows.map((r) => r.id)), JSON.stringify(table(2500).map((r) => r.id)));
}
// 3. Exactamente el tope y exactamente un múltiplo.
for (const n of [1000, 2000, 1001]) {
  const rows = await fetchAllRows(mockSource(table(n), { maxRows: 1000 }).buildQuery, "id");
  assert.equal(rows.length, n); assert.ok(noDupes(rows));
}
// 4. El servidor recorta por debajo del tamaño de página (Max rows = 300): sigue hasta el total.
{
  const s = mockSource(table(1000), { maxRows: 300 });
  const rows = await fetchAllRows(s.buildQuery, "id");
  assert.equal(rows.length, 1000); assert.ok(noDupes(rows)); assert.equal(s.log.requests, 4);
}
// 5. Tabla vacía.
assert.equal((await fetchAllRows(mockSource([]).buildQuery, "id")).length, 0);
// 6. Volumen previsto (50.000 puntos): todas las filas.
{
  const s = mockSource(table(50000), { maxRows: 1000 });
  const rows = await fetchAllRows(s.buildQuery, "id");
  assert.equal(rows.length, 50000); assert.ok(noDupes(rows)); assert.equal(s.log.requests, 50);
}
// 7. Un error en una página intermedia aborta: nunca se devuelve una lista parcial.
await assert.rejects(fetchAllRows(mockSource(table(2500), { maxRows: 1000, failOnRequest: 2 }).buildQuery, "id"), (e) => /fallo simulado/.test(e.message));
// 8. Sin total en la primera respuesta no se puede garantizar que esté completo: aborta.
await assert.rejects(fetchAllRows(mockSource(table(10), { omitCount: true }).buildQuery, "id"), /no informó del total/);
// 9. Filas borradas mientras se pagina (el total prometido ya no se alcanza): aborta en lugar de dar un mapa incompleto.
await assert.rejects(fetchAllRows(mockSource(table(2500), {
  maxRows: 1000, mutate: (req, rows) => (req === 2 ? rows.filter((r) => r.id < makeId(1500) || r.id > makeId(2000)) : rows)
}).buildQuery, "id"), /incompleta/);
// 10. Filas añadidas mientras se pagina: se devuelve al menos el total prometido, sin duplicados.
{
  const rows = await fetchAllRows(mockSource(table(2500), {
    maxRows: 1000, mutate: (req, rows) => (req === 2 ? rows.concat([{ id: makeId(9999), name: "nuevo" }]) : rows)
  }).buildQuery, "id");
  assert.ok(rows.length >= 2500); assert.ok(noDupes(rows));
}
// 11. Respuesta sin la columna de ordenación: la paginación no avanza y aborta (en vez de repetir páginas).
await assert.rejects(fetchAllRows((o) => {
  const real = mockSource(table(2500), { maxRows: 1000 }).buildQuery(o);
  const orig = real.then;
  real.then = (res, rej) => orig.call(real, (r) => res({ ...r, data: r.data && r.data.map(({ id, ...rest }) => rest) }), rej);
  return real;
}, "id"), /no avanza/);
// 12. Un servidor que repite siempre la misma página tampoco provoca un bucle infinito.
await assert.rejects(fetchAllRows((o) => {
  const api = mockSource(table(5), {}).buildQuery(o);
  const orig = api.then;
  api.then = (res, rej) => orig.call(api, (r) => res({ ...r, count: 500, data: r.data }), rej);
  return api;
}, "id", 1000, 5), /incompleta/);

console.log("test-paged-fetch: OK (13 casos, incluido 50.000 filas con tope de 1.000 por petición)");

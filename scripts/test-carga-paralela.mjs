// Carga rápida del catálogo (por provincias, varias consultas a la vez). Ejecución: node scripts/test-carga-paralela.mjs
// Se ejecuta de verdad fetchAllRowsPorGrupos de index.html contra un cliente simulado de PostgREST (orden, filtro por clave, igualdad,
// total exacto, tope de filas por petición) y se comprueba por texto que el cargador comprueba el total y vuelve a la lectura en serie.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const start = html.indexOf("const fetchAllRows = async");
const end = html.indexOf("// Guarda una fila del estado compartido", start);
assert.ok(start >= 0 && end > start, "No se pudo extraer el bloque de lectura del HTML");
const { fetchAllRowsPorGrupos } = runInNewContext(html.slice(start, end) + "\n({ fetchAllRows, fetchAllRowsPorGrupos })");

const makeId = (i) => "00000000-0000-4000-8000-" + String(i).padStart(12, "0");
// Tabla de n filas repartidas entre k provincias (id de provincia = 1..k).
const tabla = (n, k) => Array.from({ length: n }, (_, i) => ({ id: makeId(i + 1), province_id: (i % k) + 1 }));

// Cliente simulado con soporte de eq. opts: { maxRows, failGroup, latency }.
function fuente(filas, opts = {}) {
  const estado = { activas: 0, maxActivas: 0, peticiones: 0 };
  const buildQuery = (selectOpts) => {
    const q = { order: null, gt: null, limit: null, eq: null, wantCount: Boolean(selectOpts && selectOpts.count === "exact") };
    const api = {
      order(col) { q.order = col; return api; },
      gt(col, v) { q.gt = { col, v }; return api; },
      eq(col, v) { q.eq = { col, v }; return api; },
      limit(n) { q.limit = n; return api; },
      then(resolve, reject) {
        estado.peticiones++; estado.activas++; estado.maxActivas = Math.max(estado.maxActivas, estado.activas);
        return new Promise((r) => setTimeout(r, opts.latency ?? 2)).then(() => {
          estado.activas--;
          if (opts.failGroup !== undefined && q.eq && q.eq.v === opts.failGroup) return { data: null, error: { message: "fallo simulado" } };
          let out = filas.slice().sort((a, b) => (a[q.order] < b[q.order] ? -1 : a[q.order] > b[q.order] ? 1 : 0));
          if (q.eq) out = out.filter((r) => r[q.eq.col] === q.eq.v);
          const total = out.length;
          if (q.gt) out = out.filter((r) => r[q.gt.col] > q.gt.v);
          out = out.slice(0, Math.min(q.limit ?? Infinity, opts.maxRows ?? Infinity));
          return { data: out, error: null, count: q.wantCount ? total : null };
        }).then(resolve, reject);
      }
    };
    return api;
  };
  return { buildQuery, estado };
}
const sinDuplicados = (rows) => new Set(rows.map((r) => r.id)).size === rows.length;

// 1. Devuelve todas las filas de todos los grupos, sin duplicados, aunque el servidor recorte a 1.000 por petición.
{
  const filas = tabla(5200, 8), f = fuente(filas, { maxRows: 1000 });
  const out = await fetchAllRowsPorGrupos(f.buildQuery, "id", "province_id", [1, 2, 3, 4, 5, 6, 7, 8]);
  assert.equal(out.length, 5200, "Deben llegar las 5.200 filas");
  assert.ok(sinDuplicados(out), "Sin duplicados");
  assert.deepEqual(new Set(out.map((r) => r.id)), new Set(filas.map((r) => r.id)), "Mismo conjunto de filas");
}

// 2. Un grupo grande con más de 1.000 filas se pagina por dentro (como la lectura en serie).
{
  const f = fuente(tabla(3500, 1), { maxRows: 1000 });
  const out = await fetchAllRowsPorGrupos(f.buildQuery, "id", "province_id", [1]);
  assert.equal(out.length, 3500, "Un grupo de 3.500 filas se lee entero");
}

// 3. Nunca hay más peticiones a la vez que el límite, y sí hay paralelismo.
{
  const f = fuente(tabla(2000, 20), { latency: 5 });
  await fetchAllRowsPorGrupos(f.buildQuery, "id", "province_id", Array.from({ length: 20 }, (_, i) => i + 1), 4);
  assert.ok(f.estado.maxActivas <= 4, "Como mucho 4 peticiones a la vez, hubo " + f.estado.maxActivas);
  assert.ok(f.estado.maxActivas > 1, "Y sí hay paralelismo");
}

// 4. Si un grupo falla, la lectura entera falla (nunca devuelve un conjunto parcial) y deja de pedir grupos nuevos.
{
  const f = fuente(tabla(3000, 30), { failGroup: 3, latency: 3 });
  await assert.rejects(() => fetchAllRowsPorGrupos(f.buildQuery, "id", "province_id", Array.from({ length: 30 }, (_, i) => i + 1), 2), (e) => e && e.message === "fallo simulado");
  assert.ok(f.estado.peticiones < 60, "Tras el fallo no se piden todos los grupos (" + f.estado.peticiones + ")");
}

// 5. Los grupos repetidos o vacíos no duplican ni rompen.
{
  const f = fuente(tabla(600, 2));
  const out = await fetchAllRowsPorGrupos(f.buildQuery, "id", "province_id", [1, 1, null, "", 2]);
  assert.equal(out.length, 600);
  assert.ok(sinDuplicados(out));
}

// 6. Un grupo sin filas devuelve una lista vacía, no un error.
{
  const f = fuente(tabla(10, 1));
  const out = await fetchAllRowsPorGrupos(f.buildQuery, "id", "province_id", [1, 99]);
  assert.equal(out.length, 10);
}

// 7. El cargador de index.html: lectura rápida con total comprobado, orden por id y respaldo en serie.
const iniC = html.indexOf("const consultaCatalogo = (opts) =>");
const finC = html.indexOf("const seenIds = new Set();", iniC);
assert.ok(iniC >= 0 && finC > iniC, "No se encontró el cargador del catálogo");
const cargador = html.slice(iniC, finC);
assert.ok(/Promise\.all\(\[consultaCatalogo\(\{ count: "exact", head: true \}\), fetchAllRowsPorGrupos\(consultaCatalogo, "id", "province_id", grupos\)\]\)/.test(cargador), "El recuento y los datos se piden a la vez");
assert.ok(/data\.length !== cuenta\.count\) throw/.test(cargador), "El resultado solo vale si coincide con el recuento");
assert.ok(/data\.sort\(\(a, b\) => \(a\.id < b\.id \? -1 : a\.id > b\.id \? 1 : 0\)\)/.test(cargador), "Se conserva el orden por id de la lectura en serie");
assert.ok(/catch \(e\) \{\s*data = await fetchAllRows\(consultaCatalogo, "id"\);/.test(cargador), "Ante cualquier fallo se vuelve a la lectura en serie");
assert.ok(/if \(!isAdmin\) query = query\.in\("province_id", provinceIds\);/.test(cargador), "Un usuario sigue limitado a sus provincias");
assert.ok(/fetchAllRows\(\(opts\) => client\.from\("provinces"\)\.select\("id", opts\), "id"\)/.test(cargador), "El administrador lista las provincias");

console.log("test-carga-paralela: OK (completitud, límite de paralelismo, fallo, grupos raros y respaldo en serie)");

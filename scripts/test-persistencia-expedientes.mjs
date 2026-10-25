// Persistencia de expedientes: ejecuta de verdad `ejecutaOpsRel` (index.html) contra un cliente de Supabase simulado y comprueba
// qué pasa cuando una acción de varias operaciones falla a medias, cuando hay un duplicado (23505), un conflicto de versión,
// una excepción de red o un reintento. No toca ninguna base de datos.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("const conVersion = ");
const b = html.indexOf("// Estado propio del punto en establishment_app_state");
assert.ok(a >= 0 && b > a, "No se encuentra ejecutaOpsRel en index.html");
const r0 = html.indexOf("const fmtD "), r1 = html.indexOf("/* === fin de la capa relacional === */");
const codigo = html.slice(r0, r1) + "\n" + html.slice(a, b);

let n = 0;
const ok = (cond, msg) => { assert.ok(cond, msg); n++; };
const eq = (x, y, msg) => { assert.deepStrictEqual(JSON.parse(JSON.stringify(x)), JSON.parse(JSON.stringify(y)), msg); n++; };

/* Cliente simulado: cada operación consulta «plan(i, tabla, tipo)» para saber qué responde; guarda las llamadas realizadas. */
const cliente = (plan) => {
  const llamadas = [];
  const cadena = (tabla, tipo) => {
    const p = new Proxy({}, { get: (_, prop) => prop === "abortSignal"
      ? () => { const i = llamadas.length; llamadas.push([tipo, tabla]); const r = plan(i, tabla, tipo); if (r instanceof Error) return Promise.reject(r); return Promise.resolve(r); }
      : () => p });
    return p;
  };
  return { llamadas, from: (tabla) => ({ insert: () => cadena(tabla, "insert"), update: () => cadena(tabla, "update"), delete: () => cadena(tabla, "delete") }),
    rpc: (f) => cadena(f, "rpc") };
};
const sandbox = { Date, self: {}, AbortController, setTimeout: () => 0, console: { error: () => {}, log: () => {} } };
const ejecuta = runInNewContext("const permits = {}; const permitKey = (c) => c.id; const permOf = (c) => permits[permitKey(c)] || {};\n" + codigo + "\n(ejecutaOpsRel)", sandbox);
const pto = { databaseId: "est-1" };
const OK = { error: null, data: [{ id: "x" }], status: 200 };
const run = async (ops, plan) => { const cl = cliente(plan), est = {}; const res = await ejecuta(cl, "u-1", pto, ops, est); return { res, est, llamadas: cl.llamadas }; };

const sol = (id) => ({ id, ong: "A", captadores: 2, desde: "2026-11-01", hasta: "2026-11-05", fecha: "2026-10-25" });
const OPS = [{ t: "insApp", x: sol("s1") }, { t: "insGrant", h: { id: "g1", ong: "A", captadores: 1, desde: "2026-11-01", hasta: "2026-11-05" } }, { t: "fuSet", app: "s1", fu: "", due: "2026-10-30", resp: "", accion: "" }];

// Todo bien: todas las operaciones llegan y se cuentan.
{ const r = await run(OPS, () => OK); eq([r.res, r.est.hechas, r.est.total, r.llamadas.length], ["ok", 3, 3, 3], "tres operaciones, tres aplicadas"); }

// Fallo en la segunda operación: la primera ya se aplicó y se sabe (escritura parcial identificada); la tercera ni se intenta.
{ const r = await run(OPS, (i) => i === 1 ? { error: { code: "500", message: "caída" }, status: 500 } : OK); eq([r.res, r.est.hechas, r.est.total, r.llamadas.length], ["error", 1, 3, 2], "error en la segunda: una aplicada, la tercera no se intenta"); }

// Fallo en la primera: nada aplicado.
{ const r = await run(OPS, (i) => i === 0 ? { error: { code: "500" }, status: 500 } : OK); eq([r.res, r.est.hechas], ["error", 0], "error en la primera: nada aplicado"); }

// Excepción de red (fetch lanza): se traduce en «error», sin propagarse, y el contador queda informado.
{ const r = await run(OPS, (i) => i === 1 ? new TypeError("Failed to fetch") : OK); eq([r.res, r.est.hechas, r.est.total], ["error", 1, 3], "una excepción de red no se propaga y deja el recuento"); }

// Conflicto de versión (0 filas al actualizar con control de versión): «conflict», con lo ya aplicado contado.
{ const ops = [{ t: "insApp", x: sol("s1") }, { t: "updApp", id: "s2", ver: "v1", x: sol("s2") }];
  const r = await run(ops, (i, t, tipo) => tipo === "update" ? { error: null, data: [], status: 200 } : OK); eq([r.res, r.est.hechas], ["conflict", 1], "otra persona cambió el registro: conflicto tras una operación aplicada"); }

// PT409 de las funciones atómicas (aprobar, denegar, cancelar) se traduce en conflicto.
for (const op of [{ t: "approve", id: "s1", ver: "v", g: {} }, { t: "resolve", id: "s1", st: "denied", ver: "v" }, { t: "cancel", id: "g1", ver: "v" }]) {
  const r = await run([op], () => ({ error: { code: "PT409", message: "cambiado" }, status: 409 })); eq([r.res, r.est.hechas], ["conflict", 0], op.t + " con PT409 es un conflicto");
}

// Duplicado 23505 en un alta: se acepta como reintento, pero queda constancia en el recuento y verificaOps decide si es válido al releer.
{ const r = await run([{ t: "insApp", x: sol("s1") }, { t: "insGrant", h: { id: "g1", ong: "A", captadores: 1 } }], (i, t, tipo) => ({ error: { code: "23505" }, status: 409 })); eq([r.res, r.est.hechas], ["ok", 2], "un reintento duplicado (23505) se acepta y se cuenta"); }
// …pero otros 409 que no son PT409 ni duplicados siguen siendo conflicto, y otros errores, error.
{ const r = await run([{ t: "insApp", x: sol("s1") }], () => ({ error: { code: "23514", message: "ya resuelta" }, status: 400 })); eq(r.res, "error", "una regla de la base (23514) es un error, no un éxito"); }

// Reintento idempotente de borrado/cierre: ya cerrado o ya borrado no cuenta como éxito silencioso (0 filas).
{ const r = await run([{ t: "fuDone", fu: "f1", ver: "v" }], () => ({ error: null, data: [], status: 200 })); eq(r.res, "conflict", "cerrar un seguimiento ya cerrado o cambiado es un conflicto (se relee)"); }
{ const r = await run([{ t: "delApp", id: "s1" }], () => ({ error: null, data: [], status: 200 })); eq(r.res, "error", "borrar sin permiso (0 filas) es un error"); }

// El recuento se informa siempre (finally), incluso sin operaciones que ejecutar.
{ const r = await run([], () => OK); eq([r.res, r.est.hechas, r.est.total], ["ok", 0, 0], "sin operaciones: ok y recuento a cero"); }

// Doble envío: dos ejecuciones concurrentes de las mismas operaciones no se mezclan ni rompen el contador de cada una.
{ const [x, y] = await Promise.all([run(OPS, () => OK), run(OPS, (i) => i === 0 ? { error: { code: "500" }, status: 500 } : OK)]); eq([x.res, x.est.hechas, y.res, y.est.hechas], ["ok", 3, "error", 0], "dos ejecuciones simultáneas llevan cuentas independientes"); }

console.log("Persistencia de expedientes: " + n + " comprobaciones correctas.");

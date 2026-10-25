// Regresión de la sección «Centro de permisos» (menú → Centro de permisos): comprobaciones estáticas y coherencia de sus filtros con el Panel resumen.
// El comportamiento real se prueba en el navegador con scripts/dev/mock-supabase.mjs.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("/* Centro de permisos (v1, solo lectura)");
assert.ok(a >= 0, "No se encuentra el bloque del Centro de permisos en index.html");
const fin = html.indexOf("\n})();\n", a);
const bloque = html.slice(a, fin + 7);
let n = 0;
const ok = (cond, msg) => { assert.ok(cond, msg); n++; };

// Estructura accesible y entrada de menú.
ok(/<dialog id="dlgCentro" aria-labelledby="ceT">/.test(html), "dlgCentro sin aria-labelledby");
ok(/<h2 id="ceT">Centro de permisos<\/h2>/.test(html), "Falta el título del diálogo");
ok(/id="centroBtn" type="button" role="menuitem">Centro de permisos<\/button>/.test(html), "Falta la opción «Centro de permisos» en el menú");
ok(html.includes('id="ceClose" aria-label="Cerrar"'), "El botón de cerrar necesita nombre accesible");
ok(bloque.includes('aria-pressed="true">Solicitudes') && bloque.includes('data-vista="con"'), "Hay pestañas de solicitudes y concesiones con aria-pressed");
ok(bloque.includes('role="status"') && bloque.includes('<caption class="adm-sr">'), "Recuento en role=status y tabla con título");
ok(bloque.includes("badge(r.est)") && bloque.includes("esc(TEXTO[e])"), "El estado va también en texto, no solo en color");

// Solo lee lo que hay en memoria; no guarda nada ni consulta la red.
ok(!/localStorage|sessionStorage|indexedDB|document\.cookie|caches\.|fetch\(|\.from\(|\.rpc\(|supabase|savePermits|ejecutaOpsRel/.test(bloque), "El Centro (v1) no puede guardar ni llamar a la red");

// Los textos que vienen de los datos pasan por esc().
for (const t of ["esc(r.c.name)", "esc(ongDe(r))", "esc(periodo(r))", "esc(detalleCon(r, t))", "esc(String(r.c.id))", "esc(q)", "esc(n + \" (\""]) ok(bloque.includes(t), "Falta escapar con esc(): " + t);

// Ámbito y reglas compartidas.
ok(bloque.includes("isOut(c) ||") && bloque.includes("c.provinceId !== provId"), "Respeta puntos quitados/archivados y la provincia");
ok(bloque.includes("expedientesDe(c, p)") && bloque.includes("indicadores("), "Usa las reglas compartidas de expedientes");
ok(bloque.includes("TRAMO") && bloque.includes("data-mas"), "Dibuja por tramos");

// Coherencia: cada filtro del Centro cuenta lo mismo que la cifra equivalente del Panel resumen (indicadores).
const i0 = html.indexOf("const fmtD = "), i1 = html.indexOf("/* === Reglas de expedientes"), i2 = html.indexOf("/* === fin de la capa relacional === */");
const p0 = bloque.indexOf("const pred = {"), p1 = bloque.indexOf("\n  };\n", p0) + 6;
ok(i0 >= 0 && i1 > i0 && i2 > i1 && p0 >= 0 && p1 > p0, "No se encuentran las reglas o los filtros");
const Real = Date;
class Falsa extends Real { constructor(...args) { if (args.length) super(...args); else super("2026-10-25T10:00:00Z"); } static now() { return new Real("2026-10-25T10:00:00Z").getTime(); } }
const ctx = runInNewContext(
  "const permits = {}; const permitKey = (c) => c.id; const permOf = (c) => permits[permitKey(c)] || {};\n" + html.slice(i0, i2) + "\n" + bloque.slice(p0, p1) + "\n({ today, expedientesDe, indicadores, pred })",
  { Date: Falsa, self: {} }
);
const t = ctx.today();
const punto = (id) => ({ id, name: "P" + id });
const p = (extra) => Object.assign({ solicitudes: [], historial: [] }, extra);
const recs = [
  ...ctx.expedientesDe(punto(1), p({ solicitudes: [
    { id: "s1", desde: "2026-11-01", hasta: "2026-11-10", ong: "A", captadores: 2, fecha: "2026-10-01" },   /* pendiente y estancada */
    { id: "s2", desde: "2026-11-01", hasta: "2026-11-10", ong: "A", captadores: 2, fecha: "2026-10-20" },   /* pendiente */
    { id: "s3", desde: "2026-09-01", hasta: "2026-09-10", ong: "B", captadores: 1, fecha: "2026-08-01" },   /* caducada */
    { id: "s4", desde: "2026-11-01", hasta: "2026-11-10", ong: "B", captadores: 1, fecha: "2026-10-02", res: "aprobada", resFecha: "2026-10-03" },
    { id: "s5", desde: "2026-11-01", hasta: "2026-11-10", ong: "B", captadores: 1, fecha: "2026-10-02", res: "denegada", resFecha: "2026-10-03" }
  ], historial: [
    { id: "g1", desde: "2026-10-01", hasta: "2026-10-30", ong: "A", captadores: 2 },   /* vigente, vence en 5 días */
    { id: "g2", desde: "2026-10-01", hasta: "2026-11-24", ong: "A", captadores: 2 },   /* vigente, vence en 30 días */
    { id: "g3", desde: "2026-10-01", hasta: "2026-11-25", ong: "A", captadores: 2 },   /* vigente, fuera de 30 días */
    { id: "g4", desde: "2026-10-01", ong: "A", captadores: 2 },                         /* vigente sin fin */
    { id: "g5", desde: "2026-12-01", hasta: "2026-12-31", ong: "A", captadores: 2 },   /* futura */
    { id: "g6", desde: "2026-08-01", hasta: "2026-08-31", ong: "A", captadores: 2 },   /* terminada */
    { id: "g7", desde: "2026-10-01", hasta: "2026-10-30", ong: "A", captadores: 2, cancelada: true, resFecha: "2026-10-10" }
  ] }))
];
const ind = ctx.indicadores(recs, [], t), cuenta = (v, e) => recs.filter((r) => r.k === v && ctx.pred[v](e, r, t)).length;
const venc = ind.vencen7.length + ind.vencen15.length + ind.vencen30.length;
ok(cuenta("sol", "pendiente") === ind.pendientes.length && ind.pendientes.length === 2, "Pendientes coinciden con el Panel (2)");
ok(cuenta("sol", "estancada") === ind.estancadas.length && ind.estancadas.length === 1, "Estancadas coinciden con el Panel (1)");
ok(cuenta("sol", "caducada") === ind.sinRespuesta.length && ind.sinRespuesta.length === 1, "Caducadas coinciden con el Panel (1)");
ok(cuenta("sol", "aprobada") === 1 && cuenta("sol", "denegada") === 1 && cuenta("sol", "retirada") === 0 && cuenta("sol", "todas") === 5, "Aprobadas, denegadas y total");
ok(cuenta("con", "vigente") === ind.vigentes.length && ind.vigentes.length === 4, "Vigentes coinciden con el Panel (4)");
ok(cuenta("con", "vencen") === venc && venc === 2, "Vencen en 30 días coinciden con el Panel (2: 5 y 30 días; el de 31 días no)");
ok(cuenta("con", "sinfin") === ind.sinFin.length && ind.sinFin.length === 1, "Sin fecha de fin coinciden con el Panel (1)");
ok(cuenta("con", "futura") === 1 && cuenta("con", "terminada") === 1 && cuenta("con", "cancelada") === 1 && cuenta("con", "todas") === 7, "Futuras, terminadas, canceladas y total");
ok(ind.vigentes.every((r) => r.k === "con") && recs.length === 12, "Se separan solicitudes (5) y concesiones (7)");

console.log("Centro de permisos: " + n + " comprobaciones correctas.");

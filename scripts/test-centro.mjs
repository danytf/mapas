// Regresión de la sección «Centro de permisos» (menú → Centro de permisos): comprobaciones estáticas y coherencia de sus filtros con el Panel resumen.
// El comportamiento real se prueba en el navegador con scripts/dev/mock-supabase.mjs.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("/* Centro de permisos: bandejas");
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
ok(bloque.includes('aria-pressed="true">Solicitudes') && ["con", "seg", "inc"].every((v) => bloque.includes('data-vista="' + v + '"')), "Hay pestañas de solicitudes, concesiones, seguimientos y avisos con aria-pressed");
ok(bloque.includes('role="status"') && bloque.includes('<caption class="adm-sr">'), "Recuento en role=status y tabla con título");
ok(bloque.includes("badge(r.est)") && bloque.includes("esc(TEXTO[e])"), "El estado va también en texto, no solo en color");

// No toca la red ni el navegador; lo único que guarda es «Hecho» en un seguimiento, por guardaPunto (guardado verificable con control de conflictos).
ok(!/localStorage|sessionStorage|indexedDB|document\.cookie|caches\.|fetch\(|\.from\(|\.rpc\(|supabase|ejecutaOpsRel|guardaPunto/.test(bloque), "El Centro no puede llamar a la red ni escribir fuera de aplica()");
ok((bloque.match(/savePermits\(/g) || []).length === 1 && /const aplica = async[\s\S]*?await savePermits\(c\)/.test(bloque), "Hay una sola escritura: aplica() guarda con savePermits");
ok(/if \(r === "conflict"\) \{ await reloadSharedPermit\(c\); return "conflict"; \}/.test(bloque) && bloque.includes("gamPermit(c, previo)"), "aplica() recarga tras un conflicto y registra el progreso solo si se confirma");
ok(bloque.includes("if (s.punto) delete copia.segPunto") && bloque.includes('x.seg = ""'), "«Hecho» cierra solo el seguimiento elegido, no todos los del punto");
ok(bloque.includes("No se pudo confirmar el guardado") && bloque.includes("Otra persona ha cambiado"), "Los errores y conflictos no se presentan como guardados");

// Los textos que vienen de los datos pasan por esc().
for (const t of ["esc(x.c.name)", "esc(ongDe(r))", "esc(ongDe(s))", "esc(periodo(r))", "esc(detalleCon(r, t))", "esc(String(x.c.id))", "esc(q)", "esc(n + \" (\"", "esc(s.accion)", "esc(nombreResp(s.resp))", "esc(x.tipo)"]) ok(bloque.includes(t), "Falta escapar con esc(): " + t);

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
  "const permits = {}; const permitKey = (c) => c.id; const permOf = (c) => permits[permitKey(c)] || {};\n" + html.slice(i0, i2) + "\n" + bloque.slice(p0, p1) + "\n({ today, addDays, expedientesDe, seguimientosDe, indicadores, incidencias, pred })",
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

// Seguimientos: cada filtro cuenta lo mismo que el Panel resumen.
const pt2 = punto(2), p2 = p({ solicitudes: [
  { id: "q1", desde: "2026-11-01", hasta: "2026-11-10", ong: "A", captadores: 1, fecha: "2026-10-20", seg: "2026-10-20" },                       /* atrasado, sin responsable */
  { id: "q2", desde: "2026-11-01", hasta: "2026-11-10", ong: "A", captadores: 1, fecha: "2026-10-20", seg: t, resp: "u1" },                     /* hoy */
  { id: "q3", desde: "2026-11-01", hasta: "2026-11-10", ong: "B", captadores: 1, fecha: "2026-10-20", seg: ctx.addDays(t, 7), resp: "u1" },    /* en 7 días */
  { id: "q4", desde: "2026-11-01", hasta: "2026-11-10", ong: "B", captadores: 1, fecha: "2026-10-20", seg: ctx.addDays(t, 8), resp: "u1" },    /* fuera de 7 días */
  { id: "q5", desde: "2026-11-01", hasta: "2026-11-10", ong: "B", captadores: 1, fecha: "2026-10-20", res: "denegada", seg: "2026-10-01" }      /* resuelta: no cuenta */
] });
const segs = ctx.seguimientosDe(pt2, p2), recs2 = ctx.expedientesDe(pt2, p2), ind2 = ctx.indicadores(recs2, segs, t), cs = (e) => segs.filter((x) => ctx.pred.seg(e, x, t)).length;
ok(segs.length === 4, "Solo cuentan los seguimientos de solicitudes pendientes (4)");
ok(cs("vencido") === ind2.segVencidos.length && cs("vencido") === 1, "Atrasados coinciden con el Panel (1)");
ok(cs("hoy") === ind2.segHoy.length && cs("hoy") === 1, "Para hoy coinciden con el Panel (1)");
ok(cs("proximo") === ind2.segProximos.length && cs("proximo") === 1, "Próximos 7 días coinciden con el Panel (1: el de 7 días sí, el de 8 no)");
ok(cs("sinresp") === 1 && cs("todas") === 4, "Sin responsable y total");
// Avisos: la bandeja usa la misma lista de incidencias que el Panel.
ok(bloque.includes("incidencias(todas.filter(okOng), t)") && ind2.incidencias.length === ctx.incidencias(recs2, t).length, "Los avisos salen de incidencias()");

// Cambios de «aplica()»: cada mutador se prueba sobre una copia del estado del punto.
const m0 = bloque.indexOf("  const ubica = "), m1 = bloque.indexOf("\n  };\n", bloque.indexOf("const mutadores = {")) + 6;
ok(m0 >= 0 && m1 > m0, "No se encuentran los mutadores");
const M = runInNewContext(
  "const permits = {}; const permitKey = (c) => c.id; const permOf = (c) => permits[permitKey(c)] || {};\n" + html.slice(i0, i2) + "\n" + bloque.slice(m0, m1) + "\n({ mutadores, ubica, today })",
  { Date: Falsa, self: { crypto: { randomUUID: (() => { let n = 0; return () => "id-" + (++n); })() } } }
);
const nuevo = () => ({ solicitudes: [{ id: "s1", desde: "2026-11-01", hasta: "2026-11-10", captadores: 2, ong: "A", fecha: "2026-10-20", seg: "2026-10-30", contacto: "Ana", notas: "n" }, { id: "s2", res: "denegada", resFecha: "2026-10-21", fecha: "2026-10-20" }], historial: [{ id: "g1", desde: "2026-10-01", hasta: "2026-12-01", ong: "A", captadores: 3 }] });
let cp = nuevo();
ok(M.mutadores.conceder({ id: "s1" })(cp) === undefined && cp.solicitudes[0].res === "aprobada" && cp.historial.length === 2, "Conceder aprueba la solicitud y crea la concesión");
const g = cp.historial[1];
ok(g.sol === "s1" && g.desde === "2026-11-01" && g.hasta === "2026-11-10" && g.captadores === 2 && g.ong === "A" && g.contacto === "Ana" && g.notas === "n" && cp.solicitudes[0].conc === g.id, "La concesión nace con los datos de la solicitud y queda enlazada");
ok(typeof M.mutadores.conceder({ id: "s1" })(cp) === "string", "Conceder una solicitud ya resuelta se aborta sin cambios (doble clic)");
ok(typeof M.mutadores.conceder({ id: "s2" })(nuevo()) === "string" && typeof M.mutadores.conceder({ id: "nada" })(nuevo()) === "string", "Conceder una denegada o inexistente se aborta");
cp = nuevo(); M.mutadores.resolver({ id: "s1" }, "retirada", "La ONG desiste")(cp);
ok(cp.solicitudes[0].res === "retirada" && cp.solicitudes[0].motivo === "La ONG desiste" && cp.solicitudes[0].resFecha === t && cp.historial.length === 1, "Retirar guarda motivo y fecha y no crea concesión");
cp = nuevo(); M.mutadores.cancelar({ id: "g1" }, "Se acaba")(cp);
ok(cp.historial[0].cancelada === true && cp.historial[0].resFecha === t && cp.historial[0].motivo === "Se acaba", "Cancelar marca la concesión con fecha y motivo");
M.mutadores.reactivar({ id: "g1" })(cp);
ok(!cp.historial[0].cancelada && !cp.historial[0].resFecha, "Reactivar quita la cancelación");
cp = nuevo(); M.mutadores.quitarSol({ id: "s2" })(cp); M.mutadores.quitarCon({ id: "g1" })(cp);
ok(cp.solicitudes.length === 1 && cp.historial.length === 0, "Quitar borra solo el registro elegido");
cp = nuevo(); M.mutadores.cerrarSeg({ i: 0, punto: false })(cp);
ok(cp.solicitudes[0].seg === "" && cp.solicitudes[1].seg === undefined, "«Hecho» cierra solo el seguimiento de esa solicitud");
cp = { segPunto: { fecha: "2026-10-30", fu: "f1" }, solicitudes: [], historial: [] }; M.mutadores.cerrarSeg({ punto: true, i: -1 })(cp);
ok(!cp.segPunto, "«Hecho» cierra el seguimiento del punto");

// Buscador de punto del formulario: sin tildes, por palabras sueltas, con el nombre que empieza igual primero.
const b0 = bloque.indexOf("  const indiceBusqueda = "), b1 = bloque.indexOf("  const buscaPunto = ");
ok(b0 >= 0 && b1 > b0, "No se encuentra el buscador de punto");
const S = runInNewContext(
  "const sinAcentos = (t) => String(t || '').normalize('NFD').replace(/[\\u0300-\\u036f]/g, '').toLowerCase().trim();\nconst townOf = (c) => c.town || c.province || 'Sin municipio';\nconst antes = (a, b) => a.localeCompare(b, 'es');\n" + bloque.slice(b0, b1) + "\n({ encuentra })",
  {}
);
const C = [
  { id: 1, name: "Mercadona", town: "Almería", province: "Almería", street: "Calle Real 4", tipo: "Supermercado" },
  { id: 2, name: "Hospital Mercedes", town: "Granada", province: "Granada", street: "Av. de la Constitución 2", tipo: "Hospital" },
  { id: 3, name: "Super Mercadona Norte", town: "Roquetas de Mar", province: "Almería", street: "Camino Viejo", tipo: "Supermercado" },
  { id: 4, name: "CS Armilla", town: "Armilla", province: "Granada", street: "Calle Mayor", tipo: "Centro de salud" }
];
const nombres = (txt) => S.encuentra(txt, C).map((c) => c.name);
ok(nombres("almeria").join() === "Mercadona,Super Mercadona Norte", "Ignora tildes y busca también en el municipio y la provincia");
ok(nombres("mercadona")[0] === "Mercadona" && nombres("mercadona").length === 2, "El nombre que empieza por lo escrito va primero");
ok(nombres("merca roquetas").join() === "Super Mercadona Norte", "Varias palabras: todas deben aparecer, en nombre o lugar");
ok(nombres("constitucion").join() === "Hospital Mercedes", "También busca en la calle");
ok(nombres("a").length === 0 && nombres("   ").length === 0 && nombres("zzz").length === 0, "Menos de dos letras o sin coincidencias, nada");
ok(bloque.includes("MAX_RESULTADOS") && bloque.includes("escribe más para afinar"), "Avisa cuando hay más resultados de los que se muestran");

console.log("Centro de permisos: " + n + " comprobaciones correctas.");

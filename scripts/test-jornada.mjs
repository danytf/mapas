// Regresión de «Mi jornada» (la bandeja de trabajo del Centro de permisos): clasificación, orden, fechas de Madrid, una fila por expediente, filtros y recuentos,
// coherencia con el Panel, el Centro y el Calendario, actualización tras una tarea, ámbito por provincia, estados de la pantalla y rendimiento.
// Las reglas (jornada, jornadaCumple, jornadaConteos) se ejecutan tal como están en index.html, con un reloj falso. El comportamiento en el navegador lo cubre scripts/e2e-centro.mjs.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("const fmtD = "), b = html.indexOf("/* === Reglas de expedientes"), c = html.indexOf("/* === fin de la capa relacional === */");
assert.ok(a >= 0 && b > a && c > b, "No se encuentra el bloque de reglas de expedientes en index.html");
const reglasCodigo = html.slice(a, c);
const a1 = html.indexOf("/* Centro de permisos: centro de mando"), a2 = html.indexOf("\n})();\n", a1);
assert.ok(a1 >= 0 && a2 > a1, "No se encuentra el bloque del Centro de permisos");
const bloque = html.slice(a1, a2 + 7);
const trozo = (desde, hasta) => { const i = bloque.indexOf(desde), j = bloque.indexOf(hasta, i); assert.ok(i >= 0 && j > i, "No se encuentra: " + desde); return bloque.slice(i, j); };

let n = 0;
const ok = (cond, msg) => { assert.ok(cond, msg); n++; };
const norm = (v) => (v === undefined ? "__undefined__" : JSON.parse(JSON.stringify(v)));
const eq = (x, y, msg) => { assert.deepStrictEqual(norm(x), norm(y), msg); n++; };

/* Reglas con reloj falso (la fecha de hoy sale de new Date()). */
const Real = Date;
const reglas = (ahoraIso) => {
  class Falsa extends Real { constructor(...args) { if (args.length) super(...args); else super(ahoraIso); } static now() { return new Real(ahoraIso).getTime(); } }
  return runInNewContext(
    "const permits = {}; const permitKey = (c) => c.id; const permOf = (c) => permits[permitKey(c)] || {};\n" + reglasCodigo +
    "\n({ today, addDays, daysBetween, mondayOf, expedientesDe, seguimientosDe, incidencias, indicadores, calendarioSemana, resumenDatos, jornada, jornadaCumple, jornadaConteos, JOR_MOTIVOS, JOR_TIPOS, JOR_RAPIDAS, JOR_DIAS, UMBRAL_ESTANCADA })",
    { Date: Falsa, self: {} }
  );
};
const punto = (id, name, prov = "Granada", provinceId = "pr-gr") => ({ id, name, town: "Pueblo", province: prov, provinceId, databaseId: "db-" + id });
const sol = (o) => Object.assign({ desde: "2026-12-10", hasta: "2026-12-12", ong: "AECC", captadores: 2 }, o);
const con = (o) => Object.assign({ desde: "2026-10-01", hasta: "2027-03-01", ong: "AECC", captadores: 2 }, o);
const entra = (R, puntos) => {
  const recs = [], segs = [];
  puntos.forEach(([c, p]) => { R.expedientesDe(c, p).forEach((r) => recs.push(r)); R.seguimientosDe(c, p).forEach((s) => segs.push(s)); });
  return { recs, segs, t: R.today() };
};
const jornadaDe = (R, puntos) => { const { recs, segs, t } = entra(R, puntos); return R.jornada(recs, segs, t, R.incidencias(recs, t)); };
const nombres = (J) => J.map((f) => f.c.name);

/* ===== 1. Clasificación y orden de cada tipo de actuación (hoy = 26/10/2026 en Madrid) ===== */
{
  const R = reglas("2026-10-26T10:00:00Z"), T = R.today();
  eq(T, "2026-10-26", "hoy en Madrid");
  const d = (k) => R.addDays(T, k);
  /* El nombre empieza por la posición esperada: el orden de la bandeja debe coincidir con el orden alfabético de los nombres. */
  const P = [
    ["01 atrasada 4 días", { solicitudes: [sol({ id: "a", fecha: d(-6), seg: d(-4) })] }],
    ["02 atrasada 3 días y varios motivos", { solicitudes: [sol({ id: "a", desde: d(-1), hasta: d(5), ong: "", fecha: d(-20), seg: d(-3), resp: "u1", accion: "Llamar" })] }],
    ["03 atrasada 2 días (concesión)", { historial: [con({ id: "g", seg: d(-2), resp: "u2" })] }],
    ["04 atrasada 1 día (del punto)", { segPunto: { fecha: d(-1), accion: "Visitar", resp: "u1" } }],
    ["05 concesión termina hoy", { historial: [con({ id: "g", hasta: T })] }],
    ["06 concesión sin fechas (bloqueante)", { historial: [{ id: "g", ong: "WWF", captadores: 1 }] }],
    ["07 seguimiento de hoy", { solicitudes: [sol({ id: "a", fecha: d(-9), seg: T })] }],
    ["08 seguimiento de hoy más reciente", { solicitudes: [sol({ id: "a", fecha: d(-2), seg: T })] }],
    ["09 periodo empezó hace 3 días", { solicitudes: [sol({ id: "a", desde: d(-3), hasta: d(4), fecha: d(-5), seg: d(2) })] }],
    ["10 periodo empieza hoy", { solicitudes: [sol({ id: "a", desde: T, hasta: d(4), fecha: d(-5), seg: d(2) })] }],
    ["11 periodo empieza en 2 días", { solicitudes: [sol({ id: "a", desde: d(2), hasta: d(6), fecha: d(-5), seg: d(2) })] }],
    ["12 estancada 31 días", { solicitudes: [sol({ id: "a", fecha: d(-31), seg: d(3) })] }],
    ["13 estancada 16 días", { solicitudes: [sol({ id: "a", fecha: d(-16), seg: d(3) })] }],
    ["14 concesión termina en 1 día", { historial: [con({ id: "g", hasta: d(1) })] }],
    ["15 concesión termina en 7 días", { historial: [con({ id: "g", hasta: d(7) })] }],
    ["16 sin seguimiento, 9 días", { solicitudes: [sol({ id: "a", fecha: d(-9) })] }],
    ["17 sin seguimiento, 5 días", { solicitudes: [sol({ id: "a", fecha: d(-5) })] }],
    ["18 sin seguimiento, sin fecha de solicitud", { solicitudes: [sol({ id: "a" })] }],
    ["19 aviso: sin respuesta y caducada (más antigua)", { solicitudes: [sol({ id: "a", desde: d(-10), hasta: d(-1), fecha: d(-12), seg: d(5) })] }],
    ["20 aviso: solicitud sin ONG", { solicitudes: [sol({ id: "a", ong: "", fecha: d(-2), seg: d(10) })] }],
    /* No entran en la bandeja */
    ["x seguimiento de mañana", { solicitudes: [sol({ id: "a", fecha: d(-3), seg: d(1) })] }],
    ["x estancada justo en el umbral (15 días)", { solicitudes: [sol({ id: "a", fecha: d(-15), seg: d(3) })] }],
    ["x periodo empieza en 8 días", { solicitudes: [sol({ id: "a", desde: d(8), hasta: d(12), fecha: d(-3), seg: d(3) })] }],
    ["x concesión termina en 8 días", { historial: [con({ id: "g", hasta: d(8) })] }],
    ["x concesión terminó ayer", { historial: [con({ id: "g", hasta: d(-1) })] }],
    ["x concesión sin fecha de fin (solo recomendación)", { historial: [con({ id: "g", hasta: "" })] }],
    ["x solicitud denegada con seguimiento viejo", { solicitudes: [sol({ id: "a", fecha: d(-30), res: "denegada", resFecha: d(-20), seg: d(-10) })] }],
    ["x concesión cancelada con seguimiento viejo", { historial: [con({ id: "g", cancelada: true, resFecha: d(-3), seg: d(-5) })] }],
    ["x aprobada sin concesión enlazada (solo recomendación)", { solicitudes: [sol({ id: "a", fecha: d(-6), res: "aprobada", resFecha: d(-4) })] }],
    ["x solicitud resuelta con el seguimiento cerrado", { solicitudes: [sol({ id: "a", fecha: d(-3), res: "denegada", resFecha: d(-2), seg: "" })], historial: [con({ id: "g" })] }]
  ].map(([nombre, p], i) => [punto(i + 1, nombre), Object.assign({ solicitudes: [], historial: [] }, p)]);
  const J = jornadaDe(R, P);
  eq(nombres(J), P.map(([c]) => c.name).filter((x) => !x.startsWith("x ")).sort(), "orden de la bandeja = orden esperado, y solo entra lo que tiene un motivo real");
  const por = (pref) => J.find((f) => f.c.name.startsWith(pref));
  const motivo = (pref) => { const f = por(pref); return [f.principal.id, f.principal.texto, f.tipo, f.banda]; };
  eq(motivo("01"), ["atrasada", "Seguimiento atrasado 4 días", "atrasada", "urgente"], "seguimiento atrasado: días de retraso");
  eq(motivo("04"), ["atrasada", "Seguimiento atrasado 1 día", "atrasada", "urgente"], "singular: 1 día");
  eq(motivo("05"), ["terminaHoy", "La concesión termina hoy", "concesion", "urgente"], "la concesión que termina hoy es urgente");
  eq(motivo("06")[0], "bloqueante", "una concesión sin fechas es un dato bloqueante");
  ok(por("06").banda === "urgente", "…y urgente");
  eq(motivo("07"), ["hoy", "Seguimiento para hoy", "hoy", "hoy"], "seguimiento de hoy");
  eq(motivo("09"), ["inicio", "El periodo solicitado empezó hace 3 días y sigue sin respuesta", "solicitud", "atencion"], "periodo ya empezado");
  eq(motivo("10")[1], "Empieza el periodo solicitado hoy y sigue sin respuesta", "periodo que empieza hoy");
  eq(motivo("11")[1], "Empieza el periodo solicitado en 2 días y sigue sin respuesta", "periodo que empieza en 2 días");
  eq(motivo("12"), ["estancada", "Solicitud sin respuesta desde hace 31 días", "solicitud", "atencion"], "solicitud estancada");
  eq(motivo("14"), ["vence", "La concesión termina en 1 día", "concesion", "atencion"], "la concesión termina en 1 día");
  eq(motivo("15")[1], "La concesión termina en 7 días", "…en 7 días (el límite incluido)");
  eq(motivo("16"), ["sinseg", "Solicitud pendiente sin seguimiento programado", "solicitud", "atencion"], "solicitud pendiente sin seguimiento");
  eq(motivo("20")[0] + motivo("20")[2], "avisoincidencia", "un aviso de datos entra como incidencia");
  ok(por("19").principal.texto === "Solicitud sin respuesta cuyas fechas ya pasaron" && por("19").r.est === "caducada", "una solicitud caducada se señala, pero su estado no cambia (sigue «caducada», no se deniega)");
  ok(!J.some((f) => f.motivos.some((m) => m.texto.startsWith("Solicitud estancada"))), "la estancada de las incidencias no se repite: ya es un motivo propio");

  /* Una fila por expediente: los criterios de más se muestran como alertas, ordenadas por gravedad. */
  const multi = por("02");
  eq(multi.motivos.map((m) => m.id), ["atrasada", "inicio", "estancada", "aviso"], "varios criterios en un mismo expediente");
  eq(multi.extras, ["El periodo solicitado empezó hace 1 día y sigue sin respuesta", "Solicitud sin respuesta desde hace 20 días", "Solicitud sin ONG"], "las alertas adicionales van tras el motivo principal");
  ok(new Set(J.map((f) => f.clave)).size === J.length, "ningún expediente aparece dos veces");
  ok(J.filter((f) => f.c.name.startsWith("02")).length === 1, "…aunque cumpla cuatro criterios");
  ok(multi.flags.urgente && !multi.flags.sinseg && multi.resp === "u1" && multi.segDue === true && multi.seg.accion === "Llamar", "responsable y seguimiento del expediente");
  ok(por("02").siguiente === "Acción prevista: Llamar" && por("01").siguiente === "Hacer el seguimiento y marcarlo como hecho", "la siguiente acción sale de los datos; sin acción prevista, la recomendación general");

  /* El seguimiento va con su expediente exacto: solicitud, concesión o punto. */
  ok(por("01").k === "sol" && por("01").r.k === "sol" && por("01").seg.i === por("01").r.i && !por("01").seg.con, "el seguimiento de una solicitud es el de ESA solicitud");
  ok(por("03").k === "con" && por("03").r.k === "con" && por("03").seg.con === true, "el de una concesión, el de ESA concesión");
  ok(por("04").k === "punto" && por("04").r === por("04").seg && por("04").seg.punto === true, "el de un punto sin expediente es el propio seguimiento");
  ok(J.every((f) => f.c.id === f.r.c.id && (!f.seg || f.seg.c.id === f.c.id)), "cada fila apunta al punto correcto");

  /* Orden: el rango sigue el esquema documentado, y dentro de un grado manda la medida de su urgencia. */
  eq(Object.entries(R.JOR_MOTIVOS).sort((x, y) => x[1].rank - y[1].rank).map(([k]) => k), ["atrasada", "terminaHoy", "bloqueante", "hoy", "inicio", "estancada", "vence", "sinseg", "aviso"], "grados de gravedad");
  ok(J.every((f, i) => i === 0 || J[i - 1].rank <= f.rank), "nunca un motivo menos grave antes que uno más grave");
  ok(por("16").antig === 9 && por("18").antig === -1, "sin fecha de solicitud, la solicitud va al final de su grupo");

  /* Determinista: el mismo resultado con los datos en cualquier orden. */
  let semilla = 12345; const azar = () => { semilla = (semilla * 1664525 + 1013904223) % 4294967296; return semilla / 4294967296; };
  const baraja = (arr) => { const x = arr.slice(); for (let i = x.length - 1; i > 0; i--) { const j = Math.floor(azar() * (i + 1)); [x[i], x[j]] = [x[j], x[i]]; } return x; };
  const { recs, segs, t } = entra(R, P), esperado = J.map((f) => f.clave);
  for (let k = 0; k < 25; k++) eq(R.jornada(baraja(recs), baraja(segs), t, baraja(R.incidencias(recs, t))).map((f) => f.clave), esperado, "orden determinista (barajado " + k + ")");

  /* Coherencia con el Panel, el Centro y el Calendario (las mismas cifras). */
  const ind = R.indicadores(recs, segs, t), cuenta = (id) => J.filter((f) => f.motivos.some((m) => m.id === id)).length;
  ok(cuenta("atrasada") === ind.segVencidos.length && ind.segVencidos.length === 4, "seguimientos atrasados: bandeja = Panel (4)");
  ok(cuenta("hoy") === ind.segHoy.length && ind.segHoy.length === 2, "seguimientos de hoy: bandeja = Panel (2)");
  ok(cuenta("estancada") === ind.estancadas.length && ind.estancadas.length === 3, "estancadas: bandeja = Panel");
  ok(cuenta("sinseg") === ind.sinSeguimiento.length, "pendientes sin seguimiento: bandeja = Panel");
  ok(cuenta("terminaHoy") + cuenta("vence") === ind.vencen7.length && ind.vencen7.length === 3, "concesiones que terminan en 0 a 7 días: bandeja = Panel");
  const hoyCal = R.calendarioSemana(recs, segs, R.mondayOf(t), t).find((x) => x.d === t);
  ok(hoyCal.seg.length === cuenta("hoy"), "los seguimientos de hoy de la bandeja son los del día de hoy en el Calendario");
  ok(hoyCal.items.filter((i) => i.r.k === "con" && i.r.hasta === t).length === cuenta("terminaHoy"), "las concesiones que terminan hoy son las que el Calendario pinta en su último día");
  const incs = R.incidencias(recs, t), bloq = new Set(incs.filter((x) => x.sev === "bloqueante").map((x) => x.r.c.id + "|" + x.r.k + "|" + x.r.i));
  ok(J.filter((f) => f.motivos.some((m) => m.id === "bloqueante")).length === bloq.size, "datos bloqueantes: bandeja = Avisos de datos");
  const avisos = new Set(incs.filter((x) => x.sev === "aviso" && x.cod !== "estancada" && x.cod !== "inicio").map((x) => x.r.c.id + "|" + x.r.k + "|" + x.r.i));
  ok(J.filter((f) => f.motivos.some((m) => m.id === "aviso")).length === avisos.size, "avisos: bandeja = Avisos de datos (salvo estancada y periodo empezado, que son motivos propios)");
  ok(!incs.some((x) => x.sev === "recomendacion" && J.some((f) => f.r === x.r && f.principal.id === "aviso" && f.principal.texto === x.tipo)), "las recomendaciones se quedan en «Avisos de datos»");
  const rd = R.resumenDatos(recs, segs, t, incs);
  eq(rd.cola.map((x) => x.titulo), J.map((f) => f.principal.texto), "la cola del Resumen es la misma lista, en el mismo orden");
  eq(rd.cola.map((x) => x.c.id), J.map((f) => f.c.id), "…con los mismos puntos");
  ok(rd.cola.every((x) => ["seg", "sol", "con", "inc"].includes(x.vista) && x.est), "…y cada una abre su sección del Centro");
}

/* ===== 2. Fechas de ayer, hoy y mañana, y cambios de día en Europe/Madrid ===== */
{
  const caso = (iso, p) => { const R = reglas(iso); return [R.today(), jornadaDe(R, [[punto(1, "P"), Object.assign({ solicitudes: [], historial: [] }, p)]])]; };
  const sg = (f, fecha) => ({ solicitudes: [sol({ id: "a", fecha: "2026-10-20", seg: fecha })] });
  /* Seguimientos de ayer, hoy y mañana respecto a hoy. */
  for (const [dia, esperado] of [["2026-10-25", "atrasada"], ["2026-10-26", "hoy"], ["2026-10-27", undefined]]) {
    const [, J] = caso("2026-10-26T10:00:00Z", sg(0, dia));
    eq(J.length ? J[0].principal.id : undefined, esperado, "seguimiento del " + dia + " visto el 26/10");
  }
  /* A las 23:59:59 de Madrid todavía es el día anterior; a las 00:00 ya es el siguiente (en UTC sería aún el anterior). */
  let [hoy, J] = caso("2026-10-24T21:59:59Z", sg(0, "2026-10-24")); eq([hoy, J[0].principal.texto], ["2026-10-24", "Seguimiento para hoy"], "23:59:59 en Madrid: el seguimiento del 24 es de hoy");
  [hoy, J] = caso("2026-10-24T22:00:00Z", sg(0, "2026-10-24")); eq([hoy, J[0].principal.texto], ["2026-10-25", "Seguimiento atrasado 1 día"], "00:00 en Madrid: ya es el 25 y el del 24 está atrasado 1 día");
  /* Una concesión que termina «hoy» deja de estar vigente al cambiar el día: no se inventa nada. */
  [hoy, J] = caso("2026-10-24T21:59:59Z", { historial: [con({ id: "g", hasta: "2026-10-24" })] }); eq(J[0].principal.id, "terminaHoy", "la concesión que termina el 24 aún está vigente a las 23:59:59");
  [hoy, J] = caso("2026-10-24T22:00:00Z", { historial: [con({ id: "g", hasta: "2026-10-24" })] }); eq(J.length, 0, "…y al cambiar de día ya ha terminado: ni urgente ni nada (el estado sale de las fechas)");
  /* Fin de año (invierno, UTC+1) y cambios de hora. */
  [hoy, J] = caso("2026-12-31T22:59:59Z", sg(0, "2026-12-31")); eq([hoy, J[0].principal.id], ["2026-12-31", "hoy"], "invierno: 23:59:59 del 31/12");
  [hoy, J] = caso("2026-12-31T23:00:00Z", sg(0, "2026-12-31")); eq([hoy, J[0].principal.texto], ["2027-01-01", "Seguimiento atrasado 1 día"], "invierno: a medianoche ya es 2027 y el del 31/12 está atrasado");
  for (const [iso, dia] of [["2026-03-28T22:59:59Z", "2026-03-28"], ["2026-03-28T23:00:00Z", "2026-03-29"], ["2026-10-25T00:30:00Z", "2026-10-25"], ["2026-10-25T01:30:00Z", "2026-10-25"], ["2026-10-25T22:59:59Z", "2026-10-25"], ["2026-10-25T23:00:00Z", "2026-10-26"]]) {
    [hoy, J] = caso(iso, sg(0, dia)); eq([hoy, J[0].principal.id], [dia === hoy ? dia : hoy, dia === hoy ? "hoy" : "atrasada"], "cambio de hora: " + iso);
  }
}

/* ===== 3. Filtros combinados y recuentos ===== */
{
  const R = reglas("2026-10-26T10:00:00Z"), T = R.today(), d = (k) => R.addDays(T, k);
  const P = [
    [punto(1, "Hospital Granada", "Granada", "pr-gr"), { solicitudes: [sol({ id: "a", fecha: d(-6), seg: d(-4), resp: "u1" }), sol({ id: "b", fecha: d(-20) })], historial: [con({ id: "g", hasta: T, ong: "Cruz Roja", seg: d(-1), resp: "u2" })] }],
    [punto(2, "Súper Almería", "Almería", "pr-al"), { solicitudes: [sol({ id: "a", ong: "WWF", fecha: d(-9), seg: T, resp: "u1" }), sol({ id: "b", ong: "WWF", fecha: d(-3) })] }],
    [punto(3, "Gimnasio Jaén", "Jaén", "pr-ja"), { solicitudes: [sol({ id: "a", ong: "aecc", fecha: d(-17), seg: d(5) })], segPunto: { fecha: T, resp: "" } }],
    [punto(4, "Centro de salud Córdoba", "Córdoba", "pr-co"), { historial: [con({ id: "g", hasta: d(3), ong: "WWF" }), { id: "h", ong: "FJC", captadores: 1 }] }]
  ];
  const J = jornadaDe(R, P), total = J.length;
  const q = (x) => (x.c.name + " " + x.c.town + " " + x.c.province + " " + (x.ong || "Sin ONG")).toLowerCase();
  const base = { resp: "", q: "", rapida: "todas", tipo: "todos", textoDe: q };
  const cuenta = (f) => J.filter((x) => R.jornadaCumple(x, f)).length;
  ok(total >= 8 && cuenta(base) === total && R.jornadaConteos(J, base).total === total, "sin filtros salen todas");
  /* Todas las combinaciones: el recuento de cada opción es lo que daría al elegirla con los demás filtros aplicados. */
  let comb = 0;
  for (const rapida of R.JOR_RAPIDAS) for (const tipo of ["todos"].concat(R.JOR_TIPOS)) for (const resp of ["", "__ninguno", "u1", "u2"]) for (const txt of ["", "granada", "wwf", "zzz"]) {
    const f = { resp, q: txt, rapida, tipo, textoDe: q }, cn = R.jornadaConteos(J, f);
    assert.equal(cn.total, cuenta(f)); comb++;
    for (const k of R.JOR_RAPIDAS) assert.equal(cn.rapidas[k], cuenta(Object.assign({}, f, { rapida: k })));
    for (const k of ["todos"].concat(R.JOR_TIPOS)) assert.equal(cn.tipos[k], cuenta(Object.assign({}, f, { tipo: k })));
    assert.equal(R.JOR_TIPOS.reduce((s, k) => s + cn.tipos[k], 0), cn.tipos.todos, "los tipos suman el total (cada fila tiene un único tipo)");
    const sinResp = Object.assign({}, f, { resp: "" });
    assert.equal([...cn.resp.values()].reduce((s, v) => s + v, 0) + cn.sinResp, cuenta(sinResp), "los responsables suman las filas que cumplen los demás filtros");
    for (const [id, v] of cn.resp) assert.equal(v, cuenta(Object.assign({}, f, { resp: id })));
    assert.equal(cn.sinResp, cuenta(Object.assign({}, f, { resp: "__ninguno" })));
    if (rapida === "todas" && tipo === "todos" && resp === "" && txt === "") assert.equal(cn.rapidas.todas, cn.total);
    assert.ok(cn.rapidas.todas >= cn.rapidas.urgentes && cn.rapidas.todas >= cn.rapidas.hoy && cn.rapidas.todas >= cn.rapidas.sinseg, "«Todas» nunca es menos que una vista rápida");
  }
  n += comb * 5; ok(comb === 4 * 6 * 4 * 4, "384 combinaciones de filtros (4 vistas × 6 tipos × 4 responsables × 4 textos) sin recuentos incoherentes");
  /* Cada vista rápida y cada tipo, con su significado. */
  ok(J.filter((x) => R.jornadaCumple(x, Object.assign({}, base, { rapida: "urgentes" }))).every((x) => x.rank <= 3), "«Urgentes»: atrasados, concesiones que terminan hoy y datos bloqueantes");
  ok(J.filter((x) => R.jornadaCumple(x, Object.assign({}, base, { rapida: "hoy" }))).every((x) => x.motivos.some((m) => m.id === "hoy" || m.id === "terminaHoy")), "«Para hoy»: seguimientos de hoy y concesiones que terminan hoy");
  ok(J.filter((x) => R.jornadaCumple(x, Object.assign({}, base, { rapida: "sinseg" }))).every((x) => x.k === "sol" && !x.r.seg && x.r.est === "pendiente"), "«Sin seguimiento»: solicitudes pendientes sin seguimiento programado");
  ok(R.jornadaCumple(J[0], Object.assign({}, base, { q: "no existe" })) === false && R.jornadaCumple(J[0], Object.assign({}, base, { q: J[0].c.name.toLowerCase() })) === true, "la búsqueda por texto");
  /* El ámbito (provincia y ONG) se aplica a los expedientes antes de calcular: los mismos recuentos que en el Centro. */
  const { recs, segs, t } = entra(R, P), prov = (id) => ({ recs: recs.filter((r) => r.c.provinceId === id), segs: segs.filter((s) => s.c.provinceId === id) });
  const solo = prov("pr-al"), Jal = R.jornada(solo.recs, solo.segs, t, R.incidencias(solo.recs, t));
  ok(Jal.length > 0 && Jal.every((x) => x.c.provinceId === "pr-al"), "con la provincia elegida solo salen sus actuaciones");
  const wwf = (r) => (r.ong || "").trim().toLowerCase() === "wwf", rw = recs.filter(wwf), sw = segs.filter(wwf), Jw = R.jornada(rw, sw, t, R.incidencias(rw, t));
  ok(Jw.length > 0 && Jw.every((x) => x.ong.toLowerCase() === "wwf"), "con la ONG elegida solo salen sus actuaciones (sin distinguir mayúsculas)");
  ok(R.incidencias(rw, t).length === R.incidencias(recs, t).filter((x) => wwf(x.r)).length, "filtrar antes por ONG no cambia los avisos (se agrupan por punto y ONG)");
}

/* ===== 4. Completar una tarea: la bandeja se recalcula con el estado confirmado ===== */
{
  const R = reglas("2026-10-26T10:00:00Z"), T = R.today(), d = (k) => R.addDays(T, k);
  const m0 = bloque.indexOf("  const ubica = "), m1 = bloque.indexOf("\n  };\n", bloque.indexOf("const mutadores = {")) + 6;
  const M = runInNewContext("const permits = {}; const permitKey = (c) => c.id; const permOf = (c) => permits[permitKey(c)] || {};\n" + reglasCodigo + "\n" + bloque.slice(m0, m1) + "\n({ mutadores, ubica })", { Date: class extends Real { constructor(...x) { if (x.length) super(...x); else super("2026-10-26T10:00:00Z"); } static now() { return new Real("2026-10-26T10:00:00Z").getTime(); } }, self: {} });
  const c1 = punto(1, "Uno"), c2 = punto(2, "Dos");
  const estado1 = () => ({ solicitudes: [sol({ id: "a", fecha: d(-6), seg: d(-4), resp: "u1" })], historial: [] });
  const estado2 = () => ({ solicitudes: [sol({ id: "b", fecha: d(-20), seg: d(-3), desde: d(-1), hasta: d(5), ong: "" })], historial: [] });
  const antes = jornadaDe(R, [[c1, estado1()], [c2, estado2()]]);
  eq(nombres(antes), ["Uno", "Dos"], "dos tareas: la más atrasada primero");
  /* «Hecho»: la fila de un expediente con un único motivo desaparece; la de varios motivos pasa al siguiente. */
  const { seg } = antes[0], e1 = estado1(); M.mutadores.cerrarSeg(seg)(e1);
  eq(jornadaDe(R, [[c1, e1], [c2, estado2()]]).map((f) => [f.c.name, f.principal.id]), [["Dos", "atrasada"], ["Uno", "sinseg"]], "tras cerrar el seguimiento de Uno, su solicitud sigue pendiente y ahora le falta un seguimiento (el trabajo real no desaparece, solo baja de grado)");
  const e2 = estado2(); M.mutadores.cerrarSeg(antes[1].seg)(e2);
  const dsp = jornadaDe(R, [[c1, estado1()], [c2, e2]]);
  eq(dsp.map((f) => [f.c.name, f.principal.id]), [["Uno", "atrasada"], ["Dos", "inicio"]], "Dos pasa a su siguiente motivo (periodo empezado) y conserva sus alertas");
  eq(dsp[1].extras, ["Solicitud sin respuesta desde hace 20 días", "Solicitud pendiente sin seguimiento programado", "Solicitud sin ONG"], "…y las alertas restantes");
  /* Reprogramar: a una fecha futura sale de la bandeja; a hoy pasa a «hoy». */
  const e3 = estado1(); M.mutadores.cambiarSeg(seg, d(5))(e3);
  eq(jornadaDe(R, [[c1, e3]]).map((f) => f.principal.id), [], "reprogramado a una fecha futura: ya no requiere atención");
  const e4 = estado1(); M.mutadores.cambiarSeg(seg, T)(e4);
  eq(jornadaDe(R, [[c1, e4]]).map((f) => [f.principal.id, f.banda]), [["hoy", "hoy"]], "reprogramado a hoy: pasa a seguimientos de hoy");
  /* Asignar responsable no cambia la fila, solo quién la tiene. */
  const e5 = estado1(); M.mutadores.asignarResp(seg, "u9")(e5);
  eq(jornadaDe(R, [[c1, e5]]).map((f) => [f.principal.id, f.resp]), [["atrasada", "u9"]], "asignar responsable");
  /* Aprobar o resolver una solicitud la saca de la bandeja. */
  const e6 = { solicitudes: [sol({ id: "a", fecha: d(-6) })], historial: [] }; M.mutadores.resolver({ id: "a" }, "denegada", "x")(e6);
  eq(jornadaDe(R, [[c1, e6]]).length, 0, "una solicitud resuelta ya no está pendiente");
}

/* ===== 5. Ámbito por provincia y rol: solo salen los puntos a los que se tiene acceso ===== */
{
  const R = reglas("2026-10-26T10:00:00Z"), T = R.today(), d = (k) => R.addDays(T, k);
  const r0 = bloque.indexOf("  const registros = (provId) => {"), r1 = bloque.indexOf("\n  };\n", r0) + 6;
  assert.ok(r0 >= 0 && r1 > r0, "No se encuentra registros()");
  const montar = (CENTERS, permits, quitados = []) => runInNewContext(
    "const permits = " + JSON.stringify(permits) + "; const permitKey = (c) => c.id; const CENTERS = " + JSON.stringify(CENTERS) + "; const isOut = (c) => " + JSON.stringify(quitados) + ".includes(c.id);\n" + reglasCodigo.replace(/^const permits = \{\};/m, "") + "\n" + bloque.slice(r0, r1) + "\n({ registros, today, jornada, incidencias })",
    { Date: class extends Real { constructor(...x) { if (x.length) super(...x); else super("2026-10-26T10:00:00Z"); } static now() { return new Real("2026-10-26T10:00:00Z").getTime(); } }, self: {} });
  const A = { id: 1, name: "Punto A", province: "Granada", provinceId: "pr-gr" }, B = { id: 2, name: "Punto B", province: "Almería", provinceId: "pr-al" }, C = { id: 3, name: "Punto C (quitado)", province: "Granada", provinceId: "pr-gr" };
  const st = { solicitudes: [sol({ id: "a", fecha: d(-6), seg: d(-4) })], historial: [] };
  const permisos = { 1: st, 2: st, 3: st };
  const usa = (CENTERS, quitados, prov) => { const X = montar(CENTERS, permisos, quitados), { recs, segs } = X.registros(prov), t = X.today(); return X.jornada(recs, segs, t, X.incidencias(recs, t)).map((f) => f.c.name); };
  eq(usa([A, B], [], ""), ["Punto A", "Punto B"], "administrador o usuario de dos provincias: ve las dos");
  eq(usa([A], [], ""), ["Punto A"], "usuario de una provincia: el catálogo que se le entrega solo trae su provincia, y aunque haya expedientes de otras en memoria no salen");
  eq(usa([A, B], [], "pr-al"), ["Punto B"], "filtro de provincia");
  eq(usa([A, B, C], [3], ""), ["Punto A", "Punto B"], "los puntos quitados o archivados no entran");
  eq(usa([], [], ""), [], "sin puntos en el ámbito, nada (y la pantalla lo dice con su propio texto)");
  /* La bandeja solo lee CENTERS y los expedientes en memoria: no tiene ninguna lectura de red propia. */
  ok(!/\.from\(|\.rpc\(|fetch\(/.test(trozo("  /* === Mi jornada: la bandeja de trabajo", "  /* === Pantalla principal === */")), "drawJornada no lee ni escribe en la red: usa lo ya cargado por la sesión");
}

/* ===== 6. La pantalla: estados, accesibilidad y reglas de la aplicación ===== */
{
  const pantalla = trozo("  /* === Mi jornada: la bandeja de trabajo", "  /* === Pantalla principal === */");
  ok(pantalla.includes("!ses.catalogueReady || ses.catalogueError") && pantalla.includes("No se ha podido leer el trabajo pendiente") && pantalla.includes("Esto no significa que no haya nada que hacer") && pantalla.includes("No se muestran datos locales"), "si la lectura falló, se avisa y no se pinta una bandeja vacía");
  ok(pantalla.includes("Todo al día.") && pantalla.includes("Ninguna actuación con estos filtros.") && pantalla.includes("Todavía no hay solicitudes ni concesiones"), "estados vacíos distintos: todo al día, sin resultados con filtros y sin expedientes");
  ok(pantalla.includes("data-quita-filtros") && pantalla.includes("Quitar filtros ("), "forma visible de quitar los filtros, con cuántos hay");
  ok(pantalla.includes('role="group" aria-label="Vistas rápidas"') && pantalla.includes("aria-pressed") && pantalla.includes('role="status"'), "vistas rápidas accesibles y recuento anunciado");
  ok(pantalla.includes('aria-label="Marcar como hecho el seguimiento de ') && pantalla.includes('aria-label="Abrir el expediente de ') && pantalla.includes('aria-label="Seleccionar el seguimiento de '), "los botones repetidos de cada fila tienen nombre accesible con el punto");
  ok(pantalla.includes("esc(nombre)") && pantalla.includes("esc(x.principal.texto)") && pantalla.includes("esc(ongDe(x))") && pantalla.includes("esc(periodo(x.r))") && pantalla.includes("esc(lugar)") && pantalla.includes("esc(x.siguiente)"), "los textos que vienen de los datos pasan por esc()");
  ok(pantalla.includes('<h3 id="joT" tabindex="-1">') && pantalla.includes("jorFoco") && pantalla.includes("Math.min(i, filas.length - 1)"), "tras una acción el foco pasa a la siguiente tarea (o al título si no queda ninguna)");
  ok(pantalla.includes('<section class="jo-banda" aria-labelledby=') && pantalla.includes('<ul class="jo-lista">'), "secciones con título y listas reales (se recorren con lector de pantalla)");
  ok(pantalla.includes("mapaExpedientesSinVolcar"), "avisa de los expedientes antiguos que no están en las tablas");
  ok(bloque.includes("jorSnap") && /filasJ = \(vista === "jor" && ocupado && jorSnap\) \? jorSnap : jornada\(/.test(bloque), "mientras se guarda, la bandeja sigue con lo ya confirmado: nada se ve como resuelto antes de la confirmación");
  ok(/\.ce-filtros select, \.ce-filtros input"\)\.forEach\(\(e\) => \{ e\.disabled = ocupado; \}\)/.test(pantalla), "durante el guardado se bloquean los filtros");
  ok((bloque.match(/\bjornada\((recs|recsAmb),/g) || []).length === 2 && bloque.includes("filasJ = (vista") && bloque.includes("resumenDatos(recsAmb, segsAmb, t, incsAmb, filasJ)"), "la bandeja se calcula una vez por dibujo y la comparten navegación, Resumen y lista (sin procesamientos repetidos)");
  ok(!/localStorage|sessionStorage|indexedDB|document\.cookie|caches\./.test(pantalla + trozo("  /* Mi jornada: entrada del menú", "  $(\"#ceClose\")")), "Mi jornada no usa almacenamiento del navegador");
  ok(bloque.includes("let vista = \"jor\"") && bloque.includes('["jor", "Mi jornada"]'), "Mi jornada es la primera sección del Centro");
  ok(bloque.includes('document.addEventListener("sesion:lista"') && bloque.includes("cuentaJornada() > 0 && !dlg.open") && bloque.includes("if (jorAbierta) return; jorAbierta = true;"), "se abre sola al entrar, una vez por sesión, solo si hay trabajo (el flag vive en memoria)");
  ok((html.match(/document\.dispatchEvent\(new CustomEvent\("sesion:lista"\)\)/g) || []).length === 2, "el evento de sesión lista se emite al iniciar sesión y al recuperarla");
  ok(html.includes('id="jornadaBtn" type="button" role="menuitem">Mi jornada</button>') && bloque.includes('"Mi jornada (" + n + ")"'), "entrada de menú con el número de actuaciones");
  ok(bloque.includes("[data-mapa]") && pantalla.includes('data-mapa="1">Ir al mapa'), "acción clara para ir al mapa");
  ok(bloque.includes("[data-ir]") && bloque.includes("punto = r0.c; vista = r0.k || \"seg\"; est[vista] = \"todas\"; sel = clave(r0);"), "«Abrir en…» lleva al expediente exacto, en su sección, filtrado por su punto");
  ok(bloque.includes("fj.motivos.map") && bloque.includes("Por qué está en Mi jornada"), "el detalle explica por qué requiere atención");
  ok(/vista !== "seg" && vista !== "jor"/.test(bloque) && bloque.includes("multi = new Set([...multi].filter((k) => validas.has(k)))"), "los lotes valen en Mi jornada y la selección solo contiene lo que se ve");
  ok((bloque.match(/savePermits\(/g) || []).length === 1, "sigue habiendo una sola escritura: aplica()");
  /* Estilos: modo oscuro por tokens, foco visible, sin animaciones nuevas, móvil. */
  const css = html.slice(html.indexOf("/* Mi jornada: lista de trabajo compacta"), html.indexOf("/* Mi jornada: lista de trabajo compacta") + 5000);
  ok(!/#[0-9a-fA-F]{3,8}\b|rgba?\(/.test(css.slice(0, css.indexOf(".ce-tabla tr.ce-confrow") > 0 ? css.indexOf(".ce-tabla tr.ce-confrow") : css.length).split("@media")[0]), "los colores de Mi jornada son tokens (claro y oscuro)");
  ok(!/transition|animation|@keyframes/.test(css.split("@media")[0]), "sin animaciones");
  ok(/\.jo-chip:focus-visible \{ outline: 2px solid var\(--accent\)/.test(html) && /#joT:focus-visible/.test(html), "foco visible");
  ok(/#ceBody \.jo-fila \{ grid-template-columns: 36px minmax\(0, 1fr\); \}/.test(html) && /\.jo-acts \{ grid-column: 1 \/ -1;/.test(html), "en móvil la fila pasa a una columna y las acciones bajan");
  ok(/\.jo-chip, \.jo-todos \{ min-height: 44px; \}/.test(html), "objetivos de 44 px en pantallas táctiles");
  ok(/#ceBody\[data-vista="jor"\] \.ce-solo-ord \{ display: none; \}/.test(html) && /:not\(\[data-vista="jor"\]\) \.ce-solo-seg/.test(html), "en Mi jornada se ve Responsable y Tipo y no el orden (fijo)");
}

/* ===== 7. Rendimiento con el volumen real: 39.000 puntos y miles de expedientes ===== */
{
  const R = reglas("2026-10-26T10:00:00Z"), T = R.today(), d = (k) => R.addDays(T, k);
  const r0 = bloque.indexOf("  const registros = (provId) => {"), r1 = bloque.indexOf("\n  };\n", r0) + 6;
  const CENTERS = Array.from({ length: 39000 }, (_, i) => ({ id: i + 1, name: "Punto " + i, town: "Pueblo " + (i % 900), province: "Provincia " + (i % 52), provinceId: "pr-" + (i % 52) }));
  const permits = {};
  for (let i = 0; i < 39000; i += 13) { /* 3.000 puntos con expedientes: solicitudes (a veces varias), concesiones y seguimientos */
    permits[i + 1] = { solicitudes: [sol({ id: "a" + i, fecha: d(-(i % 40)), seg: i % 3 === 0 ? d((i % 9) - 5) : "", ong: ["AECC", "WWF", "Cruz Roja"][i % 3] }), sol({ id: "b" + i, fecha: d(-(i % 25)), res: i % 4 === 0 ? "denegada" : undefined, resFecha: d(-1) })], historial: [con({ id: "g" + i, hasta: d((i % 20) - 3), seg: i % 5 === 0 ? d(-1) : "" })] };
  }
  const X = runInNewContext(
    "const permits = {}; const permitKey = (c) => c.id; const isOut = () => false;\n" + reglasCodigo.replace(/^const permits = \{\};/m, "") + "\n" + bloque.slice(r0, r1) + "\n({ registros, jornada, incidencias, jornadaConteos, jornadaCumple, setPermits: (p, c) => { Object.assign(permits, p); CENTERS.push(...c); } })".replace("const permits = {};", ""),
    { Date: class extends Real { constructor(...x) { if (x.length) super(...x); else super("2026-10-26T10:00:00Z"); } static now() { return new Real("2026-10-26T10:00:00Z").getTime(); } }, self: {}, CENTERS: [] });
  X.setPermits(JSON.parse(JSON.stringify(permits)), CENTERS);
  const t0 = performance.now(), { recs, segs } = X.registros(""), t1 = performance.now(), incs = X.incidencias(recs, T), t2 = performance.now(), J = X.jornada(recs, segs, T, incs), t3 = performance.now();
  const f = { resp: "", q: "pueblo 1", rapida: "todas", tipo: "todos", textoDe: (x) => (x.c.name + " " + x.c.town + " " + x.c.province + " " + x.ong).toLowerCase() };
  const cn = X.jornadaConteos(J, f), t4 = performance.now();
  console.log("  rendimiento: " + recs.length + " expedientes, " + segs.length + " seguimientos, " + J.length + " actuaciones; registros " + (t1 - t0).toFixed(0) + " ms, avisos " + (t2 - t1).toFixed(0) + " ms, jornada " + (t3 - t2).toFixed(0) + " ms, recuentos " + (t4 - t3).toFixed(0) + " ms");
  ok(J.length > 500 && recs.length > 5000, "el escenario es realista (miles de expedientes)");
  ok(t3 - t2 < 400 && t4 - t3 < 400 && t1 - t0 < 600, "jornada y recuentos en una fracción de segundo con 39.000 puntos");
  ok(cn.total <= J.length, "recuentos coherentes");
}

console.log("Mi jornada: " + n + " comprobaciones correctas.");

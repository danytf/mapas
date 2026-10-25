// Reglas de negocio de solicitudes, concesiones y seguimientos (bloque «Reglas de expedientes» de index.html).
// Se ejecutan en un contexto aislado con un reloj falso, porque dependen de la fecha local de Madrid.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("const fmtD = ");
const b = html.indexOf("/* === Reglas de expedientes");
const c = html.indexOf("/* === fin de la capa relacional === */");
assert.ok(a >= 0 && b > a && c > b, "No se encuentra el bloque de reglas de expedientes en index.html");
const codigo = html.slice(a, b) + "\n" + html.slice(b, c);

// Reloj falso: la fecha «de hoy» de la aplicación sale de new Date().
const Real = Date;
const reglas = (ahoraIso) => {
  class Falsa extends Real {
    constructor(...args) { if (args.length) super(...args); else super(ahoraIso); }
    static now() { return new Real(ahoraIso).getTime(); }
  }
  const sandbox = { Date: Falsa, self: {} };
  return runInNewContext(
    "const permits = {}; const permitKey = (c) => c.id; const permOf = (c) => permits[permitKey(c)] || {};\n" + codigo +
    "\n({ today, addDays, mondayOf, daysBetween, solEstado, concEstado, estadoCalc, expedientesDe, seguimientosDe, capacidad, capacidadPorOng, incidencias, indicadores, estadoEnDia, calendarioSemana, sanitizeSharedPermitState, UMBRAL_ESTANCADA, relListas, diffRel, verificaOps })",
    sandbox
  );
};

let n = 0;
const ok = (cond, msg) => { assert.ok(cond, msg); n++; };
// Los valores salen de otro contexto de ejecución: se comparan como JSON para no depender de sus prototipos.
const norm = (v) => (v === undefined ? "__undefined__" : JSON.parse(JSON.stringify(v)));
const eq = (x, y, msg) => { assert.deepStrictEqual(norm(x), norm(y), msg); n++; };

// 14. Cambio de día local en Europe/Madrid (verano UTC+2, invierno UTC+1, cambio de hora).
eq(reglas("2026-10-24T21:59:59Z").today(), "2026-10-24", "23:59:59 en Madrid sigue siendo el 24");
eq(reglas("2026-10-24T22:00:00Z").today(), "2026-10-25", "00:00 en Madrid ya es el 25 (UTC sería aún el 24)");
eq(reglas("2026-12-31T22:59:59Z").today(), "2026-12-31", "invierno: 23:59:59 en Madrid");
eq(reglas("2026-12-31T23:00:00Z").today(), "2027-01-01", "invierno: medianoche de fin de año");
eq(reglas("2026-03-28T22:59:00Z").today(), "2026-03-28", "víspera del cambio de hora de marzo");
eq(reglas("2026-03-28T23:30:00Z").today(), "2026-03-29", "noche del cambio de hora de marzo");
eq(reglas("2026-10-25T01:30:00Z").today(), "2026-10-25", "noche del cambio de hora de octubre");

// Aritmética de fechas sin zona horaria.
const R = reglas("2026-10-23T10:00:00Z");
eq(R.addDays("2026-10-31", 1), "2026-11-01"); eq(R.addDays("2026-12-31", 1), "2027-01-01"); eq(R.addDays("2028-02-28", 1), "2028-02-29"); eq(R.addDays("2026-03-29", 1), "2026-03-30");
eq(R.mondayOf("2026-10-23"), "2026-10-19", "el viernes 23 pertenece a la semana del lunes 19");
eq(R.mondayOf("2026-10-25"), "2026-10-19", "el domingo pertenece a la semana que empezó el lunes");
eq(R.mondayOf("2026-10-26"), "2026-10-26");
eq(R.daysBetween("2026-10-25", "2026-10-26"), 1, "el cambio de hora no altera la diferencia en días");

// Estados de solicitud y de concesión (extremos incluidos).
eq(R.solEstado({ hasta: "2026-10-23" }), "pendiente", "hasta hoy: todavía vale");
eq(R.solEstado({ hasta: "2026-10-22" }), "caducada");
eq(R.solEstado({ hasta: "2026-10-22", res: "aprobada" }), "aprobada");
eq(R.solEstado({ res: "retirada" }), "retirada");
eq(R.concEstado({ desde: "2026-10-23", hasta: "2026-10-23" }), "vigente", "un solo día es vigente ese día");
eq(R.concEstado({ hasta: "2026-10-22" }), "terminada");
eq(R.concEstado({ desde: "2026-10-24" }), "futura");
eq(R.concEstado({ desde: "2026-10-01", cancelada: true }), "cancelada");
eq(R.concEstado({ desde: "2026-10-01" }), "vigente", "sin fecha de fin sigue vigente");

// El estado resumido del punto no oculta nada: una concesión vigente y una solicitud pendiente conviven.
eq(R.estadoCalc({ historial: [{ desde: "2026-10-01", hasta: "2026-10-30", ong: "A" }], solicitudes: [{ desde: "2026-11-01", hasta: "2026-11-30", ong: "B" }] }), "concedido");
eq(R.estadoCalc({ solicitudes: [{ desde: "2026-10-01", hasta: "2026-10-30", res: "retirada" }] }), "sin", "retirada no es denegada");
eq(R.estadoCalc({ solicitudes: [{ desde: "2026-10-01", hasta: "2026-10-30", res: "denegada" }] }), "denegado");
eq(R.estadoCalc({ solicitudes: [{ desde: "2026-10-01", hasta: "2026-10-30", res: "aprobada" }], historial: [{ desde: "2026-10-01", hasta: "2026-10-30", cancelada: true }] }), "cancelado");

// Datos de partida de los escenarios (los puntos distinguen por id).
const P1 = { id: 1, name: "P1" }, P2 = { id: 2, name: "P2" };
const rec = (p, estado) => R.expedientesDe(P1, p);
const T = "2026-10-23";

// 5. Concesión vigente de una ONG y solicitud pendiente de otra, en el mismo punto: aparecen las dos cosas.
{
  const ex = R.expedientesDe(P1, { historial: [{ desde: "2026-10-01", hasta: "2026-12-31", ong: "AECC", captadores: 4 }], solicitudes: [{ desde: "2026-11-02", hasta: "2026-11-30", ong: "Cruz Roja", captadores: 3, fecha: "2026-10-20", seg: "2026-10-30" }] });
  const ind = R.indicadores(ex, R.seguimientosDe(P1, { solicitudes: [{ ong: "Cruz Roja", seg: "2026-10-30" }] }), T);
  eq(ind.vigentes.length, 1); eq(ind.pendientes.length, 1);
  eq(ind.capacidadHoy, 4, "los captadores por aprobar no cuentan como autorizados");
  eq(ind.segProximos.length, 1);
  eq(ind.sinSeguimiento.length, 0);
}

// 6 y 7. Varias concesiones con fin distinto; una sin fecha de fin no oculta la que vence pronto.
{
  const ex = R.expedientesDe(P1, { historial: [
    { desde: "2026-09-01", ong: "A", captadores: 2 },
    { desde: "2026-09-01", hasta: "2026-10-28", ong: "B", captadores: 3 },
    { desde: "2026-09-01", hasta: "2026-11-05", ong: "C", captadores: 1 },
    { desde: "2026-09-01", hasta: "2026-11-30", ong: "D", captadores: 1 }
  ] });
  const ind = R.indicadores(ex, [], T);
  eq(ind.vencen7.map((r) => r.ong), ["B"], "vence en 5 días aunque otra concesión no tenga fin");
  eq(ind.vencen15.map((r) => r.ong), ["C"], "13 días");
  eq(ind.vencen30.length, 0, "D vence en 38 días");
  eq(ind.sinFin.map((r) => r.ong), ["A"]);
  eq(ind.vigentes.length, 4);
}
// Límites de los tramos de vencimiento (0, 7, 8, 15, 16, 30 y 31 días).
{
  const dias = [0, 7, 8, 15, 16, 30, 31];
  const ex = dias.flatMap((d, i) => R.expedientesDe({ id: 100 + i, name: "x" }, { historial: [{ desde: "2026-10-01", hasta: R.addDays(T, d), ong: "A", captadores: 1 }] }));
  const ind = R.indicadores(ex, [], T);
  eq(ind.vencen7.length, 2); eq(ind.vencen15.length, 2); eq(ind.vencen30.length, 2);
}

// 8. Concesión futura que empieza dentro de 30 días (y una que empieza después).
{
  const ex = R.expedientesDe(P1, { historial: [{ desde: "2026-11-10", hasta: "2026-11-20", ong: "A", captadores: 2 }, { desde: "2026-12-30", hasta: "2027-01-10", ong: "A", captadores: 2 }, { desde: "2026-11-22", ong: "B", captadores: 1 }] });
  const ind = R.indicadores(ex, [], T);
  eq(ind.futuras30.map((r) => r.desde).sort(), ["2026-11-10", "2026-11-22"], "hoy+30 = 22/11 incluido");
  eq(ind.vigentes.length, 0); eq(ind.capacidadHoy, 0);
}

// 9. Captadores concurrentes: ONG distintas suman; la misma ONG se toma el mayor (sin doble conteo); puntos distintos suman.
{
  const base = { historial: [
    { desde: "2026-10-01", hasta: "2026-10-31", ong: "AECC", captadores: 4 },
    { desde: "2026-10-15", hasta: "2026-11-15", ong: "aecc", captadores: 6 },
    { desde: "2026-10-01", hasta: "2026-10-31", ong: "Cruz Roja", captadores: 3 }
  ] };
  const e1 = R.expedientesDe(P1, base), e2 = R.expedientesDe(P2, { historial: [{ desde: "2026-10-01", hasta: "2026-10-31", ong: "AECC", captadores: 5 }] });
  eq(R.capacidad(e1), 9, "AECC (mayor de 4 y 6) + Cruz Roja 3");
  eq(R.capacidad(e1.concat(e2)), 14, "otro punto de la misma ONG suma");
  eq([...R.capacidadPorOng(e1.concat(e2))].sort(), [["AECC", 11], ["Cruz Roja", 3]]);
  ok(R.incidencias(e1, T).some((i) => i.tipo.startsWith("Concesiones solapadas")), "AECC solapada consigo misma se marca para revisar");
}

// 10. Semana pasada, actual y futura: solo se afirma lo que consta en los registros.
{
  const p = {
    historial: [
      { desde: "2026-10-05", hasta: "2026-10-30", ong: "A", captadores: 4, id: "g1" },
      { desde: "2026-10-05", hasta: "2026-10-30", ong: "B", captadores: 2, cancelada: true, id: "g2" },                 // cancelada sin fecha de cancelación
      { desde: "2026-10-05", hasta: "2026-10-30", ong: "C", captadores: 2, cancelada: true, resFecha: "2026-10-20", id: "g3" }
    ],
    solicitudes: [
      { desde: "2026-10-05", hasta: "2026-11-30", ong: "D", captadores: 5, fecha: "2026-10-10", seg: "2026-10-22" },       // pendiente desde el 10
      { desde: "2026-10-05", hasta: "2026-10-30", ong: "E", captadores: 3, fecha: "2026-10-06", res: "denegada", resFecha: "2026-10-12" },
      { desde: "2026-10-05", hasta: "2026-10-30", ong: "F", captadores: 2, res: "denegada" }                              // sin fecha de alta ni de decisión
    ]
  };
  const ex = R.expedientesDe(P1, p), sg = R.seguimientosDe(P1, p);
  const sem = (lunes) => R.calendarioSemana(ex, sg, lunes, T);
  const dia = (s, d) => s.find((x) => x.d === d);
  const pasada = sem("2026-10-05"); // lunes 5 a domingo 11
  eq(pasada.length, 7); eq(pasada[0].d, "2026-10-05"); eq(pasada[6].d, "2026-10-11");
  eq(dia(pasada, "2026-10-05").aut, 6, "el 5: A (4) y C (2, se canceló el 20); B no consta y no se cuenta");
  ok(dia(pasada, "2026-10-05").items.some((i) => i.r.ong === "B" && i.e === "desconocida"), "B cancelada sin fecha: estado desconocido, no se inventa");
  ok(!dia(pasada, "2026-10-05").items.some((i) => i.r.ong === "D"), "D no aparece antes de su fecha de alta");
  eq(dia(pasada, "2026-10-05").items.find((i) => i.r.ong === "E"), undefined, "E se pidió el 6: el 5 no existía");
  eq(dia(pasada, "2026-10-06").items.find((i) => i.r.ong === "E").e, "pendiente", "E estaba pendiente hasta que se denegó");
  eq(dia(pasada, "2026-10-11").pen, 8, "el 11 estaban pendientes D (5) y E (3)");
  ok(dia(pasada, "2026-10-05").items.some((i) => i.r.ong === "F" && i.e === "desconocida"), "denegada sin fechas: desconocida");
  eq(dia(pasada, "2026-10-05").seg.length, 0);
  const actual = sem("2026-10-19"); // semana de hoy (viernes 23)
  eq(dia(actual, "2026-10-19").aut, 6, "el 19 todavía contaba C");
  eq(dia(actual, "2026-10-20").aut, 4, "desde el 20 C ya está cancelada");
  eq(dia(actual, "2026-10-20").items.find((i) => i.r.ong === "E").e, "denegada", "desde el 12 E consta denegada");
  eq(dia(actual, "2026-10-22").seg.length, 1, "el seguimiento del 22");
  eq(dia(actual, "2026-10-22").segAtras, 1, "y está atrasado");
  eq(dia(actual, "2026-10-23").pen, 5, "hoy sigue pendiente D");
  const futura = sem("2026-11-02");
  eq(dia(futura, "2026-11-02").aut, 0, "las concesiones habían terminado el 30");
  eq(dia(futura, "2026-11-02").pen, 5, "la solicitud D se proyecta como por aprobar");
  eq(dia(futura, "2026-11-02").items.length, 1, "solo D en la semana futura");
}

// Caducada: una solicitud que ya pasó sin respuesta se reconstruye como pendiente mientras estuvo en plazo.
{
  const ex = R.expedientesDe(P1, { solicitudes: [{ desde: "2026-10-01", hasta: "2026-10-10", ong: "A", captadores: 2, fecha: "2026-10-02" }] });
  eq(ex[0].est, "caducada");
  eq(R.estadoEnDia(ex[0], "2026-10-05", T), "pendiente");
  eq(R.estadoEnDia(ex[0], "2026-10-01", T), null, "antes de pedirse");
}

// Aprobar conserva la solicitud y enlaza la concesión (el saneado no pierde el vínculo ni el motivo).
{
  const s = R.sanitizeSharedPermitState({
    solicitudes: [{ id: "sol-0001-abc", desde: "2026-10-01", hasta: "2026-10-31", ong: "A", captadores: 3, fecha: "2026-10-01", res: "aprobada", resFecha: "2026-10-05", conc: "con-0001-abc" },
                  { id: "sol-0002-abc", desde: "2026-10-01", ong: "A", res: "denegada", resFecha: "2026-10-06", motivo: "Sin cupo", contacto: "Ana", notas: "Llamar en enero" },
                  { id: "sol-0003-abc", desde: "2026-10-01", res: "retirada" },
                  { desde: "2026-10-01", res: "hackeada", conc: "con-0001-abc" },
                  { id: "no valido!", desde: "2026-10-01", res: "pendiente" }],
    historial: [{ id: "con-0001-abc", sol: "sol-0001-abc", desde: "2026-10-01", hasta: "2026-10-31", ong: "A", captadores: 3, alta: "2026-10-05", cancelada: true, resFecha: "2026-10-20", motivo: "ONG renuncia" }]
  });
  eq(s.solicitudes[0].res, "aprobada"); eq(s.solicitudes[0].conc, "con-0001-abc"); eq(s.solicitudes[0].resFecha, "2026-10-05");
  eq(s.historial[0].sol, "sol-0001-abc"); eq(s.historial[0].alta, "2026-10-05"); eq(s.historial[0].motivo, "ONG renuncia");
  eq(s.solicitudes[1].motivo, "Sin cupo"); eq(s.solicitudes[1].contacto, "Ana"); eq(s.solicitudes[1].notas, "Llamar en enero");
  eq(s.solicitudes[2].res, "retirada");
  eq(s.solicitudes[3].res, undefined, "un estado desconocido no se acepta"); eq(s.solicitudes[3].conc, undefined, "sin aprobación no hay enlace");
  eq(s.solicitudes[4].id, undefined, "ids con caracteres raros se descartan");
}

// Estancadas, sin seguimiento, datos incompletos y analítica de resolución.
{
  const ex = R.expedientesDe(P1, { solicitudes: [
    { desde: "2026-11-01", hasta: "2026-11-30", ong: "A", captadores: 2, fecha: "2026-10-01" },                       // 22 días: estancada, sin seguimiento
    { desde: "2026-11-01", hasta: "2026-11-30", ong: "B", captadores: 2, fecha: "2026-10-20", seg: "2026-10-25" },    // reciente, con seguimiento
    { desde: "2026-11-01", hasta: "2026-11-30", captadores: 0 },                                                        // sin ONG ni captadores
    { desde: "2026-10-01", ong: "C", captadores: 2, fecha: "2026-10-01", res: "aprobada", resFecha: "2026-10-05" },   // 4 días
    { desde: "2026-10-01", ong: "C", captadores: 2, fecha: "2026-10-01", res: "denegada", resFecha: "2026-10-04" },   // 3 días
    { desde: "2026-10-01", ong: "C", captadores: 2, res: "retirada" }                                                  // sin fechas: no entra en el tiempo medio
  ] });
  const ind = R.indicadores(ex, [], T);
  eq(ind.pendientes.length, 3); eq(ind.estancadas.map((r) => r.ong), ["A"]); eq(ind.sinSeguimiento.length, 2);
  eq(ind.resueltas, 3); eq(ind.solicitudes, 6); eq(ind.tasaResolucion, 50);
  eq(ind.diasMedios, 3.5); eq(ind.muestraTiempo, 2);
  const tipos = ind.incidencias.map((i) => i.tipo);
  ok(tipos.includes("Solicitud sin ONG") && tipos.includes("Solicitud sin número de captadores"), "datos incompletos");
  ok(tipos.some((t) => t.startsWith("Solicitud estancada")), "estancada");
  const sinDatos = R.indicadores(R.expedientesDe(P1, {}), [], T);
  eq(sinDatos.tasaResolucion, null, "sin solicitudes no se inventa un porcentaje"); eq(sinDatos.diasMedios, null);
}

// Seguimientos: vencidos, de hoy y próximos; el seguimiento de una solicitud resuelta no cuenta.
{
  const p = { solicitudes: [
    { desde: "2026-11-01", ong: "A", seg: "2026-10-20" }, { desde: "2026-11-01", ong: "B", seg: "2026-10-23" }, { desde: "2026-11-01", ong: "C", seg: "2026-10-30" },
    { desde: "2026-11-01", ong: "D", seg: "2026-10-31" }, { desde: "2026-11-01", ong: "E", seg: "2026-10-22", res: "denegada" }
  ] };
  const ind = R.indicadores(R.expedientesDe(P1, p), R.seguimientosDe(P1, p), T);
  eq(ind.segVencidos.map((s) => s.ong), ["A"]); eq(ind.segHoy.map((s) => s.ong), ["B"]); eq(ind.segProximos.map((s) => s.ong), ["C"], "hoy+7 = 30/10 incluido; el 31 queda fuera");
  eq(R.seguimientosDe(P1, { seguimiento: "2026-10-23" }).length, 1, "seguimiento antiguo de un punto sin solicitudes");
}

// Capa relacional: filas de las tablas -> listas de la ficha, y diferencias -> operaciones.
{
  const E = "est-1";
  const apps = [
    { id: "app-1", establishment_id: E, status: "pending", requested_from: "2026-11-02", requested_until: "2026-11-30", organization: "AECC", capturer_count: 3, requested_at: "2026-10-20", contact_details: "Ana", notes: null, resolved_at: null, resolution_reason: null, updated_at: "2026-10-20T10:00:00.000000+00:00" },
    { id: "app-2", establishment_id: E, status: "approved", requested_from: "2026-10-01", requested_until: "2026-10-31", organization: "WWF", capturer_count: 2, requested_at: "2026-10-01", resolved_at: "2026-10-05T10:30:00+00:00", resolution_reason: null, updated_at: "2026-10-05T10:30:00.000000+00:00" },
    { id: "app-3", establishment_id: E, status: "denied", requested_from: "2026-10-01", requested_until: null, organization: "FJC", capturer_count: null, requested_at: "2026-10-02", resolved_at: "2026-10-06T22:30:00+00:00", resolution_reason: "Sin cupo", updated_at: "2026-10-06T22:30:00.000000+00:00" }
  ];
  const grants = [
    { id: "gr-1", establishment_id: E, application_id: "app-2", status: "active", valid_from: "2026-10-01", valid_until: "2026-10-31", organization: "WWF", capturer_count: 2, created_at: "2026-10-05T10:30:00+00:00", updated_at: "2026-10-05T10:30:00.000000+00:00" },
    { id: "gr-2", establishment_id: E, application_id: null, status: "cancelled", valid_from: "2026-09-01", valid_until: "2026-09-30", organization: "AECC", capturer_count: 1, cancelled_at: "2026-09-10T08:00:00+00:00", cancelled_reason: "Renuncia", created_at: "2026-09-01T00:00:00+00:00", updated_at: "2026-09-10T08:00:00.000000+00:00" }
  ];
  const fups = [{ id: "fu-1", establishment_id: E, application_id: "app-1", due_on: "2026-10-30", completed_at: null }, { id: "fu-2", establishment_id: E, application_id: "app-3", due_on: "2026-10-10", completed_at: null }];
  const l = R.relListas(apps, grants, fups).get(E);
  eq(l.solicitudes.length, 3); eq(l.historial.length, 2);
  const s1 = l.solicitudes.find((x) => x.id === "app-1");
  eq([s1.desde, s1.hasta, s1.ong, s1.captadores, s1.fecha, s1.seg, s1.fu, s1.contacto, s1.res, s1.ver], ["2026-11-02", "2026-11-30", "AECC", 3, "2026-10-20", "2026-10-30", "fu-1", "Ana", undefined, "2026-10-20T10:00:00.000000+00:00"]);
  const s2 = l.solicitudes.find((x) => x.id === "app-2");
  eq([s2.res, s2.resFecha, s2.conc], ["aprobada", "2026-10-05", "gr-1"]);
  const s3 = l.solicitudes.find((x) => x.id === "app-3");
  eq([s3.res, s3.motivo, s3.seg, s3.resFecha], ["denegada", "Sin cupo", undefined, "2026-10-07"], "una solicitud resuelta no muestra seguimiento abierto; la fecha de decisión es la de Madrid (22:30 UTC = 00:30 del día siguiente)");
  const g2 = l.historial.find((x) => x.id === "gr-2");
  eq([g2.cancelada, g2.resFecha, g2.motivo, g2.sol], [true, "2026-09-10", "Renuncia", undefined]);
  eq(l.historial.find((x) => x.id === "gr-1").sol, "app-2");
  const base = { sols: l.solicitudes, hist: l.historial };
  const copia = () => JSON.parse(JSON.stringify(base));
  eq(R.diffRel(base, copia()), [], "sin cambios no hay operaciones (idempotente)");
  // alta con seguimiento
  let cur = copia(); cur.sols.push({ id: "new-1", desde: "2026-12-01", hasta: "2026-12-10", ong: "WWF", captadores: 2, fecha: "2026-10-23", seg: "2026-10-30" });
  eq(R.diffRel(base, cur).map((o) => o.t), ["insApp", "fuSet"]);
  // edición de campos y de seguimiento
  cur = copia(); cur.sols[0].captadores = 5; cur.sols[0].seg = "2026-11-02";
  eq(R.diffRel(base, cur).map((o) => o.t + ":" + (o.fu || o.id)), ["updApp:app-1", "fuSet:fu-1"]);
  cur = copia(); cur.sols[0].seg = "";
  eq(R.diffRel(base, cur), [{ t: "fuDone", fu: "fu-1" }]);
  // aprobar: una sola operación atómica y la concesión nueva no se inserta aparte
  cur = copia(); cur.sols[0].res = "aprobada"; cur.sols[0].conc = "c-new"; cur.hist.push({ id: "c-new", sol: "app-1", desde: "2026-11-02", hasta: "2026-11-30", ong: "AECC", captadores: 3 });
  eq(R.diffRel(base, cur).map((o) => o.t), ["approve", "fuDone"]);
  eq(R.diffRel(base, cur)[0].ver, "2026-10-20T10:00:00.000000+00:00", "aprueba con la versión leída");
  // denegar y retirar
  cur = copia(); cur.sols[0].res = "denegada"; cur.sols[0].motivo = "x";
  eq(R.diffRel(base, cur).map((o) => o.t + (o.st || "")), ["resolvedenied", "fuDone"]);
  cur = copia(); cur.sols[0].res = "retirada";
  eq(R.diffRel(base, cur)[0].st, "withdrawn");
  // cancelar, reactivar, editar y borrar concesiones
  cur = copia(); cur.hist.find((h) => h.id === "gr-1").cancelada = true; cur.hist.find((h) => h.id === "gr-1").motivo = "m";
  eq(R.diffRel(base, cur).map((o) => o.t), ["cancel"]);
  cur = copia(); delete cur.hist.find((h) => h.id === "gr-2").cancelada;
  eq(R.diffRel(base, cur).map((o) => o.t), ["reactivate"]);
  cur = copia(); cur.hist.find((h) => h.id === "gr-1").hasta = "2026-11-15";
  eq(R.diffRel(base, cur).map((o) => o.t), ["updGrant"]);
  cur = copia(); cur.hist.push({ id: "m-1", desde: "2026-12-01", hasta: "2026-12-31", ong: "A", captadores: 1 });
  eq(R.diffRel(base, cur).map((o) => o.t), ["insGrant"]);
  cur = copia(); cur.hist = cur.hist.filter((h) => h.id !== "gr-2"); cur.sols = cur.sols.filter((x) => x.id !== "app-3");
  eq(R.diffRel(base, cur).map((o) => o.t).sort(), ["delApp", "delGrant"]);
  // responsable y siguiente acción del seguimiento
  const conResp = R.relListas(apps, grants, [{ id: "fu-1", establishment_id: E, application_id: "app-1", due_on: "2026-10-30", completed_at: null, assigned_to: "user-1", next_action: "Llamar" }]).get(E);
  const sr = conResp.solicitudes.find((x) => x.id === "app-1");
  eq([sr.resp, sr.accion], ["user-1", "Llamar"]);
  cur = JSON.parse(JSON.stringify({ sols: conResp.solicitudes, hist: conResp.historial }));
  const base2 = JSON.parse(JSON.stringify(cur));
  cur.sols.find((x) => x.id === "app-1").accion = "Enviar documentación";
  eq(R.diffRel(base2, cur), [{ t: "fuSet", app: "app-1", fu: "fu-1", due: "2026-10-30", resp: "user-1", accion: "Enviar documentación" }]);
  cur = JSON.parse(JSON.stringify(base2)); cur.sols.find((x) => x.id === "app-1").resp = "";
  eq(R.diffRel(base2, cur).map((o) => o.resp), [""], "quitar el responsable actualiza el seguimiento");
  cur = JSON.parse(JSON.stringify(base2)); cur.sols = [...cur.sols, { id: "n-2", desde: "2026-12-01", fecha: "2026-10-23", seg: "2026-11-01", resp: "user-1", accion: "Visitar" }];
  eq(R.diffRel(base2, cur).filter((o) => o.t === "fuSet").map((o) => [o.resp, o.accion]), [["user-1", "Visitar"]]);
  // seguimiento del punto (sin solicitud ni concesión)
  const lp = R.relListas([], [], [
    { id: "fp-1", establishment_id: E, application_id: null, grant_id: null, due_on: "2026-11-05", completed_at: null, assigned_to: "user-9", next_action: "Revisar" },
    { id: "fp-2", establishment_id: E, application_id: null, grant_id: null, due_on: "2026-10-28", completed_at: null },
    { id: "fp-3", establishment_id: E, application_id: null, grant_id: null, due_on: "2026-10-01", completed_at: "2026-10-02T10:00:00+00:00" }
  ]).get(E);
  eq(lp.punto, { fecha: "2026-10-28", fu: "fp-2", accion: "", resp: "" }, "el seguimiento del punto es el abierto más próximo; los cerrados no cuentan");
  eq(R.diffRel({ sols: [], hist: [], punto: lp.punto }, { sols: [], hist: [], punto: undefined }), [{ t: "fuDone", fu: "fp-2" }], "marcar hecho cierra el seguimiento del punto");
  eq(R.diffRel({ sols: [], hist: [], punto: lp.punto }, { sols: [], hist: [], punto: { ...lp.punto } }), [], "sin cambios, sin operaciones");
  eq(R.diffRel({ sols: [], hist: [], punto: lp.punto }, { sols: [], hist: [], punto: { ...lp.punto, fecha: "2026-11-02" } }).map((o) => [o.t, o.due, o.app]), [["fuSet", "2026-11-02", ""]]);
  // reabrir un seguimiento cerrado (deshacer)
  const cerrado = copia(); cerrado.sols[0].seg = ""; cerrado.sols[0].fu = "fu-1";
  cur = copia(); cur.sols[0].seg = "2026-10-30"; cur.sols[0].fu = "fu-1";
  eq(R.diffRel({ sols: cerrado.sols, hist: cerrado.hist }, cur), [{ t: "fuSet", app: "app-1", fu: "fu-1", due: "2026-10-30", resp: "", accion: "" }]);
  // control de versión de los seguimientos (updated_at): se lee, se conserva y viaja en la operación
  const conVer = R.relListas(apps, grants, [{ id: "fu-1", establishment_id: E, application_id: "app-1", due_on: "2026-10-30", completed_at: null, updated_at: "2026-10-24T09:00:00+00:00" }]).get(E);
  eq(conVer.solicitudes.find((x) => x.id === "app-1").fuver, "2026-10-24T09:00:00+00:00", "la solicitud conserva la versión de su seguimiento");
  const bv = JSON.parse(JSON.stringify({ sols: conVer.solicitudes, hist: conVer.historial })), cv = JSON.parse(JSON.stringify(bv));
  cv.sols.find((x) => x.id === "app-1").seg = "2026-11-03";
  eq(R.diffRel(bv, cv).map((o) => [o.t, o.ver]), [["fuSet", "2026-10-24T09:00:00+00:00"]], "reprogramar envía la versión leída");
  cv.sols.find((x) => x.id === "app-1").seg = "";
  eq(R.diffRel(bv, cv).map((o) => [o.t, o.ver]), [["fuDone", "2026-10-24T09:00:00+00:00"]], "cerrar envía la versión leída");
  const pv = R.relListas([], [], [{ id: "fp-9", establishment_id: E, application_id: null, grant_id: null, due_on: "2026-10-28", completed_at: null, updated_at: "2026-10-24T10:00:00+00:00" }]).get(E);
  eq(R.diffRel({ sols: [], hist: [], punto: pv.punto }, { sols: [], hist: [], punto: undefined }).map((o) => [o.t, o.ver]), [["fuDone", "2026-10-24T10:00:00+00:00"]], "el seguimiento del punto también lleva su versión");
}

// Auditoría 25/10/2026, hallazgo 4: seguimientos vinculados directamente a una concesión (grant_id).
{
  const R = reglas("2026-10-25T10:00:00Z"), E = "est-1";
  const grants = [{ id: "g-1", establishment_id: E, application_id: null, status: "active", valid_from: "2026-10-01", valid_until: "2026-11-30", organization: "ONG A", capturer_count: 2, created_at: "2026-10-01T09:00:00Z", updated_at: "2026-10-01T09:00:00Z" },
                  { id: "g-2", establishment_id: E, application_id: null, status: "cancelled", cancelled_at: "2026-10-05T09:00:00Z", valid_from: "2026-10-01", valid_until: "2026-11-30", organization: "ONG B", capturer_count: 1, created_at: "2026-10-01T09:00:00Z", updated_at: "2026-10-05T09:00:00Z" }];
  const fups = [
    { id: "f-g1", establishment_id: E, application_id: null, grant_id: "g-1", due_on: "2026-10-27", completed_at: null, assigned_to: "u-1", next_action: "Revisar el cupo", updated_at: "2026-10-20T08:00:00Z" },
    { id: "f-g1b", establishment_id: E, application_id: null, grant_id: "g-1", due_on: "2026-11-10", completed_at: null, updated_at: "2026-10-20T08:00:00Z" },
    { id: "f-g1c", establishment_id: E, application_id: null, grant_id: "g-1", due_on: "2026-10-01", completed_at: "2026-10-02T10:00:00Z", updated_at: "2026-10-02T10:00:00Z" },
    { id: "f-g2", establishment_id: E, application_id: null, grant_id: "g-2", due_on: "2026-10-28", completed_at: null, updated_at: "2026-10-20T08:00:00Z" }
  ];
  const l = R.relListas([], grants, fups).get(E), h1 = l.historial.find((h) => h.id === "g-1"), h2 = l.historial.find((h) => h.id === "g-2");
  eq([h1.seg, h1.fu, h1.resp, h1.accion, h1.fuver], ["2026-10-27", "f-g1", "u-1", "Revisar el cupo", "2026-10-20T08:00:00Z"], "la concesión muestra su seguimiento abierto más próximo");
  ok(h2.seg === undefined, "el seguimiento abierto de una concesión cancelada no se muestra");
  const segs = R.seguimientosDe({ id: "c-1" }, { historial: l.historial });
  eq(segs.map((s) => [s.fecha, s.con, s.i, s.resp, s.accion]), [["2026-10-27", true, 0, "u-1", "Revisar el cupo"]], "seguimientosDe incluye los de concesión (y no los de una cancelada)");
  const ind = R.indicadores([], segs.map((s) => Object.assign({ c: { id: "c-1" } }, s)), "2026-10-25");
  ok(ind.segProximos.length === 1, "el Panel cuenta el seguimiento de la concesión");
  // si también cuelga de una solicitud, va con la solicitud y no se duplica
  const doble = R.relListas([{ id: "a-1", establishment_id: E, status: "pending", organization: "ONG A", capturer_count: 1, requested_at: "2026-10-20", updated_at: "2026-10-20T08:00:00Z" }], grants, [{ id: "f-ab", establishment_id: E, application_id: "a-1", grant_id: "g-1", due_on: "2026-10-26", completed_at: null, updated_at: "2026-10-20T08:00:00Z" }]).get(E);
  ok(doble.solicitudes[0].seg === "2026-10-26" && doble.historial.find((h) => h.id === "g-1").seg === undefined, "un seguimiento de solicitud y concesión se muestra una sola vez");
  // cerrar, reprogramar y cancelar
  const base = JSON.parse(JSON.stringify({ sols: l.solicitudes, hist: l.historial })), mut = () => JSON.parse(JSON.stringify(base));
  let cur = mut(); cur.hist[0].seg = "";
  eq(R.diffRel(base, cur), [{ t: "fuDone", fu: "f-g1", ver: "2026-10-20T08:00:00Z" }], "cerrar el seguimiento de una concesión");
  cur = mut(); cur.hist[0].seg = "2026-11-02"; cur.hist[0].accion = "Llamar";
  eq(R.diffRel(base, cur), [{ t: "fuSet", app: "", fu: "f-g1", ver: "2026-10-20T08:00:00Z", due: "2026-11-02", resp: "u-1", accion: "Llamar" }], "reprogramar el seguimiento de una concesión");
  cur = mut(); cur.hist[0].cancelada = true; cur.hist[0].resFecha = "2026-10-25";
  eq(R.diffRel(base, cur).map((o) => o.t), ["cancel", "fuDone"], "cancelar la concesión cierra su seguimiento");
  eq(R.diffRel(base, mut()), [], "sin cambios, sin operaciones");
}

// Auditoría 25/10/2026, hallazgo 2: la relectura debe coincidir con lo guardado (también cuando un 23505 se dio por bueno).
{
  const R = reglas("2026-10-25T10:00:00Z"), E = "est-1", v = R.verificaOps;
  const sol = (o) => Object.assign({ id: "s1", ver: "v", desde: "2026-11-01", hasta: "2026-11-05", ong: "A", captadores: 2, fecha: "2026-10-25" }, o);
  const con = (o) => Object.assign({ id: "g1", ver: "v", desde: "2026-11-01", hasta: "2026-11-05", ong: "A", captadores: 2, alta: "2026-10-25" }, o);
  const base = (sols, hist) => ({ sols: sols || [], hist: hist || [] });
  eq(v([{ t: "insApp", x: sol() }], base([sol()])), [], "el alta existe");
  eq(v([{ t: "insApp", x: sol() }], base([])), ["insApp"], "un alta que no aparece al releer (23505 sin fila) no se da por buena");
  eq(v([{ t: "updApp", id: "s1", x: sol({ captadores: 5 }) }], base([sol({ captadores: 2 })])), ["updApp"], "un cambio que no coincide con lo leído");
  eq(v([{ t: "updApp", id: "s1", x: sol({ captadores: 5 }) }], base([sol({ captadores: 5 })])), [], "un cambio que coincide");
  eq(v([{ t: "approve", id: "s1" }], base([sol({ res: "aprobada" })], [con({ sol: "s1" })])), [], "aprobar: solicitud aprobada y concesión enlazada");
  eq(v([{ t: "approve", id: "s1" }], base([sol({ res: "aprobada" })], [])), ["approve"], "aprobar sin concesión enlazada no se da por bueno");
  eq(v([{ t: "approve", id: "s1" }], base([sol()], [])), ["approve"], "aprobar con la solicitud aún pendiente");
  eq(v([{ t: "resolve", id: "s1", st: "denied" }], base([sol({ res: "denegada" })])), [], "denegar");
  eq(v([{ t: "resolve", id: "s1", st: "withdrawn" }], base([sol({ res: "denegada" })])), ["resolve"], "retirar no coincide con denegada");
  eq(v([{ t: "insGrant", h: con() }], base([], [])), ["insGrant"], "una concesión que no aparece");
  eq(v([{ t: "cancel", id: "g1" }], base([], [con({ cancelada: true })])), [], "cancelar");
  eq(v([{ t: "cancel", id: "g1" }], base([], [con()])), ["cancel"], "cancelar sin que figure cancelada");
  eq(v([{ t: "reactivate", id: "g1" }], base([], [con({ cancelada: true })])), ["reactivate"], "reactivar sin que se haya reactivado");
  eq(v([{ t: "delApp", id: "s1" }, { t: "delGrant", id: "g1" }], base([sol()], [con()])), ["delApp", "delGrant"], "borrar: siguen existiendo");
  eq(v([{ t: "fuSet", fu: "f", due: "2026-11-01" }, { t: "fuDone", fu: "f" }], base()), [], "los seguimientos se comprueban por relectura del punto");
}

// Auditoría 25/10/2026, hallazgo 6: coherencia entre el Panel (indicadores) y el Calendario (calendarioSemana).
{
  const R = reglas("2026-10-25T10:00:00Z"), t = R.today(), wk = R.mondayOf(t);
  const pt = (id) => ({ id });
  const recs = [
    ...R.expedientesDe(pt(1), { historial: [
      { id: "g1", desde: "2026-10-20", hasta: "2026-10-31", ong: "A", captadores: 3 },
      { id: "g2", desde: "2026-10-26", hasta: "2026-11-05", ong: "A", captadores: 5 },      /* futura: empieza mañana */
      { id: "g3", desde: "2026-10-01", hasta: "2026-10-10", ong: "B", captadores: 2 },      /* terminada */
      { id: "g4", desde: "2026-10-15", hasta: "2026-10-30", ong: "b", captadores: 4, cancelada: true, resFecha: "2026-10-18" } /* cancelada */
    ], solicitudes: [{ id: "s1", desde: "2026-10-27", hasta: "2026-10-29", ong: "C", captadores: 2, fecha: "2026-10-20" }] }),
    ...R.expedientesDe(pt(2), { historial: [{ id: "g5", desde: "2026-10-22", hasta: "2026-10-27", ong: "A", captadores: 1 }, { id: "g6", desde: "2026-10-22", hasta: "2026-10-27", ong: "a", captadores: 4 }] }) /* misma ONG con distinta caja: no se suma dos veces */
  ];
  const ind = R.indicadores(recs, [], t), sem = R.calendarioSemana(recs, [], wk, t);
  const hoy = sem.find((d) => d.d === t);
  ok(hoy.aut === ind.capacidadHoy, "captadores autorizados de hoy: Calendario " + hoy.aut + " = Panel " + ind.capacidadHoy);
  ok(ind.capacidadHoy === 3 + 4, "punto 1: 3 de «A» y punto 2: mayor de «A»/«a» (4); la terminada, la futura y la cancelada no cuentan");
  ok(hoy.nAut === ind.vigentes.length, "las concesiones vigentes de hoy: Calendario " + hoy.nAut + " = Panel " + ind.vigentes.length);
  const manana = R.calendarioSemana(recs, [], R.mondayOf(R.addDays(t, 1)), t).find((d) => d.d === R.addDays(t, 1));
  ok(manana.aut === 5 + 4 && manana.pen === 0, "mañana: la futura de la misma ONG en el mismo punto no se suma a la vigente (se toma la mayor: 5) y el otro punto aporta 4");
  const d27 = R.calendarioSemana(recs, [], R.mondayOf(R.addDays(t, 1)), t).find((d) => d.d === R.addDays(t, 2));
  ok(d27.pen === 2 && d27.aut === 5 + 4, "pasado mañana: los 2 captadores de la solicitud pendiente van aparte, no engrosan la capacidad autorizada (capacidad ≠ demanda)");
  // ninguna cifra mezcla autorizada con pendiente
  ok(sem.every((d) => d.aut >= 0 && d.pen >= 0) && !sem.some((d) => d.items.some((i) => i.e === "autorizada" && i.r.k === "sol")), "una solicitud nunca cuenta como capacidad autorizada");
  // concesión sin ninguna fecha: el Panel la cuenta como vigente y el Calendario no puede dibujarla; debe quedar señalada como incidencia
  const sinFechas = R.expedientesDe(pt(3), { historial: [{ id: "g7", ong: "D", captadores: 2 }] });
  const i2 = R.indicadores(sinFechas, [], t);
  ok(i2.vigentes.length === 1 && R.calendarioSemana(sinFechas, [], wk, t).every((d) => d.items.length === 0), "una concesión sin fechas es vigente para el Panel y no sale en el Calendario");
  ok(i2.incidencias.some((x) => /sin fechas/i.test(x.tipo)), "…y por eso se señala como incidencia");
}

console.log("Reglas de expedientes: " + n + " comprobaciones correctas.");

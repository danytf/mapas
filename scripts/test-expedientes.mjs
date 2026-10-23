// Reglas de negocio de solicitudes, concesiones y seguimientos (bloque «Reglas de expedientes» de index.html).
// Se ejecutan en un contexto aislado con un reloj falso, porque dependen de la fecha local de Madrid.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("const fmtD = ");
const b = html.indexOf("/* === Reglas de expedientes");
const c = html.indexOf("/* === fin de las reglas de expedientes === */");
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
    "\n({ today, addDays, mondayOf, daysBetween, solEstado, concEstado, estadoCalc, expedientesDe, seguimientosDe, capacidad, capacidadPorOng, incidencias, indicadores, estadoEnDia, calendarioSemana, sanitizeSharedPermitState, UMBRAL_ESTANCADA })",
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

console.log("Reglas de expedientes: " + n + " comprobaciones correctas.");

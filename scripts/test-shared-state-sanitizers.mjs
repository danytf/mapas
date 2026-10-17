import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync("index.html", "utf8");
const start = html.indexOf("const fmtD = ");
const end = html.indexOf("const today = ", start);
assert.ok(start >= 0 && end > start, "No se pudieron extraer fmtD y safeCount del HTML");
const helpers = html.slice(start, end);
const { fmtD, safeCount, sanitizeSharedPermitState } = runInNewContext(helpers + "\n({ fmtD, safeCount, sanitizeSharedPermitState })");

assert.equal(fmtD("2026-10-17"), "17/10/2026");
assert.equal(fmtD("2024-02-29"), "29/02/2024");
assert.equal(fmtD(""), "…");
assert.equal(fmtD("2026-02-31"), "—");
assert.equal(fmtD("<img src=x onerror=alert(1)>"), "—");
assert.equal(fmtD({ value: "<svg/onload=alert(1)>" }), "—");

assert.equal(safeCount(12), 12);
assert.equal(safeCount("12"), 12);
for (const value of [0, -1, 100001, true, false, "<img src=x onerror=alert(1)>", {}, null, "1e3", "12.5"]) {
  assert.equal(safeCount(value), 0, "Se rechazó un valor inválido de contador");
}

const dirtyState = sanitizeSharedPermitState({
  estado: "<img src=x onerror=alert(1)>",
  fecha: "2026-02-31",
  seguimiento: "2026-10-20",
  contacto: "C".repeat(800),
  notas: "N".repeat(6000),
  valoracion: 99,
  solicitudes: [
    { desde: "2026-10-01", hasta: "2026-10-31", captadores: "4", ong: "<svg/onload=alert(1)>", seg: "2026-10-20" },
    "<script>alert(1)</script>",
    { desde: "not-a-date", captadores: "<img>", res: "hacked" }
  ],
  historial: "not-an-array",
  arbitrary: { prototype: "pollution" }
});
assert.equal(dirtyState.estado, undefined);
assert.equal(dirtyState.fecha, undefined);
assert.equal(dirtyState.seguimiento, "2026-10-20");
assert.equal(dirtyState.contacto.length, 500);
assert.equal(dirtyState.notas.length, 5000);
assert.equal(dirtyState.valoracion, undefined);
assert.equal(dirtyState.solicitudes.length, 2);
assert.equal(dirtyState.solicitudes[0].ong, "<svg/onload=alert(1)>");
assert.equal(dirtyState.solicitudes[0].captadores, 4);
assert.equal(dirtyState.solicitudes[1].desde, undefined);
assert.equal(dirtyState.solicitudes[1].captadores, undefined);
assert.equal(dirtyState.historial, undefined);
assert.equal(dirtyState.arbitrary, undefined);
assert.equal(sanitizeSharedPermitState(["not", "an", "object"]), null);
assert.equal(sanitizeSharedPermitState({ historial: [{ desde: "2026-01-01", ong: "OK", captadores: 3, cancelada: true }] }).historial[0].cancelada, true);
assert.equal(sanitizeSharedPermitState({ solicitudes: Array.from({ length: 250 }, () => ({ ong: "OK" })) }).solicitudes.length, 200);

console.log("PRUEBAS DE SANITIZACIÓN: OK");
console.log("- Fechas ISO válidas se formatean; fechas inválidas y payloads HTML se rechazan.");
console.log("- Los contadores aceptan enteros acotados y rechazan booleanos, objetos y texto malicioso.");

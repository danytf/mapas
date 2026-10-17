import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync("index.html", "utf8");
const start = html.indexOf("const fmtD = ");
const end = html.indexOf("const today = ", start);
assert.ok(start >= 0 && end > start, "No se pudieron extraer fmtD y safeCount del HTML");
const helpers = html.slice(start, end);
const { fmtD, safeCount } = runInNewContext(helpers + "\n({ fmtD, safeCount })");

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

console.log("PRUEBAS DE SANITIZACIÓN: OK");
console.log("- Fechas ISO válidas se formatean; fechas inválidas y payloads HTML se rechazan.");
console.log("- Los contadores aceptan enteros acotados y rechazan booleanos, objetos y texto malicioso.");

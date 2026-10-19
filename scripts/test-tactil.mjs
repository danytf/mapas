// Regresión estática de los objetivos táctiles de 44 px fuera de la ficha (docs/traspaso/ROADMAP.md, auditoría visual).
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const i = html.indexOf("/* Objetivos táctiles de 44 px fuera de la ficha");
assert.ok(i >= 0, "Falta el bloque de objetivos táctiles");
const bloque = html.slice(i, html.indexOf("\n  }\n", i) + 5);
assert.ok(bloque.includes("@media (max-width: 900px), (pointer: coarse)"), "Debe aplicarse en pantallas estrechas y táctiles, no en escritorio con ratón");
for (const t of [".tools select", "#moreBtn", ".chipbtn", "#menuBtn", "#menuPanel button", "#pnClose, #admClose, #calClose", ".lg-h button", "dialog input, dialog select, dialog button", ".cal-nav button, .cal-chip", "#login input, #login button"]) {
  assert.ok(bloque.includes(t), "Falta en el bloque táctil: " + t);
}
assert.ok(/min-height: 44px|height: 44px/.test(bloque) && !/height: (3\d|4[0-3])px/.test(bloque), "Todos los tamaños del bloque deben ser de 44 px");
console.log("Objetivos táctiles: comprobaciones estáticas correctas.");

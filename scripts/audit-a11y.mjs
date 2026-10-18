#!/usr/bin/env node
// Auditoría H-05: las filas clicables del panel de estadísticas deben poder usarse con teclado.
// El manejador de clic está delegado en <tr data-k>; la accesibilidad la aporta un <button> nativo
// en la primera celda (Enter/Espacio generan click y burbujean hasta el manejador existente).
import { readFileSync } from "node:fs";

const file = process.argv[2] || "index.html";
const html = readFileSync(file, "utf8");
const failures = [];

// Cada plantilla que genera '<tr data-kind=... data-k=...>' debe abrir la primera celda con un botón.
const rowTemplates = [...html.matchAll(/'<tr data-kind="[^\n]*/g)].map((m) => m[0]);
if (rowTemplates.length < 2) failures.push(`se esperaban al menos 2 plantillas de fila clicable y hay ${rowTemplates.length}`);
for (const t of rowTemplates) {
  if (!/<td><button type="button" class="pn-rowbtn">/.test(t)) failures.push("fila clicable sin <button> en la primera celda: " + t.slice(0, 90) + "…");
}
if (/<tr[^>]*role="button"/.test(html)) failures.push('no se debe usar role="button" en <tr>: rompe la semántica de tabla');
if (!/#pnBody \.pn-rowbtn:focus-visible/.test(html)) failures.push("falta el estilo de foco visible para .pn-rowbtn");
if (!/#pnBody \.pn-rowbtn \{[^}]*cursor: pointer/.test(html)) failures.push("falta el estilo base de .pn-rowbtn");
// El manejador debe seguir delegado en tr[data-k] (si cambia, hay que revisar la accesibilidad).
if (!/closest\("tr\[data-k\]"\)/.test(html)) failures.push("el manejador delegado tr[data-k] ya no existe: revisar esta auditoría");

if (failures.length) {
  console.error("AUDITORÍA A11Y: FALLO");
  for (const f of failures) console.error("- " + f);
  process.exit(1);
}
console.log(`AUDITORÍA A11Y: OK (${rowTemplates.length} plantillas de fila clicable con botón nativo)`);

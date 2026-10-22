// Acciones masivas de la lista (Seleccionar): comprobaciones estáticas de las garantías de seguridad en index.html.
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";
const html = readFileSync(process.argv[2] || "index.html", "utf8");
const bloque = html.slice(html.indexOf("let selMode = false"), html.indexOf("let selMode = false") + 200) + html.slice(html.indexOf("async function accionSeguimiento"), html.indexOf('$("#bulkFav").addEventListener'));
for (const id of ["selBtn", "bulkBar", "bulkN", "bulkAll", "bulkNone", "bulkFecha", "bulkRep", "bulkHecho", "bulkFav", "bulkUndo", "bulkMsg"]) assert.ok(html.includes('id="' + id + '"'), "Falta #" + id);
assert.ok(/<div id="bulkBar" role="region" aria-label="[^"]+" hidden>/.test(html), "La barra debe estar oculta por defecto y con nombre accesible");
assert.ok(/aria-label", "Seleccionar " \+ c\.name/.test(html), "Cada casilla debe llevar nombre accesible");
const acc = html.slice(html.indexOf("async function accionSeguimiento"), html.indexOf('$("#bulkRep").addEventListener'));
assert.ok(acc.includes("window.confirm(") && acc.indexOf("window.confirm(") < acc.indexOf("guardaPunto("), "Debe pedirse confirmación antes de escribir");
assert.ok(acc.includes("conSeguimiento(c, modo, fecha)") && acc.includes("validIsoDate(fecha)"), "Solo se cambian puntos con seguimiento pendiente y la fecha debe ser válida");
const gp = html.slice(html.indexOf("async function guardaPunto"), html.indexOf("async function accionSeguimiento"));
assert.ok(gp.includes("savePermits(c)") && gp.includes('r === "conflict"') && gp.includes("reloadSharedPermit(c)"), "El guardado debe usar savePermits y tratar los conflictos recargando el punto");
assert.ok(/delete permits\[k\]; else permits\[k\] = previo|permits\[k\] = previo/.test(gp), "Un error debe restaurar el estado anterior en memoria");
assert.ok(html.includes("bulkUndo") && /async \(\) => \{\s*if \(bulkBusy \|\| !bulkUndo\) return;/.test(html), "Debe poder deshacerse la última acción");
assert.ok(html.includes("[...selIds].forEach((id) => { if (!vis.has(id)) selIds.delete(id); })"), "La selección debe podarse a las filas visibles");
assert.ok(!/localStorage|sessionStorage|indexedDB/.test(bloque), "Sin almacenamiento local en las acciones masivas");
console.log("Acciones masivas: confirmación previa, conflictos, deshacer y poda de la selección comprobados.");

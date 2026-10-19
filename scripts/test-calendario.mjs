// Regresión estática de la sección «Calendario semanal» (menú → Calendario semanal).
// El comportamiento real se prueba en el navegador con scripts/dev/mock-supabase.mjs (ver docs/DISENO_CALENDARIO_SEMANAL.md).
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("/* Calendario semanal: permisos de cada día");
assert.ok(a >= 0, "No se encuentra el bloque del calendario en index.html");
const fin = html.indexOf("\n})();\n", a);
const bloque = html.slice(a, fin + 7);

// Estructura accesible y entrada de menú.
assert.match(html, /<dialog id="dlgCal" aria-labelledby="calT">/, "dlgCal sin aria-labelledby");
assert.match(html, /<h2 id="calT">Calendario semanal<\/h2>/, "Falta el título del diálogo");
assert.match(html, /id="calBtn" type="button" role="menuitem">Calendario semanal<\/button>/, "Falta la opción «Calendario semanal» en el menú");
assert.ok(bloque.includes('aria-label="Semana anterior"') && bloque.includes('aria-label="Semana siguiente"'), "Los botones de semana necesitan nombre accesible");
assert.ok(bloque.includes('aria-pressed="true"') && bloque.includes("setAttribute(\"aria-pressed\""), "Los filtros de estado deben exponer aria-pressed");
assert.ok(bloque.includes('role="status"') && bloque.includes('aria-labelledby="calH'), "Rango en role=status y cada día con su encabezado");
assert.ok(bloque.includes('<span class="st">'), "Cada tarjeta debe llevar el estado también en texto (no solo color)");
assert.ok(bloque.includes('aria-hidden="true"'), "La silueta de barras es decorativa y va oculta a lectores de pantalla");

// Solo lee lo que hay en memoria; no guarda nada ni consulta la red.
assert.ok(!/localStorage|sessionStorage|indexedDB|document\.cookie|caches\.|fetch\(|\.from\(|\.rpc\(|supabase/.test(bloque), "El calendario no puede guardar en el navegador ni llamar a la red");

// Los textos que vienen de los datos pasan por esc().
for (const t of ["esc(i.c.name)", "esc(townOf(i.c))", "esc(og)", "esc(info[1])", "esc(n)", "esc(o)"]) {
  assert.ok(bloque.includes(t), "Falta escapar con esc(): " + t);
}

// Selección por provincia y reglas de cálculo.
assert.ok(bloque.includes("c.provinceId === provId"), "Debe filtrar por provincia");
assert.ok(bloque.includes("!isOut(c)"), "Los puntos quitados o archivados no deben aparecer");
assert.ok(bloque.includes('(!i.desde || i.desde <= d) && (!i.hasta || i.hasta >= d)'), "Un permiso aparece cada día entre su inicio y su fin");
assert.ok(bloque.includes('h.cancelada ? "cancelado" : "concedido"') && bloque.includes('x.res ? "denegado" : (solValid(x) ? "solicitado" : "caducado")'), "Mismos estados que el cálculo de la ficha");

// Movimiento: solo con preferencia de movimiento normal.
assert.ok(/@media \(prefers-reduced-motion: no-preference\) \{ \.cal-stack \{ animation: calGrow/.test(html), "La animación debe respetar prefers-reduced-motion");

// La vista semanal ya no está en el panel resumen.
for (const t of ['id="wkBox"', "Permisos por semana", "data-wkdate", "wkRender"]) assert.ok(!html.includes(t), "Debe haberse quitado del panel resumen: " + t);

console.log("Calendario semanal: comprobaciones estáticas correctas.");

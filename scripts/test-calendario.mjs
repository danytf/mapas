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
assert.ok(bloque.includes("aria-pressed=\"' + ver.autorizada") && bloque.includes("setAttribute(\"aria-pressed\""), "Los filtros deben exponer aria-pressed");
assert.ok(bloque.includes('role="status"') && bloque.includes('aria-labelledby="calH'), "Rango en role=status y cada día con su encabezado");
assert.ok(bloque.includes('<span class="st">'), "Cada tarjeta debe llevar el estado también en texto (no solo color)");
assert.ok(bloque.includes('aria-hidden="true"'), "La silueta de barras es decorativa y va oculta a lectores de pantalla");

// Solo lee lo que hay en memoria; no guarda nada ni consulta la red.
assert.ok(!/localStorage|sessionStorage|indexedDB|document\.cookie|caches\.|fetch\(|\.from\(|\.rpc\(|supabase/.test(bloque), "El calendario no puede guardar en el navegador ni llamar a la red");

// Los textos que vienen de los datos pasan por esc().
for (const t of ["esc(c.name)", "esc(townOf(c))", "esc(og)", "+ info[0])", "esc(o)", "esc(ongDe(s))"]) {
  assert.ok(bloque.includes(t), "Falta escapar con esc(): " + t);
}

// Selección por provincia y reglas de cálculo.
assert.ok(bloque.includes("c.provinceId !== provId"), "Debe filtrar por provincia");
assert.ok(bloque.includes("isOut(c) ||"), "Los puntos quitados o archivados no deben aparecer");
assert.ok(html.includes('const diaEnRango = (r, d) => (!r.desde || r.desde <= d) && (!r.hasta || r.hasta >= d);'), "Un permiso aparece cada día entre su inicio y su fin (extremos incluidos)");
assert.ok(bloque.includes("calendarioSemana(") && bloque.includes("expedientesDe(c, p)") && bloque.includes("seguimientosDe(c, p)"), "Usa las reglas compartidas de expedientes");
// Concesiones, solicitudes y seguimientos no se mezclan en un único total.
assert.ok(bloque.includes("captadores autorizados") && bloque.includes("captadores por aprobar") && bloque.includes("seguimiento"), "El resumen distingue autorizados, por aprobar y seguimientos");
assert.ok(bloque.includes("ver = { autorizada: true, pendiente: true, seguimiento: true, historico: false }"), "El histórico (denegadas, retiradas, canceladas) va oculto por defecto");
assert.ok(bloque.includes('data-modo="ong"') && bloque.includes("tablaOng"), "Hay vista por ONG");
assert.ok(bloque.includes("Semana pasada:") && bloque.includes("no registrado"), "La semana pasada avisa de lo que no se puede reconstruir");

// Movimiento: solo con preferencia de movimiento normal.
assert.ok(/@media \(prefers-reduced-motion: no-preference\) \{ \.cal-stack \{ animation: calGrow/.test(html), "La animación debe respetar prefers-reduced-motion");

// La vista semanal ya no está en el panel resumen.
for (const t of ['id="wkBox"', "Permisos por semana", "data-wkdate", "wkRender"]) assert.ok(!html.includes(t), "Debe haberse quitado del panel resumen: " + t);

// Auditoría 25/10/2026: las ONG se agrupan sin distinguir mayúsculas ni espacios, igual que el Panel y el Centro.
assert.ok(bloque.includes("const kOng = (x) => ongDe(x).trim().toLowerCase();") && bloque.includes("kOng(x) === ong.trim().toLowerCase()") && bloque.includes("porClave.has(kOng(y))"), "El filtro de ONG del Calendario debe usar la clave normalizada");

// Vista mensual (25/10/2026): mismas reglas que la semana (calendarioSemana), capacidad y demanda por separado, y salto a la semana del día.
assert.ok(bloque.includes('data-modo="mes"') && bloque.includes("const drawMes = ") && bloque.includes("calendarioSemana(recs, segs, ini, t)"), "La vista mensual usa calendarioSemana");
assert.ok(bloque.includes("data-dia=") && bloque.includes("wk = mondayOf(dd.dataset.dia); modo = \"dias\""), "Pulsar un día abre su semana");
assert.ok(bloque.includes("captadores autorizados") && bloque.includes("por aprobar") && bloque.includes('aria-label="' + "' + esc(lbl)"), "Cada día dice sus captadores autorizados y por aprobar por separado, con nombre accesible");
assert.ok(bloque.includes("Mes anterior") && bloque.includes("desplazaMes(+w.dataset.w)"), "La navegación avanza por meses en la vista mensual");

console.log("Calendario semanal: comprobaciones estáticas correctas.");

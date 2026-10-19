#!/usr/bin/env node
// Fase D, accesibilidad más allá del teclado (H-28 a H-35). Comprobaciones estáticas sobre index.html:
//  1. Contraste WCAG AA (1.4.3 texto 4,5:1; 1.4.11 gráficos 3:1) calculado a partir de los colores reales del fichero,
//     en modo claro y oscuro (las variables se leen de los bloques :root del propio CSS).
//  2. Nombres accesibles: diálogos con aria-labelledby válido, campos con etiqueta, botones solo-icono con aria-label,
//     etiqueta visible contenida en el nombre accesible (2.5.3).
//  3. Mensajes de estado/error en regiones aria-live (role=status|alert).
//  4. Foco de la ficha del punto y del aviso de nivel.
// No ejecuta el navegador: la verificación en navegador está descrita en docs/AUDITORIA_FASE_D_ACCESIBILIDAD_2026-10-18.md.
import { readFileSync } from "node:fs";

const file = process.argv[2] || "index.html";
const html = readFileSync(file, "utf8");
const failures = [];
const fail = (m) => failures.push(m);

// ---------- contraste ----------
const hex2 = (h) => {
  h = h.toLowerCase();
  if (h.length === 4) h = "#" + [1, 2, 3].map((i) => h[i] + h[i]).join("");
  return [1, 3, 5].map((i) => parseInt(h.slice(i, i + 2), 16));
};
const lum = ([r, g, b]) => {
  const f = (v) => { v /= 255; return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); };
  return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b);
};
const ratio = (a, b) => { const x = lum(hex2(a)), y = lum(hex2(b)); return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05); };

// Variables de los bloques :root (claro y dentro de prefers-color-scheme: dark).
const rootBlocks = [...html.matchAll(/:root\s*\{([^}]*)\}/g)].map((m) => m[1]);
const readVars = (txt) => Object.fromEntries([...txt.matchAll(/--([a-z0-9-]+):\s*(#[0-9a-fA-F]{3,6})\s*[;}]/g)].map((m) => [m[1], m[2]]));
if (rootBlocks.length < 2) fail("no se encontraron los dos bloques :root (claro y oscuro)");
const light = readVars(rootBlocks[0] || "");
const dark = { ...light, ...readVars(rootBlocks[1] || "") };

const checks = [];
const T = 4.5, G = 3;
const add = (name, fg, bg, min = T) => checks.push({ name, fg, bg, min });
for (const [mode, v] of [["claro", light], ["oscuro", dark]]) {
  const n = (s) => `${s} (${mode})`;
  for (const bg of ["panel", "bg", "ok-bg", "line", "accent-soft"]) add(n(`--fg sobre --${bg}`), v.fg, v[bg]);
  for (const bg of ["panel", "bg", "ok-bg", "line", "accent-soft"]) add(n(`--muted sobre --${bg}`), v.muted, v[bg]);
  add(n("--accent-fg sobre --accent (botón primario, número de la lista)"), v["accent-fg"], v.accent);
  add(n("--accent sobre --bg (grupo urgente)"), v.accent, v.bg);
  add(n("--accent sobre --panel"), v.accent, v.panel);
  add(n("--warn sobre --warn-bg (etiquetas, KPI de alerta, avisos)"), v.warn, v["warn-bg"]);
  add(n("--warn sobre --panel (avisos, +XP)"), v.warn, v.panel);
  add(n("--ok sobre --ok-soft (KPI destacado)"), v.ok, v["ok-soft"]);
  add(n("--panel sobre --warn (chip de revisión pulsado)"), v.panel, v.warn);
}
// Colores fijos de la cabecera, la ficha del punto y los estados.
add("cabecera: #9fb0c6 sobre --ink-2", "#9fb0c6", light["ink-2"]);
add("cabecera: #fff sobre --ink-2", "#fff", light["ink-2"]);
add("toast: #fff sobre --ink", "#fff", light.ink);
add("toast: #fff sobre --ink (oscuro)", "#fff", dark.ink);
add("insignia gamificación: #e8d9a8 sobre #1f2a3b", "#e8d9a8", "#1f2a3b");
add("insignia gamificación: #e8d9a8 sobre #2a2412", "#e8d9a8", "#2a2412");
add("indicador «Seguimientos» (claro): #ffd9de sobre --accent", "#ffd9de", light.accent);
add("ficha: botón #fff sobre #c8102e", "#fff", "#c8102e");
add("ficha: botón #fff sobre #9f0c24 (hover)", "#fff", "#9f0c24");
add("ficha: #fff sobre #0f1722 (Cómo llegar)", "#fff", "#0f1722");
for (const bg of ["#ffffff", "#f3f5f8", "#fafbfc", "#dcfce7"]) add(`ficha: #b3261e sobre ${bg}`, "#b3261e", bg);
add("ficha: #14532d sobre #dcfce7", "#14532d", "#dcfce7");
add("ficha: #14532d sobre #fff", "#14532d", "#fff");
for (const bg of ["#ffffff", "#f2f6f5"]) add(`ficha: #5b726c sobre ${bg}`, "#5b726c", bg);
add("ficha: #697384 sobre #fafbfc", "#697384", "#fafbfc");
add("ficha: #8a1020 sobre #fff", "#8a1020", "#fff");
add("ficha: #5b6574 sobre #fff", "#5b6574", "#fff");
add("ficha: #c8102e sobre #fff", "#c8102e", "#fff");
add("ficha: #7a2a00 sobre #fff", "#7a2a00", "#fff");
add("ficha: #8a5a00 sobre #fff3d6 (etiqueta)", "#8a5a00", "#fff3d6");
add("progreso: #177a40 sobre #fff (em.up)", "#177a40", light.panel);
add("progreso: #b42318 sobre #fff (em.dn)", "#b42318", light.panel);
add("progreso: #8a5a00 sobre #fff1c2 (chip activo)", "#8a5a00", "#fff1c2");
// Gráficos que transmiten información (1.4.11, 3:1): estrellas de valoración.
// La ficha (panel lateral) sigue el modo claro/oscuro del sistema: estrellas y color de error son tokens con variante oscura.
if (!/#ficha \.stars button \{[^}]*color: var\(--star-off\)/.test(html) || !/#ficha \.stars button\.on \{ color: var\(--star-on\)/.test(html)) fail("las estrellas de la ficha deben usar --star-off / --star-on");
for (const [mode, v] of [["claro", light], ["oscuro", dark]]) {
  if (!v["star-off"] || !v["star-on"] || !v.err) { fail("faltan --star-off, --star-on o --err en modo " + mode); continue; }
  add(`estrella sin marcar sobre --panel (gráfico, ${mode})`, v["star-off"], v.panel, G);
  add(`estrella marcada sobre --panel (gráfico, ${mode})`, v["star-on"], v.panel, G);
  add(`--err (errores de la ficha) sobre --panel (${mode})`, v.err, v.panel);
}
// Modo oscuro: sobreescrituras de la gamificación.
const darkOv = (sel) => html.match(new RegExp(sel.replace(/[.#]/g, "\\$&") + " \\{ color: (#[0-9a-f]{6}); \\}"))?.[1];
const up = darkOv("#dlgGam em.up"), dn = darkOv("#dlgGam em.dn");
if (!up || !dn) fail("faltan las sobreescrituras de #dlgGam em.up / em.dn en modo oscuro");
else { add("oscuro: em.up sobre --panel", up, dark.panel); add("oscuro: em.dn sobre --panel", dn, dark.panel); }
const mxVar = /#dlgGam \.ms \.mx \{[^}]*color: var\(--warn\)/.test(html) && /#dlgGam \.lgl li b \{[^}]*color: var\(--warn\)/.test(html);
if (!/.kpi.al span {[^}]*opacity: .95/.test(html) || !/.kpi.hl span {[^}]*opacity: .95/.test(html)) fail("los rótulos de .kpi.al/.kpi.hl deben tener opacity .95 o más (con .85 dan 3,98:1)");
if (!mxVar) fail("+XP y registro de XP deben usar var(--warn) (en modo oscuro #8a5a00 sobre el panel oscuro da 2,9:1)");
if (!/#dlgGam \.alc\.full \{[^}]*var\(--warn-bg\)/.test(html)) fail("#dlgGam .alc.full no debe usar un degradado claro fijo (texto claro sobre fondo claro en modo oscuro)");
if (!/\.kstrip \.k\.hot \{[^}]*\}/.test(html)) fail("falta .kstrip .k.hot");
// Ficha del punto: sus colores deben quedar fijados a claros aunque el sistema esté en oscuro.
// La ficha ya no es una burbuja de Leaflet siempre blanca: es un panel (#ficha) con los tokens de la app, que sí cambian en oscuro.
// La etiqueta mínima sobre el pin sí va sobre la burbuja blanca de Leaflet, con colores fijos oscuros.
if (!/\.leaflet-popup-content \{[^}]*color: #141b26/.test(html)) fail("la etiqueta mínima del mapa debe fijar un texto oscuro sobre la burbuja blanca de Leaflet");
if (/#ficha[^{]*\{[^}]*background: #fff/i.test(html)) fail("el panel de la ficha no debe fijar un fondo blanco (rompe el modo oscuro)");
add("etiqueta del mapa: #141b26 sobre #fff", "#141b26", "#ffffff");
add("etiqueta del mapa: #5c6779 sobre #fff", "#5c6779", "#ffffff");
if (!/input::placeholder, textarea::placeholder \{ color: var\(--muted\); opacity: 1; \}/.test(html)) fail("falta el color de ::placeholder con contraste (el predeterminado #757575 da 4,2:1 sobre --bg y menos en oscuro)");
for (const [mode, v] of [["claro", light], ["oscuro", dark]]) {
  add(`placeholder (--muted) sobre --bg (${mode})`, v.muted, v.bg);
  add(`placeholder (--muted) sobre --panel (${mode})`, v.muted, v.panel);
}

// Categorías: el texto del número de la lista se elige entre blanco y oscuro con la función real inkOn.
const inkSrc = html.match(/const inkOn = [\s\S]*?\n\};/)?.[0];
const tiposSrc = html.match(/const TIPOS = \[([\s\S]*?)\];/)?.[1];
if (!inkSrc) fail("falta la función inkOn (texto legible sobre el color de categoría)");
else if (!/color:' \+ inkOn\(colorOf\(c\)\)/.test(html)) fail("el número de la lista no usa inkOn");
if (inkSrc && tiposSrc) {
  const inkOn = new Function(inkSrc + "; return inkOn;")();
  for (const m of tiposSrc.matchAll(/\[(\d+), "([^"]+)", "(#[0-9a-f]{6})"\]/gi)) {
    const ink = inkOn(m[3]);
    add(`categoría ${m[2]} ${m[3]}: número ${ink} sobre el color`, ink, m[3]);
  }
}
// Estados de permiso (etiqueta de la lista): el color de texto lo decide el código.
const estados = [...(html.match(/const ESTADOS = \[([^\n]*)\];/)?.[1] || "").matchAll(/\["(\w+)", "([^"]+)", "(#[0-9a-f]{6})"\]/gi)];
const darkText = html.match(/\[("concedido"[^\]]*)\]\.includes\(estadoOf\(c\)\)/)?.[1] || "";
if (estados.length < 6) fail("no se leyeron los 6 estados de ESTADOS");
for (const [, k, nombre, col] of estados) {
  if (k === "sin") continue;
  add(`etiqueta de estado ${nombre} ${col}: ${darkText.includes('"' + k + '"') ? "#111" : "#fff"}`, darkText.includes('"' + k + '"') ? "#111111" : "#ffffff", col);
}
// Barras del calendario semanal: color de texto y todos los colores del fondo.
for (const m of html.matchAll(/\.wk-bar\.s-(\w+) \{ background: ([^;]+); color: (#[0-9a-f]{3,6});/gi)) {
  for (const bg of m[2].match(/#[0-9a-f]{6}/gi) || []) add(`calendario ${m[1]}: ${m[3]} sobre ${bg}`, m[3], bg);
}

for (const c of checks) {
  if (!c.fg || !c.bg) { fail(`${c.name}: color no resuelto`); continue; }
  const r = ratio(c.fg, c.bg);
  if (r < c.min) fail(`contraste ${r.toFixed(2)}:1 < ${c.min}:1 en ${c.name} (${c.fg} sobre ${c.bg})`);
}

// ---------- nombres accesibles y estructura ----------
if (!/<html lang="es">/.test(html)) fail('<html> sin lang="es"');
for (const m of html.matchAll(/<dialog\b([^>]*)>/g)) {
  const id = m[1].match(/id="([^"]+)"/)?.[1];
  const lb = m[1].match(/aria-labelledby="([^"]+)"/)?.[1];
  if (!lb) fail(`<dialog id="${id}"> sin aria-labelledby`);
  else if (!new RegExp(`id="${lb}"`).test(html)) fail(`<dialog id="${id}">: aria-labelledby="${lb}" no existe`);
}
if (!/<div id="login" role="dialog" aria-modal="true" aria-labelledby="lgTitle">/.test(html)) fail("el acceso perdió role=dialog/aria-modal/aria-labelledby");
if (!/<div id="map" role="region" aria-label=/.test(html)) fail("el mapa tiene aria-label sin role (los div sin rol no admiten nombre)");

// Campos de formulario: aria-label propio o <label> que los envuelve, o label[for].
for (const m of html.matchAll(/<(input|select|textarea)\b([^>]*)>/g)) {
  const attrs = m[2];
  if (/type="(hidden|checkbox)"/.test(attrs) && !/type="checkbox"/.test(attrs)) continue;
  if (/aria-label="[^"]+"/.test(attrs)) continue;
  const before = html.slice(Math.max(0, m.index - 600), m.index);
  const open = before.lastIndexOf("<label"), close = before.lastIndexOf("</label>");
  const id = attrs.match(/id="([^"]+)"/)?.[1];
  const forLabel = id && new RegExp(`<label[^>]*for="${id}"`).test(html);
  if (open > close || forLabel) continue;
  fail(`campo sin etiqueta accesible: <${m[1]}${attrs.slice(0, 70)}>`);
}
// 2.5.3: una etiqueta visible no puede tener un aria-label que no la contenga.
if (/Dirección postal del establecimiento<input[^>]*aria-label="Dirección postal corregida"/.test(html)) fail('«Dirección postal del establecimiento» tiene aria-label="Dirección postal corregida" (el nombre accesible no contiene el texto visible)');

// Botones que solo tienen un símbolo: deben llevar aria-label.
for (const m of html.matchAll(/<button\b([^>]*)>(&times;|×|★|&#8249;|&#8250;|<span><\/span><span><\/span><span><\/span>)<\/button>/g)) {
  if (!/aria-label="[^"]+"/.test(m[1])) fail("botón solo-icono sin aria-label: " + m[0].slice(0, 80));
}
for (const m of html.matchAll(/'<button[^']*' \+ (?:[^']*)'"[^']*>(?:★|&#8249;|&#8250;)<\/button>'/g)) if (!/aria-label/.test(m[0])) fail("botón solo-icono sin aria-label");

// Valoración con estrellas: grupo de botones con aria-pressed (role=radiogroup exigiría hijos role=radio).
if (/role="radiogroup"/.test(html)) fail('role="radiogroup" sin role="radio" en los hijos (valoración)');
if (!/class="stars" role="group"/.test(html) || !/aria-pressed="false" aria-label="' \+ n \+/.test(html) || !/b\.setAttribute\("aria-pressed", \+b\.dataset\.n === val\)/.test(html)) fail("las estrellas de valoración no exponen su estado con aria-pressed");

// Mensajes de estado y error en regiones aria-live.
for (const [name, re] of [
  ["#status", /<div class="status" id="status" role="status">/],
  ["#n-msg (diálogo de alta)", /id="n-msg" role="status"/],
  ["#lgErr (acceso)", /id="lgErr" role="alert"/],
  [".s-msg (solicitudes)", /class="s-msg fi-msg" role="status"/],
  [".h-msg (concesiones)", /class="h-msg fi-msg" role="status"/],
  [".ef (estado del permiso)", /class="ef" aria-live="polite"/],
  [".saved (ficha)", /class="saved" role="status"/],
  [".lmsg (ubicación)", /class="lmsg" role="status"/],
  ["#toast", /t\.setAttribute\("role", "status"\)/],
]) if (!re.test(html)) fail(`${name} no es una región aria-live (role=status/alert)`);

// Foco: ficha del punto (abierta con Intro desde la lista) y aviso de nivel.
if (!/popupFromKey = li; highlight\(c\.id, true\)/.test(html)) fail("la lista no marca la apertura de la ficha por teclado (popupFromKey)");
if (!/function openFicha\(c\)[\s\S]{0,1200}\.fi-title"\)\.focus\(/.test(html)) fail("al abrir la ficha con el teclado el foco no pasa a ella");
if (!/id="ficha" role="complementary" aria-label="Ficha del punto"/.test(html)) fail("la ficha no expone una región con nombre (role=complementary y aria-label)");
if (!/fichaEl\.addEventListener\("keydown", \(ev\) => \{ if \(ev\.key === "Escape"\) map\.closePopup\(\)/.test(html)) fail("la ficha no se cierra con Escape cuando el foco está dentro");
if (!/function closeFicha\(\)[\s\S]{0,700}ret\.focus\(/.test(html)) fail("al cerrar la ficha el foco no vuelve al elemento de la lista");
if (!/class="ptabs" role="tablist"/.test(html) || !/e\.key === "ArrowRight"/.test(html) || !/b\.tabIndex = on \? 0 : -1/.test(html)) fail("las pestañas de la ficha deben seguir el patrón de pestañas (tablist, flechas y tabindex itinerante)");
if (!/aria-label="Cerrar la ficha"/.test(html)) fail("el botón de cerrar la ficha necesita nombre accesible");
if (!/o\.addEventListener\("keydown", \(ev\) => \{ if \(ev\.key === "Escape"\) close\(\); \}\)/.test(html)) fail("el aviso de nivel (alertdialog) no se cierra con Escape");
if (!/const prev = document\.activeElement;[\s\S]{0,700}prev\.focus\(\)/.test(html)) fail("el aviso de nivel no devuelve el foco al cerrarse");

if (failures.length) {
  console.error("A11Y FASE D: FALLO (" + failures.length + ")");
  for (const f of failures) console.error("- " + f);
  process.exit(1);
}
console.log(`A11Y FASE D: OK (${checks.length} pares de contraste en claro y oscuro, diálogos, etiquetas, regiones aria-live y foco)`);

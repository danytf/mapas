// Regresión estática de la ficha del punto en panel lateral (docs/DISENO_FICHA_PUNTO.md).
// El comportamiento real se prueba en el navegador con scripts/dev/mock-supabase.mjs (que ya admite escribir el estado compartido).
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("function fichaFor(c, pos) {");
assert.ok(a >= 0, "No se encuentra fichaFor");
const fin = html.indexOf("  return el;\n}\n", a);
const ficha = html.slice(a, fin);

// Contenedor: región con nombre dentro de <main>, oculta por defecto; la burbuja del mapa es solo una etiqueta.
assert.match(html, /<div id="map"[^>]*><\/div>\s*<div id="ficha" role="complementary" aria-label="Ficha del punto" hidden><\/div>\s*<\/main>/, "Falta el panel #ficha dentro de main");
const popup = html.slice(html.indexOf("function popupFor(c) {"), html.indexOf("function fichaFor"));
assert.ok(popup.includes('b.className = "mini"') && popup.includes("b.dataset.cid") && !/input|button|textarea/.test(popup), "La burbuja del mapa debe ser una etiqueta sin controles");
assert.ok(html.includes("m.bindPopup(() => popupFor(c, cache[c.id]), { closeButton: false, closeOnClick: false"), "La burbuja no debe cerrarse al pulsar el mapa (se perderían ediciones) ni llevar su propio botón de cerrar");
assert.ok(/map\.on\("popupopen"[\s\S]{0,400}openFicha\(c\)/.test(html) && /map\.on\("popupclose"[\s\S]{0,200}fichaToken/.test(html), "La ficha debe seguir el ciclo de vida del popup (abrir y cerrar)");
assert.ok(html.includes("const t = fichaToken; setTimeout(() => { if (t === fichaToken) closeFicha(); }, 0);"), "Cambiar de punto no debe cerrar y reabrir el panel");
assert.ok(/main\.fi-open \{ grid-template-columns: 408px 1fr 440px; \}/.test(html), "El panel debe ser una tercera columna que no tape el mapa");

// Contenido y orden: cabecera, estado, valoración, contacto y notas siempre visibles; después la ubicación (desplegable).
const orden = ["fi-top", "fi-state", "fi-rate", "fi-contact", "fi-loc", "fi-foot"].map((k) => ficha.indexOf('class="' + k));
assert.ok(orden.every((n, i) => n > 0 && (i === 0 || n > orden[i - 1])), "El orden de la ficha debe ser cabecera, estado, valoración, contacto, ubicación y pie");
assert.ok(ficha.includes('class="fi-addrrow"') && ficha.includes("Cómo llegar"), "La dirección y «Cómo llegar» van en la cabecera");
assert.ok(ficha.includes('class="fi-flag"') && ficha.includes("f-rev"), "El aviso de ubicación por revisar y su acción van en la cabecera");
assert.ok(ficha.includes("Próximo seguimiento") === true && html.includes("(toca ya)"), "El próximo seguimiento debe verse siempre");

// Todo lo que usan los manejadores sigue existiendo (se localizan por clase).
for (const k of ["pform", "ef", "pinfo", "stars", "sv", "f-contacto", "f-notas", "f-centro", "fi-loc", "l-in", "l-address", "l-save-location", "l-mv", "l-cp", "lmsg", "l-gm", "f-save", "f-inact", "f-arch", "f-del", "f-rev", "saved"]) {
  assert.ok(ficha.includes(k), "Falta la clase " + k + " que usan los manejadores");
}
for (const k of ["setCommitControlsDisabled", "savePermits(c)", "gamPermit(c, previous.permit)", "gamRev(c)", "saveInactive()", "saveRemoved()", "reloadSharedPermit(c)", "dirty(false)", "setLoc(c, r[0], r[1], address)"]) {
  assert.ok(html.slice(a).includes(k), "Se perdió la lógica: " + k);
}
assert.ok(ficha.includes('class="fi-menu"') && ficha.indexOf("f-inact") > ficha.indexOf('class="fi-menu"') && ficha.indexOf("f-del") > ficha.indexOf('class="fi-menu"'), "Desactivar y Quitar van dentro de «Más acciones»");
assert.ok(ficha.includes('class="f-save">Guardar cambios') && ficha.indexOf("f-save") < ficha.indexOf('class="fi-more"'), "Guardar es la acción primaria y va antes de «Más acciones»");

// Accesibilidad: pestañas, cierre, foco y Escape.
// Los expedientes se gestionan solo en el Centro de permisos: la ficha no tiene formularios ni botones de solicitudes, concesiones o seguimientos.
for (const k of ["s-add", "h-add", "s-list", "h-list", "s-form", "h-form", "ptabs", "role=\"tablist\"", "f-segpunto", "paintSols", "paintHist", "askReason", "fichaTabPedida", "ejecutaOpsRel"]) {
  assert.ok(!html.slice(a, fin).includes(k), "La ficha ya no debe tener: " + k);
}
assert.ok(ficha.includes('<details class="fi-loc"><summary>Ubicación y dirección</summary>'), "La ubicación va en un desplegable con su summary");
assert.ok(ficha.includes('class="f-centro">Gestionar permisos en el Centro') && ficha.includes('new CustomEvent("centro:abrir", { detail: { punto: c, vista: "sol", est: "todas" } })'), "El botón abre el Centro de permisos filtrado por este punto");
assert.ok(ficha.includes('document.addEventListener("permisos:cambio", alCambiar)') && ficha.includes("paintEf()"), "Si el Centro cambia el punto, el resumen de la ficha se repinta con lo confirmado");
// El guardado de la ficha parte de lo confirmado en memoria: no reescribe solicitudes, concesiones ni seguimientos (una ficha abierta no puede pisar lo hecho en el Centro).
const iCommit = ficha.indexOf("const commit = async () => {"), commitFicha = ficha.slice(iCommit, ficha.indexOf('el.querySelectorAll(".stars button")', iCommit));
assert.ok(commitFicha.includes("Object.assign({}, permits[permitKey(c)] || {}, { contacto:") && !/historial: hist|solicitudes = sols|sols\.forEach|hist\.forEach/.test(commitFicha), "Guardar en la ficha solo cambia contacto, notas y valoración"); 
assert.ok(ficha.includes('aria-label="Cerrar la ficha"') && ficha.includes('class="fi-title" tabindex="-1"'), "Cerrar con nombre accesible y título enfocable");
assert.ok(html.includes('fichaEl.addEventListener("keydown", (ev) => { if (ev.key === "Escape") map.closePopup(); });'), "Escape cierra la ficha");

// Estilo: tokens de la app (modo claro y oscuro), sin fondos fijos, estado con borde y texto, 44 px en táctil.
const css = html.slice(html.indexOf("  /* Ficha del punto: panel lateral derecho"), html.indexOf("    .fi-menu button { height: 46px; }"));
assert.ok(!/background(-color)?: #[0-9a-f]{3,6}/i.test(css), "El panel no debe fijar fondos de color (rompe el modo oscuro)");
assert.ok(/\.ef \{[^}]*border-left: 5px solid var\(--st/.test(css) && /s-concedido \{ --st: var\(--st-concedido\)/.test(css), "El estado se codifica con borde izquierdo y color de estado");
assert.ok(/@media \(max-width: 900px\), \(pointer: coarse\)/.test(css) && /\.fi-close, \.fi-fav \{ width: 44px; height: 44px; \}/.test(css), "Objetivos táctiles de 44 px");
assert.ok(/#ficha \{ position: fixed; inset: 54px 0 0 0;/.test(css), "En pantallas estrechas la ficha es una hoja a pantalla completa");
assert.ok(/prefers-reduced-motion: no-preference\) \{ #ficha:not\(\[hidden\]\) \{ animation/.test(css), "La entrada del panel solo anima con movimiento permitido");
assert.ok(!/font-size: (1[01](\.5)?|12\.5|13|13\.5|19)px/.test(css), "Los tamaños de letra de la ficha siguen la escala de DESIGN.md (12, 14, 17)");

// Cambiar municipio (solo administradores): solo si hay administrador y provincia, solo entre los municipios de su provincia,
// con confirmación, escribiendo únicamente municipality_id (la base ya exige ser administrador) y sin guardar nada en el navegador.
assert.ok(ficha.includes("(admin && c.provinceId ? '<div class=\"loc-muni\">"), "El bloque «Municipio» solo se pinta para administradores");
assert.ok(html.includes('.from("municipalities").select("id, name", opts).eq("province_id", provId), "id")') && html.includes("municipiosConId(c.provinceId)"), "Los municipios ofrecidos son solo los de la provincia del punto");
assert.ok(ficha.includes('addEventListener("toggle", (e) => { if (e.target.open) { if (cargaMuni) cargaMuni(); if (cargaCp) cargaCp(); } })'), "Los municipios y el código postal se cargan al abrir el desplegable de ubicación, no al abrir cada ficha");
assert.ok(ficha.includes('update({ municipality_id: sel.value }).eq("id", c.databaseId).select("id")'), "Solo se escribe municipality_id");
assert.ok(ficha.includes("El cambio afecta a todos los usuarios.") && ficha.includes("window.confirm("), "El cambio pide confirmación");
assert.ok(ficha.includes("res.data.length !== 1") && ficha.includes('friendlyError(res.error, "No se pudo cambiar el municipio.")'), "Un rechazo de la base se explica y no cambia nada en pantalla");
assert.ok(/class="lmsg m-msg" role="status"/.test(ficha), "El resultado se anuncia en una región de estado");
const muni = html.slice(html.indexOf("const mb = el.querySelector(\".loc-muni\");"), html.indexOf("const mb = el.querySelector(\".loc-muni\");") + 3500);
assert.ok(!/localStorage|sessionStorage|indexedDB|document\.cookie/.test(muni), "El cambio de municipio no guarda nada en el navegador");

// Código postal (solo administradores): se lee solo al abrir la pestaña Ubicación, solo se escribe postal_code, 5 cifras, sin guardar nada en el navegador.
const cpBloque = html.slice(html.indexOf('const cb = el.querySelector(".loc-cp");'), html.indexOf('const rv = el.querySelector(".f-rev");'));
assert.ok(cpBloque.length > 500, "No se encuentra el manejador del código postal");
assert.ok(ficha.includes("(admin && c.databaseId ? '<div class=\"loc-cp\">"), "El bloque «Código postal» solo se pinta para administradores");
assert.ok(cpBloque.includes('update({ postal_code: nuevo }).eq("id", c.databaseId).select("id")'), "Solo se escribe postal_code");
assert.ok(cpBloque.includes("/^\\d{5}$/.test(inp.value.trim())"), "El código postal debe tener 5 cifras");
assert.ok(cpBloque.includes("res.data.length !== 1") && cpBloque.includes('friendlyError(res.error, "No se pudo guardar el código postal.")'), "Un rechazo de la base se explica");
assert.ok(!/localStorage|sessionStorage|indexedDB|document\.cookie/.test(cpBloque), "El código postal no guarda nada en el navegador");

// Las acciones de administrador (municipio y código postal) tienen aspecto de botón: relleno de acento activo y apagado desactivado, ambos con tokens.
assert.ok(/#ficha \.loc-muni \.lb, #ficha \.loc-cp \.lb \{[^}]*background: var\(--accent-soft\); color: var\(--accent\)/.test(css), "Los botones de municipio y código postal usan el fondo tintado de acento (el relleno pleno es de «Guardar cambios»)");
assert.ok(/#ficha \.loc-muni \.lb:disabled, #ficha \.loc-cp \.lb:disabled \{[^}]*opacity: 1; background: var\(--bg\); color: var\(--muted\)/.test(css), "Desactivados se apagan sin parecer un campo de texto");

// Sin restos de los formularios de permisos en los estilos, y el desplegable de ubicación y el botón del Centro tienen los suyos (con 44 px en táctil).
assert.ok(!/\.fi-tabs|\.ptabs|\.row3|\.aform|ul\.fi-list/.test(css), "Los estilos de las pestañas y formularios de permisos de la ficha ya no deben existir");
assert.ok(/#ficha details\.fi-loc \{/.test(css) && /#ficha \.fi-gestion button \{ width: 100%; \}/.test(css), "El desplegable de ubicación y el botón del Centro tienen estilo");

console.log("Ficha del punto: comprobaciones estáticas correctas.");

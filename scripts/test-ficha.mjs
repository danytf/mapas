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

// Contenido y orden: cabecera, estado, valoración, contacto y notas siempre visibles; después las pestañas.
const orden = ["fi-top", "fi-state", "fi-rate", "fi-contact", "fi-tabs", "fi-foot"].map((k) => ficha.indexOf('class="' + k));
assert.ok(orden.every((n, i) => n > 0 && (i === 0 || n > orden[i - 1])), "El orden de la ficha debe ser cabecera, estado, valoración, contacto, pestañas y pie");
assert.ok(ficha.includes('class="fi-addrrow"') && ficha.includes("Cómo llegar"), "La dirección y «Cómo llegar» van en la cabecera");
assert.ok(ficha.includes('class="fi-flag"') && ficha.includes("f-rev"), "El aviso de ubicación por revisar y su acción van en la cabecera");
assert.ok(ficha.includes("Próximo seguimiento") === true && html.includes("(toca ya)"), "El próximo seguimiento debe verse siempre");

// Todo lo que usan los manejadores sigue existiendo (se localizan por clase).
for (const k of ["pform", "ef", "pinfo", "stars", "sv", "f-contacto", "f-notas", "s-list", "h-list", "s-form", "h-form", "s-desde", "s-hasta", "s-n", "s-ong", "s-seg", "s-add", "s-cancel", "s-msg", "h-desde", "h-hasta", "h-n", "h-ong", "h-add", "h-cancel", "h-msg", "l-in", "l-address", "l-save-location", "l-mv", "l-cp", "lmsg", "l-gm", "f-save", "f-inact", "f-arch", "f-del", "f-rev", "saved"]) {
  assert.ok(ficha.includes(k), "Falta la clase " + k + " que usan los manejadores");
}
for (const k of ["setCommitControlsDisabled", "savePermits(c)", "gamPermit(c, previous.permit)", "gamRev(c)", "saveInactive()", "saveRemoved()", "reloadSharedPermit(c)", "dirty(false)", "setLoc(c, r[0], r[1], address)"]) {
  assert.ok(html.slice(a).includes(k), "Se perdió la lógica: " + k);
}
assert.ok(ficha.includes('class="fi-menu"') && ficha.indexOf("f-inact") > ficha.indexOf('class="fi-menu"') && ficha.indexOf("f-del") > ficha.indexOf('class="fi-menu"'), "Desactivar y Quitar van dentro de «Más acciones»");
assert.ok(ficha.includes('class="f-save">Guardar cambios') && ficha.indexOf("f-save") < ficha.indexOf('class="fi-more"'), "Guardar es la acción primaria y va antes de «Más acciones»");

// Accesibilidad: pestañas, cierre, foco y Escape.
assert.ok(ficha.includes('role="tablist"') && ficha.includes('setAttribute("role", "tab")') && ficha.includes("e.key === \"ArrowRight\"") && ficha.includes("b.tabIndex = on ? 0 : -1"), "Pestañas con patrón completo (flechas y tabindex itinerante)");
assert.ok(ficha.includes('aria-label="Cerrar la ficha"') && ficha.includes('class="fi-title" tabindex="-1"'), "Cerrar con nombre accesible y título enfocable");
assert.ok(html.includes('fichaEl.addEventListener("keydown", (ev) => { if (ev.key === "Escape") map.closePopup(); });'), "Escape cierra la ficha");

// Estilo: tokens de la app (modo claro y oscuro), sin fondos fijos, estado con borde y texto, 44 px en táctil.
const css = html.slice(html.indexOf("  /* Ficha del punto: panel lateral derecho"), html.indexOf("    .fi-menu button { height: 46px; }"));
assert.ok(!/background(-color)?: #[0-9a-f]{3,6}/i.test(css), "El panel no debe fijar fondos de color (rompe el modo oscuro)");
assert.ok(/\.ef \{[^}]*border-left: 5px solid var\(--st/.test(css) && /s-concedido \{ --st: #22c55e/.test(css), "El estado se codifica con borde izquierdo y color de estado");
assert.ok(/@media \(max-width: 900px\), \(pointer: coarse\)/.test(css) && /\.fi-close \{ width: 44px; height: 44px; \}/.test(css), "Objetivos táctiles de 44 px");
assert.ok(/#ficha \{ position: fixed; inset: 54px 0 0 0;/.test(css), "En pantallas estrechas la ficha es una hoja a pantalla completa");
assert.ok(/prefers-reduced-motion: no-preference\) \{ #ficha:not\(\[hidden\]\) \{ animation/.test(css), "La entrada del panel solo anima con movimiento permitido");
assert.ok(!/font-size: (1[01](\.5)?|12\.5|13|13\.5|19)px/.test(css), "Los tamaños de letra de la ficha siguen la escala de DESIGN.md (12, 14, 17)");

console.log("Ficha del punto: comprobaciones estáticas correctas.");

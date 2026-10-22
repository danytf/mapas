// Regresión estática de la cabecera (indicadores agrupados), los filtros plegables y el botón de acceso en modo oscuro.
// El comportamiento real se prueba en el navegador con scripts/dev/mock-supabase.mjs.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(process.argv[2] || "index.html", "utf8");

// Filtros: provincia, municipio y estado siempre a la vista; el resto, plegado y accesible.
const tools = html.slice(html.indexOf('<div class="tools">'), html.indexOf('<div class="srow">'));
const plegado = tools.slice(tools.indexOf('<div id="moreF" hidden>'));
assert.ok(plegado.length > 0, "Falta el bloque plegable #moreF (oculto por defecto)");
const antes = tools.slice(0, tools.indexOf('<div id="moreF"'));
for (const id of ["q", "provincia", "muni", "permiso", "moreBtn"]) assert.ok(antes.includes('id="' + id + '"'), "Debe estar siempre a la vista: " + id);
for (const id of ["tipo", "valor", "orden", "cadRow", "cadena", "subRow", "subtipo"]) assert.ok(plegado.includes('id="' + id + '"'), "Debe estar dentro de «Más filtros»: " + id);
assert.match(html, /id="moreBtn" type="button" aria-expanded="false" aria-controls="moreF"/, "El botón necesita aria-expanded y aria-controls");
assert.ok(html.includes("#moreF[hidden] { display: none; }"), "El atributo hidden debe seguir funcionando con display:grid");
assert.ok(html.includes('["#tipo", "#valor", "#cadena", "#subtipo"].filter((s) => $(s).value).length + ($("#orden").selectedIndex > 0 ? 1 : 0)'), "El contador debe contar los filtros ocultos activos");
assert.ok(/function renderList\(\) \{[\s\S]*?syncMore\(\);/.test(html), "renderList debe actualizar el contador de filtros");

// Cabecera: indicadores operativos y de progreso en grupos con nombre; las reglas responsive apuntan al grupo operativo.
assert.ok(html.includes('class="kg kg-op" role="group" aria-label="Estado de la operación"') && html.includes('class="kg kg-gam" role="group" aria-label="Mi progreso"'), "Los indicadores deben ir en dos grupos con nombre");
for (const id of ["segBtn", "logrosK"]) assert.ok(html.includes('id="' + id + '"'), "Debe conservarse el indicador #" + id);
assert.ok(html.includes("gamTileHTML()"), "Debe conservarse el indicador de nivel");
assert.ok(html.includes("@media (max-width: 1180px) { .kg-op .k:nth-child(-n+2) { display: none; } }"), "La regla de 1180 px debe afectar solo al grupo operativo");
assert.ok(!/\.kstrip \.k span \{ font-size: 1[01](\.5)?px/.test(html), "Las etiquetas de los indicadores no deben bajar de 12 px");

// Modo oscuro: el texto del botón de acceso usa el token (en oscuro el blanco fijo daba 3,2:1).
assert.ok(/#login button \{[^}]*background: var\(--accent\); color: var\(--accent-fg\)/.test(html), "El botón de acceso debe usar var(--accent-fg)");

console.log("Cabecera y filtros: comprobaciones estáticas correctas.");

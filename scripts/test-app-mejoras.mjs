// Regresión estática de tres mejoras de la app (19/10/2026): filtro de Municipio, municipios desplegables al
// agregar un punto y desactivar puntos (personal). El comportamiento real se prueba en el navegador con
// scripts/dev/mock-supabase.mjs.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(process.argv[2] || "index.html", "utf8");

// 1. Filtro de municipio.
assert.match(html, /<select id="muni" aria-label="Filtrar por municipio"><\/select>/, "Falta el filtro de municipio accesible");
assert.ok(html.includes("function refreshMuniSelect()") && html.includes("refreshMuniSelect();\n  const tv"), "El filtro de municipio debe reconstruirse con los selectores");
assert.ok(html.includes("(!muni || townOf(c) === muni)"), "La lista debe filtrar por municipio");
assert.ok(html.includes("provincia, muni, tipo"), "El cambio de municipio debe reiniciar la primera página de la lista");
assert.ok(html.includes('$("#muni").addEventListener("change", refilter);'), "Falta el evento del filtro de municipio");

// 2. Alta de puntos con provincia y municipio desplegables.
assert.match(html, /<label>Provincia<select id="n-prov"><\/select><\/label>/, "Falta el desplegable de provincia del alta");
assert.match(html, /<label>Municipio<select id="n-town" disabled>/, "El municipio del alta debe ser un desplegable");
assert.ok(!/<input id="n-town"/.test(html), "El municipio del alta ya no es de texto libre");
assert.ok(html.includes('fetchAllRows((opts) => window.mapaSession.supabase.from("municipalities").select("id, name", opts).eq("province_id", provId), "id")'),
  "Los municipios del alta deben leerse paginados (H-23)");
assert.ok(html.includes('town = $("#n-town").value, street'), "El alta debe usar el municipio elegido");

// 3. Desactivar puntos (personal): no se dibujan en el mapa pero siguen en la lista.
assert.ok(html.includes('window.mapaPersistUserState("inactive"'), "El estado de desactivados se guarda en el estado personal");
assert.ok(html.includes("const isInactive = (c) => hasPersonalRef(inactive, c);"), "Falta isInactive");
assert.ok(html.includes("if (!isInactive(c)) nuevos.push(m);"), "Los desactivados no se añaden al mapa al crear los marcadores");
assert.ok(html.includes("enMapa = visible && !isInactive(c)"), "renderList debe quitar del mapa los desactivados");
assert.ok(html.includes('class="f-inact"') && html.includes("Desactivar en el mapa") && html.includes("Activar en el mapa"), "Falta el botón de la ficha");
assert.ok(html.includes("Desactivado en el mapa"), "La lista debe marcar los desactivados");
assert.ok(html.includes("inactive = normalizePersonalRefs(state.inactive);"), "El estado de desactivados se carga al iniciar sesión");
assert.ok(html.includes("L.popup({ minWidth: 330, maxWidth: 380, ariaTitle: c.name })"), "Un desactivado debe poder abrir su ficha desde la lista");

// Sin persistencia local nueva.
const trozo = html.slice(html.indexOf("let inactive = new Set();"), html.indexOf("let inactive = new Set();") + 600);
assert.ok(!/localStorage|sessionStorage|indexedDB/.test(trozo), "Sin persistencia local en el estado de desactivados");

console.log("test-app-mejoras: OK");

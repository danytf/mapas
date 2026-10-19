// Regresión estática de los favoritos (docs/DISENO_FAVORITOS.md): lista personal de cada usuario, marcada desde la ficha,
// con un filtro «Favoritos» junto a la búsqueda. Se guarda en user_app_state (sin migración) y nunca en el navegador.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(process.argv[2] || "index.html", "utf8");

// Estado personal: conjunto propio, guardado y cargado con el resto del estado personal.
assert.ok(html.includes("let favorites = new Set();") && html.includes('window.mapaPersistUserState("favorites", [...favorites])'), "Los favoritos se guardan en el estado personal (user_app_state.favorites)");
assert.ok(html.includes("favorites = normalizePersonalRefs(state.favorites);"), "Los favoritos se cargan normalizados al iniciar sesión");
assert.ok(html.includes("const isFav = (c) => hasPersonalRef(favorites, c);"), "Falta isFav");
const a = html.indexOf("let favorites = new Set();");
const trozo = html.slice(a, a + 700);
assert.ok(!/localStorage|sessionStorage|indexedDB|document\.cookie/.test(trozo), "Los favoritos no pueden guardarse en el navegador");

// Marcar desde la ficha: botón con aria-pressed y nombre que cambia; guardado con reversión si falla.
const ficha = html.slice(html.indexOf("function fichaFor(c, pos) {"));
assert.ok(ficha.includes('class="fi-fav" aria-pressed="false"'), "La ficha lleva el botón de favorito");
assert.ok(ficha.includes('"Quitar de favoritos" : "Marcar como favorito"'), "El nombre accesible del botón cambia con el estado");
assert.ok(/const ok = await saveFavorites\(\);\s*if \(!ok\) \{\s*if \(era\) addPersonalRef\(favorites, c\); else deletePersonalRef\(favorites, c\);\s*await saveFavorites\(\);/.test(ficha), "Si no se puede guardar, el favorito vuelve a como estaba");
assert.ok(ficha.includes("No se pudo guardar el favorito en Supabase; se queda como estaba."), "Falta el aviso de error");
assert.ok(ficha.includes("añadido a favoritos") && ficha.includes("ya no es favorito"), "Cada cambio se anuncia en la región de estado");

// Filtro junto a la búsqueda: afecta a la lista y al mapa, tiene contador y se desactiva sin favoritos.
assert.match(html, /<div class="row qrow">\s*<input id="q"[^>]*>\s*<button id="favBtn" type="button" aria-pressed="false" disabled>/, "El filtro va junto a la búsqueda y empieza desactivado");
assert.ok(html.includes("(!onlyFav || isFav(c))") && html.includes("onlyRev, onlySeg, onlyFav,"), "El filtro actúa sobre la lista y el mapa y forma parte de la clave de paginación");
assert.ok(html.includes('$("#favBtn").addEventListener("click", () => { onlyFav = !onlyFav;'), "Falta el manejador del filtro");
assert.ok(html.includes("fb.disabled = !nFav;") && html.includes("if (!nFav && onlyFav) { onlyFav = false;"), "Sin favoritos el filtro se desactiva y se apaga solo");
assert.ok(html.includes('"Favoritos (\' + nFav + ")"') || html.includes("<span>Favoritos (' + nFav + \")</span>"), "El botón muestra el contador");
assert.ok(/#favBtn\[aria-pressed="true"\] \{[^}]*var\(--accent\)/.test(html), "El filtro activo se distingue por estilo, además de aria-pressed");

console.log("Favoritos: comprobaciones estáticas correctas.");

// Contadores de los filtros: cada selector cuenta teniendo en cuenta los demás filtros activos (comprobación estática de index.html).
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";
const html = readFileSync(process.argv[2] || "index.html", "utf8");
assert.ok(/function coincide\(c, f, omitir\)/.test(html), "Falta la función coincide(c, f, omitir)");
const cuerpo = html.slice(html.indexOf("function coincide(c, f, omitir)"), html.indexOf("function refreshCounts()"));
for (const clave of ["muni", "provincia", "tipo", "cadena", "subtipo", "permiso", "valor"]) {
  assert.ok(cuerpo.includes('omitir !== "' + clave + '"'), "El filtro «" + clave + "» debe poder omitirse para contar sus propias alternativas");
}
for (const f of ["isOut(c)", "onlyRev", "onlySeg", "onlyFav", "f.q"]) assert.ok(cuerpo.includes(f), "El contador debe respetar: " + f);
assert.ok(/function renderList\(\) \{[\s\S]*?refreshCounts\(\);/.test(html), "renderList debe actualizar los contadores");
const facetas = html.slice(html.indexOf("function refreshCounts()"), html.indexOf("function refreshMuniSelect()"));
for (const id of ["#provincia", "#muni", "#tipo", "#permiso", "#cadena", "#subtipo"]) assert.ok(facetas.includes('$("' + id + '")'), "Debe contarse el selector " + id);
console.log("Contadores de filtros: cada selector cuenta con los demás filtros aplicados.");

// Regresión estática de la pantalla de Administración (usuarios y provincias).
// El comportamiento real se prueba en el navegador con scripts/dev/mock-supabase.mjs (ver docs/DISENO_PANEL_ADMINISTRACION.md).
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("// Administración (usuarios y provincias)");
assert.ok(a >= 0, "No se encuentra el bloque de Administración en index.html");
const fin = html.indexOf("\n})();\n", a);
const bloque = html.slice(a, fin + 7);

// Estructura accesible.
assert.match(html, /<dialog id="dlgAdm" aria-labelledby="admT">/, "dlgAdm sin aria-labelledby");
assert.match(html, /<h2 id="admT">Administración<\/h2>/, "Falta el título del diálogo");
assert.match(html, /<div id="admMsg" role="status"><\/div>/, "El mensaje de estado debe ser role=status");
assert.match(html, /id="admBtn"[^>]*role="menuitem"[^>]*hidden/, "La opción del menú debe estar oculta por defecto");
assert.match(html, /id="admMh" hidden/, "El encabezado del grupo de menú debe estar oculto por defecto");
assert.ok(html.includes(".filter((i) => !i.disabled && !i.hidden)"), "El menú por teclado no debe incluir elementos ocultos");

// Solo para administradores y acceso a datos por las vías previstas.
assert.ok(bloque.includes('window.mapaSession?.profile?.role === "admin"'), "La opción debe depender del rol de administrador");
assert.ok(bloque.includes('rpc("admin_list_users")'), "La lista debe leerse con admin_list_users");
for (const t of ['from("profiles").update', 'from("user_provinces").insert', 'from("user_provinces").delete', 'from("provinces").update']) {
  assert.ok(bloque.includes(t), "Falta la operación " + t);
}

// Seguridad: sin persistencia local, texto escapado y protecciones en pantalla.
assert.ok(!/localStorage|sessionStorage|indexedDB|document\.cookie|caches\./.test(bloque), "La pantalla de administración no puede guardar nada en el navegador");
assert.ok(bloque.includes("esc(x.display_name") && bloque.includes("esc(label(x))") && bloque.includes("esc(p.name)"), "Los textos de usuarios y provincias deben pasar por esc()");
assert.ok(bloque.includes('disabled title="No puedes cambiar tu propio rol"') && bloque.includes('disabled title="No puedes desactivarte a ti mismo"'), "Falta la protección del propio usuario");
assert.ok(bloque.includes("window.confirm("), "Las acciones sensibles deben pedir confirmación");
assert.ok(bloque.includes('e.code === "23514"'), "Debe explicarse el error de último administrador");
assert.ok(bloque.includes("await load();"), "Tras cada cambio se recarga desde Supabase");

// El simulado debe cubrir las operaciones usadas.
const mock = readFileSync("scripts/dev/mock-supabase.mjs", "utf8");
for (const t of ["rpc/admin_list_users", '"23514"', "alta_provincia", "baja_provincia"]) assert.ok(mock.includes(t), "El simulado no cubre " + t);

console.log("test-admin-panel: OK");

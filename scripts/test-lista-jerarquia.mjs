// Jerarquía visual de la lista: icono de categoría en lugar del número, título sin repetir la calle y estado como etiqueta de color.
// Prueba estática sobre index.html (con el ayudante del título ejecutado de verdad). Ejecución: node scripts/test-lista-jerarquia.mjs
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const html = readFileSync(process.argv[2] || "index.html", "utf8");

// 1) El título corto: se extrae el código real y se ejecuta.
const m = html.match(/const normTxt = [^\n]*\nconst tituloOf = \(c\) => \{[\s\S]*?\n\};/);
assert.ok(m, "Faltan normTxt y tituloOf en index.html");
const { tituloOf } = new Function(m[0] + "\nreturn { tituloOf };")();
const casos = [
  [{ name: "Supermercado Julian Guadiana – Calle Vegas Bajas", street: "Calle Vegas Bajas" }, "Supermercado Julian Guadiana"],
  [{ name: "Supermercado Julian Guadiana – Calle Vegas Bajas", street: "Calle Vegas Bajas 3" }, "Supermercado Julian Guadiana"],
  [{ name: "Hospital Materno Infantil Las Palmas de Gran Canaria – Paseo Blas Cabrera Felipe \"Físico\"", street: "Paseo Blas Cabrera Felipe \"Físico\"" }, "Hospital Materno Infantil Las Palmas de Gran Canaria"],
  [{ name: "Ayuntamiento de Úbeda – Plaza de Andalucía", street: "plaza de andalucia 1" }, "Ayuntamiento de Úbeda"],
  [{ name: "Ayuntamiento de Pamplona Pamplona / Iruña – Plaza Consistorial", street: "Plaza Consistorial" }, "Ayuntamiento de Pamplona Pamplona / Iruña"],
  // Casos en los que NO se recorta: la parte final no es la calle, o no hay calle.
  [{ name: "Centro A – Anexo B", street: "Calle Mayor 5" }, "Centro A – Anexo B"],
  [{ name: "Centro A – Calle Mayor", street: "" }, "Centro A – Calle Mayor"],
  [{ name: "Sin guion", street: "Calle Mayor" }, "Sin guion"],
  [{ name: " – Calle Mayor", street: "Calle Mayor" }, " – Calle Mayor"]
];
for (const [c, esperado] of casos) assert.equal(tituloOf(c), esperado, "tituloOf(" + c.name + ")");

// 2) La lista usa el icono de categoría (decorativo), el título corto con el nombre completo como ayuda y el estado con su color.
const li = html.match(/function listItemFor\(c\) \{[\s\S]*?\n\}/);
assert.ok(li, "Falta listItemFor");
assert.ok(/<div class="num" aria-hidden="true" style="background:[^"]*" \+ colorOf\(c\)|class="num" aria-hidden="true"/.test(li[0]), "El icono de la lista es decorativo (aria-hidden)");
assert.ok(/glyphOf\(c\)/.test(li[0]) && !/ \+ c\.id \+ "<\/div><div><strong>/.test(li[0]), "La lista muestra el icono de la categoría, no el número");
assert.ok(/esc\(tituloOf\(c\)\)/.test(li[0]) && /title="' \+ esc\(c\.name\)/.test(li[0]), "El título es el corto, con el nombre completo escapado como ayuda");
assert.ok(/class="rs-st" style="--st:/.test(li[0]), "El estado lleva su color en --st");

// 3) Estilo: icono de 36 px con trazo, etiqueta de estado con color tintado y respaldo sin color-mix.
assert.ok(/\.num \{[^}]*width: 36px; height: 36px/.test(html), "El icono de la lista mide 36 px");
assert.ok(/\.num svg \{[^}]*stroke: currentColor/.test(html), "El icono dibuja con el trazo del color de contraste");
assert.ok(/\.rs-st \{[^}]*border-radius: var\(--r-pill\)/.test(html) && /@supports \(background: color-mix\(/.test(html) && /color-mix\(in srgb, var\(--st\) 14%, var\(--panel\)\)/.test(html), "La etiqueta de estado es una píldora tintada con respaldo");

console.log("test-lista-jerarquia: OK (" + casos.length + " títulos; icono de categoría, título corto y etiqueta de estado)");

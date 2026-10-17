#!/usr/bin/env node
/**
 * Auditoría XSS estática y pruebas de regresión del escapado HTML.
 * Uso: node scripts/audit-xss.mjs [index.html]
 *
 * Prueba la función esc real extraída de la aplicación y detecta sinks/patrones
 * de alto riesgo. Es una barrera de regresión, no un analizador semántico completo.
 */
import fs from "node:fs";
import vm from "node:vm";
import assert from "node:assert/strict";

const file = process.argv[2] ?? "index.html";
const html = fs.readFileSync(file, "utf8");
const failures = [];
let checks = 0;

function check(name, fn) {
  checks++;
  try {
    fn();
    console.log("PASS " + name);
  } catch (error) {
    failures.push({ name, error: error.message });
    console.error("FAIL " + name + ": " + error.message);
  }
}

const escMatch = html.match(/const\s+esc\s*=\s*\(s\)\s*=>\s*String\(s\)\.replace\([^;]+;/);
check("la función esc de producción existe y se puede extraer", () => {
  assert.ok(escMatch, "No se encontró la definición esperada de const esc");
});

if (escMatch) {
  const sandbox = {};
  vm.runInNewContext(escMatch[0] + "\nglobalThis.__esc = esc;", sandbox, { timeout: 1000 });
  const esc = sandbox.__esc;
  const vectors = [
    ["texto normal", "Centro de Salud", "Centro de Salud"],
    ["etiquetas HTML", "<img src=x onerror=alert(1)>", "&lt;img src=x onerror=alert(1)&gt;"],
    ["comillas dobles", '" onmouseover="alert(1)', "&quot; onmouseover=&quot;alert(1)"],
    ["ampersands", "A&B", "A&amp;B"],
    ["caracteres combinados", '<svg/onload=alert(1)>&"\u0027', "&lt;svg/onload=alert(1)&gt;&amp;&quot;'"],
    ["null y números se convierten a texto", 42, "42"],
  ];
  for (const [name, input, expected] of vectors) {
    check("esc: " + name, () => assert.equal(esc(input), expected));
  }
}

check("no hay inserción HTML mediante insertAdjacentHTML", () => {
  assert.doesNotMatch(html, /\.insertAdjacentHTML\s*\(/i);
});
check("no hay asignaciones a outerHTML", () => {
  assert.doesNotMatch(html, /\.outerHTML\s*=/i);
});
check("no hay protocolo javascript: en el código", () => {
  assert.doesNotMatch(html, /javascript\s*:/i);
});
check("no hay atributos HTML de eventos inline", () => {
  assert.doesNotMatch(html, /\son(?:abort|error|load|click|mouseover|focus|blur|submit|pointerdown|keydown)\s*=/i);
});
check("los enlaces dinámicos a Google Maps codifican el texto de búsqueda", () => {
  assert.match(html, /encodeURIComponent\(pos\s*&&\s*pos\.lat\s*!=\s*null\s*\?\s*pos\.lat\s*\+\s*","\s*\+\s*pos\.lon\s*:\s*c\.name\.replace/);
});
check("los colores de marcadores usan la lista de tipos con fallback constante", () => {
  assert.match(html, /const\s+colorOf\s*=\s*\(c\)\s*=>\s*\(TIPOS\.find\(\(t\)\s*=>\s*t\[1\]\s*===\s*c\.tipo\)\s*\|\|\s*\[0,\s*0,\s*["']#[0-9a-f]{6}["']\]\)\[2\]/i);
});
check("los nombres de establecimientos se escapan en el renderizado de marcadores/lista", () => {
  assert.match(html, /esc\(c\.name\)/);
});
check("las direcciones se escapan en las plantillas HTML que las muestran", () => {
  assert.match(html, /esc\(addrOf\(c\)\)/);
});

console.log("\nComprobaciones: " + checks + "; fallos: " + failures.length);
if (failures.length) {
  for (const failure of failures) console.error("- " + failure.name + ": " + failure.error);
  process.exitCode = 1;
}

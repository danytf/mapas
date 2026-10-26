// Detalles visuales del Centro de permisos, el Panel y el Calendario (inspección visual del 25/10/2026):
// casillas con el tema oscuro, cabecera y barra de lote del Centro en móvil, rejilla equilibrada del Panel y título del Calendario según la vista.
// Prueba estática sobre index.html (el reparto de columnas del Panel se ejecuta de verdad). Ejecución: node scripts/test-centro-detalles.mjs
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const html = readFileSync(process.argv[2] || "index.html", "utf8");

// 1) Casillas y demás controles nativos: color-scheme claro en :root y oscuro en el modo oscuro, con el acento como color de las casillas.
const raiz = html.match(/:root \{[\s\S]*?\n  \}\n  @media \(prefers-color-scheme: dark\) \{\n    :root \{([\s\S]*?)\n    \}\n  \}/);
assert.ok(raiz, "Faltan :root y su variante oscura");
assert.ok(/color-scheme: light;/.test(raiz[0].split("@media (prefers-color-scheme: dark)")[0]), ":root declara color-scheme: light");
assert.ok(/color-scheme: dark;/.test(raiz[1]), "El modo oscuro declara color-scheme: dark");
assert.ok(/input\[type="checkbox"\], input\[type="radio"\] \{ accent-color: var\(--accent\); \}/.test(html), "Las casillas y los radios usan el acento");

// 2) Cabecera del Centro en móvil: las tres acciones en una sola fila (sin partirse) y «Reprogramar al» sin saltos de línea.
const movil = html.match(/@media \(max-width: 700px\) \{\n    #ceBody \{[\s\S]*?\n  \}\n/);
assert.ok(movil, "Falta el bloque móvil (700 px) del Centro");
assert.ok(/\.ce-new \{[^}]*flex-wrap: nowrap[^}]*width: 100%/.test(movil[0]), "En móvil las acciones de la cabecera no saltan de fila");
assert.ok(/\.ce-new \.ce-act \{[^}]*flex: 1 1 auto[^}]*padding: 0 8px/.test(movil[0]), "En móvil las acciones se reparten el ancho con menos relleno");
assert.ok(/\.ce-lotef \{[^}]*white-space: nowrap/.test(html), "«Reprogramar al» no se parte en dos líneas");
assert.ok(/<button type="button" class="ce-act pri" data-new="sol">Nueva solicitud<\/button><button type="button" class="ce-act" data-new="con">Nueva concesión<\/button><button type="button" class="ce-act" data-cal="1">Calendario<\/button>/.test(html), "Las tres acciones de la cabecera siguen todas");
assert.ok(/<label class="ce-lotef">Reprogramar al <input type="date" id="ceLoteFecha"/.test(html), "La barra de lote conserva «Reprogramar al»");

// 3) Panel: --cols reparte las tarjetas de cada grupo (como mucho 6 por fila, sin una sola en la última) y en móvil la impar final ocupa la fila.
const reparto = html.match(/const n = ts\.length \+ \(g === "Concesiones" \? 1 : 0\);[^\n]*\n\s*return "<h3>"[^\n]*Math\.ceil\(n \/ Math\.ceil\(n \/ 6\)\)/);
assert.ok(reparto, "Falta el reparto de columnas por grupo en el Panel");
const cols = (n) => Math.ceil(n / Math.ceil(n / 6));
const huerfana = (n) => { const c = cols(n); return n > 1 && n % c === 1; }; // true = la última fila tiene una sola tarjeta
for (let n = 1; n <= 30; n++) assert.ok(cols(n) <= 6 && !huerfana(n), "n=" + n + " deja una tarjeta sola");
assert.equal(cols(7), 4, "Las 7 tarjetas de Concesiones van 4 + 3");
assert.equal(cols(6), 6, "6 tarjetas siguen en una fila");
assert.equal(cols(4), 4, "4 tarjetas siguen en una fila");
assert.equal(cols(1), 1, "Una tarjeta ocupa el ancho");
assert.ok(/#pnBody \.kpis \{ grid-template-columns: repeat\(auto-fit, minmax\(max\(128px, calc\(\(100% - 10px \* \(var\(--cols, 6\) - 1\)\) \/ var\(--cols, 6\)\)\), 1fr\)\); \}/.test(html), "La rejilla del Panel usa --cols como tope por fila");
assert.ok(/@media \(max-width: 700px\) \{\n    #pnBody \.kpis \{ grid-template-columns: repeat\(2, minmax\(0, 1fr\)\); \}\n    #pnBody \.kpis > :last-child:nth-child\(odd\) \{ grid-column: 1 \/ -1; \}/.test(html), "En móvil son 2 columnas y la tarjeta impar final ocupa la fila");
// Los grupos reales del Panel (se leen de GRUPOS) no dejan una tarjeta sola en pantalla ancha.
const grupos = html.match(/const GRUPOS = \[([\s\S]*?)\n  \];/);
assert.ok(grupos, "Falta GRUPOS");
const g = [...grupos[1].matchAll(/\["([^"]+)", \[([\s\S]*?)\]\]/g)].map((m) => [m[1], (m[2].match(/\["[A-Za-z0-9]+", "/g) || []).length + (m[1] === "Concesiones" ? 1 : 0)]);
assert.ok(g.length >= 4, "Se leen los grupos del Panel");
for (const [nombre, n] of g) assert.ok(n === 1 || !huerfana(n), "El grupo «" + nombre + "» (" + n + " tarjetas) deja una sola en la última fila");

// 4) Calendario: el título del diálogo sigue a la vista (mensual o semanal); el título inicial y la opción del menú no cambian.
assert.ok(/document\.getElementById\("calT"\)\.textContent = modo === "mes" \? "Calendario mensual" : "Calendario semanal";/.test(html), "El título del Calendario sigue a la vista");
assert.ok(/<h2 id="calT">Calendario semanal<\/h2>/.test(html) && /<dialog id="dlgCal" aria-labelledby="calT">/.test(html), "El diálogo sigue nombrado por su título");
const dibuja = html.match(/const draw = \(\) => \{\n    const a = wk, b = addDays\(wk, 6\), t = today\(\);\n(.*)\n/);
assert.ok(dibuja && dibuja[1].includes('"calT"'), "El título se actualiza al principio de draw(), antes de pintar cualquier vista");

console.log("test-centro-detalles: OK (color-scheme y casillas, cabecera y lote en móvil, rejilla del Panel " + g.map(([, n]) => n + "→" + cols(n)).join(" ") + " tarjetas por fila)");

// Panel resumen: «El catálogo de un vistazo» (anillo por categoría y barras por provincia).
// Prueba estática sobre index.html con la función de gráficas ejecutada de verdad con puntos de ejemplo. Ejecución: node scripts/test-panel-graficas.mjs
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const m = html.match(/  const fmtN = [^\n]*\n  const COLOR_TIPO = [^\n]*\n[\s\S]*?\n  const graficas = \(pts\) => \{[\s\S]*?\n  \};\n/);
assert.ok(m, "Faltan fmtN, COLOR_TIPO y graficas en index.html");
const esc = (s) => String(s).replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]));
const TIPOS = [[1, "Hospital", "var(--cat-hospital)"], [3, "Supermercado", "var(--cat-super)"], [5, "Entidad oficial", "var(--cat-oficial)"]];
const { graficas } = new Function("esc", "TIPOS", m[0] + "\nreturn { graficas };")(esc, TIPOS);

// 1) Sin puntos no hay sección.
assert.equal(graficas([]), "", "Sin puntos no se dibuja nada");

// 2) Con puntos: anillo con arcos que suman 100, leyenda con los recuentos y barras ordenadas.
const pts = [];
const añade = (n, tipo, province) => { for (let i = 0; i < n; i++) pts.push({ tipo, province }); };
añade(50, "Supermercado", "Madrid"); añade(30, "Hospital", "Madrid"); añade(15, "Entidad oficial", "Sevilla"); añade(5, "Otra cosa", "Lugo");
const out = graficas(pts);
assert.ok(out.includes("El catálogo de un vistazo"), "Falta el título de la sección");
const arcos = [...out.matchAll(/stroke-dasharray="([\d.]+) ([\d.]+)"/g)].map((x) => Number(x[1]));
assert.equal(arcos.length, 4, "Un arco por categoría");
assert.ok(Math.abs(arcos.reduce((a, b) => a + b, 0) - 100) < 0.01, "Los arcos del anillo suman el 100 %");
assert.ok(/aria-label="Reparto de 100 puntos por categoría: Supermercado 50, Hospital 30, Entidad oficial 15, Otra cosa 5"/.test(out), "El anillo tiene alternativa de texto con los números");
const leyenda = [...out.matchAll(/<li><i style="background:([^"]+)"><\/i>([^<]+)<b>([^<]+)<\/b><\/li>/g)];
assert.deepEqual(leyenda.map((x) => [x[2], x[3]]), [["Supermercado", "50"], ["Hospital", "30"], ["Entidad oficial", "15"], ["Otra cosa", "5"]], "La leyenda lista todas las categorías con su recuento, de mayor a menor");
assert.ok(leyenda[0][1] === "var(--cat-super)" && leyenda[3][1] === "var(--cat-otra)", "El color sale de la categoría (y gris para una desconocida)");
assert.ok(/<span class="pn-b" aria-hidden="true">/.test(out), "La barra es decorativa: el número va en texto");
const barras = [...out.matchAll(/<li><span>([^<]+)<\/span><span class="pn-b" aria-hidden="true"><i style="width:([\d.]+)%"><\/i><\/span><b>([^<]+)<\/b><\/li>/g)];
assert.deepEqual(barras.map((x) => [x[1], x[3]]), [["Madrid", "80"], ["Sevilla", "15"], ["Lugo", "5"]], "Provincias de mayor a menor");
assert.deepEqual(barras.map((x) => Number(x[2])), [100, 18.8, 6.3], "El ancho es proporcional a la mayor");

// Miles con punto en cuatro y más cifras, para que 8.426 y 16.929 se lean igual.
const grande = [];
for (let i = 0; i < 1234; i++) grande.push({ tipo: "Supermercado", province: "Madrid" });
for (let i = 0; i < 16929; i++) grande.push({ tipo: "Hospital", province: "Sevilla" });
const gg = graficas(grande);
assert.ok(gg.includes("<b>1.234</b>") && gg.includes("<b>16.929</b>") && gg.includes("<b>18.163</b>"), "Los miles llevan punto también con cuatro cifras (1.234, 16.929, 18.163)");

// 3) Con una sola provincia no hay barras; con más de diez se avisa; todo se escapa.
assert.ok(!graficas(pts.filter((p) => p.province === "Madrid")).includes("pn-barras"), "Con una sola provincia no se dibujan barras");
const muchas = []; for (let i = 0; i < 14; i++) muchas.push({ tipo: "Hospital", province: "Provincia " + i });
const gm = graficas(muchas);
assert.ok(gm.includes("las 10 mayores de 14") && (gm.match(/<li><span>/g) || []).length === 10, "Con más de diez provincias, se muestran diez y se dice cuántas hay");
const xss = graficas([{ tipo: "Hospital", province: '<img src=x onerror=alert(1)>' }, { tipo: "Hospital", province: "B" }]);
assert.ok(!xss.includes("<img") && xss.includes("&lt;img"), "Los nombres de provincia se escapan");

// 4) El panel la incluye tras la barra de filtros y la sección cumple la escala del diseño.
assert.ok(/body\.innerHTML = barra\(d\) \+ graficas\(d\.pts\) \+/.test(html), "El panel debe incluir las gráficas después de los filtros");
assert.ok(!/<text /.test(m[0]), "El número central va como HTML con los tamaños de letra del diseño, no como texto SVG");

// 5) Estado vacío: aviso claro cuando no hay registros y cifras en cero atenuadas.
assert.ok(/d\.recs\.length \? "" : '<p class="pn-vacio">/.test(html) && html.includes("Todavía no hay permisos que gestionar"), "Falta el estado vacío del panel");
assert.ok(/\(valor === 0 \? " cero" : ""\)/.test(html) && /\.kpi\.cero b \{ color: var\(--muted\); \}/.test(html), "Las cifras en cero se atenúan");

console.log("test-panel-graficas: OK (anillo, leyenda, barras, límites y escapado)");

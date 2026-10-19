// Regresión estática de la escala de radios y tamaños de letra (DESIGN.md): la hoja de estilos usa tokens, no valores sueltos.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const st = html.slice(html.indexOf("<style>"), html.indexOf("</style>"));

for (const t of ["--r-xs: 4px", "--r-control: 8px", "--r-card: 12px", "--r-surface: 16px", "--r-pill: 999px", "--fs-label: 12px", "--fs-label-lg: 13px", "--fs-body: 14px", "--fs-title: 17px", "--fs-display: 20px"]) {
  assert.ok(st.includes(t), "Falta el token " + t);
}

// Valores que se quedan literales a propósito: círculos, marcas de 2 a 3 px, barras con la parte superior redondeada, 0 y controles de Leaflet.
const radioOk = /^(0|2px|3px|50%|50% 50% 50% 0|8px 8px 0 0|5px 5px 0 0)$/;
const malos = [];
for (const m of st.matchAll(/([^{}]+)\{([^{}]*)\}/g)) {
  const sel = m[1].replace(/\/\*[\s\S]*?\*\//g, "").trim();
  if (sel.includes(".leaflet")) continue;
  for (const r of m[2].matchAll(/border-radius:\s*([^;}]+?)\s*(?=;|$)/g)) {
    const v = r[1].trim();
    if (v.startsWith("var(--r-") || radioOk.test(v)) continue;
    malos.push(sel.slice(-50) + " → border-radius: " + v);
  }
  for (const f of m[2].matchAll(/font-size:\s*([\d.]+)px/g)) {
    const n = parseFloat(f[1]);
    if (n >= 22) continue; // numerales, cifras de la cabecera y glifos grandes
    malos.push(sel.slice(-50) + " → font-size: " + f[1] + "px");
  }
}
assert.deepEqual(malos, [], "Valores fuera de la escala (usa los tokens --r-* y --fs-*):\n" + malos.join("\n"));

// Colores de categoría, gamificación y banda de la cabecera: tokens, no literales (solo se definen en :root).
const fuera = st.replace(/:root\s*\{[^}]*\}/g, "");
for (const lit of ["#e0a800", "#fff1c2", "#8a5a00", "#22a15a", "#f5c542", "#ffe28a", "#ffd966", "#fbbf24", "#22c55e", "#2b394d", "#3a4c66", "#26354b", "#1f2a3b"]) {
  assert.ok(!fuera.toLowerCase().includes(lit), "El literal " + lit + " debe ser un token (--gam-*, --hd-*), no un valor suelto");
}
for (const t of ["--gam-gold:", "--gam-gold-soft:", "--gam-gold-ink:", "--gam-green:", "--hd-line:", "--cat-hospital:", "--cat-eventos:", "--cat-otra:", "--cat-defecto:"]) assert.ok(st.includes(t), "Falta el token " + t);
const tipos = html.slice(html.indexOf("const TIPOS = ["), html.indexOf("];", html.indexOf("const TIPOS = [")));
assert.ok(!/#[0-9a-f]{6}/i.test(tipos) && (tipos.match(/var\(--cat-/g) || []).length === 17, "Las 17 categorías usan tokens --cat-*");
assert.ok(html.includes("const resolveColor = ") && /const inkOn = \(hex\) => \{\s*hex = resolveColor\(hex\);/.test(html), "El contraste del número de la lista resuelve el token antes de calcularlo");
assert.ok(!/style="background:#(fff3d6|dcfce7)/.test(html), "Las etiquetas de la lista usan clases (.tag.warn / .tag.ok), no colores fijos");

console.log("Escala de radios y tamaños de letra: comprobaciones estáticas correctas.");

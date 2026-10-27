// Contraste WCAG AA (texto 4,5:1; elementos gráficos 3:1) de lo nuevo del diseño en claro y en oscuro: lista (icono de categoría y etiqueta de estado),
// panel resumen (anillo, barras y cifras), grupos de marcadores por densidad (.cl.n1 a .cl.n4) y atajos de zona. Prueba estática sobre index.html:
// lee los tokens reales de :root y del bloque prefers-color-scheme: dark, los resuelve (var(--x), color-mix) y calcula los ratios. Ejecución: node scripts/test-oscuro-contraste.mjs
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const st = html.slice(html.indexOf("<style>"), html.indexOf("</style>"));

// 1) Tokens: el primer :root y el :root del bloque oscuro (que solo redefine lo que cambia).
const bloques = st.match(/:root \{([\s\S]*?)\n  \}\n  @media \(prefers-color-scheme: dark\) \{\n    :root \{([\s\S]*?)\n    \}/);
assert.ok(bloques, "No se encuentran :root y su variante oscura");
const lee = (s) => { const o = {}; for (const m of s.matchAll(/(--[\w-]+):\s*([^;]+);/g)) o[m[1]] = m[2].trim(); return o; };
const claro = lee(bloques[1]);
const oscuro = { ...claro, ...lee(bloques[2]) };

const resuelve = (T, v, prof = 0) => {
  const m = /^var\((--[\w-]+)\)$/.exec(v.trim());
  if (!m) return v.trim();
  assert.ok(T[m[1]] !== undefined && prof < 6, "Token sin definir o con referencia circular: " + m[1]);
  return resuelve(T, T[m[1]], prof + 1);
};
const rgb = (h) => { h = h.replace("#", ""); if (h.length === 3) h = [...h].map((x) => x + x).join(""); assert.ok(/^[0-9a-f]{6}$/i.test(h), "Color no hexadecimal: " + h); return [0, 2, 4].map((i) => parseInt(h.slice(i, i + 2), 16)); };
const lum = (c) => { const k = c.map((v) => { v /= 255; return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); }); return 0.2126 * k[0] + 0.7152 * k[1] + 0.0722 * k[2]; };
const ratio = (a, b) => { const x = lum(a), y = lum(b); return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05); };
// Color de un token o literal en un modo (los valores que aún son var(--x) se resuelven).
const col = (T, v) => rgb(resuelve(T, v));
const mezcla = (a, pa, b) => a.map((v, i) => Math.round(v * pa + b[i] * (1 - pa))); // color-mix(in srgb, a pa%, b)

// 2) Regla CSS de un selector exacto (para leer color y fondo de los grupos de marcadores).
const regla = (sel) => {
  const esc = sel.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const m = st.match(new RegExp("(?:^|[}\\n])\\s*" + esc + " \\{([^}]*)\\}"));
  assert.ok(m, "Falta la regla " + sel);
  return m[1];
};
const decl = (cuerpo, prop) => { const m = cuerpo.match(new RegExp("(?:^|[;\\s])" + prop + ":\\s*([^;]+?)\\s*(?:;|$)")); return m ? m[1] : null; };

const fallos = [];
let comprobados = 0;
const exige = (modo, nombre, a, b, min) => {
  comprobados++;
  const r = ratio(a, b);
  if (r < min) fallos.push(modo + ": " + nombre + " = " + r.toFixed(2) + " (mínimo " + min + ")");
};

for (const [modo, T] of [["claro", claro], ["oscuro", oscuro]]) {
  const c = (v) => col(T, v);
  const panel = c("var(--panel)"), bg = c("var(--bg)");

  // Texto base y secundario sobre las superficies de la lista y del panel (reposo, pasar el ratón y fila activa).
  for (const [n, f] of [["--fg", "var(--fg)"], ["--muted", "var(--muted)"]]) {
    for (const [s, fondo] of [["--panel", "var(--panel)"], ["--bg", "var(--bg)"], ["--ok-bg (fila al pasar el ratón)", "var(--ok-bg)"], ["--accent-soft (fila activa)", "var(--accent-soft)"]]) exige(modo, n + " sobre " + s, c(f), c(fondo), 4.5);
  }
  // Rótulos de la lista: .rs-w y .rs-f (aviso), .rs-ok (vigente), enlaces de acento y errores.
  for (const [s, fondo] of [["--panel", "var(--panel)"], ["--ok-bg", "var(--ok-bg)"], ["--accent-soft", "var(--accent-soft)"]]) {
    exige(modo, "--warn (.rs-w, .rs-f) sobre " + s, c("var(--warn)"), c(fondo), 4.5);
    exige(modo, "--ok (.rs-ok) sobre " + s, c("var(--ok)"), c(fondo), 4.5);
  }
  exige(modo, "--accent (enlaces) sobre --panel", c("var(--accent)"), panel, 4.5);
  exige(modo, "--err sobre --panel", c("var(--err)"), panel, 4.5);
  exige(modo, "--accent-fg sobre --accent (botón primario)", c("var(--accent-fg)"), c("var(--accent)"), 4.5);
  exige(modo, "--accent-fg sobre --accent-d (botón primario al pasar el ratón)", c("var(--accent-fg)"), c("var(--accent-d)"), 4.5);
  // Cifras del panel resumen (.kpi, .kpi.hl, .kpi.al, .kpi.cero) y etiquetas de las etiquetas .tag.
  exige(modo, "--ok sobre --ok-soft (.kpi.hl, .tag.ok)", c("var(--ok)"), c("var(--ok-soft)"), 4.5);
  exige(modo, "--warn sobre --warn-bg (.kpi.al, .tag.warn, .chipbtn)", c("var(--warn)"), c("var(--warn-bg)"), 4.5);
  exige(modo, "--gam-up sobre --panel", c("var(--gam-up)"), panel, 4.5);
  exige(modo, "--gam-dn sobre --panel", c("var(--gam-dn)"), panel, 4.5);

  // Etiqueta de estado de la lista: texto --fg sobre la mezcla del estado (14 %) con el panel, y punto de color (elemento gráfico, 3:1) sobre el panel.
  for (const e of ["concedido", "solicitado", "porsolicitar", "solicitada", "caducado", "denegado", "cancelado"]) {
    const s = c("var(--st-" + e + ")");
    exige(modo, "texto de la etiqueta de estado «" + e + "» (--fg sobre 14 % de --st)", c("var(--fg)"), mezcla(s, 0.14, panel), 4.5);
    exige(modo, "punto del estado «" + e + "» sobre --panel", s, panel, 3);
  }

  // Icono de la lista: el número usa el color de categoría de fondo y el trazo blanco u oscuro (inkOn elige el de más contraste, como en index.html).
  for (const k of Object.keys(T).filter((k) => /^--cat-/.test(k))) {
    const f = c("var(--" + k.slice(2) + ")");
    const mejor = Math.max(ratio([255, 255, 255], f), ratio(rgb("#111827"), f));
    comprobados++;
    if (mejor < 4.5) fallos.push(modo + ": icono de la lista sobre " + k + " = " + mejor.toFixed(2) + " (mínimo 4,5)");
  }

  // Barras por provincia: relleno (--ch-a3) sobre la pista (--ok-bg), elemento gráfico de 3:1; y anillo: la pista del aro sobre el panel no se exige (el reparto va también en texto).
  exige(modo, "barra por provincia (--ch-a3) sobre su pista (--ok-bg)", c("var(--ch-a3)"), c("var(--ok-bg)"), 3);
  exige(modo, "barra por provincia (--ch-a3) sobre --panel", c("var(--ch-a3)"), panel, 3);

  // Grupos de marcadores por densidad: el color del texto y el fondo salen de las reglas reales.
  const base = regla(".cl");
  for (const n of ["n1", "n2", "n3", "n4"]) {
    const r = regla(".cl." + n);
    const fondo = decl(r, "background");
    assert.ok(fondo, ".cl." + n + " define su fondo");
    const texto = decl(r, "color") || decl(base, "color");
    exige(modo, "texto del grupo ." + n + " (" + texto + ") sobre " + fondo, c(texto), c(fondo), 4.5);
  }

  // Conmutador Mapa/Lista de móvil y atajos de zona.
  exige(modo, "conmutador (#cfd6e2) sobre --ink", rgb("#cfd6e2"), c("var(--ink)"), 4.5);
  exige(modo, "conmutador activo (--ink) sobre blanco", c("var(--ink)"), rgb("#ffffff"), 4.5);
  const reg = regla("#regiones button");
  assert.ok(/background: var\(--panel\)/.test(reg) && /color: var\(--fg\)/.test(reg), "Los atajos de zona usan --panel y --fg (contraste comprobado arriba)");
}

assert.deepEqual(fallos, [], "Pares por debajo de WCAG AA:\n" + fallos.join("\n"));

// 3) Los grupos usan tokens propios (--cl-*), no los de las gráficas, que se invierten en oscuro: en oscuro --ch-a2 y --ch-a3 son claros y el texto blanco no se leería.
for (const n of ["n1", "n2", "n4"]) assert.ok(new RegExp("\\.cl\\." + n + " \\{[^}]*background: var\\(--cl-" + n + "\\)").test(st), ".cl." + n + " usa el token --cl-" + n);
for (const n of ["n1", "n2", "n4"]) assert.ok(claro["--cl-" + n] && !/^var\(/.test(claro["--cl-" + n]), "Falta el token --cl-" + n + " en :root");
assert.ok(!/\.cl\.n[1-4] \{[^}]*var\(--ch-/.test(st), "Los grupos no dependen de los tokens de las gráficas (--ch-*)");

// 4) Acceso (en él se ven los estados de carga y de error): todo campo del formulario tiene estilo propio. Un tipo sin regla (el correo es type=email)
// se pinta con el estilo del navegador: blanco con texto negro en oscuro y sin el borde ni el radio del sistema.
const inicio = html.indexOf('id="login"');
const login = html.slice(inicio, html.indexOf("</form>", inicio));
const tipos = [...login.matchAll(/<input[^>]*type="(\w+)"/g)].map((m) => m[1]).filter((t) => t !== "checkbox");
assert.ok(tipos.includes("email") && tipos.includes("password"), "El formulario de acceso tiene correo y contraseña");
for (const t of tipos) assert.ok(new RegExp("#login input\\[type=" + t + "\\]").test(st), "Los campos type=" + t + " del acceso tienen estilo propio (#login input[type=" + t + "])");

console.log("test-oscuro-contraste: OK (" + comprobados + " pares de contraste en claro y oscuro y " + tipos.length + " campos del acceso con estilo: lista, etiqueta de estado, panel resumen, grupos por densidad y atajos de zona)");

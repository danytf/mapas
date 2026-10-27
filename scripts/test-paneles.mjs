// Regresión estática de Panel resumen y Administración con el lenguaje visual de la ficha (docs/DISENO_FICHA_PUNTO.md, DESIGN.md).
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("  #dlgPanel, #dlgAdm { padding: 0; }");
const b = html.indexOf("  /* Objetivos táctiles de 44 px fuera de la ficha");
assert.ok(a > 0 && b > a, "No se encuentra el bloque de estilos de Panel resumen y Administración");
const css = html.slice(a, b);

assert.ok(!/background(-color)?: #[0-9a-f]{3,6}/i.test(css) && !/ (color|border[a-z-]*): #[0-9a-f]{3,6}/i.test(css), "Los paneles no deben fijar colores: usan los tokens (modo claro y oscuro)");
assert.ok(/\.pn-head[^}]*position: sticky[^}]*border-bottom: 1px solid var\(--line\)/.test(css), "La cabecera del panel es fija y lleva filete");
assert.ok(/h2 \{ font-size: var\(--fs-title\)/.test(css), "Los títulos siguen la escala de la ficha (--fs-title, 17 px)");
assert.ok(/\.kpi \{ border-left: 5px solid var\(--kpi/.test(css) && /\.kpi\.hl \{ --kpi: var\(--st-concedido\)/.test(css) && /\.kpi\.al \{ --kpi: var\(--st-solicitado\)/.test(css), "Las tarjetas del resumen codifican el estado con borde izquierdo y los tokens de estado");
assert.ok(/button\.kpi \{[^}]*cursor: pointer/.test(css) && /button\.kpi:focus-visible/.test(css), "Cada cifra del resumen es un botón con foco visible");
assert.ok(/\.pn-scroll \{ max-height: none; overflow-x: auto; overflow-y: visible; position: relative; \}/.test(css), "La tabla del resumen no crea una segunda barra de desplazamiento vertical");
assert.ok(/dialog input\[type="checkbox"\] \{ width: 18px; height: 18px; min-height: 0;/.test(css), "Las casillas de verificación no heredan el alto de los campos de texto");
assert.ok(/@media \(max-width: 900px\), \(pointer: coarse\) \{ \.adm-chk \{ min-height: 44px; \} \}/.test(css), "Las filas con casilla de Administración miden 44 px en táctil");

// Cada cifra del panel dice qué cuenta y abre la lista exacta de registros.
const pa = html.indexOf("/* Panel resumen */"), pb = html.indexOf("/* Ayuda y atajos");
const panel = html.slice(pa, pb);
for (const t of ["Seguimientos atrasados", "Pendientes de decisión", "Vigentes hoy", "Vencen en 0–7 días", "Vencen en 8–15 días", "Vencen en 16–30 días", "Empiezan en los próximos 30 días", "Posibles incoherencias o datos incompletos", "Capacidad por ONG"]) assert.ok(panel.includes(t), "Falta en el panel: " + t);
assert.ok(panel.includes("button[data-ind]") && panel.includes("renderLista") && panel.includes('id="pnBack"'), "Cada cifra abre su lista y se puede volver");
assert.ok(panel.includes('id="pnProv"') && panel.includes('id="pnOng"') && panel.includes("fProv") && panel.includes("fOng"), "Filtros de provincia y ONG que se mantienen al navegar");
assert.ok(panel.includes("indicadores(recs, segs, t)") && !panel.includes("estadoOf("), "Los totales salen de cada expediente, no del estado resumido del punto");

// El botón de cerrar es el mismo en Panel resumen, Administración y Calendario (una «×» sin borde, como la de la ficha).
assert.ok(/#pnClose, #admClose, #calClose \{ font-size: 24px;[^}]*border: 0;/.test(html), "Los tres diálogos comparten el botón de cerrar");

console.log("Panel resumen y Administración: comprobaciones estáticas correctas.");

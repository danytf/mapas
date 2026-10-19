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
assert.ok(/\.kpi \{ border-left: 5px solid var\(--kpi/.test(css) && /--st-solicitado/.test(css) && /--st-concedido/.test(css) && /--st-denegado/.test(css) && /--st-caducado/.test(css), "Las tarjetas del resumen codifican el estado con borde izquierdo y los tokens de estado");
assert.ok(/\.pn-scroll \{ max-height: none; overflow-x: auto; overflow-y: visible; \}/.test(css), "La tabla del resumen no crea una segunda barra de desplazamiento vertical");
assert.ok(/dialog input\[type="checkbox"\] \{ width: 18px; height: 18px; min-height: 0;/.test(css), "Las casillas de verificación no heredan el alto de los campos de texto");
assert.ok(/@media \(max-width: 900px\), \(pointer: coarse\) \{ \.adm-chk \{ min-height: 44px; \} \}/.test(css), "Las filas con casilla de Administración miden 44 px en táctil");

// Las tarjetas ordenadas por posición: puntos, solicitados, concedidos, denegados, vigentes, captadores, caducan, caducadas.
const kp = html.slice(html.indexOf("'<div class=\"kpis\">'"), html.indexOf("'<div class=\"kpis\">'") + 1200);
const orden = ["Puntos en el mapa", "Solicitados (pendientes)", "Concedidos", "Denegados", "Con concesión vigente hoy", "Captadores que se pueden enviar hoy", "Caducan en 30 días", "Solicitud caducada"].map((t) => kp.indexOf(t));
assert.ok(orden.every((n, i) => n > 0 && (i === 0 || n > orden[i - 1])), "El orden de las tarjetas del resumen cambió: hay que revisar los nth-child de los bordes de estado");
for (const n of [2, 3, 4, 8]) assert.ok(css.includes(`.kpis .kpi:nth-child(${n})`), "Falta el color de estado de la tarjeta " + n);

// El botón de cerrar es el mismo en Panel resumen, Administración y Calendario (una «×» sin borde, como la de la ficha).
assert.ok(/#pnClose, #admClose, #calClose \{ font-size: 24px;[^}]*border: 0;/.test(html), "Los tres diálogos comparten el botón de cerrar");

console.log("Panel resumen y Administración: comprobaciones estáticas correctas.");

// Ficha del punto mejorada: mini-mapa de situación y línea temporal con los datos que ya existen en memoria.
// Prueba estática sobre index.html; la línea temporal se ejecuta de verdad (se extrae el código real de eventosPunto y de las reglas de expedientes).
// Ejecución: node scripts/test-ficha-mejorada.mjs
import { readFileSync } from "node:fs";
import assert from "node:assert/strict";

const html = readFileSync(process.argv[2] || "index.html", "utf8");

// Extrae una constante de nivel superior: una línea, o varias hasta «\n};».
const grab = (name) => {
  const i = html.indexOf("\nconst " + name + " = ");
  assert.ok(i >= 0, "Falta const " + name + " en index.html");
  const fin = html.indexOf("\n", i + 1), linea = html.slice(i + 1, fin);
  if (/;\s*(\/\*.*\*\/)?\s*$/.test(linea)) return linea;
  const f = html.indexOf("\n};", i);
  assert.ok(f > 0, "No se encuentra el final de " + name);
  return html.slice(i + 1, f + 3);
};
const codigo = ["safeCount", "solsOf", "solEstado", "concEstado", "expedientesDe", "eventosPunto"].map(grab).join("\n");
const fmt = (d) => d ? d.slice(8, 10) + "/" + d.slice(5, 7) + "/" + d.slice(0, 4) : "…";
const T = "2026-10-26";
const { eventosPunto } = new Function("today", codigo + "\nreturn { eventosPunto };")(() => T);
const nom = (id) => ({ u1: "tú", u2: "otra persona" }[id] || "");
const ev = (p) => eventosPunto({ id: 1 }, p, T, fmt, nom);

// 1) Sin datos no hay línea temporal; no se inventa nada.
assert.deepEqual(ev({}), [], "Un punto sin permisos no tiene hechos");
assert.deepEqual(ev({ estado: "sin", fecha: "", contacto: "x", notas: "y", valoracion: 3 }), [], "Contacto, notas y valoración no son hechos con fecha");
assert.deepEqual(ev({ solicitudes: [{ ong: "A", captadores: 3 }] }), [], "Una solicitud sin ninguna fecha no genera hechos");
assert.deepEqual(ev({ solicitudes: [{ res: "denegada", ong: "A" }] }).map((e) => e.tipo), [], "Una denegación sin fecha de decisión no se dibuja");

// 2) Solicitud pendiente con seguimiento futuro: primero lo próximo, luego lo pasado.
const pend = ev({ solicitudes: [{ id: "s0000001", fecha: "2026-10-20", desde: "2026-11-02", hasta: "2026-11-06", ong: "Cruz Roja", captadores: 2, seg: "2026-10-30", resp: "u1", accion: "Llamar" }] });
assert.deepEqual(pend.map((e) => e.tipo + "@" + e.f), ["seg@2026-10-30", "sol@2026-10-20"]);
assert.ok(pend[0].meta.includes("responsable: tú") && pend[0].meta.includes("Llamar") && pend[0].meta.includes("Cruz Roja"), "El seguimiento muestra ONG, acción y responsable");
assert.ok(pend[1].meta.includes("2 captadores") && pend[1].meta.includes("pedido 02/11/2026 – 06/11/2026"), "La solicitud muestra captadores y fechas pedidas");

// 3) Solicitud aprobada con su concesión vigente: la decisión y el ciclo de la concesión, de más reciente a más antiguo.
const apr = ev({
  solicitudes: [{ id: "s0000002", fecha: "2026-09-01", res: "aprobada", resFecha: "2026-09-05", ong: "UNICEF", captadores: 1, conc: "c0000002" }],
  historial: [{ id: "c0000002", desde: "2026-10-01", hasta: "2026-11-30", alta: "2026-09-05", ong: "UNICEF", captadores: 1, sol: "s0000002" }]
});
assert.deepEqual(apr.map((e) => e.tipo + "@" + e.f), ["con@2026-11-30", "con@2026-10-01", "aprobada@2026-09-05", "sol@2026-09-01"]);
assert.equal(apr[0].txt, "Termina la concesión", "Una concesión que aún no ha acabado «termina»");
assert.equal(apr[1].txt, "Inicio de la concesión");
assert.deepEqual(ev({ historial: [{ desde: "2026-10-01", hasta: "2026-11-30", alta: "2026-09-20", ong: "X" }] }).map((e) => e.tipo + "@" + e.f), ["con@2026-11-30", "con@2026-10-01", "con@2026-09-20"], "Una concesión directa muestra su alta");
const ya = ev({ historial: [{ desde: "2026-01-10", hasta: "2026-02-10" }] });
assert.deepEqual(ya.map((e) => e.txt), ["Fin de la concesión", "Inicio de la concesión"], "Una concesión terminada usa «Fin»");
const fut = ev({ historial: [{ desde: "2026-12-01", hasta: "2026-12-10" }] });
assert.equal(fut[1].txt, "Comienza la concesión", "Una concesión futura «comienza»");

// 4) Cancelada: no se anuncia un fin que ya no ocurrirá; solo se muestra la cancelación si tiene fecha.
const canc = ev({ historial: [{ desde: "2026-10-01", hasta: "2026-11-30", cancelada: true, resFecha: "2026-10-15", motivo: "El centro cerró" }] });
assert.deepEqual(canc.map((e) => e.tipo + "@" + e.f), ["canc@2026-10-15", "con@2026-10-01"]);
assert.ok(canc[0].meta.includes("El centro cerró"), "La cancelación lleva su motivo");
assert.deepEqual(ev({ historial: [{ desde: "2026-10-01", hasta: "2026-11-30", cancelada: true }] }).map((e) => e.tipo), ["con"], "Cancelada sin fecha de decisión: solo el inicio");

// 5) Denegada y retirada con fecha; caducada sin respuesta.
assert.equal(ev({ solicitudes: [{ res: "denegada", resFecha: "2026-10-10", motivo: "Sin cupo" }] })[0].txt, "Solicitud denegada");
assert.equal(ev({ solicitudes: [{ res: "retirada", resFecha: "2026-10-10" }] })[0].tipo, "retirada");
const cad = ev({ solicitudes: [{ fecha: "2026-09-01", desde: "2026-09-10", hasta: "2026-09-20" }] });
assert.deepEqual(cad.map((e) => e.tipo + "@" + e.f), ["cad@2026-09-20", "sol@2026-09-01"]);

// 6) Seguimiento del punto y datos antiguos.
const sp = ev({ segPunto: { fecha: "2026-11-05", accion: "Visita", resp: "u2" } });
assert.deepEqual(sp.map((e) => e.txt), ["Seguimiento del punto"]); assert.ok(sp[0].meta.includes("responsable: otra persona"));
assert.deepEqual(ev({ seguimiento: "2026-11-09" }).map((e) => e.tipo), ["seg"], "Seguimiento antiguo de un punto sin solicitudes");
assert.deepEqual(ev({ estado: "solicitado", fecha: "2026-08-01" }).map((e) => e.f), ["2026-08-01"], "Dato antiguo con fecha");
assert.deepEqual(ev({ estado: "sin", fecha: "2026-08-01" }), [], "Un estado «sin» no dibuja la fecha antigua");

// 7) Sin inventar: toda fecha que sale estaba en los datos de entrada.
for (const p of [pend[0] && { solicitudes: [{ fecha: "2026-10-20", seg: "2026-10-30", desde: "2026-11-02", hasta: "2026-11-06" }] }, { solicitudes: [{ res: "aprobada", resFecha: "2026-09-05" }], historial: [{ desde: "2026-10-01", hasta: "2026-11-30", alta: "2026-09-05" }], segPunto: { fecha: "2026-12-01" } }]) {
  const dadas = new Set(JSON.stringify(p).match(/\d{4}-\d{2}-\d{2}/g));
  for (const e of ev(p)) assert.ok(dadas.has(e.f), "Fecha inventada: " + e.f);
}
// Orden: nunca crece la fecha al bajar por la lista.
const todos = ev({ solicitudes: [{ fecha: "2026-01-01", res: "aprobada", resFecha: "2026-01-02", seg: "2026-03-03" }, { fecha: "2026-06-01", seg: "2026-10-01" }], historial: [{ desde: "2026-02-01", hasta: "2026-04-01" }], segPunto: { fecha: "2026-12-12" } });
assert.ok(todos.every((e, i) => i === 0 || todos[i - 1].f >= e.f), "La línea temporal va de más reciente a más antigua");

// 8) Mini-mapa: solo con coordenadas, estático, con las teselas de la app y sin persistencia.
const mont = html.match(/function montarMiniFicha\(el, c\) \{[\s\S]*?\n\}\n/);
assert.ok(mont, "Falta montarMiniFicha");
const m = mont[0];
assert.ok(/L\.map\(caja, \{[^}]*zoomControl: false[^}]*dragging: false[^}]*touchZoom: false[^}]*doubleClickZoom: false[^}]*scrollWheelZoom: false[^}]*boxZoom: false[^}]*keyboard: false/.test(m), "El mini-mapa es estático (no atrapa el desplazamiento ni el foco)");
assert.ok(m.includes('esriTiles("World_Street_Map"') && m.includes("Canvas/World_Dark_Gray_Base") && m.includes("prefers-color-scheme: dark"), "Teselas de Esri de la app, con variante oscura");
assert.ok(!/fetch\(|https?:\/\/|localStorage|sessionStorage|indexedDB|caches\.|document\.cookie|console\.error/.test(m), "El mini-mapa no pide nada, no guarda nada y no escribe errores de consola");
assert.ok(/catch \(e\) \{\s*soltarMiniFicha\(\);[\s\S]*sec\.hidden = true/.test(m), "Si el mini-mapa falla, se oculta sin romper la ficha");
assert.ok(m.includes("makeIcon(c)") && m.includes("interactive: false"), "Lleva el pin del punto, no interactivo");
assert.ok(/function soltarMiniFicha\(\) \{[\s\S]*?miniFicha\.map\.remove\(\)/.test(html), "El mapa se destruye al cerrar");
assert.ok(/function openFicha\(c\) \{\s*fichaToken\+\+;\s*soltarMiniFicha\(\);[\s\S]*?montarMiniFicha\(fichaEl\.firstElementChild, c\);/.test(html), "openFicha monta el mini-mapa tras mostrar el panel");
assert.ok(/function closeFicha\(\) \{[\s\S]*?soltarMiniFicha\(\);[\s\S]*?fichaEl\.replaceChildren\(\)/.test(html), "closeFicha destruye el mini-mapa");
assert.ok(html.includes("if (ok) actualizaMiniFicha(c);") && /function actualizaMiniFicha\(c\)[\s\S]*?setLatLng\(at\)/.test(html), "Al guardar una ubicación nueva el mini-mapa sigue al pin");

// 9) Plantilla: mini-mapa (solo con coordenadas) y línea temporal dentro del área desplazable, antes de la valoración; nombres accesibles.
const a = html.indexOf("function fichaFor(c, pos) {"), ficha = html.slice(a, html.indexOf("  return el;\n}\n", a));
assert.ok(/const mini = pos && Number\.isFinite\(pos\.lat\) && Number\.isFinite\(pos\.lon\)/.test(ficha), "El mini-mapa solo existe si el punto tiene coordenadas");
assert.ok(ficha.includes('class="fi-mini" aria-label="Situación en el mapa"') && ficha.includes('role="group" aria-label="Mapa de situación de \' + esc(c.name)'), "El mini-mapa tiene nombre accesible con el nombre escapado");
assert.ok(ficha.includes('class="fi-time" aria-label="Línea temporal del permiso" hidden'), "La línea temporal nace oculta y tiene nombre accesible");
const orden = ["mini +", 'class="fi-state"', 'class="fi-time"', 'class="fi-rate"', 'class="fi-contact"', 'class="fi-loc"'].map((k) => ficha.indexOf(k));
assert.ok(orden.every((n, i) => n > 0 && (i === 0 || n > orden[i - 1])), "Orden: mini-mapa, estado, línea temporal, valoración, contacto y ubicación");
assert.ok(/paintTime\(cur\);/.test(ficha) && ficha.includes("miniFicha.marker.setIcon(makeIcon(c))"), "Al cambiar el permiso se repinta la línea temporal y el color del pin");
assert.ok(/const paintTime = \(cur\) => \{[\s\S]*?sec\.hidden = !ev\.length;/.test(ficha), "Sin hechos, la sección se oculta");
assert.ok(/<time datetime="' \+ e\.f/.test(ficha) && ficha.includes("e.meta.map(esc)") && ficha.includes("esc(e.txt)"), "Fechas en <time> y todo el texto escapado");
assert.ok(ficha.includes(" · próximo") && ficha.includes(" · vencido"), "Lo próximo y lo vencido se dicen con texto, no solo con color");

// 10) Estilo: solo tokens (sin colores, radios ni tamaños de letra sueltos), aislado del menú «Más acciones» y objetivo táctil de 44 px.
const css = html.slice(html.indexOf("  .fi-mini { isolation: isolate; }"), html.indexOf("  .fi-state { display: grid; gap: 8px; }"));
assert.ok(css.length > 500, "No se encuentra el bloque de estilos nuevo");
assert.ok(!/#[0-9a-fA-F]{3,8}\b|rgba?\(/.test(css), "El bloque nuevo no usa colores literales");
assert.ok(!/font-size:\s*[\d.]+px/.test(css) && !/border-radius:\s*(?!var\(--r-|50%)[^\s;]/.test(css), "Tamaños de letra y radios con tokens (el 50% es el punto de la línea)");
assert.ok(/\.fi-mini \{ isolation: isolate; \}/.test(css), "El mapa no puede quedar por encima del menú «Más acciones» (z-index interno de Leaflet)");
assert.ok(/\.fi-mini-map \{ height: 148px;/.test(css) && /#ficha \.fi-mini-map \.leaflet-control-attribution \{ font-size: var\(--fs-label\)/.test(css), "Altura contenida y atribución legible");
assert.ok(/@media \(max-width: 900px\), \(pointer: coarse\) \{[^@]*#ficha \.tl-more > summary \{ min-height: 44px; \}|#ficha \.tl-more > summary \{ min-height: 44px; \}/.test(html), "«Ver anteriores» mide 44 px en táctil");
for (const k of ["--st-solicitado", "--st-concedido", "--st-denegado", "--st-cancelado", "--st-caducado", "--accent", "--panel", "--line"]) assert.ok(css.includes("var(" + k + ")"), "La línea temporal usa el token " + k + " (con modo oscuro)");

console.log("test-ficha-mejorada: OK (línea temporal ejecutada con sus reglas; mini-mapa estático, sin persistencia y con pin)");

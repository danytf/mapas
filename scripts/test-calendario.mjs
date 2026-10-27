// Regresión estática de la sección «Calendario semanal» (menú → Calendario semanal).
// El comportamiento real se prueba en el navegador con scripts/dev/mock-supabase.mjs (ver docs/DISENO_CALENDARIO_SEMANAL.md).
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("/* Calendario semanal: permisos de cada día");
assert.ok(a >= 0, "No se encuentra el bloque del calendario en index.html");
const fin = html.indexOf("\n})();\n", a);
const bloque = html.slice(a, fin + 7);

// Estructura accesible y entrada de menú.
assert.match(html, /<dialog id="dlgCal" aria-labelledby="calT">/, "dlgCal sin aria-labelledby");
assert.match(html, /<h2 id="calT">Calendario semanal<\/h2>/, "Falta el título del diálogo");
assert.match(html, /id="calBtn" type="button" role="menuitem">Calendario semanal<\/button>/, "Falta la opción «Calendario semanal» en el menú");
assert.ok(bloque.includes('aria-label="Anterior"') && bloque.includes('aria-label="Siguiente"') && bloque.includes('"Mes anterior" : "Semana anterior"'), "Los botones de semana necesitan nombre accesible");
assert.ok(bloque.includes("aria-pressed=\"' + ver.autorizada") && bloque.includes("setAttribute(\"aria-pressed\""), "Los filtros deben exponer aria-pressed");
assert.ok(bloque.includes('role="status"') && bloque.includes('aria-labelledby="calH'), "Rango en role=status y cada día con su encabezado");
assert.ok(bloque.includes('<span class="st">'), "Cada tarjeta debe llevar el estado también en texto (no solo color)");
assert.ok(bloque.includes('aria-hidden="true"'), "La silueta de barras es decorativa y va oculta a lectores de pantalla");

// Solo lee lo que hay en memoria; no guarda nada ni consulta la red.
assert.ok(!/localStorage|sessionStorage|indexedDB|document\.cookie|caches\.|fetch\(|\.from\(|\.rpc\(|supabase/.test(bloque), "El calendario no puede guardar en el navegador ni llamar a la red");

// Los textos que vienen de los datos pasan por esc().
for (const t of ["esc(c.name)", "esc(townOf(c))", "esc(og)", ": info[0])) + \"</span><strong>\"", "esc(o)", "esc(ongDe(s))"]) {
  assert.ok(bloque.includes(t), "Falta escapar con esc(): " + t);
}

// Selección por provincia y reglas de cálculo.
assert.ok(bloque.includes("c.provinceId !== provId"), "Debe filtrar por provincia");
assert.ok(bloque.includes("isOut(c) ||"), "Los puntos quitados o archivados no deben aparecer");
assert.ok(html.includes('const diaEnRango = (r, d) => (!r.desde || r.desde <= d) && (!r.hasta || r.hasta >= d);'), "Un permiso aparece cada día entre su inicio y su fin (extremos incluidos)");
assert.ok(bloque.includes("calendarioSemana(") && bloque.includes("expedientesDe(c, p)") && bloque.includes("seguimientosDe(c, p)"), "Usa las reglas compartidas de expedientes");
// Concesiones, solicitudes y seguimientos no se mezclan en un único total.
assert.ok(bloque.includes("captadores autorizados") && bloque.includes("captadores por aprobar") && bloque.includes("seguimiento"), "El resumen distingue autorizados, por aprobar y seguimientos");
assert.ok(bloque.includes("ver = { autorizada: true, pendiente: true, seguimiento: true, historico: false }"), "El histórico (denegadas, retiradas, canceladas) va oculto por defecto");
assert.ok(!bloque.includes('data-modo="ong"') && !bloque.includes("tablaOng") && !html.includes("cal-ongt") && bloque.includes('id="calOng"'), "No hay vista «Por ONG»: el filtro de ONG la sustituye");
assert.ok(bloque.includes("Semana pasada:") && bloque.includes("no registrado"), "La semana pasada avisa de lo que no se puede reconstruir");

// Movimiento: solo con preferencia de movimiento normal.
assert.ok(!html.includes("cal-stack") && !html.includes("calGrow") && !html.includes("cal-sky"), "El gráfico de barras de cada día se retiró (la cifra y las tarjetas ya lo dicen) y, con él, su animación");

// La vista semanal ya no está en el panel resumen.
for (const t of ['id="wkBox"', "Permisos por semana", "data-wkdate", "wkRender"]) assert.ok(!html.includes(t), "Debe haberse quitado del panel resumen: " + t);

// Auditoría 25/10/2026: las ONG se agrupan sin distinguir mayúsculas ni espacios, igual que el Panel y el Centro.
assert.ok(bloque.includes("const kOng = (x) => ongDe(x).trim().toLowerCase();") && bloque.includes("kOng(x) === ong.trim().toLowerCase()") && bloque.includes("porClave.has(kOng(y))"), "El filtro de ONG del Calendario debe usar la clave normalizada");

// Vista mensual (25/10/2026): mismas reglas que la semana (calendarioSemana), capacidad y demanda por separado, y salto a la semana del día.
assert.ok(bloque.includes('data-modo="mes"') && bloque.includes("const drawMes = ") && bloque.includes("calendarioSemana(recs, segs, ini, t)"), "La vista mensual usa calendarioSemana");
assert.ok(bloque.includes("data-dia=") && bloque.includes("wk = mondayOf(dd.dataset.dia); modo = \"dias\""), "Pulsar un día abre su semana");
assert.ok(bloque.includes("captadores autorizados") && bloque.includes("por aprobar") && bloque.includes('esc(lbl + ". Pulsa para ver el día")'), "Cada día dice sus captadores autorizados y por aprobar por separado, con nombre accesible");
assert.ok(bloque.includes("Mes anterior") && bloque.includes("desplazaMes(+w.dataset.w)"), "La navegación avanza por meses en la vista mensual");

// Provincia por defecto (26/10/2026, decisión del titular): como el Panel y el Centro, abre con todas las provincias del usuario; ya no se elige una sola a mano.
assert.ok(!html.includes("provAuto"), "El Calendario ya no elige una provincia automáticamente");
assert.ok(/let wk = mondayOf\(today\(\)\), prov = null,/.test(html), "La provincia empieza sin elegir (null) hasta la primera apertura");
assert.ok(/prov = opts\.length > 1 \? "" : \(opts\[0\] \? opts\[0\]\[0\] : ""\)/.test(bloque), "Con más de una provincia abre con «todas»; con una sola, esa");
assert.ok(/<option value="">Todas las provincias<\/option>/.test(bloque), "«Todas las provincias» sigue en el selector");
assert.ok(bloque.includes('if (e.target.id === "calProv") { prov = e.target.value;'), "Elegir una provincia en el selector se mantiene durante la sesión");

// Exportar a PDF (impresión del navegador: Imprimir → Guardar como PDF). Sin librerías, sin datos nuevos y sin guardar nada.
assert.ok(/<button type="button" id="calPdf" class="cal-pdf"[^>]*>Exportar a PDF<\/button>/.test(bloque), "Falta el botón «Exportar a PDF»");
assert.ok(/const exportaPdf = \(\) => \{[\s\S]*?window\.print\(\);\s*\};/.test(bloque) && bloque.includes('if (e.target.closest("#calPdf")) { body.querySelector("details.cal-menu").open = false; exportaPdf(); return; }'), "El botón llama a la impresión del navegador");
assert.ok(bloque.includes('id="calPrintHead"') && bloque.includes("Generado el ") && bloque.includes('window.addEventListener("afterprint", fin)'), "La hoja lleva su cabecera (rango, provincia, ONG, filtros y fecha) y se restablece al terminar de imprimir");
assert.ok(bloque.includes('const eraModal = dlg.matches(":modal"); if (eraModal) { dlg.close(); dlg.show(); }') && bloque.includes("dlg.close(); dlg.showModal();"), "Durante la impresión el diálogo se muestra como no modal (en la capa superior no se pagina bien) y se restablece");
const ini = html.indexOf("@page cal {");
assert.ok(ini >= 0, "Faltan los estilos de impresión del Calendario");
const imp = html.slice(ini, html.indexOf("\n  }\n", ini) + 4);
assert.ok(imp.includes("@page cal { size: A4 landscape;") && imp.includes("body.imprime-cal { page: cal; }"), "La hoja es A4 apaisado");
assert.ok(imp.includes("body.imprime-cal > :not(#dlgCal) { display: none !important; }"), "Al imprimir solo se ve el Calendario");
assert.ok(imp.includes("#dlgCal .cal-top, body.imprime-cal #dlgCal .cal-sub, body.imprime-cal #dlgCal .cal-ayuda { display: none !important; }"), "Los controles no salen en el PDF");
assert.ok(!/\.cal-card[^{}]*\{[^}]*break-inside/.test(imp), "break-inside en las tarjetas cuelga a Chrome al paginar (cientos de tarjetas): no se usa");
assert.ok(imp.includes(".cal-wk { min-width: 0; grid-template-columns: repeat(7, minmax(0, 1fr));") && imp.includes(".cal-scroll, body.imprime-cal #dlgCal .pn-scroll, body.imprime-cal #dlgCal .cal-day { overflow: visible; }"), "La semana se ajusta al ancho de la hoja y sin zonas con desplazamiento");
// La hoja siempre en claro: cada variable que redefine el modo oscuro vuelve a su valor claro en la impresión.
const raiz = html.match(/:root \{([\s\S]*?)\n  \}\n  @media \(prefers-color-scheme: dark\) \{\n    :root \{([\s\S]*?)\n    \}\n  \}/);
const impClaro = imp.match(/body\.imprime-cal \{ color-scheme: light; ([^}]*)\}/);
assert.ok(raiz && impClaro, "Falta el bloque claro de la impresión");
for (const m of raiz[2].matchAll(/(--[\w-]+):/g)) {
  if (/^--(gam|hd)-/.test(m[1])) continue; // de la cabecera de la aplicación, que no sale en el PDF
  const claro = raiz[1].match(new RegExp(m[1] + ":\\s*([^;]+);"));
  assert.ok(claro && impClaro[1].includes(m[1] + ": " + claro[1].trim() + ";"), m[1] + " no vuelve a su valor claro en la impresión");
}

// «+ Solicitud» y «+ Concesión» de un día: el formulario se abre encima del Calendario, que no se cierra, y al terminar se vuelve a la semana.
assert.ok(bloque.includes("if (nv) { nuevaDesde(nv.dataset.nuevo, nv.dataset.nuevoDia); return; }") && /const nuevaDesde = \(tipo, dia, hasta\) => document\.dispatchEvent\(new CustomEvent\("centro:abrir", \{ detail: \{[^}]*enCalendario: true \} \}\)\);/.test(bloque), "«+ Solicitud» abre el formulario sin cerrar el Calendario");
assert.ok(bloque.includes('document.addEventListener("calendario:refresca"') && bloque.includes('id="calAviso"'), "El Calendario se repinta y avisa de lo guardado al volver del formulario");
assert.ok(html.includes("const cierraSoloForm = (texto) =>") && html.includes("cierraSoloForm(res.texto)") && html.includes('if (e.target.closest("#cfCancelar")) { form = null; dibujaForm(); cierraSoloForm(); return; }'), "Guardar y cancelar cierran el formulario y devuelven al Calendario");
assert.ok(html.includes("#dlgCentro.solo-form #ceBody .ce-nav"), "En ese modo el Centro enseña solo el formulario");

// «+ Nueva solicitud» fija en la barra: disponible en las tres vistas (semana, mes y por ONG), no solo en los días de «Semana».
assert.ok(/<button type="button" class="primary cal-nueva" data-nuevo="sol" data-nuevo-dia="' \+ today\(\) \+ '">\+ Nueva solicitud<\/button>/.test(bloque), "Falta el botón fijo «Nueva solicitud» en la barra del Calendario");

// Vista mensual como centro de mando: pinchar un día abre su panel (solicitudes por aprobar con Conceder y Denegar, concesiones, seguimientos y «+ Nueva solicitud»).
assert.ok(bloque.includes('if (dd && modo === "mes") {') && bloque.includes('rangoIni = ""; diaSel = dia; denegando = -1; draw();'), "En el mes, pinchar un día abre su panel");
// Periodos: inicio y fin marcados en el mes («Hasta otro día…» o Mayús + clic) y formulario con atajos y varios periodos (una solicitud por periodo).
assert.ok(bloque.includes('const ini = rangoIni || (e.shiftKey && diaSel ? diaSel : "")') && bloque.includes('nuevaDesde("sol", ini < dia ? ini : dia, ini < dia ? dia : ini)') && bloque.includes('data-rango-fin="1"'), "En el mes se marca un periodo con inicio y fin");
assert.ok(html.includes('hasta: o.hasta && validIsoDate(o.hasta) && o.hasta >= o.desde ? o.hasta : o.desde'), "El formulario nuevo acepta el periodo que trae el Calendario");
assert.ok(html.includes('<option value="7">1 semana</option><option value="1m">1 mes</option><option value="3m">3 meses</option><option value="1a">1 año</option>') && html.includes("const hastaDe = (desde, k) =>"), "El formulario ofrece atajos de periodo (1 semana, 1 mes, 3 meses, 1 año)");
assert.ok(html.includes('id="cfMasPer">+ Añadir otro periodo</button>') && html.includes('rangos.map((rg, i) =>') && html.includes("nuevas.forEach((y) => copia.solicitudes.push(y))") && html.includes("Dos periodos se solapan"), "Varios periodos crean una solicitud por periodo en una sola escritura y no se solapan");
assert.ok(bloque.includes("const drawDia = (dias, t) =>") && bloque.includes('data-pa="conceder"') && bloque.includes('data-pa="den-ok"') && bloque.includes('id="calMotivo"'), "El panel del día ofrece Conceder y Denegar (con motivo)");
assert.ok(bloque.includes("const panelAccion = async (a, i) =>") && bloque.includes("api.conceder(r)") && bloque.includes("api.denegar(r, motivo)"), "Conceder y denegar usan la API del Centro");
assert.ok(/window\.mapaAccionesCalendario = \{\s*solicitada: \(r\) => ejecuta\(r\.c, mutadores\.enviar\(r, today\(\)\)[^\n]*\n\s*conceder: \(r\) => ejecuta\(r\.c, mutadores\.conceder\(r\)/.test(html) && html.includes('denegar: (r, motivo) => ejecuta(r.c, mutadores.resolver(r, "denegada", motivo || ""), '), "El Centro expone conceder y denegar con su misma escritura verificada");
assert.ok(html.includes("if (!body.firstChild) return; /* el Centro aún no se ha abierto"), "El Centro no repinta si nunca se abrió (se concede desde el Calendario)");
assert.ok(bloque.includes('<span class="cal-ch \' + (i.e === "pendiente" ? "p" + (i.r.env ? " env" : "") : "a")') && bloque.includes("chips.slice(0, 2)") && bloque.includes('<span class="mas-t"> más</span>'), "Las celdas del mes llevan chips (hasta 2 y «+n más»)");
assert.ok(bloque.includes("const nuevaDesde = (tipo, dia, hasta) =>"), "Un solo punto de entrada para abrir el formulario desde el Calendario");
// Al entrar se abre el Calendario en vista mensual (una vez por sesión, en memoria) y esa es la vista por defecto.
assert.ok(/ong = "", modo = "mes",/.test(bloque), "La vista por defecto es el mes");
assert.ok(bloque.includes('document.addEventListener("sesion:lista"') && bloque.includes("if (abiertoAlEntrar) return; abiertoAlEntrar = true;") && bloque.includes('if (!document.querySelector("dialog[open]")) abrir();'), "Al entrar se abre el Calendario una vez por sesión, sin interponerse a otro diálogo abierto");
// Estados de una solicitud (flujo del titular, 27/10/2026): por solicitar (pendiente sin envío) → solicitada (pendiente con envío) → concedida / denegada.
assert.ok(html.includes('const subEstado = (r) => (r.k === "sol" && r.est === "pendiente" ? (r.env ? "solicitada" : "porsolicitar") : r.est);'), "Una solicitud pendiente es «por solicitar» o «solicitada» según tenga fecha de envío");
assert.ok(html.includes("if (a.sent_on) x.enviada = a.sent_on;") && html.includes("sent_on: x.enviada || null") && html.includes('"conc", "enviada"]'), "La fecha de envío viaja con la solicitud, se escribe y no se pierde al editarla");
assert.ok(html.includes('data-pa="env"') && html.includes("Marcar como solicitada") && html.includes("a === \"env\" ? await api.solicitada(r)"), "El panel del día permite marcar una solicitud como solicitada");
assert.ok(bloque.includes('(i.r.env ? "Solicitada: " : "Por solicitar: ")') && bloque.includes("<h4>Por solicitar (") && bloque.includes("Solicitadas ("), "Chips y panel distinguen «por solicitar» y «solicitada»");

console.log("Calendario semanal: comprobaciones estáticas correctas.");

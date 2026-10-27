// Regresión de la sección «Centro de permisos» (menú → Centro de permisos): comprobaciones estáticas y coherencia de sus filtros con el Panel resumen.
// El comportamiento real se prueba en el navegador con scripts/dev/mock-supabase.mjs.
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("/* Centro de permisos: centro de mando");
assert.ok(a >= 0, "No se encuentra el bloque del Centro de permisos en index.html");
const fin = html.indexOf("\n})();\n", a);
const bloque = html.slice(a, fin + 7);
let n = 0;
const ok = (cond, msg) => { assert.ok(cond, msg); n++; };

// Estructura accesible y entrada de menú.
ok(/<dialog id="dlgCentro" aria-labelledby="ceT">/.test(html), "dlgCentro sin aria-labelledby");
ok(/<h2 id="ceT">Centro de permisos<\/h2>/.test(html), "Falta el título del diálogo");
ok(/id="centroBtn" type="button" role="menuitem">Centro de permisos<\/button>/.test(html), "Falta la opción «Centro de permisos» en el menú");
ok(html.includes('id="ceClose" aria-label="Cerrar"'), "El botón de cerrar necesita nombre accesible");
ok(["jor", "res", "sol", "con", "seg", "inc"].every((v) => bloque.includes('["' + v + '", "')) && bloque.includes('aria-label="Secciones del Centro de permisos"') && bloque.includes("aria-current"), "Navegación principal: Mi jornada, Resumen, Solicitudes, Concesiones, Seguimientos y Avisos, con aria-current");
ok(bloque.includes('role="status"') && bloque.includes('<caption class="adm-sr">'), "Recuento en role=status y tabla con título");
ok(bloque.includes("badge(r.est)") && bloque.includes("esc(TEXTO[e])"), "El estado va también en texto, no solo en color");

// No toca la red ni el navegador; lo único que guarda es «Hecho» en un seguimiento, por guardaPunto (guardado verificable con control de conflictos).
const sinHistorial = bloque.replace(/const \{ data, error \} = await window\.mapaSession\.supabase\.from\("audit_log"\)[^\n]*\n/, "");
ok(!/localStorage|sessionStorage|indexedDB|document\.cookie|caches\.|fetch\(|\.from\(|\.rpc\(|supabase|ejecutaOpsRel|guardaPunto/.test(sinHistorial) && (bloque.match(/\.supabase\./g) || []).length === 1, "El Centro no llama a la red ni escribe fuera de aplica(); su única lectura propia es el historial de auditoría (audit_log)");
ok((bloque.match(/savePermits\(/g) || []).length === 1 && /const aplica = async[\s\S]*?await savePermits\(c\)/.test(bloque), "Hay una sola escritura: aplica() guarda con savePermits");
ok(/if \(r === "conflict"\) \{ await reloadSharedPermit\(c\); return "conflict"; \}/.test(bloque) && bloque.includes("gamPermit(c, previo)"), "aplica() recarga tras un conflicto y registra el progreso solo si se confirma");
ok(bloque.includes("if (s.punto) delete copia.segPunto") && bloque.includes('x.seg = ""'), "«Hecho» cierra solo el seguimiento elegido, no todos los del punto");
ok(bloque.includes("No se pudo confirmar el guardado") && bloque.includes("Otra persona ha cambiado"), "Los errores y conflictos no se presentan como guardados");

// Los textos que vienen de los datos pasan por esc().
for (const t of ["esc(x.c.name)", "esc(ongDe(r))", "esc(ongDe(s))", "esc(periodo(r))", "esc(detalleCon(r, t))", "esc(clave(x))", "esc(q)", "esc(n + \" (\"", "esc(s.accion)", "esc(nombreResp(s.resp))", "esc(x.tipo)"]) ok(bloque.includes(t), "Falta escapar con esc(): " + t);

// Ámbito y reglas compartidas.
ok(bloque.includes("isOut(c) ||") && bloque.includes("c.provinceId !== provId"), "Respeta puntos quitados/archivados y la provincia");
ok(bloque.includes("expedientesDe(c, p)") && bloque.includes("indicadores("), "Usa las reglas compartidas de expedientes");
ok(bloque.includes("TRAMO") && bloque.includes("data-mas"), "Dibuja por tramos");

// Coherencia: cada filtro del Centro cuenta lo mismo que la cifra equivalente del Panel resumen (indicadores).
const i0 = html.indexOf("const fmtD = "), i1 = html.indexOf("/* === Reglas de expedientes"), i2 = html.indexOf("/* === fin de la capa relacional === */");
const p0 = bloque.indexOf("const edadEn = "), p1 = bloque.indexOf("\n  };\n", p0) + 6;
ok(i0 >= 0 && i1 > i0 && i2 > i1 && p0 >= 0 && p1 > p0, "No se encuentran las reglas o los filtros");
const Real = Date;
class Falsa extends Real { constructor(...args) { if (args.length) super(...args); else super("2026-10-25T10:00:00Z"); } static now() { return new Real("2026-10-25T10:00:00Z").getTime(); } }
const ctx = runInNewContext(
  "const permits = {}; const permitKey = (c) => c.id; const permOf = (c) => permits[permitKey(c)] || {};\n" + html.slice(i0, i2) + "\n" + bloque.slice(p0, p1) + "\n({ today, addDays, expedientesDe, seguimientosDe, indicadores, incidencias, pred })",
  { Date: Falsa, self: {} }
);
const t = ctx.today();
const punto = (id) => ({ id, name: "P" + id });
const p = (extra) => Object.assign({ solicitudes: [], historial: [] }, extra);
const recs = [
  ...ctx.expedientesDe(punto(1), p({ solicitudes: [
    { id: "s1", desde: "2026-11-01", hasta: "2026-11-10", ong: "A", captadores: 2, fecha: "2026-10-01" },   /* pendiente y estancada */
    { id: "s2", desde: "2026-11-01", hasta: "2026-11-10", ong: "A", captadores: 2, fecha: "2026-10-20" },   /* pendiente */
    { id: "s3", desde: "2026-09-01", hasta: "2026-09-10", ong: "B", captadores: 1, fecha: "2026-08-01" },   /* caducada */
    { id: "s4", desde: "2026-11-01", hasta: "2026-11-10", ong: "B", captadores: 1, fecha: "2026-10-02", res: "aprobada", resFecha: "2026-10-03" },
    { id: "s5", desde: "2026-11-01", hasta: "2026-11-10", ong: "B", captadores: 1, fecha: "2026-10-02", res: "denegada", resFecha: "2026-10-03" }
  ], historial: [
    { id: "g1", desde: "2026-10-01", hasta: "2026-10-30", ong: "A", captadores: 2 },   /* vigente, vence en 5 días */
    { id: "g2", desde: "2026-10-01", hasta: "2026-11-24", ong: "A", captadores: 2 },   /* vigente, vence en 30 días */
    { id: "g3", desde: "2026-10-01", hasta: "2026-11-25", ong: "A", captadores: 2 },   /* vigente, fuera de 30 días */
    { id: "g4", desde: "2026-10-01", ong: "A", captadores: 2 },                         /* vigente sin fin */
    { id: "g5", desde: "2026-12-01", hasta: "2026-12-31", ong: "A", captadores: 2 },   /* futura */
    { id: "g6", desde: "2026-08-01", hasta: "2026-08-31", ong: "A", captadores: 2 },   /* terminada */
    { id: "g7", desde: "2026-10-01", hasta: "2026-10-30", ong: "A", captadores: 2, cancelada: true, resFecha: "2026-10-10" }
  ] }))
];
const ind = ctx.indicadores(recs, [], t), cuenta = (v, e) => recs.filter((r) => r.k === v && ctx.pred[v](e, r, t)).length;
const venc = ind.vencen7.length + ind.vencen15.length + ind.vencen30.length;
ok(cuenta("sol", "pendiente") === ind.pendientes.length && ind.pendientes.length === 2, "Pendientes coinciden con el Panel (2)");
ok(cuenta("sol", "estancada") === ind.estancadas.length && ind.estancadas.length === 1, "Estancadas coinciden con el Panel (1)");
ok(cuenta("sol", "caducada") === ind.sinRespuesta.length && ind.sinRespuesta.length === 1, "Caducadas coinciden con el Panel (1)");
ok(cuenta("sol", "aprobada") === 1 && cuenta("sol", "denegada") === 1 && cuenta("sol", "retirada") === 0 && cuenta("sol", "todas") === 5, "Aprobadas, denegadas y total");
ok(cuenta("con", "vigente") === ind.vigentes.length && ind.vigentes.length === 4, "Vigentes coinciden con el Panel (4)");
ok(cuenta("con", "vencen") === venc && venc === 2, "Vencen en 30 días coinciden con el Panel (2: 5 y 30 días; el de 31 días no)");
ok(cuenta("con", "sinfin") === ind.sinFin.length && ind.sinFin.length === 1, "Sin fecha de fin coinciden con el Panel (1)");
ok(cuenta("con", "futura") === 1 && cuenta("con", "terminada") === 1 && cuenta("con", "cancelada") === 1 && cuenta("con", "todas") === 7, "Futuras, terminadas, canceladas y total");
ok(ind.vigentes.every((r) => r.k === "con") && recs.length === 12, "Se separan solicitudes (5) y concesiones (7)");

// Seguimientos: cada filtro cuenta lo mismo que el Panel resumen.
const pt2 = punto(2), p2 = p({ solicitudes: [
  { id: "q1", desde: "2026-11-01", hasta: "2026-11-10", ong: "A", captadores: 1, fecha: "2026-10-20", seg: "2026-10-20" },                       /* atrasado, sin responsable */
  { id: "q2", desde: "2026-11-01", hasta: "2026-11-10", ong: "A", captadores: 1, fecha: "2026-10-20", seg: t, resp: "u1" },                     /* hoy */
  { id: "q3", desde: "2026-11-01", hasta: "2026-11-10", ong: "B", captadores: 1, fecha: "2026-10-20", seg: ctx.addDays(t, 7), resp: "u1" },    /* en 7 días */
  { id: "q4", desde: "2026-11-01", hasta: "2026-11-10", ong: "B", captadores: 1, fecha: "2026-10-20", seg: ctx.addDays(t, 8), resp: "u1" },    /* fuera de 7 días */
  { id: "q5", desde: "2026-11-01", hasta: "2026-11-10", ong: "B", captadores: 1, fecha: "2026-10-20", res: "denegada", seg: "2026-10-01" }      /* resuelta: no cuenta */
] });
const segs = ctx.seguimientosDe(pt2, p2), recs2 = ctx.expedientesDe(pt2, p2), ind2 = ctx.indicadores(recs2, segs, t), cs = (e) => segs.filter((x) => ctx.pred.seg(e, x, t)).length;
ok(segs.length === 4, "Solo cuentan los seguimientos de solicitudes pendientes (4)");
ok(cs("vencido") === ind2.segVencidos.length && cs("vencido") === 1, "Atrasados coinciden con el Panel (1)");
ok(cs("hoy") === ind2.segHoy.length && cs("hoy") === 1, "Para hoy coinciden con el Panel (1)");
ok(cs("proximo") === ind2.segProximos.length && cs("proximo") === 1, "Próximos 7 días coinciden con el Panel (1: el de 7 días sí, el de 8 no)");
ok(cs("sinresp") === 1 && cs("todas") === 4, "Sin responsable y total");
// Avisos: la bandeja usa la misma lista de incidencias que el Panel.
ok(bloque.includes("incidencias(recsAmb, t)") && ind2.incidencias.length === ctx.incidencias(recs2, t).length, "Los avisos salen de incidencias()");

// Cambios de «aplica()»: cada mutador se prueba sobre una copia del estado del punto.
const m0 = bloque.indexOf("  const ubica = "), m1 = bloque.indexOf("\n  };\n", bloque.indexOf("const mutadores = {")) + 6;
ok(m0 >= 0 && m1 > m0, "No se encuentran los mutadores");
const M = runInNewContext(
  "const permits = {}; const permitKey = (c) => c.id; const permOf = (c) => permits[permitKey(c)] || {};\n" + html.slice(i0, i2) + "\n" + bloque.slice(m0, m1) + "\n({ mutadores, ubica, today })",
  { Date: Falsa, self: { crypto: { randomUUID: (() => { let n = 0; return () => "id-" + (++n); })() } } }
);
const nuevo = () => ({ solicitudes: [{ id: "s1", desde: "2026-11-01", hasta: "2026-11-10", captadores: 2, ong: "A", fecha: "2026-10-20", seg: "2026-10-30", contacto: "Ana", notas: "n" }, { id: "s2", res: "denegada", resFecha: "2026-10-21", fecha: "2026-10-20" }], historial: [{ id: "g1", desde: "2026-10-01", hasta: "2026-12-01", ong: "A", captadores: 3 }] });
let cp = nuevo();
ok(M.mutadores.conceder({ id: "s1" })(cp) === undefined && cp.solicitudes[0].res === "aprobada" && cp.historial.length === 2, "Conceder aprueba la solicitud y crea la concesión");
const g = cp.historial[1];
ok(g.sol === "s1" && g.desde === "2026-11-01" && g.hasta === "2026-11-10" && g.captadores === 2 && g.ong === "A" && g.contacto === "Ana" && g.notas === "n" && cp.solicitudes[0].conc === g.id, "La concesión nace con los datos de la solicitud y queda enlazada");
ok(typeof M.mutadores.conceder({ id: "s1" })(cp) === "string", "Conceder una solicitud ya resuelta se aborta sin cambios (doble clic)");
ok(typeof M.mutadores.conceder({ id: "s2" })(nuevo()) === "string" && typeof M.mutadores.conceder({ id: "nada" })(nuevo()) === "string", "Conceder una denegada o inexistente se aborta");
cp = nuevo(); M.mutadores.resolver({ id: "s1" }, "retirada", "La ONG desiste")(cp);
ok(cp.solicitudes[0].res === "retirada" && cp.solicitudes[0].motivo === "La ONG desiste" && cp.solicitudes[0].resFecha === t && cp.historial.length === 1, "Retirar guarda motivo y fecha y no crea concesión");
cp = nuevo(); M.mutadores.cancelar({ id: "g1" }, "Se acaba")(cp);
ok(cp.historial[0].cancelada === true && cp.historial[0].resFecha === t && cp.historial[0].motivo === "Se acaba", "Cancelar marca la concesión con fecha y motivo");
M.mutadores.reactivar({ id: "g1" })(cp);
ok(!cp.historial[0].cancelada && !cp.historial[0].resFecha, "Reactivar quita la cancelación");
cp = nuevo(); M.mutadores.quitarSol({ id: "s2" })(cp); M.mutadores.quitarCon({ id: "g1" })(cp);
ok(cp.solicitudes.length === 1 && cp.historial.length === 0, "Quitar borra solo el registro elegido");
cp = nuevo(); M.mutadores.cerrarSeg({ i: 0, punto: false })(cp);
ok(cp.solicitudes[0].seg === "" && cp.solicitudes[1].seg === undefined, "«Hecho» cierra solo el seguimiento de esa solicitud");
cp = { segPunto: { fecha: "2026-10-30", fu: "f1" }, solicitudes: [], historial: [] }; M.mutadores.cerrarSeg({ punto: true, i: -1 })(cp);
ok(!cp.segPunto, "«Hecho» cierra el seguimiento del punto");

// Buscador de punto del formulario: sin tildes, por palabras sueltas, con el nombre que empieza igual primero.
const b0 = bloque.indexOf("  const indiceBusqueda = "), b1 = bloque.indexOf("  const buscaPunto = ");
ok(b0 >= 0 && b1 > b0, "No se encuentra el buscador de punto");
const S = runInNewContext(
  "const sinAcentos = (t) => String(t || '').normalize('NFD').replace(/[\\u0300-\\u036f]/g, '').toLowerCase().trim();\nconst townOf = (c) => c.town || c.province || 'Sin municipio';\nconst antes = (a, b) => a.localeCompare(b, 'es');\n" + bloque.slice(b0, b1) + "\n({ encuentra })",
  {}
);
const C = [
  { id: 1, name: "Mercadona", town: "Almería", province: "Almería", street: "Calle Real 4", tipo: "Supermercado" },
  { id: 2, name: "Hospital Mercedes", town: "Granada", province: "Granada", street: "Av. de la Constitución 2", tipo: "Hospital" },
  { id: 3, name: "Super Mercadona Norte", town: "Roquetas de Mar", province: "Almería", street: "Camino Viejo", tipo: "Supermercado" },
  { id: 4, name: "CS Armilla", town: "Armilla", province: "Granada", street: "Calle Mayor", tipo: "Centro de salud" }
];
const nombres = (txt) => S.encuentra(txt, C).map((c) => c.name);
ok(nombres("almeria").join() === "Mercadona,Super Mercadona Norte", "Ignora tildes y busca también en el municipio y la provincia");
ok(nombres("mercadona")[0] === "Mercadona" && nombres("mercadona").length === 2, "El nombre que empieza por lo escrito va primero");
ok(nombres("merca roquetas").join() === "Super Mercadona Norte", "Varias palabras: todas deben aparecer, en nombre o lugar");
ok(nombres("constitucion").join() === "Hospital Mercedes", "También busca en la calle");
ok(nombres("a").length === 0 && nombres("   ").length === 0 && nombres("zzz").length === 0, "Menos de dos letras o sin coincidencias, nada");
ok(bloque.includes("MAX_RESULTADOS") && bloque.includes("escribe más para afinar"), "Avisa cuando hay más resultados de los que se muestran");

// Enlaces cruzados: cada cifra del Panel tiene su filtro equivalente en el Centro y da la misma cifra.
const pa0 = html.indexOf("const EN_CENTRO = {"), pa1 = html.indexOf("\n  };\n", pa0) + 6;
ok(pa0 >= 0 && pa1 > pa0, "No se encuentra la tabla de enlaces del Panel");
const tabla = Object.fromEntries([...html.slice(pa0, pa1).matchAll(/(\w+): \["(\w+)", "(\w+)"\]/g)].map((m) => [m[1], [m[2], m[3]]]));
const claves = [...html.matchAll(/^      \["(\w+)", "[^"]+", "[^"]+", "[^"]+", "[^"]*"\]/gm)].map((m) => m[1]);
ok(claves.length >= 15, "No se leen las cifras del Panel");
for (const k of [...claves, "capacidadHoy"]) ok(tabla[k], "La cifra «" + k + "» del Panel no tiene enlace al Centro");
const opcionesCentro = (v) => [...bloque.slice(bloque.indexOf("const OPC = {"), bloque.indexOf("const COLOR")).matchAll(new RegExp(v + ": \\[(.*)\\]", "g"))].map((m) => [...m[1].matchAll(/\["(\w+)"/g)].map((x) => x[1]))[0] || [];
for (const [k, [v, e]] of Object.entries(tabla)) ok(v === "inc" || opcionesCentro(v).includes(e), "El enlace de «" + k + "» apunta a un filtro que no existe en el Centro: " + v + ":" + e);
// Las cifras de vencimientos, futuras y pendientes sin seguimiento coinciden con las del Panel.
const cnt = (v, e) => recs.filter((r) => r.k === v && ctx.pred[v](e, r, t)).length;
ok(cnt("con", "vencen7") === ind.vencen7.length && ind.vencen7.length === 1, "Vencen en 0–7 días: Centro y Panel (1: el de 5 días)");
ok(cnt("con", "vencen15") === ind.vencen15.length && cnt("con", "vencen30") === ind.vencen30.length && ind.vencen30.length === 1, "Vencen en 8–15 y 16–30 días coinciden con el Panel");
ok(cnt("con", "futuras30") === ind.futuras30.length, "Empiezan en los próximos 30 días coincide con el Panel");
ok(cnt("sol", "sinseg") === ind.sinSeguimiento.length && ind.sinSeguimiento.length === 2, "Pendientes sin seguimiento coincide con el Panel (2)");
ok(html.includes('id="pnCentro"') && html.includes('new CustomEvent("centro:abrir"') && html.includes('document.addEventListener("centro:abrir"'), "Panel, Calendario y Centro se comunican con el evento centro:abrir");
ok(html.includes('data-centro="sol:pendiente"') && html.includes('data-centro="con:vigente"') && html.includes('data-centro="seg:todas"') && html.includes("detail: { vista, est, prov, ong }"), "El Calendario abre el Centro con su provincia y su ONG");
ok(bloque.includes("claveOngDe(x) === ong.trim().toLowerCase()"), "El filtro de ONG del Centro no distingue mayúsculas, como el del Panel");

// La ficha ya no gestiona expedientes: el Panel, el Calendario y la ficha llevan al Centro filtrado por ese punto.
ok(!html.includes("fichaTabPedida"), "Ya no hay pestañas de permisos en la ficha que pedir");
ok(html.includes('data-v="' + "' + f.v + '" + '"') || html.includes("data-v=\"' + f.v + '\""), "Las filas del detalle del Panel llevan su vista");
ok(html.includes('detail: { punto: c, vista: tr.dataset.v || "sol", est: "todas" }') && html.includes('detail: { punto: c, vista: pt.dataset.v || "sol", est: "todas" }'), "Panel y Calendario abren el Centro filtrado por el punto");
ok(bloque.includes("(!punto || String(x.c.id) === String(punto.id))") && bloque.includes("data-quita-punto") && bloque.includes("abreForm(nw.dataset.new, punto, null)"), "El Centro filtra por punto, permite quitar el filtro y da de alta en ese punto");
ok(bloque.includes('new CustomEvent("permisos:cambio", { detail: { id: c.id } })'), "El Centro avisa a la ficha abierta de que el punto ha cambiado");

// Móvil: sin desbordamiento horizontal del diálogo (medido en un marco de 390 px).
ok(/\.ce-nav \{[^}]*overflow-x: auto;/.test(html) && /@media \(max-width: 700px\) \{[\s\S]*?\.ce-tabla thead \{ display: none; \}/.test(html), "La navegación del Centro se desplaza por dentro y las tablas pasan a tarjetas en móvil");
ok(/\.pn-scroll \{[^}]*overflow-x: auto;[^}]*position: relative;/.test(html), "El contenedor de las tablas es su propia referencia de posición: los textos ocultos (adm-sr) de la última columna no deben alargar el diálogo");

// Auditoría 25/10/2026: el estado de guardado se libera siempre y los fallos parciales se explican.
ok(/try \{ res = await aplica\(c, muta\); \}\s*catch \(e\) \{[\s\S]*?\} finally \{ ocupado = false; \}/.test(bloque), "ejecuta() libera «ocupado» en un finally: una excepción no deja el Centro bloqueado");
ok(bloque.includes("try { r = await savePermits(c); } catch (e)") && bloque.includes("try { gamPermit(c, previo); } catch (e)"), "aplica() no se rompe si savePermits o la gamificación lanzan");
ok(bloque.includes("Se aplicaron \" + ultimoGuardado.hechas + \" de \" + ultimoGuardado.total") && bloque.includes("Lo guardado no coincide con lo esperado"), "Un guardado a medias o no verificado se explica");
ok(html.includes("const mal = verificaOps(ops, relBase.get(key) || { sols: [], hist: [] });") && html.includes("estadoOps.noVerificadas = mal; result = \"error\";"), "savePermits verifica por relectura que se guardó lo esperado");

ok((bloque.match(/form\.idNuevo \|\| \(form\.idNuevo = newId\(\)\)/g) || []).length === 2, "Las altas del formulario usan un identificador estable entre intentos (el reintento tras un fallo parcial no duplica)");

// Rediseño (25/10/2026): centro de mando, detalle lateral, ordenación y lotes.
ok(bloque.includes("drawResumen") && bloque.includes("resumenDatos(recsAmb, segsAmb, t, incsAmb, filasJ)"), "El Resumen se calcula con las funciones compartidas (resumenDatos) y las mismas listas que el Panel");
for (const k of ["grafCapacidad", "grafSemanas", "barraSvg", "tablaCapacidad", "tablaSemanas"]) ok(bloque.includes("const " + k + " = "), "Gráfico o tabla alternativa: " + k);
ok(bloque.includes('data-tabla="') && bloque.includes("Ver como tabla") && bloque.includes("role=\"img\" aria-label="), "Cada gráfico tiene descripción accesible y vista como tabla");
ok(bloque.includes('<title>') && bloque.includes("captadores autorizados · "), "Cada columna del gráfico lleva su valor (tooltip y lector de pantalla)");
ok(html.includes("--ch-aut: #16a34a; --ch-dem: #d97706; --ch-1: #3b6fb6;") && html.includes("--ch-a1: #55647e; --ch-a2: #7d8ca6; --ch-a3: #a9b6ca;"), "Colores de los gráficos como tokens, con variante oscura (validados con la guía de visualización)");
ok(/\.ce-b-dem \{ fill: url\(#ceHatch\); \}/.test(html) && bloque.includes('id="ceHatch"'), "La demanda pendiente se distingue de la capacidad con textura (no solo con color)");
ok(bloque.includes("Nunca se suma a la capacidad autorizada") && bloque.includes("Es la capacidad real"), "Las definiciones dicen que la demanda no se suma a la capacidad");
ok(bloque.includes('<details class="ce-defs">') && bloque.includes("Cómo se calcula cada indicador"), "Cada indicador tiene su definición");
ok(bloque.includes("const ORDENES = {") && ["sol", "con", "seg", "inc"].every((v) => bloque.includes(v + ": [[\"auto\"")), "Ordenación configurable en las cuatro bandejas");
ok(bloque.includes("const drawDetalle = ") && bloque.includes('aria-label="Detalle del expediente"') && bloque.includes("Expedientes de este punto") && bloque.includes("bloqueosDe(r)"), "Detalle lateral con los expedientes del punto y las razones por las que una acción no está disponible");
ok(bloque.includes("sel = fr.dataset.key; accion = null; draw();") && !/sel = ""[^;]*mostrar = TRAMO/.test(bloque), "Abrir el detalle no recarga la lista ni pierde filtros, selección ni posición");
ok(html.includes('from("audit_log").select("action,table_name,created_at,actor_id,details").in("record_id", ids)') && bloque.includes("if (!esAdmin() || historial.has(k)) return;"), "El historial sale de audit_log y solo se pide a administradores (la RLS ya lo limita a ellos)");
ok(bloque.includes("Sin cambios registrados para este expediente.") && bloque.includes("No se pudo leer el historial"), "El historial dice cuando no hay datos o falla, sin inventar");
ok(bloque.includes("const ejecutaLote = async () =>") && /for \(let i = 0; i < sels\.length; i\+\+\)[\s\S]*?await aplica\(s\.c, lote\.tipo === "hecho"/.test(bloque), "El lote guarda y verifica cada seguimiento por separado con aplica()");
ok(bloque.includes("Vas a ") && bloque.includes("Cada seguimiento se guarda y se comprueba por separado") && bloque.includes("fase: \"confirmar\""), "El lote enseña un resumen previo y pide confirmación");
ok(bloque.includes("lote = { fase: \"resultado\"") && bloque.includes("guardados\" + (mal ? \" y \" + mal + \" sin guardar\"") && bloque.includes("quedan seleccionados los que no se pudieron guardar"), "El lote da el resultado de cada registro y deja seleccionados los fallidos");
ok(/finally \{ ocupado = false; \}\s*tocados\.forEach/.test(bloque), "El lote libera el estado de guardado aunque falle");
ok(bloque.includes("sev:") && bloque.includes("SEV_ORDEN.map((k) => [\"sev:\" + k"), "Los avisos se filtran por gravedad");
ok(bloque.includes('class="ce-sev ' ) && /\.ce-sev\.bl i \{[^}]*rotate\(45deg\)/.test(html) && /\.ce-sev\.re i \{[^}]*border: 2px solid/.test(html), "La gravedad se codifica con color y forma (rombo, punto, anillo) además de texto");
ok(bloque.includes("data-cal=") && bloque.includes('$("#calBtn").click()'), "Acceso al Calendario desde el Centro");

// Cambiar la fecha de un seguimiento (formulario y lotes): conserva acción y responsable cuando no se indican.
{
  const cs = M.mutadores.cambiarSeg;
  let cp2 = { solicitudes: [{ id: "s1", seg: "2026-10-30", accion: "Llamar", resp: "u1" }, { id: "s2", res: "denegada", seg: "2026-10-30" }], historial: [{ id: "g1", seg: "2026-10-30", accion: "Revisar", resp: "u2" }, { id: "g2", cancelada: true, seg: "2026-10-30" }], segPunto: { fecha: "2026-10-30", accion: "Visitar", resp: "u3" } };
  ok(cs({ i: 0 }, "2026-11-05")(cp2) === undefined && cp2.solicitudes[0].seg === "2026-11-05" && cp2.solicitudes[0].accion === "Llamar" && cp2.solicitudes[0].resp === "u1", "Reprogramar una solicitud conserva acción y responsable");
  ok(cs({ i: 0, con: true }, "2026-11-06")(cp2) === undefined && cp2.historial[0].seg === "2026-11-06" && cp2.historial[0].accion === "Revisar", "Reprogramar el seguimiento de una concesión");
  ok(cs({ punto: true }, "2026-11-07")(cp2) === undefined && cp2.segPunto.fecha === "2026-11-07" && cp2.segPunto.accion === "Visitar" && cp2.segPunto.resp === "u3", "Reprogramar el seguimiento del punto");
  cs({ i: 0 }, "2026-11-08", "", "")(cp2);
  ok(cp2.solicitudes[0].accion === undefined && cp2.solicitudes[0].resp === undefined && cp2.solicitudes[0].seg === "2026-11-08", "Con acción y responsable vacíos (formulario) se quitan");
  ok(typeof cs({ i: 1 }, "2026-11-09")(cp2) === "string" && typeof cs({ i: 1, con: true }, "2026-11-09")(cp2) === "string" && typeof cs({ i: 9 }, "2026-11-09")(cp2) === "string", "No se reprograma lo resuelto, lo cancelado ni lo que ya no existe");
  let cp3 = { solicitudes: [], historial: [{ id: "g1", seg: "2026-10-30" }] }; M.mutadores.cerrarSeg({ i: 0, con: true })(cp3);
  ok(cp3.historial[0].seg === "", "«Hecho» en un seguimiento de concesión cierra solo ese");
}
// Filtros por antigüedad del Resumen: coinciden con los tramos de resumenDatos.
{
  const hoyR = ctx.today(), cuentaEdad = (e) => recs.filter((r) => r.k === "sol" && ctx.pred.sol(e, r, hoyR)).length;
  ok(cuentaEdad("edad0") + cuentaEdad("edad8") + cuentaEdad("edad16") + cuentaEdad("edad31") === ind.pendientes.length, "Los cuatro tramos de antigüedad suman las pendientes con fecha de solicitud (las mismas del Resumen)");
}

ok(bloque.includes('if (selProv.value !== prov) selProv.value = prov;'), "El selector de provincia refleja el filtro aunque cambie desde el Resumen");

// Regresión (25/10/2026): «Avisos de datos» lanzaba una excepción al dibujar porque la cabecera de seguimientos evaluaba clave() sobre filas de avisos.
ok(bloque.includes('(vista === "seg" && vis.length && vis.every((s) => multi.has(clave(s)))'), "La casilla de seleccionar todos solo se evalúa en la vista de seguimientos");
ok(/const draw = \(\) => \{\s*if \(!body\.firstChild\) return;[^\n]*\n\s*try \{ dibuja\(\); \}\s*catch \(e\) \{[\s\S]*?No se pudo dibujar esta vista/.test(bloque), "Un fallo al dibujar se registra y se avisa, sin dejar la pantalla a medias");

console.log("Centro de permisos: " + n + " comprobaciones correctas.");

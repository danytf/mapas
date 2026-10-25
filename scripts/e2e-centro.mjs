// Prueba de extremo a extremo del Centro de permisos en un Chrome real (sin dependencias: habla con Chrome por el protocolo de depuración).
// Levanta el Supabase simulado (scripts/dev/mock-supabase.mjs), sirve una copia de index.html apuntando a él, carga datos sintéticos y recorre la
// aplicación como administrador, como usuario de una provincia y en un móvil de 390 px. Falla ante CUALQUIER excepción de la página o error de consola
// que no esté esperado (los fallos de guardado se provocan a propósito y se declaran). No toca ninguna base real.
// Uso: node scripts/e2e-centro.mjs            (necesita Chrome o Chromium; CHROME_PATH indica otro; E2E_HTML prueba otro index.html, p. ej. una versión anterior)
import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import { existsSync, mkdtempSync, rmSync, readFileSync } from "node:fs";
import { createServer } from "node:http";
import { tmpdir } from "node:os";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { seed } from "./dev/seed-permits-demo.mjs";

const RAIZ = join(dirname(fileURLToPath(import.meta.url)), ".."), MOCK = "http://127.0.0.1:8766", WEB = "http://127.0.0.1:8767", CDP = 9333;
const esperaMs = (ms) => new Promise((r) => setTimeout(r, ms));
const hasta = async (cond, ms = 20000, que = "condición") => { const t0 = Date.now(); while (Date.now() - t0 < ms) { try { const v = await cond(); if (v) return v; } catch { /* aún no */ } await esperaMs(150); } throw new Error("Tiempo agotado esperando: " + que); };
let comprobaciones = 0;
const ok = (cond, msg) => { assert.ok(cond, msg); comprobaciones++; };
const eq = (a, b, msg) => { assert.deepStrictEqual(a, b, msg); comprobaciones++; };

const buscaChrome = () => {
  const c = [process.env.CHROME_PATH, "C:/Program Files/Google/Chrome/Application/chrome.exe", "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe", "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe", "/usr/bin/google-chrome", "/usr/bin/google-chrome-stable", "/usr/bin/chromium", "/usr/bin/chromium-browser", "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"];
  return c.find((x) => x && existsSync(x));
};
const chrome = buscaChrome();
if (!chrome) { console.log("SIN CHROME: no se puede ejecutar la prueba de extremo a extremo (define CHROME_PATH)."); process.exit(process.env.CI ? 1 : 0); }

const tmp = mkdtempSync(join(tmpdir(), "e2e-centro-"));
const procesos = [];
const lanza = (cmd, args, opts = {}) => { const p = spawn(cmd, args, { stdio: "ignore", ...opts }); procesos.push(p); return p; };
let servidor, cierraTodo = () => {};

/* Cliente mínimo del protocolo de depuración de Chrome. */
const conectaCdp = async (wsUrl, onEvento) => {
  const ws = new WebSocket(wsUrl); await new Promise((res, rej) => { ws.addEventListener("open", res); ws.addEventListener("error", rej); });
  let id = 0; const pend = new Map();
  ws.addEventListener("message", (ev) => { const m = JSON.parse(ev.data); if (m.id && pend.has(m.id)) { const { res, rej } = pend.get(m.id); pend.delete(m.id); m.error ? rej(new Error(m.error.message)) : res(m.result); } else onEvento(m); });
  return { send: (method, params = {}) => new Promise((res, rej) => { const i = ++id; pend.set(i, { res, rej }); ws.send(JSON.stringify({ id: i, method, params })); }), close: () => ws.close() };
};

const fallos = []; let permitidos = []; /* errores de consola esperados en la fase actual */
const registra = (m) => {
  if (m.method === "Runtime.exceptionThrown") { const d = m.params.exceptionDetails; fallos.push("EXCEPCIÓN: " + (d.exception?.description || d.text).split("\n").slice(0, 3).join(" | ")); }
  else if (m.method === "Runtime.consoleAPICalled" && m.params.type === "error") {
    const t = m.params.args.map((a) => a.value ?? a.description ?? "").join(" ");
    if (!permitidos.some((re) => re.test(t))) fallos.push("ERROR DE CONSOLA: " + t.slice(0, 200));
  }
};

const main = async () => {
  /* Supabase simulado, copia de la aplicación y servidor estático */
  lanza(process.execPath, [join(RAIZ, "scripts/dev/mock-supabase.mjs")]);
  await hasta(async () => (await fetch(MOCK + "/__rel")).ok, 15000, "el Supabase simulado");
  const salida = join(tmp, "web"); const { mkdirSync } = await import("node:fs"); mkdirSync(salida);
  await new Promise((res, rej) => spawn(process.execPath, [join(RAIZ, "scripts/dev/build-mock-site.mjs"), process.env.E2E_HTML || join(RAIZ, "index.html"), join(salida, "index.html")], { stdio: "ignore" }).on("exit", (c) => c === 0 ? res() : rej(new Error("build-mock-site falló"))));
  const html = readFileSync(join(salida, "index.html"));
  servidor = createServer((req, res) => { res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" }); res.end(html); }).listen(8767, "127.0.0.1");
  cierraTodo = () => { servidor?.close(); procesos.forEach((p) => { try { p.kill(); } catch { /* ya cerrado */ } }); try { rmSync(tmp, { recursive: true, force: true }); } catch { /* en uso */ } };

  lanza(chrome, ["--headless=new", "--remote-debugging-port=" + CDP, "--user-data-dir=" + join(tmp, "perfil"), "--no-first-run", "--no-default-browser-check", "--no-sandbox", "--disable-gpu", "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "--window-size=1440,900", "about:blank"]);
  const pestana = await hasta(async () => (await (await fetch("http://127.0.0.1:" + CDP + "/json")).json()).find((t) => t.type === "page"), 20000, "Chrome");
  const c = await conectaCdp(pestana.webSocketDebuggerUrl, registra);
  await c.send("Runtime.enable"); await c.send("Page.enable");
  const ev = async (expresion) => { const r = await c.send("Runtime.evaluate", { expression: "(async()=>{" + expresion + "})()", awaitPromise: true, returnByValue: true }); if (r.exceptionDetails) throw new Error("Fallo en la página: " + (r.exceptionDetails.exception?.description || r.exceptionDetails.text)); return r.result.value; };
  const rel = async () => (await fetch(MOCK + "/__rel")).json();
  const ayudas = `const w=(ms)=>new Promise(r=>setTimeout(r,ms)); const b=()=>document.getElementById('ceBody'); const nav=(v)=>{b().querySelector('#ceNav [data-vista='+v+']').click();};
    const set=(id,v)=>{const e=b().querySelector('#'+id); e.value=v; e.dispatchEvent(new Event('input',{bubbles:true})); e.dispatchEvent(new Event('change',{bubbles:true}));};
    const d=(k)=>new Date(Date.now()+k*864e5).toISOString().slice(0,10);`;
  const abre = async (usuario, ancho = 1440, alto = 900) => {
    await fetch(MOCK + "/__reset"); await seed(MOCK);
    await c.send("Emulation.setDeviceMetricsOverride", { width: ancho, height: alto, deviceScaleFactor: 1, mobile: ancho < 700 });
    await c.send("Page.navigate", { url: WEB + "/?u=" + Date.now() });
    await hasta(() => ev("return document.readyState === 'complete' && !!document.querySelector('#login input') && typeof L === 'object' && typeof window.supabase === 'object';"), 30000, "la pantalla de acceso");
    await esperaMs(800); /* los manejadores de la aplicación se registran al terminar de cargar */
    await ev("const ins=[...document.querySelectorAll('#login input')]; ins[0].value=" + JSON.stringify(usuario) + "; ins[1].value='x'; ins.forEach(i=>i.dispatchEvent(new Event('input',{bubbles:true}))); document.querySelector('#login button[type=submit]').click(); return 1;");
    try { await hasta(() => ev("return !!window.mapaSession && /cargados/.test(document.getElementById('status').textContent);"), 30000, "el inicio de sesión de " + usuario); }
    catch (e) { throw new Error(e.message + " (estado: " + JSON.stringify(await ev("return { sesion: !!window.mapaSession, estado: document.getElementById('status').textContent, login: getComputedStyle(document.getElementById('login')).display, leaflet: typeof L, supabase: typeof window.supabase };")) + ")"); }
    await ev("document.getElementById('menuBtn').click(); document.getElementById('centroBtn').click(); await new Promise(r=>setTimeout(r,1200)); return 1;");
  };

  /* ===== 1. Administrador: recorrido de todas las vistas, estados, órdenes y detalle ===== */
  await abre("admin@test.es");
  const r1 = await ev(ayudas + `
    const out = { vistas: {}, cabeceras: [] };
    const CAP = { res: 'Resumen', sol: 'Solicitudes', con: 'Concesiones', seg: 'Seguimientos', inc: 'Avisos de datos' };
    out.nav = [...b().querySelectorAll('#ceNav button')].map(x => x.innerText.replace(/\\n/g,' '));
    out.ayudaNav = [...b().querySelectorAll('#ceNav button')].filter(x => x.querySelector('.n')).map(x => [x.getAttribute('aria-label'), x.title, x.querySelector('.n').textContent, x.querySelector('.n').hidden]);
    out.kpis = b().querySelectorAll('.ce-kpis .kpi').length; out.svgs = b().querySelectorAll('svg.ce-svg').length; out.cards = b().querySelectorAll('.ce-card').length;
    for (const v of ['res','sol','con','seg','inc']) {
      nav(v); await w(250); const info = { caption: b().querySelector('#ceList table caption')?.textContent || null, estados: 0, descuadres: [], detalle: false };
      if (v !== 'res') {
        const sel = b().querySelector('#ceEst');
        for (const o of [...sel.options]) {
          sel.value = o.value; sel.dispatchEvent(new Event('change',{bubbles:true})); await w(60);
          const n = +(o.text.match(/\\((\\d+)\\)\\s*$/)||[])[1], filas = b().querySelectorAll('#ceList tr.ce-row').length, cuenta = b().querySelector('.ce-count')?.textContent || '';
          const total = +(cuenta.match(/^(\\d+)/)||[])[1] || 0;
          if (n !== total && !(n === 0 && filas === 0)) info.descuadres.push(o.text + ' → ' + cuenta);
          if (filas && b().querySelector('#ceList table caption')?.textContent !== CAP[v]) out.cabeceras.push(v + ':' + o.text);
          info.estados++;
        }
        const ord = b().querySelector('#ceOrd'); for (const o of [...ord.options]) { ord.value = o.value; ord.dispatchEvent(new Event('change',{bubbles:true})); await w(50); }
        ord.value = ord.options[0].value; ord.dispatchEvent(new Event('change',{bubbles:true})); sel.value = sel.options[0].value; sel.dispatchEvent(new Event('change',{bubbles:true})); await w(100);
        const pt = b().querySelector('#ceList tr.ce-row .ce-pt'); if (pt) { pt.click(); await w(250); info.detalle = !b().querySelector('#ceSide').hidden && !!b().querySelector('#ceSide .ce-datos'); b().querySelector('[data-cierra-lado]')?.click(); await w(100); }
      }
      out.vistas[v] = info;
    }
    return out;`);
  eq(r1.nav.length, 5, "cinco secciones de navegación"); ok(r1.ayudaNav.length === 4 && r1.ayudaNav.every(([al, ti, n, oculto]) => (oculto ? /^0 / : new RegExp("^" + n + " ")).test(ti) && /^(Solicitudes|Concesiones|Seguimientos|Avisos de datos): /.test(al) && al.endsWith(ti)), "cada número de la navegación dice qué cuenta (ayuda y etiqueta accesible)"); ok(r1.ayudaNav.some(([al]) => /^Concesiones: \d+ vigentes? hoy$/.test(al)), "Concesiones cuenta las vigentes hoy"); ok(r1.kpis === 6 && r1.svgs >= 3 && r1.cards >= 8, "el Resumen tiene sus indicadores, gráficos y tarjetas");
  for (const v of ["sol", "con", "seg", "inc"]) { ok(r1.vistas[v].estados >= 4, v + ": se recorrieron sus estados"); ok(r1.vistas[v].detalle, v + ": el detalle se abre"); eq(r1.vistas[v].descuadres, [], v + ": el número de cada estado coincide con las filas"); }
  eq(r1.cabeceras, [], "cada vista dibuja su propia tabla (no la de la vista anterior)");

  /* Las cifras del Resumen coinciden con las del Panel resumen */
  const r1b = await ev(ayudas + `
    nav('res'); await w(300); const centro = [...b().querySelectorAll('.ce-kpis .kpi')].map(k => +k.querySelector('b').textContent);
    document.getElementById('ceClose').click(); await w(200); document.getElementById('menuBtn').click(); document.getElementById('panelBtn').click(); await w(600);
    const pk = (k) => +document.querySelector('#pnBody [data-ind=' + k + '] b').textContent; const panel = [pk('pendientes'), pk('estancadas'), pk('vigentes'), pk('segVencidos')];
    document.getElementById('pnClose').click(); await w(200); document.getElementById('menuBtn').click(); document.getElementById('centroBtn').click(); await w(800);
    return { centro: [centro[0], centro[1], centro[2], centro[4]], panel };`);
  eq(r1b.centro, r1b.panel, "pendientes, estancadas, vigentes y seguimientos atrasados: Resumen = Panel");

  /* ===== 2. Escritura: cada acción se guarda, se verifica y es visible en la base ===== */
  const r2 = await ev(ayudas + `
    const out = {}; const rel = () => fetch('http://127.0.0.1:8766/__rel').then(r => r.json());
    nav('sol'); await w(250); set('ceEst','pendiente'); await w(200);
    const a0 = (await rel()).permit_applications.filter(a => a.status === 'approved').length;
    b().querySelector('[data-act=conceder]').click(); await w(2500); out.conceder = b().querySelector('#ceAviso').textContent; let r = await rel(); out.aprobadas = r.permit_applications.filter(a => a.status === 'approved').length - a0; out.enlazada = r.permit_grants.filter(g => g.application_id).length;
    b().querySelector('tr.ce-row .ce-pt').click(); await w(300); b().querySelector('#ceSide [data-act=den]').click(); await w(300); out.motivoEnfocado = document.activeElement.id === 'ceMotivo'; b().querySelector('#ceMotivo').value = 'Prueba E2E'; b().querySelector('#ceSide [data-conf=ok]').click(); await w(2500);
    out.denegar = b().querySelector('#ceAviso').textContent; out.denegadas = (await rel()).permit_applications.filter(a => a.resolution_reason === 'Prueba E2E').length; b().querySelector('[data-cierra-lado]')?.click();
    nav('con'); await w(250); set('ceEst','vigente'); await w(200); b().querySelector('[data-act=can]').click(); await w(300); b().querySelector('#ceMotivo').value = 'Fin E2E'; b().querySelector('[data-conf=ok]').click(); await w(2500);
    out.cancelada = (await rel()).permit_grants.filter(g => g.cancelled_reason === 'Fin E2E').length; set('ceEst','cancelada'); await w(250);
    b().querySelector('[data-act=rea]').click(); await w(2500); out.reactivada = (await rel()).permit_grants.filter(g => g.cancelled_reason === 'Fin E2E' && g.status === 'active').length;
    nav('sol'); b().querySelector('[data-new=sol]').click(); await w(300); set('cfPunto','roquetas'); await w(250); b().querySelector('[data-pick="0"]').click(); await w(250);
    set('cfDesde', d(5)); set('cfHasta', d(9)); set('cfN','3'); set('cfOng','ONG E2E'); set('cfSeg', d(2)); set('cfAccion','Llamar E2E'); b().querySelector('#cfGuardar').click(); await w(2800);
    r = await rel(); out.alta = [r.permit_applications.filter(a => a.organization === 'ONG E2E').length, r.followups.filter(f => f.next_action === 'Llamar E2E').length]; out.formCerrado = b().querySelector('#ceForm').hidden;
    /* añadir un seguimiento a una solicitud ya guardada sin él: debe aparecer en la base y en la lista de Seguimientos */
    b().querySelector('[data-new=sol]').click(); await w(300); set('cfPunto','roquetas'); await w(250); b().querySelector('[data-pick="0"]').click(); await w(250);
    set('cfDesde', d(6)); set('cfHasta', d(10)); set('cfN','2'); set('cfOng','ONG SinSeg'); b().querySelector('#cfGuardar').click(); await w(2800);
    r = await rel(); const appSin = r.permit_applications.find(a => a.organization === 'ONG SinSeg'); out.sinSeg = [!!appSin, appSin ? r.followups.filter(f => f.application_id === appSin.id).length : -1];
    set('ceEst','todas'); await w(300);
    const fila = [...b().querySelectorAll('#ceList tr.ce-row')].find(tr => tr.textContent.includes('ONG SinSeg')); out.filaSinSeg = !!fila;
    fila.querySelector('.ce-pt').click(); await w(300); b().querySelector('#ceSide [data-act=ed]').click(); await w(400);
    set('cfSeg', d(4)); set('cfAccion', 'Seguimiento añadido después'); b().querySelector('#cfGuardar').click(); await w(2800);
    out.avisoSinSeg = b().querySelector('#ceAviso').textContent;
    r = await rel(); out.trasEditar = appSin ? r.followups.filter(f => f.application_id === appSin.id && !f.completed_at && f.due_on === d(4)).length : -1;
    nav('seg'); await w(250); set('ceEst','todas'); await w(300); out.enLista = [...b().querySelectorAll('#ceList tr')].filter(tr => tr.textContent.includes('Seguimiento añadido después')).length;
    /* una solicitud ya resuelta no ofrece un seguimiento que luego se descartaría */
    nav('sol'); await w(250); set('ceEst','aprobada'); await w(300); b().querySelector('#ceList tr.ce-row .ce-pt').click(); await w(300); b().querySelector('#ceSide [data-act=ed]').click(); await w(400);
    out.resuelta = [!!b().querySelector('#cfSeg'), !!b().querySelector('#cfSinSeg'), !!b().querySelector('#cfDesde')]; b().querySelector('#cfCancelar').click(); await w(200);
    return out;`);
  eq([r2.aprobadas, r2.enlazada >= 1], [1, true], "conceder aprueba la solicitud y crea su concesión enlazada"); ok(/Aprobada y guardada/.test(r2.conceder), "conceder confirma tras verificar");
  ok(r2.motivoEnfocado && r2.denegadas === 1 && /Denegación guardada/.test(r2.denegar), "denegar con motivo desde el detalle");
  eq([r2.cancelada, r2.reactivada], [1, 1], "cancelar con motivo y reactivar una concesión"); eq(r2.alta, [1, 1], "alta de solicitud con su seguimiento (una sola solicitud)"); ok(r2.formCerrado, "el formulario se cierra al guardar"); eq(r2.sinSeg, [true, 0], "una solicitud sin seguimiento no crea ninguno"); ok(r2.filaSinSeg, "la solicitud sin seguimiento aparece en la lista"); eq(r2.trasEditar, 1, "añadir un seguimiento a una solicitud ya guardada lo crea en la base ["+r2.avisoSinSeg+"]"); eq(r2.enLista, 1, "…y aparece en la lista de Seguimientos"); eq(r2.resuelta, [false, true, true], "editar una solicitud resuelta no ofrece seguimiento y lo explica");

  /* ===== 3. Lotes y fallos: resultado por registro, conflicto, caída del servidor y reintento sin duplicados ===== */
  permitidos = [/\[Mapa\] (Error al guardar expedientes|Supabase rechazó una operación de expedientes|Error inesperado)/];
  const r3 = await ev(ayudas + `
    const out = {}; const rel = () => fetch('http://127.0.0.1:8766/__rel').then(r => r.json());
    const marca = async (n) => { for (let i = 0; i < n; i++) { const c = b().querySelector('input[data-chk]:not(:checked)'); c.checked = true; c.dispatchEvent(new Event('change',{bubbles:true})); await w(150); } };
    nav('seg'); await w(250); set('ceEst','vencido'); await w(250); await marca(3); out.seleccion = b().querySelectorAll('input[data-chk]:checked').length;
    b().querySelector('#ceLoteFecha').value = d(11); b().querySelector('[data-lote=rep]').click(); await w(250); out.previo = b().querySelector('#ceLote .ce-lote strong').textContent;
    b().querySelector('[data-lote=ejecutar]').click(); await w(6000); out.lote1 = b().querySelector('#ceLote .ce-lote strong').textContent; out.reprogramados = (await rel()).followups.filter(f => f.due_on === d(11)).length; b().querySelector('[data-lote=cerrar]').click(); await w(200);
    /* asignar responsable en bloque: solo ofrece a quien vale para todos los puntos y se comprueba en la base */
    set('ceEst','todas'); await w(300); await marca(2); await w(1200);
    { const accs = [...b().querySelectorAll('input[data-chk]:checked')].map(i => i.closest('tr').querySelector('td[data-l="Acción prevista"]').textContent);
      const sel = b().querySelector('#ceLoteResp'), opt = [...sel.options].find(o => o.value && o.value !== '__'); out.opcionesResp = [...sel.options].map(o => o.textContent);
      out.sinElegir = (b().querySelector('[data-lote=resp]').click(), await w(200), b().querySelector('#ceAviso').textContent);
      await w(1200); const sel2 = b().querySelector('#ceLoteResp'); sel2.value = opt.value; b().querySelector('[data-lote=resp]').click(); await w(250); out.previoResp = b().querySelector('#ceLote .ce-lote strong').textContent;
      b().querySelector('[data-lote=ejecutar]').click(); await w(5000); out.loteResp = b().querySelector('#ceLote .ce-lote strong').textContent;
      const rr = await rel(); out.respOk = accs.length === 2 && accs.every(a => rr.followups.find(f => f.next_action === a && !f.completed_at)?.assigned_to === opt.value);
      b().querySelector('[data-lote=cerrar]').click(); await w(200); out.accsResp = accs; out.idResp = opt.value; }
    set('ceEst','vencido'); await w(250); await marca(3);
    const acc = [...b().querySelectorAll('input[data-chk]:checked')][0].closest('tr').querySelector('td[data-l="Acción prevista"]').textContent;
    const objetivo = (await rel()).followups.find(f => !f.completed_at && f.next_action === acc);
    await window.mapaSession.supabase.from('followups').update({ next_action: 'Cambiado por otra persona' }).eq('id', objetivo.id); await w(300);
    b().querySelector('[data-lote=hecho]').click(); await w(250); b().querySelector('[data-lote=ejecutar]').click(); await w(6500);
    out.lote2 = b().querySelector('#ceLote .ce-lote strong').textContent; out.lineas = [...b().querySelectorAll('#ceLote .ce-res-lote li')].map(li => li.className); out.quedan = b().querySelectorAll('input[data-chk]:checked').length;
    b().querySelector('[data-lote=cerrar]').click(); await w(200); multi = null;
    /* caída del servidor al conceder: no se aplica y el Centro sigue operativo */
    nav('sol'); await w(250); set('ceEst','pendiente'); await w(250);
    const cli = window.mapaSession.supabase, orig = cli.rpc.bind(cli); cli.rpc = () => ({ abortSignal: async () => { throw new TypeError('Failed to fetch'); } });
    const antes = (await rel()).permit_applications.filter(a => a.status === 'approved').length;
    b().querySelector('[data-act=conceder]').click(); await w(2500); cli.rpc = orig;
    out.caida = b().querySelector('#ceAviso').textContent; out.sinCambios = (await rel()).permit_applications.filter(a => a.status === 'approved').length === antes; out.libre = ![...b().querySelectorAll('[data-act]')].some(x => x.disabled);
    /* alta que falla en la base de datos (create_permit_application es atómica): no queda nada a medias; el reintento crea una sola solicitud y un solo seguimiento */
    b().querySelector('[data-new=sol]').click(); await w(300); set('cfPunto','vera'); await w(250); b().querySelector('[data-pick="0"]').click(); await w(250);
    set('cfDesde', d(5)); set('cfHasta', d(9)); set('cfN','2'); set('cfOng','ONG Reintento'); set('cfSeg', d(3)); set('cfAccion','Reintento E2E');
    cli.rpc = (f, a) => f === 'create_permit_application' ? { abortSignal: async () => ({ error: { code: '500', message: 'caída' }, status: 500 }) } : orig(f, a);
    b().querySelector('#cfGuardar').click(); await w(3000); cli.rpc = orig; out.parcial = b().querySelector('#ceAviso').textContent;
    { const q = await rel(); out.sinMedias = [q.permit_applications.filter(a => a.organization === 'ONG Reintento').length, q.followups.filter(f => f.next_action === 'Reintento E2E').length]; }
    b().querySelector('#cfGuardar').click(); await w(3000); const r = await rel(); out.reintento = [r.permit_applications.filter(a => a.organization === 'ONG Reintento').length, r.followups.filter(f => f.next_action === 'Reintento E2E').length];
    return out;`);
  eq(r3.seleccion, 3, "se seleccionan 3 seguimientos"); ok(/Vas a pasar 3 seguimientos/.test(r3.previo), "el lote enseña un resumen previo");
  ok(r3.opcionesResp.length >= 3 && r3.opcionesResp[1] === "Sin responsable", "el selector de responsable ofrece «Sin responsable» y personas"); ok(/Elige un responsable/.test(r3.sinElegir), "no se asigna sin elegir responsable"); ok(/Vas a asignar a .* 2 seguimientos/.test(r3.previoResp), "el lote de responsable enseña un resumen previo"); ok(/Responsable asignado: 2 guardados/.test(r3.loteResp) && r3.respOk, "asignar responsable en bloque se guarda y se comprueba en la base");
  ok(/3 guardados/.test(r3.lote1) && r3.reprogramados === 3, "reprogramar 3 seguimientos en lote");
  ok(/2 guardados y 1 sin guardar/.test(r3.lote2) && r3.lineas.filter((x) => x === "mal").length === 1 && r3.quedan === 1, "lote con un conflicto: 2 guardados, 1 sin guardar y queda seleccionado");
  ok(/No se pudo confirmar el guardado/.test(r3.caida) && r3.sinCambios && r3.libre, "caída del servidor: no se aplica nada y el Centro sigue operativo");
  ok(/No se ha aplicado/.test(r3.parcial), "un alta que falla avisa de que no se ha aplicado"); eq(r3.sinMedias, [0, 0], "un alta que falla no deja ni la solicitud ni el seguimiento a medias"); eq(r3.reintento, [1, 1], "reintentar el alta crea una sola solicitud y un solo seguimiento");
  permitidos = [];

  /* Coherencia Centro ↔ ficha del punto: las solicitudes pendientes de un punto son las mismas en las dos pantallas */
  const r3b = await ev(ayudas + `
    nav('sol'); await w(250); set('ceEst','pendiente'); await w(250);
    const nombres = [...b().querySelectorAll('tr.ce-row .ce-pt strong')].map(x => x.textContent), nombre = nombres[0], esperadas = nombres.filter(x => x === nombre).length;
    b().querySelector('tr.ce-row .ce-pt').click(); await w(300); b().querySelector('#ceSide [data-pt]').click(); await w(3000);
    const f = document.getElementById('ficha'), caja = [...f.querySelectorAll('.pinfo > div')].find(x => /Pendientes/.test(x.innerText));
    return { nombre, esperadas, ficha: f.querySelector('.fi-title')?.textContent, pendientes: caja ? +caja.querySelector('b').textContent : -1, soloLectura: !f.querySelector('.s-add, .h-add, .ptabs') && !!f.querySelector('.f-centro') };`);
  eq(r3b.ficha, r3b.nombre, "la ficha abre el punto elegido en el Centro"); eq(r3b.pendientes, r3b.esperadas, "solicitudes pendientes de un punto: ficha = Centro"); ok(r3b.soloLectura, "la ficha no tiene formularios de permisos y ofrece el botón del Centro");

  /* ===== 4. Calendario, enlaces cruzados y almacenamiento local ===== */
  const r4 = await ev(ayudas + `
    const out = {}; document.getElementById('ceClose').click(); await w(200);
    document.getElementById('menuBtn').click(); document.getElementById('calBtn').click(); await w(800);
    const cb = () => document.getElementById('calBody'); cb().querySelector('[data-modo=mes]').click(); await w(500);
    out.mes = [cb().querySelector('#calRange').textContent, cb().querySelectorAll('.cal-m').length]; const hoy = cb().querySelector('.cal-m.hoy'); out.aut = hoy.querySelector('.m .a')?.parentElement.textContent.trim() || '0';
    hoy.click(); await w(400); out.semana = cb().querySelector('.cal-day.today .cal-tot')?.innerText.replace(/\\n/g,' ') || ''; cb().querySelector('[data-centro="seg:todas"]').click(); await w(800);
    out.desdeCalendario = [document.getElementById('dlgCentro').open, b().dataset.vista];
    document.getElementById('ceClose').click(); await w(200); document.getElementById('menuBtn').click(); document.getElementById('panelBtn').click(); await w(500);
    document.querySelector('#pnBody [data-ind=pendientes]').click(); await w(300); document.getElementById('pnCentro').click(); await w(800); out.desdePanel = [document.getElementById('dlgCentro').open, b().dataset.vista, document.getElementById('ceEst').selectedOptions[0].value];
    out.almacenamiento = [Object.keys(localStorage).length, Object.keys(sessionStorage).length, document.cookie.length, (await caches.keys()).length, (await navigator.serviceWorker.getRegistrations()).length];
    return out;`);
  ok(/^\w+ \d{4}$/.test(r4.mes[0]) && r4.mes[1] >= 28, "vista mensual del Calendario"); ok(new RegExp("^" + r4.aut + " autorizados").test(r4.semana) || r4.aut === "0", "el día de hoy da los mismos autorizados en el mes y en la semana");
  eq(r4.desdeCalendario, [true, "seg"], "el Calendario abre el Centro en Seguimientos"); eq(r4.desdePanel, [true, "sol", "pendiente"], "el Panel abre el Centro en solicitudes pendientes");
  eq(r4.almacenamiento, [0, 0, 0, 0, 0], "sin datos en localStorage, sessionStorage, cookies, caché ni service workers");

  /* ===== 5. Usuario de una provincia: solo su ámbito y sin capacidades de administrador ===== */
  await abre("alm@test.es");
  const r5 = await ev(ayudas + `
    const out = { prov: [...b().querySelectorAll('#ceProv option')].map(o => o.text) }; const filas = [];
    for (const v of ['sol','con','seg']) { nav(v); await w(250); set('ceEst','todas'); await w(250); filas.push(...[...b().querySelectorAll('tr.ce-row')].map(r => r.innerText)); }
    out.filas = filas.length; out.otraProvincia = filas.some(t => /Granada|Armilla|Motril/.test(t));
    nav('sol'); await w(200); b().querySelector('tr.ce-row .ce-pt').click(); await w(500);
    out.quitar = !!b().querySelector('[data-act=quitS],[data-act=quitC]'); out.historial = [...b().querySelectorAll('#ceSide h4')].some(h => /Historial/.test(h.textContent)); out.razon = [...b().querySelectorAll('#ceSide .ce-razones li')].some(l => /administradores/.test(l.textContent));
    b().querySelector('[data-cierra-lado]')?.click(); b().querySelector('[data-new=sol]').click(); await w(300); set('cfPunto','armilla'); await w(250); out.armilla = b().querySelectorAll('#cfRes button').length;
    return out;`);
  eq(r5.prov, ["Almería"], "solo la provincia asignada"); ok(r5.filas > 0 && !r5.otraProvincia, "ningún expediente de otra provincia"); ok(!r5.quitar && !r5.historial && r5.razon, "sin «Quitar» ni historial, y se explica por qué"); eq(r5.armilla, 0, "no se pueden buscar puntos de otra provincia");

  /* ===== 6. Móvil de 390 px: sin desbordes, objetivos táctiles de 44 px y detalle a pantalla completa ===== */
  await abre("admin@test.es", 390, 800);
  const r6 = await ev(ayudas + `
    const dlg = document.getElementById('dlgCentro'); const out = { desborde: [] }; const mide = (n) => { if (dlg.scrollWidth > dlg.clientWidth) out.desborde.push(n); };
    mide('resumen'); for (const v of ['sol','con','seg','inc']) { nav(v); await w(300); mide(v); }
    nav('sol'); await w(300); b().querySelector('tr.ce-row .ce-pt').click(); await w(500); const l = b().querySelector('#ceSide').getBoundingClientRect(); out.detalle = [Math.round(l.width) >= innerWidth - 2, Math.round(l.height) >= innerHeight - 2]; mide('detalle'); b().querySelector('.ce-x').click(); await w(300);
    out.pequenos = [...b().querySelectorAll('button, select, input:not([type=checkbox])')].filter(e => e.offsetParent !== null && e.getBoundingClientRect().height < 43.5).map(e => (e.id || e.className).toString().slice(0, 24));
    b().querySelector('[data-new=sol]').click(); await w(300); mide('formulario'); return out;`);
  eq(r6.desborde, [], "sin desbordamiento horizontal en ninguna vista"); eq(r6.detalle, [true, true], "el detalle ocupa toda la pantalla"); eq(r6.pequenos, [], "ningún control por debajo de 44 px");

  ok(fallos.length === 0, "La página no lanzó excepciones ni errores de consola inesperados:\n  " + fallos.join("\n  "));
  c.close();
  console.log("E2E del Centro de permisos: " + comprobaciones + " comprobaciones correctas (administrador, usuario de una provincia y móvil; 0 excepciones).");
};

main().then(() => { cierraTodo(); process.exit(0); }).catch((e) => { console.error("FALLO E2E: " + (e.message || e)); if (fallos.length) console.error("Excepciones o errores de consola:\n  " + fallos.join("\n  ")); cierraTodo(); process.exit(1); });

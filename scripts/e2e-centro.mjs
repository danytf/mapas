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
  const abre = async (usuario, ancho = 1440, alto = 900, { sinSeed = false, sinCentro = false } = {}) => {
    await fetch(MOCK + "/__reset"); if (!sinSeed) await seed(MOCK);
    await c.send("Emulation.setDeviceMetricsOverride", { width: ancho, height: alto, deviceScaleFactor: 1, mobile: ancho < 700 });
    await c.send("Page.navigate", { url: WEB + "/?u=" + Date.now() });
    await hasta(() => ev("return document.readyState === 'complete' && !!document.querySelector('#login input') && typeof L === 'object' && typeof window.supabase === 'object';"), 30000, "la pantalla de acceso");
    await esperaMs(800); /* los manejadores de la aplicación se registran al terminar de cargar */
    await ev("const ins=[...document.querySelectorAll('#login input')]; ins[0].value=" + JSON.stringify(usuario) + "; ins[1].value='x'; ins.forEach(i=>i.dispatchEvent(new Event('input',{bubbles:true}))); document.querySelector('#login button[type=submit]').click(); return 1;");
    try { await hasta(() => ev("return !!window.mapaSession && /cargados|No hay establecimientos/.test(document.getElementById('status').textContent);"), 30000, "el inicio de sesión de " + usuario); }
    catch (e) { throw new Error(e.message + " (estado: " + JSON.stringify(await ev("return { sesion: !!window.mapaSession, estado: document.getElementById('status').textContent, login: getComputedStyle(document.getElementById('login')).display, leaflet: typeof L, supabase: typeof window.supabase };")) + ")"); }
    if (sinCentro) { await esperaMs(1500); return; } /* sin abrir el Centro a mano: Mi jornada se abre sola si hay trabajo */
    await ev("document.getElementById('menuBtn').click(); document.getElementById('centroBtn').click(); await new Promise(r=>setTimeout(r,1200)); return 1;");
  };
  const postAdmin = async (tabla, fila) => {
    const ses = await (await fetch(MOCK + "/auth/v1/token?grant_type=password", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ email: "admin@test.es", password: "x" }) })).json();
    const r = await fetch(MOCK + "/rest/v1/" + tabla, { method: "POST", headers: { "Content-Type": "application/json", Authorization: "Bearer " + ses.access_token, apikey: "x" }, body: JSON.stringify(fila) });
    if (r.status !== 201) throw new Error("No se pudo crear en " + tabla + ": " + r.status);
  };
  const tecla = async (key, code, vk) => { await c.send("Input.dispatchKeyEvent", { type: "keyDown", key, code, windowsVirtualKeyCode: vk, text: key === "Enter" ? String.fromCharCode(13) : undefined }); await c.send("Input.dispatchKeyEvent", { type: "keyUp", key, code, windowsVirtualKeyCode: vk }); };

  /* ===== 1. Administrador: recorrido de todas las vistas, estados, órdenes y detalle ===== */
  await abre("admin@test.es");
  const r1 = await ev(ayudas + `
    const out = { vistas: {}, cabeceras: [] };
    const CAP = { res: 'Resumen', sol: 'Solicitudes', con: 'Concesiones', seg: 'Seguimientos', inc: 'Avisos de datos' };
    out.nav = [...b().querySelectorAll('#ceNav button')].map(x => x.innerText.replace(/\\n/g,' '));
    out.ayudaNav = [...b().querySelectorAll('#ceNav button')].filter(x => x.querySelector('.n')).map(x => [x.getAttribute('aria-label'), x.title, x.querySelector('.n').textContent, x.querySelector('.n').hidden]);
    nav('res'); await w(300); out.kpis = b().querySelectorAll('.ce-kpis .kpi').length; out.svgs = b().querySelectorAll('svg.ce-svg').length; out.cards = b().querySelectorAll('.ce-card').length;
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
  eq(r1.nav.length, 6, "seis secciones de navegación (Mi jornada primero)"); ok(r1.nav[0].startsWith("Mi jornada"), "la primera sección es Mi jornada"); ok(r1.ayudaNav.length === 5 && r1.ayudaNav.every(([al, ti, n, oculto]) => (oculto ? /^0 / : new RegExp("^" + n + " ")).test(ti) && /^(Mi jornada|Solicitudes|Concesiones|Seguimientos|Avisos de datos): /.test(al) && al.endsWith(ti)), "cada número de la navegación dice qué cuenta (ayuda y etiqueta accesible)"); ok(r1.ayudaNav.some(([al]) => /^Concesiones: \d+ vigentes? hoy$/.test(al)), "Concesiones cuenta las vigentes hoy"); ok(r1.kpis === 6 && r1.svgs >= 3 && r1.cards >= 8, "el Resumen tiene sus indicadores, gráficos y tarjetas");
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

  /* ===== 3c. Seguimientos ligados directamente a una concesión (grant_id), con y sin seguimiento del punto: modificar y cerrar, comprobado en las filas recargadas ===== */
  const r3c = await ev(ayudas + `
    const out = { variantes: [] }; const rel = () => fetch('http://127.0.0.1:8766/__rel').then(r => r.json()); const cli = window.mapaSession.supabase, yo = window.mapaSession.user.id;
    if (!document.getElementById('dlgCentro').open) { document.getElementById('menuBtn').click(); document.getElementById('centroBtn').click(); await w(1500); }
    let r0 = await rel(); const concs = r0.permit_grants.filter(g => !g.application_id).slice(0, 2); const g1 = r0.followups.find(f => f.grant_id && !f.application_id && !f.completed_at);
    const gA = r0.permit_grants.find(g => g.id === g1.grant_id), gB = r0.permit_grants.find(g => g.id !== gA.id && !r0.followups.some(f => f.grant_id === g.id) && g.establishment_id !== gA.establishment_id);
    const punto = (est) => r0.followups.filter(f => f.establishment_id === est && !f.application_id && !f.grant_id && !f.completed_at);
    /* variante A: sin seguimiento del punto en ese establecimiento; variante B: con seguimiento del punto, y un segundo seguimiento de concesión creado por la API */
    for (const f of punto(gA.establishment_id)) await cli.from('followups').delete().eq('id', f.id);
    await cli.from('followups').insert({ establishment_id: gB.establishment_id, grant_id: gB.id, due_on: d(21), next_action: 'Cupo B E2E', created_by: yo });
    await cli.from('followups').insert({ establishment_id: gB.establishment_id, due_on: d(23), next_action: 'Punto B E2E', created_by: yo });
    for (const g of [gA, gB]) { const c = CENTERS.find(x => x.databaseId === g.establishment_id); await reloadSharedPermit(c); document.dispatchEvent(new CustomEvent('permisos:cambio', { detail: { id: c.id } })); }
    const variantes = [{ nom: 'sinPunto', g: gA, accion0: g1.next_action, nueva: 'Cupo A cambiado E2E', fecha: d(30), resp: yo }, { nom: 'conPunto', g: gB, accion0: 'Cupo B E2E', nueva: 'Cupo B cambiado E2E', fecha: d(31), resp: '' }];
    for (const v of variantes) {
      nav('sol'); await w(200); nav('seg'); await w(300); set('ceEst','todas'); await w(300);
      const fila = (txt) => [...b().querySelectorAll('#ceList tr.ce-row')].find(tr => tr.textContent.includes(txt));
      const rr = await rel(); const res = { nom: v.nom, puntoAntes: rr.followups.filter(f => f.establishment_id === v.g.establishment_id && !f.application_id && !f.grant_id && !f.completed_at).length, existe: !!fila(v.accion0) };
      fila(v.accion0).querySelector('.ce-pt').click(); await w(300); b().querySelector('#ceSide [data-act=edseg]').click(); await w(900);
      set('cfSeg', v.fecha); set('cfAccion', v.nueva); const sel = b().querySelector('#cfResp'); if (sel && v.resp) sel.value = v.resp; b().querySelector('#cfGuardar').click(); await w(3000);
      res.avisoEdit = b().querySelector('#ceAviso').textContent; let r1 = await rel(); const f1 = r1.followups.find(f => f.grant_id === v.g.id);
      res.edit = f1 ? [f1.due_on === v.fecha, f1.next_action === v.nueva, (f1.assigned_to || '') === v.resp, !f1.application_id, !f1.completed_at] : null;
      res.puntoTrasEditar = r1.followups.filter(f => f.establishment_id === v.g.establishment_id && !f.application_id && !f.grant_id && !f.completed_at).map(f => f.due_on + '|' + f.next_action).sort();
      res.puntoAntesLista = r0.followups.filter(f => f.establishment_id === v.g.establishment_id && !f.application_id && !f.grant_id && !f.completed_at && f.id !== undefined).length;
      b().querySelector('[data-cierra-lado]')?.click(); await w(150); set('ceEst','todas'); await w(250);
      fila(v.nueva).querySelector('.ce-pt').click(); await w(300); b().querySelector('#ceSide [data-act=hecho]').click(); await w(400); b().querySelector('[data-conf=ok]')?.click(); await w(3000);
      res.avisoHecho = b().querySelector('#ceAviso').textContent; r1 = await rel(); const f2 = r1.followups.find(f => f.grant_id === v.g.id);
      res.hecho = f2 ? [!!f2.completed_at, f2.due_on === v.fecha] : null; res.enLista = !!fila(v.nueva);
      res.puntoTrasHecho = r1.followups.filter(f => f.establishment_id === v.g.establishment_id && !f.application_id && !f.grant_id && !f.completed_at).map(f => f.due_on + '|' + f.next_action).sort();
      b().querySelector('[data-cierra-lado]')?.click(); await w(150); out.variantes.push(res);
    }
    return out;`);
  r3c.variantes.forEach((x) => {
    ok(x.existe, "[" + x.nom + "] el seguimiento de la concesión aparece en Seguimientos");
    eq(x.edit, [true, true, true, true, true], "[" + x.nom + "] cambiar el seguimiento de la concesión: fecha, acción y responsable guardados en su fila (grant_id, sin application_id) [" + x.avisoEdit + "]");
    ok(/guardado/i.test(x.avisoEdit) && !/No se pudo|Otra persona/.test(x.avisoEdit), "[" + x.nom + "] la edición se guardó y se verificó");
    eq(x.hecho, [true, true], "[" + x.nom + "] «Hecho» cierra el seguimiento de la concesión en su fila [" + x.avisoHecho + "]"); ok(!x.enLista, "[" + x.nom + "] y desaparece de la lista");
    eq(x.puntoTrasHecho, x.puntoTrasEditar, "[" + x.nom + "] el seguimiento del punto (si lo hay) no se toca al editar ni al cerrar el de la concesión");
  });
  eq(r3c.variantes.map((x) => x.puntoAntes > 0), [false, true], "la prueba cubre una concesión sin seguimiento del punto y otra con él");

  /* ===== 3e. Filtro por responsable en Seguimientos y reasignar todo lo de una persona a otra ===== */
  const r3e = await ev(ayudas + `
    const out = {}; const rel = () => fetch('http://127.0.0.1:8766/__rel').then(r => r.json()); const yo = window.mapaSession.user.id;
    if (!document.getElementById('dlgCentro').open) { document.getElementById('menuBtn').click(); document.getElementById('centroBtn').click(); await w(1500); }
    nav('sol'); await w(200); nav('seg'); await w(300); set('ceEst','todas'); await w(300);
    const sel = () => b().querySelector('#ceResp'); const cuenta = (o) => +o.textContent.slice(o.textContent.lastIndexOf('(') + 1, -1); const nombre = (o) => o.textContent.slice(0, o.textContent.lastIndexOf('(')).trim();
    out.visible = getComputedStyle(sel().closest('label')).display !== 'none'; out.opciones = [...sel().options].map(o => o.textContent);
    const total = b().querySelector('.ce-count')?.textContent || '';
    const personas = [...sel().options].filter(o => o.value && o.value !== '__ninguno'); const X = personas.filter(o => o.value !== yo).sort((a, c) => cuenta(c) - cuenta(a))[0] || personas[0];
    set('ceResp', X.value); await w(400);
    const filas = () => [...b().querySelectorAll('#ceList tr.ce-row')]; const col = (tr, l) => tr.querySelector('td[data-l="' + l + '"]')?.textContent.trim();
    out.filtroX = { n: filas().length, esperado: cuenta(X), todasDeX: filas().every(tr => col(tr, 'Responsable') === nombre(X) || (X.value === yo && col(tr, 'Responsable') === 'tú')) };
    set('ceResp', '__ninguno'); await w(400); out.sinResp = { n: filas().length, todas: filas().every(tr => col(tr, 'Responsable') === 'Sin responsable') };
    const ningun = [...sel().options].find(o => o.value === '__ninguno'); out.sinRespEsperado = cuenta(ningun);
    set('ceResp', X.value); await w(400);
    const acciones = filas().map(tr => col(tr, 'Acción prevista')); const antes = await rel();
    const idsDeX = acciones.map(a => antes.followups.find(f => !f.completed_at && f.next_action === a)).filter(Boolean).map(f => f.id);
    out.antes = { n: idsDeX.length, todosDeX: idsDeX.every(id => antes.followups.find(f => f.id === id).assigned_to === X.value) };
    const resto = antes.followups.filter(f => !f.completed_at && f.assigned_to === X.value && !idsDeX.includes(f.id)).length;
    b().querySelector('#ceChkTodos').click(); await w(500); await w(1500);
    const lr = b().querySelector('#ceLoteResp'); const Y = [...lr.options].find(o => o.value && o.value !== '__' && o.value !== X.value); out.destino = Y ? Y.textContent : null;
    lr.value = Y.value; b().querySelector('[data-lote=resp]').click(); await w(300); out.previo = b().querySelector('#ceLote .ce-lote strong').textContent;
    b().querySelector('[data-lote=ejecutar]').click(); await w(Math.max(6000, idsDeX.length * 900)); out.resultado = b().querySelector('#ceLote .ce-lote strong').textContent;
    const despues = await rel(); out.despues = { movidos: idsDeX.filter(id => despues.followups.find(f => f.id === id).assigned_to === Y.value).length, sinTocar: despues.followups.filter(f => !f.completed_at && f.assigned_to === X.value).length === resto };
    b().querySelector('[data-lote=cerrar]')?.click(); await w(200); set('ceResp', ''); await w(200);
    return out;`);
  ok(r3e.visible && r3e.opciones.length >= 3 && /^Todos \(/.test(r3e.opciones[0]) && /^Sin responsable \(/.test(r3e.opciones[1]), "Seguimientos ofrece el filtro «Responsable» con Todos, Sin responsable y personas (con su recuento) [" + r3e.opciones.join(" | ") + "]");
  eq([r3e.filtroX.n, r3e.filtroX.todasDeX], [Math.min(r3e.filtroX.esperado, 100), true], "filtrar por una persona muestra solo sus seguimientos y el recuento cuadra");
  eq([r3e.sinResp.n > 0, r3e.sinResp.todas, r3e.sinResp.n], [true, true, Math.min(r3e.sinRespEsperado, 100)], "«Sin responsable» muestra solo los que no tienen");
  ok(r3e.antes.n >= 2, "hay al menos 2 seguimientos que reasignar (" + r3e.antes.n + ")"); eq(r3e.antes.todosDeX, true, "las filas filtradas son de esa persona en la base"); ok(/asignar a .*/.test(r3e.previo), "reasignar todo lo de una persona: resumen previo [" + r3e.previo + "]");
  eq([r3e.despues.movidos, r3e.despues.sinTocar], [r3e.antes.n, true], "todo lo de esa persona pasa a la otra y no se toca nada más [" + r3e.resultado + "]");

  /* ===== 3f. Exportar a CSV lo que se ve en cada lista, con los filtros ===== */
  const r3f = await ev(ayudas + `
    const out = { listas: {} }; const CRLF = String.fromCharCode(13, 10); window.confirm = () => true; const crea = URL.createObjectURL.bind(URL); URL.createObjectURL = (bl) => { window.__csv = bl; return crea(bl); };
    if (!document.getElementById('dlgCentro').open) { document.getElementById('menuBtn').click(); document.getElementById('centroBtn').click(); await w(1500); }
    const exporta = async () => { window.__csv = null; b().querySelector('[data-csv]').click(); await w(300); return window.__csv ? await window.__csv.text() : null; };
    const total = () => +(b().querySelector('.ce-count')?.textContent.match(/^[0-9]+/) || [0])[0];
    for (const [v, est] of [['sol', 'todas'], ['con', 'todas'], ['seg', 'todas'], ['inc', 'todas']]) {
      nav(v); await w(300); set('ceEst', est); await w(400); set('ceResp', ''); await w(100);
      const n = total(), primera = b().querySelector('#ceList tr.ce-row .ce-pt strong')?.textContent, txt = await exporta(); const bytes = window.__csv ? new Uint8Array(await window.__csv.arrayBuffer()) : null; const lineas = txt ? txt.split(CRLF) : [];
      out.listas[v] = { n, bom: !!bytes && bytes[0] === 239 && bytes[1] === 187 && bytes[2] === 191, cabecera: lineas[0] || '', filas: lineas.length - 1, tienePrimera: !!primera && txt.includes(primera), aviso: b().querySelector('#ceAviso').textContent };
    }
    nav('seg'); await w(300); set('ceEst', 'todas'); await w(300);
    const sel = b().querySelector('#ceResp'); const X = [...sel.options].find(o => o.value && o.value !== '__ninguno'); set('ceResp', X.value); await w(400);
    const nX = total(), txtX = await exporta(); out.filtrado = { n: nX, filas: txtX ? txtX.split(CRLF).length - 1 : -1 };
    set('ceResp', ''); await w(200);
    return out;`);
  const CAB = { sol: 'provincia;municipio;punto;direccion;ong;desde;hasta;captadores;estado;solicitada;resuelta;motivo;seguimiento;responsable_seguimiento;accion_seguimiento', con: 'provincia;municipio;punto;direccion;ong;desde;hasta;captadores;estado;alta;cancelada_el;motivo;solicitud_enlazada', seg: 'provincia;municipio;punto;direccion;ong;fecha;situacion;dias_de_retraso;accion;responsable;origen', inc: 'gravedad;aviso;provincia;municipio;punto;ong;expediente;periodo' };
  Object.entries(r3f.listas).forEach(([v, x]) => {
    ok(x.bom && x.n > 0, "[" + v + "] el CSV se crea con BOM y la lista no está vacía");
    eq(x.cabecera.split('"').join(''), CAB[v], "[" + v + "] cabecera del CSV"); eq(x.filas, x.n, "[" + v + "] el CSV tiene una fila por cada elemento de la lista (" + x.n + ")"); ok(x.tienePrimera && /CSV creado con/.test(x.aviso), "[" + v + "] contiene lo que se ve y avisa");
  });
  eq([r3f.filtrado.n > 0, r3f.filtrado.filas], [true, r3f.filtrado.n], "el CSV respeta el filtro de responsable");

  /* ===== 3g. Crear desde un día del Calendario: el formulario llega con la fecha de ese día ===== */
  const r3g = await ev(ayudas + `
    const out = {}; const rel = () => fetch('http://127.0.0.1:8766/__rel').then(r => r.json()); const cb = () => document.getElementById('calBody'); const t = today();
    if (document.getElementById('dlgCentro').open) { document.getElementById('ceClose').click(); await w(200); }
    document.getElementById('menuBtn').click(); document.getElementById('calBtn').click(); await w(900);
    const dias = [...cb().querySelectorAll('.cal-day')].map(d => ({ sol: d.querySelector('[data-nuevo=sol]')?.dataset.nuevoDia || null, con: d.querySelector('[data-nuevo=con]')?.dataset.nuevoDia || null }));
    out.dias = dias.length; out.conSol = dias.filter(d => d.sol).length; out.conCon = dias.filter(d => d.con).length; out.solPasado = dias.some(d => d.sol && d.sol < t);
    const dia = dias.find(d => d.sol && d.sol >= t).sol; out.dia = dia;
    cb().querySelector('[data-nuevo=sol][data-nuevo-dia="' + dia + '"]').click(); await w(1200);
    const b2 = () => document.getElementById('ceBody');
    out.abierto = [document.getElementById('dlgCentro').open, b2().dataset.vista, !b2().querySelector('#ceForm').hidden, b2().querySelector('#cfT')?.textContent];
    out.fechas = [b2().querySelector('#cfDesde')?.value, b2().querySelector('#cfHasta')?.value];
    out.encima = [document.getElementById('dlgCal').open, document.getElementById('dlgCentro').classList.contains('solo-form'), document.getElementById('ceT').textContent, getComputedStyle(b2().querySelector('.ce-nav')).display === 'none' && getComputedStyle(b2().querySelector('#ceForm')).display !== 'none'];
    const set2 = (id, v) => { const e = b2().querySelector('#' + id); e.value = v; e.dispatchEvent(new Event('input', { bubbles: true })); e.dispatchEvent(new Event('change', { bubbles: true })); };
    set2('cfPunto', 'roquetas'); await w(300); b2().querySelector('[data-pick="0"]').click(); await w(300); set2('cfN', '2'); set2('cfOng', 'ONG Calendario E2E'); b2().querySelector('#cfGuardar').click(); await w(3000);
    const r = await rel(); const a = r.permit_applications.find(x => x.organization === 'ONG Calendario E2E'); out.guardada = a ? [a.requested_from, a.requested_until, a.status] : null; out.aviso = cb().querySelector('#calAviso').textContent;
    out.volver = [!document.getElementById('dlgCentro').open, document.getElementById('dlgCal').open, !document.getElementById('dlgCentro').classList.contains('solo-form'), document.getElementById('ceT').textContent, !cb().querySelector('#calAviso').hidden && cb().querySelector('#calAviso').textContent.length > 0, cb().textContent.includes('ONG Calendario E2E')];
    /* concesión desde un día, con el filtro de ONG del Calendario */
    document.getElementById('calClose').click(); await w(200); document.getElementById('menuBtn').click(); document.getElementById('calBtn').click(); await w(900);
    const oc = cb().querySelector('#calOng'); const ong = [...oc.options].find(o => o.value); if (ong) { oc.value = ong.value; oc.dispatchEvent(new Event('change', { bubbles: true })); await w(400); }
    const dCon = cb().querySelector('[data-nuevo=con]').dataset.nuevoDia; cb().querySelector('[data-nuevo=con][data-nuevo-dia="' + dCon + '"]').click(); await w(1200);
    out.con = [b2().querySelector('#cfT')?.textContent, b2().querySelector('#cfDesde')?.value === dCon, b2().querySelector('#cfHasta')?.value === dCon, ong ? b2().querySelector('#cfOng')?.value === ong.value : null];
    b2().querySelector('#cfCancelar')?.click(); await w(200);
    /* vista mensual: pinchar un día (desde hoy) crea la solicitud de ese día; uno pasado sigue llevando a su semana */
    cb().querySelector('[data-modo=mes]').click(); await w(400);
    const fut = [...cb().querySelectorAll('.cal-m')].find(x => x.dataset.dia >= t);
    fut.click(); await w(1000);
    out.mes = [document.getElementById('dlgCal').open, document.getElementById('dlgCentro').classList.contains('solo-form'), b2().querySelector('#cfDesde')?.value === fut.dataset.dia, b2().querySelector('#cfHasta')?.value === fut.dataset.dia, b2().querySelector('#cfT')?.textContent];
    b2().querySelector('#cfCancelar')?.click(); await w(300);
    const pas = [...cb().querySelectorAll('.cal-m')].find(x => x.dataset.dia < t); /* se busca después: el Calendario se repinta al cerrar el formulario */
    out.mesPasado = null; if (pas) { pas.click(); await w(400); out.mesPasado = [document.getElementById('dlgCentro').open, cb().querySelector('[data-modo=dias]').getAttribute('aria-pressed')]; }
    return out;`);
  /* En lunes (primer dia de la semana mostrada) no hay ningun dia pasado y las 7 casillas ofrecen solicitud: conSol puede ser 7. Lo que no puede ocurrir es ofrecerla en un dia pasado (solPasado). */
  ok(r3g.dias === 7 && r3g.conCon === 7 && r3g.conSol >= 1 && r3g.conSol <= 7 && !r3g.solPasado, "cada día del Calendario ofrece «+ Concesión»; «+ Solicitud» solo desde hoy [" + r3g.conSol + "/" + r3g.conCon + "]");
  eq([r3g.abierto[0], r3g.abierto[1], r3g.abierto[2], r3g.abierto[3]], [true, "sol", true, "Nueva solicitud"], "«+ Solicitud» abre el Centro con el formulario de nueva solicitud");
  eq(r3g.fechas, [r3g.dia, r3g.dia], "el formulario llega con la fecha del día elegido (desde y hasta)");
  eq(r3g.encima, [true, true, "Nueva solicitud", true], "el formulario se abre encima del Calendario (que sigue abierto), solo con el formulario y con su título");
  eq(r3g.guardada, [r3g.dia, r3g.dia, "pending"], "la solicitud creada desde el día se guarda con esa fecha [" + r3g.aviso + "]");
  eq(r3g.volver, [true, true, true, "Centro de permisos", true, true], "al guardar se vuelve al Calendario: el Centro se cierra, queda el aviso de lo guardado y la solicitud nueva sale en la semana [" + r3g.aviso + "]");
  eq(r3g.mes, [true, true, true, true, "Nueva solicitud"], "en la vista mensual, pinchar un día desde hoy abre la nueva solicitud con ese día");
  if (r3g.mesPasado) eq(r3g.mesPasado, [false, "true"], "…y un día pasado sigue llevando a su semana en «Por día»");
  eq(r3g.con.slice(0, 3), ["Nueva concesión", true, true], "«+ Concesión» abre el formulario con la fecha del día"); ok(r3g.con[3] !== false, "…y con la ONG que se estaba filtrando en el Calendario");

  /* ===== 3h. Menú con secciones desplegables ===== */
  const r3h = await ev(ayudas + `
    const out = {}; ['ceClose', 'pnClose', 'calClose'].forEach(id => { const x = document.getElementById(id); if (x && x.closest('dialog')?.open) x.click(); }); await w(300);
    const panel = document.getElementById('menuPanel'), btn = document.getElementById('menuBtn'); btn.click(); await w(200);
    const cabs = () => [...panel.querySelectorAll('.mh-btn')].filter(x => !x.hidden); const estado = () => cabs().map(x => x.textContent.trim() + ':' + x.getAttribute('aria-expanded'));
    const visibles = () => [...panel.querySelectorAll('.mn-sec button[role=menuitem]')].filter(x => !x.closest('[hidden]') && !x.hidden).map(x => x.id);
    out.abierto = !panel.hidden; out.inicial = estado(); out.itemsInicial = visibles();
    const datos = cabs().find(x => x.textContent.trim() === 'Datos'); datos.click(); await w(150);
    out.tras = [!panel.hidden, datos.getAttribute('aria-expanded'), visibles().includes('csv')];
    const inf = cabs().find(x => x.textContent.trim() === 'Informes'); inf.click(); await w(150); out.pliega = [!panel.hidden, inf.getAttribute('aria-expanded'), visibles().includes('centroBtn')];
    /* teclado: las flechas saltan las opciones ocultas y la tecla Intro pliega el título enfocado */
    inf.focus(); panel.dispatchEvent(new KeyboardEvent('keydown', { key: 'ArrowDown', bubbles: true })); out.flecha = document.activeElement.textContent.trim();
    datos.click(); await w(150); out.pliegaDatos = [datos.getAttribute('aria-expanded'), visibles().includes('csv')];
    const aria = [...panel.querySelectorAll('.mh-btn')].every(x => { const sec = document.getElementById(x.getAttribute('aria-controls')); return !!sec && (x.getAttribute('aria-expanded') === 'true') === !sec.hidden; }); out.aria = aria;
    /* elegir una opción cierra el menú y la acción se ejecuta */
    inf.click(); await w(100); document.getElementById('panelBtn').click(); await w(700); out.accion = [panel.hidden, document.getElementById('dlgPanel').open]; document.getElementById('pnClose').click(); await w(200);
    return out;`);
  eq(r3h.inicial, ["Informes:true", "Progreso:false", "Puntos:false", "Datos:false", "Administración:false", "Ayuda:false"], "el menú muestra seis secciones; solo Informes empieza desplegada");
  eq(r3h.itemsInicial, ["jornadaBtn", "centroBtn", "panelBtn", "calBtn", "admBtn"].filter((x) => r3h.itemsInicial.includes(x)), "con las demás plegadas solo se ven las opciones de Informes"); ok(r3h.itemsInicial.length >= 4 && !r3h.itemsInicial.includes("csv"), "…y no las de Datos");
  eq(r3h.tras, [true, "true", true], "pulsar «Datos» despliega su sección sin cerrar el menú"); eq(r3h.pliega, [true, "false", false], "pulsar «Informes» pliega su sección sin cerrar el menú");
  eq(r3h.flecha, "Progreso", "la flecha abajo salta las opciones plegadas y va al título siguiente"); eq(r3h.pliegaDatos, ["false", false], "pulsar otra vez pliega"); ok(r3h.aria, "cada título refleja con aria-expanded si su sección está visible");
  eq(r3h.accion, [true, true], "elegir una opción cierra el menú y abre lo pedido");

  /* ===== 3d. Coherencia de cifras: las tablas fuente, recalculadas aquí de forma independiente, frente al Centro (menú y Resumen), el Panel y el Calendario ===== */
  const r3d = await ev(ayudas + `
    const out = {}; const rel = () => fetch('http://127.0.0.1:8766/__rel').then(r => r.json()); const t = today();
    const dias = (a, b) => Math.round((Date.parse(b) - Date.parse(a)) / 864e5), suma = (iso, n) => new Date(Date.parse(iso) + n * 864e5).toISOString().slice(0, 10);
    const R = await rel(), apps = R.permit_applications, grants = R.permit_grants, abiertos = R.followups.filter(f => !f.completed_at && f.due_on);
    const estSol = (a) => a.status === 'approved' ? 'aprobada' : a.status === 'denied' ? 'denegada' : a.status === 'withdrawn' ? 'retirada' : (a.requested_until && a.requested_until < t ? 'caducada' : 'pendiente');
    const estCon = (g) => g.status === 'cancelled' ? 'cancelada' : (g.valid_from && g.valid_from > t) ? 'futura' : (g.valid_until && g.valid_until < t) ? 'terminada' : 'vigente';
    const masProximo = (lista) => lista.slice().sort((a, b) => a.due_on.localeCompare(b.due_on))[0];
    /* seguimientos que se muestran: el más próximo abierto de cada solicitud sin resolver, de cada concesión no cancelada (sin solicitud) y de cada punto */
    const visibles = [];
    for (const a of apps.filter(a => ['pendiente', 'caducada'].includes(estSol(a)))) { const f = masProximo(abiertos.filter(f => f.application_id === a.id)); if (f) visibles.push({ id: f.id, due: f.due_on, app: a.id }); }
    for (const g of grants.filter(g => estCon(g) !== 'cancelada')) { const f = masProximo(abiertos.filter(f => f.grant_id === g.id && !f.application_id)); if (f) visibles.push({ id: f.id, due: f.due_on }); }
    const porEst = new Map(); abiertos.filter(f => !f.application_id && !f.grant_id).forEach(f => { const v = porEst.get(f.establishment_id); if (!v || f.due_on < v.due_on) porEst.set(f.establishment_id, f); });
    porEst.forEach(f => visibles.push({ id: f.id, due: f.due_on }));
    const pend = apps.filter(a => estSol(a) === 'pendiente'), vig = grants.filter(g => estCon(g) === 'vigente');
    const conSeg = new Set(visibles.filter(v => v.app).map(v => v.app));
    const esp = { pendientes: pend.length, sinSeguimiento: pend.filter(a => !conSeg.has(a.id)).length, estancadas: pend.filter(a => a.requested_at && dias(a.requested_at, t) > UMBRAL_ESTANCADA).length,
      sinRespuesta: apps.filter(a => estSol(a) === 'caducada').length, aprobadas: apps.filter(a => estSol(a) === 'aprobada').length, denegadas: apps.filter(a => estSol(a) === 'denegada').length, retiradas: apps.filter(a => estSol(a) === 'retirada').length,
      segVencidos: visibles.filter(v => v.due < t).length, segHoy: visibles.filter(v => v.due === t).length, segProximos: visibles.filter(v => v.due > t && v.due <= suma(t, 7)).length,
      vigentes: vig.length, futuras30: grants.filter(g => estCon(g) === 'futura' && g.valid_from <= suma(t, 30)).length, sinFin: vig.filter(g => !g.valid_until).length,
      vencen7: vig.filter(g => g.valid_until && dias(t, g.valid_until) >= 0 && dias(t, g.valid_until) <= 7).length };
    const cap = new Map(); vig.forEach(g => { const k = g.establishment_id + '|' + (g.organization || '').trim().toLowerCase(); cap.set(k, Math.max(cap.get(k) || 0, g.capturer_count || 0)); });
    esp.autorizadosHoy = [...cap.values()].reduce((x, y) => x + y, 0); out.esp = esp;
    /* El Calendario coloca cada concesión en días concretos: las que no tienen ni fecha de inicio ni de fin no aparecen en él (sí cuentan como vigentes en el Panel y el Centro). */
    const capCal = new Map(); vig.filter(g => g.valid_from || g.valid_until).forEach(g => { const k = g.establishment_id + '|' + (g.organization || '').trim().toLowerCase(); capCal.set(k, Math.max(capCal.get(k) || 0, g.capturer_count || 0)); });
    esp.autorizadosCalendario = [...capCal.values()].reduce((x, y) => x + y, 0); esp.sinFechas = vig.filter(g => !g.valid_from && !g.valid_until).length;
    const provDe = new Map(CENTERS.map(c => [c.databaseId, c.provinceId])); out.autPorProv = {};
    capCal.forEach((n, k) => { const pv = provDe.get(k.split('|')[0]); if (pv) out.autPorProv[pv] = (out.autPorProv[pv] || 0) + n; });
    /* Centro: etiquetas del menú y tarjetas del Resumen */
    document.getElementById('dlgCentro').open || (document.getElementById('menuBtn').click(), document.getElementById('centroBtn').click(), await w(1200));
    nav('res'); await w(300); set('ceProv', ''); await w(200); set('ceOng', ''); await w(300); const num = (el) => el && !el.hidden ? +el.textContent : 0;
    out.menu = { pendientes: num(b().querySelector('#ceNav [data-vista=sol] .n')), vigentes: num(b().querySelector('#ceNav [data-vista=con] .n')), segVencidos: num(b().querySelector('#ceNav [data-vista=seg] .n')) };
    const k = [...b().querySelectorAll('.ce-kpis .kpi')].map(x => +x.querySelector('b').textContent); out.resumen = { pendientes: k[0], estancadas: k[1], vigentes: k[2], segVencidos: k[4] };
    /* Panel resumen */
    document.getElementById('ceClose').click(); await w(200); document.getElementById('menuBtn').click(); document.getElementById('panelBtn').click(); await w(800);
    out.panel = {}; for (const key of Object.keys(esp)) { const el = document.querySelector('#pnBody [data-ind=' + key + '] b'); if (el) out.panel[key] = +el.textContent; }
    const capEl = document.querySelector('#pnBody [data-ind=capacidadHoy] b'); if (capEl) out.panel.autorizadosHoy = +capEl.textContent;
    document.getElementById('pnClose').click(); await w(200);
    /* Calendario: captadores autorizados hoy */
    document.getElementById('menuBtn').click(); document.getElementById('calBtn').click(); await w(800); const cb = () => document.getElementById('calBody');
    const selP = cb().querySelector('#calProv'); out.calProvDefecto = selP.selectedOptions[0].textContent; const provs = [...selP.options].map(o => [o.value, o.textContent]);
    const leeCal = async (valor) => { selP.value = valor; selP.dispatchEvent(new Event('change', { bubbles: true })); await w(400); cb().querySelector('[data-modo=mes]').click(); await w(400); cb().querySelector('[data-modo=dias]').click(); await w(400); const tt = cb().querySelector('.cal-day.today .cal-tot')?.innerText || ''; return +((tt.match(/(\\d+)\\s*autorizad/) || [])[1] || 0); };
    out.calPorProv = {}; for (const [v, n] of provs) if (v) out.calPorProv[v] = [n, await leeCal(v)];
    await leeCal('');
    const tot = cb().querySelector('.cal-day.today .cal-tot')?.innerText || ''; out.calendario = { texto: tot.replace(/\\n/g, ' '), autorizados: +((tot.match(/(\\d+)\\s*autorizad/) || [])[1] || 0) };
    document.getElementById('calClose')?.click(); await w(200);
    return out;`);
  const e = r3d.esp;
  eq(r3d.menu, { pendientes: e.pendientes, vigentes: e.vigentes, segVencidos: e.segVencidos }, "menú del Centro = tablas fuente (pendientes, concesiones vigentes hoy, seguimientos atrasados)");
  eq(r3d.resumen, { pendientes: e.pendientes, estancadas: e.estancadas, vigentes: e.vigentes, segVencidos: e.segVencidos }, "Resumen del Centro = tablas fuente");
  eq(Object.keys(r3d.panel).length >= 10, true, "el Panel muestra al menos 10 de los indicadores comprobados (" + Object.keys(r3d.panel).join(",") + ")");
  Object.entries(r3d.panel).forEach(([key, v]) => eq([key, v], [key, e[key]], "Panel «" + key + "» = tablas fuente"));
  ok(e.sinFechas > 0 && e.autorizadosCalendario < e.autorizadosHoy, "hay concesiones vigentes sin fechas: cuentan en el Panel y el Centro (" + e.autorizadosHoy + ") pero el Calendario no puede colocarlas (" + e.autorizadosCalendario + ")");
  eq(r3d.calendario.autorizados, e.autorizadosCalendario, "Calendario (todas las provincias): captadores autorizados hoy = tablas fuente con fechas [" + r3d.calendario.texto + "]");
  ok(Object.keys(r3d.calPorProv).length >= 2, "el Calendario ofrece varias provincias");
  Object.entries(r3d.calPorProv).forEach(([pv, [nombre, val]]) => eq([nombre, val], [nombre, r3d.autPorProv[pv] || 0], "Calendario de «" + nombre + "»: captadores autorizados hoy = tablas fuente"));
  eq(Object.values(r3d.autPorProv).reduce((x, y) => x + y, 0), e.autorizadosCalendario, "la suma por provincias = el total del Calendario");

  /* ===== 3j. Mi jornada: puerta de entrada, filtros, navegación, tareas, fallos, ámbito, teclado, móvil y oscuro ===== */
  await abre("admin@test.es", 1440, 900, { sinCentro: true });
  const j1 = await ev(ayudas + `
    const out = {}; const dlg = document.getElementById('dlgCentro');
    out.abierta = [dlg.open, b().dataset.vista, b().querySelector('#ceNav [aria-current=page]')?.textContent.trim().startsWith('Mi jornada'), document.activeElement === b().querySelector('#ceNav [aria-current=page]')];
    out.mapaAccesible = !!b().querySelector('[data-mapa]');
    const filas = () => [...b().querySelectorAll('.jo-fila')];
    out.total = +b().querySelector('.ce-count').textContent.match(/^\\d+/)[0]; out.nav = +b().querySelector('#ceNav [data-vista=jor] .n').textContent;
    out.claves = new Set(filas().map(f => f.dataset.key)).size; out.filas = filas().length;
    out.bandas = [...b().querySelectorAll('.jo-banda h3')].map(h => h.textContent.trim());
    out.chips = [...b().querySelectorAll('.jo-chip')].map(x => [x.dataset.rapida, +x.querySelector('b').textContent, x.getAttribute('aria-pressed')]);
    /* orden: ninguna fila menos grave antes que una más grave */
    const orden = { urgente: 0, hoy: 1, atencion: 2 }; out.ordenBandas = filas().map(f => orden[f.className.match(/b-(\\w+)/)[1]]); out.ordenOk = out.ordenBandas.every((v, i) => i === 0 || out.ordenBandas[i - 1] <= v);
    out.motivos = filas().slice(0, 5).map(f => [f.querySelector('.jo-motivo strong').textContent, !!f.querySelector('.jo-sig'), !!f.querySelector('.jo-meta .ce-badge, .jo-meta .jo-tipo')]);
    /* cifras frente al Panel y al Centro */
    const atr = filas().filter(f => /^Seguimiento atrasado/.test(f.querySelector('.jo-motivo strong').textContent)).length, hoy = filas().filter(f => f.querySelector('.jo-motivo strong').textContent === 'Seguimiento para hoy').length;
    out.atrasadas = atr; out.hoy = hoy;
    out.menu = (document.getElementById('menuBtn').click(), await w(100), document.getElementById('jornadaBtn').textContent.trim()); document.getElementById('menuBtn').click(); await w(100);
    document.getElementById('ceClose').click(); await w(200); document.getElementById('menuBtn').click(); document.getElementById('panelBtn').click(); await w(800);
    const pk = (k) => +document.querySelector('#pnBody [data-ind=' + k + '] b').textContent; out.panel = { atrasados: pk('segVencidos'), hoy: pk('segHoy'), estancadas: pk('estancadas'), sinSeg: pk('sinSeguimiento'), vencen7: pk('vencen7') };
    document.getElementById('pnClose').click(); await w(200); document.getElementById('menuBtn').click(); document.getElementById('jornadaBtn').click(); await w(800);
    out.cuentaTipos = {}; for (const o of [...b().querySelector('#ceEst').options]) out.cuentaTipos[o.value] = +o.text.match(/\\((\\d+)\\)\\s*$/)[1];
    /* para comparar con el Panel, los motivos se cuentan sobre todas las filas (principal o «También») */
    const textos = filas().map(f => f.textContent); b().querySelector('[data-mas]')?.click();
    out.estancadas = filas().filter(f => /Solicitud sin respuesta desde hace/.test(f.textContent)).length; out.sinSeg = filas().filter(f => /Solicitud pendiente sin seguimiento programado/.test(f.textContent)).length;
    out.vencen = filas().filter(f => /La concesión termina (hoy|en [1-7] días?)/.test(f.textContent)).length;
    /* el Resumen del Centro ofrece las mismas primeras actuaciones */
    const primeras = filas().slice(0, 8).map(f => f.querySelector('.ce-pt strong').textContent + '|' + f.querySelector('.jo-motivo strong').textContent);
    b().querySelector('#ceNav [data-vista=res]').click(); await w(400); out.cola = [...b().querySelectorAll('.ce-cola .ce-item')].map(x => x.querySelector('strong').textContent + '|' + x.querySelector('span:last-child').textContent.split(' · ')[0]);
    out.primeras = primeras; b().querySelector('#ceNav [data-vista=jor]').click(); await w(400);
    return out;`);
  eq(j1.abierta, [true, "jor", true, true], "al entrar, Mi jornada se abre sola (hay trabajo) y el foco está en su sección");
  ok(j1.mapaAccesible, "«Ir al mapa» está a la vista");
  eq([j1.total, j1.filas, j1.claves], [j1.nav, Math.min(j1.total, 100), Math.min(j1.total, 100)], "el recuento de la lista, la navegación y las filas dibujadas coinciden, sin filas repetidas");
  ok(j1.ordenOk && /^Urgente/.test(j1.bandas[0]), "las filas van de la banda más urgente a la menos urgente: " + j1.bandas.join(" | "));
  ok(j1.chips.length === 4 && j1.chips[0][0] === "urgentes" && j1.chips[3][0] === "todas" && j1.chips[3][2] === "true" && j1.chips[3][1] === j1.total, "vistas rápidas Urgentes, Para hoy, Sin seguimiento y Todas; «Todas» marcada con el total");
  ok(j1.motivos.every(([m, sig, meta]) => m && sig && meta), "cada fila explica el motivo, su siguiente acción y su tipo/estado");
  eq(j1.menu, "Mi jornada (" + j1.total + ")", "el menú dice cuántas actuaciones hay");
  eq([j1.atrasadas, j1.hoy], [j1.panel.atrasados, j1.panel.hoy], "seguimientos atrasados y de hoy: Mi jornada = Panel resumen");
  eq([j1.estancadas, j1.sinSeg, j1.vencen], [j1.panel.estancadas, j1.panel.sinSeg, j1.panel.vencen7], "estancadas, sin seguimiento y concesiones que terminan en 7 días: Mi jornada = Panel resumen (motivos principales y «También»)");
  ok(j1.cola.length > 0 && j1.cola.every((x, i) => x.split("|")[0] === j1.primeras[i].split("|")[0]), "el Resumen muestra las mismas primeras actuaciones, en el mismo orden");
  eq(Object.entries(j1.cuentaTipos).filter(([k]) => k !== "todos").reduce((x, [, v]) => x + v, 0), j1.cuentaTipos.todos, "los tipos suman el total");

  /* Filtros combinados */
  const j2 = await ev(ayudas + `
    const out = {}; const filas = () => [...b().querySelectorAll('.jo-fila')]; const total = () => +b().querySelector('.ce-count').textContent.match(/^\\d+/)[0];
    const chip = (k) => b().querySelector('[data-rapida=' + k + ']'); const n = (k) => +chip(k).querySelector('b').textContent;
    out.antes = { urg: n('urgentes'), hoy: n('hoy'), sin: n('sinseg'), todas: n('todas') };
    chip('urgentes').click(); await w(300); out.urgentes = [total(), filas().every(f => /b-urgente/.test(f.className)), chip('urgentes').getAttribute('aria-pressed')];
    chip('sinseg').click(); await w(300); out.sinseg = [total(), filas().every(f => /sin seguimiento programado/.test(f.textContent))];
    set('ceEst', 'solicitud'); await w(300); const optSol = +b().querySelector('#ceEst').selectedOptions[0].text.match(/\\((\\d+)\\)/)[1]; out.tipoSol = [total(), optSol, chip('sinseg').getAttribute('aria-pressed')];
    const sel = b().querySelector('#ceResp'); out.opcionesResp = [...sel.options].map(o => o.text);
    const hayProv = [...b().querySelector('#ceProv').options].find(o => o.value); set('ceProv', hayProv.value); await w(300); out.conProv = [total(), filas().every(f => !f.textContent.includes('Almería') || hayProv.text === 'Almería'), b().querySelector('[data-quita-filtros]')?.textContent];
    chip('todas').click(); set('ceEst', 'todos'); set('ceProv', ''); await w(300);
    const q = b().querySelector('#ceQ'); q.value = 'zzzzzz'; q.dispatchEvent(new Event('input', { bubbles: true })); await w(300);
    out.vacio = [total(), b().querySelector('#ceList .pn-empty')?.textContent.replace(/\\s+/g, ' '), !!b().querySelector('#ceList [data-quita-filtros]'), chip('todas').querySelector('b').textContent];
    b().querySelector('#ceList [data-quita-filtros]').click(); await w(300);
    out.quitados = [total(), b().querySelector('#ceQ').value, b().querySelector('#ceEst').value, chip('todas').getAttribute('aria-pressed'), !b().querySelector('[data-quita-filtros]')];
    return out;`);
  ok(j2.urgentes[0] === j2.antes.urg && j2.urgentes[1] && j2.urgentes[2] === "true", "«Urgentes» muestra exactamente las urgentes (" + j2.antes.urg + ")");
  ok(j2.sinseg[0] > 0 && j2.sinseg[1] && j2.sinseg[0] <= j2.antes.sin, "«Sin seguimiento» combinada con «Urgentes» da una intersección coherente");
  eq(j2.tipoSol[0], j2.tipoSol[1], "el número de la opción de tipo es lo que sale al elegirla con los demás filtros");
  ok(j2.opcionesResp[0].startsWith("Todos (") && /^Sin responsable \(/.test(j2.opcionesResp[1]), "el filtro de responsable ofrece Todos y Sin responsable con su recuento");
  ok(/^Quitar filtros \(\d+\)$/.test(j2.conProv[2]), "con filtros activos hay un botón visible para quitarlos, con su número");
  ok(j2.vacio[0] === 0 && /Ninguna actuación con estos filtros/.test(j2.vacio[1]) && j2.vacio[2], "sin resultados: mensaje útil y botón para quitar filtros");
  eq(j2.quitados, [j1.total, "", "todos", "true", true], "«Quitar filtros» devuelve la bandeja completa");

  /* Navegación al expediente exacto y detalle */
  const j3 = await ev(ayudas + `
    const out = {}; const filas = () => [...b().querySelectorAll('.jo-fila')];
    const f = filas().find(x => /Solicitud/.test(x.querySelector('.jo-tipo').textContent)); const nombre = f.querySelector('.ce-pt strong').textContent, ong = f.querySelector('.jo-meta').textContent;
    f.querySelector('.jo-acts [data-sel]').click(); await w(400);
    out.detalle = [!b().querySelector('#ceSide').hidden, b().querySelector('#ceSide h3').textContent === nombre, /Por qué está en Mi jornada/.test(b().querySelector('#ceSide').textContent), b().dataset.vista, filas().length > 1];
    b().querySelector('#ceSide [data-ir]').click(); await w(400);
    out.destino = [b().dataset.vista, b().querySelector('#cePunto').textContent.includes(nombre), !b().querySelector('#ceSide').hidden, b().querySelector('#ceSide h3').textContent === nombre, document.getElementById('ceEst').value];
    b().querySelector('#ceNav [data-vista=jor]').click(); await w(400); out.vuelve = [b().dataset.vista, filas().length > 1, !b().querySelector('#cePunto').textContent];
    return out;`);
  eq(j3.detalle, [true, true, true, "jor", true], "«Abrir» enseña el expediente y por qué está en la bandeja sin salir de ella");
  eq(j3.destino.slice(0, 4), ["sol", true, true, true], "«Abrir en Solicitudes» lleva al expediente exacto, con su punto filtrado y su detalle abierto"); eq(j3.destino[4], "todas", "…con el estado «Todas» para que se vea");
  eq(j3.vuelve, ["jor", true, true], "al volver a Mi jornada la bandeja está como estaba (sin el filtro del punto)");
  await ev(ayudas + "b().querySelector('[data-cierra-lado]')?.click(); await w(100); return 1;");

  /* Completar una tarea: la base cambia, la bandeja se recalcula y el foco pasa a la siguiente */
  const j4 = await ev(ayudas + `
    const out = {}; const rel = () => fetch('http://127.0.0.1:8766/__rel').then(r => r.json()); const filas = () => [...b().querySelectorAll('.jo-fila')];
    const total = () => +b().querySelector('.ce-count').textContent.match(/^\\d+/)[0]; const abiertos = async () => (await rel()).followups.filter(f => !f.completed_at).length;
    const f0 = filas().find(x => x.querySelector('[data-act=hecho]')); const texto0 = f0.querySelector('.jo-main').textContent; const idx = filas().indexOf(f0), nombre = f0.querySelector('.ce-pt strong').textContent, antes = { total: total(), bd: await abiertos(), nav: +b().querySelector('#ceNav [data-vista=jor] .n').textContent };
    f0.querySelector('[data-act=hecho]').click(); out.durante = [filas().length > 0, [...b().querySelectorAll('.jo-fila [data-act]')].every(x => x.disabled), b().querySelector('#ceAviso').textContent, filas().some(x => x === f0 || x.dataset.key === f0.dataset.key)];
    await w(2800);
    out.despues = { aviso: b().querySelector('#ceAviso').textContent, bd: await abiertos(), total: total(), nav: +b().querySelector('#ceNav [data-vista=jor] .n').textContent, foco: document.activeElement.className, focoEnFila: !!document.activeElement.closest('.jo-fila'), sigueIgual: filas().some(x => x.dataset.key === f0.dataset.key && x.querySelector('.jo-main').textContent === texto0) };
    out.antes = antes; out.nombre = nombre; out.idx = idx;
    return out;`);
  ok(j4.durante[1] && /Guardando/.test(j4.durante[2]) && j4.durante[3], "mientras se guarda, los botones se bloquean y la fila sigue en pantalla: nada aparece resuelto sin confirmar");
  ok(/Seguimiento cerrado en/.test(j4.despues.aviso) && j4.despues.bd === j4.antes.bd - 1, "«Hecho» cierra el seguimiento en la base y lo confirma [" + j4.despues.aviso + "]");
  ok(j4.despues.nav <= j4.antes.nav && j4.despues.total <= j4.antes.total && !j4.despues.sigueIgual, "la bandeja y los recuentos se actualizan desde lo confirmado (la fila desaparece o pasa al siguiente seguimiento abierto de ese expediente)");
  ok(j4.despues.focoEnFila, "el foco pasa a la siguiente tarea para poder seguir sin reconstruir nada");

  /* Fallos: caída del guardado, conflicto y lote con resultado parcial */
  permitidos = [/\[Mapa\] (Error al guardar expedientes|Supabase rechazó una operación de expedientes|Error inesperado)/];
  const j5 = await ev(ayudas + `
    const out = {}; const rel = () => fetch('http://127.0.0.1:8766/__rel').then(r => r.json()); const filas = () => [...b().querySelectorAll('.jo-fila')]; const cli = window.mapaSession.supabase, origFrom = cli.from.bind(cli);
    const conHecho = () => filas().filter(x => x.querySelector('[data-act=hecho]'));
    /* a) el servidor no confirma el cierre: la fila sigue, con su aviso, y la base no cambia */
    const f0 = conHecho()[0], clave0 = f0.dataset.key, bd0 = (await rel()).followups.filter(f => !f.completed_at).length;
    cli.from = (t) => t === 'followups' ? Object.assign(origFrom(t), { update: () => { throw new TypeError('Failed to fetch'); } }) : origFrom(t);
    f0.querySelector('[data-act=hecho]').click(); await w(3500); cli.from = origFrom;
    out.caida = [b().querySelector('#ceAviso').textContent, filas().some(x => x.dataset.key === clave0 && x.querySelector('[data-act=hecho]')), (await rel()).followups.filter(f => !f.completed_at).length === bd0, ![...b().querySelectorAll('[data-act]')].some(x => x.disabled)];
    /* b) otra persona cambia el seguimiento antes de cerrarlo: conflicto, no se pisa y la bandeja se recarga */
    const f1 = conHecho()[0], acc = f1.querySelector('.jo-sig').textContent.replace('Siguiente: ', '').replace('Acción prevista: ', '').trim();
    const objetivo = (await rel()).followups.find(f => !f.completed_at && f.next_action === acc);
    if (objetivo) { await cli.from('followups').update({ next_action: 'Cambiado por otra persona J' }).eq('id', objetivo.id); await w(300); f1.querySelector('[data-act=hecho]').click(); await w(3500);
      out.conflicto = [b().querySelector('#ceAviso').textContent, (await rel()).followups.find(f => f.id === objetivo.id)?.completed_at == null]; } else out.conflicto = null;
    /* c) lote de 2: uno cambiado por otra persona -> 1 guardado y 1 sin guardar, y queda seleccionado */
    const marca = async (n) => { for (let i = 0; i < n; i++) { const c = b().querySelector('input[data-chk]:not(:checked)'); c.checked = true; c.dispatchEvent(new Event('change', { bubbles: true })); await w(150); } };
    out.disponibles = b().querySelectorAll('input[data-chk]').length; await marca(Math.min(2, out.disponibles)); out.seleccion = b().querySelectorAll('input[data-chk]:checked').length;
    const accs = [...b().querySelectorAll('input[data-chk]:checked')].map(i => i.closest('.jo-fila').querySelector('.jo-sig').textContent.replace('Siguiente: ', '').replace('Acción prevista: ', '').trim());
    const ob2 = (await rel()).followups.find(f => !f.completed_at && f.next_action === accs[0]);
    if (ob2) await cli.from('followups').update({ next_action: 'Cambiado por otra persona L' }).eq('id', ob2.id); await w(300);
    b().querySelector('[data-lote=hecho]').click(); await w(300); out.previo = b().querySelector('#ceLote .ce-lote strong').textContent; b().querySelector('[data-lote=ejecutar]').click(); await w(7000);
    out.lote = b().querySelector('#ceLote .ce-lote strong').textContent; out.lineas = [...b().querySelectorAll('#ceLote .ce-res-lote li')].map(li => li.className); out.quedan = b().querySelectorAll('input[data-chk]:checked').length;
    b().querySelector('[data-lote=cerrar]').click(); await w(200); b().querySelector('[data-lote=limpiar]')?.click();
    return out;`);
  ok(/No se pudo confirmar el guardado/.test(j5.caida[0]) && j5.caida[1] && j5.caida[2] && j5.caida[3], "caída del guardado: se explica, la fila sigue, la base no cambia y la pantalla queda operativa [" + j5.caida[0] + "]");
  ok(j5.conflicto && /Otra persona ha cambiado/.test(j5.conflicto[0]) && j5.conflicto[1], "conflicto de concurrencia: no se pisa lo de la otra persona [" + (j5.conflicto && j5.conflicto[0]) + "]");
  eq(j5.seleccion, 2, "se seleccionan 2 seguimientos desde Mi jornada (disponibles: " + j5.disponibles + ")"); ok(/Vas a cerrar 2 seguimientos/.test(j5.previo), "el lote enseña el alcance antes de confirmar");
  ok(/1 guardados y 1 sin guardar/.test(j5.lote) && j5.lineas.filter((x) => x === "mal").length === 1 && j5.lineas.filter((x) => x === "ok").length === 1 && j5.quedan === 1, "resultado parcial: resultado de cada registro y queda seleccionado el que falló [" + j5.lote + "]");
  permitidos = [];

  /* Teclado: Tab hasta «Hecho» y Enter lo ejecuta; Escape cierra */
  const j6 = await ev(ayudas + "b().querySelector('#ceNav [data-vista=jor]').click(); await w(300); const bd = (await (await fetch('http://127.0.0.1:8766/__rel')).json()).followups.filter(f => !f.completed_at).length; b().querySelector('#joT').focus(); window.__bd = bd; return bd;");
  let alcanzado = null;
  for (let i = 0; i < 60 && !alcanzado; i++) { await tecla("Tab", "Tab", 9); alcanzado = await ev("const e = document.activeElement; return e && e.matches && e.matches('[data-act=hecho]') ? e.getAttribute('aria-label') : null;"); }
  ok(!!alcanzado && /^Marcar como hecho el seguimiento de /.test(alcanzado), "con Tab se llega a «Hecho», con nombre accesible que incluye el punto [" + alcanzado + "]");
  await tecla("Enter", "Enter", 13); await esperaMs(3000);
  const bd2 = (await rel()).followups.filter((f) => !f.completed_at).length;
  ok(bd2 === j6 - 1, "Intro sobre «Hecho» cierra el seguimiento (solo teclado)");
  const j7 = await ev(ayudas + `
    const out = {}; const filas = [...b().querySelectorAll('.jo-fila')];
    out.focoFila = !!document.activeElement.closest('.jo-fila') || document.activeElement.id === 'joT';
    out.sinTabindex = [...b().querySelectorAll('#ceList button, #ceList input')].every(x => x.tabIndex >= 0);
    out.etiquetas = [...b().querySelectorAll('#ceList button, #ceList input, #ceList select')].filter(x => !(x.textContent.trim() || x.getAttribute('aria-label') || x.title)).length;
    out.h = [...b().querySelectorAll('#ceList h3')].map(h => h.textContent.trim().length > 0).every(Boolean);
    out.estados = filas.every(f => f.querySelector('.ce-sev') && f.querySelector('.ce-sev').textContent.trim().length > 0);
    return out;`);
  ok(j7.focoFila && j7.sinTabindex && j7.etiquetas === 0 && j7.h && j7.estados, "el foco queda en la lista tras la acción, todo es alcanzable con teclado, con nombre y con la gravedad también en texto");

  /* Detalle lateral y Escape: el foco entra en el detalle, Escape lo cierra SIN cerrar el Centro y el foco vuelve a su fila (crítica de diseño del 27/10/2026) */
  const j9a = await ev(ayudas + `
    const out = {}; const fila = b().querySelector('.jo-fila'); out.key = fila.dataset.key; fila.querySelector('.ce-pt').click(); await w(300);
    out.abierto = !b().querySelector('#ceSide').hidden; out.focoTitulo = document.activeElement === b().querySelector('#ceSide h3'); out.tituloFocalizable = b().querySelector('#ceSide h3').tabIndex === -1;
    return out;`);
  ok(j9a.abierto && j9a.focoTitulo && j9a.tituloFocalizable, "al abrir el detalle el foco pasa a su título (antes se quedaba en la página)");
  await tecla("Escape", "Escape", 27); await esperaMs(300);
  const j9b = await ev(ayudas + `
    const k = ${JSON.stringify(j9a.key)}; const fila = [...b().querySelectorAll('.jo-fila')].find((x) => x.dataset.key === k);
    return { centroAbierto: document.getElementById('dlgCentro').open, detalleCerrado: b().querySelector('#ceSide').hidden, focoEnFila: !!fila && document.activeElement === fila.querySelector('.ce-pt') };`);
  ok(j9b.centroAbierto && j9b.detalleCerrado && j9b.focoEnFila, "Escape con el detalle abierto lo cierra, el Centro sigue abierto y el foco vuelve a la fila [" + JSON.stringify(j9b) + "]");
  /* Con el foco fuera del cuerpo del Centro (tras pulsar en una zona vacía) Escape también cierra solo el detalle */
  await ev(ayudas + "b().querySelector('.jo-fila .ce-pt').click(); await w(300); document.activeElement.blur(); return 1;");
  await tecla("Escape", "Escape", 27); await esperaMs(300);
  const j9c = await ev(ayudas + "return { centroAbierto: document.getElementById('dlgCentro').open, detalleCerrado: b().querySelector('#ceSide').hidden };");
  ok(j9c.centroAbierto && j9c.detalleCerrado, "Escape con el foco en la página cierra el detalle y no el Centro [" + JSON.stringify(j9c) + "]");
  await tecla("Escape", "Escape", 27); await esperaMs(300);
  ok(!(await ev("return document.getElementById('dlgCentro').open;")), "con el detalle ya cerrado, Escape cierra el Centro");
  await ev(ayudas + "document.getElementById('centroBtn').click(); await w(600); if (!b().querySelector('.jo-fila')) { nav('jor'); await w(400); } return 1;");

  /* Modo oscuro: contraste del texto de las filas y cambio real de fondo */
  const j8claro = await ev(ayudas + "const f = b().querySelector('.jo-fila'); const cs = getComputedStyle(f), cm = getComputedStyle(f.querySelector('.jo-motivo strong')); return { fondo: cs.backgroundColor, texto: cm.color, menor: getComputedStyle(f.querySelector('.jo-meta')).color };");
  await c.send("Emulation.setEmulatedMedia", { features: [{ name: "prefers-color-scheme", value: "dark" }] }); await esperaMs(400);
  const j8oscuro = await ev(ayudas + "const f = b().querySelector('.jo-fila'); const cs = getComputedStyle(f), cm = getComputedStyle(f.querySelector('.jo-motivo strong')); return { fondo: cs.backgroundColor, texto: cm.color, menor: getComputedStyle(f.querySelector('.jo-meta')).color };");
  await c.send("Emulation.setEmulatedMedia", { features: [{ name: "prefers-color-scheme", value: "light" }] });
  const lum = (rgb) => { const m = rgb.match(/[\d.]+/g).map(Number); const [r, g, b2] = m.slice(0, 3).map((v) => { v /= 255; return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); }); return 0.2126 * r + 0.7152 * g + 0.0722 * b2; };
  const contraste = (x, y) => { const a = lum(x), b3 = lum(y); return (Math.max(a, b3) + 0.05) / (Math.min(a, b3) + 0.05); };
  ok(j8claro.fondo !== j8oscuro.fondo, "el modo oscuro cambia el fondo de las filas");
  for (const [nom, t] of [["claro", j8claro], ["oscuro", j8oscuro]]) ok(contraste(t.texto, t.fondo) >= 4.5 && contraste(t.menor, t.fondo) >= 4.5, "contraste del texto de las filas en modo " + nom + " (≥ 4,5:1)");

  /* Usuario de una provincia: solo su ámbito */
  await abre("alm@test.es", 1440, 900, { sinCentro: true });
  const j9 = await ev(ayudas + `
    const out = { abierta: document.getElementById('dlgCentro').open, prov: [...b().querySelectorAll('#ceProv option')].map(o => o.text) };
    const filas = [...b().querySelectorAll('.jo-fila')]; out.n = filas.length; out.otra = filas.some(f => /Granada|Armilla|Motril/.test(f.textContent));
    out.provinciaFija = b().querySelector('#ceProv').value !== '' && !b().querySelector('[data-quita-filtros]');
    return out;`);
  ok(j9.abierta && j9.n > 0 && !j9.otra && j9.prov.length === 1 && j9.prov[0] === "Almería" && j9.provinciaFija, "un usuario de una provincia ve solo las actuaciones de la suya, y la provincia no cuenta como filtro que quitar");

  /* Estados: sin expedientes, todo al día (y sin abrirse sola) y error de lectura */
  await abre("vacio@test.es", 1440, 900, { sinSeed: true, sinCentro: true });
  const j10 = await ev(ayudas + `
    const out = { abiertaSola: document.getElementById('dlgCentro').open };
    document.getElementById('menuBtn').click(); await w(100); out.menu = document.getElementById('jornadaBtn').textContent.trim(); document.getElementById('jornadaBtn').click(); await w(600);
    out.texto = b().querySelector('#ceList .pn-empty')?.textContent.replace(/\\s+/g, ' ');
    return out;`);
  ok(!j10.abiertaSola && j10.menu === "Mi jornada", "sin trabajo no se abre sola ni el menú inventa un número");
  ok(/Todavía no hay solicitudes ni concesiones/.test(j10.texto), "sin expedientes en el ámbito, lo dice");
  await abre("alm@test.es", 1440, 900, { sinSeed: true, sinCentro: true });
  await postAdmin("permit_applications", { establishment_id: "00000000-0000-4000-8000-000000000103", organization: "AECC", capturer_count: 2, requested_from: "2026-01-10", requested_until: "2026-01-12", requested_at: "2026-01-02", status: "denied", resolved_at: "2026-01-03T10:00:00Z" });
  await c.send("Page.reload"); await hasta(() => ev("return document.readyState === 'complete' && !!document.querySelector('#login input') && typeof L === 'object';"), 30000); await esperaMs(800);
  await ev("const ins=[...document.querySelectorAll('#login input')]; ins[0].value='alm@test.es'; ins[1].value='x'; ins.forEach(i=>i.dispatchEvent(new Event('input',{bubbles:true}))); document.querySelector('#login button[type=submit]').click(); return 1;");
  await hasta(() => ev("return !!window.mapaSession && /cargados/.test(document.getElementById('status').textContent);"), 30000); await esperaMs(1500);
  const j11 = await ev(ayudas + `
    const out = { abiertaSola: document.getElementById('dlgCentro').open };
    document.getElementById('menuBtn').click(); document.getElementById('jornadaBtn').click(); await w(600);
    out.texto = b().querySelector('#ceList .pn-empty')?.textContent.replace(/\\s+/g, ' '); out.filas = b().querySelectorAll('.jo-fila').length; out.nav = !!b().querySelector('#ceNav [data-vista=jor] .n:not([hidden])');
    window.mapaSession.catalogueReady = false; window.mapaSession.catalogueError = 'Error de lectura de prueba'; b().querySelector('#ceNav [data-vista=res]').click(); await w(200); b().querySelector('#ceNav [data-vista=jor]').click(); await w(300);
    out.error = [b().querySelector('#ceList [role=alert]')?.textContent.replace(/\\s+/g, ' '), /Todo al día/.test(b().querySelector('#ceList').textContent), b().querySelectorAll('.jo-fila').length];
    window.mapaSession.catalogueReady = true; window.mapaSession.catalogueError = null;
    return out;`);
  ok(!j11.abiertaSola && /Todo al día/.test(j11.texto) && j11.filas === 0 && !j11.nav, "con expedientes resueltos y nada pendiente: «Todo al día», sin abrirse sola ni contador");
  ok(/No se ha podido leer el trabajo pendiente/.test(j11.error[0]) && /Error de lectura de prueba/.test(j11.error[0]) && !j11.error[1] && j11.error[2] === 0, "si la lectura falló, no se presenta una bandeja vacía ni «Todo al día»");

  /* Móvil de 390 px */
  await abre("admin@test.es", 390, 800, { sinCentro: true });
  const j12 = await ev(ayudas + `
    const dlg = document.getElementById('dlgCentro'); const out = { abierta: dlg.open, desborde: dlg.scrollWidth > dlg.clientWidth };
    out.pequenos = [...b().querySelectorAll('#ceList button, #ceList select, #ceList input:not([type=checkbox]), .ce-filtros select, .ce-filtros input')].filter(e => e.offsetParent !== null && e.getBoundingClientRect().height < 43.5).map(e => (e.id || e.className).toString().slice(0, 24));
    out.casillas = [...b().querySelectorAll('.jo-fila .ce-chkl')].filter(e => e.getBoundingClientRect().height < 43.5 || e.getBoundingClientRect().width < 43.5).length;
    b().querySelector('.jo-fila .ce-pt').click(); await w(500); const l = b().querySelector('#ceSide').getBoundingClientRect(); out.detalle = [Math.round(l.width) >= innerWidth - 2, dlg.scrollWidth > dlg.clientWidth]; b().querySelector('.ce-x').click(); await w(300);
    out.accionesBajan = (() => { const f = b().querySelector('.jo-fila'); const a = f.querySelector('.jo-acts').getBoundingClientRect(), m = f.querySelector('.jo-main').getBoundingClientRect(); return a.top >= m.bottom - 1; })();
    return out;`);
  ok(j12.abierta && !j12.desborde && !j12.detalle[1] && j12.detalle[0], "móvil: Mi jornada se abre sin desbordes y el detalle ocupa la pantalla");
  eq([j12.pequenos, j12.casillas], [[], 0], "móvil: ningún control de Mi jornada por debajo de 44 px"); ok(j12.accionesBajan, "móvil: las acciones pasan debajo del texto de la fila");
  await c.send("Emulation.setDeviceMetricsOverride", { width: 1440, height: 900, deviceScaleFactor: 1, mobile: false });

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

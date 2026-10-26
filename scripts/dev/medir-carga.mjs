// Mide la carga de la aplicación con muchos puntos (por defecto 39.000) en un Chrome real contra el Supabase simulado. No toca ninguna base real.
// Compara variantes de index.html alternándolas (el ruido de la máquina es alto: usa varias repeticiones y mira la mediana y el mínimo).
// Uso: node scripts/dev/medir-carga.mjs <modo> nombre=ruta/index.html [nombre2=ruta2 ...]
//   tiempos  carga completa repetida (REP, por defecto 5): POST2 = ms desde que llega el catálogo hasta que la app es utilizable (pantalla desbloqueada),
//            LT = suma de tareas largas del hilo principal, FSUM = suma de renderList, refreshSelects, makeMarkers, checkLogros y gamTile.
//   bench    mínimo de varias llamadas con la aplicación ya cargada (renderList, refreshSelects, checkLogros, logrosCalc, refreshCounts…).
//   snap     compara lo que ve el usuario entre variantes: lista, contadores de los filtros, indicadores, insignias y marcadores, con varios filtros.
//   perfil   perfil de CPU de una carga (funciones con más tiempo propio e inclusivo).
// Variables: N_PUNTOS (39000), REP, USERSTATE=1 (listas personales: quitados, desactivados, revisados y favoritos), PERMISOS=<n> (solicitudes,
//   concesiones y seguimientos sintéticos en n puntos), ESTADOS, CUENTAS=0 (sin envolver funciones), CHROME_PATH.
// Puertos propios (simulado 8786, estático 8787, depuración 9343) para no chocar con el E2E (8766, 8767, 9333). Se desactiva WebGL (--disable-3d-apis):
// el mapa vectorial en software añadía un ruido enorme a la medida y es el mismo para todas las variantes.
import { spawn } from "node:child_process";
import { mkdtempSync, rmSync, readFileSync, existsSync } from "node:fs";
import { createServer } from "node:http";
import { tmpdir } from "node:os";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { createHash } from "node:crypto";
const [modo, ...resto] = process.argv.slice(2);
const raiz = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const MP = 8786, WP = 8787, CDP = 9343, MOCK = "http://127.0.0.1:" + MP, WEB = "http://127.0.0.1:" + WP;
const N = +(process.env.N_PUNTOS || 39000), REP = +(process.env.REP || 5);
const variantes = resto.filter((x) => x.includes("=")).map((x) => x.split("="));
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const hasta = async (c, ms = 60000) => { const t = Date.now(); while (Date.now() - t < ms) { try { const v = await c(); if (v) return v; } catch {} await sleep(100); } throw new Error("timeout"); };
const tmp = mkdtempSync(join(tmpdir(), "perf-")); const procs = [];
const lanza = (cmd, args, env = {}) => { const p = spawn(cmd, args, { stdio: "ignore", env: { ...process.env, ...env } }); procs.push(p); return p; };
const fin = () => { procs.forEach((p) => { try { p.kill(); } catch {} }); try { rmSync(tmp, { recursive: true, force: true }); } catch {} };
process.on("exit", fin);
const chrome = [process.env.CHROME_PATH, "C:/Program Files/Google/Chrome/Application/chrome.exe", "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe", "/usr/bin/google-chrome", "/usr/bin/google-chrome-stable", "/usr/bin/chromium", "/usr/bin/chromium-browser", "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"].find((x) => x && existsSync(x));
if (!chrome) { console.error("No se encuentra Chrome (define CHROME_PATH)."); process.exit(1); }
if (!["tiempos", "bench", "snap", "perfil"].includes(modo) || !resto.some((x) => x.includes("="))) { console.error("Uso: node scripts/dev/medir-carga.mjs <tiempos|bench|snap|perfil> nombre=ruta/index.html [...]"); process.exit(2); }
const webs = {};
lanza(process.execPath, [join(raiz, "scripts/dev/mock-supabase.mjs")], { MOCK_PORT: String(MP) });
await hasta(async () => (await fetch(MOCK + "/__rel")).ok, 15000);
for (const [nombre, ruta] of variantes) {
  const out = join(tmp, nombre + ".html");
  await new Promise((res, rej) => spawn(process.execPath, [join(raiz, "scripts/dev/build-mock-site.mjs"), ruta, out], { stdio: "ignore", env: { ...process.env, MOCK_PORT: String(MP) } }).on("exit", (c) => c === 0 ? res() : rej(new Error("build"))));
  webs[nombre] = readFileSync(out);
}
const srv = createServer((req, res) => { const n = req.url.split("?")[0].slice(1); res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" }); res.end(webs[n]); }).listen(WP, "127.0.0.1");
lanza(chrome, ["--headless=new", "--remote-debugging-port=" + CDP, "--user-data-dir=" + join(tmp, "perfil"), "--no-first-run", "--no-sandbox", "--disable-gpu", "--disable-3d-apis", "--window-size=1440,900", "about:blank"]);
const pest = await hasta(async () => (await (await fetch("http://127.0.0.1:" + CDP + "/json")).json()).find((t) => t.type === "page"), 20000);
const ws = new WebSocket(pest.webSocketDebuggerUrl); await new Promise((r) => ws.addEventListener("open", r));
let id = 0; const pend = new Map(); const errores = [];
ws.addEventListener("message", (ev) => { const m = JSON.parse(ev.data); if (m.id && pend.has(m.id)) { const { res, rej } = pend.get(m.id); pend.delete(m.id); m.error ? rej(new Error(m.error.message)) : res(m.result); } else if (m.method === "Runtime.exceptionThrown") errores.push(m.params.exceptionDetails.exception?.description || m.params.exceptionDetails.text); });
const send = (method, params = {}) => new Promise((res, rej) => { const i = ++id; pend.set(i, { res, rej }); ws.send(JSON.stringify({ id: i, method, params })); });
const ev = async (e) => { const r = await send("Runtime.evaluate", { expression: "(async()=>{" + e + "})()", awaitPromise: true, returnByValue: true }); if (r.exceptionDetails) throw new Error(r.exceptionDetails.exception?.description || r.exceptionDetails.text); return r.result.value; };
await send("Runtime.enable"); await send("Page.enable");
await send("Emulation.setDeviceMetricsOverride", { width: 1440, height: 900, deviceScaleFactor: 1, mobile: false });

const CUENTAS = process.env.CUENTAS !== "0";
const INSTR = "window.__t={};" + (CUENTAS ? " for(const n of ['renderList','refreshSelects','makeMarkers','checkLogros','logrosCalc','townStats','albumData','refreshCounts','gamTile','gamMenu','gamBadges','refrescaDensidad','pintaRegiones','refreshMuniSelect']){ if(typeof window[n]!=='function'){window.__t[n]='no';continue;} const f=window[n]; window.__t[n]={ms:0,n:0}; window[n]=function(){const t0=performance.now(); try{return f.apply(this,arguments);}finally{window.__t[n].ms+=performance.now()-t0; window.__t[n].n++;}}; }" : "") + "window.__larga=[]; try{ new PerformanceObserver(l=>l.getEntries().forEach(e=>window.__larga.push([Math.round(e.startTime),Math.round(e.duration)]))).observe({entryTypes:['longtask']}); }catch(e){}";
async function carga(nombre, conPerfil) {
  await fetch(MOCK + "/__reset?n=" + N + "&realista=1&estados=" + (process.env.ESTADOS || "0"));
  if (process.env.USERSTATE === "1") {
    const tk = await (await fetch(MOCK + "/auth/v1/token?grant_type=password", { method: "POST", headers: { "Content-Type": "application/json", apikey: "x" }, body: JSON.stringify({ email: "admin@test.es", password: "x" }) })).json();
    const uid = (n) => "est:00000000-0000-4000-8000-" + String(200000 + n).padStart(12, "0");
    const rng = (a, k, m) => Array.from({ length: k }, (_, i) => uid((a + i * m) % N));
    const state = { removed: rng(5, 300, 97), inactive: rng(11, 400, 89), reviewed: rng(3, 500, 71), favorites: rng(7, 250, 131) };
    state.removed.push("Punto de prueba 77 – Granada", "nombre inexistente");
    const r = await fetch(MOCK + "/rest/v1/user_app_state", { method: "POST", headers: { "Content-Type": "application/json", apikey: "x", Authorization: "Bearer " + tk.access_token }, body: JSON.stringify({ user_id: tk.user.id, state }) });
    if (r.status !== 201) throw new Error("userstate " + r.status);
  }
  if (+process.env.PERMISOS > 0) {
    const tk = await (await fetch(MOCK + "/auth/v1/token?grant_type=password", { method: "POST", headers: { "Content-Type": "application/json", apikey: "x" }, body: JSON.stringify({ email: "admin@test.es", password: "x" }) })).json();
    const H = { "Content-Type": "application/json", apikey: "x", Authorization: "Bearer " + tk.access_token };
    const d = (k) => new Date(Date.now() + k * 864e5).toISOString().slice(0, 10);
    const eid = (n) => "00000000-0000-4000-8000-" + String(200000 + n).padStart(12, "0");
    const post = async (t, f) => { const r = await fetch(MOCK + "/rest/v1/" + t, { method: "POST", headers: H, body: JSON.stringify(f) }); if (r.status !== 201) throw new Error(t + " " + r.status); };
    for (let k = 0; k < +process.env.PERMISOS; k++) {
      const i = (k * 61) % N; const estado = k % 9 === 0 ? "denied" : k % 11 === 0 ? "withdrawn" : "pending";
      await post("permit_applications", { establishment_id: eid(i), organization: "ONG " + (k % 5), capturer_count: 1 + (k % 4), requested_from: d((k % 30) - 3), requested_until: d((k % 30) + 4), requested_at: d(-(k % 20)), status: estado, ...(estado !== "pending" ? { resolved_at: d(-1) + "T10:00:00Z" } : {}) });
      await post("permit_grants", { establishment_id: eid((i + 7) % N), organization: "ONG " + ((k + 2) % 5), capturer_count: 1 + (k % 6), valid_from: d((k % 40) - 25), valid_until: k % 13 === 0 ? null : d((k % 40) - 8) });
      if (k % 2 === 0) await post("followups", { establishment_id: eid(i), due_on: d((k % 16) - 8), next_action: "Acción " + k, created_by: tk.user.id });
    }
  }
  await send("Page.navigate", { url: WEB + "/" + nombre + "?u=" + Date.now() });
  await hasta(() => ev("return document.readyState==='complete' && !!document.querySelector('#login input') && typeof L==='object' && typeof window.supabase==='object';"), 60000);
  await sleep(800);
  await ev(INSTR);
  if (conPerfil) { await send("Profiler.enable"); await send("Profiler.setSamplingInterval", { interval: 200 }); await send("Profiler.start"); }
  await send("Performance.enable"); const m0 = Object.fromEntries((await send("Performance.getMetrics")).metrics.map((x) => [x.name, x.value]));
  await ev("const ins=[...document.querySelectorAll('#login input')]; ins[0].value='admin@test.es'; ins[1].value='x'; window.__t0=performance.now(); document.querySelector('#login button[type=submit]').click(); return 1;");
  await hasta(() => ev("return !document.documentElement.classList.contains('lock') && /cargados/.test(document.getElementById('status').textContent);"), 120000);
  const base = await ev(`
    const t1=performance.now();
    const res=performance.getEntriesByType('resource').filter(r=>/establishments|provinces|app_state/.test(r.name));
    const ultimaRed=Math.max(...res.map(r=>r.responseEnd));
    const cat=performance.getEntriesByType('resource').filter(r=>r.name.indexOf('/rest/v1/establishments?')>=0); const finCat=Math.max(...cat.map(r=>r.responseEnd));
    return {post2:Math.round(t1-finCat), fn:window.__t, total:Math.round(t1-window.__t0), finRed:Math.round(ultimaRed-window.__t0), post:Math.round(t1-ultimaRed), larga:window.__larga};`);
  await sleep(1500);
  const m1 = Object.fromEntries((await send("Performance.getMetrics")).metrics.map((x) => [x.name, x.value]));
  base.lt = Math.round((await ev("return window.__larga.reduce((a,x)=>a+x[1],0);"))); base.fsum = Math.round((await ev("let s=0; for(const k of ['renderList','refreshSelects','makeMarkers','checkLogros','gamTile']){ if(window.__t[k]&&window.__t[k].ms) s+=window.__t[k].ms; } return s;")));
  base.script = Math.round((m1.ScriptDuration - m0.ScriptDuration) * 1000); base.task = Math.round((m1.TaskDuration - m0.TaskDuration) * 1000);
  let perfil = null;
  if (conPerfil) { perfil = (await send("Profiler.stop")).profile; }
  return { ...base, perfil };
}
const mediana = (a) => { const s = [...a].sort((x, y) => x - y); return s[Math.floor(s.length / 2)]; };
if (modo === "tiempos") {
  const R = Object.fromEntries(variantes.map(([n]) => [n, []]));
  for (let i = 0; i < REP; i++) for (const [n] of variantes) { const r = await carga(n, false); R[n].push(r); console.error(n, i, JSON.stringify({ post2: r.post2, lt: r.lt, fsum: r.fsum })); }
  if (process.env.FN === "1") console.log(JSON.stringify(R[variantes[0][0]][0].fn));
for (const [n] of variantes) console.log(n, "POST2 (datos->utilizable) mediana", mediana(R[n].map((r) => r.post2)), "min", Math.min(...R[n].map((r) => r.post2)), "todos", R[n].map((r) => r.post2).join(","), "| LT mediana", mediana(R[n].map((r) => r.lt)), "min", Math.min(...R[n].map((r) => r.lt)), "todos", R[n].map((r) => r.lt).join(","), "| FSUM mediana", mediana(R[n].map((r) => r.fsum)), "min", Math.min(...R[n].map((r) => r.fsum)), "todos", R[n].map((r) => r.fsum).join(","), "| SCRIPT mediana", mediana(R[n].map((r) => r.script)), "min", Math.min(...R[n].map((r) => r.script)), "| TASK mediana", mediana(R[n].map((r) => r.task)), "min", Math.min(...R[n].map((r) => r.task)), "| total mediana", mediana(R[n].map((r) => r.total)), "| finRed", mediana(R[n].map((r) => r.finRed)));
} else if (modo === "bench") {
  const acum = {};
  for (let i = 0; i < REP; i++) for (const [n] of variantes) {
    await carga(n, false);
    const r = await ev(`const T=(f)=>{const r=[];for(let i=0;i<5;i++){const t=performance.now();f();r.push(performance.now()-t);} return Math.min(...r);};
      return {renderList:T(()=>renderList()), refreshSelects:T(()=>refreshSelects()), checkLogros:T(()=>checkLogros()), logrosCalc:T(()=>logrosCalc()), refreshCounts:T(()=>refreshCounts()), makeMarkers:T(()=>makeMarkers(CENTERS)), gamMenu:T(()=>gamMenu()), townStats:T(()=>townStats()), albumData:T(()=>albumData())};`);
    ((acum[n] = acum[n] || {}), Object.entries(r).forEach(([k, v]) => (acum[n][k] = acum[n][k] || []).push(v)));
    console.error(n, i, JSON.stringify(Object.fromEntries(Object.entries(r).map(([k, v]) => [k, Math.round(v)]))));
  }
  for (const [n] of variantes) console.log(n, JSON.stringify(Object.fromEntries(Object.entries(acum[n]).map(([k, v]) => [k, Math.round(Math.min(...v))]))));
} else if (modo === "perfil") {
  const [n] = variantes[0];
  await carga(n, false);
  const r = await carga(n, true);
  const p = r.perfil; const nodos = new Map(p.nodes.map((x) => [x.id, x]));
  const self = new Map(); const dt = p.timeDeltas; let tot = 0;
  p.samples.forEach((sid, i) => { const cf = nodos.get(sid).callFrame; const k = (cf.functionName || "(anon)") + " " + cf.url.split("/").pop() + ":" + (cf.lineNumber + 1); self.set(k, (self.get(k) || 0) + dt[i]); tot += dt[i]; });
  console.log("post", r.post, "total", r.total, "perfil total ms", Math.round(tot / 1000));
  [...self.entries()].sort((a, b) => b[1] - a[1]).slice(0, 35).forEach(([k, v]) => console.log((v / 1000).toFixed(1).padStart(8), k));
  const hijos = new Map(); p.nodes.forEach((x) => (x.children || []).forEach((c) => hijos.set(c, x.id)));
  const incl = new Map();
  p.samples.forEach((sid, i) => { const vistos = new Set(); let cur = sid; while (cur) { const cf = nodos.get(cur).callFrame; const k = (cf.functionName || "(anon)") + ":" + (cf.lineNumber + 1); if (!vistos.has(k)) { vistos.add(k); incl.set(k, (incl.get(k) || 0) + dt[i]); } cur = hijos.get(cur); } });
  console.log("--- inclusivo");
  [...incl.entries()].sort((a, b) => b[1] - a[1]).slice(0, 45).forEach(([k, v]) => console.log((v / 1000).toFixed(1).padStart(8), k));
} else if (modo === "snap") {
  const out = {};
  for (const [n] of variantes) {
    await carga(n, false);
    out[n] = await ev(`
      const opts=(id)=>[...document.getElementById(id).options].map(o=>o.value+'|'+o.textContent);
      const snap=()=>({ vLista:document.getElementById('vLista').textContent, lis:[...document.querySelectorAll('#list li')].map(l=>l.dataset.id||l.textContent.slice(0,60)), sels:['provincia','muni','tipo','permiso','cadena','subtipo','valor','orden'].map(opts), kstrip:document.getElementById('kstrip').textContent, status:document.getElementById('status').textContent, cluster:cluster.getLayers().length, regCount:JSON.stringify(regCount), logrosBtn:(document.getElementById('logrosBtn')||{}).textContent, gamBtn:(document.getElementById('gamBtn')||{}).textContent, logros:JSON.stringify(logros.n), gam:JSON.stringify(Object.keys(gam.aw).sort()), rev:document.getElementById('revBtn').textContent, fav:document.getElementById('favBtn').textContent, restore:document.getElementById('restore').textContent, lg:document.getElementById('lgBody').textContent, clr:document.getElementById('clrBtn').textContent });
      const res={base:snap()};
      const set=(id,v)=>{const e=document.getElementById(id); e.value=v; e.dispatchEvent(new Event('change',{bubbles:true}));};
      set('tipo','Supermercado'); res.tipo=snap(); set('tipo','');
      set('provincia','Granada'); res.prov=snap(); set('provincia','');
      set('permiso','sin'); res.perm=snap(); set('permiso',''); set('permiso','concedido'); res.conc=snap(); set('permiso',''); set('permiso','solicitado'); res.soli=snap(); set('permiso',''); for(const b of ['revBtn','favBtn','segBtn']){ const e=document.getElementById(b); e.click(); await new Promise(r=>setTimeout(r,300)); res[b]=snap(); document.getElementById(b).click(); await new Promise(r=>setTimeout(r,300)); } set('tipo','Supermercado'); set('cadena',document.getElementById('cadena').options[1].value); res.cad=snap(); set('tipo','');
      const q=document.getElementById('q'); q.value='punto de prueba 12'; q.dispatchEvent(new Event('input',{bubbles:true})); await new Promise(r=>setTimeout(r,600)); res.q=snap(); q.value=''; q.dispatchEvent(new Event('input',{bubbles:true})); await new Promise(r=>setTimeout(r,600));
      set('orden','val'); res.orden=snap(); set('orden','');
      return res;`);
  }
  const hs = Object.entries(out).map(([n, o]) => [n, createHash("sha256").update(JSON.stringify(o)).digest("hex").slice(0, 16)]);
  console.log(hs.map((x) => x.join(" ")).join("\n"));
  const [a, b] = Object.values(out); if (b) for (const k of Object.keys(a)) console.log(k, JSON.stringify(a[k]) === JSON.stringify(b[k]) ? "IGUAL" : "DIFERENTE", a[k].lis.length, a[k].cluster);
  console.log("base", Object.values(out).map((o) => o.base.lis.length + "/" + o.base.cluster + " " + o.base.vLista));
}
if (errores.length) console.error("ERRORES PAGINA", errores.slice(0, 3));
srv.close(); fin(); process.exit(0);

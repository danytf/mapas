// Capturas de pantalla de «Mi jornada» contra el Supabase simulado (datos sintéticos), en escritorio, móvil y modo oscuro.
// Sirve para la inspección visual; no forma parte de las pruebas automáticas. No toca ninguna base real.
// Uso: node scripts/dev/capturas-jornada.mjs <carpeta-de-salida>        (necesita Chrome o Chromium; CHROME_PATH indica otro)
import { spawn } from "node:child_process";
import { existsSync, mkdirSync, mkdtempSync, rmSync, readFileSync, writeFileSync } from "node:fs";
import { createServer } from "node:http";
import { tmpdir } from "node:os";
import { join, dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { seed } from "./seed-permits-demo.mjs";

const RAIZ = join(dirname(fileURLToPath(import.meta.url)), "..", ".."), MOCK = "http://127.0.0.1:8766", WEB = "http://127.0.0.1:8767", CDP = 9335;
const SALIDA = resolve(process.argv[2] || join(tmpdir(), "capturas-jornada"));
mkdirSync(SALIDA, { recursive: true });
const espera = (ms) => new Promise((r) => setTimeout(r, ms));
const hasta = async (cond, ms = 20000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { try { const v = await cond(); if (v) return v; } catch { /* aún no */ } await espera(200); } throw new Error("Tiempo agotado"); };
const chrome = [process.env.CHROME_PATH, "C:/Program Files/Google/Chrome/Application/chrome.exe", "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe", "/usr/bin/google-chrome", "/usr/bin/chromium"].find((x) => x && existsSync(x));
if (!chrome) { console.log("SIN CHROME"); process.exit(1); }
const tmp = mkdtempSync(join(tmpdir(), "capturas-jor-")), procesos = [];
const lanza = (cmd, args) => { const p = spawn(cmd, args, { stdio: "ignore" }); procesos.push(p); return p; };
const conecta = async (url) => {
  const ws = new WebSocket(url); await new Promise((res, rej) => { ws.addEventListener("open", res); ws.addEventListener("error", rej); });
  let id = 0; const pend = new Map();
  ws.addEventListener("message", (ev) => { const m = JSON.parse(ev.data); if (m.id && pend.has(m.id)) { const { res, rej } = pend.get(m.id); pend.delete(m.id); m.error ? rej(new Error(m.error.message)) : res(m.result); } });
  return { send: (method, params = {}) => new Promise((res, rej) => { const i = ++id; pend.set(i, { res, rej }); ws.send(JSON.stringify({ id: i, method, params })); }) };
};
let servidor;
const main = async () => {
  lanza(process.execPath, [join(RAIZ, "scripts/dev/mock-supabase.mjs")]);
  await hasta(async () => (await fetch(MOCK + "/__rel")).ok, 15000);
  const web = join(tmp, "web"); mkdirSync(web);
  await new Promise((res, rej) => spawn(process.execPath, [join(RAIZ, "scripts/dev/build-mock-site.mjs"), join(RAIZ, "index.html"), join(web, "index.html")], { stdio: "ignore" }).on("exit", (c) => c === 0 ? res() : rej(new Error("build"))));
  const html = readFileSync(join(web, "index.html"));
  servidor = createServer((req, res) => { res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" }); res.end(html); }).listen(8767, "127.0.0.1");
  lanza(chrome, ["--headless=new", "--remote-debugging-port=" + CDP, "--user-data-dir=" + join(tmp, "perfil"), "--no-first-run", "--no-sandbox", "--disable-gpu", "--use-angle=swiftshader", "--enable-unsafe-swiftshader", "about:blank"]);
  const pestana = await hasta(async () => (await (await fetch("http://127.0.0.1:" + CDP + "/json")).json()).find((t) => t.type === "page"));
  const c = await conecta(pestana.webSocketDebuggerUrl); await c.send("Runtime.enable"); await c.send("Page.enable");
  const ev = async (e) => { const r = await c.send("Runtime.evaluate", { expression: "(async()=>{" + e + "})()", awaitPromise: true, returnByValue: true }); if (r.exceptionDetails) throw new Error(r.exceptionDetails.exception?.description || r.exceptionDetails.text); return r.result.value; };
  const foto = async (nombre) => { const r = await c.send("Page.captureScreenshot", { format: "png" }); writeFileSync(join(SALIDA, nombre + ".png"), Buffer.from(r.data, "base64")); console.log("captura:", nombre); };
  const ayudas = `const w=(ms)=>new Promise(r=>setTimeout(r,ms)); const b=()=>document.getElementById('ceBody'); const set=(id,v)=>{const e=b().querySelector('#'+id); e.value=v; e.dispatchEvent(new Event('input',{bubbles:true})); e.dispatchEvent(new Event('change',{bubbles:true}));};`;
  const abre = async (ancho, alto, usuario = "admin@test.es") => {
    await fetch(MOCK + "/__reset"); await seed(MOCK);
    await c.send("Emulation.setDeviceMetricsOverride", { width: ancho, height: alto, deviceScaleFactor: 1, mobile: ancho < 700 });
    await c.send("Page.navigate", { url: WEB + "/?u=" + Date.now() });
    await hasta(() => ev("return document.readyState === 'complete' && !!document.querySelector('#login input') && typeof L === 'object' && typeof window.supabase === 'object';"), 30000); await espera(800);
    await ev("const ins=[...document.querySelectorAll('#login input')]; ins[0].value=" + JSON.stringify(usuario) + "; ins[1].value='x'; ins.forEach(i=>i.dispatchEvent(new Event('input',{bubbles:true}))); document.querySelector('#login button[type=submit]').click(); return 1;");
    await hasta(() => ev("return !!document.getElementById('dlgCentro').open;"), 30000);
    await espera(900);
  };
  for (const [prefijo, ancho, alto] of [["pc", 1440, 900], ["movil", 390, 800]]) {
    await abre(ancho, alto);
    await foto(prefijo + "-01-al-entrar");
    await ev(ayudas + "b().querySelector('.jo-fila .ce-pt').click(); await w(500); return 1;"); await foto(prefijo + "-02-detalle");
    await ev(ayudas + "b().querySelector('[data-cierra-lado]')?.click(); await w(200); b().querySelector('[data-rapida=urgentes]').click(); await w(400); return 1;"); await foto(prefijo + "-03-urgentes");
    await ev(ayudas + "b().querySelector('[data-rapida=todas]').click(); await w(200); for (let i = 0; i < 2; i++) { const c = b().querySelector('input[data-chk]:not(:checked)'); if (c) { c.checked = true; c.dispatchEvent(new Event('change',{bubbles:true})); await w(150); } } return 1;"); await foto(prefijo + "-04-lote");
    await ev(ayudas + "b().querySelector('[data-lote=limpiar]')?.click(); await w(200); const q = b().querySelector('#ceQ'); q.value = 'zzzzzz'; q.dispatchEvent(new Event('input',{bubbles:true})); await w(400); return 1;"); await foto(prefijo + "-05-sin-resultados");
  }
  await abre(1440, 900);
  await c.send("Emulation.setEmulatedMedia", { features: [{ name: "prefers-color-scheme", value: "dark" }] });
  await espera(500); await foto("pc-oscuro-01"); await ev(ayudas + "b().querySelector('.jo-fila .ce-pt').click(); await w(500); return 1;"); await foto("pc-oscuro-02-detalle");
  await c.send("Emulation.setEmulatedMedia", { features: [{ name: "prefers-color-scheme", value: "light" }] });
  await abre(1440, 900, "alm@test.es"); await foto("pc-provincia-almeria");
};
main().then(() => { servidor?.close(); procesos.forEach((p) => { try { p.kill(); } catch { /* ya cerrado */ } }); try { rmSync(tmp, { recursive: true, force: true }); } catch { /* en uso */ } process.exit(0); })
  .catch((e) => { console.error("FALLO:", e.message); servidor?.close(); procesos.forEach((p) => { try { p.kill(); } catch { /* ya cerrado */ } }); process.exit(1); });

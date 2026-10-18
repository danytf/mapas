// Mide la carga del mapa con muchos puntos contra el Supabase simulado (scripts/dev/mock-supabase.mjs).
// Uso: con la copia de la app (scripts/dev/build-mock-site.mjs) abierta en el navegador y SIN haber iniciado sesión,
// pegar la parte 1 en la consola cambiando N; esperar a que cargue y pegar la parte 2.
// La página queda bloqueada mientras carga: con el código anterior a H-27, 20.000 puntos tardaban 75 s.

// ---- Parte 1: instrumentar e iniciar sesión como administrador con N puntos sintéticos ----
const N = 5000;
window.__t = {};
const envolver = (obj, nombre, etiqueta) => {
  const f = obj[nombre]; window.__t[etiqueta] = { ms: 0, n: 0 };
  obj[nombre] = function () { const t0 = performance.now(); try { return f.apply(this, arguments); } finally { window.__t[etiqueta].ms += performance.now() - t0; window.__t[etiqueta].n++; } };
};
envolver(window, "renderList", "renderList");
envolver(window, "refreshSelects", "refreshSelects");
if (typeof makeMarkers === "function") { envolver(window, "makeMarkers", "makeMarkers"); envolver(cluster, "addLayers", "cluster.addLayers"); }
else { envolver(window, "makeMarker", "makeMarker"); envolver(cluster, "addLayer", "cluster.addLayer"); }
window.__larga = [];
try { new PerformanceObserver((l) => l.getEntries().forEach((e) => window.__larga.push(Math.round(e.duration)))).observe({ entryTypes: ["longtask"] }); } catch (e) {}
window.__cargadoMs = null;
new MutationObserver(() => {
  if (window.__cargadoMs === null && /[0-9]+ establecimientos cargados/.test(document.getElementById("status").textContent)) window.__cargadoMs = Math.round(performance.now() - window.__t0);
}).observe(document.getElementById("status"), { childList: true, characterData: true, subtree: true });
await fetch("http://127.0.0.1:8766/__reset?n=" + N + "&estados=0");
document.getElementById("lgUser").value = "admin@test.es";
document.getElementById("lgPass").value = "x";
window.__t0 = performance.now();
document.getElementById("loginForm").requestSubmit();

// ---- Parte 2: leer los resultados (pegar cuando haya cargado) ----
// const wait = (ms) => new Promise((r) => setTimeout(r, ms));
// for (let i = 0; i < 400 && window.__cargadoMs === null; i++) await wait(200);
// const r = {}; for (const [k, v] of Object.entries(window.__t)) r[k] = { ms: Math.round(v.ms), llamadas: v.n };
// const out = { msHastaMapaCargado: window.__cargadoMs, funciones: r, tareasLargasMs: window.__larga,
//   filasEnLista: document.getElementById("list").children.length, nodosDOM: document.getElementsByTagName("*").length,
//   heapMB: performance.memory ? Math.round(performance.memory.usedJSHeapSize / 1048576) : null };
// const sel = document.getElementById("tipo"); sel.value = "Hospital"; let t = performance.now();
// sel.dispatchEvent(new Event("change", { bubbles: true })); out.msFiltroCategoria = Math.round(performance.now() - t);
// sel.value = ""; sel.dispatchEvent(new Event("change", { bubbles: true }));
// out;

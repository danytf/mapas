// Escenarios de la lista lateral para comparar dos versiones de la app (p. ej. main frente a una rama) contra el Supabase simulado.
// Uso: GET http://127.0.0.1:8766/__reset?n=250&estados=1, iniciar sesión como admin@test.es en cada versión y pegar este guion;
// devuelve, por escenario, el número de elementos, las cabeceras de grupo y un hash del HTML de la lista: deben coincidir entre versiones.
const wait = (ms) => new Promise((r) => setTimeout(r, ms));
const hash = (s) => { let h = 0; for (let i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) | 0; return h + ":" + s.length; };
const lista = () => document.getElementById("list");
const res = {};
const snap = (nombre) => {
  const li = [...lista().children];
  res[nombre] = {
    elementos: li.length,
    cabeceras: li.filter((x) => x.classList.contains("grp")).map((x) => x.textContent.trim().slice(0, 60)),
    hash: hash(lista().innerHTML),
    marcadoresEnMapa: document.querySelectorAll(".leaflet-marker-icon").length
  };
};
const poner = async (id, valor, evento) => { const e = document.getElementById(id); e.value = valor; e.dispatchEvent(new Event(evento || "change", { bubbles: true })); await wait(500); };
const limpiar = async () => { for (const id of ["tipo", "permiso", "valor", "orden", "provincia"]) await poner(id, ""); await poner("q", "", "input"); };

await wait(500);
snap("base");
await poner("tipo", "Hospital"); snap("categoria Hospital"); await limpiar();
await poner("q", "sintético 1", "input"); snap("busqueda"); await limpiar();
await poner("permiso", "solicitado"); snap("estado solicitado"); await limpiar();
await poner("permiso", "concedido"); snap("estado concedido"); await limpiar();
await poner("orden", "val"); snap("orden por valoracion"); await limpiar();
document.getElementById("revBtn").click(); await wait(500); snap("por revisar"); document.getElementById("revBtn").click(); await wait(500);
document.getElementById("segBtn").click(); await wait(500); snap("seguimiento"); document.getElementById("segBtn").click(); await wait(500);
snap("base otra vez");
res;

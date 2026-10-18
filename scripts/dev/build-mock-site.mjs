// Prepara una copia de index.html que habla con el Supabase simulado (scripts/dev/mock-supabase.mjs) y con su
// Nominatim simulado, para probar la interfaz en el navegador sin tocar ningún proyecto real.
// Uso: node scripts/dev/build-mock-site.mjs <index.html de origen> <fichero de salida>
// La copia sirve en cualquier servidor estático local (p. ej. 127.0.0.1:8765); no se guarda en el repositorio.
import { readFileSync, writeFileSync } from "node:fs";

const [src, out] = process.argv.slice(2);
if (!src || !out) { console.error("Uso: node scripts/dev/build-mock-site.mjs <origen> <salida>"); process.exit(2); }
let html = readFileSync(src, "utf8");
const MOCK = "http://127.0.0.1:8766";
const replaceAll = (a, b) => {
  if (!html.includes(a)) throw new Error("No se encuentra en el origen: " + a.slice(0, 60));
  html = html.split(a).join(b);
};
const url = html.match(/const SUPABASE_URL = "(https:\/\/[a-z0-9]+\.supabase\.co)";/);
const key = html.match(/const SUPABASE_KEY = "([^"]+)";/);
if (!url || !key) throw new Error("No se encuentran SUPABASE_URL y SUPABASE_KEY");
// La CSP de la copia permite solo el simulado; Nominatim también va al simulado.
replaceAll(url[1] + " https://nominatim.openstreetmap.org", MOCK);
replaceAll('const SUPABASE_URL = "' + url[1] + '";', 'const SUPABASE_URL = "' + MOCK + '";');
replaceAll(key[1], "sb_publishable_mock");
replaceAll("https://nominatim.openstreetmap.org/search", MOCK + "/nominatim/search");
// Registrador de violaciones de CSP desde el primer byte (window.__csp).
const lock = '<script>document.documentElement.classList.add("lock");</script>';
replaceAll(lock, '<script>window.__csp=[];document.addEventListener("securitypolicyviolation",function(e){window.__csp.push(e.violatedDirective+" "+e.blockedURI)});</script>\n' + lock);
writeFileSync(out, html);
console.log("Copia de prueba escrita en " + out);

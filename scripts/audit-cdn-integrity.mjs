#!/usr/bin/env node
// Auditoría H-01: todo script o hoja de estilos externa debe cargarse con versión exacta
// e integridad SRI (sha384+) y crossorigin. La hoja de Google Fonts es la única excepción
// porque su contenido varía según el navegador y no admite SRI.
import { readFileSync } from "node:fs";

const file = process.argv[2] || "index.html";
const html = readFileSync(file, "utf8");
const EXEMPT_HOSTS = new Set(["fonts.googleapis.com"]);
const tags = [...html.matchAll(/<(script|link)\b([^>]*)>/gi)].map((m) => ({ tag: m[1].toLowerCase(), attrs: m[2] }));
const failures = [];
let checked = 0;

for (const { tag, attrs } of tags) {
  const attr = (name) => (attrs.match(new RegExp("\\b" + name + "\\s*=\\s*\"([^\"]*)\"", "i")) || [])[1];
  const url = tag === "script" ? attr("src") : /\brel\s*=\s*"stylesheet"/i.test(attrs) ? attr("href") : undefined;
  if (!url || !/^https?:\/\//i.test(url)) continue;
  const host = new URL(url).hostname;
  if (EXEMPT_HOSTS.has(host)) continue;
  checked++;
  if (!/@\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?(?=\/|$)/.test(url)) failures.push(`versión no fijada (x.y.z): ${url}`);
  const integrity = attr("integrity");
  if (!integrity || !/^sha(384|512)-[A-Za-z0-9+/]{64,}={0,2}$/.test(integrity.trim().split(/\s+/)[0])) {
    failures.push(`falta integrity sha384/sha512 válido: ${url}`);
  }
  if (attr("crossorigin") !== "anonymous") failures.push(`falta crossorigin="anonymous": ${url}`);
}

if (checked === 0) failures.push("no se encontró ningún recurso externo: la auditoría no está comprobando nada");
if (failures.length) {
  console.error("AUDITORÍA CDN/SRI: FALLO");
  for (const f of failures) console.error("- " + f);
  process.exit(1);
}
console.log(`AUDITORÍA CDN/SRI: OK (${checked} recursos externos con versión exacta e integridad)`);

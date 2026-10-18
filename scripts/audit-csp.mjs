#!/usr/bin/env node
// Auditoría H-02: la página debe declarar una Content-Security-Policy por <meta> (GitHub Pages no
// permite cabeceras) como primer elemento de <head>, sin comodines ni 'unsafe-eval', y cada origen
// externo que usa el código debe estar permitido en su directiva. Si se añade un recurso o servicio
// nuevo sin actualizar la política, esta auditoría falla antes de que el navegador lo bloquee.
import { readFileSync } from "node:fs";

const file = process.argv[2] || "index.html";
const html = readFileSync(file, "utf8");
const failures = [];

const metas = [...html.matchAll(/<meta\s+http-equiv="Content-Security-Policy"\s+content="([^"]*)"\s*>/gi)];
if (metas.length !== 1) {
  failures.push(`debe haber exactamente una <meta http-equiv="Content-Security-Policy"> (hay ${metas.length})`);
}
const policy = metas[0]?.[1] || "";

// Debe ir antes de cualquier script, hoja de estilos o estilo: la política no protege lo anterior.
const head = html.slice(html.search(/<head>/i) + 6, html.search(/<\/head>/i));
const firstTag = (head.match(/<(script|link|style|meta)\b[^>]*>/i) || [""])[0];
if (!/http-equiv="Content-Security-Policy"/i.test(firstTag)) {
  failures.push("la <meta> de CSP debe ser el primer elemento de <head>");
}

const directives = new Map(policy.split(";").map((d) => d.trim()).filter(Boolean).map((d) => {
  const [name, ...sources] = d.split(/\s+/);
  return [name.toLowerCase(), sources];
}));
const sourcesOf = (name) => directives.get(name) || directives.get("default-src") || [];
const expect = (name, value) => {
  const got = (directives.get(name) || []).join(" ");
  if (got !== value) failures.push(`${name} debe ser ${value} (es «${got || "sin definir"}»)`);
};
expect("default-src", "'self'");
expect("object-src", "'none'");
expect("base-uri", "'none'");
expect("form-action", "'none'");

for (const [name, sources] of directives) {
  for (const s of sources) {
    if (s === "*" || /^\*|:\/\/\*/.test(s)) failures.push(`${name} no puede usar comodines: ${s}`);
    if (s === "'unsafe-eval'") failures.push(`${name} no puede permitir 'unsafe-eval'`);
    if (/^http:/i.test(s) || s === "http:" || s === "https:") failures.push(`${name} demasiado amplio o sin TLS: ${s}`);
  }
}
if ((directives.get("script-src") || []).some((s) => s === "data:" || s === "blob:")) {
  failures.push("script-src no puede permitir data: ni blob:");
}

const allows = (name, url) => {
  const origin = new URL(url).origin;
  return sourcesOf(name).some((s) => s.replace(/\/$/, "") === origin);
};
let checked = 0;
const requireAllowed = (name, url, what) => {
  checked++;
  if (!allows(name, url)) failures.push(`${name} no permite ${new URL(url).origin} (${what})`);
};

for (const m of html.matchAll(/<script\b[^>]*\bsrc="(https:\/\/[^"]+)"/gi)) requireAllowed("script-src", m[1], "script externo");
for (const m of html.matchAll(/<link\b[^>]*rel="stylesheet"[^>]*href="(https:\/\/[^"]+)"/gi)) requireAllowed("style-src", m[1], "hoja de estilos");
for (const m of html.matchAll(/<link\b[^>]*href="(https:\/\/[^"]+)"[^>]*rel="stylesheet"/gi)) requireAllowed("style-src", m[1], "hoja de estilos");
const supabaseUrl = (html.match(/const SUPABASE_URL = "(https:\/\/[^"]+)"/) || [])[1];
if (!supabaseUrl) failures.push("no se encontró SUPABASE_URL");
else requireAllowed("connect-src", supabaseUrl, "Supabase");
for (const m of html.matchAll(/["'`](https:\/\/nominatim\.[^"'`]+)["'`]/g)) requireAllowed("connect-src", m[1], "geocodificación");
for (const m of html.matchAll(/L\.tileLayer\(\s*["'`](https:\/\/[^"'`]+)["'`]/g)) {
  requireAllowed("img-src", m[1].replace(/\{s\}\./, "").replace(/\{[^}]+\}/g, "0"), "teselas del mapa");
}
if (/fonts\.googleapis\.com/.test(html)) requireAllowed("font-src", "https://fonts.gstatic.com/", "fuentes de Google");

// Cualquier otra URL https del documento debe estar permitida por alguna directiva de carga, salvo los
// destinos que solo se usan como enlace de navegación (no cargan recursos en la página).
const NAVIGATION_ONLY = new Set(["https://www.google.com", "https://danytf.github.io"]);
const loadDirectives = ["script-src", "style-src", "img-src", "connect-src", "font-src"];
const htmlWithoutPolicy = html.replace(metas[0]?.[0] || "", "");
for (const m of htmlWithoutPolicy.matchAll(/https:\/\/[a-z0-9.-]+\.[a-z]{2,}/gi)) {
  const origin = new URL(m[0]).origin;
  if (NAVIGATION_ONLY.has(origin)) continue;
  if (!loadDirectives.some((d) => allows(d, origin))) failures.push(`origen usado en el código y no permitido por la CSP: ${origin}`);
}
if (checked < 8) failures.push(`solo se comprobaron ${checked} orígenes: la auditoría no está viendo los recursos esperados`);

if (failures.length) {
  console.error("AUDITORÍA CSP: ERROR");
  failures.forEach((f) => console.error("- " + f));
  process.exit(1);
}
console.log(`AUDITORÍA CSP: OK (${checked} orígenes comprobados, ${directives.size} directivas)`);

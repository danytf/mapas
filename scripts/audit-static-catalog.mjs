#!/usr/bin/env node
/**
 * Auditoría reproducible de los literales del catálogo.
 * Uso: node scripts/audit-static-catalog.mjs [index.html] [directorio-salida]
 * Solo lee el archivo indicado. No abre navegador, no lee almacenamiento local y no conecta con Supabase.
 */
import fs from "node:fs";
import path from "node:path";
import { createHash } from "node:crypto";

const sourcePath = path.resolve(process.argv[2] ?? "index.html");
const outputDir = path.resolve(process.argv[3] ?? "catalog-audit-output");
const source = fs.readFileSync(sourcePath, "utf8");

function literalFor(name) {
  const match = new RegExp("\\bconst\\s+" + name + "\\s*=\\s*").exec(source);
  if (!match) throw new Error("No se encontró la constante " + name);
  let i = match.index + match[0].length;
  while (/\s/.test(source[i] ?? "")) i++;
  const start = i;
  const opening = source[i];
  if (opening !== "[" && opening !== "{") throw new Error(name + ": no es un literal array/objeto");
  let depth = 0, quote = "", escaped = false, lineComment = false, blockComment = false;
  for (; i < source.length; i++) {
    const c = source[i], next = source[i + 1];
    if (lineComment) { if (c === "\n") lineComment = false; continue; }
    if (blockComment) { if (c === "*" && next === "/") { blockComment = false; i++; } continue; }
    if (quote) {
      if (escaped) { escaped = false; continue; }
      if (c === "\\") { escaped = true; continue; }
      if (c === quote) quote = "";
      continue;
    }
    if (c === "/" && next === "/") { lineComment = true; i++; continue; }
    if (c === "/" && next === "*") { blockComment = true; i++; continue; }
    if (c === '"' || c === "'") { quote = c; continue; }
    if (c === "[" || c === "{") depth++;
    if (c === "]" || c === "}") {
      depth--;
      if (depth === 0) return source.slice(start, i + 1);
    }
  }
  throw new Error(name + ": literal sin cerrar");
}

function stripComments(text) {
  let out = "", quote = "", escaped = false, lineComment = false, blockComment = false;
  for (let i = 0; i < text.length; i++) {
    const c = text[i], next = text[i + 1];
    if (lineComment) { if (c === "\\n") { lineComment = false; out += c; } else out += " "; continue; }
    if (blockComment) {
      if (c === "*" && next === "/") { blockComment = false; out += "  "; i++; }
      else out += c === "\\n" ? "\\n" : " ";
      continue;
    }
    if (quote) {
      out += c;
      if (escaped) { escaped = false; continue; }
      if (c === "\\\\") { escaped = true; continue; }
      if (c === quote) quote = "";
      continue;
    }
    if (c === '"' || c === "'") { quote = c; out += c; continue; }
    if (c === "/" && next === "/") { lineComment = true; out += "  "; i++; continue; }
    if (c === "/" && next === "*") { blockComment = true; out += "  "; i++; continue; }
    out += c;
  }
  return out;
}

function parseArray(name) {
  const text = stripComments(literalFor(name));
  // Estos seis bloques son arrays de datos literales con strings/números/booleanos.
  const json = name === "CENTERS"
    ? text.replace(/(^|[,{]\s*)(id|name|tipo|street|conf|extra)\s*:/gm, '$1"$2":')
    : text;
  return JSON.parse(json);
}
function parseObject(name) { return JSON.parse(stripComments(literalFor(name))); }
function csv(value) {
  const s = value == null ? "" : String(value);
  return /[",\r\n]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s;
}
function writeCsv(file, rows, columns) {
  fs.writeFileSync(file, [columns.join(","), ...rows.map(r => columns.map(k => csv(r[k])).join(","))].join("\r\n") + "\r\n");
}
function normalize(value) {
  return String(value ?? "").normalize("NFD").replace(/[\u0300-\u036f]/g, "")
    .toLocaleLowerCase("es").replace(/[^a-z0-9]+/g, " ").trim();
}

const definitions = [
  ["CENTERS", "Centro sanitario"],
  ["PROV", "Centro sanitario"],
  ["SUPER", "Supermercado"],
  ["OFICIALES", "Oficina/servicio público"],
  ["GYMS", "Gimnasio/centro deportivo"],
  ["BIGS", "Gran superficie/servicio"],
];
const rows = [];
for (const [block, defaultCategory] of definitions) {
  const values = parseArray(block);
  values.forEach((v, index) => {
    let row;
    if (block === "CENTERS") row = {
      source_block:block, source_index:index+1, source_id:v.id ?? "", name:v.name ?? "",
      category:v.tipo ?? defaultCategory, municipality:"", address:v.street ?? "",
      review_flag:v.conf === true ? "true" : v.conf === false ? "false" : "", source_note:v.extra ?? ""
    };
    else if (block === "PROV") row = {
      source_block:block, source_index:index+1, source_id:"", name:v[1] ?? "",
      category:v[0] === "L" ? "Consultorio" : "Centro de salud", municipality:v[2] ?? "",
      address:v[3] ?? "", review_flag:v[4] ?? "", source_note:""
    };
    else if (block === "SUPER") row = {
      source_block:block, source_index:index+1, source_id:"", name:v[0] ?? "",
      category:defaultCategory, municipality:v[1] ?? "", address:v[2] ?? "",
      review_flag:"", source_note:v[3] ?? ""
    };
    else if (block === "OFICIALES") row = {
      source_block:block, source_index:index+1, source_id:"", name:v[0] ?? "",
      category:v[1] ?? defaultCategory, municipality:v[2] ?? "", address:v[3] ?? "",
      review_flag:"", source_note:""
    };
    else if (block === "GYMS") row = {
      source_block:block, source_index:index+1, source_id:"", name:v[0] ?? "",
      category:defaultCategory, municipality:v[1] ?? "", address:v[2] ?? "",
      review_flag:"", source_note:v[3] ?? ""
    };
    else row = {
      source_block:block, source_index:index+1, source_id:"", name:v[0] ?? "",
      category:v[1] ?? defaultCategory, municipality:v[2] ?? "", address:v[3] ?? "",
      review_flag:"", source_note:v[4] ?? ""
    };
    row.source_key = String(row.name);
    rows.push(row);
  });
}

const coordinates = parseObject("PRECOMPUTED");
const coordinateKeys = new Set(Object.keys(coordinates));
for (const row of rows) {
  const pair = coordinates[row.source_key];
  row.latitude = Array.isArray(pair) ? pair[0] : "";
  row.longitude = Array.isArray(pair) ? pair[1] : "";
  row.coordinate_key_match = pair ? "exact" : "missing";
  row.coordinate_valid_range = Array.isArray(pair) && pair.length === 2 &&
    Number.isFinite(pair[0]) && Number.isFinite(pair[1]) &&
    pair[0] >= -90 && pair[0] <= 90 && pair[1] >= -180 && pair[1] <= 180 ? "yes" : "no";
}
const nameGroups = new Map();
for (const row of rows) {
  const key = normalize(row.name);
  if (!key) continue;
  if (!nameGroups.has(key)) nameGroups.set(key, []);
  nameGroups.get(key).push(row);
}
const duplicates = [...nameGroups.entries()].filter(([, group]) => group.length > 1).map(([normalized_name, group]) => ({
  normalized_name, count:group.length,
  source_rows:group.map(r => r.source_block + "#" + r.source_index).join("; "),
  names:[...new Set(group.map(r => r.name))].join("; ")
}));
const usedKeys = new Set(rows.map(r => r.source_key));
const unusedKeys = [...coordinateKeys].filter(k => !usedKeys.has(k)).map(key => ({key}));
const issues = [];
for (const row of rows) {
  const missing = [];
  if (!String(row.name).trim()) missing.push("missing_name");
  if (!String(row.municipality).trim()) missing.push("missing_municipality");
  if (!String(row.address).trim()) missing.push("missing_address");
  if (row.coordinate_key_match !== "exact") missing.push("missing_coordinate_match");
  if (row.coordinate_valid_range !== "yes") missing.push("invalid_or_missing_coordinate");
  if (missing.length) issues.push({source_block:row.source_block, source_index:row.source_index, source_key:row.source_key, issues:missing.join("; ")});
}

fs.mkdirSync(outputDir, {recursive:true});
const columns = ["source_block","source_index","source_id","source_key","name","category","municipality","address","latitude","longitude","coordinate_key_match","coordinate_valid_range","review_flag","source_note"];
writeCsv(path.join(outputDir,"catalog-audit.csv"), rows, columns);
writeCsv(path.join(outputDir,"duplicate-names.csv"), duplicates, ["normalized_name","count","source_rows","names"]);
writeCsv(path.join(outputDir,"rows-with-issues.csv"), issues, ["source_block","source_index","source_key","issues"]);
writeCsv(path.join(outputDir,"unused-coordinate-keys.csv"), unusedKeys, ["key"]);
const summary = {
  source_file:sourcePath, source_sha256:createHash("sha256").update(source).digest("hex"),
  rows_by_source:Object.fromEntries(definitions.map(([name]) => [name, rows.filter(r => r.source_block === name).length])),
  total_rows:rows.length, precomputed_coordinate_keys:coordinateKeys.size,
  exact_coordinate_matches:rows.filter(r => r.coordinate_key_match === "exact").length,
  missing_coordinate_matches:rows.filter(r => r.coordinate_key_match !== "exact").length,
  invalid_or_missing_coordinates:rows.filter(r => r.coordinate_valid_range !== "yes").length,
  missing_municipality:rows.filter(r => !String(r.municipality).trim()).length,
  missing_address:rows.filter(r => !String(r.address).trim()).length,
  normalized_duplicate_name_groups:duplicates.length,
  rows_in_duplicate_name_groups:duplicates.reduce((n,d) => n+d.count,0),
  unused_precomputed_coordinate_keys:unusedKeys.length, rows_with_issues:issues.length,
  limitation:"Auditoría estructural; no confirma unicidad física, exactitud de direcciones ni precisión geográfica."
};
fs.writeFileSync(path.join(outputDir,"summary.json"), JSON.stringify(summary,null,2)+"\n");
console.log(JSON.stringify({outputDir,...summary},null,2));

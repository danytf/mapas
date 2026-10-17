import { readFileSync } from "node:fs";

const path = process.argv[2] || "index.html";
const html = readFileSync(path, "utf8");
const failures = [];
const requireMatch = (pattern, message) => {
  if (!pattern.test(html)) failures.push(message);
};
const forbidMatch = (pattern, message) => {
  if (pattern.test(html)) failures.push(message);
};

forbidMatch(/\b(?:window\s*\.\s*)?(?:localStorage|sessionStorage)\s*\.\s*(?:setItem|clear)\s*\(/i,
  "No se permiten escrituras directas en localStorage/sessionStorage.");
forbidMatch(/\b(?:window\s*\.\s*)?indexedDB\s*\.\s*(?:open|deleteDatabase)\s*\(/i,
  "No se permite persistir datos mediante IndexedDB.");
forbidMatch(/\b(?:window\s*\.\s*)?caches\s*\.\s*open\s*\(/i,
  "No se permite persistir datos de la aplicación en Cache Storage.");
forbidMatch(/\bdocument\s*\.\s*cookie\s*=/i,
  "No se permite guardar datos de la aplicación en cookies.");
forbidMatch(/\bnavigator\s*\.\s*serviceWorker\s*\.\s*register\s*\(/i,
  "No se permite registrar un service worker para persistencia local.");

requireMatch(/delete\s+loadedPersonalState\.locations\s*;/,
  "Debe descartarse el campo heredado loadedPersonalState.locations.");

const setLocStart = html.indexOf("async function setLoc(c, lat, lon, address)");
const customStart = html.indexOf("if (c.custom) {", setLocStart);
const masterStart = html.indexOf("if (!c.databaseId)", customStart);
if (setLocStart < 0 || customStart < 0 || masterStart < 0) {
  failures.push("No se pudo localizar la edición de ubicaciones personalizadas.");
} else {
  const customLocation = html.slice(customStart, masterStart);
  if (!/if\s*\(!await\s+saveCustoms\(\)\)\s*\{/.test(customLocation) ||
      !/p\.lat\s*=\s*previous\.lat/.test(customLocation) ||
      !/p\.lon\s*=\s*previous\.lon/.test(customLocation) ||
      !/await\s+saveCustoms\(\)/.test(customLocation)) {
    failures.push("Si falla el guardado de un punto personalizado, debe restaurarse su ubicación anterior.");
  }
}

forbidMatch(/id=["']imp["']|id=["']impf["']/i,
  "La interfaz no debe ofrecer importación de copias JSON antiguas.");
forbidMatch(/\$\(["']#impf["']\)\.addEventListener\s*\(/,
  "No debe existir un manejador de importación JSON.");

const csvStart = html.indexOf('$("#csv").addEventListener("click", () => {');
const jsonStart = html.indexOf('$("#bak").addEventListener("click", () => {');
const restoreStart = html.indexOf("/* Restaurar puntos quitados */", jsonStart);
if (csvStart < 0 || jsonStart < 0 || restoreStart < 0) {
  failures.push("No se pudieron localizar los manejadores de exportación.");
} else {
  const csvExport = html.slice(csvStart, jsonStart);
  const jsonExport = html.slice(jsonStart, restoreStart);
  if (!/window\.confirm\s*\(/.test(csvExport)) {
    failures.push("La exportación CSV debe advertir y pedir confirmación.");
  }
  if (!/window\.confirm\s*\(/.test(jsonExport) ||
      !/NO es una copia completa de Supabase/.test(jsonExport)) {
    failures.push("La exportación JSON debe advertir que no es un backup completo y pedir confirmación.");
  }
  if (/ubicaciones\s*:/.test(jsonExport)) {
    failures.push("La exportación JSON no debe incluir sobrescrituras de ubicaciones del catálogo maestro.");
  }
}
if (failures.length) {
  console.error("AUDITORÍA DE PERSISTENCIA: ERROR");
  failures.forEach(message => console.error("- " + message));
  process.exitCode = 1;
} else {
  console.log("AUDITORÍA DE PERSISTENCIA: OK");
  console.log("- Sin escrituras detectadas en almacenamiento persistente del navegador.");
  console.log("- Se descartan ubicaciones personales heredadas.");
  console.log("- No hay importador de copias antiguas y ambas exportaciones requieren confirmación.");
}

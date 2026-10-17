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

const importStart = html.indexOf('$("#impf").addEventListener("change", async (e) => {');
const importEnd = html.indexOf("/* Restaurar puntos quitados */", importStart);
if (importStart < 0 || importEnd < 0) {
  failures.push("No se pudo localizar el flujo de importación de copias.");
} else {
  const importer = html.slice(importStart, importEnd);
  if (!/if\s*\(!await\s+savePermits\(\)\)/.test(importer)) {
    failures.push("La importación debe esperar el guardado de permisos compartidos.");
  }
  if (!/if\s*\(!await\s+persist\(key,\s*value\)\)/.test(importer)) {
    failures.push("La importación debe esperar cada guardado del estado personal.");
  }
  if (!/Copia importada y guardada en Supabase/.test(importer)) {
    failures.push("El mensaje de éxito debe confirmar guardado en Supabase.");
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
  console.log("- La importación espera confirmación de Supabase.");
}

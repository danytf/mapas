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

requireMatch(/const personalStateKey/,
  "Las referencias personales deben usar UUID para establecimientos maestros.");
requireMatch(/removed = normalizePersonalRefs/,
  "Las ocultaciones antiguas por nombre deben migrarse a claves estables al cargarse.");
requireMatch(/reviewed = normalizePersonalRefs/,
  "Las revisiones antiguas por nombre deben migrarse a claves estables al cargarse.");


requireMatch(/const safeCount =/,
  "Los contadores de captadores compartidos deben validarse como enteros antes de renderizar.");
requireMatch(/const fmtD =/,
  "El formateador de fechas debe rechazar datos no válidos antes de insertarlos en HTML.");
requireMatch(/n: safeCount/,
  "El calendario semanal debe sanitizar el número de captadores de concesiones compartidas.");
requireMatch(/n: safeCount/,
  "El calendario semanal debe sanitizar el número de captadores de solicitudes compartidas.");


forbidMatch(/key\.startsWith\(["']mapa-["']\)/,
  "La limpieza no debe borrar indiscriminadamente todas las claves mapa-* del mismo origen.");
forbidMatch(/\^sb-\.\+-auth-token\$/,
  "La limpieza no debe borrar tokens de otros proyectos Supabase.");
requireMatch(/key\s*===\s*["']sb-wwoczmihhupofwmlmgga-auth-token["']/,
  "La limpieza debe limitar el token de Supabase al proyecto de este mapa.");

const setLocStart = html.indexOf("async function setLoc(c, lat, lon, address)");
const personalLoadStart = html.indexOf("async function loadPersonalState()");
const customLoadStart = html.indexOf("customs = Array.isArray(state.customs)", personalLoadStart);
const removedLoadStart = html.indexOf("removed = normalizePersonalRefs", customLoadStart);
if (personalLoadStart < 0 || customLoadStart < 0 || removedLoadStart < 0) {
  failures.push("No se pudo localizar la validación de puntos personalizados restaurados.");
} else {
  const customLoad = html.slice(customLoadStart, removedLoadStart);
  if (!/Number\.isFinite\(lat\)/.test(customLoad) ||
      !/Number\.isFinite\(lon\)/.test(customLoad) ||
      !/lat < 36\.5 \|\| lat > 38\.3 \|\| lon < -4\.6 \|\| lon > -2\.2/.test(customLoad) ||
      !/customNames\.has\(name\)/.test(customLoad)) {
    failures.push("Los puntos personalizados recuperados deben tener coordenadas dentro del ámbito y nombres únicos.");
  }
}
const locationMasterStart = html.indexOf("const verifyController = new AbortController()", setLocStart);
const locationMasterEnd = html.indexOf("let moving = null;", setLocStart);
if (locationMasterStart < 0 || locationMasterEnd < 0) {
  failures.push("El guardado de ubicación maestra debe comprobar el resultado de una respuesta ambigua.");
} else {
  const locationWrite = html.slice(locationMasterStart, locationMasterEnd);
  if (!/location_source === "manual_google_maps"/.test(locationWrite) ||
      !/location_precision === "verified"/.test(locationWrite) ||
      !/persisted\.updated_by === window\.mapaSession\.user\.id/.test(locationWrite) ||
      !/persisted\.latitude\) === targetLat/.test(locationWrite) ||
      !/persisted\.longitude\) === targetLon/.test(locationWrite)) {
    failures.push("La lectura posterior debe confirmar dirección, coordenadas, precisión, origen y usuario antes de declarar éxito.");
  }
}
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

const personalWriteStart = html.indexOf("window.mapaPersistUserState =");
const personalWriteEnd = html.indexOf("async function loadPersonalState()", personalWriteStart);
if (personalWriteStart < 0 || personalWriteEnd < 0) {
  failures.push("No se pudo localizar la persistencia personal para auditar los fallos de escritura.");
} else {
  const personalWrite = html.slice(personalWriteStart, personalWriteEnd);
  if (!/let persistedPersonalState = \{\}/.test(html) ||
      !/const snapshot = JSON\.parse\(JSON\.stringify\(loadedPersonalState\)\)/.test(personalWrite) ||
      !/persistedPersonalState = snapshot/.test(personalWrite) ||
      !/personalStateVersions\.get\(key\) === version/.test(personalWrite) ||
      !/loadedPersonalState = rest/.test(personalWrite)) {
    failures.push("Si falla una escritura personal, debe revertirse la clave fallida sin sobrescribir ediciones posteriores ni encolar estado obsoleto.");
  }
}

const commitStart = html.indexOf("const commit = async () => {");
const commitEnd = html.indexOf('el.querySelectorAll(".stars button")', commitStart);
if (commitStart < 0 || commitEnd < 0) {
  failures.push("No se pudo localizar el guardado de permisos compartidos.");
} else {
  const permitCommit = html.slice(commitStart, commitEnd);
  if (!/if\s*\(!saved\)\s*\{/.test(permitCommit) ||
      !/permits\[c\.name\]\s*=\s*previous\.permit/.test(permitCommit) ||
      !/const rollbackSaved = await savePermits\(c\.name\)/.test(permitCommit) ||
      !/setCommitControlsDisabled\(true\)/.test(permitCommit) ||
      !/setCommitControlsDisabled\(false\)/.test(permitCommit) ||
      !/paint\(\); paintHist\(\); paintSols\(\); paintEf\(\);\s*setCommitControlsDisabled\(true\);\s*const rollbackSaved = await savePermits\(c\.name\)/.test(permitCommit) ||
      !/gamPermit\(c, previous\.permit\)/.test(permitCommit)) {
    failures.push("El guardado de permisos debe bloquear ediciones concurrentes, revertir el estado ante fallo y otorgar progreso solo tras guardar.");
  }
}
forbidMatch(/\$\(["']#impf["']\)\.addEventListener\s*\(/,
  "No debe existir un manejador de importación JSON.");

const copyStart = html.indexOf('$("#copy").addEventListener("click", async () => {');
const csvStart = html.indexOf('$("#csv").addEventListener("click", () => {');
const jsonStart = html.indexOf('$("#bak").addEventListener("click", () => {');
const restoreStart = html.indexOf("/* Restaurar puntos quitados */", jsonStart);
if (copyStart < 0 || csvStart < 0 || jsonStart < 0 || restoreStart < 0) {
  failures.push("No se pudieron localizar los manejadores de exportación.");
} else {
  const copyExport = html.slice(copyStart, csvStart);
  const csvExport = html.slice(csvStart, jsonStart);
  const jsonExport = html.slice(jsonStart, restoreStart);
  if (!/window\.confirm\s*\(/.test(copyExport)) {
    failures.push("La copia de coordenadas al portapapeles debe pedir confirmación.");
  }
  if (!/window\.confirm\s*\(/.test(csvExport)) {
    failures.push("La exportación CSV debe advertir y pedir confirmación.");
  }
  if (!html.includes("const csvCell = (value) =>") ||
      !csvExport.includes(".map(csvCell).join(\";\"") ) {
    failures.push("La exportación CSV debe serializar cada celda con protección frente a fórmulas.");
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

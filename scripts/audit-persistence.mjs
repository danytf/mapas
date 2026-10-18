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
const locationResponseStart = html.indexOf("const responseConfirmed =", setLocStart);
const locationResponseEnd = html.indexOf("if (!responseConfirmed)", locationResponseStart);
if (locationResponseStart < 0 || locationResponseEnd < 0) {
  failures.push("La respuesta normal del guardado de ubicación debe verificarse antes de declarar éxito.");
} else {
  const locationResponse = html.slice(locationResponseStart, locationResponseEnd);
  if (!/data\.id === c\.databaseId/.test(locationResponse) ||
      !/String\(data\.address \|\| ""\)\.trim\(\) === cleanAddress/.test(locationResponse) ||
      !/Number\(data\.latitude\) === targetLat/.test(locationResponse) ||
      !/Number\(data\.longitude\) === targetLon/.test(locationResponse) ||
      !/data\.location_precision === "verified"/.test(locationResponse) ||
      !/data\.location_source === "manual_google_maps"/.test(locationResponse) ||
      !/data\.updated_by === window\.mapaSession\.user\.id/.test(locationResponse)) {
    failures.push("La respuesta normal debe confirmar ID, dirección, coordenadas, precisión, origen y usuario antes de declarar éxito.");
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

const permitWriteStart = html.indexOf("const saveSharedPermitRow = async");
const permitWriteEnd = html.indexOf("let removed = new Set()", permitWriteStart);
if (permitWriteStart < 0 || permitWriteEnd < 0) {
  failures.push("No se pudo localizar la comprobación posterior de escrituras compartidas.");
} else {
  const permitWrite = html.slice(permitWriteStart, permitWriteEnd);
  if (!/\.eq\("establishment_id", row\.establishment_id\)/.test(permitWrite) ||
      !/persisted\.updated_by === userId/.test(permitWrite) ||
      !/persisted\.province_id === row\.province_id/.test(permitWrite) ||
      !/setTimeout\(\(\) => controller\.abort\(\), 15000\)/.test(permitWrite) ||
      !/setTimeout\(\(\) => verifyController\.abort\(\), 8000\)/.test(permitWrite)) {
    failures.push("Un timeout de permisos debe comprobar estado, provincia y usuario persistidos antes de revertir la edición.");
  }
  // H-11: el estado compartido se guarda condicionado a la versión leída; nunca con upsert ciego.
  if (!/\.update\(\{ state: row\.state, updated_by: userId \}\)\s*\.eq\("establishment_id", row\.establishment_id\)\.eq\("version", expected\)/.test(permitWrite) ||
      !/\.from\("establishment_app_state"\)\.insert\(row\)/.test(permitWrite) ||
      !/writeError\?\.code === "23505"\) return "conflict"/.test(permitWrite) ||
      !/if \(persistedVersion !== expected\) return "conflict"/.test(permitWrite) ||
      /establishment_app_state"\)\.upsert\(/.test(permitWrite)) {
    failures.push("El estado compartido debe guardarse con control de versión (UPDATE condicionado o INSERT) y detectar conflictos (H-11).");
  }
}
if (/from\("establishment_app_state"\)\s*\.upsert\(/.test(html)) {
  failures.push("No debe haber upsert ciego sobre establishment_app_state (H-11).");
}
// H-14: el estado de permisos se indexa por una clave estable (ID de Supabase), nunca por el nombre.
if (/permits\[c\.name\]|permits\[name\]|item\.name === name && item\.databaseId/.test(html) ||
    !/const permitKey = \(c\) => c\.databaseId \? "id:" \+ c\.databaseId : "custom:" \+ c\.name;/.test(html)) {
  failures.push("El estado de permisos debe indexarse por permitKey (ID de Supabase), no por el nombre del punto (H-14).");
}
// H-13: los permisos de un punto personal se guardan en el estado personal; nunca se da por bueno sin escribir.
const savePermitsStart = html.indexOf("const savePermits = async (c) =>");
const savePermitsBody = savePermitsStart >= 0 ? html.slice(savePermitsStart, html.indexOf("const reloadSharedPermit", savePermitsStart)) : "";
if (!savePermitsBody ||
    !/if \(!c\.databaseId\) \{\s*const result = c\.custom \? await saveCustomPermits\(\) : "error";/.test(savePermitsBody) ||
    /return "ok";/.test(savePermitsBody) ||
    !/window\.mapaPersistUserState\("customPermits", customPermitsSnapshot\(\)\)/.test(html) ||
    !/state\.customPermits/.test(html)) {
  failures.push("Los permisos de los puntos personales deben guardarse y cargarse desde user_app_state (customPermits) sin dar por bueno un guardado no realizado (H-13).");
}
const personalTimeoutStart = html.indexOf("window.mapaPersistUserState =");
const personalTimeoutEnd = html.indexOf("async function loadPersonalState()", personalTimeoutStart);
const locationApplyStart = html.indexOf("const apply = async (txt) =>");
const locationApplyEnd = html.indexOf('inp.addEventListener("paste"', locationApplyStart);
if (personalTimeoutStart < 0 || personalTimeoutEnd < 0 || locationApplyStart < 0 || locationApplyEnd < 0) {
  failures.push("No se pudieron localizar los límites de tiempo de las escrituras.");
} else {
  const personalTimeout = html.slice(personalTimeoutStart, personalTimeoutEnd);
  const locationApply = html.slice(locationApplyStart, locationApplyEnd);
  const permitSave = html.slice(html.indexOf("const saveSharedPermitRow ="), html.indexOf("let removed = new Set()"));
  if (!/setTimeout\(\(\) => controller\.abort\(\), 12000\)/.test(personalTimeout) ||
      !/abortSignal\(controller\.signal\)/.test(personalTimeout) ||
      !/setTimeout\(\(\) => controller\.abort\(\), 15000\)/.test(permitSave) ||
      !/setTimeout\(\(\) => resolve\(false\), 27000\)/.test(locationApply)) {
    failures.push("Las escrituras deben tener un timeout real y la UI de ubicación debe esperar a que termine su verificación.");
  }
}
const commitStart = html.indexOf("const commit = async () => {");
const commitEnd = html.indexOf('el.querySelectorAll(".stars button")', commitStart);
if (commitStart < 0 || commitEnd < 0) {
  failures.push("No se pudo localizar el guardado de permisos compartidos.");
} else {
  const permitCommit = html.slice(commitStart, commitEnd);
  // H-11: ante un conflicto no se reescribe nada (ni la restauración), solo se ofrece recargar.
  const conflictStart = permitCommit.indexOf('if (saved === "conflict") {');
  const errorStart = permitCommit.indexOf('if (saved !== "ok") {');
  const conflictBranch = conflictStart >= 0 && errorStart > conflictStart ? permitCommit.slice(conflictStart, errorStart) : "";
  if (!conflictBranch || /savePermits\(/.test(conflictBranch) || !/reloadSharedPermit\(c\)/.test(conflictBranch)) {
    failures.push("Un conflicto al guardar permisos no debe reescribir el estado y debe ofrecer cargar la versión actual (H-11).");
  }
  if (!/if\s*\(saved !== "ok"\)\s*\{/.test(permitCommit) ||
      !/permits\[permitKey\(c\)\]\s*=\s*previous\.permit/.test(permitCommit) ||
      !/const rollbackSaved = await savePermits\(c\)/.test(permitCommit) ||
      !/setCommitControlsDisabled\(true\)/.test(permitCommit) ||
      !/setCommitControlsDisabled\(false\)/.test(permitCommit) ||
      !/paint\(\); paintHist\(\); paintSols\(\); paintEf\(\);\s*setCommitControlsDisabled\(true\);\s*const rollbackSaved = await savePermits\(c\)/.test(permitCommit) ||
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

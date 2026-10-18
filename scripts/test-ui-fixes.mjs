// Regresión de los arreglos de interfaz H-15 a H-19: mensajes de error en español (H-16) y comprobaciones
// estáticas de que siguen presentes el bloqueo del botón de ubicación (H-15), el mensaje de lista vacía y las
// etiquetas de valoración (H-17), el teclado del menú y el foco al cerrar diálogos (H-18) y la escritura
// única del estado personal (H-19). El comportamiento real se comprueba en el navegador con
// scripts/dev/mock-supabase.mjs (ver docs/AUDITORIA_FASE_D_2026-10-18.md).
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { runInNewContext } from "node:vm";

const html = readFileSync(process.argv[2] || "index.html", "utf8");
const a = html.indexOf("function friendlyError(e, fallback) {");
const b = html.indexOf("// Municipio mostrado de un punto:", a);
assert.ok(a >= 0 && b > a, "No se encuentra friendlyError en index.html");
const { friendlyError } = runInNewContext(html.slice(a, b) + "\n({ friendlyError })");

// --- H-16: ningún texto técnico llega al usuario --------------------------------------------------------------
const casos = [
  [{ name: "AbortError", message: "The operation was aborted." }, "La operación no respondió a tiempo."],
  [{ message: "AbortError: The operation was aborted." }, "La operación no respondió a tiempo."],
  [{ name: "TypeError", message: "Failed to fetch" }, "No hay conexión. Revisa tu conexión a internet."],
  [{ message: "Failed to fetch" }, "No hay conexión. Revisa tu conexión a internet."],
  [{ message: "Load failed" }, "No hay conexión. Revisa tu conexión a internet."],
  [{ message: "NetworkError when attempting to fetch resource." }, "No hay conexión. Revisa tu conexión a internet."],
  [{ code: "PGRST301", message: "JWT expired" }, "La sesión ha caducado. Vuelve a iniciar sesión."],
  [{ status: 401, message: "x" }, "La sesión ha caducado. Vuelve a iniciar sesión."],
  [{ message: "Invalid Refresh Token: Refresh Token Not Found" }, "La sesión ha caducado. Vuelve a iniciar sesión."],
  [{ code: "42501", message: "new row violates row-level security policy for table" }, "No tienes permiso para esta operación."],
  [{ message: "permission denied for table establishments" }, "No tienes permiso para esta operación."]
];
for (const [error, esperado] of casos) assert.equal(friendlyError(error), esperado, "Mensaje para " + JSON.stringify(error));
// Error de servidor con código técnico: texto genérico (o el que se indique), sin filtrar el detalle.
assert.equal(friendlyError({ code: "XX000", message: "error interno de Postgres" }), "El servidor devolvió un error. Inténtalo de nuevo; si se repite, avisa al administrador.");
assert.equal(friendlyError({ code: "XX000", message: "boom" }, "Error de lectura del catálogo."), "Error de lectura del catálogo.");
// Los errores propios de la app, ya en español, pasan tal cual.
assert.equal(friendlyError(new Error("Tu usuario no tiene provincias activas asignadas.")), "Tu usuario no tiene provincias activas asignadas.");
assert.equal(friendlyError("texto"), "texto");
assert.equal(friendlyError(null, "Plan B"), "Plan B");
assert.equal(friendlyError(undefined), "Error inesperado.");
for (const [error] of casos) assert.ok(!/AbortError|Failed to fetch|JWT|Load failed|row-level|permission denied/i.test(friendlyError(error)), "Se filtra texto técnico");

// --- Que no vuelvan los mensajes técnicos ni el texto equivocado -----------------------------------------------
const prohibidos = [
  [/catalogueError = error\.message/, "mensaje técnico del catálogo mostrado tal cual"],
  [/err\.textContent = error\.message/, "mensaje técnico de acceso mostrado tal cual"],
  [/"HTTP " \+ r\.status/, "«HTTP nnn» mostrado al usuario"],
  [/17 segundos/, "texto de 17 segundos (la espera real es de 27)"],
  [/\(5\)<\/option>/, "etiqueta de valoración que parece un recuento"],
  [/OpenStreetMap \(" \+ e\.message/, "mensaje técnico de Nominatim mostrado tal cual"]
];
for (const [re, que] of prohibidos) assert.ok(!re.test(html), "Vuelve a aparecer: " + que);

// --- Presencia de los arreglos ----------------------------------------------------------------------------------
const requeridos = [
  ["let savingLocation = false;", "H-15: bloqueo de «Guardar dirección y ubicación» mientras guarda"],
  ["if (savingLocation) return;", "H-15: segunda pulsación ignorada"],
  ["saveLocBtn.disabled = true;", "H-15: botón deshabilitado mientras guarda"],
  ["Ningún punto coincide con la búsqueda y los filtros.", "H-17: mensaje de lista vacía"],
  ["5 estrellas</option>", "H-17: etiqueta de valoración clara"],
  ['e.key === "ArrowDown"', "H-18: flechas en el menú"],
  ['e.key === "Home"', "H-18: Inicio en el menú"],
  ['document.querySelectorAll("dialog").forEach((d) => d.addEventListener("close"', "H-18: foco al cerrar diálogos"],
  ["if (stableJson(snapshot) === stableJson(persistedPersonalState)) return true;", "H-19: no se repite una escritura que no cambia nada"]
];
for (const [texto, que] of requeridos) assert.ok(html.includes(texto), "Falta: " + que);

console.log("test-ui-fixes: OK (mensajes en español sin texto técnico y arreglos H-15 a H-19 presentes)");

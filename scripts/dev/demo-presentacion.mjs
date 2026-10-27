// Demostración local de la aplicación con datos sintéticos (para presentaciones). No toca ninguna base real.
// Levanta el Supabase simulado con unos 3.000 puntos repartidos por los núcleos de Andalucía, carga un juego de solicitudes, concesiones y
// seguimientos que enseña todas las opciones (Mi jornada, Centro, Panel, Calendario, avisos de datos, lotes) y sirve la copia en http://127.0.0.1:8765.
// Uso: node scripts/dev/demo-presentacion.mjs        (Ctrl+C para pararla; al volver a lanzarla, los datos empiezan de cero)
// Usuarios (contraseña «x»): admin@test.es (administrador, todo), multi@test.es (Granada y Almería), alm@test.es (Almería).
// Los nombres de los puntos, las fechas y las cifras son inventados y relativos a hoy (fecha de Madrid): no son establecimientos ni permisos reales.
import { spawn } from "node:child_process";
import { randomUUID } from "node:crypto";
import { mkdtempSync, readFileSync, rmSync } from "node:fs";
import { createServer } from "node:http";
import { tmpdir } from "node:os";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const RAIZ = join(dirname(fileURLToPath(import.meta.url)), "..", ".."), MOCK = "http://127.0.0.1:8766", PUERTO_WEB = 8765;
const ID = (n) => "00000000-0000-4000-8000-" + String(n).padStart(12, "0");
const USUARIOS = { multi: ID(1), alm: ID(2), admin: ID(4) };
const ONGS = ["AECC", "Cruz Roja", "WWF", "Aldeas Infantiles", "FJC", "FPM", "FEC"];
const espera = (ms) => new Promise((r) => setTimeout(r, ms));
const hasta = async (cond, ms = 15000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { try { if (await cond()) return; } catch { /* aún no */ } await espera(200); } throw new Error("Tiempo agotado"); };

/* Fechas relativas a hoy en Madrid (la misma referencia que la aplicación) */
const hoy = new Intl.DateTimeFormat("en-CA", { timeZone: "Europe/Madrid", year: "numeric", month: "2-digit", day: "2-digit" }).format(new Date());
const d = (k) => { const t = new Date(hoy + "T00:00:00Z"); t.setUTCDate(t.getUTCDate() + k); return t.toISOString().slice(0, 10); };
const ts = (k) => d(k) + "T10:00:00Z";

const procesos = [];
const tmp = mkdtempSync(join(tmpdir(), "demo-mapas-"));
let servidor;
const cierra = () => { servidor?.close(); procesos.forEach((p) => { try { p.kill(); } catch { /* ya cerrado */ } }); try { rmSync(tmp, { recursive: true, force: true }); } catch { /* en uso */ } };
process.on("SIGINT", () => { console.log("\nDemostración parada."); cierra(); process.exit(0); });

const main = async () => {
  /* 1. Supabase simulado con puntos de presentación */
  const libre = await fetch(MOCK + "/__rel").then(() => false).catch(() => true);
  if (!libre) throw new Error("El puerto 8766 ya está en uso (¿otro simulador o el E2E?). Ciérralo y vuelve a lanzar la demo.");
  procesos.push(spawn(process.execPath, [join(RAIZ, "scripts/dev/mock-supabase.mjs")], { stdio: "ignore" }));
  await hasta(async () => (await fetch(MOCK + "/__rel")).ok);
  const r0 = await (await fetch(MOCK + "/__reset?realista=1&n=3000&demo=1")).json();
  const { establishments } = await (await fetch(MOCK + "/__state")).json();

  /* 2. Sesión de administrador del simulado para dar de alta los expedientes */
  const ses = await (await fetch(MOCK + "/auth/v1/token?grant_type=password", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ email: "admin@test.es", password: "x" }) })).json();
  const H = { "Content-Type": "application/json", Authorization: "Bearer " + ses.access_token, apikey: "x" };
  /* El identificador se pone aquí para poder enlazar la concesión o el seguimiento con su solicitud */
  const alta = async (tabla, fila) => { fila.id = randomUUID(); const r = await fetch(MOCK + "/rest/v1/" + tabla, { method: "POST", headers: H, body: JSON.stringify(fila) }); if (r.status !== 201) throw new Error("No se pudo crear en " + tabla + ": " + r.status); return fila; };

  /* Puntos elegidos: muchos en Granada y Almería (los ve también el usuario de provincia) y el resto repartido */
  const provDe = (e) => e.provinces?.name || "";
  const gra = establishments.filter((e) => provDe(e) === "Granada"), alm = establishments.filter((e) => provDe(e) === "Almería"), resto = establishments.filter((e) => !["Granada", "Almería"].includes(provDe(e)));
  const toma = (arr, n) => arr.filter((_, i) => i % Math.max(1, Math.floor(arr.length / n)) === 0).slice(0, n);
  const puntos = [...toma(gra, 30), ...toma(alm, 30), ...toma(resto, 60)];
  const respDe = (e, i) => provDe(e) === "Almería" ? [USUARIOS.alm, USUARIOS.multi, USUARIOS.admin, null][i % 4] : provDe(e) === "Granada" ? [USUARIOS.multi, USUARIOS.admin, null][i % 3] : [USUARIOS.admin, null][i % 2];
  const n = { solicitudes: 0, concesiones: 0, seguimientos: 0 };
  const sol = async (e, o) => { n.solicitudes++; return alta("permit_applications", Object.assign({ establishment_id: e.id, organization: "AECC", capturer_count: 2, requested_from: d(10), requested_until: d(14), requested_at: d(-3), status: "pending" }, o)); };
  const con = async (e, o) => { n.concesiones++; return alta("permit_grants", Object.assign({ establishment_id: e.id, organization: "AECC", capturer_count: 2, valid_from: d(-10), valid_until: d(40), status: "active" }, o)); };
  const seg = async (e, o) => { n.seguimientos++; return alta("followups", Object.assign({ establishment_id: e.id, created_by: USUARIOS.admin }, o)); };

  /* 3. Un caso de cada tipo, repetido por los puntos con variaciones (ONG, captadores, fechas y responsables) */
  const CASOS = [
    async (e, i) => { const a = await sol(e, { organization: ONGS[i % 7], capturer_count: 2 + (i % 3), requested_at: d(-6 - (i % 5)), requested_from: d(8 + (i % 6)), requested_until: d(12 + (i % 6)), sent_on: d(-5 - (i % 5)) }); await seg(e, { application_id: a.id, due_on: d(-1 - (i % 8)), next_action: "Llamar al responsable del centro para confirmar", assigned_to: respDe(e, i) }); },
    async (e, i) => { const a = await sol(e, { organization: ONGS[(i + 1) % 7], requested_at: d(-4), requested_from: d(6), requested_until: d(9), sent_on: d(-3) }); await seg(e, { application_id: a.id, due_on: d(0), next_action: "Confirmar las fechas por correo", assigned_to: respDe(e, i + 1) }); },
    async (e, i) => { const a = await sol(e, { organization: ONGS[(i + 2) % 7], capturer_count: 3, requested_at: d(-2), requested_from: d(15), requested_until: d(19), sent_on: d(-1) }); await seg(e, { application_id: a.id, due_on: d(3 + (i % 6)), next_action: "Enviar la documentación de la ONG", assigned_to: respDe(e, i) }); },
    async (e, i) => { await sol(e, { organization: ONGS[(i + 3) % 7], capturer_count: 2, requested_at: d(-2 - (i % 9)), requested_from: d(20), requested_until: d(24) }); },
    async (e, i) => { const a = await sol(e, { organization: ONGS[(i + 4) % 7], capturer_count: 4, requested_at: d(-18 - (i % 25)), requested_from: d(25), requested_until: d(30), sent_on: d(-17 - (i % 25)) }); await seg(e, { application_id: a.id, due_on: d(4), next_action: "Reclamar respuesta al centro", assigned_to: respDe(e, i) }); },
    async (e, i) => { await sol(e, { organization: ONGS[(i + 5) % 7], capturer_count: 3, requested_at: d(-5), requested_from: d(1 + (i % 5)), requested_until: d(6 + (i % 5)) }); },
    async (e, i) => { const a = await sol(e, { organization: ONGS[(i + 6) % 7], capturer_count: 2, requested_at: d(-9), requested_from: d(-2), requested_until: d(5), sent_on: d(-8) }); await seg(e, { application_id: a.id, due_on: d(-2), next_action: "El periodo ya empezó: pedir respuesta hoy", assigned_to: respDe(e, i) }); },
    async (e, i) => { await sol(e, { organization: ONGS[i % 7], requested_at: d(-30), requested_from: d(-12), requested_until: d(-4) }); },
    async (e, i) => { const a = await sol(e, { organization: ONGS[(i + 1) % 7], capturer_count: 3, requested_at: d(-35 + (i % 20)), requested_from: d(-5), requested_until: d(30 + (i % 30)), status: "approved", resolved_at: ts(-30 + (i % 20) + 3 + (i % 6)) }); await con(e, { application_id: a.id, organization: ONGS[(i + 1) % 7], capturer_count: 3, valid_from: d(-5), valid_until: d(30 + (i % 30)) }); },
    async (e, i) => { await sol(e, { organization: ONGS[(i + 2) % 7], requested_at: d(-40 + (i % 30)), status: "denied", resolved_at: ts(-36 + (i % 30)), resolution_reason: ["Sin cupo esa semana", "El centro no admite captación en esas fechas", "Coincide con otra campaña"][i % 3] }); },
    async (e, i) => { await sol(e, { organization: ONGS[(i + 3) % 7], requested_at: d(-25 + (i % 10)), status: "withdrawn", resolved_at: ts(-20 + (i % 10)), resolution_reason: "La ONG cambia de zona" }); },
    async (e, i) => { await con(e, { organization: ONGS[(i + 4) % 7], capturer_count: 4, valid_from: d(-20), valid_until: d(0) }); },
    async (e, i) => { const g = await con(e, { organization: ONGS[(i + 5) % 7], capturer_count: 2 + (i % 4), valid_from: d(-15), valid_until: d(2 + (i % 5)) }); await seg(e, { grant_id: g.id, due_on: d(i % 2 ? 0 : -1), next_action: "Pedir la renovación antes de que termine", assigned_to: respDe(e, i) }); },
    async (e, i) => { await con(e, { organization: ONGS[(i + 6) % 7], capturer_count: 3, valid_from: d(4 + (i % 10)), valid_until: d(18 + (i % 10)) }); },
    async (e, i) => { await con(e, { organization: ONGS[i % 7], capturer_count: 2, valid_from: d(-45), valid_until: d(-8) }); },
    async (e, i) => { await con(e, { organization: ONGS[(i + 1) % 7], capturer_count: 3, valid_from: d(-10), valid_until: d(25), status: "cancelled", cancelled_at: ts(-2), cancelled_reason: "Obras en la entrada del centro" }); },
    async (e, i) => { await con(e, { organization: ONGS[(i + 2) % 7], capturer_count: 2, valid_from: d(-3), valid_until: null }); },
    async (e, i) => { const a = await sol(e, { organization: "", capturer_count: 0, requested_at: d(-3), requested_from: d(12), requested_until: d(15) }); await seg(e, { application_id: a.id, due_on: d(6), next_action: "Completar ONG y captadores", assigned_to: respDe(e, i) }); },
    async (e, i) => { await seg(e, { due_on: d(-3 + (i % 4)), next_action: "Visitar el centro para presentar la campaña", assigned_to: respDe(e, i) }); },
    async (e, i) => { for (const k of [0, 1]) await sol(e, { organization: "Cruz Roja", capturer_count: 2, requested_at: d(-4 + k), requested_from: d(9), requested_until: d(11) }); },
    async (e, i) => { await con(e, { organization: "WWF", capturer_count: 2, valid_from: d(-5), valid_until: d(20) }); await con(e, { organization: "WWF", capturer_count: 3, valid_from: d(10), valid_until: d(35) }); },
    async (e, i) => { await con(e, { organization: ONGS[(i + 3) % 7], capturer_count: 5, valid_from: d(-2), valid_until: d(12) }); await sol(e, { organization: ONGS[(i + 4) % 7], capturer_count: 3, requested_at: d(-1), requested_from: d(1), requested_until: d(10) }); }
  ];
  for (let i = 0; i < puntos.length; i++) await CASOS[i % CASOS.length](puntos[i], i);

  /* 4. Copia de la aplicación apuntando al simulado, servida en local */
  const salida = join(tmp, "index.html");
  await new Promise((res, rej) => spawn(process.execPath, [join(RAIZ, "scripts/dev/build-mock-site.mjs"), join(RAIZ, "index.html"), salida], { stdio: "ignore" }).on("exit", (c) => c === 0 ? res() : rej(new Error("build-mock-site falló"))));
  const html = readFileSync(salida);
  servidor = createServer((req, res) => { res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" }); res.end(html); }).listen(PUERTO_WEB, "127.0.0.1");

  console.log("Demostración lista: " + r0.puntos + " puntos sintéticos, " + n.solicitudes + " solicitudes, " + n.concesiones + " concesiones y " + n.seguimientos + " seguimientos (fechas relativas a hoy, " + hoy + ").");
  console.log("Abre http://127.0.0.1:" + PUERTO_WEB + "/ y entra con admin@test.es (contraseña x). También: multi@test.es (Granada y Almería) y alm@test.es (Almería).");
  console.log("La sesión no se guarda: al recargar hay que volver a entrar. Los cambios que hagas duran mientras la demo siga abierta. Ctrl+C para pararla.");
};
main().catch((e) => { console.error("FALLO: " + e.message); cierra(); process.exit(1); });

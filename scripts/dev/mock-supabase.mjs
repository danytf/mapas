// Supabase simulado para probar la interfaz sin tocar ningún proyecto real (H-20 y H-21).
// Imita lo mínimo de GoTrue y PostgREST que usa la app, con datos sintéticos de varias provincias, y un
// Nominatim simulado que registra las peticiones. Puerto 8766, estado en memoria. Uso: node scripts/dev/mock-supabase.mjs
// Usuarios (contraseña «x»): multi@test.es (Granada y Almería), alm@test.es (Almería), vacio@test.es (Jaén, sin puntos), admin@test.es.
// Utilidades: GET /__log (peticiones registradas), GET /__state (estado), GET /__reset (opcional ?n=<puntos>&estados=1&realista=1),
// GET /__fail?n=<veces>&modo=500|perdida (las próximas escrituras del estado compartido fallan con un 500, o se aplican y se corta la respuesta).
import { createServer } from "node:http";

const PORT = Number(process.env.MOCK_PORT || 8766); /* MOCK_PORT: otro puerto, p. ej. para medir sin chocar con la prueba E2E */
let FALLO = { n: 0, modo: "500" };
const id = (n) => "00000000-0000-4000-8000-" + String(n).padStart(12, "0");
const b64 = (o) => Buffer.from(JSON.stringify(o)).toString("base64url");

// Prueba de volumen: MOCK_POINTS=<n> (o GET /__reset?n=<n>) genera n puntos sintéticos y reproducibles repartidos por
// las 52 provincias, en lugar de los 7 de ejemplo. Granada (18) y Almería (04) conservan su nombre.
const NOMBRES = { "18": "Granada", "04": "Almería", "23": "Jaén" };
const provinces = Array.from({ length: 52 }, (_, i) => {
  const code = String(i + 1).padStart(2, "0");
  return { id: id(900 + i + 1), code, name: NOMBRES[code] || "Provincia " + code, is_active: true };
});
const P = (code) => provinces.find((p) => p.code === code);
const users = {
  "multi@test.es": { id: id(1), role: "user", provinces: ["18", "04"] },
  "alm@test.es": { id: id(2), role: "user", provinces: ["04"] },
  "vacio@test.es": { id: id(3), role: "user", provinces: ["23"] },
  "admin@test.es": { id: id(4), role: "admin", provinces: [] }
};
const seedPoints = [
  ["Hospital", "Hospital Granada Centro", "18", "Granada", "Calle Ficticia 1", 37.1773, -3.5986],
  ["Centro de salud", "CS Armilla", "18", "Armilla", "Calle Ficticia 2", 37.1420, -3.6200],
  ["Supermercado", "Super Motril", "18", "Motril", "Calle Ficticia 3", 36.7440, -3.5150],
  ["Hospital", "Hospital Almería Centro", "04", "Almería", "Calle Ficticia 10", 36.8400, -2.4600],
  ["Supermercado", "Super Roquetas", "04", "Roquetas de Mar", "Calle Ficticia 11", 36.7620, -2.6150],
  ["Centro comercial", "CC Vera", "04", "Vera", "Calle Ficticia 12", 37.2500, -1.8600],
  ["Tiendas", "Tienda El Ejido", "04", "El Ejido", "Calle Ficticia 13", 36.7760, -2.8140]
];
const CATEGORIAS = ["Hospital", "Centro de salud", "Supermercado", "Centro comercial", "Entidad oficial", "Gimnasios", "Correos", "Bricolaje", "Estaciones", "Tiendas"];
// Modo realista (MOCK_REALISTA=1 o GET /__reset?realista=1&n=<puntos>): n puntos sintéticos agrupados alrededor de los núcleos urbanos
// de Andalucía (centros aproximados de las capitales y de las ciudades grandes), para juzgar densidad, agrupaciones y rendimiento del mapa.
// Son datos de prueba locales: no son establecimientos reales ni salen de este ordenador.
const NUCLEOS = [
  ["Sevilla", "41", 37.389, -5.984, 10], ["Málaga", "29", 36.721, -4.421, 9], ["Granada", "18", 37.177, -3.599, 7], ["Córdoba", "14", 37.888, -4.779, 6],
  ["Almería", "04", 36.834, -2.464, 5], ["Cádiz", "11", 36.527, -6.289, 4], ["Jerez de la Frontera", "11", 36.686, -6.137, 4], ["Huelva", "21", 37.261, -6.945, 4],
  ["Jaén", "23", 37.779, -3.785, 3], ["Marbella", "29", 36.510, -4.886, 3], ["Algeciras", "11", 36.133, -5.455, 3], ["Dos Hermanas", "41", 37.283, -5.921, 2],
  ["Roquetas de Mar", "04", 36.764, -2.615, 2], ["El Ejido", "04", 36.776, -2.814, 2], ["Motril", "18", 36.745, -3.518, 2], ["Linares", "23", 38.095, -3.634, 2],
  ["Estepona", "29", 36.427, -5.146, 2], ["Vélez-Málaga", "29", 36.779, -4.100, 2], ["Écija", "41", 37.542, -4.728, 1], ["Lucena", "14", 37.409, -4.485, 1]
];
function generadosRealistas(n) {
  let semilla = 777;
  const azar = () => { semilla = (semilla * 1103515245 + 12345) % 2147483648; return semilla / 2147483648; };
  const normal = () => { let t = 0; for (let k = 0; k < 6; k++) t += azar(); return (t - 3) / Math.sqrt(0.5); };
  const peso = NUCLEOS.reduce((a, x) => a + x[4], 0);
  return Array.from({ length: n }, (_, i) => {
    let r = azar() * peso, nu = NUCLEOS[0];
    for (const x of NUCLEOS) { r -= x[4]; if (r <= 0) { nu = x; break; } }
    const p = P(nu[1]), sd = 0.02 + nu[4] * 0.0035;
    return {
      id: id(200000 + i), province_id: p.id, name: "Punto de prueba " + (i + 1) + " – " + nu[0], address: "Calle Ficticia " + (i % 300) + ", " + nu[0],
      latitude: +(nu[2] + normal() * sd).toFixed(6), longitude: +(nu[3] + normal() * sd * 1.25).toFixed(6),
      location_precision: i % 9 === 0 ? "approximate" : "address", source_ref: "real-" + i, status: "active", subtype: null,
      categories: { name: CATEGORIAS[Math.floor(azar() * CATEGORIAS.length)] }, municipalities: { name: nu[0] }, provinces: { name: p.name, code: p.code }
    };
  });
}
function generados(n) {
  let semilla = 12345;
  const azar = () => { semilla = (semilla * 1103515245 + 12345) % 2147483648; return semilla / 2147483648; };
  return Array.from({ length: n }, (_, i) => {
    const p = provinces[i % provinces.length];
    return {
      id: id(100000 + i), province_id: p.id, name: "Punto sintético " + (i + 1), address: "Calle Ficticia " + (i % 300) + ", Municipio " + p.code + "-" + (i % 40),
      latitude: +(36.0 + azar() * 7.5).toFixed(6), longitude: +(-9.0 + azar() * 12.5).toFixed(6),
      location_precision: i % 7 === 0 ? "approximate" : "address", source_ref: "vol-" + i, status: "active", subtype: null,
      categories: { name: CATEGORIAS[i % CATEGORIAS.length] }, municipalities: { name: "Municipio " + p.code + "-" + (i % 40) }, provinces: { name: p.name, code: p.code }
    };
  });
}
// Estados de permisos sintéticos (GET /__reset?estados=1 o MOCK_STATES=1): uno de cada diez puntos tiene estado:
// con seguimiento atrasado, con concesión que caduca en 10 días o con concesión vigente a 90 días.
const dia = (d) => new Date(Date.now() + d * 864e5).toISOString().slice(0, 10);
function estadosDe(establishments) {
  const filas = [];
  establishments.forEach((e, i) => {
    if (i % 10 !== 0) return;
    const patron = (i / 10) % 3;
    const state = patron === 0
      ? { estado: "solicitado", fecha: dia(-1), solicitudes: [{ desde: dia(5), hasta: dia(15), fecha: dia(-1), captadores: 2, ong: "ONG Mock", seg: dia(-1) }] }
      : { estado: "concedido", fecha: dia(-20), historial: [{ desde: dia(-5), hasta: dia(patron === 1 ? 10 : 90), captadores: 3, ong: "ONG Mock" }] };
    filas.push({ establishment_id: e.id, province_id: e.province_id, state, version: 1 });
  });
  return filas;
}
const freshState = (n = Number(process.env.MOCK_POINTS || 0), conEstados = process.env.MOCK_STATES === "1", realista = process.env.MOCK_REALISTA === "1") => ({
  conEstados,
  establishments: realista && n > 0 ? generadosRealistas(n) : n > 0 ? generados(n) : seedPoints.map(([cat, name, code, muni, addr, lat, lon], i) => ({
    id: id(100 + i), province_id: P(code).id, name, address: addr, latitude: lat, longitude: lon,
    location_precision: "address", source_ref: "mock-" + i, status: "active", subtype: null,
    categories: { name: cat }, municipalities: { name: muni }, provinces: { name: P(code).name, code }
  })),
  userState: {},
  shared: {},
  rel: { permit_applications: [], permit_grants: [], followups: [] },
  log: []
});
let S = freshState();
// Administración simulada: usuarios con rol, estado, nombre y provincias editables (el usuario "baja@test.es" no inicia sesión).
const admInicial = () => ({
  [id(1)]: { email: "multi@test.es", role: "user", is_active: true, display_name: null, provs: ["18", "04"], last: "2026-10-18T09:00:00Z" },
  [id(2)]: { email: "alm@test.es", role: "user", is_active: true, display_name: "Almería <b>1</b>", provs: ["04"], last: null },
  [id(3)]: { email: "vacio@test.es", role: "user", is_active: true, display_name: null, provs: ["23"], last: null },
  [id(4)]: { email: "admin@test.es", role: "admin", is_active: true, display_name: null, provs: [], last: "2026-10-19T08:00:00Z" },
  [id(5)]: { email: "baja@test.es", role: "user", is_active: false, display_name: null, provs: [], last: null }
});
let ADM = admInicial();

const userByToken = (req) => {
  const t = (req.headers.authorization || "").replace("Bearer ", "");
  try { const sub = JSON.parse(Buffer.from(t.split(".")[1], "base64url").toString()).sub; return Object.values(users).find((u) => u.id === sub) || null; } catch { return null; }
};
const emailOf = (u) => Object.keys(users).find((k) => users[k] === u);

function applyFilters(rows, params) {
  let out = rows;
  for (const [key, raw] of params) {
    if (["select", "order", "limit", "offset", "on_conflict"].includes(key)) continue;
    const dot = raw.indexOf(".");
    const op = raw.slice(0, dot), val = raw.slice(dot + 1);
    if (op === "eq") out = out.filter((r) => String(r[key]) === val);
    else if (op === "gt") out = out.filter((r) => String(r[key]) > val);
    else if (op === "in") { const set = val.slice(1, -1).split(","); out = out.filter((r) => set.includes(String(r[key]))); }
    else if (op === "is" && val === "null") out = out.filter((r) => r[key] === null || r[key] === undefined);
    else if (raw === "not.is.null") out = out.filter((r) => r[key] !== null && r[key] !== undefined);
  }
  return out;
}

function send(res, status, body, extra = {}) {
  const cors = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "authorization, apikey, content-type, x-client-info, prefer, accept, accept-profile, content-profile, range, x-supabase-api-version",
    "Access-Control-Allow-Methods": "GET,POST,PATCH,PUT,DELETE,OPTIONS",
    "Access-Control-Expose-Headers": "content-range"
  };
  res.writeHead(status, { ...cors, ...(body === undefined ? {} : { "Content-Type": "application/json" }), ...extra });
  res.end(body === undefined ? undefined : JSON.stringify(body));
}

createServer(async (req, res) => {
  const url = new URL(req.url, "http://127.0.0.1:" + PORT);
  const chunks = []; for await (const c of req) chunks.push(c);
  const raw = Buffer.concat(chunks).toString();
  let body = {}; try { body = raw ? JSON.parse(raw) : {}; } catch { body = {}; }
  const path = url.pathname;
  if (req.method === "OPTIONS") return send(res, 204);

  // Utilidades de prueba.
  if (path === "/__fail") { FALLO = { n: Number(url.searchParams.get("n") || 0), modo: url.searchParams.get("modo") || "500" }; return send(res, 200, FALLO); }
  if (path === "/__rel") return send(res, 200, S.rel);
  if (path === "/__log") return send(res, 200, S.log);
  if (path === "/__state") return send(res, 200, { userState: S.userState, establishments: S.establishments });
  if (path === "/__reset") { const n = url.searchParams.get("n"); const e = url.searchParams.get("estados"); S = freshState(n === null ? undefined : Number(n), e === null ? undefined : e === "1", url.searchParams.get("realista") === "1"); ADM = admInicial(); for (const p of provinces) p.is_active = true; return send(res, 200, { ok: true, puntos: S.establishments.length, estados: S.conEstados }); }

  // Nominatim simulado: registra la petición y responde en el centro del área pedida (o en Madrid).
  if (path === "/nominatim/search") {
    const q = url.searchParams.get("q") || "", vb = url.searchParams.get("viewbox");
    S.log.push({ tipo: "nominatim", q, viewbox: vb, bounded: url.searchParams.get("bounded"), countrycodes: url.searchParams.get("countrycodes") });
    if (q.includes("SINRESULTADO")) return send(res, 200, []);
    let lat = 40.4168, lon = -3.7038;
    if (vb) { const [l, t, r, b] = vb.split(",").map(Number); lat = +((t + b) / 2).toFixed(6); lon = +((l + r) / 2).toFixed(6); }
    return send(res, 200, [{ lat: String(lat), lon: String(lon) }]);
  }

  // GoTrue.
  if (path === "/auth/v1/token") {
    const u = users[body.email];
    if (!u || body.password !== "x") return send(res, 400, { error: "invalid_grant", error_description: "Invalid login credentials" });
    const exp = Math.floor(Date.now() / 1000) + 3600;
    const token = b64({ alg: "HS256", typ: "JWT" }) + "." + b64({ sub: u.id, role: "authenticated", exp }) + ".firma";
    return send(res, 200, { access_token: token, token_type: "bearer", expires_in: 3600, expires_at: exp, refresh_token: "r-" + u.id,
      user: { id: u.id, aud: "authenticated", role: "authenticated", email: body.email, app_metadata: {}, user_metadata: {}, created_at: "2026-10-18T00:00:00Z" } });
  }
  if (path === "/auth/v1/logout") return send(res, 204);
  if (path === "/auth/v1/user") { const u = userByToken(req); return u ? send(res, 200, { id: u.id, email: emailOf(u), aud: "authenticated", role: "authenticated" }) : send(res, 401, { message: "sin sesión" }); }

  // PostgREST.
  if (path.startsWith("/rest/v1/")) {
    const table = path.slice("/rest/v1/".length);
    const u = userByToken(req);
    if (!u) return send(res, 401, { code: "PGRST301", message: "JWT inválido" });
    const wantsCount = (req.headers.prefer || "").includes("count=exact");
    const single = (req.headers.accept || "").includes("vnd.pgrst.object+json");
    const reply = (rows, status = 200) => {
      let out = rows;
      const order = url.searchParams.get("order");
      if (order) { const [col, dir] = order.split("."); out = out.slice().sort((a, b) => (a[col] < b[col] ? -1 : a[col] > b[col] ? 1 : 0) * (dir === "desc" ? -1 : 1)); }
      const total = out.length;
      const limit = Number(url.searchParams.get("limit") || 1000);
      out = out.slice(0, Math.min(limit, 1000));
      const range = total === 0 ? "*/0" : "0-" + (out.length - 1) + "/" + total;
      return send(res, status, single ? (out[0] ?? null) : out, wantsCount ? { "Content-Range": range } : {});
    };
    S.log.push({ tipo: "rest", metodo: req.method, tabla: table, consulta: url.search.slice(0, 300) });

    const eqParam = (name) => { const v = url.searchParams.get(name); return v && v.startsWith("eq.") ? v.slice(3) : null; };

    if (table === "rpc/list_establishment_assignees") {
      const est = S.establishments.find((e) => e.id === body.p_establishment_id);
      if (!est || !(u.role === "admin" || u.provinces.some((c) => P(c).id === est.province_id))) return send(res, 403, { code: "42501", message: "No autorizado" });
      const prov = provinces.find((p) => p.id === est.province_id);
      return send(res, 200, Object.entries(users).filter(([, x]) => x.role === "admin" || (prov && x.provinces.includes(prov.code))).map(([mail, x]) => ({ id: x.id, label: mail.split("@")[0] })));
    }
    // Expedientes relacionales (solicitudes, concesiones y seguimientos) con las mismas reglas que la migración permit_workflow.
    const REL = ["permit_applications", "permit_grants", "followups"];
    const relVisible = (row) => u.role === "admin" || S.establishments.some((e) => e.id === row.establishment_id && u.provinces.some((c) => P(c).id === e.province_id));
    const ahora = () => { S.relClock = (S.relClock || 0) + 1; return new Date(Date.UTC(2026, 9, 23, 12, 0, 0) + S.relClock * 1000).toISOString().replace("Z", "000+00:00"); };
    const fallo = (code, message, status = 400) => send(res, status, { code, message });
    const apps = S.rel.permit_applications, grants = S.rel.permit_grants, fups = S.rel.followups;
    /* Auditoría simulada (como los triggers de audit_log): solo la lee un administrador. */
    S.audit = S.audit || [];
    const aud = (accion, tabla, rid, campos) => S.audit.push({ id: S.audit.length + 1, actor_id: u.id, action: accion, table_name: tabla, record_id: rid, details: { changed_fields: campos }, created_at: ahora().replace("000+00:00", "Z") });
    if (table === "audit_log") {
      if (u.role !== "admin") return reply([]);
      return reply(applyFilters(S.audit.slice().reverse(), url.searchParams));
    }
    const closeFups = (appId) => fups.forEach((f) => { if (f.application_id === appId && !f.completed_at) f.completed_at = ahora(); });
    const closeGrantFups = (grantId) => fups.forEach((f) => { if (f.grant_id === grantId && !f.completed_at) f.completed_at = ahora(); });
    /* create_permit_application (migración 20261025170441): solicitud y seguimiento en una transacción, idempotente por identificador. */
    if (table === "rpc/create_permit_application") {
      if (!body.p_id || !body.p_establishment_id) return fallo("22023", "Faltan el identificador o el establecimiento");
      const est = S.establishments.find((e) => e.id === body.p_establishment_id);
      if (!est || !relVisible({ establishment_id: est.id })) return fallo("42501", "new row violates row-level security policy", 403);
      let a = apps.find((x) => x.id === body.p_id);
      if (a) {
        const n = (v) => v ?? null;
        if (a.establishment_id !== body.p_establishment_id || n(a.organization) !== n(body.p_organization) || n(a.capturer_count) !== n(body.p_capturer_count) || n(a.requested_from) !== n(body.p_requested_from) || n(a.requested_until) !== n(body.p_requested_until)) return fallo("23505", "Ya existe otra solicitud con ese identificador", 409);
      } else {
        a = { id: body.p_id, establishment_id: body.p_establishment_id, status: "pending", requested_from: body.p_requested_from ?? null, requested_until: body.p_requested_until ?? null, organization: body.p_organization ?? null, capturer_count: body.p_capturer_count ?? null,
          requested_at: body.p_requested_at ?? ahora().slice(0, 10), contact_details: body.p_contact_details ?? null, notes: body.p_notes ?? null, created_by: u.id, updated_by: u.id, created_at: ahora(), updated_at: ahora() };
        if (body.p_followup_due && body.p_followup_assignee && !relVisible({ establishment_id: a.establishment_id })) return fallo("23514", "responsable no válido");
        apps.push(a);
        aud("insert", "permit_applications", a.id, ["organization", "requested_from", "requested_until", "capturer_count", "status"]);
      }
      if (body.p_followup_due && a.status === "pending" && !fups.some((f) => f.application_id === a.id && !f.completed_at)) {
        const f = { id: "00000000-0000-4000-a000-" + String(fups.length + 1).padStart(12, "0"), establishment_id: a.establishment_id, application_id: a.id, due_on: body.p_followup_due, assigned_to: body.p_followup_assignee ?? null, next_action: body.p_followup_action ?? null, completed_at: null, created_by: u.id, created_at: ahora(), updated_at: ahora() };
        fups.push(f); aud("insert", "followups", f.id, ["due_on", "assigned_to", "next_action"]);
      }
      return send(res, 200, a.id);
    }
    if (table.startsWith("rpc/") && ["approve_permit_application", "resolve_permit_application", "cancel_permit_grant"].includes(table.slice(4))) {
      const fn = table.slice(4);
      const a = apps.find((x) => x.id === body.p_application_id && relVisible(x)), g = grants.find((x) => x.id === body.p_grant_id && relVisible(x));
      if (fn === "cancel_permit_grant") {
        if (!g) return fallo("P0002", "Concesión no encontrada", 404);
        if (g.status === "cancelled") return send(res, 200, null);
        if (body.p_expected_updated_at && body.p_expected_updated_at !== g.updated_at) return fallo("PT409", "La concesión ha cambiado desde que se leyó", 409);
        Object.assign(g, { status: "cancelled", cancelled_at: ahora(), cancelled_reason: body.p_reason || null, updated_at: ahora(), updated_by: u.id });
        closeGrantFups(g.id);
        aud("update", "permit_grants", g.id, ["status", "cancelled_at", "cancelled_reason"]);
        return send(res, 200, null);
      }
      if (!a) return fallo("P0002", "Solicitud no encontrada", 404);
      if (fn === "approve_permit_application") {
        const ya = grants.find((x) => x.application_id === a.id);
        if (a.status === "approved" && ya) return send(res, 200, ya.id);
        if (body.p_expected_updated_at && body.p_expected_updated_at !== a.updated_at) return fallo("PT409", "La solicitud ha cambiado desde que se leyó", 409);
        if (a.status !== "pending") return fallo("23514", "La solicitud ya está resuelta");
        const vf = body.p_valid_from ?? a.requested_from, vu = body.p_valid_until ?? a.requested_until;
        if (vf && vu && vu < vf) return fallo("23514", "fechas incoherentes");
        Object.assign(a, { status: "approved", resolved_at: ahora(), resolved_by: u.id, updated_at: ahora(), updated_by: u.id });
        const nueva = { id: "00000000-0000-4000-9000-" + String(grants.length + 1).padStart(12, "0"), establishment_id: a.establishment_id, application_id: a.id, status: "active", valid_from: vf, valid_until: vu,
          organization: body.p_organization ?? a.organization, capturer_count: body.p_capturer_count ?? a.capturer_count, contact_details: a.contact_details, notes: a.notes, cancelled_at: null, cancelled_reason: null, created_at: ahora(), updated_at: ahora(), created_by: u.id };
        grants.push(nueva);
        closeFups(a.id);
        aud("update", "permit_applications", a.id, ["status", "resolved_at"]); aud("insert", "permit_grants", nueva.id, ["organization", "valid_from", "valid_until", "capturer_count", "application_id", "status"]);
        S.log.push({ tipo: "rel", accion: "aprobar", app: a.id, grant: nueva.id });
        return send(res, 200, nueva.id);
      }
      if (!["denied", "withdrawn"].includes(body.p_status)) return fallo("22023", "Estado de resolución no válido");
      if (a.status === body.p_status) return send(res, 200, null);
      if (body.p_expected_updated_at && body.p_expected_updated_at !== a.updated_at) return fallo("PT409", "La solicitud ha cambiado desde que se leyó", 409);
      if (a.status !== "pending") return fallo("23514", "La solicitud ya está resuelta");
      Object.assign(a, { status: body.p_status, resolution_reason: body.p_reason || null, resolved_at: ahora(), resolved_by: u.id, updated_at: ahora(), updated_by: u.id });
      closeFups(a.id);
      aud("update", "permit_applications", a.id, ["status", "resolution_reason", "resolved_at"]);
      return send(res, 200, null);
    }
    if (REL.includes(table)) {
      const rows = S.rel[table];
      if (req.method === "GET") return reply(applyFilters(rows.filter(relVisible), url.searchParams));
      if (req.method === "POST") {
        const fila = Array.isArray(body) ? body[0] : body;
        if (!fila || !fila.establishment_id || !relVisible(fila)) return fallo("42501", "new row violates row-level security policy", 403);
        if (fila.id && rows.some((x) => x.id === fila.id)) return fallo("23505", "duplicate key value", 409);
        const nueva = { id: fila.id || "00000000-0000-4000-a000-" + String(rows.length + 1).padStart(12, "0"), status: table === "permit_grants" ? "active" : "pending", completed_at: null, ...fila, created_at: ahora(), updated_at: ahora() };
        rows.push(nueva);
        aud("insert", table, nueva.id, Object.keys(fila));
        return send(res, 201);
      }
      if (req.method === "PATCH") {
        const sel = applyFilters(rows.filter(relVisible), url.searchParams);
        for (const r of sel) { Object.assign(r, body, { updated_at: ahora() }); aud("update", table, r.id, Object.keys(body)); }
        return send(res, 200, sel.map((r) => ({ id: r.id })));
      }
      if (req.method === "DELETE") {
        if (u.role !== "admin") return send(res, 200, []);
        const sel = applyFilters(rows, url.searchParams);
        sel.forEach((r) => { rows.splice(rows.indexOf(r), 1); aud("delete", table, r.id, []); });
        return send(res, 200, sel.map((r) => ({ id: r.id })));
      }
    }
    if (table === "municipalities") {
      const prov = provinces.find((p) => p.id === eqParam("province_id"));
      if (!prov) return reply([]);
      const nombres = prov.code === "18" ? ["Granada", "Armilla", "Maracena", "Motril", "Albolote"] : ["Capital", "Norte", "Sur"].map((x) => x + " " + prov.code);
      return reply(nombres.map((n, i) => ({ id: id(5000 + Number(prov.code) * 10 + i), name: n, province_id: prov.id })));
    }
    if (table === "rpc/admin_list_users") {
      if (u.role !== "admin" || !ADM[u.id]?.is_active) return send(res, 403, { code: "42501", message: "No autorizado" });
      return send(res, 200, Object.entries(ADM).map(([uid, a]) => ({ id: uid, email: a.email, display_name: a.display_name, role: a.role, is_active: a.is_active, created_at: "2026-10-16T00:00:00Z", last_sign_in_at: a.last, province_ids: a.provs.map((c) => P(c).id) })));
    }
    if (table === "profiles" && req.method === "PATCH") {
      if (u.role !== "admin") return send(res, 200, []);
      const uid = eqParam("id"), a = ADM[uid];
      if (!a) return send(res, 200, []);
      const nuevo = { ...a, ...("role" in body ? { role: body.role } : {}), ...("is_active" in body ? { is_active: body.is_active } : {}), ...("display_name" in body ? { display_name: body.display_name } : {}) };
      const activosAdmin = (x) => x.role === "admin" && x.is_active;
      if (activosAdmin(a) && !activosAdmin(nuevo) && !Object.entries(ADM).some(([k, x]) => k !== uid && activosAdmin(x))) return send(res, 400, { code: "23514", message: "No se puede dejar el sistema sin administradores activos" });
      ADM[uid] = nuevo;
      S.log.push({ tipo: "adm", accion: "profiles", uid, body });
      return send(res, 200, [{ id: uid }]);
    }
    if (table === "provinces") {
      if (req.method === "PATCH") { const p = provinces.find((q) => q.id === eqParam("id")); if (!p || u.role !== "admin") return send(res, 200, []); Object.assign(p, body); S.log.push({ tipo: "adm", accion: "provinces", id: p.id, body }); return send(res, 200, [{ id: p.id }]); }
      return reply(provinces.slice().map((p) => ({ id: p.id, code: p.code, name: p.name, is_active: p.is_active })));
    }
    if (table === "user_provinces" && req.method === "POST") {
      if (u.role !== "admin") return send(res, 403, { code: "42501", message: "row-level security" });
      const a = ADM[body.user_id], p = provinces.find((q) => q.id === body.province_id);
      if (a && p && !a.provs.includes(p.code)) a.provs.push(p.code);
      S.log.push({ tipo: "adm", accion: "alta_provincia", body });
      return send(res, 201);
    }
    if (table === "user_provinces" && req.method === "DELETE") {
      if (u.role !== "admin") return send(res, 200, []);
      const a = ADM[eqParam("user_id")], p = provinces.find((q) => q.id === eqParam("province_id"));
      if (!a || !p || !a.provs.includes(p.code)) return send(res, 200, []);
      a.provs = a.provs.filter((c) => c !== p.code);
      S.log.push({ tipo: "adm", accion: "baja_provincia", user: eqParam("user_id"), province: p.id });
      return send(res, 200, [{ user_id: eqParam("user_id") }]);
    }
    if (table === "profiles") return reply(applyFilters([{ id: u.id, display_name: emailOf(u), role: u.role, is_active: true }], url.searchParams));
    if (table === "user_provinces") {
      return reply(applyFilters(u.provinces.map((code) => ({ user_id: u.id, province_id: P(code).id, provinces: P(code) })), url.searchParams));
    }
    if (table === "establishments") {
      const visible = u.role === "admin" ? S.establishments : S.establishments.filter((e) => u.provinces.some((c) => P(c).id === e.province_id));
      if (req.method === "PATCH") {
        const rows = applyFilters(visible, url.searchParams);
        for (const r of rows) Object.assign(r, body);
        return reply(rows);
      }
      return reply(applyFilters(visible, url.searchParams));
    }
    if (table === "user_app_state") {
      if (req.method === "GET") { const st = S.userState[u.id]; return reply(applyFilters(st ? [{ user_id: u.id, state: st }] : [], url.searchParams)); }
      S.userState[u.id] = body.state; return send(res, 201);
    }
    if (table === "establishment_app_state") {
      const visibles = new Set((u.role === "admin" ? S.establishments : S.establishments.filter((e) => u.provinces.some((c) => P(c).id === e.province_id))).map((e) => e.id));
      // Escrituras con el mismo protocolo que la app (H-11): INSERT si no hay fila (23505 si ya existe) y UPDATE condicionado a la versión leída, que suma 1.
      const fallaAhora = (req.method === "POST" || req.method === "PATCH") && FALLO.n > 0 ? (FALLO.n--, FALLO.modo) : "";
      if (fallaAhora === "500") return send(res, 500, { code: "XX000", message: "fallo simulado" });
      if (req.method === "POST") {
        const fila = Array.isArray(body) ? body[0] : body;
        if (!fila || !visibles.has(fila.establishment_id)) return send(res, 403, { code: "42501", message: "new row violates row-level security policy" });
        if (S.shared[fila.establishment_id]) return send(res, 409, { code: "23505", message: "duplicate key value" });
        S.shared[fila.establishment_id] = { establishment_id: fila.establishment_id, province_id: fila.province_id, state: fila.state, updated_by: fila.updated_by || u.id, version: 1 };
        return send(res, 201, [{ establishment_id: fila.establishment_id, version: 1 }]);
      }
      if (req.method === "PATCH") {
        const eid = eqParam("establishment_id"), ver = Number(eqParam("version"));
        let fila = S.shared[eid];
        // Las filas de estados sintéticos (estados=1) existen solo de lectura hasta que se editan: se materializan en la primera escritura.
        if (!fila && S.conEstados) { const v = estadosDe(S.establishments).find((r) => r.establishment_id === eid); if (v) fila = S.shared[eid] = { ...v, updated_by: v.updated_by || u.id, version: 1 }; }
        if (!fila || fila.version !== ver) return send(res, 200, []);
        fila.state = body.state; fila.updated_by = body.updated_by || u.id; fila.version += 1;
        if (fallaAhora === "perdida") { req.socket.destroy(); return; }
        return send(res, 200, [{ establishment_id: eid, version: fila.version }]);
      }
      const base = (S.conEstados ? estadosDe(S.establishments).filter((r) => !S.shared[r.establishment_id]) : []).concat(Object.values(S.shared));
      return reply(applyFilters(base.filter((r) => visibles.has(r.establishment_id)), url.searchParams));
    }
    return send(res, 404, { code: "MOCK404", message: "tabla no simulada: " + table });
  }
  return send(res, 404, { message: "ruta no simulada: " + path });
}).listen(PORT, "127.0.0.1", () => console.log("mock supabase en http://127.0.0.1:" + PORT));

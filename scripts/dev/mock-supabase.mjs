// Supabase simulado para probar la interfaz sin tocar ningún proyecto real (H-20 y H-21).
// Imita lo mínimo de GoTrue y PostgREST que usa la app, con datos sintéticos de varias provincias, y un
// Nominatim simulado que registra las peticiones. Puerto 8766, estado en memoria. Uso: node scripts/dev/mock-supabase.mjs
// Usuarios (contraseña «x»): multi@test.es (Granada y Almería), alm@test.es (Almería), vacio@test.es (Jaén, sin puntos), admin@test.es.
// Utilidades: GET /__log (peticiones registradas), GET /__state (estado), GET /__reset (opcional ?n=<puntos>&estados=1).
import { createServer } from "node:http";

const PORT = 8766;
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
const freshState = (n = Number(process.env.MOCK_POINTS || 0), conEstados = process.env.MOCK_STATES === "1") => ({
  conEstados,
  establishments: n > 0 ? generados(n) : seedPoints.map(([cat, name, code, muni, addr, lat, lon], i) => ({
    id: id(100 + i), province_id: P(code).id, name, address: addr, latitude: lat, longitude: lon,
    location_precision: "address", source_ref: "mock-" + i, status: "active", subtype: null,
    categories: { name: cat }, municipalities: { name: muni }, provinces: { name: P(code).name, code }
  })),
  userState: {},
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
  if (path === "/__log") return send(res, 200, S.log);
  if (path === "/__state") return send(res, 200, { userState: S.userState, establishments: S.establishments });
  if (path === "/__reset") { const n = url.searchParams.get("n"); const e = url.searchParams.get("estados"); S = freshState(n === null ? undefined : Number(n), e === null ? undefined : e === "1"); ADM = admInicial(); for (const p of provinces) p.is_active = true; return send(res, 200, { ok: true, puntos: S.establishments.length, estados: S.conEstados }); }

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
      return reply(S.conEstados ? applyFilters(estadosDe(S.establishments).filter((r) => visibles.has(r.establishment_id)), url.searchParams) : []);
    }
    return send(res, 404, { code: "MOCK404", message: "tabla no simulada: " + table });
  }
  return send(res, 404, { message: "ruta no simulada: " + path });
}).listen(PORT, "127.0.0.1", () => console.log("mock supabase en http://127.0.0.1:" + PORT));

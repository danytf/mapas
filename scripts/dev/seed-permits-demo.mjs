// Datos sintéticos de solicitudes, concesiones y seguimientos para el Supabase simulado (scripts/dev/mock-supabase.mjs). No toca ninguna base real.
// Uso: node scripts/dev/seed-permits-demo.mjs [http://127.0.0.1:8766]   (o importar seed(base, opciones))
// Los puntos son los 7 del simulador (Granada y Almería). Las fechas son relativas a hoy, así que las cifras cambian de un día a otro pero su forma no.
export const ADMIN = "admin@test.es";
const ID_ADMIN = "00000000-0000-4000-8000-000000000004", ID_MULTI = "00000000-0000-4000-8000-000000000001", ID_ALM = "00000000-0000-4000-8000-000000000002";
const ONGS = ["AECC", "Cruz Roja", "WWF", "FJC", "Aldeas Infantiles", "FPM", "FEC"];
const E = (i) => "00000000-0000-4000-8000-" + String(100 + (((i % 7) + 7) % 7)).padStart(12, "0");

export const seed = async (base = "http://127.0.0.1:8766", { n = 60 } = {}) => {
  const sesion = await (await fetch(base + "/auth/v1/token?grant_type=password", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ email: ADMIN, password: "x" }) })).json();
  const H = { "Content-Type": "application/json", Authorization: "Bearer " + sesion.access_token, apikey: "x" };
  const d = (k) => new Date(Date.now() + k * 864e5).toISOString().slice(0, 10);
  const post = async (tabla, fila) => { const r = await fetch(base + "/rest/v1/" + tabla, { method: "POST", headers: H, body: JSON.stringify(fila) }); if (r.status !== 201) throw new Error("No se pudo crear en " + tabla + ": " + r.status); };
  const resp = [ID_MULTI, ID_ALM, ID_ADMIN, null];
  const EDADES = [1, 2, 3, 5, 6, 9, 12, 14, 18, 22, 28, 35, 41];
  for (let i = 0; i < n; i++) {
    const edad = EDADES[i % EDADES.length], estado = i % 9 === 0 ? "denied" : i % 11 === 0 ? "withdrawn" : "pending";
    const a = { establishment_id: E(i), organization: ONGS[i % 7], capturer_count: 1 + (i % 5), requested_from: d((i % 30) - 3), requested_until: d((i % 30) + 4), requested_at: d(-edad), status: estado };
    if (estado === "pending" && i % 2 === 0) a.sent_on = d(-edad); /* la mitad de las pendientes ya se ha pedido por correo (solicitada); el resto, por solicitar */
    if (estado !== "pending") { a.resolved_at = d(-Math.max(0, edad - 3)) + "T10:00:00Z"; a.resolution_reason = estado === "denied" ? "Sin cupo" : null; }
    await post("permit_applications", a);
    await post("permit_grants", { establishment_id: E(i + 3), organization: ONGS[(i + 2) % 7], capturer_count: 1 + (i % 6), valid_from: d((i % 40) - 25), valid_until: i % 13 === 0 ? null : d((i % 40) - 8) });
    if (i % 2 === 0) await post("followups", { establishment_id: E(i), due_on: d((i % 16) - 8), next_action: "Acción " + i, assigned_to: resp[i % 4], created_by: ID_ADMIN });
  }
  /* Un seguimiento vinculado directamente a una concesión (grant_id) y una concesión sin fechas, para ejercitar esos casos. */
  const rel = await (await fetch(base + "/__rel")).json(), g = rel.permit_grants[0];
  await post("followups", { establishment_id: g.establishment_id, grant_id: g.id, due_on: d(-2), next_action: "Revisar cupo de la concesión", created_by: ID_ADMIN });
  await post("permit_grants", { establishment_id: E(1), organization: "Sin fechas S.L.", capturer_count: 2 });
  return rel;
};

if (import.meta.url === "file:///" + process.argv[1].replace(/\\/g, "/") || import.meta.url.endsWith(process.argv[1]?.replace(/\\/g, "/") || "?")) {
  const base = process.argv[2] || "http://127.0.0.1:8766";
  seed(base).then(() => console.log("Datos sintéticos cargados en " + base)).catch((e) => { console.error(e.message); process.exit(1); });
}

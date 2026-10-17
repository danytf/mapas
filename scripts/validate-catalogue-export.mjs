#!/usr/bin/env node
/**
 * Validate catalogo-inicial-granada.json before any Supabase import.
 * Usage: node scripts/validate-catalogue-export.mjs catalogo-inicial-granada.json
 * Read-only: never writes to Supabase or changes the input file.
 */
import fs from "node:fs";

const file = process.argv[2] || "catalogo-inicial-granada.json";
const fail = message => {
  console.error("ERROR:", message);
  process.exitCode = 1;
};

let data;
try {
  data = JSON.parse(fs.readFileSync(file, "utf8"));
} catch (error) {
  console.error(`No se puede leer JSON válido en "${file}": ${error.message}`);
  process.exit(1);
}

if (data?.format_version !== 1) fail("format_version debe ser 1.");
if (data?.source !== "static_catalogue_only") fail("La fuente no es static_catalogue_only.");
if (data?.province !== "Granada") fail("La provincia debe ser Granada.");
if (!Array.isArray(data?.establishments)) fail("establishments debe ser un array.");

const rows = Array.isArray(data?.establishments) ? data.establishments : [];
const refs = new Map();
const duplicates = new Map();
const invalidCoordinates = [];
const missingCoordinates = [];
const invalidRows = [];

rows.forEach((row, index) => {
  const rowNo = index + 1;
  for (const key of ["source_ref", "name", "category", "municipality", "province"]) {
    if (typeof row?.[key] !== "string" || !row[key].trim()) {
      invalidRows.push({ row: rowNo, issue: `missing_${key}` });
    }
  }
  if (row?.province !== "Granada") {
    invalidRows.push({ row: rowNo, issue: "province_mismatch" });
  }

  const hasLat = row?.latitude !== null && row?.latitude !== undefined;
  const hasLon = row?.longitude !== null && row?.longitude !== undefined;
  if (!hasLat && !hasLon) {
    missingCoordinates.push(rowNo);
  } else if (
    !hasLat || !hasLon ||
    typeof row.latitude !== "number" || !Number.isFinite(row.latitude) ||
    typeof row.longitude !== "number" || !Number.isFinite(row.longitude) ||
    row.latitude < -90 || row.latitude > 90 ||
    row.longitude < -180 || row.longitude > 180
  ) {
    invalidCoordinates.push({ row: rowNo, source_ref: row?.source_ref ?? null });
  }

  if (typeof row?.source_ref === "string") {
    refs.set(row.source_ref, (refs.get(row.source_ref) || 0) + 1);
  }
});

for (const [source_ref, count] of refs) {
  if (count > 1) duplicates.set(source_ref, count);
}

const report = {
  file,
  rows: rows.length,
  invalid_required_fields: invalidRows.length,
  missing_coordinate_pairs: missingCoordinates.length,
  invalid_coordinate_pairs: invalidCoordinates.length,
  duplicate_source_refs: duplicates.size,
  embedded_export_counts: data?.counts ?? null,
  pass: invalidRows.length === 0 &&
    invalidCoordinates.length === 0 &&
    duplicates.size === 0
};

console.log(JSON.stringify({
  ...report,
  invalid_rows_sample: invalidRows.slice(0, 20),
  missing_coordinate_rows_sample: missingCoordinates.slice(0, 20),
  invalid_coordinates_sample: invalidCoordinates.slice(0, 20),
  duplicate_source_refs_sample: [...duplicates.entries()].slice(0, 20)
}, null, 2));

if (!report.pass) process.exitCode = 1;

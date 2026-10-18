#!/usr/bin/env bash
# Copia lógica mensual de la base de Supabase (roles, esquema y datos), con sumas de control.
# Uso (desde un ordenador de confianza, NO en GitHub Actions):
#   export DB_URL='<cadena de conexión de la base, del panel de Supabase>'
#   bash scripts/backup-supabase.sh [carpeta_destino]
# La cadena de conexión no se escribe en ningún fichero ni se muestra. Carpeta por defecto: ~/backups-mapas (fuera del repositorio).
# Usa Supabase CLI (`supabase`) si está instalado (puede requerir Docker). Si no, usa `pg_dump` (versión 17 o superior) y vuelca los schemas public y private
# (no incluye usuarios de auth ni roles: tras restaurar habría que recrearlos; ver docs/import-export-backups.md).
# Esto es una copia, no una restauración: hasta probarla en un proyecto aislado (Fase E) no debe darse por buena.
set -euo pipefail
umask 077

if [ -z "${DB_URL:-}" ]; then
  echo "Falta la variable DB_URL (cadena de conexión de Supabase). No se ha hecho nada." >&2
  exit 1
fi
if command -v supabase >/dev/null 2>&1; then MODE=cli; elif command -v pg_dump >/dev/null 2>&1; then MODE=pgdump; else echo "No se encuentra ni supabase (CLI) ni pg_dump." >&2; exit 1; fi

DEST_BASE="${1:-$HOME/backups-mapas}"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
DEST="$DEST_BASE/$STAMP"
mkdir -p "$DEST"
cd "$DEST"

if [ "$MODE" = cli ]; then
  echo "Volcando roles..."
  supabase db dump --db-url "$DB_URL" -f roles.sql --role-only
  echo "Volcando esquema..."
  supabase db dump --db-url "$DB_URL" -f schema.sql
  echo "Volcando datos..."
  supabase db dump --db-url "$DB_URL" -f data.sql --use-copy --data-only
else
  echo "Supabase CLI no disponible: usando pg_dump (schemas public y private)."
  echo "-- Sin volcado de roles en modo pg_dump (los roles de Supabase ya existen en un proyecto nuevo)." > roles.sql
  echo "Volcando esquema public y private..."
  pg_dump "$DB_URL" --schema=public --schema=private --schema-only --no-owner --no-privileges -f schema.sql
  echo "Volcando datos de public y private..."
  pg_dump "$DB_URL" --schema=public --schema=private --data-only --no-owner -f data.sql
fi

# Comprobaciones mínimas: ficheros no vacíos y con contenido esperado.
for f in roles.sql schema.sql data.sql; do
  [ -s "$f" ] || { echo "ERROR: $f está vacío. Copia NO válida: $DEST" >&2; exit 1; }
done
grep -q "CREATE SCHEMA private" schema.sql || { echo "ERROR: schema.sql no contiene el schema private (las políticas dependen de él). Copia NO válida." >&2; exit 1; }
grep -q "establishments" schema.sql || { echo "ERROR: schema.sql no contiene la tabla establishments. Copia NO válida." >&2; exit 1; }
grep -q "establishments" data.sql || { echo "ERROR: data.sql no contiene datos de establishments. Copia NO válida." >&2; exit 1; }

sha256sum roles.sql schema.sql data.sql > SHA256SUMS
echo
echo "Copia creada en: $DEST"
ls -l roles.sql schema.sql data.sql SHA256SUMS
echo
echo "Siguiente: guarda esta carpeta en un sitio privado y cifrado, fuera de GitHub y de Supabase, y conserva al menos las 3 últimas."
echo "Para comprobar que no se ha corrompido: cd '$DEST' && sha256sum -c SHA256SUMS"

#!/usr/bin/env bash
# Copia lógica mensual de la base de Supabase (roles, esquema y datos), con sumas de control.
# Uso (desde un ordenador de confianza, NO en GitHub Actions):
#   export DB_URL='<cadena de conexión de la base, del panel de Supabase>'
#   bash scripts/backup-supabase.sh [carpeta_destino]
# La cadena de conexión no se escribe en ningún fichero ni se muestra. Carpeta por defecto: ~/backups-mapas (fuera del repositorio).
# Requiere Supabase CLI (`supabase`); según su versión puede requerir Docker en marcha.
# Esto es una copia, no una restauración: hasta probarla en un proyecto aislado (Fase E) no debe darse por buena.
set -euo pipefail
umask 077

if [ -z "${DB_URL:-}" ]; then
  echo "Falta la variable DB_URL (cadena de conexión de Supabase). No se ha hecho nada." >&2
  exit 1
fi
command -v supabase >/dev/null 2>&1 || { echo "No se encuentra el comando supabase (Supabase CLI)." >&2; exit 1; }

DEST_BASE="${1:-$HOME/backups-mapas}"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
DEST="$DEST_BASE/$STAMP"
mkdir -p "$DEST"
cd "$DEST"

echo "Volcando roles..."
supabase db dump --db-url "$DB_URL" -f roles.sql --role-only
echo "Volcando esquema..."
supabase db dump --db-url "$DB_URL" -f schema.sql
echo "Volcando datos..."
supabase db dump --db-url "$DB_URL" -f data.sql --use-copy --data-only

# Comprobaciones mínimas: ficheros no vacíos y con contenido esperado.
for f in roles.sql schema.sql data.sql; do
  [ -s "$f" ] || { echo "ERROR: $f está vacío. Copia NO válida: $DEST" >&2; exit 1; }
done
grep -q "establishments" schema.sql || { echo "ERROR: schema.sql no contiene la tabla establishments. Copia NO válida." >&2; exit 1; }
grep -q "establishments" data.sql || { echo "ERROR: data.sql no contiene datos de establishments. Copia NO válida." >&2; exit 1; }

sha256sum roles.sql schema.sql data.sql > SHA256SUMS
echo
echo "Copia creada en: $DEST"
ls -l roles.sql schema.sql data.sql SHA256SUMS
echo
echo "Siguiente: guarda esta carpeta en un sitio privado y cifrado, fuera de GitHub y de Supabase, y conserva al menos las 3 últimas."
echo "Para comprobar que no se ha corrompido: cd '$DEST' && sha256sum -c SHA256SUMS"

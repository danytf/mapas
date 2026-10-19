#!/usr/bin/env bash
# Aplica en orden los SQL de una carga por trozos (uno por provincia) con psql, parando en el primer error.
# Uso: bash scripts/catalogue/cargar.sh <directorio con import_*.sql> <categoria (code)>
# La cadena de conexion se pide sin eco y no se guarda en ningun sitio. Cada trozo es una transaccion (BEGIN/COMMIT en el propio SQL).
# Muestra el recuento de la categoria y el total de puntos antes y despues.
set -euo pipefail
dir="${1:?directorio con los SQL}"
cat="${2:?codigo de la categoria}"
read -r -s -p "Cadena de conexion de Supabase (no se muestra ni se guarda): " CONN
echo
cuenta() {
  psql "$CONN" -Atq -c "select (select count(*) from establishments), (select count(*) from establishments e join categories c on c.id=e.category_id where c.code='$cat')"
}
echo "Antes (total|categoria): $(cuenta)"
for f in "$dir"/import_*.sql; do
  echo "Aplicando $f"
  psql "$CONN" -v ON_ERROR_STOP=1 -q -f "$f"
done
echo "Despues (total|categoria): $(cuenta)"
unset CONN

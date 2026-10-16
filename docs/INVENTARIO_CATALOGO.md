# Inventario preliminar del catálogo estático

Fuente: `index.html` de `audit/fase-1-app-actual`, SHA `4a002c76a78f87e1c6bfc1a0bfe4635bd64890bf`. Este inventario es solo documental; no modifica la aplicación ni carga datos.

## Recuento sintáctico

| Bloque | Entradas detectadas |
|---|---:|
| `CENTERS` | 48 |
| `PROV` | 35 |
| `SUPER` | 320 |
| `OFICIALES` | 207 |
| `GYMS` | 89 |
| `BIGS` | 92 |
| **Total en los seis bloques** | **791** |
| Claves en `PRECOMPUTED` (coordenadas) | 791 |
| Nombres en `REVIEWED_BASE` | 49 |

Los recuentos son estructurales, no prueban que existan 791 ubicaciones únicas ni que todas las coordenadas sean correctas. `REVIEWED_BASE` es una lista heterogénea, no evidencia suficiente para marcar automáticamente registros como verificados.

La auditoría automatizada de GitHub Actions confirma **791/791 coincidencias exactas por clave de nombre** entre las filas de los seis bloques y `PRECOMPUTED`, sin grupos de nombres duplicados detectados por normalización básica ni claves de coordenadas sobrantes. Esto solo confirma la estructura, no que cada punto corresponda a la dirección correcta.

El código usa el tercer valor de algunas coordenadas (`1`) como indicador de aproximación (`q[2] === 1`). El informe identifica **27 ubicaciones marcadas como aproximadas**, **33 registros sin municipio explícito** y **4 sin dirección explícita**. No se detectaron coordenadas ausentes o fuera de rango global en esta comprobación. Los 37 registros con municipio/dirección incompletos requieren revisión; los 27 aproximados deben conservar una precisión `approximate`, no convertirse en `verified` por defecto.

## Alcance y limitaciones

- El catálogo inspeccionado se centra en Granada y su provincia; no constituye una base nacional.
- Los bloques tienen estructuras distintas y enlazan coordenadas por nombre visible. Hay que revisar colisiones, duplicados, nombres divergentes, direcciones incompletas y coordenadas fuera del ámbito esperado.
- No se migrará ningún dato de `localStorage`, `sessionStorage` ni exportaciones de pruebas. Solo se evaluará el catálogo estático versionado en el código.

## Extractor de auditoría creado

Se ha añadido [`scripts/audit-static-catalog.mjs`](../scripts/audit-static-catalog.mjs), que lee solo los literales estáticos de `index.html` y genera CSV/JSON de auditoría. No lee almacenamiento del navegador ni escribe en Supabase. Genera filas por fuente, grupos de nombres duplicados, registros con campos incompletos y claves de coordenadas no utilizadas.

El script ya se ha ejecutado correctamente en [GitHub Actions](https://github.com/danytf/mapas/actions/runs/38974374559) y ha generado los CSV/JSON como [artefacto descargable](https://github.com/danytf/mapas/actions/runs/38974374559/artifacts/12078231907). La ejecución confirma los recuentos anteriores y la marca de aproximación para 27 coordenadas. **No se han verificado geográficamente las coordenadas** ni resuelto manualmente los campos incompletos.

El siguiente paso es ejecutar el script sobre una copia exacta del archivo fuente, revisar los CSV/JSON y corregir discrepancias manualmente. Solo después debe prepararse un lote de importación reproducible con checksum e informe de incidencias.

**Estado:** inventario preliminar. No hay CSV/semilla aprobada ni carga en Supabase. `main` y la app publicada permanecen sin cambios.

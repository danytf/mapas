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

## Alcance y limitaciones

- El catálogo inspeccionado se centra en Granada y su provincia; no constituye una base nacional.
- Los bloques tienen estructuras distintas y enlazan coordenadas por nombre visible. Hay que revisar colisiones, duplicados, nombres divergentes, direcciones incompletas y coordenadas fuera del ámbito esperado.
- No se migrará ningún dato de `localStorage`, `sessionStorage` ni exportaciones de pruebas. Solo se evaluará el catálogo estático versionado en el código.

## Siguiente paso recomendado

Crear un extractor de solo lectura que produzca un CSV de auditoría, sin escribir en Supabase, con fuente, nombre, categoría, municipio, dirección, coordenadas, indicador de revisión y notas. Debe informar filas sin coordenadas/dirección, coordenadas parciales, nombres duplicados, claves sin correspondencia y candidatos a revisión manual. Después se normalizan municipios/provincias, se validan coordenadas y se prepara un lote reproducible con checksum e informe de incidencias.

**Estado:** inventario preliminar. No hay CSV/semilla aprobada ni carga en Supabase. `main` y la app publicada permanecen sin cambios.

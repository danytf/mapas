# Completar calles y códigos postales de grandes superficies

Consulta a Nominatim inverso hecha por el titular el 19/10/2026 sobre los 198 puntos del lote que carecían de calle o de código postal (1 petición cada 1,2 s). Devolvió 197 calles y 197 códigos postales; la calle es la vía más cercana (orientativa, no una dirección postal verificada).

## Calles (SQL)

`supabase/seeds/grandes-superficies-andalucia/calles_nominatim.sql`: 12 de las 28 calles que faltaban. Se descartaron 16 resultados que no son una calle del comercio: autovías, autopistas, circunvalaciones, códigos de carretera (A-2202, A-8082R1, A-376), accesos y «Ruta de las Alpujarras». Esos 16 puntos siguen sin calle (no se inventa).

Solo rellena `address` si está vacío y aborta sin cambios si no actualiza exactamente 12 filas (por eso una segunda ejecución falla a propósito). Probado en local: 28 → 16 puntos sin calle. **Pendiente de aprobación; sin aplicar en producción.**

## Códigos postales (a mano desde la ficha)

`codigos_postales_pendientes.csv`: 196 códigos sugeridos por Nominatim (5 cifras, y las dos primeras coinciden con la provincia del punto). Falta 1: «Carrefour Oria – Calle Calvario», Nominatim no devolvió código. Por SQL no se pueden escribir (`guard_sensitive_updates`); la edición se hace por un administrador desde la ficha (PR #151, pestaña Ubicación). Los códigos de Nominatim son los del punto consultado, conviene contrastar los dudosos en Correos o en Google Maps.

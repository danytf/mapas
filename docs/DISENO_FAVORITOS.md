# Favoritos

Estado: **implementados en la rama `feat/favoritos`; pendiente de verificación en navegador, PR y despliegue** (19/10/2026). Decisión del titular (19/10/2026): favoritos **personales de cada usuario**, marcados **desde la ficha del punto**, con un filtro **«Favoritos»** junto a la búsqueda.

## Qué hace

- **Marcar.** En la ficha, un corazón junto al botón de cerrar (`aria-pressed`; su nombre cambia entre «Marcar como favorito» y «Quitar de favoritos»). Cada cambio se guarda en Supabase y se anuncia en la región de estado (««X» añadido a favoritos»). Si no se puede guardar, el favorito vuelve a como estaba y se avisa.
- **Filtrar.** Un botón «Favoritos (n)» a la derecha de la búsqueda. Activado, la lista y el mapa muestran solo tus favoritos (y los demás filtros siguen aplicándose). Sin favoritos queda desactivado con una pista («Marca puntos como favoritos desde su ficha»); si estando activo se quita el último, se apaga solo.
- El corazón no es una estrella porque la valoración para captación ya usa estrellas.

## Datos y reglas

- Se guardan en `user_app_state.favorites` (lista de referencias a puntos, igual que «desactivados», «quitados» y «revisados»): **personales, no se comparten y no necesitan migración**. Nunca en `localStorage`, `sessionStorage` ni cookies.
- La referencia de un punto es la misma que usan las demás listas personales (`personalStateKey`), así que sobrevive a renombrados.

## Pruebas

`scripts/test-favoritos.mjs` (estática, en CI). Pendiente: prueba en navegador con el Supabase simulado (marcar y quitar, contador, filtro, error de guardado, recarga) y comprobación en producción por el titular.

## Límites

No hay marca de favorito en la lista, en el pin ni en el calendario (no se pidió). Cambiar de usuario en el mismo navegador no mezcla favoritos: cada sesión carga los suyos.

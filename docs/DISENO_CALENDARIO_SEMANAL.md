# Calendario semanal

Estado: **hecho y desplegado el 19/10/2026** (PR #137, commit `fcde338`). Verificado: el despliegue de Pages terminó con éxito y la URL pública tiene el mismo SHA-256 que `index.html` de `main` (`d1499dbd934330e6`...), con la sección nueva y sin la vista semanal del panel. Pendiente: que el titular lo revise con sus permisos reales. Decisión del titular (19/10/2026): sacar la vista semanal del panel resumen y crear una sección nueva, a pantalla completa y muy visual, con selector de semana y provincia.

## Qué hace

- Menú → Informes → **Calendario semanal**. Diálogo grande sobre el mapa.
- Controles: provincia (las del usuario; administradores, todas las que tienen puntos), ONG, semana (flechas, «Hoy» y selector de fecha) y filtros por estado (concedido, solicitado, caducado, denegado, cancelado).
- Resumen de la semana: captadores concedidos y por aprobar, con el número de puntos, y los sin respuesta, denegados y cancelados.
- Siete columnas (lunes a domingo). Sobre cada una, una **silueta de barras**: altura = captadores del día (concedidos en verde, por aprobar en trama amarilla). Debajo, el día, el total y una tarjeta por permiso: estado (texto y color), punto, municipio y categoría, fechas si dura varios días, ONG (color propio según el nombre) y número de captadores. Pulsar una tarjeta cierra el calendario y abre el punto en el mapa.
- En pantallas estrechas las columnas pasan a una lista vertical.

## Datos y reglas

- Solo lee lo que ya está en memoria (solicitudes y concesiones de cada punto, con las mismas reglas de estado que la ficha). **No cambia la base de datos, no escribe y no guarda nada en el navegador.**
- Un permiso aparece cada día entre su fecha de inicio y la de fin (si falta una, queda abierto por ese lado). Los puntos quitados o archivados no aparecen.
- Los captadores de un día suman, por punto, el mayor número declarado en sus permisos de ese estado.
- Al abrir se elige la provincia con más captadores esa semana (o la primera por orden alfabético). «Todas las provincias» está disponible si hay más de una.
- Se retiró «Permisos por semana» del panel resumen (la vista de barras por ONG).

## Accesibilidad y diseño

- Estado siempre en texto además de color; filtros con `aria-pressed`; cada día con su encabezado; rango de la semana en `role="status"`; la silueta es decorativa (`aria-hidden`).
- Colores con las variables de la app (modo claro y oscuro); la animación de las barras solo con movimiento permitido (`prefers-reduced-motion`).

## Pruebas

- `scripts/test-calendario.mjs` (estática, en CI).
- En el navegador con el Supabase simulado (`scripts/dev/mock-supabase.mjs`, usuario `multi@test.es`): escenarios con los cinco estados, varias ONG y permisos de varios días; filtros de estado; apertura de un punto desde una tarjeta; diseño estrecho en un iframe de 400 px sin desbordamiento horizontal; 0 violaciones de CSP y nada en `localStorage` ni `sessionStorage`.
- No probado: lectores de pantalla reales ni el modo oscuro del sistema real.

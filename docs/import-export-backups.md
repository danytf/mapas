# Punto 3 — Importación, exportación y copias de seguridad

Fecha de auditoría: 2026-10-17  
Proyecto Supabase revisado: `mapas-dev` (`wwoczmihhupofwmlmgga`).

## Hallazgos

- El catálogo operativo está en Supabase; la copia JSON de la interfaz no es una copia completa de la base de datos.
- La exportación CSV incluye campos operativos potencialmente sensibles: contactos, notas, solicitudes e historial de permisos.
- La antigua importación JSON aceptaba datos legacy y podía llamar a las rutinas de guardado del estado compartido. Esto permitía reintroducir datos locales de prueba o modificar estado operativo mediante un archivo sin validación suficiente.
- Se ha retirado la importación de copias locales de la interfaz. La exportación CSV y la exportación JSON ahora requieren confirmación explícita y advierten sobre el carácter sensible de los datos y los límites de la copia JSON.
- El proyecto revisado tiene 792 establecimientos, 52 provincias y RLS habilitado en las 16 tablas públicas. No se ha insertado, actualizado ni eliminado ningún registro de Supabase durante esta auditoría.

## Límites de lo verificado

La integración disponible permite consultar el proyecto y su base de datos, pero no expone el plan contratado ni el inventario/estado de las copias automáticas. Por tanto, **no está verificado que existan copias automáticas disponibles ni que se haya probado una restauración**. No debe darse por resuelta la recuperación hasta comprobarlo en el panel de Supabase.

## Procedimiento de copia y recuperación

1. En el panel de Supabase, abre el proyecto `mapas-dev` y entra en **Database → Backups**. Comprueba el plan, la fecha de la copia más reciente y el periodo de retención. La documentación oficial indica que las copias diarias automáticas se incluyen en Pro, Team y Enterprise; para Free recomienda generar exportaciones regulares con Supabase CLI y mantener copias fuera del proyecto.
2. Conserva una copia lógica independiente de la base de datos mediante Supabase CLI (`supabase db dump`) y guárdala cifrada fuera del repositorio GitHub y fuera del propio proyecto Supabase. No guardes contraseñas, tokens ni claves secretas en el repositorio, en la copia ni en este documento.
3. Mantén el esquema/migraciones en Git y los datos operativos en la copia de base de datos. La exportación JSON/CSV de la interfaz **no** sustituye la copia completa de la base de datos.
4. Antes de cualquier restauración, crea/elige un entorno de desarrollo aislado. Restaura allí primero; nunca pruebes la recuperación directamente sobre la base de datos que usa la aplicación.
5. Después de restaurar, verifica: tablas y migraciones esperadas, conteos de establecimientos/provincias/categorías, inicio de sesión, aislamiento entre provincias y guardado/lectura con RLS. Registra fecha, origen de la copia, resultado y cualquier diferencia.
6. Repite la copia según la frecuencia de cambios y comprueba periódicamente que el archivo puede leerse y que el procedimiento de restauración funciona.

## Referencias oficiales

- Supabase — Database Backups: https://supabase.com/docs/guides/platform/backups
- Supabase — CLI: https://supabase.com/docs/reference/cli/supabase-db-dump

## Estado

- [x] Retirar el importador JSON legacy de la interfaz.
- [x] Advertir antes de exportar CSV o JSON.
- [x] Documentar la diferencia entre exportación de interfaz y backup de base de datos.
- [ ] Confirmar plan y copias disponibles en el panel de Supabase.
- [ ] Crear y verificar una copia independiente de la base de datos.
- [ ] Realizar una restauración de prueba aislada.

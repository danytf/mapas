# Exportaciones y copias de seguridad

Actualizado: 17 de octubre de 2026.

## Qué guarda la aplicación

- El catálogo maestro y sus coordenadas se leen desde Supabase.
- El estado operativo de permisos compartidos se guarda en `establishment_app_state`.
- El estado personal (puntos propios, puntos ocultos, revisiones, logros y progreso) se guarda en `user_app_state`.
- La aplicación no debe guardar esos datos en el almacenamiento persistente del navegador. La sesión de Supabase se mantiene en memoria y puede ser necesario iniciar sesión tras recargar.

## Exportar desde la interfaz

Las opciones **Exportar CSV** y **Exportar estado (JSON)** piden confirmación antes de crear el archivo. La opción avanzada **Copiar JSON con coordenadas** también pide confirmación antes de copiar nombres, direcciones y coordenadas al portapapeles.

- El CSV incluye datos operativos como contactos, notas, solicitudes e historial de permisos. Guárdalo únicamente en una ubicación autorizada y protegida.
- El JSON contiene una exportación parcial del estado operativo y de puntos personalizados. **No es una copia completa de la base de datos**: no incluye el catálogo maestro completo ni sustituye un backup de Supabase.
- La interfaz ya no permite importar archivos JSON antiguos. Esto evita volver a introducir datos de pruebas o sobrescribir estado operativo con una copia local desactualizada.
- La exportación de coordenadas desde el menú avanzado es una herramienta de consulta, no una vía para actualizar el catálogo maestro.

## Copia lógica de Supabase

Supabase indica que los backups automáticos diarios están disponibles en los planes Pro, Team y Enterprise. Para proyectos Free recomienda generar copias con Supabase CLI y conservarlas fuera del proyecto: [Database Backups](https://supabase.com/docs/guides/platform/backups).

Desde un ordenador de confianza, con Supabase CLI instalado y la cadena privada de conexión disponible en una variable de entorno `DB_URL`, la documentación oficial muestra estos comandos:

```bash
supabase db dump --db-url "$DB_URL" -f roles.sql --role-only
supabase db dump --db-url "$DB_URL" -f schema.sql
supabase db dump --db-url "$DB_URL" -f data.sql --use-copy --data-only
```

Referencia: [Supabase CLI — db dump](https://supabase.com/docs/reference/cli/supabase-db-dump).

Protege la cadena de conexión y los archivos resultantes. No la pegues en el chat ni la guardes en el repositorio. Conserva los dumps en una ubicación privada cifrada, separada de GitHub y de Supabase. Los archivos pueden contener datos personales y operativos.

## Restauración y verificación

No pruebes una restauración sobre la base de datos usada por la aplicación. Restaura primero en un proyecto de desarrollo aislado y sigue la guía oficial compatible con los dumps generados: [Backup and restore using the CLI](https://supabase.com/docs/guides/platform/migrating-within-supabase/backup-restore).

Después comprueba, como mínimo:

1. Tablas, migraciones y conteos esperados.
2. Usuarios y configuración de autenticación.
3. RLS y aislamiento entre provincias.
4. Lectura del catálogo y escritura de estados.
5. Que el catálogo maestro y sus coordenadas no han sido reemplazados por datos antiguos.

**Estado de verificación:** la aplicación y su despliegue se validan mediante GitHub Actions. No se ha generado ni restaurado una copia externa desde esta integración; la recuperación no debe considerarse probada hasta completar la prueba aislada.

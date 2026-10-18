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

## Procedimiento de copia mensual (decidido el 19/10/2026)

- **Quién:** el titular, a mano, desde un ordenador de confianza. La cadena de conexión con la contraseña de la base no se comparte con asistentes ni se usa en GitHub Actions.
- **Cuándo:** una vez al mes y siempre antes de aplicar una migración en producción. Si el uso crece, pasar a semanal.
- **Cómo:** `export DB_URL='<cadena de conexión del panel de Supabase>'` y después `bash scripts/backup-supabase.sh`. Genera en `~/backups-mapas/<fecha>/` los ficheros `roles.sql`, `schema.sql` y `data.sql` más `SHA256SUMS`, y se niega a dar la copia por válida si algún fichero está vacío o no contiene `establishments`.
- **Dónde guardarla:** un sitio privado y cifrado, fuera de GitHub y de Supabase; conservar al menos las 3 últimas.
- **Estado:** el script se ha comprobado solo en sintaxis y en su comportamiento sin `DB_URL`. **No se ha ejecutado contra Supabase ni se ha restaurado una copia**: hasta la prueba de restauración (Fase E) no debe darse por buena. Con Supabase CLI (puede requerir Docker) vuelca roles, esquema y datos. Si no está instalado usa `pg_dump` y vuelca solo el schema `public`: no incluye usuarios de autenticación ni sus contraseñas. Con `pg_dump` hay que usar una cadena de conexión que funcione desde tu red (si la directa falla, usa la del "session pooler" del panel de Supabase).

## Restauración y verificación

**Primera prueba real (19/10/2026, proyecto temporal `mapas-restore-test`, copia de `pg_dump`):** los datos se restauraron completos (791 puntos, 3 estados compartidos, 3 perfiles, 856 filas de auditoría; esquema `schema.sql` en unos 10 s y datos en unos 3 s por la red del titular). Pero **la primera copia solo volcaba el schema `public`, y las políticas RLS dependen de funciones del schema `private`: la restauración dejó 0 políticas y RLS desactivado**. El script se corrigió para volcar también `private` y negarse a dar la copia por válida si falta. Además, `schema.sql` empieza con `CREATE SCHEMA public;`, que falla en un proyecto Supabase nuevo.

Pasos de restauración con la copia de `pg_dump` (en un proyecto aislado, nunca sobre producción):

```bash
cd <carpeta de la copia>
sed '/^CREATE SCHEMA public;$/d' schema.sql | psql "$NEW_URL" -v ON_ERROR_STOP=1 -q
(echo "SET session_replication_role = replica;"; cat data.sql) | psql "$NEW_URL" -v ON_ERROR_STOP=1 -q
```

Después, comprobar las 6 huellas (`supabase/tools/schema_fingerprint.sql`) y los recuentos. Los usuarios de autenticación no van en esta copia.

No pruebes una restauración sobre la base de datos usada por la aplicación. Restaura primero en un proyecto de desarrollo aislado y sigue la guía oficial compatible con los dumps generados: [Backup and restore using the CLI](https://supabase.com/docs/guides/platform/migrating-within-supabase/backup-restore).

Después comprueba, como mínimo:

1. Tablas, migraciones y conteos esperados.
2. Usuarios y configuración de autenticación.
3. RLS y aislamiento entre provincias.
4. Lectura del catálogo y escritura de estados.
5. Que el catálogo maestro y sus coordenadas no han sido reemplazados por datos antiguos.

**Estado de verificación:** la aplicación y su despliegue se validan mediante GitHub Actions. No se ha generado ni restaurado una copia externa desde esta integración; la recuperación no debe considerarse probada hasta completar la prueba aislada.

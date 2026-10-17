# Punto 3 — Importación, exportación y copias de seguridad

Fecha de auditoría: 2026-10-17  
Proyecto Supabase revisado: `mapas-dev` (`wwoczmihhupofwmlmgga`).

## Hallazgos

- El catálogo operativo está en Supabase; la copia JSON de la interfaz no es una copia completa de la base de datos.
- La exportación CSV incluye campos operativos potencialmente sensibles: contactos, notas, solicitudes e historial de permisos.
- La antigua importación JSON aceptaba datos legacy y podía llamar a las rutinas de guardado del estado compartido. Esto permitía reintroducir datos locales de prueba o modificar estado operativo mediante un archivo sin validación suficiente.
- Se ha retirado la importación de copias locales de la interfaz. La exportación CSV y la exportación JSON ahora requieren confirmación explícita y advierten sobre el carácter sensible de los datos y los límites de la copia JSON.
- El proyecto revisado tiene 792 establecimientos, 52 provincias y RLS habilitado en las 16 tablas públicas. No se ha insertado, actualizado ni eliminado ningún registro de Supabase durante esta auditoría.
- El usuario confirma que su proyecto está en el plan Free y no dispone de copias automáticas.

## Copia independiente para el plan Free

Las exportaciones de la interfaz no sustituyen una copia de la base de datos. Para generar una copia lógica completa desde un ordenador de confianza:

1. Instala y autentica Supabase CLI y asegúrate de tener `pg_dump` disponible. Consulta la documentación oficial.
2. En Supabase Dashboard → **Connect**, copia la cadena de conexión de la base de datos. No la compartas en el chat, GitHub ni capturas; contiene credenciales. Si la conexión directa no funciona por restricciones de red/IPv6, utiliza el método de conexión recomendado por Supabase para tu entorno.
3. En una terminal local, asigna la cadena a la variable de entorno `DB_URL` sin pegarla en el historial del repositorio y ejecuta los dumps documentados por Supabase para roles, esquema y datos. Guarda los archivos en una carpeta privada cifrada fuera de GitHub y fuera de Supabase.
4. Comprueba que los archivos existen y tienen tamaño razonable. No consideres la copia verificada hasta restaurarla en un proyecto/entorno aislado y comprobar tablas, datos, migraciones, autenticación y aislamiento por provincia.
5. Repite el proceso con una frecuencia acorde al ritmo de cambios y conserva más de una generación de copias.

Comandos de referencia de Supabase CLI (ejecutar localmente; sustituye la variable de entorno por tu conexión privada):

```bash
supabase db dump --db-url "$DB_URL" -f roles.sql --role-only
supabase db dump --db-url "$DB_URL" -f schema.sql
supabase db dump --db-url "$DB_URL" -f data.sql --data-only
```

No subas estos archivos al repositorio público. El archivo de roles puede incluir información de configuración sensible; protege todos los dumps. No pegues aquí la cadena de conexión ni contraseñas.

## Recuperación

- Restaura primero en un proyecto de desarrollo aislado; nunca pruebes la recuperación sobre la base de datos usada por la aplicación.
- Sigue el procedimiento de restauración oficial compatible con los dumps generados y revisa cualquier error en lugar de ignorarlo.
- Comprueba los conteos esperados de establecimientos, provincias y categorías; inicio de sesión; aislamiento entre provincias; y lectura/escritura con RLS.
- Registra fecha, origen de la copia, resultado y diferencias.

## Límites de lo verificado

No se ha generado ni restaurado aún una copia externa desde esta integración. Por tanto, la recuperación **no está validada** hasta completar la prueba aislada. No se han modificado registros de Supabase durante esta auditoría.

## Referencias oficiales

- Supabase — Database Backups: https://supabase.com/docs/guides/platform/backups
- Supabase — CLI db dump: https://supabase.com/docs/reference/cli/supabase-db-dump
- Supabase — Database connection: https://supabase.com/docs/guides/database/connecting-to-postgres

## Estado

- [x] Retirar el importador JSON legacy de la interfaz.
- [x] Advertir antes de exportar CSV o JSON.
- [x] Documentar que la exportación de interfaz no es un backup completo.
- [x] Registrar que el plan Free no dispone de copias automáticas.
- [ ] Crear y verificar una copia independiente de la base de datos.
- [ ] Realizar una restauración de prueba aislada.

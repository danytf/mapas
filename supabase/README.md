# Supabase: bootstrap y migraciones

## Proyecto Supabase ya provisionado

El proyecto activo `wwoczmihhupofwmlmgga` ya contiene el esquema base y los cambios de seguridad iniciales. Algunos de esos scripts se aplicaron antes de que quedaran registrados en `supabase_migrations.schema_migrations`.

Por eso, los scripts de `supabase/bootstrap/` **no son migraciones pendientes para producción**. No ejecutarlos sobre el proyecto activo ni copiarlos a `supabase/migrations/`.

## Crear una base de pruebas desde cero

En una base PostgreSQL/Supabase vacía, ejecutar los scripts de `bootstrap/` en orden numérico para crear el esquema base y sus primeras restricciones. Después aplicar las migraciones de `supabase/migrations/` en orden de versión y cargar el seed de referencia cuando corresponda.

El workflow `.github/workflows/schema-smoke.yml` conserva ese orden y prueba la secuencia completa en una base PostgreSQL efímera. Nunca usa la base de producción.

## Despliegues del proyecto existente

Los nombres y versiones de `supabase/migrations/` deben coincidir con el historial remoto. Antes de usar `supabase db push`, comprobar con `supabase migration list` que las versiones pendientes son exactamente las esperadas. No usar `migration repair` ni modificar la tabla interna de migraciones sin verificar el estado real del esquema.

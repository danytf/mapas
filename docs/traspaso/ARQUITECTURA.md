# Arquitectura

## Aplicación
- Un único `index.html` (HTML, CSS y JavaScript en línea, tres bloques `<script>`) más Leaflet y leaflet.markercluster por CDN. Sin proceso de build. Se publica tal cual en GitHub Pages (`deploy-pages.yml`, solo cuando cambia `index.html` o el workflow).
- Cliente Supabase (`supabase-js` 2.118.0) con almacenamiento de sesión **en memoria**; al cargar borra claves heredadas del navegador y no persiste datos de negocio.
- Capas de mapa: OpenStreetMap y Esri (teselas); geocodificación con Nominatim; enlaces a Google Maps solo como navegación.
- Escrituras: ubicación a `establishments` (verificadas con tiempo límite de 15 s y lectura posterior); estado operativo compartido a `establishment_app_state` mediante `upsert` del JSONB completo; estado personal a `user_app_state`.

## Base de datos (Supabase, proyecto `wwoczmihhupofwmlmgga`)
Tablas de `public` (17, todas con RLS): `provinces`, `municipalities`, `categories`, `establishments`, `establishment_location_history`, `establishment_location_reviews`, `establishment_app_state`, `establishment_app_state_history`, `user_app_state`, `profiles`, `user_provinces`, `permit_applications`, `permit_grants`, `followups`, `audit_log`, `import_batches`, `import_records`.

Modelo de autorización:
- `profiles.role` es `user` o `admin`; un perfil puede estar inactivo. Los usuarios no administradores solo operan sobre las provincias de `user_provinces`.
- Funciones de apoyo `is_admin()`, `has_province_access()` y `can_access_establishment()` en `public` (invocables por `authenticated`, envoltorios) sobre implementaciones en el esquema `private`; `search_path` vacío salvo `set_updated_at` (H-03).
- Usuarios no administradores solo pueden cambiar dirección y campos de ubicación del catálogo maestro; insertar establecimientos exige administrador.
- Triggers relevantes: `guard_sensitive_updates` (campos inmutables y restricción de columnas), `guard_establishment_app_state`, `write_audit_log` (solo nombres de campos cambiados), `record_establishment_location_history`, `record_establishment_app_state_history` (estado previo del JSONB), validaciones de coherencia (municipio-provincia, solicitud-concesión-seguimiento) y marcas de `updated_at`.
- Todas las funciones de trigger y de servicio están sin `EXECUTE` para `anon` y `authenticated`; los objetos nuevos de `public` no heredan privilegios por defecto.
- `anon` no tiene privilegios sobre ninguna tabla.

## Integración continua
- `audit` (`audit-static-catalog.yml`): scripts `scripts/*.mjs` (persistencia, XSS, accesibilidad, SRI, catálogo, sanitizadores), sintaxis del JavaScript en línea.
- `postgres-smoke` (`schema-smoke.yml`): PostgreSQL 17 efímero con una capa mínima de `auth`; aplica bootstrap y migraciones en orden, comprueba que toda migración del repositorio se aplica, y ejecuta `schema_smoke.sql`, `state_history.sql` y `rls_matrix.sql`.
- `default-function-acl.yml`: ACL por defecto de funciones.

## Límites conocidos
Las pruebas SQL corren sobre PostgreSQL con un sustituto mínimo de `auth` (`auth.users`, `auth.uid()` leyendo `request.jwt.claim.sub`): validan políticas, permisos y triggers, no GoTrue ni PostgREST. La Fase C cubre esa brecha con un entorno Supabase real aislado.

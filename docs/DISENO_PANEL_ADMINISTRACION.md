# Diseño del panel de administración (v1)

Estado: **propuesta para aprobación del titular** (19/10/2026). Todavía no hay código. Decisiones ya tomadas por el titular: la primera versión gestiona usuarios y provincias; el alta de cuentas se hace en el panel de Supabase; el panel identifica a los usuarios por su correo.

## 1. Alcance de la v1

Una pantalla «Administración», visible solo para administradores (`profiles.role = 'admin'`), desde el menú de la app. Permite:

1. **Ver los usuarios**: correo, nombre visible, rol, activo o inactivo, provincias asignadas, último acceso.
2. **Cambiar el rol** (usuario o administrador) y **activar o desactivar** a un usuario.
3. **Asignar y quitar provincias** a cada usuario, y **activar o desactivar provincias**.
4. **Editar el nombre visible** (`profiles.display_name`, hoy sin uso).

Fuera de la v1: dar de alta cuentas (se sigue haciendo en Supabase, Authentication → invitar usuario; procedimiento en `docs/ADMINISTRACION_CUENTAS.md`), borrar cuentas, editar el catálogo, ver la auditoría, crear provincias. Dentro, por decisión del titular: activar o desactivar provincias (ver sección 6).

## 2. Qué ya existe y sirve

- Políticas RLS: solo el administrador puede insertar, modificar y borrar en `profiles` y `user_provinces`; cada usuario lee lo suyo y el administrador, todo (`rls_matrix.sql`).
- El trigger `guard_sensitive_updates` solo impide cambiar `id` y `created_at` en `profiles`; el administrador sí puede cambiar rol, `is_active` y `display_name`.
- `profiles` y `user_provinces` ya están auditadas por `write_audit_log` (quién y cuándo; desde H-03 también el rol de la base si no hay usuario).
- La app ya valida el perfil activo y las provincias al iniciar sesión; los cambios del panel se notan en el siguiente inicio de sesión o recarga.

## 3. Qué hay que añadir

### 3.1 Base de datos (una migración, con pruebas)

1. **`public.admin_list_users()`**: función `SECURITY DEFINER` con `search_path` vacío que devuelve `id, email, display_name, role, is_active, last_sign_in_at, provincias` para todos los usuarios. Lee el correo de `auth.users`, que la app no puede leer. Comprueba `is_admin()` al empezar y lanza error si no lo es. `REVOKE` a `PUBLIC` y `anon`, `GRANT EXECUTE` solo a `authenticated`. El correo solo llega al administrador, que ya puede verlo en el panel de Supabase.
2. **Protección contra bloqueo**: un trigger sobre `profiles` que impide dejar el sistema sin ningún administrador activo (desactivar o degradar al último). Evita el caso en que el único administrador se quita a sí mismo y la recuperación exigiría SQL desde el panel de Supabase.
3. Cambios acompañados de: prueba SQL nueva (acceso denegado a `anon`, a usuarios y a administradores inactivos; correcto para el administrador; protección del último administrador), paso en `schema-smoke.yml`, huellas locales y matriz RLS sin discrepancias.

Se aplicará en producción **solo con aprobación del titular** y el permiso temporal de `apply_migration`, igual que las anteriores.

### 3.2 Aplicación (`index.html`)

- Un diálogo nativo `<dialog>` (como «Panel resumen») con tabla de usuarios y controles de rol, estado y provincias; textos en español, etiquetas y foco accesibles (H-28 a H-35), sin librerías nuevas, sin cambios de CSP.
- Las escrituras usan el cliente de Supabase ya existente (`profiles.update`, `user_provinces.insert/delete`) y la lectura usa `rpc('admin_list_users')`.
- Sin persistencia local: la lista vive en memoria; cada acción recarga desde Supabase.
- Protecciones en pantalla: no permitir que el administrador se desactive o se degrade a sí mismo desde el panel; confirmación antes de desactivar o quitar el rol de administrador; mensajes de error con `friendlyError`.
- Pruebas: prueba estática en CI (patrón de `test-ui-fixes.mjs`), prueba en navegador con el Supabase simulado (se ampliará `scripts/dev/mock-supabase.mjs` con la función y las escrituras), y ampliación de `test-a11y-fase-d.mjs` para el diálogo nuevo.

## 4. Plan de entrega (un PR por paso)

1. **PR A: base de datos.** Migración, prueba SQL, `schema-smoke.yml`, documentación. Aprobación del titular antes de aplicarla en producción y verificación posterior (huellas, avisos, simulación de usuario).
2. **PR B: pantalla.** Cambios en `index.html`, simulado, pruebas y accesibilidad. Despliega en producción al fusionarse; verificación en la URL pública con la sesión del titular.
3. **PR C (puede ir dentro del B): documentación.** `ADMINISTRACION_CUENTAS.md` pasa a describir el panel y el procedimiento de alta.

## 5. Riesgos y cómo se controlan

| Riesgo | Control |
|---|---|
| Un usuario no administrador llega a ver correos | La función comprueba `is_admin()` dentro, tiene `EXECUTE` solo para `authenticated`, y la prueba SQL cubre `anon`, usuario normal y administrador inactivo |
| El administrador se bloquea a sí mismo | Trigger de último administrador y protección en pantalla |
| Cambio de rol por error | Confirmación en pantalla, y toda la actividad queda en `audit_log` |
| Función nueva `SECURITY DEFINER` en `public` | `search_path` vacío, permisos mínimos, revisada en la huella `public_functions` y en `default_function_acl_smoke.sql` |
| Cambios en producción | Migración con aprobación explícita y permiso temporal; PR con checks en verde antes de fusionar |

## 6. Decisiones del titular (19/10/2026)

1. Los administradores ven el último acceso de cada usuario: **sí**.
2. La v1 incluye **activar y desactivar provincias** (la política `provinces_admin_update` ya lo permite solo al administrador). Como desactivar una provincia retira el acceso a todos sus usuarios (H-22), la pantalla pedirá confirmación y mostrará cuántos usuarios afecta. Crear provincias sigue fuera de la v1.
3. Un administrador puede degradar a otro **mientras quede al menos uno activo** (trigger `protect_last_admin`).

# Procedimiento de administración y recuperación de cuentas

**Estado:** procedimiento operativo documentado; no ejecuta cambios de cuentas.  
**Proyecto Supabase de desarrollo:** `wwoczmihhupofwmlmgga`.

## Principios de seguridad

- La identidad se administra en **Supabase Auth**; el perfil de aplicación está en `public.profiles` con el mismo UUID que `auth.users.id`.
- El trigger `public.handle_new_auth_user()` crea automáticamente un perfil con `role='user'` y `is_active=true`. No se confía en metadatos de usuario para asignar el rol.
- Solo existen los roles `user` y `admin`. Un usuario estándar necesita al menos una asignación en `public.user_provinces`; sin provincia, la aplicación no debe mostrar el catálogo.
- RLS debe seguir siendo la barrera de seguridad. Nunca se debe cambiar un rol desde el cliente de la aplicación.
- La clave `service_role` no se introduce en `index.html`, GitHub Pages, mensajes, archivos compartidos ni herramientas del navegador. Las operaciones administrativas se realizan en la consola de Supabase o en un entorno servidor autorizado.
- No se registran contraseñas, enlaces de recuperación, tokens ni datos de autenticación en incidencias o logs.

## Panel de administración en la aplicación (desde 19/10/2026)

Los administradores ven en el menú de la aplicación la opción «Usuarios y provincias» (Administración). Desde ahí, sin SQL:

- Ver los usuarios con su correo, nombre visible, rol, estado, provincias y último acceso.
- Cambiar el nombre visible, el rol (usuario o administrador) y activar o desactivar a un usuario.
- Asignar y retirar provincias a cada usuario.
- Activar o desactivar provincias (desactivar una provincia retira el acceso a todos sus usuarios; la pantalla pide confirmación y dice cuántos usuarios afecta).

Protecciones: nadie puede cambiar su propio rol ni desactivarse desde la pantalla; la base de datos impide dejar el sistema sin ningún administrador activo (error explicado en pantalla); las acciones sensibles piden confirmación; todo cambio queda en la auditoría (`audit_log`). Los cambios se aplican al instante en la base; un usuario desactivado o sin provincia pierde el acceso en su siguiente consulta.

**Lo que el panel no hace**: dar de alta cuentas (sigue siendo el procedimiento de la sección siguiente, en Supabase), borrar cuentas, ni editar el catálogo. La lectura de correos usa la función `admin_list_users()` (migraciones `20261018231945` y `20261018232107`), que solo responde a administradores activos.

## Alta de una cuenta

1. En Supabase Dashboard, abre el proyecto correcto y la sección de autenticación de usuarios.
2. Crea/invita al usuario por el flujo de administración autorizado. No habilites registro público solo para facilitar altas.
3. Copia el UUID de la cuenta creada y comprueba que el trigger ha generado su fila en `public.profiles`.
4. Mantén el rol predeterminado `user`. En `public.user_provinces`, asigna únicamente las provincias necesarias.
5. Comprueba que `assigned_by` identifica al administrador responsable y que la pareja `(user_id, province_id)` no está duplicada.
6. Pide al usuario que inicie sesión en la URL oficial de GitHub Pages y confirma que solo ve las provincias asignadas. No reutilices sesiones ni credenciales de otra persona.

## Asignación de una provincia

Solo un administrador autorizado debe realizar la operación. En el SQL Editor de Supabase, con el contexto administrativo del proyecto —nunca con la clave pública desde el navegador—, sustituye todos los marcadores por UUID comprobados:

```sql
insert into public.user_provinces (user_id, province_id, assigned_by)
values ('<USER_UUID>', '<PROVINCE_UUID>', '<ADMIN_UUID>')
on conflict (user_id, province_id)
do update set assigned_by = excluded.assigned_by,
              assigned_at = now();
```

Verifica el resultado con una consulta de solo lectura a `public.user_provinces` y `public.provinces`. No asignes provincias por coincidencia de nombre de usuario ni uses un UUID copiado de una conversación sin contrastarlo con Supabase.

## Recuperación de contraseña

1. En Supabase Auth, identifica la cuenta por el correo corporativo verificado.
2. Usa el flujo oficial de restablecimiento de contraseña de Supabase. No pidas ni establezcas la contraseña por chat.
3. Si el usuario no recibe el enlace, revisa la configuración de correo/redirección y el estado de la cuenta. No copies el token del enlace a tickets.
4. Después del cambio, pide iniciar sesión de nuevo y confirma que el perfil está activo y las provincias correctas.

## Recuperación de un administrador

Si queda al menos un administrador operativo, ese administrador debe recuperar el acceso por el flujo oficial de Auth.

Si no queda ningún administrador operativo:

1. Confirma que tienes acceso legítimo de propietario al proyecto Supabase y que estás en el proyecto correcto.
2. Localiza la cuenta correspondiente en Auth y confirma su UUID. Si no existe, créala desde el panel autorizado y verifica que el trigger creó el perfil.
3. Usa el SQL Editor administrativo de Supabase para corregir únicamente el perfil de esa cuenta. Ejemplo para una cuenta ya existente:

```sql
begin;

update public.profiles
set role = 'admin',
    is_active = true,
    updated_at = now()
where id = '<ADMIN_UUID>';

-- Debe devolver exactamente una fila al verificar:
select id, role, is_active
from public.profiles
where id = '<ADMIN_UUID>';

commit;
```

4. Si el `UPDATE` afecta cero filas, **no** insertes un perfil arbitrario: comprueba primero la existencia de `auth.users` y la ejecución del trigger. Si afecta más de una fila, detente y revisa el esquema.
5. Cierra sesión e inicia sesión con la cuenta recuperada; confirma que el perfil se valida y que el catálogo carga.
6. Registra fuera de la aplicación la fecha, el motivo, el responsable y el UUID de la cuenta afectada, sin incluir secretos. Revisa después el listado de administradores y deja solo los necesarios.

Este procedimiento requiere acceso de propietario al proyecto. No hay un mecanismo de recuperación de administrador mediante la aplicación pública y no debe crearse uno.

## Baja, suspensión o pérdida de acceso

- Para bloquear acceso en la aplicación, un administrador autorizado establece `profiles.is_active=false`. Comprueba además la política de sesiones de Auth y revoca sesiones/tokens por el mecanismo administrativo oficial cuando sea necesario.
- Retira las asignaciones de `user_provinces` que ya no correspondan a la persona. La baja del perfil y la revocación de sesión son operaciones distintas.
- No borres el usuario de Auth como primer recurso: la eliminación en cascada puede eliminar perfil, asignaciones y referencias asociadas. Antes de una eliminación definitiva, evalúa retención y auditoría.
- Para reactivar, verifica identidad y autorización, establece `is_active=true` y restaura solo las asignaciones aprobadas.

## Revisión periódica

- Mantener una lista mínima de administradores activos y un responsable suplente.
- Revisar usuarios activos, roles y provincias asignadas al menos trimestralmente y al cambiar de puesto una persona.
- Probar recuperación de contraseña y acceso del administrador suplente en una ventana acordada.
- Verificar que las 16 tablas públicas mantienen RLS habilitado y que no existen privilegios de tabla para `anon` o `PUBLIC`.
- Revisar los avisos de seguridad de Supabase. La advertencia actual sobre protección frente a contraseñas filtradas no se puede activar en la configuración/plan vigente; no se debe presentar como resuelta ni requiere cambios en el código de la aplicación.

## Comprobaciones técnicas actuales

- El trigger de alta asigna `user`, no `admin`.
- La política de `profiles` permite al usuario leer su perfil y reserva cambios de perfil a administradores.
- La asignación de provincias está restringida a administradores.
- La app valida el perfil activo y la asignación provincial antes de cargar datos.
- La sesión de la app se mantiene en memoria; una recarga requiere volver a autenticar.

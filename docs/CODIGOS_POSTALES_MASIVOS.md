# Carga masiva de códigos postales (administradores)

Estado: **aplicada en producción el 19/10/2026** con la aprobación del titular (versión registrada `20261019191833`, función `SECURITY INVOKER`, `anon` sin `EXECUTE`, `authenticated` con `EXECUTE`).

Problema: `guard_sensitive_updates` solo deja cambiar `postal_code` a un administrador identificado con JWT, así que por SQL (`psql`) no se puede y hasta ahora se escribía punto a punto desde la ficha (unos 1.000 puntos, ~45 minutos). La función `public.admin_set_postal_codes(p_items jsonb, p_only_empty boolean default true)` permite hacerlo en una sola llamada con la sesión del administrador.

## Qué hace

- `SECURITY INVOKER`: se ejecuta con los permisos de quien llama. No concede nada nuevo; siguen mandando las políticas de fila y `guard_sensitive_updates`. Comprueba además `is_admin()` para dar un error claro (`42501`).
- Entrada: array JSON de `{"id": "<uuid>", "postal_code": "NNNNN"}`, hasta 2.000 por llamada.
- Solo escribe si el código tiene 5 cifras y sus dos primeras coinciden con el código de la provincia del punto. Por defecto no pisa un código existente (`p_only_empty = true`).
- Devuelve `{"actualizados": n, "omitidos": [{id, motivo}...]}`: lo que no se puede escribir se lista, no aborta el resto.
- Cada cambio queda en `audit_log` con el administrador como autor.
- `EXECUTE` solo para `authenticated` (no `anon` ni `PUBLIC`).

## Cómo se usa (cuando esté aplicada)

Con la sesión de administrador abierta en la app, desde la consola del navegador:

```js
const items = [{ id: "<uuid>", postal_code: "18001" }, /* ... */];
const { data, error } = await window.mapaSession.supabase.rpc("admin_set_postal_codes", { p_items: items });
console.log(data.actualizados, data.omitidos, error);
```

Los candidatos salen de `scripts/catalogue/completar_cp_desde_base.py` (Nominatim, solo lectura) o de una lista del titular. Los códigos de Nominatim son los del lugar consultado, no una verificación postal.

## Pruebas

`supabase/tests/admin_postal_codes.sql` (19 comprobaciones): permisos (anon y usuario normal), entrada no válida, rellenar vacíos, no pisar, `p_only_empty = false`, código de otra provincia, formatos e ids no válidos, límite de 2.000, que solo cambie `postal_code` y que quede en la auditoría. Probado en PostgreSQL 17 tras reconstruir el esquema con `scripts/dev/rebuild-local-db.sh` y con el resto de pruebas SQL en el orden de `schema-smoke.yml`. El paso está añadido al workflow.

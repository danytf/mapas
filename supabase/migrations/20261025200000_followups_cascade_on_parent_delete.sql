-- Quitar una solicitud o una concesión que tiene seguimientos fallaba siempre.
--
-- Las claves foráneas followups.application_id y followups.grant_id eran ON DELETE SET NULL. Al borrar el padre, la base de datos intenta poner esa columna a NULL en los
-- seguimientos, y el trigger guard_sensitive_updates prohíbe cambiar application_id y grant_id después de crear el registro (con razón: un seguimiento no debe
-- cambiar de expediente). El borrado se abortaba con «El campo application_id no se puede modificar después de crear el registro». No se había notado porque nunca se
-- había quitado un expediente con seguimientos (se detectó al limpiar las solicitudes de prueba de producción el 25/10/2026; reproducido en una base local aislada).
--
-- Un seguimiento sin su solicitud o concesión no tiene sentido, y «Quitar» es una acción solo de administradores: pasan a ON DELETE CASCADE, de modo que los seguimientos
-- se borran con su expediente en la misma transacción. No se toca el trigger de seguridad, ni las políticas RLS (borrar sigue siendo solo de administradores, tanto el
-- expediente como el seguimiento) ni ningún dato. Los borrados quedan en audit_log por los triggers existentes.
-- Reversión: volver a crear ambas claves con ON DELETE SET NULL (los seguimientos ya borrados no se recuperan).

BEGIN;

ALTER TABLE public.followups DROP CONSTRAINT followups_application_id_fkey;
ALTER TABLE public.followups
  ADD CONSTRAINT followups_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.permit_applications(id) ON DELETE CASCADE;

ALTER TABLE public.followups DROP CONSTRAINT followups_grant_id_fkey;
ALTER TABLE public.followups
  ADD CONSTRAINT followups_grant_id_fkey FOREIGN KEY (grant_id) REFERENCES public.permit_grants(id) ON DELETE CASCADE;

COMMIT;

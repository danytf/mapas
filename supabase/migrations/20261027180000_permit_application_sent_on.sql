-- Fecha en que el RGR mandó el correo de una solicitud (permit_applications.sent_on).
--
-- Flujo de trabajo (decisión del titular, 27/10/2026): el responsable provincial o coordinador pone en el Calendario las solicitudes que quiere («por solicitar»);
-- el RGR las pide por correo («solicitada»); cuando responden se conceden o se deniegan. Hasta ahora una solicitud pendiente no distinguía las dos primeras fases.
--
--   por solicitar = status 'pending' y sent_on NULL     (la crea el RP o coordinador)
--   solicitada    = status 'pending' y sent_on con fecha (el RGR la marca al mandar el correo)
--   concedida     = status 'approved'                    (sin cambios)
--   denegada      = status 'denied'                      (sin cambios)
--
-- Los valores de status NO cambian: todo lo que ya existe (aprobar, denegar, el Calendario, el Centro, las funciones y las políticas RLS) sigue igual. Las solicitudes
-- pendientes que ya hay empiezan «por solicitar» porque no consta cuándo se mandó su correo.
--
-- Cambio ADITIVO y reversible: una columna nueva y anulable, sin valor por defecto. No toca políticas RLS, funciones ni datos. Quién puede escribirla lo decide la
-- política de UPDATE que ya tiene la tabla (usuarios con acceso a la provincia del punto), y el cambio queda en audit_log con el resto de campos.
-- Reversión: ALTER TABLE public.permit_applications DROP COLUMN sent_on;

BEGIN;

ALTER TABLE public.permit_applications ADD COLUMN sent_on date;

COMMENT ON COLUMN public.permit_applications.sent_on IS
  'Día en que el RGR mandó el correo de la solicitud. NULL con status pending = «por solicitar»; con fecha = «solicitada».';

COMMIT;

-- Matriz exhaustiva de autorización: tabla x operación x actor x ámbito.
--
-- Qué hace
--   * Crea datos sintéticos (identificadores 00000000-0000-4000-8000-0000000000xx) dentro de una
--     transacción que termina en ROLLBACK: no deja rastro y no toca producción.
--   * Para cada celda ejecuta la operación SQL bajo el rol de API real (authenticated/anon) con el
--     usuario suplantado mediante request.jwt.claim.sub, y revierte el efecto con un subtransacción.
--   * Compara el resultado con una especificación escrita aparte de las políticas (función expected).
--   * Falla si hay discrepancias o si una celda termina por un error distinto de una denegación
--     (p. ej. una FK), porque eso significaría que la celda no prueba lo que dice probar.
--
-- Ejecución: psql -v ON_ERROR_STOP=1 -f supabase/tests/rls_matrix.sql
-- Requiere el esquema completo (migraciones) y el shim mínimo de auth.users / auth.uid().

begin;

-- ---------------------------------------------------------------------------
-- Utilidades
-- ---------------------------------------------------------------------------
create function pg_temp.expand(p_sql text, p_actor uuid) returns text
language sql immutable as $$
  select regexp_replace(
    replace(p_sql, '{A}', coalesce('''' || p_actor::text || '''', 'null')),
    '\{([0-9a-f]{2})\}',
    '''00000000-0000-4000-8000-0000000000\1''',
    'g')
$$;

create function pg_temp.u(sfx text) returns uuid
language sql immutable as $$ select ('00000000-0000-4000-8000-0000000000' || sfx)::uuid $$;

-- ---------------------------------------------------------------------------
-- Actores
-- ---------------------------------------------------------------------------
create temp table matrix_actors (
  label text primary key,
  id uuid,
  db_role text not null,
  is_admin boolean not null,
  active boolean not null,
  prov text
);
insert into matrix_actors values
  ('admin',  pg_temp.u('b1'), 'authenticated', true,  true,  null),
  ('userG',  pg_temp.u('b2'), 'authenticated', false, true,  'G'),
  ('userO',  pg_temp.u('b3'), 'authenticated', false, true,  'O'),
  ('userN',  pg_temp.u('b4'), 'authenticated', false, true,  null),
  ('userI',  pg_temp.u('b5'), 'authenticated', false, false, 'G'),
  ('userG2', pg_temp.u('b6'), 'authenticated', false, true,  'G'),
  ('anon',   null,            'anon',          false, false, null);

-- ---------------------------------------------------------------------------
-- Datos sintéticos (como superusuario, con el administrador como auth.uid())
-- ---------------------------------------------------------------------------
select set_config('request.jwt.claim.sub', pg_temp.u('b1')::text, true);

insert into auth.users (id, raw_user_meta_data)
select pg_temp.u(s), jsonb_build_object('full_name', 'Matrix ' || s)
from unnest(array['b1','b2','b3','b4','b5','b6','b7']) s;

update public.profiles set role = 'admin' where id = pg_temp.u('b1');

insert into public.provinces (id, code, name) values
  (pg_temp.u('c1'), '96', 'Matrix Provincia G'),
  (pg_temp.u('c2'), '97', 'Matrix Provincia O'),
  (pg_temp.u('c9'), '95', 'Matrix Provincia Sin Uso');

insert into public.municipalities (id, province_id, name, normalized_name) values
  (pg_temp.u('c3'), pg_temp.u('c1'), 'Matrix Mun G',  'matrix mun g'),
  (pg_temp.u('c4'), pg_temp.u('c2'), 'Matrix Mun O',  'matrix mun o'),
  (pg_temp.u('c6'), pg_temp.u('c1'), 'Matrix Mun Sin Uso', 'matrix mun sin uso');

insert into public.categories (id, code, name) values
  (pg_temp.u('c5'), 'matrix_cat',        'Matrix Categoria'),
  (pg_temp.u('c7'), 'matrix_cat_unused', 'Matrix Categoria Sin Uso');

insert into public.user_provinces (user_id, province_id, assigned_by) values
  (pg_temp.u('b2'), pg_temp.u('c1'), pg_temp.u('b1')),
  (pg_temp.u('b3'), pg_temp.u('c2'), pg_temp.u('b1')),
  (pg_temp.u('b5'), pg_temp.u('c1'), pg_temp.u('b1')),
  (pg_temp.u('b6'), pg_temp.u('c1'), pg_temp.u('b1'));

insert into public.user_app_state (user_id, state)
select pg_temp.u(s), '{"fixture":true}'::jsonb from unnest(array['b1','b2','b3','b4','b5','b6']) s;

-- d1/d2 con hijos; d3/d4 sin hijos para probar DELETE sin ruido de claves foráneas.
insert into public.establishments
  (id, province_id, municipality_id, category_id, name, normalized_name, address, latitude, longitude, created_by, updated_by)
values
  (pg_temp.u('d1'), pg_temp.u('c1'), pg_temp.u('c3'), pg_temp.u('c5'), 'Matrix Est G',  'matrix est g',  'Calle G 1', 37.10, -3.60, pg_temp.u('b1'), pg_temp.u('b1')),
  (pg_temp.u('d2'), pg_temp.u('c2'), pg_temp.u('c4'), pg_temp.u('c5'), 'Matrix Est O',  'matrix est o',  'Calle O 1', 38.00, -3.50, pg_temp.u('b1'), pg_temp.u('b1')),
  (pg_temp.u('d3'), pg_temp.u('c1'), pg_temp.u('c3'), pg_temp.u('c5'), 'Matrix Est Gx', 'matrix est gx', 'Calle G 3', 37.11, -3.61, pg_temp.u('b1'), pg_temp.u('b1')),
  (pg_temp.u('d4'), pg_temp.u('c2'), pg_temp.u('c4'), pg_temp.u('c5'), 'Matrix Est Ox', 'matrix est ox', 'Calle O 3', 38.01, -3.51, pg_temp.u('b1'), pg_temp.u('b1')),
  (pg_temp.u('d5'), pg_temp.u('c1'), pg_temp.u('c3'), pg_temp.u('c5'), 'Matrix Est Autor', 'matrix est autor', 'Calle G 5', 37.12, -3.62, pg_temp.u('b2'), pg_temp.u('b1'));

-- Sufijos por tabla: e1 = ámbito G, e2 = ámbito O, e3 = G borrable, e4 = O borrable.
-- Los registros de G los crea userG (b2) y los de O userO (b3): sirve para probar que otro
-- usuario del mismo equipo (userG2) también puede modificarlos (comportamiento actual, ver H-04).
insert into public.permit_applications (id, establishment_id, created_by) values
  (pg_temp.u('e1'), pg_temp.u('d1'), pg_temp.u('b2')), (pg_temp.u('e2'), pg_temp.u('d2'), pg_temp.u('b3')),
  (pg_temp.u('e3'), pg_temp.u('d1'), pg_temp.u('b2')), (pg_temp.u('e4'), pg_temp.u('d2'), pg_temp.u('b3'));
insert into public.permit_grants (id, establishment_id, created_by) values
  (pg_temp.u('e1'), pg_temp.u('d1'), pg_temp.u('b2')), (pg_temp.u('e2'), pg_temp.u('d2'), pg_temp.u('b3')),
  (pg_temp.u('e3'), pg_temp.u('d1'), pg_temp.u('b2')), (pg_temp.u('e4'), pg_temp.u('d2'), pg_temp.u('b3'));
insert into public.permit_applications (id, establishment_id, created_by) values (pg_temp.u('e5'), pg_temp.u('d1'), pg_temp.u('b2'));
insert into public.permit_grants (id, establishment_id, created_by) values (pg_temp.u('e5'), pg_temp.u('d1'), pg_temp.u('b2'));
insert into public.followups (id, establishment_id, due_on, created_by) values
  (pg_temp.u('e1'), pg_temp.u('d1'), current_date, pg_temp.u('b2')), (pg_temp.u('e2'), pg_temp.u('d2'), current_date, pg_temp.u('b3')),
  (pg_temp.u('e3'), pg_temp.u('d1'), current_date, pg_temp.u('b2')), (pg_temp.u('e4'), pg_temp.u('d2'), current_date, pg_temp.u('b3'));
insert into public.followups (id, establishment_id, application_id, grant_id, due_on, created_by) values
  (pg_temp.u('e5'), pg_temp.u('d1'), pg_temp.u('e5'), pg_temp.u('e5'), current_date, pg_temp.u('b2'));
insert into public.establishment_location_reviews (id, establishment_id, proposed_latitude, proposed_longitude, created_by) values
  (pg_temp.u('e1'), pg_temp.u('d1'), 37.1, -3.6, pg_temp.u('b2')), (pg_temp.u('e2'), pg_temp.u('d2'), 38.0, -3.5, pg_temp.u('b3')),
  (pg_temp.u('e3'), pg_temp.u('d1'), 37.1, -3.6, pg_temp.u('b2')), (pg_temp.u('e4'), pg_temp.u('d2'), 38.0, -3.5, pg_temp.u('b3'));

insert into public.establishment_app_state (establishment_id, province_id, state, updated_by) values
  (pg_temp.u('d1'), pg_temp.u('c1'), '{"fixture":true}', pg_temp.u('b1')),
  (pg_temp.u('d2'), pg_temp.u('c2'), '{"fixture":true}', pg_temp.u('b1'));

insert into public.import_batches (id, source_name) values (pg_temp.u('f1'), 'matrix 1'), (pg_temp.u('f3'), 'matrix 3');
insert into public.import_records (id, batch_id) values (pg_temp.u('f2'), pg_temp.u('f1')), (pg_temp.u('f4'), pg_temp.u('f1'));

-- Genera historial y auditoría de forma natural mediante los triggers.
update public.establishments set address = 'Calle G 1 bis' where id = pg_temp.u('d1');
update public.establishments set address = 'Calle O 1 bis' where id = pg_temp.u('d2');

-- La cuenta inactiva conserva su asignación provincial y su estado personal.
update public.profiles set is_active = false where id = pg_temp.u('b5');

do $$
begin
  if (select count(*) from public.establishment_location_history where establishment_id in
        (pg_temp.u('d1'), pg_temp.u('d2'))) <> 2 then
    raise exception 'FIXTURE: el historial de ubicación no se generó como se esperaba';
  end if;
  if (select count(*) from public.profiles where id = pg_temp.u('b5') and not is_active) <> 1 then
    raise exception 'FIXTURE: userI debe estar inactivo';
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- Celdas: una operación concreta sobre un objetivo concreto.
--   tprov: ámbito del objetivo (G, O) o X (global) ; owner: dueño para tablas personales.
--   {xx} = UUID sintético ; {A} = UUID del actor.
-- ---------------------------------------------------------------------------
create temp table matrix_cells (
  n serial primary key,
  tbl text not null, op text not null, target text not null,
  tprov text not null, owner uuid,
  stmt text not null, prep text, kind text not null default 'dml'
);

-- Tablas de referencia globales
insert into matrix_cells (tbl, op, target, tprov, stmt, kind)
values
  ('provinces','select','X','X','select 1 from public.provinces where id={c1}','select'),
  ('provinces','insert','X','X','insert into public.provinces(code,name) values (''94'',''Matrix Insert'')','dml'),
  ('provinces','update','X','X','update public.provinces set name=name where id={c1}','dml'),
  ('provinces','delete','X','X','delete from public.provinces where id={c9}','dml'),
  ('municipalities','select','X','X','select 1 from public.municipalities where id={c3}','select'),
  ('municipalities','insert','X','X','insert into public.municipalities(province_id,name,normalized_name) values ({c1},''Matrix New'',''matrix new'')','dml'),
  ('municipalities','update','X','X','update public.municipalities set name=name where id={c3}','dml'),
  ('municipalities','delete','X','X','delete from public.municipalities where id={c6}','dml'),
  ('categories','select','X','X','select 1 from public.categories where id={c5}','select'),
  ('categories','insert','X','X','insert into public.categories(code,name) values (''matrix_new'',''Matrix New'')','dml'),
  ('categories','update','X','X','update public.categories set name=name where id={c5}','dml'),
  ('categories','delete','X','X','delete from public.categories where id={c7}','dml');

-- profiles y user_provinces (dueño = usuario objetivo)
insert into matrix_cells (tbl, op, target, tprov, owner, stmt, prep, kind)
select 'profiles', o.op, t.sfx, 'X', pg_temp.u(t.sfx),
  case o.op
    when 'select' then 'select 1 from public.profiles where id={' || t.sfx || '}'
    when 'update' then 'update public.profiles set display_name=''m'' where id={' || t.sfx || '}'
    when 'delete' then 'delete from public.profiles where id={' || t.sfx || '}'
  end, null, case o.op when 'select' then 'select' else 'dml' end
from (values ('select'),('update'),('delete')) o(op)
cross join (values ('b1'),('b2'),('b3'),('b4'),('b5'),('b6')) t(sfx);
insert into matrix_cells (tbl, op, target, tprov, owner, stmt, prep)
values ('profiles','insert','b7','X',null,
  'insert into public.profiles(id,role) values ({b7},''user'')',
  'delete from public.profiles where id={b7}');

-- El autoborrado del administrador no es una celda genérica: se comprueba más abajo.
delete from matrix_cells where tbl = 'profiles' and op = 'delete' and target = 'b1';

insert into matrix_cells (tbl, op, target, tprov, owner, stmt, prep, kind)
select 'user_provinces', o.op, t.sfx, 'X', pg_temp.u(t.sfx),
  case o.op
    when 'select' then 'select 1 from public.user_provinces where user_id={' || t.sfx || '}'
    when 'update' then 'update public.user_provinces set assigned_by=assigned_by where user_id={' || t.sfx || '}'
    when 'delete' then 'delete from public.user_provinces where user_id={' || t.sfx || '}'
  end, null, case o.op when 'select' then 'select' else 'dml' end
from (values ('select'),('update'),('delete')) o(op)
cross join (values ('b2'),('b3'),('b5'),('b6')) t(sfx);
insert into matrix_cells (tbl, op, target, tprov, owner, stmt)
values ('user_provinces','insert','b4','X',null,
  'insert into public.user_provinces(user_id,province_id,assigned_by) values ({b4},{c1},{b1})');

-- Catálogo maestro
insert into matrix_cells (tbl, op, target, tprov, stmt, kind) values
  ('establishments','select','G','G','select 1 from public.establishments where id={d1}','select'),
  ('establishments','select','O','O','select 1 from public.establishments where id={d2}','select'),
  ('establishments','update_location','G','G','update public.establishments set address=''Matrix addr'' where id={d1}','dml'),
  ('establishments','update_location','O','O','update public.establishments set address=''Matrix addr'' where id={d2}','dml'),
  ('establishments','update_master','G','G','update public.establishments set name=name||'' x'' where id={d1}','dml'),
  ('establishments','update_master','O','O','update public.establishments set name=name||'' x'' where id={d2}','dml'),
  ('establishments','insert','G','G','insert into public.establishments(province_id,name,normalized_name,created_by) values ({c1},''Matrix Ins'',''matrix ins'',{A})','dml'),
  ('establishments','insert','O','O','insert into public.establishments(province_id,name,normalized_name,created_by) values ({c2},''Matrix Ins'',''matrix ins'',{A})','dml'),
  ('establishments','delete','G','G','delete from public.establishments where id={d3}','dml'),
  ('establishments','delete','O','O','delete from public.establishments where id={d4}','dml');

-- Registros operativos por establecimiento (mismas cuatro operaciones y dos ámbitos)
insert into matrix_cells (tbl, op, target, tprov, stmt, kind)
select t.tbl, o.op, s.scope, s.scope,
  case o.op
    when 'select' then format('select 1 from public.%s where id={%s}', t.tbl, s.row_sfx)
    when 'update' then format('update public.%s set notes=''m'' where id={%s}', t.tbl, s.row_sfx)
    when 'delete' then format('delete from public.%s where id={%s}', t.tbl, s.del_sfx)
    when 'insert' then format(t.insert_tpl, s.est_sfx)
  end,
  case o.op when 'select' then 'select' else 'dml' end
from (values
  ('permit_applications', 'insert into public.permit_applications(establishment_id,created_by) values ({%s},{A})'),
  ('permit_grants',       'insert into public.permit_grants(establishment_id,created_by) values ({%s},{A})'),
  ('followups',           'insert into public.followups(establishment_id,due_on,created_by) values ({%s},current_date,{A})')
) t(tbl, insert_tpl)
cross join (values ('select'),('update'),('delete'),('insert')) o(op)
cross join (values ('G','e1','e3','d1'),('O','e2','e4','d2')) s(scope,row_sfx,del_sfx,est_sfx);

-- followups no tiene columna "notes" en todas las versiones: sí la tiene; reviews usa "notes" también.
insert into matrix_cells (tbl, op, target, tprov, stmt, kind)
select 'establishment_location_reviews', o.op, s.scope, s.scope,
  case o.op
    when 'select' then format('select 1 from public.establishment_location_reviews where id={%s}', s.row_sfx)
    when 'update' then format('update public.establishment_location_reviews set notes=''m'' where id={%s}', s.row_sfx)
    when 'delete' then format('delete from public.establishment_location_reviews where id={%s}', s.del_sfx)
    when 'insert' then format('insert into public.establishment_location_reviews(establishment_id,status,proposed_latitude,proposed_longitude,created_by) values ({%s},''pending'',37.1,-3.6,{A})', s.est_sfx)
  end,
  case o.op when 'select' then 'select' else 'dml' end
from (values ('select'),('update'),('delete'),('insert')) o(op)
cross join (values ('G','e1','e3','d1'),('O','e2','e4','d2')) s(scope,row_sfx,del_sfx,est_sfx);

-- Borrar una solicitud o concesión con seguimientos: hasta la migración 20261025200000 se rechazaba incluso para administración (followups.application_id/grant_id son inmutables y la clave era SET NULL). Ahora la clave es CASCADE: la administración puede quitarla (los seguimientos se van con ella) y el resto sigue sin poder.
insert into matrix_cells (tbl, op, target, tprov, stmt) values
  ('permit_applications','delete_referenced','G','G','delete from public.permit_applications where id={e5}'),
  ('permit_grants','delete_referenced','G','G','delete from public.permit_grants where id={e5}');

-- Historial: lectura por ámbito; nadie escribe directamente.
insert into matrix_cells (tbl, op, target, tprov, stmt, kind)
select 'establishment_location_history', o.op, s.scope, s.scope,
  case o.op
    when 'select' then format('select 1 from public.establishment_location_history where establishment_id={%s}', s.est_sfx)
    when 'insert' then format('insert into public.establishment_location_history(establishment_id,new_address) values ({%s},''m'')', s.est_sfx)
    when 'update' then format('update public.establishment_location_history set change_reason=''m'' where establishment_id={%s}', s.est_sfx)
    when 'delete' then format('delete from public.establishment_location_history where establishment_id={%s}', s.est_sfx)
  end,
  case o.op when 'select' then 'select' else 'dml' end
from (values ('select'),('insert'),('update'),('delete')) o(op)
cross join (values ('G','d1'),('O','d2')) s(scope,est_sfx);

-- Auditoría
insert into matrix_cells (tbl, op, target, tprov, stmt, kind) values
  ('audit_log','select','X','X','select 1 from public.audit_log','select'),
  ('audit_log','insert','X','X','insert into public.audit_log(action,table_name) values (''m'',''m'')','dml'),
  ('audit_log','update','X','X','update public.audit_log set action=action','dml'),
  ('audit_log','delete','X','X','delete from public.audit_log','dml');

-- Importaciones (solo administración)
insert into matrix_cells (tbl, op, target, tprov, stmt, kind) values
  ('import_batches','select','X','X','select 1 from public.import_batches where id={f1}','select'),
  ('import_batches','insert','X','X','insert into public.import_batches(source_name) values (''m'')','dml'),
  ('import_batches','update','X','X','update public.import_batches set status=status where id={f1}','dml'),
  ('import_batches','delete','X','X','delete from public.import_batches where id={f3}','dml'),
  ('import_records','select','X','X','select 1 from public.import_records where id={f2}','select'),
  ('import_records','insert','X','X','insert into public.import_records(batch_id) values ({f1})','dml'),
  ('import_records','update','X','X','update public.import_records set status=status where id={f2}','dml'),
  ('import_records','delete','X','X','delete from public.import_records where id={f4}','dml');

-- Estado personal (dueño = usuario objetivo). El INSERT parte de una fila inexistente.
insert into matrix_cells (tbl, op, target, tprov, owner, stmt, prep, kind)
select 'user_app_state', o.op, t.sfx, 'X', pg_temp.u(t.sfx),
  case o.op
    when 'select' then 'select 1 from public.user_app_state where user_id={' || t.sfx || '}'
    when 'update' then 'update public.user_app_state set state=''{"a":1}'' where user_id={' || t.sfx || '}'
    when 'delete' then 'delete from public.user_app_state where user_id={' || t.sfx || '}'
    when 'insert' then 'insert into public.user_app_state(user_id,state) values ({' || t.sfx || '},''{}'')'
  end,
  case o.op when 'insert' then 'delete from public.user_app_state where user_id={' || t.sfx || '}' end,
  case o.op when 'select' then 'select' else 'dml' end
from (values ('select'),('update'),('delete'),('insert')) o(op)
cross join (values ('b1'),('b2'),('b3'),('b4'),('b5'),('b6')) t(sfx);

-- Estado operativo compartido por establecimiento/provincia
insert into matrix_cells (tbl, op, target, tprov, stmt, prep, kind)
select 'establishment_app_state', o.op, s.scope, s.scope,
  case o.op
    when 'select' then format('select 1 from public.establishment_app_state where establishment_id={%s}', s.est_sfx)
    when 'update' then format('update public.establishment_app_state set state=''{"a":1}'' where establishment_id={%s}', s.est_sfx)
    when 'delete' then format('delete from public.establishment_app_state where establishment_id={%s}', s.est_sfx)
    when 'insert' then format('insert into public.establishment_app_state(establishment_id,province_id,state,updated_by) values ({%s},{%s},''{}'',{A})', s.est_sfx, s.prov_sfx)
  end,
  case o.op when 'insert' then format('delete from public.establishment_app_state where establishment_id={%s}', s.est_sfx) end,
  case o.op when 'select' then 'select' else 'dml' end
from (values ('select'),('update'),('delete'),('insert')) o(op)
cross join (values ('G','d1','c1'),('O','d2','c2')) s(scope,est_sfx,prov_sfx);

-- ---------------------------------------------------------------------------
-- Especificación independiente: ¿debería permitirse?
-- ---------------------------------------------------------------------------
create function pg_temp.expected(p_tbl text, p_op text, a matrix_actors, p_tprov text, p_owner uuid)
returns boolean language plpgsql as $$
declare
  authed boolean := a.db_role = 'authenticated';
  in_scope boolean := a.db_role = 'authenticated' and a.active and (a.is_admin or coalesce(a.prov = p_tprov, false));
  is_self boolean := p_owner is not null and a.id = p_owner;
begin
  if not authed then return false; end if;            -- anon: sin acceso a nada
  return case p_tbl
    when 'provinces' then   case when p_op = 'select' then true else a.is_admin end
    when 'municipalities' then case when p_op = 'select' then true else a.is_admin end
    when 'categories' then  case when p_op = 'select' then true else a.is_admin end
    when 'profiles' then    case when p_op = 'select' then (is_self or a.is_admin) else a.is_admin end
    when 'user_provinces' then case when p_op = 'select' then (is_self or a.is_admin) else a.is_admin end
    when 'establishments' then case p_op
        when 'select' then in_scope
        when 'update_location' then in_scope
        else a.is_admin end                               -- update_master, insert, delete
    when 'permit_applications' then case p_op when 'delete' then a.is_admin when 'delete_referenced' then a.is_admin else in_scope end
    when 'permit_grants' then       case p_op when 'delete' then a.is_admin when 'delete_referenced' then a.is_admin else in_scope end
    when 'followups' then           case when p_op = 'delete' then a.is_admin else in_scope end
    when 'establishment_location_reviews' then case p_op
        when 'select' then in_scope
        when 'insert' then in_scope                       -- un no administrador solo como 'pending'
        else a.is_admin end                               -- update, delete
    when 'establishment_location_history' then case when p_op = 'select' then in_scope else false end
    when 'audit_log' then           case when p_op = 'select' then a.is_admin else false end
    when 'import_batches' then a.is_admin
    when 'import_records' then a.is_admin
    when 'user_app_state' then case when p_op = 'delete' then false else (is_self and a.active) end
    when 'establishment_app_state' then case when p_op = 'delete' then false else in_scope end
    else null end;
end $$;

-- ---------------------------------------------------------------------------
-- Ejecutor de celdas: cada celda se ejecuta en una subtransacción que siempre se revierte.
-- ---------------------------------------------------------------------------
create function pg_temp.run_cell(p_actor uuid, p_role text, p_prep text, p_stmt text, p_kind text)
returns text language plpgsql as $$
declare
  n bigint;
  -- Se calculan antes de cambiar de rol: el rol de API no puede usar el esquema temporal.
  v_prep text := case when p_prep is null then null else pg_temp.expand(p_prep, p_actor) end;
  v_stmt text := case when p_kind = 'select'
                      then 'select count(*) from (' || pg_temp.expand(p_stmt, p_actor) || ') s'
                      else pg_temp.expand(p_stmt, p_actor) end;
begin
  begin
    if v_prep is not null then execute v_prep; end if;
    perform set_config('request.jwt.claim.sub', coalesce(p_actor::text, ''), true);
    execute format('set local role %I', p_role);
    if p_kind = 'select' then
      execute v_stmt into n;
    else
      execute v_stmt;
      get diagnostics n = row_count;
    end if;
    raise exception using errcode = 'P0001', message = 'RESULT:' || n;
  exception when others then
    if sqlerrm like 'RESULT:%' then
      return case when substr(sqlerrm, 8)::bigint > 0 then 'ALLOW' else 'DENY' end;
    elsif sqlstate = '42501' then
      return 'DENY';
    else
      return 'OTHER[' || sqlstate || '] ' || left(sqlerrm, 160);
    end if;
  end;
end $$;

create temp table matrix_results (
  tbl text, op text, target text, actor text, expected boolean, outcome text, verdict text
);

do $$
declare
  c matrix_cells;
  a matrix_actors;
  r text;
  exp boolean;
  v text;
begin
  for c in select * from matrix_cells order by n loop
    for a in select * from matrix_actors order by label loop
      r := pg_temp.run_cell(a.id, a.db_role, c.prep, c.stmt, c.kind);
      exp := pg_temp.expected(c.tbl, c.op, a, c.tprov, c.owner);
      v := case
        when r like 'OTHER%' then 'INCONCLUSA'
        when (r = 'ALLOW') = exp then 'OK'
        else 'DISCREPANCIA' end;
      insert into matrix_results values (c.tbl, c.op, c.target, a.label, exp, r, v);
    end loop;
  end loop;
end $$;

-- ---------------------------------------------------------------------------
-- Informe y veredicto
-- ---------------------------------------------------------------------------
select tbl, count(*) as celdas,
       count(*) filter (where verdict = 'OK') as ok,
       count(*) filter (where verdict = 'DISCREPANCIA') as discrepancias,
       count(*) filter (where verdict = 'INCONCLUSA') as inconclusas,
       count(*) filter (where outcome = 'ALLOW') as permitidas,
       count(*) filter (where outcome = 'DENY') as denegadas
from matrix_results group by tbl order by tbl;

select tbl, op, target, actor, expected as esperado, outcome as resultado
from matrix_results where verdict <> 'OK' order by tbl, op, target, actor;

do $$
declare total int; bad int; inconc int; denied_expected int;
begin
  select count(*), count(*) filter (where verdict = 'DISCREPANCIA'), count(*) filter (where verdict = 'INCONCLUSA'),
         count(*) filter (where not expected and verdict = 'OK')
    into total, bad, inconc, denied_expected from matrix_results;
  raise notice 'Matriz RLS: % celdas, % discrepancias, % inconclusas, % denegaciones esperadas verificadas',
    total, bad, inconc, denied_expected;
  if bad > 0 then raise exception 'FALLO: la matriz de autorización tiene % discrepancias', bad; end if;
  if inconc > 0 then raise exception 'FALLO: % celdas no son concluyentes (error distinto de una denegación)', inconc; end if;
  if denied_expected < 100 then raise exception 'FALLO: demasiado pocas pruebas negativas (%)', denied_expected; end if;
end $$;

-- ---------------------------------------------------------------------------
-- H-10: baja de un usuario autor de registros (flujo real: borrado en Auth, sin usuario suplantado)
-- ---------------------------------------------------------------------------
do $$
declare
  r text;
  n bigint;
begin
  -- 1) Un administrador no puede borrarse a sí mismo mientras es autor de registros.
  r := pg_temp.run_cell(pg_temp.u('b1'), 'authenticated', null,
         'delete from public.profiles where id={b1}', 'dml');
  if r = 'ALLOW' then
    raise exception 'FALLO H-10: un administrador pudo borrar su propio perfil';
  end if;

  -- 2) Manipulación: un usuario normal no puede anular ni reasignar created_by de otro autor vivo.
  r := pg_temp.run_cell(pg_temp.u('b6'), 'authenticated', null,
         'update public.permit_applications set created_by = null where id={e2}', 'dml');
  if r = 'ALLOW' then raise exception 'FALLO H-10: se pudo anular created_by con el autor vivo'; end if;
  r := pg_temp.run_cell(pg_temp.u('b6'), 'authenticated', null,
         'update public.permit_applications set created_by = {b6} where id={e2}', 'dml');
  if r = 'ALLOW' then raise exception 'FALLO H-10: se pudo reasignar created_by con el autor vivo'; end if;
  r := pg_temp.run_cell(pg_temp.u('b6'), 'authenticated', null,
         'update public.establishments set created_by = null where id={d1}', 'dml');
  if r = 'ALLOW' then raise exception 'FALLO H-10: se pudo anular created_by del catálogo con el autor vivo'; end if;

  -- 3) Baja real de userG (b2): como superusuario y sin auth.uid(), igual que el panel de Auth.
  perform set_config('request.jwt.claim.sub', '', true);
  delete from auth.users where id = pg_temp.u('b2');

  if exists (select 1 from public.profiles where id = pg_temp.u('b2')) then
    raise exception 'FALLO H-10: el perfil sigue existiendo tras borrar el usuario de Auth';
  end if;
  if exists (select 1 from public.user_provinces where user_id = pg_temp.u('b2'))
     or exists (select 1 from public.user_app_state where user_id = pg_temp.u('b2')) then
    raise exception 'FALLO H-10: asignaciones o estado personal no se eliminaron en cascada';
  end if;

  -- Los registros se conservan y quedan sin autor (no se pierde información operativa).
  select count(*) into n from public.permit_applications where id in (pg_temp.u('e1'), pg_temp.u('e3'), pg_temp.u('e5')) and created_by is null;
  if n <> 3 then raise exception 'FALLO H-10: solicitudes de la persona dada de baja: % de 3 conservadas sin autor', n; end if;
  select count(*) into n from public.permit_grants where id in (pg_temp.u('e1'), pg_temp.u('e3'), pg_temp.u('e5')) and created_by is null;
  if n <> 3 then raise exception 'FALLO H-10: concesiones conservadas sin autor: % de 3', n; end if;
  select count(*) into n from public.followups where id in (pg_temp.u('e1'), pg_temp.u('e3'), pg_temp.u('e5')) and created_by is null;
  if n <> 3 then raise exception 'FALLO H-10: seguimientos conservados sin autor: % de 3', n; end if;
  select count(*) into n from public.establishment_location_reviews where id in (pg_temp.u('e1'), pg_temp.u('e3')) and created_by is null;
  if n <> 2 then raise exception 'FALLO H-10: propuestas de ubicación conservadas sin autor: % de 2', n; end if;
  select count(*) into n from public.establishments where id = pg_temp.u('d5') and created_by is null;
  if n <> 1 then raise exception 'FALLO H-10: el establecimiento del autor dado de baja no se conservó sin autor'; end if;

  -- 4) Un registro huérfano no se puede volver a atribuir a otra persona.
  r := pg_temp.run_cell(pg_temp.u('b6'), 'authenticated', null,
         'update public.permit_applications set created_by = {b6} where id={e1}', 'dml');
  if r = 'ALLOW' then raise exception 'FALLO H-10: se pudo atribuir autoría a un registro huérfano'; end if;
  r := pg_temp.run_cell(pg_temp.u('b1'), 'authenticated', null,
         'update public.establishments set created_by = {b1} where id={d5}', 'dml');
  if r = 'ALLOW' then raise exception 'FALLO H-10: un administrador pudo reescribir la autoría del catálogo'; end if;

  raise notice 'H-10: baja de autor verificada (registros conservados sin autor; autoría no manipulable)';
end $$;

rollback;

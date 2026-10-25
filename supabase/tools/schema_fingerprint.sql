-- Huella MD5 del esquema público. Compara una base local reconstruida con producción.
-- En producción excluir la función de plataforma rls_auto_enable (no existe en la reconstrucción local).
-- Valores de referencia a 25/10/2026 (tras la migración 20261025170441; coinciden en local y en producción): políticas 51 f12aa180, permisos 57 374f58c4, funciones propias 29 86d1deb5, privadas 6 39b74823, triggers 39 12e54ed8, RLS 17 e9ad42c3. (Anteriores: 23/10/2026 funciones 28 8e76f7c5.)
-- Valores de referencia a 23/10/2026 (tras la migración 20261023164238; coinciden en local y en producción): políticas 51 f12aa180, permisos 57 374f58c4, funciones propias 28 8e76f7c5, privadas 6 39b74823, triggers 39 12e54ed8, RLS 17 e9ad42c3. (A 18/10/2026: funciones 21 a3b79a0d, privadas 5 f09ad78b, triggers 36 bf342f42.)
select 'policies' k, count(*) n, md5(string_agg(tablename||'|'||policyname||'|'||cmd||'|'||roles::text||'|'||coalesce(qual,'')||'|'||coalesce(with_check,''), E'\n' order by tablename, policyname)) h from pg_policies where schemaname='public'
union all
select 'table_grants', count(*), md5(string_agg(grantee||'|'||table_name||'|'||privilege_type, E'\n' order by table_name, grantee, privilege_type)) from information_schema.role_table_grants where table_schema='public' and grantee in ('anon','authenticated','PUBLIC')
union all
select 'public_functions', count(*), md5(string_agg(p.proname||'|'||p.prosecdef||'|'||coalesce(p.proconfig::text,'')||'|'||has_function_privilege('anon',p.oid,'EXECUTE')||'|'||has_function_privilege('authenticated',p.oid,'EXECUTE'), E'\n' order by p.proname)) from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public' and p.proname<>'rls_auto_enable' and not exists (select 1 from pg_depend d where d.objid=p.oid and d.deptype='e')
union all
select 'private_functions', count(*), md5(string_agg(p.proname||'|'||p.prosecdef||'|'||coalesce(p.proconfig::text,'')||'|'||has_function_privilege('authenticated',p.oid,'EXECUTE'), E'\n' order by p.proname)) from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='private'
union all
select 'triggers', count(*), md5(string_agg(c.relname||'|'||t.tgname||'|'||pg_get_triggerdef(t.oid), E'\n' order by c.relname, t.tgname)) from pg_trigger t join pg_class c on c.oid=t.tgrelid join pg_namespace n on n.oid=c.relnamespace where n.nspname='public' and not t.tgisinternal
union all
select 'rls_tables', count(*), md5(string_agg(c.relname||'|'||c.relrowsecurity||'|'||c.relforcerowsecurity, E'\n' order by c.relname)) from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='public' and c.relkind='r'
order by 1;

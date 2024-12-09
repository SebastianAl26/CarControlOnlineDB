--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 03/12/2024
--@Descripción: Se crean sinonimos publicos y privados pertenecientes a admin e invitado

whenever sqlerror exit;
--Sinonimos publicos pertenecientes admin(simplificar sentencias sql)
connect af_proy_admin/af@afbd_s2
create or replace public synonym vehiculo_tp for vehiculo_transporte_publico;
create or replace public synonym historico_pv for historico_propietario_vehiculo;
create or replace public synonym historico_sv for historico_status_vehiculo;

--Admin otorga permiso de lectura a 4 tablas
grant select on vehiculo to af_proy_invitado;
grant select on placa to af_proy_invitado;
grant select on modelo to af_proy_invitado;
grant select on marca to af_proy_invitado;

--invitado crea sinonimos privados para las tablas que admin le otorgo permiso
connect af_proy_invitado/af@afbd_s2
create or replace synonym vehiculo for af_proy_admin.vehiculo;
create or replace synonym placa for af_proy_admin.placa;
create or replace synonym modelo for af_proy_admin.modelo;
create or replace synonym marca for af_proy_admin.marca;

--creamos un sinonimo para todas las tablas de admin, af_<nombre tabla>
connect af_proy_admin/af@afbd_s2

declare
  cursor cur_tablas_usuario is 
    select table_name from user_tables;
begin
  for p in cur_tablas_usuario loop
    execute immediate '
      create or replace synonym af_'||p.table_name||' for '||p.table_name
    ;
  end loop;
end;
/

--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 25/11/2024
--@Descripción: Se crean los usuarios admin e invitado y sus roles correspondientes

whenever sqlerror exit;
prompt conectando como sys a la pdb
connect sys/system1@afbd_s2 as sysdba

prompt creando roles
drop role if exists rol_admin;
create role rol_admin;
grant create session, create table, create sequence, create view,
  create synonym, create public synonym, create procedure, create trigger to rol_admin;

drop role if exists rol_invitado;
create role rol_invitado;
grant create session, create synonym to rol_invitado;

prompt se creando usuarios
drop user if exists af_proy_admin cascade;
create user af_proy_admin identified by af quota unlimited on users;

drop user if exists af_proy_invitado cascade;
create user af_proy_invitado identified by af quota unlimited on users;

prompt asignando roles a los usuarios
grant rol_admin to af_proy_admin;
grant rol_invitado to af_proy_invitado;

prompt script finalizado
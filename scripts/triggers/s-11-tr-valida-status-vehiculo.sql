--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 06/12/2024
--@Descripción: Trigger para actualizar y registrar el status de un auto
/*Al relizar el registro de un nuevo auto su status debera ser en regla, caso contrario
se debera lanzar un error e indicar que ese status no esta permitido para un auto recien
registrado.
*No se debe permitir el cambio de status a EN REGLA manualmente, indicar que hay un 
procedimiento encargado de hacer eso.
*Si el status se quiere actualizar a CON VERIFICACION PENDIENTE se debera validar
que el propietario tenga al menos una notificacion para llevar a su vehiculo  al verificentro.
*Solo se puede actualizar el status a LICENCIA expirida si el propietario no tiene al
menos una licencia vigente*/


set serveroutput on
create or replace trigger tr_valida_status_vehiculo
before insert or update of status_vehiculo_id
on vehiculo for each row

declare
  v_status_vehiculo number;
  v_num_notificaciones number;
  v_num_licencias_vigentes number;
  v_sesion varchar2(30);

begin
  case 
    when inserting then
      --se verifica si el status es en regla
      --se seleccionara un registro si el id del insert coindice con el nombre, en regla
      select count(*) into v_status_vehiculo
      from status_vehiculo 
      where nombre = 'EN REGLA' and status_vehiculo_id = :new.status_vehiculo_id;

      if v_status_vehiculo = 0 then
        raise_application_error(-20001, 'ERROR, como es la primera vez que se registra el'
          ||'vehículo (es nuevo) solo puede tener el status EN REGLA');
      end if;

    when updating('status_vehiculo_id') then
      --verificar si se quiere actualizar a status EN REGLA
      select count(*) into v_status_vehiculo
      from status_vehiculo 
      where nombre = 'EN REGLA' and status_vehiculo_id = :new.status_vehiculo_id;

      if v_status_vehiculo = 1 then
        select sys_context('USERENV', 'CLIENT_IDENTIFIER') into v_sesion
        from dual;
        --si el trigger no se activa desde el procedimiento bloqueamos el update
        if v_sesion is null then
          raise_application_error(-20002, 'ERROR, no se permiten las actualizaciones manuales'
            ||' solo dentro de un procedimiento');
        end if;
      end if;

      --verificar si se quiere actualizar a status EN VERIFICACION
      select count(*) into v_status_vehiculo
      from status_vehiculo 
      where nombre = 'CON VERIFICACIÓN PENDIENTE'
        and status_vehiculo_id = :new.status_vehiculo_id;
      
      if v_status_vehiculo = 1 then
      /*contamos cuantas notificaciones tiene el vehiculo, esta logica funciona ya que
      cada vez que el estado vuelve ser en regla las notificaciones se borran*/
      
        select count(distinct num_notificacion) into v_num_notificaciones
        from notificacion
        where vehiculo_id = :old.vehiculo_id;
        if v_num_notificaciones = 0 then 
          raise_application_error(-20003, 'ERROR, no se es necesario actualizar al status'
          ||'CON VERIFICACION PENDIENTE, aun no hay notificaciones acerca de eso');
        end if;
      end if;

      --verificar si se quiere actualizar a status LICENCIA EXPIRADA
      select count(*) into v_status_vehiculo
      from status_vehiculo 
      where nombre = 'CON LICENCIA EXPIRADA'
        and status_vehiculo_id = :new.status_vehiculo_id;

      if v_status_vehiculo = 1 then
      --contamos cuantas licencias vigentes tiene el propietario del vehiculo--
        select count(*) into v_num_licencias_vigentes
        from licencia_propietario
        where propietario_id = :old.propietario_id
          and fecha_vigencia > sysdate;

        if v_num_licencias_vigentes > 0 then
            raise_application_error(-20003, 'ERROR, no se debe actualizar el estado a '
          ||'CON LICENCIA EXPIRADA, el propietario tiene licencias vigentes');
        end if;
      end if;
    end case;
end;
/
show errors

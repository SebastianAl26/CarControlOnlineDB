--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 08/12/2024
--@Descripción: 
/*
Se desea crear un trigger que valide cuando se desea hacer una actualizacion a una placa
en un vehiculo, se debe verificar que la nueva placa exista en la base de datos y que no 
este asignada a otro auto.

Si se hace la actualización se debera marcar como inactiva la placa que se remplazara y
marcar como activa la placa que ahora tiene el vehículo 
Solo se puede cambiar el propietario si no tiene multas y se registar en el historico 
el cambio de propietario.
Tambien verificar cuando se desea borrar un vehiculo, que este vehiculo no tenga multas,
de no ser asi no se podra borrar el vehiculo hasta que pague sus multas(se eliminen).
*/
set serveroutput on
create or replace trigger tr_registro_vehiculo
after insert or delete or update of placa_id, propietario_id
on vehiculo for each row

declare 
  v_existe_placa number;
  v_es_inactiva number;
  v_num_multas number;
  v_fecha_adquisicion date;
begin

  case 
    when deleting then
      --validar que el vehiculo no tenga multas
      select count(*) into v_num_multas
      from multa
      where propietario_id = :old.propietario_id;

      if v_num_multas > 0 then
        raise_application_error(-20001,'ERROR: No se puede borrar el vehiculo, faltan pagar multas');
      end if;

    when updating('placa_id') then
      --se verifica que exista la placa en la base de datos 
      select count(*) into v_existe_placa
      from placa
      where placa_id = :new.placa_id;

      if v_existe_placa = 0 then
        raise_application_error(-20002,'ERROR: No existe la placa a la cual se quiere actualizar');
      end if;

      --se verifica que no este asociado a un vehiculo
      select es_inactiva into v_es_inactiva
      from placa 
      where placa_id = :new.placa_id;

      if v_es_inactiva = 0 then
        raise_application_error(-20003,'ERROR: La placa ya esta siendo usada por otro vehiculo');
      end if; 

      --si llega a este flujo se permite la actualizacion y se marca como inactiva la anterior
      --y como activa la que se acaba de actualizar
      update placa 
      set es_inactiva = 1
      where placa_id = :old.placa_id;

      update placa 
      set es_inactiva = 0
      where placa_id = :new.placa_id;

    when updating('propietario_id') then
      --solo puede cambiar de propietario de si no tiene multas
      select count(*) into v_num_multas
      from multa 
      where propietario_id = :old.propietario_id;
      
      if v_num_multas > 0 then
        raise_application_error(-20004,'ERROR: No se puede actualizar el propietario'|| 
          ' tiene multas pendientes');
      end if;

      --se registra el nuevo propietario del vehiculo en el historico y agrega la 
      --fecha fin del anterior
      insert into historico_propietario_vehiculo(historico_propietario_vehiculo_id, fecha_adquisicion, 
        fecha_fin, vehiculo_id, propietario_id)  
      values(historico_propietario_vehiculo_id_seq.nextval,sysdate, null, 
        :new.vehiculo_id, :new.propietario_id);
      
      update historico_propietario_vehiculo
      set fecha_fin = sysdate
      where vehiculo_id = :new.vehiculo_id
        and propietario_id = :old.propietario_id;

    when inserting then
    --marcar como activa la placa 
      update placa 
      set es_inactiva = 0
      where placa_id = :new.placa_id;

      --se registra el nuevo propietario del vehiculo en el historico
      insert into historico_propietario_vehiculo(historico_propietario_vehiculo_id, 
        fecha_adquisicion,fecha_fin,vehiculo_id, propietario_id)
      values(historico_propietario_vehiculo_id_seq.nextval, sysdate, null, 
        :new.vehiculo_id, :new.propietario_id );
  end case;
  
end;
/
show errors

--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 05/12/2024
--@Descripción: Se crean los usuarios admin e invitado y sus roles correspondientes

/*Se desea verificar que al insertar una licencia para un propietario cumpla con las
siguientes condiciones:
*Que el propietario no sobrepase las 3 licencias
*Tomar en cuenta que el propietario solo puede tener una por cada tipo
*No se debe permitir el registro de una licencia si el propietario tiene mas
de 200 puntos acumulados*/

set serveroutput on

create or replace trigger tr_valida_licencia_pr
before insert on licencia_propietario for each row
declare
  v_cantidad_licencias number;
  v_cantidad_tipos number;
  v_puntos_negativos number;
begin
    --Se verifica la cantidad de licencias del propietario
      select count(*) into v_cantidad_licencias
      from licencia_propietario
      where propietario_id = :new.propietario_id;

      if v_cantidad_licencias >= 3 then
        raise_application_error(-20001,'ERROR: El propietario ya cuenta con 
        3 licencias registradas');
      end if;

    --se verifica si existe una licencia del tipo indicado para el propietario
    --es decir no se puede ingresar otra del mismo tipo
      select count(*) into v_cantidad_tipos
      from licencia_propietario lp
      join licencia l on lp.licencia_id = l.licencia_id
      where lp.propietario_id = :new.propietario_id
      and l.tipo = (select tipo from licencia where licencia_id = :new.licencia_id);

      if v_cantidad_tipos = 1 then
        raise_application_error(-20002,'ERROR: Ya existe ese tipo de licencia que se desea ingresar');
      end if;
      
    --se verifica que la puntuacion negativa del propietario no pase de 200
      select puntos_negativos_acumulados into v_puntos_negativos
      from propietario
      where propietario_id = :new.propietario_id;

    if v_puntos_negativos >= 200 then
      raise_application_error(-20003,'ERROR: El propietario regiistrar una licencia'||
      ' debido a su puntuacionde multas no puede  ');
    end if;
end;
/
show errors


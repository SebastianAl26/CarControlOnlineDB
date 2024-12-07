--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 05/12/2024
--@Descripción: 

/*En el caso de de estudio se dice que al registrar una licencia para el tipo de 
transporte publico se debe de hacer en base a los pasajeros parados y sentados que puede
tener el vehiculo : 
tipo a -> taxis sedan comunmente 4 pasajeros sentados y 0 de pie
tipo b -> camionetas comunmente 6 a 8 pasajeros sentados y 0 de pie
tipo c -> camiones mas 8 pasajeros sentados y más de 20 de pie
EL trigger debe validar qua licencia que se asigne coincida con esas condiciones
*/

create or replace trigger tr_valida_licencia_tp
before insert 
on vehiculo_transporte_publico for each row

declare
  v_tipo_licencia varchar2(1);
  
begin
  select tipo into v_tipo_licencia
  from licencia
  where licencia_id = :new.licencia_id;

  if v_tipo_licencia = 'A' and (:new.pasajeros_sentados not between 0 and 4 
  or :new.pasajeros_parados != 0) then
    raise_application_error(20001, 'ERROR, Licencia incorrecta para el tipo de auto');
  end if;

  if v_tipo_licencia = 'B' and (:new.pasajeros_sentados not between 6 and 8 
  or :new.pasajeros_parados != 0) then
    raise_application_error(20001, 'ERROR, Licencia incorrecta para el tipo de auto');
  end if;

  if v_tipo_licencia = 'C' and (:new.pasajeros_sentados < 8 
  or :new.pasajeros_parados < 20) then
    raise_application_error(20001, 'ERROR, Licencia incorrecta para el tipo de auto');
  end if;

end;
/
show errors

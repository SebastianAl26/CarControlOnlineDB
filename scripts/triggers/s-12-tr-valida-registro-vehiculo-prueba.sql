--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 05/12/2024
--@Descripción:Se realizan las pruebas del trigger tr_valida_registro_auto

connect af_proy_admin/af@afbd_s2

set serveroutput on

Prompt ===========================================================
Prompt Prueba 1 (Negativa).
Prompt Intentando borrar un vehiculo con multas pendientes
Prompt No deberia dejar hacerlo mostrando error 
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1000, 'ZZZZZZZ', true, 1);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (500, 'LZZLA98765ZZ', 'Tovar', 'Gutierrez', 'Navarro', 
  'LOLA9R75RR', 'tovar.gut@gmail.com', 15, 1);

 insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
    es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
    status_vehiculo_id, modelo_id, propietario_id) 
  values (1501, 'BBBBBB', '2025', 1, 0, 0, 'ZZZZZZZ', 
  to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1000, 1, 1, 500);

insert into multa (propietario_id, folio, fecha_registro, descripcion, puntos_negativos, 
  documento_pdf) 
values (500, '00001', to_date('17/11/2023', 'dd/mm/yyyy'), 
  'Multa por no llevar puesto el cinturón de seguridad', 15, empty_blob());

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

  delete from vehiculo
  where vehiculo_id = 1501;
  
  --El flujo no debio seguir aqui
  raise_application_error(-20102, 'ERROR, El trigger permite eliminaciones de autos que'||
  ' su propietario tiene multas, el trigger no funciona correctamente');
  
  exception
    when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);

    if v_codigo = -20001 then
      dbms_output.put_line('El trigger no deja eliminar autos que tengan multas.');
      dbms_output.put_line('OK, PRUEBA 1 EXITOSA');
    else
      dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
      raise;
    end if;
end;
/

Prompt ==========================================================================
Prompt Prueba 2 (Positiva)
Prompt Insertando un nuevo vehiculo 
Prompt Debe actualizar la placa a activa e insertarse el vehiculo en el historico
Prompt Se espera que se hagan los cambios
Prompt ==========================================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1001, 'ZZXXXBS', true, 1);

declare
  v_count number;
begin

  insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
    es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
    status_vehiculo_id, modelo_id, propietario_id) 
  values (1505, 'BACACAC', '2025', 1, 0, 0, 'ZZZXMOZ', 
  to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1001, 1, 1, 1); 

  select count(*) into v_count
  from placa 
  where placa_id = 1001 
  and es_inactiva = 0;

  if v_count = 1 then
    dbms_output.put_line('OK, Se marco la placa ingesada como activa');
  else
    raise_application_error(-20101,' ERROR: No se esta marcando la placa como inactiva'||
      ' el trigger no esta funcionando correctamente');
  end if;

  select count(*) into v_count
  from historico_propietario_vehiculo
  where vehiculo_id = 1505
  and propietario_id = 1
  and fecha_adquisicion = sysdate
  and fecha_fin is null;

  if v_count = 1 then
    dbms_output.put_line('OK, Vehiculo registrado en el historico correctamente');
    dbms_output.put_line('OK, PRUEBA 2 EXITOSA.');
  else
    raise_application_error(-20102,' ERROR: El registro no se insertó');
  end if;
end;
/



Prompt ==========================================================================
Prompt Prueba 3 (Negativa)
Prompt Actualizando placa_id que no existe
Prompt Se espera que se hagan los cambios
Prompt ==========================================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1003, 'ZZAÑÑBS', true, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
  status_vehiculo_id, modelo_id, propietario_id) 
values (1506, 'FIUNAM', '2025', 1, 0, 0, 'ZAÑKMX', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1003, 1, 1, 1);

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

  update vehiculo
  set placa_id = 1010
  where vehiculo_id = 1506;
  
  --El flujo no debio seguir aqui
  raise_application_error(-20102, 'ERROR, Ne debio llegar aqui ni el trigger ni las las'||
  ' restricciones de referencia estan funcionando, posiblemente no haya una fk para la'||
  ' relacion entre la tabla vehículo y placa');
  
  exception
    when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);

    if v_codigo = -20002 then
      dbms_output.put_line('El trigger no deja actualizar a placas que no existen.');
      dbms_output.put_line('OK, PRUEBA 3 EXITOSA');
      --parent key not found
    elsif v_codigo = -02291 then
      dbms_output.put_line('Se esta haciendo la validacion mediante restricciones de'||
        ' referencia pero no se hace mediante el trigger');
    else
      dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
      raise;
    end if;
end;
/


Prompt ==========================================================================
Prompt Prueba 4 (Negativa)
Prompt Actualizando placa_id que ya existe y esta asignada a un auto
Prompt Se espera que se hagan los cambios
Prompt ==========================================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1008, 'ÑÑOORR', true, 1);

--placa que estaria asignada a un vehiculo
insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1010, 'HLNAOORR', false, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
  status_vehiculo_id, modelo_id, propietario_id) 
values (1507, 'FIFA24', '2025', 1, 0, 0, 'ZUUUUX', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1008, 1, 1, 1);

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

  update vehiculo
  set placa_id = 1010
  where vehiculo_id = 1507;
  
  --El flujo no debio seguir aqui
  raise_application_error(-20102, 'ERROR, Ne debio llegar aqui ni el trigger ni las las'||
  ' restricciones de referencia estan funcionando, posiblemente ya hay una fk para la'||
  ' y esta permitiendo una relacion muchos a muchos');
  
  exception
    when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);

    if v_codigo = -20003 then
      dbms_output.put_line('El trigger no deja actualizar a placas que ya existen.');
      dbms_output.put_line('OK, PRUEBA 4 EXITOSA');
      --unique constraint violated
    elsif v_codigo = -00001 then
      dbms_output.put_line('Se esta haciendo la validacion mediante restricciones de'||
        ' referencia pero no se hace mediante el trigger');
    else
      dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
      raise;
    end if;
end;
/

Prompt ==========================================================================
Prompt Prueba 5 (Positiva)
Prompt Actualizando placa_id correcto
Prompt Se espera que se hagan los cambios
Prompt ==========================================================================

--placa vieja
insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1011, 'ZZXXDACS', true, 1);

--placa nueva
insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1012, 'ZZXXDACS', true, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
  status_vehiculo_id, modelo_id, propietario_id) 
values (1510, 'BARCA', '2025', 1, 0, 0, 'CAMPEON', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1011, 1, 1, 1); 

declare
  v_count number;
begin

  update Vehiculo
  set placa_id = 1012
  where vehiculo_id = 1510;

  select count(*) into v_count
  from placa 
  where placa_id = 1012
  and es_inactiva = 0;

  if v_count = 1 then
    dbms_output.put_line('OK, Se marco la placa ingesada como activa');
  else
    raise_application_error(-20101,' ERROR: No se esta marcando la placa nueva como activa'||
      ' el trigger no esta funcionando correctamente');
  end if;

  select count(*) into v_count
  from placa
  where placa_id = 1011
  and es_inactiva = 1;

  if v_count = 1 then
    dbms_output.put_line('OK, Placa antigua actualizada correctamente');
    dbms_output.put_line('OK, PRUEBA 5 EXITOSA.');
  else
    raise_application_error(-20102,' ERROR: No se esta marcando anterior la placa como'||
      'inactiva, el trigger no esta funcionando correctamente');
  end if;
end;
/


Prompt ===========================================================
Prompt Prueba 6 (Negativa).
Prompt Intentando actualizar un propietario en vehiculo con multas pendientes
Prompt No deberia dejar hacerlo mostrando error 
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1600, 'UUUU', true, 1);

--propietario anterior
insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (508, 'LPÑLAZ', 'Owen', 'Gutierrez', 'Navarro', 
  'ÑÑLAMS', 'owen.gut@gmail.com', 15, 1);

--propietario anterior
insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (560, 'DAVID', 'David', 'Gutierrez', 'Navarro', 
  'ÑZZS', 'david.gut@gmail.com', 15, 1);

 insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
    es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
    status_vehiculo_id, modelo_id, propietario_id) 
  values (1550, 'BUUTYB', '2025', 1, 0, 0, 'ZÑLASZ', 
  to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1600, 1, 1, 508);

insert into multa (propietario_id, folio, fecha_registro, descripcion, puntos_negativos, 
  documento_pdf) 
values (508, '00001', to_date('17/11/2023', 'dd/mm/yyyy'), 
  'Multa por no llevar puesto el cinturón de seguridad', 15, empty_blob());

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

  update vehiculo
  set propietario_id = 560
  where vehiculo_id = 1550;
    
  --El flujo no debio seguir aqui
  raise_application_error(-20102, 'ERROR, El trigger permite actualizaciones de autos que'||
  ' su propietario tiene multas, el trigger no funciona correctamente');
  
  exception
    when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);

    if v_codigo = -20004 then
      dbms_output.put_line('El trigger no deja actualizar propietarios de autos'|| 
      'que tengan multas.');
      dbms_output.put_line('OK, PRUEBA 6 EXITOSA');
    else
      dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
      raise;
    end if;
end;
/


Prompt ===========================================================
Prompt Prueba 7 (Positiva).
Prompt Intentando actualizar un propietario en vehiculo con multas pendientes
Prompt No deberia dejar hacerlo mostrando error 
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1700, 'LLOOPNMJ', true, 1);

--propietario anterior
insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (511, 'AVAPLMJ', 'Diego', 'Martinez', 'Martinez', 
  'AVAPLMJPVC', 'deiguito.gut@gmail.com', 15, 1);

--nuevo propietario
insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (660, 'LLAKFEÑ', 'David', 'Gutierrez', 'Navarro', 
  'ÑUZS', 'lalos.gut@gmail.com', 15, 1);

 insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
    es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
    status_vehiculo_id, modelo_id, propietario_id) 
  values (1551, 'QWSDJAB', '2025', 1, 0, 0, 'QRRAXX', 
  to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1700, 1, 1, 511);


declare
  v_count number;
begin

  update vehiculo
  set propietario_id = 660
  where vehiculo_id = 1551;

  select count(*) into v_count
  from historico_propietario_vehiculo
  where vehiculo_id = 1551
  and propietario_id = 660
  and fecha_adquisicion = sysdate
  and fecha_fin is null;

  if v_count = 1 then
    dbms_output.put_line('OK, Se actualizo el propietario del vehiculo y se registro'||
      ' en la tabla de historico');
  else
    raise_application_error(-20102,' ERROR: El registro no se insertó');
  end if;

  select count(*) into v_count
  from historico_propietario_vehiculo
  where vehiculo_id = 1551
  and propietario_id = 511
  and fecha_fin = sysdate;
    
  if v_count = 1 then
    dbms_output.put_line('OK, Se actualizo la fecha fin para el propietario anterior'||
    ' del vehiculo en el historico');
    dbms_output.put_line('OK, PRUEBA 7 EXITOSA');
  else
    raise_application_error(-20102,' ERROR: El registro no se actualizo en el historico');
  end if;

end;
/

Prompt haciendo rollback para limpiar la BD
rollback;
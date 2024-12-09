--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 08/12/2024
--@Descripción: Prueba del procedimiento, proc_valida_emisiones_contaminantes

set serveroutput on
prompt =================================================================
prompt Prueba 1: Se insertaron de manera correcta los contaminantes a la notificacion
prompt =================================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (2000, 'ZÑ', false, 1);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (1000, 'LOLPOPXX', 'Fedrico', 'Gutierrez', 'Navarro', 
  'LOLZ345ZZ', 'campitos.gut@gmail.com', 50, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (5000, 'ABÑÑN', '2025', 1, 0, 0, 'AMB', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 2000, 1, 1, 1000); 

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (123, 0.9, to_date('5/12/2024', 'dd/mm/yyyy'), 5000, 3);

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (124, 0.9, to_date('5/12/2024', 'dd/mm/yyyy'), 5000, 2);

/*insert into notificacion (notificacion_id, num_notificacion, fecha_envio, 
  vehiculo_id, contaminante_vehiculo_id)
values(100, 1, sysdate, 5000, 123);*/

declare
  v_num_notificacion1 number;
  v_num_notificacion2 number;
  v_status_vehiculo number;
  
begin
  select count(distinct num_notificacion) into v_num_notificacion1
  from notificacion
  where vehiculo_id = 5000; 

  dbms_output.put_line('Notificaciones antes:'||v_num_notificacion1);

  begin

    proc_validacion_emisiones_contaminantes();
    
    select count(distinct num_notificacion) into v_num_notificacion2
    from notificacion
    where vehiculo_id = 5000; 

    dbms_output.put_line('Notificaciones despues:'||v_num_notificacion2);


    if v_num_notificacion1 = v_num_notificacion2 - 1 then
      dbms_output.put_line('Se mando su primera notificacion');
    end if;

    select status_vehiculo_id into v_status_vehiculo
    from vehiculo
    where vehiculo_id = 5000;  

    dbms_output.put_line('Status Actualizado:'||v_status_vehiculo);
    if v_status_vehiculo = 4 then
      dbms_output.put_line('Se actualizo el status del vehiculo a VERIFICACION PENDIENTE');
    else
      raise_application_error(-20001,'ERROR:No se actualizo el status');
    end if;

    --commit  
  end;
    
  exception
    when others then
      dbms_output.put_line('ERROR: Procedimiento no funciona correctamente');
      rollback;
end;
/
rollback;
prompt =================================================================
prompt Prueba 2: Se insertaron de manera correcta los contaminantes a la notificacion
prompt =================================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (2001, 'XX', false, 1);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (1001, 'LÑÑIU', 'Fedrico', 'Gutierrez', 'Navarro', 
  'ÑPLOA', 'americacampeon.gut@gmail.com', 50, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (5003, 'GUS', '2025', 1, 0, 0, 'AXZ', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 2001, 1, 1, 1001); 

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (126, 0.9, to_date('5/05/2023', 'dd/mm/yyyy'), 5003, 3);

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (127, 0.9, to_date('5/05/2023', 'dd/mm/yyyy'), 5003, 2);

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (128, 0.9, to_date('5/05/2023', 'dd/mm/yyyy'), 5003, 1);

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (129, 0.8, to_date('5/12/2024', 'dd/mm/yyyy'), 5003, 1);

insert into notificacion (notificacion_id, num_notificacion, fecha_envio, 
  vehiculo_id, contaminante_vehiculo_id)
values(100, 1, sysdate, 5003, 126);

insert into notificacion (notificacion_id, num_notificacion, fecha_envio, 
  vehiculo_id, contaminante_vehiculo_id)
values(101, 2, sysdate, 5003, 127);

insert into notificacion (notificacion_id, num_notificacion, fecha_envio, 
  vehiculo_id, contaminante_vehiculo_id)
values(102, 3, sysdate, 5003, 128);

declare
  v_num_notificacion1 number;
  v_num_notificacion2 number;
  v_num_multas1 number;
  v_num_multas2 number;
  v_status_vehiculo number;
  
begin
  select count(distinct num_notificacion) into v_num_notificacion1
  from notificacion
  where vehiculo_id = 5003; 

  select count(*) into v_num_multas1
  from multa
  where propietario_id = 1001;

  dbms_output.put_line('Multas antes:'||v_num_multas1);
  dbms_output.put_line('Notificaciones antes:'||v_num_notificacion1);
  
  begin

    proc_validacion_emisiones_contaminantes();
    
    select count(distinct num_notificacion) into v_num_notificacion2
    from notificacion
    where vehiculo_id = 5003; 

    dbms_output.put_line('Notificaciones despues:'||v_num_notificacion2);


    if v_num_notificacion1 = v_num_notificacion2 - 1 then
      dbms_output.put_line('Se mando su siguiente notificacion');
    else
      raise_application_error(-20005,'ERROR: No se inserto la notificacion correctamente');
    end if;

    select status_vehiculo_id into v_status_vehiculo
    from vehiculo
    where vehiculo_id = 5003;  

    dbms_output.put_line('Status Actualizado:'||v_status_vehiculo);
    if v_status_vehiculo = 4 then
      dbms_output.put_line('Se actualizo el status del vehiculo a VERIFICACION PENDIENTE');
    else
      raise_application_error(-20001,'ERROR:No se actualizo el status');
    end if;

    select count(*) into v_num_multas2
    from multa
    where propietario_id = 1001; 

    dbms_output.put_line('Multas despues:'||v_num_multas2);

    if v_num_multas1 = v_num_multas2 - 1 then
      dbms_output.put_line('Se agrego la multa por notificacion');
    else
      raise_application_error(-20002,'ERROR: No se agrego la multa');
    end if; 
    --commit  
  end;
    
  exception
    when others then
      dbms_output.put_line('ERROR: Procedimiento no funciona correctamente');
      dbms_output.put_line('ERROR: ' || SQLERRM);
      raise;
      rollback;
end;
/


Prompt haciendo rollback para limpiar la BD
rollback;
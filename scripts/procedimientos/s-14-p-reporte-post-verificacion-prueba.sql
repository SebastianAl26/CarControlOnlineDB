--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 04/12/2024
--@Descripción: Pruebas para el procedimiento p-reporte-post-verificacion

set serveroutput on
prompt ================================================================================
prompt Prueba 1: Ejecutando procedimiento cuando aun no hay medidas para esa verificacion
prompt ================================================================================
--parametros del procedimiento:
--p_vehiculo_id, p_verificacion_id, p_estado_verificacion out

--insertamos a un vehiculo y una verificacion pero aun sin medicioones en el verificentro
insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1014, 'ZZZZ', false, 1);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (400, 'PRUEBARFC', 'Pedro', 'Ramírez', 'López', 
  'PRUEBA2CURP', 'pedro.ramirez@gmail.com', 0, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (1901, 'OOOO', '2025', 1, 0, 0, 'UUUUU', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000 , 1014, 1, 1, 400); 

insert into verificacion (verificacion_id, clave_verificentro,fecha_verificacion,
  folio_verificacion,num_serie_dispo_medicion, notificacion_id, vehiculo_id)
values(345,'CLAVE',sysdate,'FOLIO','ZXZXZX',null,1901);

declare
  p_estado_verificacion number;
begin
  begin
    proc_reporte_post_verificacion(1901, 345, p_estado_verificacion);
    if p_estado_verificacion = 0 then
      dbms_output.put_line('OK, valor p_estado_verificacion correcto, no se han registrado'||
        ' valores de contaminantes en la verificacion');
    else 
      raise_application_error(-20001,'ERROR, valor p_estado_verificacion incorrecto, se esperaba 0 '||
        'no se termino el procedimiento donde se esperaba');
    end if;
  --commit
  end;

  exception
    when others then
      dbms_output.put_line('ERROR: El procedimiento no funciona');
      rollback;
end;
/


prompt =================================================================
prompt Prueba 2: Ejecutando procedimiento para un a verificacion no exitosa
prompt =================================================================
insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1015, 'XZXZX', false, 1);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (401, 'PRUEBARFC2', 'Pedro', 'Ramírez', 'López', 
  'PRUEBA3CURP', 'ped.ramirez@gmail.com', 0, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (1902, 'ÑÑÑÑ', '2025', 1, 0, 0, 'UUÑLAU', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1015, 1, 1, 401); 

insert into verificacion (verificacion_id, clave_verificentro,fecha_verificacion,
  folio_verificacion,num_serie_dispo_medicion, notificacion_id, vehiculo_id)
values(346,'CLAV1',sysdate,'FOLIO1','ZBBXBX',null,1902);

insert into contaminante_verificacion (contaminante_verificacion_id, medicion, 
  verificacion_id, contaminante_id)
values (2100, 0.9, 346, 3);

insert into contaminante_verificacion (contaminante_verificacion_id, medicion, 
  verificacion_id, contaminante_id)
values (2101, 0.7, 346, 4);

declare
  p_estado_verificacion number;
begin
  begin
    proc_reporte_post_verificacion(1902, 346, p_estado_verificacion);

    if p_estado_verificacion = -1 then
      dbms_output.put_line('OK, valor p_estado_verificacion correcto, el vehiculo no '||
        'paso la verificacion');
    else 
      raise_application_error(-20002,'ERROR, valor p_estado_verificacion incorrecto, se esperaba '||
        '-1, el procedimiento no finalizo donde deberia');
    end if;
    --commit
  end;

  exception
    when others then
      dbms_output.put_line('ERROR: Procedimiento no funciona');
      rollback;
  
end;
/

prompt =================================================================
prompt Prueba 3: Caso de verificacion exitosa, se actualizara el status 
prompt del vehiculo a EN REGLA, se borraran sus notificaciones, sus multas
prompt generadas por acumulacion de notificaciones y se otorgara el permiso 
prompt para volver a tener la licencia
prompt =================================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1016, 'XZXXSHD', false, 1);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (402, 'PRUEBARFC3', 'Pedro', 'Ramírez', 'López', 
  'PRBAA3CURP', 'alamirez@gmail.com', 200, 0);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status,precio , placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (1904, '10023H32', '2025', 1, 0, 0, 'IIMASUNAM', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1016, 1, 1, 402); 

update vehiculo
set status_vehiculo_id = 3
where vehiculo_id = 1904; 

insert into notificacion (notificacion_id, num_notificacion, fecha_envio, vehiculo_id, 
  contaminante_vehiculo_id)
values(700,1,sysdate,1904,1);

insert into verificacion (verificacion_id, clave_verificentro,fecha_verificacion,
  folio_verificacion,num_serie_dispo_medicion, notificacion_id, vehiculo_id)
values(347,'CLAV5',sysdate,'FOLIO5','ZXXXBX',700,1904);

insert into contaminante_verificacion (contaminante_verificacion_id, medicion, 
  verificacion_id, contaminante_id)
values (2105, 0.2, 347, 3);

insert into contaminante_verificacion (contaminante_verificacion_id, medicion, 
  verificacion_id, contaminante_id)
values (2106, 0.2, 347, 4);

insert into multa (propietario_id, folio, fecha_registro, descripcion, puntos_negativos, 
  documento_pdf) 
values (402, '00001', to_date('17/11/2023', 'dd/mm/yyyy'), 
  'Multa por hacer caso omiso a las notificaciones de verificacion', 15, empty_blob());

declare
  p_estado_verificacion number;
  v_count number;
  v_num_notificaciones number;
  v_num_multas number;
  v_num_puntos_acumulados1 number;
  v_num_puntos_acumulados2 number;
begin
  begin
    --puntos negativos antes de que se llame al procedimiento(se usa despues)
    select puntos_negativos_acumulados into v_num_puntos_acumulados1
    from propietario
    where propietario_id = 402;

    proc_reporte_post_verificacion(1904, 347, p_estado_verificacion);
      
    if p_estado_verificacion = 1 then
      dbms_output.put_line('OK, valor p_estado_verificacion correcto, el vehiculo '||
        'paso la verificacion');
      
      --se verifica que se haya ctualizao a en regla
      select count(*) into v_count
      from vehiculo 
      where vehiculo_id = 1904 and
        status_vehiculo_id = 1;
      
      if v_count = 1 then
        dbms_output.put_line('OK, status del vehiculo actualizado a EN REGLA');
      else 
        raise_application_error(-20003,'ERROR, no se actualizo el status vehiculo');
      end if;

      select count(*) into v_num_notificaciones
      from notificacion
      where vehiculo_id = 1904;
      
      --se verifica el numero de notificaciones
      if v_num_notificaciones = 0 then
        dbms_output.put_line('OK, se eliminaron correctamente las notifiaciones que '||
        'generaron la verificación');
      else 
        raise_application_error(-20004,'ERROR, no se estan borrando las notificaciones de la verificaicon');
      end if;
      
      --se verifca el numero de multas generadas por notficaciones de verificacion 
      select count(*) into v_num_multas
      from multa
      where propietario_id = 402;

      if v_num_multas = 0 then
        dbms_output.put_line('OK, se eliminaron correctamente las multas que '||
        'generaron la verificación');
      else 
        raise_application_error(-20005,'ERROR, no se estan borrando las multas de la verificaicon');
      end if;

  
      select puntos_negativos_acumulados into v_num_puntos_acumulados2
      from propietario
      where propietario_id = 402;

      if v_num_puntos_acumulados2 = v_num_puntos_acumulados1 - 15 then
        dbms_output.put_line('OK, se eliminaron correctamente las puntos de las multas que '||
        'generaron las notificaciones');
      else 
        raise_application_error(-20006,'ERROR, no se estan restando los puntos de las multas borradas');
      end if;

      --se verifica que se haya vuelto a otrogar permiso de tener licencia al propietario
      select count(*) into v_count
      from propietario 
      where propietario_id = 402 and
        con_derecho_a_licencia = 1;
      
      if v_count = 1 then
        dbms_output.put_line('OK, se volvio a dar permiso de tener licencia al propietario');
      else 
        raise_application_error(-20007,'ERROR, no se dio permis al propietario de volver a tener licencia ');
      end if;

    else 
      dbms_output.put_line('ERROR, valor p_estado_verificacion incorrecto, se esperaba '||
        '1, el procedimiento no funciona correctamente');
    end if;
    --commit
  end;

  exception
    when others then
      dbms_output.put_line('ERROR, Procedimiento no funciona');
      rollback;

end;
/ 
show errors

Prompt haciendo rollback para limpiar la BD
rollback;
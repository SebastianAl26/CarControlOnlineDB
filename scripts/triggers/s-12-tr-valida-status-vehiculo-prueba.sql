--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 05/12/2024
--@Descripción: Se hacen las validaaciones necesarias para el trigger valida status vehiculo

connect af_proy_admin/af@afbd_s2

set serveroutput on

Prompt ===========================================================
Prompt Prueba 1 (Camino feliz).
Prompt Insertando un nuevo vehiculo con status EN REGLA
Prompt Deberia dejar insertarlo sin problema
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1000, 'ZZZZZZZ', false, 1);

declare
  v_count number;
begin
  insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
    es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
    status_vehiculo_id, modelo_id, propietario_id) 
  values (1501, 'BBBBBB', '2025', 1, 0, 0, 'ZZZZZZZ', 
  to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1000, 1, 1, 1); 

  select count(*) into v_count
  from vehiculo
  where vehiculo_id = 1501
  and placa_id = 1000
  and status_vehiculo_id = 1;

  if v_count = 1 then
    dbms_output.put_line('OK, Vehiculo registrado, su status es en regla');
    dbms_output.put_line('OK, PRUEBA 1 EXITOSA.');
  else
    raise_application_error(-20101,' ERROR: El registro no se insertó');
  end if;
  
end;
/

Prompt ===========================================================
Prompt Prueba 2 (Mal Camino).
Prompt Insertando un nuevo vehiculo con status incorrecto 
Prompt No debe dejar insertarlo ya que al ser nuevo debe ser EN REGLA
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1011, 'ZXZXZXZX', false, 1);

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
  status_vehiculo_id,modelo_id, propietario_id)
values (1601, 'BABABA', '2025', 1, 0, 0, 'ZAZAZAZ', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1011, 2, 1, 1); 

--El trigger no debio llegar aqui
  raise_application_error(-20102,
    ' SE DETECTO UN ERROR: Status no valido.'
    || ' El trigger no está funcionando correctamente :(');

exception
  when others then
  v_codigo := sqlcode;
  v_mensaje := sqlerrm;
  dbms_output.put_line('Codigo:  ' || v_codigo);
  dbms_output.put_line('Mensaje: ' || v_mensaje);

  if v_codigo = -20001 then
    dbms_output.put_line('OK, VEHICULO NO REGISTRADO, STATUS INGRESADO INCORRECTO.');
    dbms_output.put_line('OK, PRUEBA 2 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 3 (Camino Feliz).
Prompt Actualizar el registro status de manera manual no deberia permitirlo
Prompt No debe dejar insertarlo ya que eso lo debe hacer el procedimiento
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1012, 'ÑLMLOP', false, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
  status_vehiculo_id,modelo_id, propietario_id) 
values (1701, 'BÑBKBZ', '2025', 1, 0, 0, 'XZXZXZM', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1012, 1, 1, 1); 

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

update vehiculo
set status_vehiculo_id = 1 
where vehiculo_id = 1701;

--El trigger no debio llegar aqui
  raise_application_error(-20102,
    ' SE DETECTO UN ERROR: Status no deberia poder cambiarse de manera manual.'
    || ' El trigger no está funcionando correctamente :(');

exception
  when others then
  v_codigo := sqlcode;
  v_mensaje := sqlerrm;
  dbms_output.put_line('Codigo:  ' || v_codigo);
  dbms_output.put_line('Mensaje: ' || v_mensaje);

  if v_codigo = -20002 then
    dbms_output.put_line('OK, VEHICULO NO ACTUALIZADO, STATUS INGRESADO MANUALMENTE NO PERMITIDO.');
    dbms_output.put_line('OK, PRUEBA 3 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 4 (Mal Camino).
Prompt Actualizar a status CON VERIFICACION PENDIENTE debe tener alguna notificacion
Prompt No tiene notificacion no debe cambiar el status a Verificacion pendiente
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1013, 'ÑLMXSZ', false, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
  status_vehiculo_id,modelo_id, propietario_id) 
values (1801, 'AACXBBZ', '2025', 1, 0, 0, 'YYTRGL', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1013, 1, 1, 1); 

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

update vehiculo
set status_vehiculo_id = 4
where vehiculo_id = 1801;

--El trigger no debio llegar aqui
  raise_application_error(-20102,
    ' SE DETECTO UN ERROR: Status no deberia poder cambiarse si no hay notificaciones.'
    || ' El trigger no está funcionando correctamente :(');

exception
  when others then
  v_codigo := sqlcode;
  v_mensaje := sqlerrm;
  dbms_output.put_line('Codigo:  ' || v_codigo);
  dbms_output.put_line('Mensaje: ' || v_mensaje);

  if v_codigo = -20003 then
    dbms_output.put_line('OK, VEHICULO NO ACTUALIZADO, STATUS INGRESADO NO NECESARIO.');
    dbms_output.put_line('OK, PRUEBA 4 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 5 (Mal Camino).
Prompt Actualizar a status CON LICENCIA EXPIRADA debe tener alguna licenica expirada
Prompt No tiene licencia expirada no debe dejar cambiar el status
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1014, 'ZZZZ', false, 1);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (400, 'PRUEBARFC', 'Pedro', 'Ramírez', 'López', 
  'PRUEBA2CURP', 'pedro.ramirez@gmail.com', 0, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
  status_vehiculo_id,modelo_id, propietario_id) 
values (1901, 'OOOO', '2025', 1, 0, 0, 'UUUUU', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1014, 1, 1, 400); 

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (255, '112234', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('16/07/2030','dd/mm/yyyy'), null, 400, 1);

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

update vehiculo
set status_vehiculo_id = 2
where vehiculo_id = 1901;

--El trigger no debio llegar aqui
  raise_application_error(-20102,
    ' SE DETECTO UN ERROR: Status no deberia poder cambiarse si no hay licencias expiradas.'
    || ' El trigger no está funcionando correctamente :(');

exception
  when others then
  v_codigo := sqlcode;
  v_mensaje := sqlerrm;
  dbms_output.put_line('Codigo:  ' || v_codigo);
  dbms_output.put_line('Mensaje: ' || v_mensaje);

  if v_codigo = -20003 then
    dbms_output.put_line('OK, VEHICULO NO ACTUALIZADO, STATUS INGRESADO NO NECESARIO.');
    dbms_output.put_line('OK, PRUEBA 5 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 6 (Buen Camino).
Prompt Actualizar a status CON VERIFICACION PENDIENTE debe tener alguna notificacion
Prompt Tiene notificacion si debe cambiar el status a Verificacion pendiente
Prompt ===========================================================


insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1016, 'IIII', false, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
  status_vehiculo_id,modelo_id, propietario_id) 
values (1888, 'RRRR', '2025', 1, 0, 0, 'SSSS', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1016, 1, 1, 1); 

insert into notificacion (notificacion_id, num_notificacion, fecha_envio, vehiculo_id, 
  contaminante_vehiculo_id)
values(1200,1,sysdate,1888,1);

declare
  v_cantidad_vehiculo number;
begin

  update vehiculo
  set status_vehiculo_id = 4
  where vehiculo_id = 1888;

  select count(*) into v_cantidad_vehiculo
  from vehiculo
  where vehiculo_id = 1888
  and placa_id = 1016
  and status_vehiculo_id = 4;

  if v_cantidad_vehiculo = 1 then
    dbms_output.put_line('OK, STATUS ACTUALIZADO, STATUS NECESARIO');
    dbms_output.put_line('OK, PRUEBA 6 EXITOSA.');
  else
    raise_application_error(-20101,' ERROR: El registro no se insertó');
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 7 (Buen Camino).
Prompt Actualizar a status CON LICENCIA EXPIRADA debe tener alguna licencia expirada
Prompt Tiene licencia expirada si debe cambiar el status Licencia expirada
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1018, 'QQQQ', false, 1);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados, con_derecho_a_licencia) 
values (116, 'HOLARFC', 'Franklin', 'Ramírez', 'López', 
  'ADIOSCURP', 'franklin.ramirez@gmail.com', 0, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, precio, placa_id, 
  status_vehiculo_id,modelo_id, propietario_id) 
values (1999, 'WWWA', '2025', 1, 0, 0, 'ÑLKJH', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, 1018, 1, 1, 116); 

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (234, '11223344', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('16/07/2003','dd/mm/yyyy'), null, 116, 1);

declare
  v_cantidad_vehiculo number;
begin

  update vehiculo
  set status_vehiculo_id = 2
  where vehiculo_id = 1999;

  select count(*) into v_cantidad_vehiculo
  from vehiculo
  where vehiculo_id = 1999
  and placa_id = 1018
  and status_vehiculo_id = 2;

  if v_cantidad_vehiculo = 1 then
    dbms_output.put_line('OK, STATUS ACTUALIZADO, STATUS NECESARIO');
    dbms_output.put_line('OK, PRUEBA 7 EXITOSA.');
  else
    raise_application_error(-20101,' ERROR: El registro no se actualizo');
  end if;
end;
/


Prompt haciendo rollback para limpiar la BD
rollback;
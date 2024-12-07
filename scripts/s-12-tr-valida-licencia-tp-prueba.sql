--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 05/12/2024
--@Descripción: Se hacen las validaaciones necesarias para el trigger licencia tp

connect af_proy_admin/af@afbd_s2

set serveroutput on

Prompt ===========================================================
Prompt Prueba 1 (Camino feliz).
Prompt Insertando vehiculos de cada tipo de licencia con pasajeros correctos
Prompt Tipo A
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1000, 'ZZZZZZZ', false, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (1501, 'BBBBBB', '2025', 1, 0, 0, 'ZZZZZZZ', 
to_date('01/07/2023', 'dd/mm/yyyy'), 1000, 1, 1, 1); 


declare
  v_cantidad_vehiculos number;
begin

  insert into vehiculo_transporte_publico (vehiculo_id, pasajeros_sentados, 
    pasajeros_parados, licencia_id) 
  values (1501, 4, 0, 1);

  select count(*) into v_cantidad_vehiculos
  from vehiculo_transporte_publico
  where vehiculo_id = 1501
    and pasajeros_parados = 0
    and pasajeros_sentados = 4;

  if v_cantidad_vehiculos = 1 then
    dbms_output.put_line('OK, VEHICULOS INSERTADOS');
    dbms_output.put_line('OK, PRUEBA 1 EXITOSA.');
  else
    raise_application_error(-20101,' ERROR: El registro no se insertó');
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 2 (Mal Camino).
Prompt Insertando pasajeros parados incorrectos para licencia tipo A
Prompt Tipo A
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1011, 'ZXZXZXZX', false, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (1601, 'BABABA', '2025', 1, 0, 0, 'ZAZAZAZ', 
to_date('01/07/2023', 'dd/mm/yyyy'), 1011, 1, 1, 1); 

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

  insert into vehiculo_transporte_publico (vehiculo_id, pasajeros_sentados, 
    pasajeros_parados, licencia_id) 
  values (1601, 4, 1, 1);

--El trigger no debio llegar aqui
  raise_application_error(-20102,
    ' SE DETECTO UN ERROR: Licencia no valida.'
    || ' El trigger no está funcionando correctamente :(');

exception
  when others then
  v_codigo := sqlcode;
  v_mensaje := sqlerrm;
  dbms_output.put_line('Codigo:  ' || v_codigo);
  dbms_output.put_line('Mensaje: ' || v_mensaje);

  if v_codigo = -20005 then
    dbms_output.put_line('OK, VEHICULO NO REGISTRADO, PASAJEROS PARADOS INCORRECTOS.');
    dbms_output.put_line('OK, PRUEBA 2 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 3 (Mal Camino).
Prompt Insertando pasajeros parados incorrectos para licencia tipo B
Prompt Tipo B
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1012, 'AMAMAMAM', false, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (1701, 'ÑMÑMÑMÑ', '2025', 1, 0, 0, 'POPOPOPO', 
to_date('01/07/2023', 'dd/mm/yyyy'), 1012, 1, 1, 1); 

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

  insert into vehiculo_transporte_publico (vehiculo_id, pasajeros_sentados, 
    pasajeros_parados, licencia_id) 
  values (1701, 6, 1, 2);

--El trigger no debio llegar aqui
  raise_application_error(-20102,
    ' SE DETECTO UN ERROR: Licencia no valida.'
    || ' El trigger no está funcionando correctamente :(');

exception
  when others then
  v_codigo := sqlcode;
  v_mensaje := sqlerrm;
  dbms_output.put_line('Codigo:  ' || v_codigo);
  dbms_output.put_line('Mensaje: ' || v_mensaje);

  if v_codigo = -20006 then
    dbms_output.put_line('OK, VEHICULO NO REGISTRADO, PASAJEROS PARADOS INCORRECTOS.');
    dbms_output.put_line('OK, PRUEBA 3 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 4 (Mal Camino).
Prompt Insertando pasajeros parados incorrectos para licencia tipo C
Prompt Tipo C
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1013, 'LOLOLOL', false, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (1801, 'BBAASSAA', '2025', 1, 0, 0, 'YTYTYTYT', 
to_date('01/07/2023', 'dd/mm/yyyy'), 1013, 1, 1, 1); 

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

  insert into vehiculo_transporte_publico (vehiculo_id, pasajeros_sentados, 
    pasajeros_parados, licencia_id) 
  values (1801, 8, 0, 3);

--El trigger no debio llegar aqui
  raise_application_error(-20102,
    ' SE DETECTO UN ERROR: Licencia no valida.'
    || ' El trigger no está funcionando correctamente :(');

exception
  when others then
  v_codigo := sqlcode;
  v_mensaje := sqlerrm;
  dbms_output.put_line('Codigo:  ' || v_codigo);
  dbms_output.put_line('Mensaje: ' || v_mensaje);

  if v_codigo = -20007 then
    dbms_output.put_line('OK, VEHICULO NO REGISTRADO, PASAJEROS PARADOS INCORRECTOS.');
    dbms_output.put_line('OK, PRUEBA 4 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 5 (Mal Camino).
Prompt Insertando pasajeros sentados incorrectos para licencia tipo A
Prompt Tipo A
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1100, 'LO', false, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (2000, 'AB', '2025', 1, 0, 0, 'YT', 
to_date('01/07/2023', 'dd/mm/yyyy'), 1100, 1, 1, 1); 

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

  insert into vehiculo_transporte_publico (vehiculo_id, pasajeros_sentados, 
    pasajeros_parados, licencia_id) 
  values (2000, 5, 0, 1);

--El trigger no debio llegar aqui
  raise_application_error(-20102,
    ' SE DETECTO UN ERROR: Licencia no valida.'
    || ' El trigger no está funcionando correctamente :(');

exception
  when others then
  v_codigo := sqlcode;
  v_mensaje := sqlerrm;
  dbms_output.put_line('Codigo:  ' || v_codigo);
  dbms_output.put_line('Mensaje: ' || v_mensaje);

  if v_codigo = -20005 then
    dbms_output.put_line('OK, VEHICULO NO REGISTRADO, PASAJEROS SENTADOS INCORRECTOS.');
    dbms_output.put_line('OK, PRUEBA 5 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 6 (Mal Camino).
Prompt Insertando pasajeros sentados incorrectos para licencia tipo B
Prompt Tipo B
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1101, 'LO', false, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (2001, 'ABMLN', '2025', 1, 0, 0, 'YTZÑÑ', 
to_date('01/07/2023', 'dd/mm/yyyy'), 1101, 1, 1, 1); 

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

  insert into vehiculo_transporte_publico (vehiculo_id, pasajeros_sentados, 
    pasajeros_parados, licencia_id) 
  values (2001, 5, 0, 2);

--El trigger no debio llegar aqui
  raise_application_error(-20102,
    ' SE DETECTO UN ERROR: Licencia no valida.'
    || ' El trigger no está funcionando correctamente :(');

exception
  when others then
  v_codigo := sqlcode;
  v_mensaje := sqlerrm;
  dbms_output.put_line('Codigo:  ' || v_codigo);
  dbms_output.put_line('Mensaje: ' || v_mensaje);

  if v_codigo = -20006 then
    dbms_output.put_line('OK, VEHICULO NO REGISTRADO, PASAJEROS SENTADOS INCORRECTOS.');
    dbms_output.put_line('OK, PRUEBA 6 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 7 (Mal Camino).
Prompt Insertando pasajeros sentados incorrectos para licencia tipo C
Prompt Tipo C
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (1110, 'ZÑ', false, 1);

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (2100, 'ABZKKL', '2025', 1, 0, 0, 'YTZZKKÑ', 
to_date('01/07/2023', 'dd/mm/yyyy'), 1110, 1, 1, 1); 

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

  insert into vehiculo_transporte_publico (vehiculo_id, pasajeros_sentados, 
    pasajeros_parados, licencia_id) 
  values (2100, 5, 20, 3);

--El trigger no debio llegar aqui
  raise_application_error(-20102,
    ' SE DETECTO UN ERROR: Licencia no valida.'
    || ' El trigger no está funcionando correctamente :(');

exception
  when others then
  v_codigo := sqlcode;
  v_mensaje := sqlerrm;
  dbms_output.put_line('Codigo:  ' || v_codigo);
  dbms_output.put_line('Mensaje: ' || v_mensaje);

  if v_codigo = -20007 then
    dbms_output.put_line('OK, VEHICULO NO REGISTRADO, PASAJEROS SENTADOS INCORRECTOS.');
    dbms_output.put_line('OK, PRUEBA 7 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/
Prompt hacemos rollback para limpiar la BD
rollback;
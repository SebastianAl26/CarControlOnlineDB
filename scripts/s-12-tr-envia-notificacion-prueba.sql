
Prompt ===========================================================
Prompt Prueba 1 (Camino feliz).
Prompt Se inserta una medicion de contaminante que no genera notificacion
Prompt contaminante_id = 2
Prompt ===========================================================

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (100, 'ZXZX', false, 12);  

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (1000, 'PPP', '2021', 0, 0, 1, 'ZZZ', 
to_date('02/11/2023', 'dd/mm/yyyy'), 100, 1, 10, 1); 

declare
  v_count number;
begin

  insert into contaminante_vehiculo(contaminante_vehiculo_id, medicion, fecha_registro,
    contaminante_id, vehiculo_id) 
  values (1001, 0.5,sysdate, 2, 1000);

  select count(*) into v_count
  from contaminante_vehiculo
  where vehiculo_id = 1000
    and contaminante_id = 2
    and medicion = 0.5;

  if v_count = 1 then
    dbms_output.put_line('OK, Contaminante registrado');
    dbms_output.put_line('OK, PRUEBA 1 EXITOSA.');
  else
    raise_application_error(-20101,' ERROR: El registro no se insertó');
  end if;
end;
/
rollback;
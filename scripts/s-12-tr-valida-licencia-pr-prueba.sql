--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 05/12/2024
--@Descripción: Se hacen las validaaciones necesarias para el trigger licencia prueba pr

connect af_proy_admin/af@afbd_s2

set serveroutput on

Prompt ===========================================================
Prompt Prueba 1 (Camino feliz).
Prompt Insertando una licencia valida de tipo A
Prompt con 2 licencias tipo B y C ya registradas
Prompt ===========================================================

insert into propietario values (
  1005, 'RFCLNMBVS', 'Kiliano', 'Ferrera', 'Guadarrama',
  null, 'kili@gmail.com', 0, 1
);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, 'cccc', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('10/10/2030','dd/mm/yyyy'), null, 1005, 2);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, 'zzzz', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('10/10/2030','dd/mm/yyyy'), null, 1005, 3);


declare
  v_cantidad_licencias number;
begin

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, 'ññññ', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('10/10/2030','dd/mm/yyyy'), null, 1005, 1);

  select count(*) into v_cantidad_licencias
  from licencia_propietario
  where propietario_id = 1005
  and licencia_id = 1
  group by propietario_id;

  if v_cantidad_licencias = 1 then
    dbms_output.put_line('OK, LICENCIA REGISTRADA');
    dbms_output.put_line('OK, PRUEBA 1 EXITOSA.');
  else
    raise_application_error(-20101,' ERROR: El registro no se insertó');
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 2 (Mal Camino).
Prompt Insertando una licencia invalida de tipo A
Prompt con 2 licencias tipo A y B ya registradas
Prompt ===========================================================

insert into propietario values (
  1001, 'RFCKILIANO12', 'Aldo', 'Altamirano', 'Guadarrama',
  null, 'carlo@gmail.com', 0, 1
);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '4444', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('10/10/2030','dd/mm/yyyy'), null, 1001, 1);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '5555', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('10/10/2030','dd/mm/yyyy'), null, 1001, 2);

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '6666', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('10/10/2030','dd/mm/yyyy'), null, 1001, 1);

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

  if v_codigo = -20002 then
    dbms_output.put_line('OK, LICENCIA NO REGISTRADA.');
    dbms_output.put_line('OK, PRUEBA 2 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 3 (Mal Camino).
Prompt Insertando mas de 3 licencias
Prompt con 3 licencias tipo A, B y C ya registradas
Prompt ===========================================================

insert into propietario values (
  1002, 'RFCLÑKIOP', 'Aldo', 'Altamirano', 'Guadarrama',
  null, 'ferrera@gmail.com', 0, 1
);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '448987', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('10/10/2030','dd/mm/yyyy'), null, 1002, 1);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '5678', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('10/10/2030','dd/mm/yyyy'), null, 1002, 2);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '555676', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('10/10/2030','dd/mm/yyyy'), null, 1002, 3);

declare
  v_codigo number;
  v_mensaje varchar2(1000);
begin

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '6345', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('10/10/2030','dd/mm/yyyy'), null, 1002, 1);

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

  if v_codigo = -20001 then
    dbms_output.put_line('OK, LICENCIA NO REGISTRADA.');
    dbms_output.put_line('OK, PRUEBA 3 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt ===========================================================
Prompt Prueba 4 (Mal Camino).
Prompt Insertando una licencia valida cuando el propietario tiene 200 puntos acumulados
Prompt ===========================================================

insert into propietario values (
  1003, 'RFCKAMSN', 'Kiliano', 'Ferrera', 'Guadarrama',
  null, 'guadarrama@gmail.com', 200, 0
);

declare
  v_cantidad_puntos number;
  v_codigo number;
  v_mensaje varchar2(1000);
begin

  insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
    huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
    propietario_id, licencia_id)
  values (licencia_propietario_id_seq.nextval, '2123', empty_blob(), empty_blob(), 
    empty_blob(), empty_blob(), to_date('10/10/2030','dd/mm/yyyy'), null, 1003, 1);

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

  if v_codigo = -20003 then
    dbms_output.put_line('OK, LICENCIA NO REGISTRADA.');
    dbms_output.put_line('OK, PRUEBA 4 EXITOSA.');
  else
    dbms_output.put_line('ERROR, se obtuvo otro tipo de excepcion');
    raise;
  end if;
end;
/

Prompt hacemos rollback para limpiar la BD 
rollback;


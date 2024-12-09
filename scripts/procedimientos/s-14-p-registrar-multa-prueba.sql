--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 04/12/2024
--@Descripción: Pruebas para el procedimiento p-registrar-multa

set serveroutput on
prompt =================================================================
prompt Prueba 1: Insertando una multa que no provoca perdida de licencia
prompt =================================================================
--parametros del procedimiento:
--p_propietario_id, p_mensaje, p_puntos_negativos  
--p_num_multas out y p_perdida_licencias out
declare
  v_mensaje varchar2(100);
  v_puntaje_propietario_1 number;
  v_num_multas number; 
  v_puntaje_propietario_2 number;
  p_num_multas number;
  p_perdida_licencias number;

begin
  --puntaje propietario antes de lanzar procedimiento
  begin
    select puntos_negativos_acumulados into v_puntaje_propietario_1
    from propietario
    where propietario_id = 1;

    v_mensaje := 'Multa por saltarse un semaforo rojo';
    dbms_output.put_line('Registrando una multa: propietario_id = 1');
    proc_registra_multa(1, v_mensaje, 20, p_num_multas, p_perdida_licencias);

    select puntos_negativos_acumulados into v_puntaje_propietario_2
    from propietario
    where propietario_id = 1;

    select count(*) into v_num_multas
    from multa 
    where propietario_id = 1;
    
    if v_num_multas = p_num_multas then 
      dbms_output.put_line('OK, Cantidad de multas correctos');

      if v_puntaje_propietario_1 + 20 = v_puntaje_propietario_2 then
        dbms_output.put_line('OK, Se actualiza correctamente el puntaje negativo');
      else 
        raise_application_error(-20008,'ERROR, No se esta actualizando bien el punataje negativo del'||
        ' propietario');
      end if; 

    else
      raise_application_error(-20009,'ERROR, No se esta registrando correctamente la multa'||
        ' del propietario');
    end if;
    --commit  
  end;

  exception
    when others then
      dbms_output.put_line('ERROR: Procedimiento no funciona correctamente');
      rollback;
end;
/

prompt ======================================================================
prompt Prueba 2: Insertando una multa que genere la perdida de licencias
prompt =====================================================================

--parametros del procedimiento:
--p_propietario_id, p_mensaje, p_puntos_negativos  
--p_num_multas out y p_perdida_licencias out
declare
  v_mensaje varchar2(100);
  v_puntaje_propietario_1 number;
  v_num_multas number; 
  v_puntaje_propietario_2 number; 
  v_num_licencias number; 
  v_derecho_licencia number;
  p_num_multas number;
  p_perdida_licencias number;

begin
  begin
  --puntaje propietario antes de lanzar procedimiento
    select puntos_negativos_acumulados into v_puntaje_propietario_1
    from propietario
    where propietario_id = 1;

    v_mensaje := 'Multa por chocar un poste';
    dbms_output.put_line('Registrando una multa: propietario_id = 1');
    proc_registra_multa(1, v_mensaje, 200, p_num_multas, p_perdida_licencias);

    --puntaje propietario despues de lanzar procedimiento
    select puntos_negativos_acumulados into v_puntaje_propietario_2
    from propietario
    where propietario_id = 1;

    --contamos cantidad de licencias despues de lanzar procedimiento
    select count(*) into v_num_licencias
    from licencia_propietario
    where propietario_id = 1;

    select count(*) into v_num_multas
    from multa 
    where propietario_id = 1;


    if v_num_multas = p_num_multas then 
      dbms_output.put_line('OK, Cantidad de multas correctos');
      
      if v_puntaje_propietario_1 + 200 = v_puntaje_propietario_2 then
        dbms_output.put_line('OK, Se actualiza correctamente el puntaje negativo');
      else 
        raise_application_error(-20010,'ERROR, No se esta actualizando bien el punataje negativo del'||
        ' propietario');
      end if; 

    else
      raise_application_error(-20011,'ERROR, No se esta registrando correctamente la multa'||
        ' del propietario');
    end if;

  
    if p_perdida_licencias = 1 then

      if v_num_licencias = 0 then
        dbms_output.put_line('OK, Licencias borradas correctamente');
      else
        raise_application_error(-20012,'ERROR, No se estan eliminando correctamente las licencias');
      end if;

    else 
      raise_application_error(-20013,'ERROR, se esperaba el valor p_perdida_licencias = 1');
    end if;
    
    select con_derecho_a_licencia into v_num_licencias
    from propietario
    where propietario_id = 1; 
    
    if v_num_licencias = 0 then
      dbms_output.put_line('OK, Permiso para licencia actualizado correctamente');
    else
      raise_application_error(-20014,'ERROR: NO se actualizo el permiso a licencia');
    end if;  
    --commit
  end;
  exception
    when others then
      dbms_output.put_line('ERROR: Procedimiento no funciona correctamente');
      rollback;
end;
/

Prompt haciendo rollback para limpiar la BD
rollback;
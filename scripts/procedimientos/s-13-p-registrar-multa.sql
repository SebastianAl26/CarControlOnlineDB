--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 05/12/2024
--@Descripción: 
/*El procedimiento acceptara los siguientes parametros de entrada y salida: 
p_propietario_id, p_mensaje, p_puntos_negativos  
p_num_multas out y p_perdida_licencias out(bandera que indica si el propietario ha perdido 
sus licencias).
El procedimiento debe registrar una multa al propietario indicado y actualizar su cantidad
de puntos negatuvos acumulados de acuerdo al puntaje de la multa, ademas si esa nueva
multa registrada ocasiona que la cantidad de puntos negativos acumulados sea mayor a 200,
el propietario perdera el derecho a tener licencias y las licencias que tenga seran
eliminadas de la base de datos.*/

create or replace procedure proc_registra_multa(
  p_propietario_id number, p_mensaje varchar2, p_puntos_negativos number,
  p_num_multas out number, p_perdida_licencias out number
) is
v_puntos_negativos_propietario number;

begin 
  /*primero se obtiene el numero de multas de un propietario si es que hay y 
  en base a eso se puede saber folio siguiente*/

  select count(*) into p_num_multas
  from multa 
  where propietario_id = p_propietario_id;

  p_num_multas := p_num_multas + 1;


  --Se inserta el registro de multa y se actualizan los puntos del propietario
  insert into multa(propietario_id, folio, fecha_registro, descripcion, 
    puntos_negativos, documento_pdf)
  values(p_propietario_id, p_num_multas, sysdate, p_mensaje, p_puntos_negativos,
    empty_blob());

  update propietario 
  set puntos_negativos_acumulados = puntos_negativos_acumulados + p_puntos_negativos
  where propietario_id = p_propietario_id;

  /*Se hace la validacion de los puntos negativos del propietario y se retiran las 
  licencias si es necesario*/
  select puntos_negativos_acumulados into v_puntos_negativos_propietario
  from propietario
  where propietario_id = p_propietario_id;

  if v_puntos_negativos_propietario >= 200 then 
    update propietario 
    set con_derecho_a_licencia = 0;
    p_perdida_licencias := 1;

    delete from licencia_propietario
    where propietario_id = p_propietario_id;
  else
    p_perdida_licencias := 0; 
  end if;


end;
/
show errors

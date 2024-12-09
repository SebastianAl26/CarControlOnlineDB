--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 05/12/2024
--@Descripción:
/*Proc para actualizar el status del vehiculo dependiendo de los resultados de
las mediciones de contaminantes en el verificentro 

Procedimientos para realizar cambios despues de la verificacion, se decidio crear
un procedimiento que valide y si es necesario haga los siguientes cambios despues de 
el proceso de verificacion.
*Se deben verificar las mediciones realizadas en el verificentro y si cumplen con una
medida establecida se debe actualizar el status del vehiculo a EN REGLA
*En caso de que la verificacion haya sido ocasionada por una notificacion y si se pasan
las medidas del verificentro se deben de eliminar esa notificacion o notificaciones
*Si el propterio tuvo multas por caso omiso a notificaciones, 
estas deben de eliminarse y se tiene que actualizar su puntaje nagativo acumulado y si es 
necesario y posible volver a otorgar el derecho a tener licencia.*/


create or replace procedure proc_reporte_post_verificacion(
  p_vehiculo_id number, p_verificacion_id number, p_estado_verificacion out number
) is

v_cantidad_registros number;
v_suma_contaminantes number;
v_existe_notificacion number;
v_num_multas number;
v_propietario_id number;
v_puntos_negativos_multas number;
v_puntos_negativos_propietario number;
v_puntaje_negativo_actualizado number;

--Obtenemos los contaminantes por verificacion
cursor cur_contaminantes_medidos_verificentro is
  select c.nombre, c.clave, cv.medicion
  from contaminante_verificacion cv
  join contaminante c on c.contaminante_id = cv.contaminante_id
  where verificacion_id = p_verificacion_id;

begin 
  --variable de sesion para que se permita la actualizacion de status_vehiculo_id
  dbms_session.set_identifier('permitido');

  select count(*) into v_cantidad_registros
  from contaminante_verificacion
  where verificacion_id = p_verificacion_id;
  
  --Validamos el caso la verificacion no haya acabado o no tenga registros de contaminante aun
  if v_cantidad_registros = 0 then
    dbms_output.put_line('No se a medido nada aun para esta verificacion, ejecutar'||
      ' cuando se tengan mediciones');
    dbms_session.clear_identifier;
    p_estado_verificacion := 0;
    return;
  end if;

  --Mostrar reporte de contaminantes obtenido por el cursos 
  v_suma_contaminantes := 0;
  dbms_output.put_line('*Reportes de contaminantes en el verificentro');
  dbms_output.put_line('Nombre---------------Clave------Medicion');
  for r in cur_contaminantes_medidos_verificentro loop
    dbms_output.put_line(r.nombre||'   '||r.clave||'         '||r.medicion||chr(10));
    v_suma_contaminantes := v_suma_contaminantes + r.medicion;
  end loop;

  --Validamos si no paso la verificacion, no actualizaremos nada en la BD
  if v_suma_contaminantes > 1.5 then
    dbms_output.put_line('El vehiculo no paso la verificacion su status no cambia');
    dbms_session.clear_identifier;
    p_estado_verificacion := -1;
    return;
  end if;

  --la verificacion fue exitosa
  p_estado_verificacion := 1;

  --Hacemos actualizacion al status del vehiculo a en regla
  update vehiculo
  set status_vehiculo_id = (
    select status_vehiculo_id
    from status_vehiculo
    where nombre = 'EN REGLA')
  where vehiculo_id = p_vehiculo_id;
  dbms_output.put_line('*El status del vehiculo con id: '||p_vehiculo_id||' fue'|| 
    ' actualizado al status EN REGLA');

  --Hacemos una consulta para ver si la notificacion se genero por una notificacion
  --si es el caso procedemos a borrar la o las notifiaciones de verificacion
  select count(*) into v_existe_notificacion
  from verificacion
  where verificacion_id = p_verificacion_id
    and notificacion_id is not null;

  if v_existe_notificacion = 1 then
    update verificacion 
    set notificacion_id = null
    where verificacion_id = p_verificacion_id;

    delete from notificacion
    where vehiculo_id = p_vehiculo_id;
    dbms_output.put_line('*Se econtraron notificaciones para esta verificacion '|| 
      ' ahora que el status es EN REGLA, se han eliminado');
  end if;

  --Consulta para verificar las multas que se le hicieron al propietario debido a que no 
  --habia hecho su verificacion, en el caso que tenga sumamos esos puntos y los restamos
  --en puntos acumulados del propietario, ya por ultimo borramos esas multas
  --nota: no puede haber una multa sin su notificacion correspondiente
  begin
    select p.propietario_id, p.puntos_negativos_acumulados, count(*), 
      sum(puntos_negativos) 
    into v_propietario_id, v_puntos_negativos_propietario, v_num_multas, 
      v_puntos_negativos_multas
    from vehiculo v
    join propietario p on v.propietario_id = p.propietario_id
    join multa m on p.propietario_id = m.propietario_id
    where v.vehiculo_id = p_vehiculo_id
      and m.descripcion like '%notificaciones%'
    group by p.propietario_id, p.puntos_negativos_acumulados;

    exception
      when no_data_found then
        null; 
        -- se deja continuar el flujo
  end;

  if v_num_multas > 0 then 

    delete from multa 
    where propietario_id = v_propietario_id
      and descripcion like '%notificaciones%';
    dbms_output.put_line('*Se econtraron multas por caso omiso a notificaciones'|| 
      ' ahora que se hizo la verificacion se han eliminado del historial del propietario');

    dbms_output.put_line('*Puntaje del propietario antes de actualizar: '
      ||v_puntos_negativos_propietario);

    v_puntaje_negativo_actualizado := 
      v_puntos_negativos_propietario - v_puntos_negativos_multas;

    update propietario
    set puntos_negativos_acumulados = v_puntaje_negativo_actualizado
    where propietario_id = v_propietario_id;

    dbms_output.put_line('*Puntaje del propietario despues de actualizar: '
      ||v_puntaje_negativo_actualizado);

    --Si los puntos acumulados despues de la actualizacion son menos de 200 el derecho a 
    --licencia debe ser valido
    if v_puntaje_negativo_actualizado < 200 then
      update propietario
      set con_derecho_a_licencia = true
      where propietario_id = v_propietario_id;
      dbms_output.put_line('*Se volvio a dar permiso al propietario de tener licenia');
    end if;
  end if;

  dbms_session.clear_identifier;
end;
/
show errors
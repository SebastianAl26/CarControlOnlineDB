--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 06/12/2024
--@Descripción: 
/* 
Cada 10 dias se realiza un analisis de las emisiones de contaminantes de los vehiculos,
se debe revisar lo siguiente:
Si hay alguna medicion no cumple los niveles permitidos(0.7), o la suma de contaminantes 
generados por el vehículo en ese lapso de dias sobrepasa cierta cantidad (1.5) 
se debe gener una notificacion que se le enviara al propietario por correo electrónico. 
Se requiere registrar el numero de notificacion(1,2,3), la fecha de envio 
y el registro de mediciones que causaron el exceso, 
El estado del carro paasa a ser VERIFICACION PENDIENTE, ademas una vez se acumulen 
3 notificaciones por cada nueva notificacion se generara una multa de 15 puntos*/

create or replace procedure proc_validacion_emisiones_contaminantes is
  v_num_notificacion number;
  v_propietario_id number;
  v_mensaje varchar2(300);
  v_vehiculo_id_actual number;
  v_vehiculo_id_anterior number := -1;
  
  --no se usan las variables, son para completar los param de un procedimiento
  v_1 number;
  v_2 number;

  --vehiculos que tendrian que recibir una notificacion por acumulacion de contaminantes
  --o por alguna medicion muy alta
  cursor cur_vehiculos_a_notificar is 
    select cv.contaminante_vehiculo_id, q1.vehiculo_id, cv.contaminante_id
    from (
      select vehiculo_id
      from contaminante_vehiculo
      where fecha_registro >= sysdate - 10 and fecha_registro <= sysdate
      group by vehiculo_id
      having sum(medicion) >= 1.5 or max(medicion) >= 0.7
    ) q1
    join contaminante_vehiculo cv on q1.vehiculo_id = cv.vehiculo_id
    order by vehiculo_id;

  cursor cur_vehiculos_a_actualizar is
    select vehiculo_id
    from contaminante_vehiculo
    where fecha_registro >= sysdate - 10 and fecha_registro <= sysdate
    group by vehiculo_id
    having sum(medicion) >= 1.5 or max(medicion) >= 0.7;

begin

  for p in cur_vehiculos_a_notificar loop

    --queremos que el num_notificacion, sumarle uno y que ese valor sea fijo 
    --hasta que vehiculo_id cambie
    --recordar que hay varios registros con la misma notificacion pero cambia el contaminante

    select count(distinct num_notificacion) into v_num_notificacion
    from notificacion
    where vehiculo_id = p.vehiculo_id;
    
    v_vehiculo_id_actual := p.vehiculo_id;

    if v_vehiculo_id_actual != v_vehiculo_id_anterior then
      v_num_notificacion := v_num_notificacion + 1;
    end if; 
    
    insert into notificacion(notificacion_id, num_notificacion, fecha_envio, 
      vehiculo_id, contaminante_vehiculo_id)
    values(notificacion_id_seq.nextval, v_num_notificacion, sysdate, p.vehiculo_id, 
      p.contaminante_vehiculo_id);

    v_vehiculo_id_anterior := v_vehiculo_id_actual;

  end loop;

  for p in cur_vehiculos_a_actualizar loop
    --actualizamos el estado de los vehiculo a verificacion pendiente
    update vehiculo
    set status_vehiculo_id = (
      select status_vehiculo_id
      from status_vehiculo
      where nombre = 'CON VERIFICACIÓN PENDIENTE'
    )
    where vehiculo_id = p.vehiculo_id;

    --validar el numero de notificaciones para ver si se genera una multa
    select count(distinct num_notificacion) into v_num_notificacion
    from notificacion
    where vehiculo_id = p.vehiculo_id;

    if v_num_notificacion > 3 then
      select propietario_id into v_propietario_id
      from vehiculo 
      where vehiculo_id = p.vehiculo_id;

      v_mensaje := 'Se ha hecho caso omiso de las notificaciones para verificacion del vehículo';

      proc_registra_multa(v_propietario_id, v_mensaje, 15, v_1, v_2);
    end if;
  end loop;
end;
/
show errors
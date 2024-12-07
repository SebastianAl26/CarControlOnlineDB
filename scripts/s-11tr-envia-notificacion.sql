--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 06/12/2024
--@Descripción: 

/*En el momento que se registra una medicion de contaminante para un vehículo y esta 
medicion no cumple los niveles permitidos, o la suma de contaminantes generados por el 
vehículo en los ultimos 15 dias tomando como referencia la fecha de registro del ultimo 
contaminante, sobrepasa cierto nivel, se genera una notificacion 
que se le enviara al propietario por correo electrónico. Se requiere registrar el numero 
de notificacion(1,2,3), la fecha de envio y el registro de mediciones que causaron el 
exceso, el estado del carro paasa a ser VERIFICACION PENDIENTE, ademas una vez se acumulen 
3 notificaciones por cada nueva notificacion se generara una multa de 15 puntos*/

create or replace trigger tr_envia_notificacion
after insert 
on contaminante_vehiculo for each row

declare 
  v_suma_contaminantes number;
  v_num_notificacion number;
  v_contaminante_id contaminante_vehiculo.contaminante_vehiculo_id%type;
  v_propietario_id number;

  --variables para cumplir con los parametros del procedimiento
  v1 number;
  v2 number;

  -- Cursor para obtener los contaminantes que contribuyeron al exceso
  cursor cur_contaminantes_exceso is
    select contaminante_vehiculo_id
    from contaminante_vehiculo
    where vehiculo_id = :new.vehiculo_id
      and (fecha_registro <= sysdate and fecha_registro >= sysdate - 15);
      
begin

  /*Se obtiene la suma de medicion de contaminantes del vehiculo en los ultimos 15 dias*/
  select sum(medicion) into v_suma_contaminantes
  from contaminante_vehiculo
  where vehiculo_id = :new.vehiculo_id
    and (fecha_registro <= sysdate and fecha_registro >= sysdate - 15);

  -- Verificar si la medición individual o la suma excede los límites
  if :new.medicion >= 0.7 or v_suma_contaminantes >= 1.5 then
    -- Actualizamos el estado del vehiculo a 'VERIFICACION PENDIENTE'
    update vehiculo
    set status_vehiculo_id = (
      select status_vehiculo_id 
      from status_vehiculo
      where nombre = 'CON VERIFICACION PENDIENTE')
    where vehiculo_id = :new.vehiculo_id;

    -- Obtener el número de notificaciones que tiene el vehiculo
    select count(*) into v_num_notificacion
    from notificacion 
    where vehiculo_id = :new.vehiculo_id;

    --Si existen 3 notificaciones cada nueva notificacion genera una nulta
    if v_num_notificacion > 3 then
      --se obtiene el propietario del vehiculo
      select propietario_id into v_propietario_id
      from vehiculo v
      join contaminante_vehiculo cv on v.vehiculo_id = cv.vehiculo_id
      where v.vehiculo_id = :new.vehiculo_id;
      
      proc_registra_multa(v_propietario_id, 'Caso omiso a las notificaciones
        para verificar el vehiculo', 15, v1, v2);
    end if;


    --Se obtiene el sig num de notificacion antes de insertarla
    if v_num_notificacion = 0 then
      v_num_notificacion := 1;
    else
      v_num_notificacion := v_num_notificacion + 1;
    end if;
  end if;

  -- Insertar la nueva notificación por la medición individual si excede el límite
  if :new.medicion >= 0.7 then
    insert into notificacion(notificacion_id, num_notificacion, fecha_envio, 
      vehiculo_id, contaminante_vehiculo_id)
    values(notificacion_id_seq.nextval, v_num_notificacion, sysdate, 
      :new.vehiculo_id, :new.contaminante_vehiculo_id);
  end if;

  --Si la suma total de contaminantes supera 1.5, registrar 
  --todos los contaminantes contribuyentes
  if v_suma_contaminantes >= 1.5 then
    --Insertar cada contaminante que contribuyó al exceso
    for r in cur_contaminantes_exceso loop
      insert into notificacion(notificacion_id, num_notificacion, fecha_envio, 
        vehiculo_id, contaminante_vehiculo_id)
      values(notificacion_id_seq.nextval, v_num_notificacion, sysdate, 
        :new.vehiculo_id, r.contaminante_vehiculo_id);
    end loop;
  end if;

end;
/
show errors

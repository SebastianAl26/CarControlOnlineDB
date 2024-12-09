--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 04/12/2024
--@Descripción: Funcion que calcula la cuota del seguro dependiendo de ciertos factores

create or replace function calcular_cuota_seguro(
  p_vehiculo_id number,
  p_num_bolsas_aire number,
  p_frenos_abs number
) return number is

v_cuota_seguro number(10,4); --return
v_precio number;
v_num_multas number;
v_clave_estado varchar2(2);

begin 

  begin
    select precio into v_precio
    from vehiculo
    where vehiculo_id = p_vehiculo_id;
  end;
  
  --establecemos una cuota base (3%)
  v_cuota_seguro := v_precio * 0.03;

  --Incremento de acuerdo a bolsas de aire
  --mientras más tenga es mas seguro el auto
  if p_num_bolsas_aire between 2 and 4 then
    v_cuota_seguro := v_cuota_seguro + (v_cuota_seguro * 0.12);
  elsif p_num_bolsas_aire between 4 and 6 then
    v_cuota_seguro := v_cuota_seguro + (v_cuota_seguro * 0.08);
  elsif p_num_bolsas_aire > 6 then
    v_cuota_seguro := v_cuota_seguro + (v_cuota_seguro * 0.02);
  end if;

  --Incremento de acuerdo al sistema de frenos
  if p_frenos_abs = 0 then
    v_cuota_seguro := v_cuota_seguro + (v_cuota_seguro * 0.12);
  end if;

  --Si es que el vehiculo no es nuevo se verifica la cantidad de multas que su 
  --propietario ha tenido
  select count(*) into v_num_multas 
  from vehiculo v
  join propietario p on v.propietario_id = p.propietario_id
  join multa m on p.propietario_id = m.propietario_id
  where v.vehiculo_id = p_vehiculo_id;

  if v_num_multas >= 2 then
    v_cuota_seguro := v_cuota_seguro + (v_cuota_seguro * 0.2);
  end if;

  --Si el vehiculo pertenece a uno de los 5 estados mas inserguros aumenta la cuota
  --Guanajuato, Estado de México, Baja California, Michoacán y Jalisco
  select clave into v_clave_estado 
  from vehiculo v
  join placa p on v.placa_id = p.placa_id
  join estado e on p.estado_id = e.estado_id
  where vehiculo_id = p_vehiculo_id;

  if v_clave_estado in ('GR', 'MC', 'BC', 'MN', 'JC') then
    v_cuota_seguro := v_cuota_seguro + (v_cuota_seguro * 0.05);
  end if;

  return v_cuota_seguro;

  exception
    when no_data_found then
      -- Manejo de errores genérico
      dbms_output.put_line('vehiculo_id incorrecto: ' || SQLERRM);
      dbms_output.put_line('Error: ' || SQLERRM);
      return null;  -- Retornar NULL en caso de error
    when others then
      -- Manejo de errores genérico
      dbms_output.put_line('Error: ' || SQLERRM);
      return null;  -- Retornar NULL en caso de error
end;
/
show errors

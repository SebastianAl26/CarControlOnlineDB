--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 04/12/2024
--@Descripción: Funcion que calcula la cuota de impuesto dependiendo de ciertos factores

create or replace function calcular_cuota_impuesto(
  p_vehiculo_id number,
  p_num_bolsas_aire number,
  p_frenos_abs number,
  p_tipo_transmision char
) return number is

v_cuota_impuesto number(10,4);
v_precio number;
begin 

  --puede ser que no exista el vehiculo_id recibido como parametro
  begin
    select precio into v_precio
    from vehiculo
    where vehiculo_id = p_vehiculo_id;
  end;
  
  --establecemos una cuota base (2.5%)
  v_cuota_impuesto := v_precio * 0.025;

  --Incremento de acuerdo a bolsas de aire
  if p_num_bolsas_aire between 2 and 4 then
    v_cuota_impuesto := v_cuota_impuesto + (v_cuota_impuesto * 0.02);
  elsif p_num_bolsas_aire between 4 and 6 then
    v_cuota_impuesto := v_cuota_impuesto + (v_cuota_impuesto * 0.04);
  elsif p_num_bolsas_aire > 6 then
    v_cuota_impuesto := v_cuota_impuesto + (v_cuota_impuesto * 0.06);
  end if;

  --Incremento de acuerdo al sistema de frenos
  if p_frenos_abs = 0 then
    v_cuota_impuesto := v_cuota_impuesto + (v_cuota_impuesto * 0.1);
  elsif p_frenos_abs = 1 then
    v_cuota_impuesto := v_cuota_impuesto - (v_cuota_impuesto * 0.05);
  end if;

  --Incremento de acuerdo al tipo de transmision
  if upper(p_tipo_transmision) = 'A' then
    v_cuota_impuesto := v_cuota_impuesto + (v_cuota_impuesto * 0.08);
  end if;
  
  return v_cuota_impuesto;

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


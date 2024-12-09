--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 04/12/2024
--@Descripción: 
/*Funcion que calcula el porcentaje de verificaciones respecto al total de autos
La funcion puede recibir varios parametro de entrada opcionales, ya que estos parametros
serviran como restriccion para calcular porcentajes con respecto a intervalos de tiempo
o con respecto a ciertos tipos de vehiculos o ya por ultimo calcular el porcentaje total 
sin ningun tipo de restriccion anterior*/

create or replace function calcular_porcentaje_verificaciones
(
  p_fecha_inicio date default null,    -- Parámetro opcional para filtrar verificaciones por fecha de inicio
  p_fecha_fin date default null,       -- Parámetro opcional para filtrar verificaciones por fecha de fin
  p_es_transporte_publico number default null,  -- Parámetro para filtrar por vehículos de transporte público
  p_es_carga number default null,      -- Parámetro para filtrar por vehículos de carga
  p_es_particular number default null  -- Parámetro para filtrar por vehículos particulares
)
return number
is
    v_total_vehiculos number;
    v_total_verificaciones number;
    v_total_vehiculos_con_verificacion number;
    v_porcentaje number;
begin
  -- Contar el número total de vehículos, aplicando filtros de tipo si es necesario
  select count(*) into v_total_vehiculos
  from vehiculo
  where (p_es_transporte_publico is null or es_transporte_publico = p_es_transporte_publico)
    and (p_es_carga is null or es_carga = p_es_carga)
    and (p_es_particular is null or es_particular = p_es_particular);


  -- Contar el número total de verificaciones, aplicando filtros de fecha y tipo de vehículo
  select count(*) into v_total_verificaciones
  from verificacion v
  join vehiculo veh on v.vehiculo_id = veh.vehiculo_id
  where (p_fecha_inicio is null or v.fecha_verificacion >= p_fecha_inicio)
    and (p_fecha_fin is null or v.fecha_verificacion <= p_fecha_fin)
    and (p_es_transporte_publico is null or veh.es_transporte_publico = p_es_transporte_publico)
    and (p_es_carga is null or veh.es_carga = p_es_carga)
    and (p_es_particular is null or veh.es_particular = p_es_particular);

  -- Contar el número de vehículos con al menos una verificación, aplicando filtros de fecha y tipo
  select count(distinct v.vehiculo_id) into v_total_vehiculos_con_verificacion
  from verificacion v
  join vehiculo veh on v.vehiculo_id = veh.vehiculo_id
  where (p_fecha_inicio is null or v.fecha_verificacion >= p_fecha_inicio)
    and (p_fecha_fin is null or v.fecha_verificacion <= p_fecha_fin)
    and (p_es_transporte_publico is null or veh.es_transporte_publico = p_es_transporte_publico)
    and (p_es_carga is null or veh.es_carga = p_es_carga)
    and (p_es_particular is null or veh.es_particular = p_es_particular);

  -- Evitar división por cero
  if v_total_vehiculos = 0 then
      v_porcentaje := 0;
  else
    -- Calcular el porcentaje de vehículos que han realizado verificaciones
    v_porcentaje := (v_total_vehiculos_con_verificacion / v_total_vehiculos) * 100;
  end if;

  -- Retornar el porcentaje
  return v_porcentaje;

exception
  when others then
    -- Manejo de errores genérico
    dbms_output.put_line('Error: ' || SQLERRM);
    return null;  -- Retornar NULL en caso de error
end;
/
show errors
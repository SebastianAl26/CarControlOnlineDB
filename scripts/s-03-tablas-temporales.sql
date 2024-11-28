--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 27/11/2024
--@Descripción: Implementacion de tablas temporales

/*
-----Escenario donde puede ser util una tabla temporal-----
En el sistema de control de vehículos, se requiere generar un reporte  que 
combine información de diversas tablas.El objetivo principal es  analizar datos sobre 
vehículos que son de tipos carga y particular, considerando únicamente 
aquellos que  pertenezcan simultáneamente a ambos tipos. Para facilitar el análisis, se 
hara una desnormalizacion los datos y se guardará en una tabla temporal.

El reporte debe incluir los siguientes datos:
El identificador del vehículo, número de serie, la clave de la marca, el nombre del 
modelo, el numero de placa, la capacidad (incluyendo su unidad), el tipo de transmisión ,
si cuentan con frenos ABS y el número de serie del dispositivo de medición.

Además, debe reflejar el estado actual del vehículo, incluyendo  la fecha en que fue 
actualizado. También se requiere un análisis de las emisiones contaminantes generadas, 
indicando el número total de contaminantes registrados por cada vehículo y el promedio 
global de contaminantes emitidos por todos los vehículos seleccionados como columna 
de referencia.

La creación de una tabla temporal para este propósito está justificada debido
a la complejidad de la consulta y el nivel de normalizacion que presentan los datos
*/

create global temporary table reporte_vehiculos_carga_particular(
  select q1.vehiculo_id, q1.numero_serie, ma.clave, mo.nombre as marca, 
    p.numero_placa, q1.capacidad, q1.unidad_capacidad, q1.tipo_transmision, 
    q1.cuenta_con_frenos_abs, q1.num_serie_dispo_medicion, s.nombre as status_vehiculo, 
    q1.fecha_status, q1.num_contaminantes_registrados, 
    --Columna referencia
    (select avg(num_contaminantes_registrados)
    from (
      select v.vehiculo_id, count(*) as num_contaminantes_registrados
      from vehiculo v
      join contaminante_vehiculo cv on v.vehiculo_id = cv.vehiculo_id
      where v.es_carga = 1 and es_particular = 1
      group by v.vehiculo_id
    )) as prom_contaminantes_registrados

  from (
    select v.vehiculo_id, v.numero_serie, v.num_serie_dispo_medicion, 
      v.fecha_status, v.status_vehiculo_id, v.modelo_id, 
      v.placa_id, vc.capacidad, vc.unidad_capacidad,
      vp.tipo_transmision, vp.cuenta_con_frenos_abs, 
      count(*) as num_contaminantes_registrados
    from vehiculo v 
    join vehiculo_carga vc on v.vehiculo_id = vc.vehiculo_id
    join vehiculo_particular vp on v.vehiculo_id = vp.vehiculo_id
    join contaminante_vehiculo cv on v.vehiculo_id = cv.vehiculo_id
    group by v.vehiculo_id, v.numero_serie, v.num_serie_dispo_medicion, 
      v.fecha_status, v.status_vehiculo_id, v.modelo_id, 
      v.placa_id, vc.capacidad, vc.unidad_capacidad,
      vp.tipo_transmision, vp.cuenta_con_frenos_abs
  ) q1
  join status_vehiculo s on q1.status_vehiculo_id = s.status_vehiculo_id
  join placa p on q1.placa_id = p.placa_id
  join modelo mo on q1.modelo_id = mo.modelo_id 
  join marca ma on mo.marca_id = ma.marca_id
) on commit preserve rows;

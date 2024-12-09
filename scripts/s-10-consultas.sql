--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 04/12/2024
--@Descripción: Se proponen diferentes consultas aplicando lo que vimos en el curso

/*
---Consulta 1 (Algebra Relacional)---
Algunos erificentros realizaran un sorteo para obtener a lo vehiculos que tendran gratis
su siguiente verificacion para ello se establecen las siguientes condiciones.
El vehiculo debe tener el status EN REGLA (status_vehiculo_id = 1)
El vehiculo debe ser de tipo particular 
El vehiculo tiene que ser del año 2021 o 2022
Mostrar identificador, numero_serie, anio, fecha_status*/

select vehiculo_id, numero_serie, anio, fecha_status 
from (
  select * from vehiculo where status_vehiculo_id = 1
  intersect 
  select * from vehiculo where es_particular = 1
  intersect
  (
    select * from vehiculo where anio = '2021'
    union
    select * from vehiculo where anio = '2022'
  )
  minus --existe la psosibilidad de es_carga=1 y es_particular=1 (solo queremos es_particular)
  select * from vehiculo where es_carga = 1
);

/* ---Consulta 2 (Funciones de agregación, group by, having, sinonimo, inner join)---
Se requiere obtener información sobre las emisiones de contaminantes generadas mensualmente 
por los vehículos durante el año 2024. Se debe de mostrar el número de serie del vehículo, 
su año y el número de serie del dispositivo de medición asociado. Además, se muestra
la cantidad total de emisiones mensuales y el maximo valor de estas para cada vehículo, 
considerando únicamente aquellos que hayan registrado emisiones correspondientes a más 
de dos contaminantes*/

select v.numero_serie num_serie_vehiculo, v.anio año_vehiculo, 
  v.num_serie_dispo_medicion, to_char(cv.fecha_registro, 'mm') mes_registro,
  count(*) num_emisiones_registradas, max(medicion) max_medicion_registrada
from af_vehiculo v
join af_contaminante_vehiculo cv on v.vehiculo_id = cv.vehiculo_id
group by v.numero_serie, v.anio, v.num_serie_dispo_medicion, 
  to_char(cv.fecha_registro, 'mm')
having count(*) >= 2
order by v.numero_serie;


/* ---Consulta 3 (Vistas - funciones de agregacion)---
Usando la vista v_licencias_propietarios, se quiere mostrar cuantas licencias tiene
cada propietario que tengan vigencia en el año actual
tiene cada propietario tal que alguna de sus licencia tenga vigencia en el año actual*/

select nombre_propietario, count(*) num_licencias_2024
from v_licencias_propietarios
where to_char(fecha_vigencia_licencia, 'yyyy') = to_char(sysdate, 'yyyy')
group by nombre_propietario;


/*---Consulta 4 (Subconsultas y funciones de agregacion)---
Para cada uno de los vehiculos del año 2021 seleccionar del numero de serie, numero de 
placa, el numero de serie del dispositivo de medicion, la clave, nombre, meidcion 
y fecha de registro del contaminante que tuvo la mayor emision
*/

select q1.vehiculo_id, v.numero_serie, p.numero_placa, v.num_serie_dispo_medicion, 
  c.nombre, c.clave, cv.medicion, cv.fecha_registro
from(
  select v.vehiculo_id, max(cv.medicion) max_medicion_registrada
  from vehiculo v
  join contaminante_vehiculo cv on v.vehiculo_id = cv.vehiculo_id
  where v.anio = '2021'
  group by v.vehiculo_id
) q1
join vehiculo v on q1.vehiculo_id = v.vehiculo_id
join placa p on v.placa_id = p.placa_id
join contaminante_vehiculo cv on v.vehiculo_id = cv.vehiculo_id
join contaminante c on cv.contaminante_id = c.contaminante_id
where cv.medicion = q1.max_medicion_registrada;



/* Consulta 5 - Outer join, subconsultas y funciones de agregacion
Se desea obtener un pequeño reporte de todos los propietarios 
que ha tenido el vehiculo con numero de serie 1A2B3C4D5E6F7G8H9J
(uso del historico) debe mostrarse el numero de serie del vehiculo, su placa, estado, 
el nombre completo del propietario, el periodo de propiedad, 
y cuantas multas tuvo el propietario en ese lapso(tomar en cuenta que pudo haber tenido 0)
*/
select v.numero_serie, pl.numero_placa, e.nombre, p.nombre, p.apellido_paterno, 
  p.apellido_materno, pv.fecha_adquisicion, pv.fecha_fin,
  q1.num_multas_propietario
from (
  select pv.propietario_id, count(m.puntos_negativos) num_multas_propietario
  from historico_propietario_vehiculo pv
  join vehiculo v on pv.vehiculo_id = v.vehiculo_id
  join propietario p on pv.propietario_id = p.propietario_id
  left join multa m on p.propietario_id = m.propietario_id
  where substr(v.numero_serie, 1, 8) = '1A2B3C4D'
    and m.fecha_registro >= pv.fecha_adquisicion
    and m.fecha_registro <= nvl(pv.fecha_fin, sysdate)
  group by pv.propietario_id
) q1
join propietario p on q1.propietario_id = p.propietario_id
join historico_propietario_vehiculo pv on p.propietario_id = pv.propietario_id
join vehiculo v on pv.vehiculo_id = v.vehiculo_id
join placa pl on v.placa_id = pl.placa_id
join estado e on pl.estado_id = e.estado_id;


/*---Consulta 6 (Natural Join)---
Se desea una descripcion detallada de los autos que son del año 2021 y de baja california,
 que sean de tipo transporte publico y su licencia sea de tipo A.
Se quiere mostrar el identificador, el numero de serie, placa, su status, fecha_status 
el numero de pasajeros sentados,tipo y descripcion de licencia
*/
select vehiculo_id, v.numero_serie, p.numero_placa, s.nombre, v.fecha_status, 
  vp.pasajeros_sentados, l.tipo, l.descripcion
from licencia l 
natural join vehiculo_transporte_publico vp
natural join vehiculo v
natural join placa p
natural join estado e
join status_vehiculo s using(status_vehiculo_id)
where v.anio = '2021'
and l.tipo = 'A'
and e.clave = 'BC';


/*---Consulta 7 (Tabla externa)---
Se desea consultar a los fabricantes cuyos vehículos tienen emisiones promedio de CO2 
superiores al promedio global, agrupando los resultados por tipo de combustible. Esta 
información permitirá identificar qué fabricantes destacan negativamente en emisiones para
 cada tipo de combustible.*/

select fabricante, tipo_combustible, avg(emisiones_co2), 
  trunc((select avg(emisiones_co2) from emisiones_vehiculo_externa),2)
  as prom_emisiones_co2_global
from emisiones_vehiculo_externa
group by fabricante, tipo_combustible
having avg(emisiones_co2) >= prom_emisiones_co2_global
order by 1;

/*Consulta 8 (Tabla Temporal)
Se requiere ingresar una cantidad de vehiculos sin placa a la Base de Datos, estos
registros se estan guardando en la tabla temporal "vehiculos_sin_placa_temporal",
posteriormente se ingresaran ala tabla vehiculo, pero antes se quiere saber 
la cantidad de placas que se necesitan por cada marca*/

--Se insertan registros en esta sesion para la consulta de tabla temporal

Prompt tabla temporal vehiculos sin placa
-- Vehículos de tipo transporte_publico (es_transporte_publico = 1)
insert into vehiculos_sin_placa_temporal (vehiculo_id, numero_serie, anio, 
  es_transporte_publico, es_carga, es_particular, num_serie_dispo_medicion, 
  fecha_status, precio, placa_id, status_vehiculo_id, modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, 'NNNB3C4D5E6F7GCDMX', '2022', 1, 0, 0, '1A2B3C4D5E6F7G9983', 
to_date('01/07/2023', 'dd/mm/yyyy'), 400000, null, 1, 1, 1); 

insert into vehiculos_sin_placa_temporal (vehiculo_id, numero_serie, anio, 
  es_transporte_publico, es_carga, es_particular, num_serie_dispo_medicion, 
  fecha_status, precio, placa_id, status_vehiculo_id, modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '2B3C4D5BBB7G8H9I0K', '2021', 1, 0, 0, '2B3C4D5E6F7G8H9L0M', 
to_date('10/08/2023', 'dd/mm/yyyy'), 400000, null, 1, 1, 2); 

-- Vehículos de tipo carga (es_carga = 1)
insert into vehiculos_sin_placa_temporal (vehiculo_id, numero_serie, anio, 
  es_transporte_publico, es_carga, es_particular, num_serie_dispo_medicion, 
  fecha_status, precio, placa_id, status_vehiculo_id, modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '66ZZ7G8H9I0J1K2L3N', '2018', 0, 1, 0, '5E6F7G8H9I0LLOOP', 
to_date('01/06/2023', 'dd/mm/yyyy'), 400000, null, 1, 5, 5); 

insert into vehiculos_sin_placa_temporal (vehiculo_id, numero_serie, anio, 
  es_transporte_publico, es_carga, es_particular, num_serie_dispo_medicion, 
  fecha_status, precio, placa_id, status_vehiculo_id, modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '8KPP8H9ÑLK1K2L3N4O', '2021', 0, 1, 0, '6F7G8H9I0J1KILIA', 
to_date('10/09/2023', 'dd/mm/yyyy'), 400000, null, 1, 4, 6); 

-- Vehículos de tipo particular (es_particular = 1)
insert into vehiculos_sin_placa_temporal (vehiculo_id, numero_serie, anio, 
  es_transporte_publico, es_carga, es_particular, num_serie_dispo_medicion, 
  fecha_status, precio, placa_id, status_vehiculo_id, modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '9I0J1K2L3M4POPOT', '2021', 0, 0, 1, '9I0J1K2LLIIY', 
to_date('02/11/2023', 'dd/mm/yyyy'), 400000, null, 1, 10, 1); 

-- Vehículos de tipo carga y particular (es_carga = 1 y es_particular = 1)
insert into vehiculos_sin_placa_temporal (vehiculo_id, numero_serie, anio, 
  es_transporte_publico, es_carga, es_particular, num_serie_dispo_medicion, 
  fecha_status, precio, placa_id, status_vehiculo_id, modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, 'D3M4N5O6P7Q8MNJUO', '2020', 0, 1, 1, 'D3M4N5O99OM', 
to_date('28/11/2023', 'dd/mm/yyyy'), 400000, null, 1, 6, 5); 

insert into vehiculos_sin_placa_temporal (vehiculo_id, numero_serie, anio, 
  es_transporte_publico, es_carga, es_particular, num_serie_dispo_medicion, 
  fecha_status, precio, placa_id, status_vehiculo_id, modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, 'E4N5O6JJJ8ROOPPÑÑ', '2021', 0, 1, 1, 'E4N5O6PSSLL', 
to_date('05/12/2023', 'dd/mm/yyyy'), 400000, null, 1, 17, 6); 


select ma.marca_id,ma.clave, count(*) placas_requeridas
from vehiculos_sin_placa_temporal vt
join modelo mo on vt.modelo_id = mo.modelo_id
join marca ma on mo.marca_id = ma.marca_id
group by ma.marca_id, ma.clave;


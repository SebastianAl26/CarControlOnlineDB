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

/*---Consulta 5 (Outter join)---
Se necesita hacer una consulta donde se vea a todos los propietarios que tengan 
o no multas registradas, se necesita mostrar el nombre completo del propietario, correo,
puntos negativos por falta cometida, descripcion de la falta, folio de la multa
y puntos negativos acumuludos
Solo se interesa mandar un reporte de sus multas a los que tengan un correo con 
dominio gmail*/
select p.nombre ||' '||p.apellido_paterno||' '||p.apellido_materno as nombre_propietario,
  p.correo, m.folio, m.puntos_negativos, m.descripcion, p.puntos_negativos_acumulados
from propietario p
left join multa m on p.propietario_id = m.propietario_id
where p.correo like '%gmail%';

--vehiculos que no tengan multas


/*---Consulta 6 (Natural Join)---
Se desea una descripcion detallada de los autos que son del año 2021 y de CDMX, que sean 
de tipo transporte publico y su licencia sea de tipo A.
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
De la tabla externa se quiere saber por cada tipo de combustible, cuantas marcas lo usan,
cuantos autos en total lo usaron en 2021 (suma de la cantidad de vehiculos de las marca)
el promedio de consumo de combustible OBFCM y de emisiones C02 
*/


/*
Consulta 8 (Tabla Temporal)

/*Se requiere ingresar una cantidad de vehiculos sin placa a la Base de Datos, estos
registros se estan guardando en la tabla temporal "vehiculos_sin_placa_temporal",
posteriormente se ingresaran ala tabla vehiculo, pero antes se quiere necesita saber 
la cantidad de placas que se necesitan por cada marca
*/

select vt.vehiculo_id, vt.numero_serie, count(*), mo.nombre as modelo, ma.clave as marca
from vehiculos_sin_placa_temporal vt
join modelo mo on mo.modelo_id = vt.modelo_id
join marca ma on ma.marca_id = mo.marca_id
group by vt.vehiculo_id, vt.numero_serie, mo.nombre, ma.clave; 

select * from vehiculos_sin_placa_temporal;

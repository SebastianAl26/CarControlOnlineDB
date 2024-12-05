--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 04/12/2024
--@Descripción: Se proponen 5 consultas usando lo que se pide en el documento del proyecto

/*
Consulta 1 (Algebra Relacional)
Algunos erificentros realizaran un sorteo para obtener a lo vehiculos que tendran gratis
su siguiente verificacion para ello se establecen las siguientes condiciones.
El vehiculo debe tener el status EN REGLA (status_vehiculo_id = 1)
El vehiculo debe ser de tipo particular 
El vehiculo tiene que ser del año 2021 o 2022
Mostrar identificador, numero_serie, anio, fecha_status
*/

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
  minus --debido a que existe la psosibilidad de carga y particular (solo queremos el 2)
  select * from vehiculo where es_carga = 1
);


/* Consulta 2. Funciones de agregacion, group by, having y sinonimos(prefijo af)
Se requiere saber la cantidad y el promedio de emisiones mensuales por cada vehiculo en el 
año de 2021. Se debe mostrar el numero de serie, año y el numero de serie del
dispositivo de medicion pero solo de los vehiculos que generaron mas de 2 contaminantes.
*/


/* Consulta 3 Vistas - funciones de agregacion
Calcular el promedio de la cantidad de contaminantes registrados por cada vehículo, 
de acuerdoo
*/

/* Consulta 4 Vistas - subconsulta en la clausula select 
Obtener la licencia que mas durara mostrando el nombre del propietario, y el numero de licencia
*/

/* Consulta 5 Vistas - funciones de agregacion
Se quiere saber cantos vehiculos tiene cada propietario
*/

/*Consulta 6 (Subconsultas y funciones de agregacion)
Para cada vehiculo del año 2021 seleccionar el numero de serie del vehiculo,
numero de serie del dispositivo de medicion, modelo, numero de placa 
y el vehiculo con mayor puntos negativos de multas
*/
select q1.vehiculo_id, q1.numero_serie, q1.num_serie_dispo_medicion, 
  q1.puntos_negativos, mo.nombre, pl.numero_placa
from(
select v.vehiculo_id, v.numero_serie, v.num_serie_dispo_medicion, 
  max(p.puntos_negativos_acumulados) as puntos_negativos
from vehiculo v
join propietario p on v.propietario_id = p.propietario_id
where v.anio = 2021
group by v.vehiculo_id, v.numero_serie, v.num_serie_dispo_medicion
) q1
join

/*
Consulta 7 - Outter join Mostrar los que no tienen nulta
*/



/*
Consulta n Tabla externa --subconsulta clausula select
Se desea consultar el promedio de emisiones de CO2 (Dioxido de carbono) de los vehiculos
registrados en la Base de Datos para poder compararlos con los datos investigados de una
institucion privada sobre reportes de contaminantes.
*/

--Temporal
--Natural Join
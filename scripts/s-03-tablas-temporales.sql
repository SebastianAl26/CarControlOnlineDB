--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 27/11/2024
--@Descripción: Implementacion de tablas temporales

/*
-----Escenario donde puede ser util una tabla temporal-----
Se crea una tabla temporal pensando en el escenario donde se necesita 
registrar nuevos autos que aun no tienen placa de modo que la tabla 
temporal sirva para que se puedan registrar vehículos que aun no se les asigne
alguna placa, para despues ser ingresados a la tabla vehiculo ya con una placa asignada.*/

whenever sqlerror exit;
connect af_proy_admin/af@afbd_s2

--Tabla para realizar reportes 
create global temporary table vehiculos_sin_placa_temporal (
  vehiculo_id number(10,0),
  numero_serie varchar2(40),
  anio varchar(4),
  es_transporte_publico boolean,
  es_carga boolean,
  es_particular boolean,
  num_serie_dispo_medicion  char(18),
  fecha_status date,
  precio number(10,2),
  placa_id number(10,0),
  status_vehiculo_id number(10,0),
  modelo_id number(10,0),
  propietario_id number(10,0)
) on commit preserve rows; 

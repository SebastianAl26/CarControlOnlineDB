--@Autor(es): Aldo Sebastian Altamirano Vázquez 
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 02/11/2024
/*@Descripción: se propone un esquema de indexado para el caso de estudio donde se usan 
todos los tipos de indices vistos en clase*/

whenever sqlerror exit;
connect af_proy_admin/af@afbd_s2

----Indices unique----
/*Ademas de los de los indices unique por cada constraint unique
Para evitar duplicado y pueden ser usados en condiciones de busqueda*/

create unique index licencia_propietario_num_licencia_iuk
on licencia_propietario(num_licencia);

create unique index verificacion_folio_verificacion_iuk
on verificacion(folio_verificacion);

create unique index verificacion_clave_verificacion_iuk
on verificacion(clave_verificentro);

----Indices non-unique----
/*
Este indice se usa en el procedimiento de validar emisiones de contaminantes
ya que se usa la fecha de registro como condicion de busqueda
*/
create index contaminante_vehiculo_fecha_registro_ix
on contaminante_vehiculo(fecha_registro); 

--Se indexan fks, se usan comunmente en consultas en especifico en los joins
create index vehiculo_propietario_id_ix
on vehiculo(propietario_id); 

create index vehiculo_status_vehiculo_id_ix
on vehiculo(status_vehiculo_id); 

create index vehiculo_modelo_id_ix
on vehiculo(modelo_id); 

create index licencia_propietario_propietario_id_ix
on licencia_propietario(propietario_id); 

create index verificacion_vehiculo_id_ix
on verificacion(vehiculo_id); 

create index notificacion_vehiculo_id_ix 
on notificacion(vehiculo_id); 

create index notificacion_contaminante_vehiculo_id_ix
on notificacion(contaminante_vehiculo_id); 


----Indices compuestos----
/*Para evitar combinaciones duplicadas en tablas intermedias o por el concepto 
de dependencia de identificacion evitando asi inconsistencias*/

create unique index historico_propietario_vehiculo_vehic_id_propiet_id_iuk
on historico_propietario_vehiculo(vehiculo_id, propietario_id); 

----Indices basados en funciones----
create index modelo_nombre_ifx on modelo(lower(nombre));

--Las busquedas de carros se realizan empleando los primeros 8 caracteres del num_serie
create index vehiculo_numero_serie on vehiculo(substr(numero_serie, 1, 8));
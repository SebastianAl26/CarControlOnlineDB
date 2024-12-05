--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 28/11/2024
--@Descripción: Se crean secuencias para las entidades que lo requieran
whenever sqlerror exit;
connect af_proy_admin/af@afbd_s2
--Tabla pais
create sequence pais_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla marca
create sequence marca_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla modelo
create sequence modelo_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla estado
create sequence estado_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla placa
create sequence placa_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla propietario
create sequence propietario_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla licencia_tp
create sequence licencia_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla licencia_propietario
create sequence licencia_propietario_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla status_vehiculo
create sequence status_vehiculo_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla contaminante
create sequence contaminante_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

----------------------------------------------------------------------------------------
--Tabla vehiculo
create sequence vehiculo_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;


--Tabla historico_status_vehiculo
create sequence historico_status_vehiculo_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla historico_propietario_vehiculo
create sequence historico_propietario_vehiculo_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla contaminante_vehiculo
create sequence contaminante_vehiculo_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla notificacion
create sequence notificacion_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla verificacion
create sequence verificacion_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

--Tabla contaminante_verificacion
create sequence contaminante_verificacion_id_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
noorder;

-----Tablas que no requieren secuencia------
--Tabla transporte_publico
--Tabla vehiculo_carga
--Tabla particular
--Tabla multa

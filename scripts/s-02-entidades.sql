--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 26/11/2024
--@Descripción: Se crea el DDL del proyecto
whenever sqlerror exit;

--Tabla pais
create table pais(
  pais_id number(10,0),
  clave varchar2(3) not null, 
  nombre varchar2(40) not null,
  constraint pais_pk primary key(pais_id),
  constraint pais_clave_uk unique(clave)
);

--Tabla marca
create table marca(
  marca_id number(10,0),
  clave varchar2(40) not null,
  descripcion varchar2(40) not null,
  pais_id not null,
  constraint marca_pk primary key(marca_id),
  constraint marca_clave_uk unique(clave),
  constraint marca_pais_id_fk foreign key(pais_id) references pais(pais_id)
);

--Tabla modelo
create table modelo(
  modelo_id number(10,0),
  nombre varchar2(40) not null,
  marca_id not null,
  constraint modelo_pk primary key(modelo_id),
  constraint modelo_marca_id_fk foreign key(marca_id) references marca(marca_id)
);

--Tabla estado
create table estado(
  estado_id number(10,0),
  clave varchar2(2) not null, 
  nombre varchar2(40) not null,
  constraint estado_pk primary key(estado_id),
  constraint estado_clave_uk unique(clave)
);

--Tabla placa
create table placa(
  placa_id number(10,0),
  numero_placa varchar2(10) not null,
  fecha_asignacion date default sysdate,
  es_inactiva boolean not null,
  estado_id not null,
  constraint placa_pk primary key(placa_id),
  constraint placa_estado_id_fk foreign key(estado_id) references estado(estado_id)
);

--Tabla propietario
create table propietario(
  propietario_id number(10,0),
  rfc char(13) not null,
  nombre varchar2(40) not null,
  apellido_paterno varchar2(40) not null, 
  apellido_materno varchar2(40) null, 
  curp char(18) null,
  correo varchar2(320) not null,
  puntos_negativos_acumulados varchar2(40) not null,
  constraint propietario_pk primary key(propietario_id),
  constraint propietario_rfc_uk unique(rfc),
  constraint propietario_curp_uk unique(curp),
  constraint propietario_correo_uk unique(correo)
);

--Tabla licencia_propietario
create table licencia_propietario(
  licencia_propietario_id number(10,0),
  tipo_licencia varchar(40) not null,
  num_licencia char(8) not null,
  descripcion varchar2(40) not null,
  foto blob not null,
  firma blob not null,
  huella_indice_der blob null,
  huella_indice_izq blob null,
  fecha_adquisicion date default sysdate,
  --Columna virtual
  --Regla: Las licencias duran 5 años
  fecha_vigencia generated always as (fecha_adquisicion + (365*5)) virtual,
  licencia_remplazo_id null,
  propietario_id not null,
  constraint licencia_propietario_pk primary key(licencia_propietario_id),

  constraint licencia_propietario_licencia_remplazo_id_fk 
  foreign key(licencia_remplazo_id) 
  references licencia_propietario(licencia_propietario_id),

  constraint licencia_propietario_propietario_id_fk 
  foreign key(propietario_id)
  references propietario(propietario_id)
);

create table multa(
  propietario_id not null,
  folio varchar2(40),
  fecha_registro date default sysdate,
  descripcion varchar(300) not null,
  puntos_negativos number(3,0) not null,
  documento_pdf blob not null,
  
  constraint multa_pk primary key(propietario_id, folio),
  constraint multa_propietario_id_fk foreign key(propietario_id) 
  references propietario(propietario_id)
);


--Tabla status_vehiculo
create table status_vehiculo(
  status_vehiculo_id number(10,0),
  nombre varchar2(40) not null,
  descripcion varchar2(40) null,
  constraint status_vehiculo_pk primary key(status_vehiculo_id)
);

--Tabla contaminante
create table contaminante(
  contaminante_id number(10,0),
  clave char(3) not null,    
  nombre varchar2(40) not null,
  constraint contaminante_pk primary key(contaminante_id),
  constraint contaminante_clave_uk unique(clave)
);

----------------------------------------------------------------------------------------
--Tabla vehiculo
create table vehiculo(
  vehiculo_id number(10,0),
  numero_serie char(18) not null,
  anio varchar2(4) not null,
  es_transporte_publico boolean not null,
  es_carga boolean not null,
  es_particular boolean not null,
  num_serie_dispo_medicion char(18) not null,
  fecha_status date default sysdate,
  placa_id not null,
  status_vehiculo_id not null,
  modelo_id not null,
  propietario_id not null,

  constraint vehiculo_pk primary key(vehiculo_id),
  constraint vehiculo_placa_id_fk foreign key(placa_id) 
  references placa(placa_id),

  constraint vehiculo_status_vehiculo_id_fk foreign key(status_vehiculo_id) 
  references status_vehiculo(status_vehiculo_id),

  constraint vehiculo_modelo_fk foreign key(modelo_id) 
  references modelo(modelo_id),

  constraint vehiculo_propietario_id_fk foreign key(propietario_id) 
  references propietario(propietario_id),

  constraint vehiculo_numero_serie_uk unique(numero_serie),
  constraint vehiculo_num_serie_dispo_medicion_uk unique(num_serie_dispo_medicion),

  constraint vehiculo_placa_id_uk unique(placa_id), --Relacion 1 a 1

  --Corregir el comentario en el modelo relacional
  constraint vehiculo_jerarquia_chk check( 
    (es_transporte_publico = 0 and es_carga = 1 and es_particular = 1) or
    (es_transporte_publico = 1 and es_carga = 0 and es_particular = 0) or
    (es_transporte_publico = 0 and es_carga = 1 and es_particular = 0) or
    (es_transporte_publico = 0 and es_carga = 0 and es_particular = 1) 
  )
);

--Tabla licencia_tp
create table licencia_tp(
  licencia_tp_id number(10,0),
  tipo char(1) not null,
  descripcion varchar(40) not null,
  constraint licencia_tp_pk primary key(licencia_tp_id)
);

--Tabla transporte_publico
create table vehiculo_transporte_publico(
  vehiculo_id,
  pasajeros_sentados number(10,0) not null,
  pasajeros_parados number(10,0) not null,
  licencia_tp_id not null,
  constraint vehiculo_tp_pk primary key(vehiculo_id),
  constraint vehiculo_tp_vehiculo_id_fk foreign key(vehiculo_id)
  references vehiculo(vehiculo_id),

  constraint vehiculo_transporte_publico_licencia_tp_id 
  foreign key(licencia_tp_id)
  references licencia_tp(licencia_tp_id)
);


create table vehiculo_carga(
  vehiculo_id,
  capacidad number(10,0) not null,
  unidad_capacidad varchar(2),
  numero_remolques number(10,0) null,
  constraint vehiculo_carga_pk primary key(vehiculo_id),
  constraint vehiculo_carga_vehiculo_id_fk foreign key(vehiculo_id)
  references vehiculo(vehiculo_id),
  constraint vehiculo_carga_unidad_capacidad_chk check(
    unidad_capacidad in ('T','M3','m3','t')
  )
);

--Tabla particular
create table vehiculo_particular(
  vehiculo_id,
  num_bolsas_aire number(10,0) not null,
  cuenta_con_frenos_abs boolean not null,
  tipo_transmision char(1) not null,
  porcentaje_impuesto number(4,2),
  porcentaje_seguro number(4,2),
  constraint vehiculo_particular_pk primary key(vehiculo_id),
  constraint vehiculo_particular_vehiculo_id_fk foreign key(vehiculo_id)
  references vehiculo(vehiculo_id),

  constraint transporte_particular_tipo_transmision_chk check(
    tipo_transmision in ('A', 'M')
  )
);


--Tabla historico_status_vehiculo
create table historico_status_vehiculo(
  historico_status_vehiculo_id number(10,0),
  fecha_status date not null,
  status_vehiculo_id not null,
  vehiculo_id not null,

  constraint historico_status_vehiculo_pk primary key(historico_status_vehiculo_id),

  constraint historico_status_vehiculo_status_vehiculo_fk 
  foreign key(status_vehiculo_id)
  references status_vehiculo(status_vehiculo_id),

  constraint historico_status_vehiculo_vehiculo_id_fk 
  foreign key(vehiculo_id)
  references vehiculo(vehiculo_id)
);

--Tabla historico_propietario_vehiculo
create table historico_propietario_vehiculo(
  historico_propietario_vehiculo_id number(10,0),
  fecha_adquisiscion date not null,
  fecha_fin date null,
  vehiculo_id not null,
  propietario_id not null,
  
  constraint historico_propietario_vehiculo_pk 
  primary key(historico_propietario_vehiculo_id),

  constraint historico_propietario_vehiculo_vehiculo_id_fk
  foreign key(vehiculo_id)
  references vehiculo(vehiculo_id),

  constraint historico_propietario_vehiculo_propietario_id_fk 
  foreign key(propietario_id)
  references propietario(propietario_id)
);

--Tabla contaminante_vehiculo
create table contaminante_vehiculo(
  contaminante_vehiculo_id number(10,0),
  medicion number(3,2) not null,
  fecha_registro date default sysdate,
  vehiculo_id not null,
  contaminante_id not null,
  constraint contaminante_vehiculo_pk primary key(contaminante_vehiculo_id),

  constraint contaminante_vehiculo_vehiculo_id_fk foreign key(vehiculo_id)
  references vehiculo(vehiculo_id),

  constraint contaminante_vehiculo_contaminante_id_fk foreign key(contaminante_id)
  references contaminante(contaminante_id),

  constraint contaminante_vehiculo_medicion_chk check(
    medicion between 0 and 1
  )
);

--Tabla notificacion
create table notificacion(
  notificacion_id number(10,0),
  num_notificacion number(1,0) not null,
  fecha_envio date default sysdate,
  vehiculo_id not null,
  contaminante_vehiculo_id not null,
  constraint notificacion_pk primary key(notificacion_id),

  constraint notificacion_vehiculo_id_fk foreign key(vehiculo_id)
  references vehiculo(vehiculo_id),

  constraint notificacion_contaminante_vehiculo_id_fk 
  foreign key(contaminante_vehiculo_id)
  references contaminante_vehiculo(contaminante_vehiculo_id)
);

--Tabla verificacion
create table verificacion(
  verificacion_id number(10,0),
  clave_verificentro char(5) not null,
  fecha_verificacion date default sysdate,
  folio_verificacion char(13) not null,
  num_serie_dispo_medicion char(18) not null, 
  vehiculo_id not null,
  notificacion_id null,  
  constraint verificacion_pk primary key(verificacion_id),
  constraint verificacion_vehiculo_id_fk foreign key(vehiculo_id)
  references vehiculo(vehiculo_id),

  constraint verificacion_notificacion_id_fk foreign key(notificacion_id)
  references notificacion(notificacion_id),

  constraint verificacion_notificacion_id_uk unique(notificacion_id),
  constraint verificacion_dispo_medicion_uk unique(num_serie_dispo_medicion)
);

--Tabla contaminante_verificacion
create table contaminante_verificacion(
  contaminante_verificacion_id number(10,0),
  medicion number(3,2) not null, 
  contaminante_id not null,
  verificacion_id not null,


  constraint contaminante_verifificacion_pk primary key(contaminante_verificacion_id),

  constraint contaminante_verificacion_contaminante_id_fk 
  foreign key(contaminante_id)
  references contaminante(contaminante_id),

  constraint contaminante_verificacion_verificacion_id_fk 
  foreign key(verificacion_id)
  references verificacion(verificacion_id),

  constraint contaminante_verficacion_medicion_chk check(
    medicion between 0 and 1
  )
);

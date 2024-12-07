--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 28/11/2024
--@Descripción: Implementacion de tablas externas

/*
Csv o conjunto de datos recopilado de kaggle
*/

prompt conectando como sys
connect sys/system1@afbd_s2 as sysdba

prompt creando objeto tipo directory
define path_ext = '/unam/bd/proyectoFinalBd/scripts/tabla-externa'
create or replace directory tmp_dir as '&&path_ext';
grant read, write on directory tmp_dir to af_proy_admin; 

prompt conectando como af_proy_admin
connect af_proy_admin/af@afbd_s2

create table emisiones_vehiculos_externa(
  marca varchar2(40),
  tipo_combustible varchar2(20),
  numero_vehiculos number(10,0),
  consumo_combustible number(4,2),
  emsiones_co2 number(5,2),
  consumo_combustible_ponderado number(4,2),
  emisiones_co2_ponderada number(5,2)
)
organization external (
  type oracle_loader 
  default directory tmp_dir
  access parameters (
      records delimited by newline
      badfile tmp_dir: 'tabla-externa_bad.log'
      logfile tmp_dir: 'tabla-externa.log'
      fields terminated by ','
      lrtrim
      missing field values are null
      (
        marca, tipo_combustible, numero_vehiculos, consumo_combustible,
        emsiones_co2, consumo_combustible_ponderado, emisiones_co2_ponderada
      )
  )
  location ('tabla-externa.csv')
)
reject limit unlimited;
!chmod 777 &&path_ext
prompt tabla temporal creada
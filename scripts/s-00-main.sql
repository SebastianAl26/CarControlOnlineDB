--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 04/12/2024
--@Descripción: Script main que invoca a todos los demas archivos

connect sys/system1@afbd_s2 as sysdba
@s-01-usuarios.sql
@s-02-entidades.sql
@s-03-tablas-temporales.sql
@tabla-externa/s-04-tablas-externas.sql
@s-05-secuencias.sql
@s-06-indices.sql
@s-07-sinonimos.sql
@s-08-vistas.sql
@s-09-carga-inicial.sql

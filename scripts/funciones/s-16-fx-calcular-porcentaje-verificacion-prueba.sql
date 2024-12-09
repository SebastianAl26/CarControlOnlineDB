--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 05/12/2024
--@Descripción: Se hace la prueba de la funcion fx_calcular_porcentaje_verificaciones

connect af_proy_admin/af@afbd_s2

insert into verificacion (verificacion_id, clave_verificentro,fecha_verificacion,
  folio_verificacion,num_serie_dispo_medicion, notificacion_id, vehiculo_id)
values(150,'CLÑ1',sysdate,'FOZZO1','ZZZ',null,1);

insert into verificacion (verificacion_id, clave_verificentro,fecha_verificacion,
  folio_verificacion,num_serie_dispo_medicion, notificacion_id, vehiculo_id)
values(151,'CLAZ1',sysdate,'FAAI1','XXX',null,2);

Prompt ===========================================================
Prompt Prueba 1
Prompt Calculando sin ningun tipo de restriccion de fecha o tipo de vehiculo
Prompt ===========================================================

select calcular_porcentaje_verificaciones(null, null, null,
null,null) as porcentaje from dual;

/*
En este caso tenemos 15 Vehiculos en la BD
y nada mas dos de estos tienen verificacion por lo tanto se debe realizar
la siguiente operacion:
2/15
2 --> vehiculos con verificacion
15 --> total vehiculos en la BD
Resultado:
0.13 * 100 = 13.3333%
*/

Prompt ===========================================================
Prompt Prueba 2
Prompt Calculando con restriccion de tipo de transporte publico
Prompt ===========================================================

select calcular_porcentaje_verificaciones(null, null, TRUE,
  null,null) as porcentaje from dual;

/*
En este caso tenemos 4 Vehiculos de tipo transporte publico en la BD
y nada mas dos de estos tienen verificacion por lo tanto se debe realizar
la siguiente operacion:
4/15
2 --> vehiculos con verificacion
4 --> total vehiculos en la BD
Resultado:
0.50 * 100 = 50%
*/

Prompt ===========================================================
Prompt Prueba 3
Prompt Calculando con restriccion de un intervalo de fecha
Prompt ===========================================================

select calcular_porcentaje_verificaciones(to_date('1/01/2024','dd/mm/yyyy'), 
  to_date('31/12/2024','dd/mm/yyyy'), null,null,null) as porcentaje from dual;

/*
En este caso tenemos 15 Vehiculos en la BD
y nada mas dos de estos tienen verificacion por lo tanto se debe realizar
la siguiente operacion:
2/15
2 --> vehiculos con verificacion
15 --> total vehiculos en la BD
Resultado:
0.13 * 100 = 13.3333%
*/


rollback;
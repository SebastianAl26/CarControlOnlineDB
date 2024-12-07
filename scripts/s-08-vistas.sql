--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 03/12/2024
--@Descripción: Se crean 3 vistas para 3 escenarios distintos

whenever sqlerror exit;
connect af_proy_admin/af@afbd_s2

/*Se desea mostrar infromacion de los propietarios y sus licencias, pero 
restringiendo datos sensibles o privados del propietario como podrian ser curp, 
puntos_negativos, foto, firma y huellas de sus licencias. 
Para eso se desea crear una vista que incluya el nombre del propietario 
y si es tiene licencias, su numero de licencia, su tipo y su fecha de vigencia.
Otorgamos el permiso de usar esa vista al ususario invitado 
donde se harian estas consultas
*/

create or replace view v_licencias_propietarios(
  nombre_propietario, num_licencia, tipo, fecha_vigencia_licencia
) as select p.nombre||' '||p.apellido_paterno||' '||p.apellido_materno nombre_propietario,
  lp.num_licencia, l.tipo, lp.fecha_vigencia
from propietario p
left join licencia_propietario lp on p.propietario_id = lp.propietario_id
left join licencia l on lp.licencia_id = l.licencia_id
order by nombre_propietario;

grant select on v_licencias_propietarios to af_proy_invitado;

/*
Cada cierto tiempo se requiere generar un reporte para analizar datos sobre vehículos que 
son de tipos carga y particular al mismo tiempo.El reporte debe incluir los siguientes datos:
El número de serie, año,el nombre del modelo y clave de la marca, el numero de placa, la 
capacidad (incluyendo su unidad), el tipo de transmisión ,si cuentan con frenos ABS.
Además, debe reflejar el estado actual del vehículo, incluyendo  la fecha en que fue 
actualizado. También se quiere mostrar número total de contaminantes 
registrados por cada vehículo
*/

--poner unos datos para que funcione (carlo)
create or replace view v_reporte_contaminantes(
  numero_serie, anio, nombre_marca, clave, numero_placa, 
  capacidad, unidad, tipo_transmision, cuenta_con_frenos_abs,
  nombre_status, fecha_status, num_contaminantes_registrados
) as select v.numero_serie, v.anio, mo.nombre marca, ma.clave, p.numero_placa, 
  vc.capacidad, vc.unidad_capacidad, vp.tipo_transmision, vp.cuenta_con_frenos_abs,
  s.nombre status, v.fecha_status, q1.num_contaminantes_registrados
from (
  select v.vehiculo_id, count(*) num_contaminantes_registrados
  from vehiculo v 
  join contaminante_vehiculo cv on v.vehiculo_id = cv.vehiculo_id
  where v.es_carga = 1 and es_particular = 1
  group by v.vehiculo_id
) q1
join vehiculo v on v.vehiculo_id = q1.vehiculo_id
join vehiculo_carga vc on v.vehiculo_id = vc.vehiculo_id
join vehiculo_particular vp on v.vehiculo_id = vp.vehiculo_id
join placa p on v.placa_id = p.placa_id
join status_vehiculo s on v.status_vehiculo_id = s.status_vehiculo_id
join modelo mo on v.modelo_id = mo.modelo_id
join marca ma on mo.marca_id = ma.marca_id; 

/*Constantemente se desea consultar de los propietarios que tengan multas registradas
el nombre completo del propietario, correo y puntos negativos acumulados ademas 
descripcion, fecha de registro y puntaje la multa que más puntos negativos haya generado 
Esto con la finalidad de evnviarles un correo informe pero solo a los que tengan un 
correo con dominio gmail*/

create or replace view v_propietarios_multas_max_puntaje(
  nombre_propietario, correo, puntos_negativos_acumulados, descripcion,
  fecha_registro, puntaje_negativo
) as select p.nombre||' '||p.apellido_paterno||' '||p.apellido_materno nombre_propietario,
  p.correo, p.puntos_negativos_acumulados, m.descripcion, m.fecha_registro,
  m.puntos_negativos
from (
  select p.propietario_id, max(m.puntos_negativos) max_puntaje_negativo
  from propietario p
  join multa m on p.propietario_id = m.propietario_id
  where p.correo like '%gmail%'
  group by p.propietario_id
) q1
join propietario p on q1.propietario_id = p.propietario_id
join multa m on p.propietario_id = m.propietario_id
where q1.max_puntaje_negativo = m.puntos_negativos;


/*
select * from v_licencias_propietarios;
select * from v_reporte_contaminantes;
select * from v_propietarios_multas_max_puntaje;
*/

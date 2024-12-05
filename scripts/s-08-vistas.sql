--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 03/12/2024
--@Descripción: Se crean 3 vistas para 3 escenarios distintos

whenever sqlerror exit;
connect af_proy_admin/af@afbd_s2

/*
Cada cierto tiempo se desea generar un reporte para analizar datos sobre vehiculos que son 
de cierto modelo en especifico, El reporte deberia incluir el nombre del propietario, ademas
tambien el numero de serie, numero de placa y modelo del vehiculo. La idea general de esta vista
es ocultar informacion sensible como curp, correo, numero de licencia, 
firmas y datos sensibles de licencia en general. 
Para eso al final otorgamos el permiso de usar esa vista al ususario invitado 
donde se harian estas consultas
*/

create or replace view v_info_vehiculo(
  numero_serie, numero_placa, modelo, fecha_vigencia, nombre_propietario
) as select v.numero_serie, p.numero_placa, m.nombre, l.fecha_vigencia,
  p.nombre||' '||p.apellido_paterno||' '||p.apellido_materno nombre_propietario 
from vehiculo v
join propietario p on v.propietario_id = p.propietario_id
join placa p on v.placa_id = p.placa_id
join modelo m on v.modelo_id = m.modelo_id
join licencia_propietario l on l.propietario_id = p.propietario_id;

grant select on v_info_vehiculo to af_proy_invitado;

/*
Cada cierto tiempo se requiere generar un reporte para analizar datos sobre vehículos que 
son de tipos carga y particular al mismo tiempo.El reporte debe incluir los siguientes datos:
El número de serie, año,el nombre del modelo y clave de la marca, el numero de placa, la 
capacidad (incluyendo su unidad), el tipo de transmisión ,si cuentan con frenos ABS.
Además, debe reflejar el estado actual del vehículo, incluyendo  la fecha en que fue 
actualizado. También se quiere mostrar número total de contaminantes registrados por cada vehículo
*/

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

select * from v_info_vehiculo;
select * from v_reporte_contaminantes;
select * from v_licencias_propietario;

/*
Cada cierto tiempo se desea generar un reporte para analizar datos sobre las licencias
de los propietarios se puede obtener información detallada 
sobre los propietarios y sus licencias, incluyendo el estado actual de la licencia 
(tipo y fecha de vigencia) y la relación con licencias anteriores que han sido reemplazadas.

Un caso de uso sería verificar la validez de las licencias en vigencia y anticipar renovaciones, evitando 
que los propietarios operen con licencias vencidas. Esto es especialmente útil para asegurar el 
cumplimiento de normativas o para mantener registros actualizados en un sistema de gestión de licencias.
*/
create or replace view v_licencias_propietario(
  nombre_completo, numero_licencia, fecha_vigencia, 
  numero_licencia_anterior, fecha_vigencia_anterior
) as select p.nombre||' '||p.apellido_paterno||' '||p.apellido_materno nombre_completo,
  l.num_licencia, l.fecha_vigencia, 
  lr.num_licencia numero_licencia_anterior, 
  lr.fecha_vigencia fecha_vigencia_anterior
from propietario p
join licencia_propietario l on p.propietario_id = l.propietario_id
left join licencia_propietario lr on l.licencia_remplazo_id = lr.licencia_propietario_id;



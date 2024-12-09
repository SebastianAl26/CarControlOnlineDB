--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 04/12/2024
--@Descripción: Pruebas para la funcion fx_calcular_cuota_seguro

connect af_proy_admin/af@afbd_s2
set serveroutput on

Prompt ===========================================================
Prompt Prueba 1
Prompt Calculando la cuota de seguro de un vehiculo
Prompt El propietario del vehiculo no tiene multas pero
Prompt El vehiculo pertenece a una de las ciudades mas inseguras (edomex)
Prompt ===========================================================

declare
  v_num_bolsas_aire number;
  v_frenos_abs number;
  v_resultado number(10,4);
  v_resultado_esperado number(10,4);
begin
  --vehiculo_id = 12, bolsas aire 7, frenos abs(0)
  --se espera que se hagan las operaciones
  v_resultado_esperado := 400000 * 0.03;
  v_resultado_esperado := v_resultado_esperado + (v_resultado_esperado * 0.02);
  v_resultado_esperado := v_resultado_esperado + (v_resultado_esperado * 0.12);
  v_resultado_esperado := v_resultado_esperado + (v_resultado_esperado * 0.05);

  select num_bolsas_aire, cuenta_con_frenos_abs
  into v_num_bolsas_aire, v_frenos_abs
  from vehiculo_particular
  where vehiculo_id = 12;

  dbms_output.put_line('Llamada a la funcion');
  v_resultado := calcular_cuota_seguro(12, v_num_bolsas_aire, v_frenos_abs);
  dbms_output.put_line('Cuota de seguro: '||v_resultado);
  
  if v_resultado = v_resultado_esperado then
    dbms_output.put_line('OK se esperaba '||v_resultado_esperado);
    dbms_output.put_line('PRUEBA 1 EXITOSA');
  else
    dbms_output.put_line('ERROR, valor incorrecto dado por la función');
    dbms_output.put_line('Se esperaba '||v_resultado_esperado);
  end if;

end;
/

Prompt ===========================================================
Prompt Prueba 2
Prompt Calculando la cuota de seguro de un vehiculo
Prompt El propietario tiene más de 2 multas
Prompt El pertenece a una de las ciudades mas inseguras (michoacan)
Prompt ===========================================================

declare
  v_num_bolsas_aire number;
  v_frenos_abs number;
  v_resultado number(10,4);
  v_resultado_esperado number(10,4);

begin
  --vehiculo_id = 13, bolsas aire 7, frenos abs(1), multas 2, michoacan

  --se espera que se hagan estas oepraciones
  v_resultado_esperado := 400000 * 0.03;
  v_resultado_esperado := v_resultado_esperado + (v_resultado_esperado * 0.02);
  v_resultado_esperado := v_resultado_esperado + (v_resultado_esperado * 0.2);
  v_resultado_esperado := v_resultado_esperado + (v_resultado_esperado * 0.05);

  select num_bolsas_aire, cuenta_con_frenos_abs
  into v_num_bolsas_aire, v_frenos_abs
  from vehiculo_particular
  where vehiculo_id = 13;

  dbms_output.put_line('Llamada a la funcion');
  v_resultado := calcular_cuota_seguro(13, v_num_bolsas_aire, v_frenos_abs);
  dbms_output.put_line('Cuota de seguro: '||v_resultado);
  
  if v_resultado = v_resultado_esperado then
    dbms_output.put_line('OK se esperaba '||v_resultado_esperado);
    dbms_output.put_line('PRUEBA 2 EXITOSA');
  else
    dbms_output.put_line('ERROR, valor incorrecto dado por la función');
    dbms_output.put_line('Se esperaba '||v_resultado_esperado);
  end if;

end;
/

Prompt ===========================================================
Prompt Prueba 3
Prompt Probando la funcion, vehiculo_id que no existe
Prompt ===========================================================

declare
  v_resultado number;
begin
  v_resultado := calcular_cuota_impuesto(955, 5, 0, 'M');
  if v_resultado is null then
    dbms_output.put_line('OK la funcion regreso null y lanzo excepcion');
    dbms_output.put_line('PRUEBA 3 EXITOSA');
  else
    dbms_output.put_line('ERROR: La funcion no esta funcionando correctamente');
  end if;
end;
/
--@Autor(es): Aldo Sebastian Altamirano Vázquez
--            Carlo Kiliano Ferrera Guadarrama              
--@Fecha creación: 04/12/2024
--@Descripción: Se hace la carga inicial de la base de datos, generados por chatgpt
whenever sqlerror exit rollback;
connect af_proy_admin/af@afbd_s2

Prompt tabla pais
--12 paises

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'mex', 'méxico');

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'usa', 'estados unidos');

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'can', 'canadá');

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'bra', 'brasil');

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'arg', 'argentina');

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'fra', 'francia');

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'deu', 'alemania');

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'esp', 'españa');

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'gbr', 'reino unido');

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'ita', 'italia');

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'chn', 'china');

insert into pais (pais_id, clave, nombre) 
values (pais_id_seq.nextval, 'jpn', 'japón');


Prompt tabla marca
--8 marcas
insert into marca (marca_id, clave, descripcion, pais_id) 
values (marca_id_seq.nextval, 'ford', 'Fabricante estadounidense de vehículos.', 2);

insert into marca (marca_id, clave, descripcion, pais_id) 
values (marca_id_seq.nextval, 'toyota', 'Marca japonesa de automóviles de lujo y utilitarios.', 12);

insert into marca (marca_id, clave, descripcion, pais_id) 
values (marca_id_seq.nextval, 'bmw', 'Marca alemana de autos de lujo y alto rendimiento.', 7);

insert into marca (marca_id, clave, descripcion, pais_id) 
values (marca_id_seq.nextval, 'audi', 'Fabricante alemán conocido por sus autos de lujo.', 7);

insert into marca (marca_id, clave, descripcion, pais_id) 
values (marca_id_seq.nextval, 'honda', 'Marca japonesa de automóviles y motocicletas.', 12);

insert into marca (marca_id, clave, descripcion, pais_id) 
values (marca_id_seq.nextval, 'chevrolet', 'Marca estadounidense conocida por sus autos y camionetas.', 2);

insert into marca (marca_id, clave, descripcion, pais_id) 
values (marca_id_seq.nextval, 'ferrari', 'Marca italiana de autos deportivos de lujo.', 10);

insert into marca (marca_id, clave, descripcion, pais_id) 
values (marca_id_seq.nextval, 'nissan', 'Marca japonesa famosa por sus vehículos de bajo costo.',12);

Prompt tabla modelo
--Tabla modelo

-- Ford (3 modelos)
insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'mustang', 1);  -- Ford

insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'f-150', 1);  -- Ford

insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'focus', 1);  -- Ford

-- Toyota (3 modelos)
insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'camry', 2);  -- Toyota

insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'corolla', 2);  -- Toyota

insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'hilux', 2);  -- Toyota

-- BMW (3 modelos)
insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'serie 3', 3);  -- BMW

insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'x5', 3);  -- BMW

insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'm4', 3);  -- BMW

-- Audi (2 modelos, igual que antes)
insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'a3', 4);  -- Audi

insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'q7', 4);  -- Audi

-- Honda (2 modelos, igual que antes)
insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'civic', 5);  -- Honda

insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'accord', 5);  -- Honda

-- Chevrolet (2 modelos, igual que antes)
insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'silverado', 6);  -- Chevrolet

insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'malibu', 6);  -- Chevrolet

-- Ferrari (2 modelos, igual que antes)
insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, '488 gtb', 7);  -- Ferrari

insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'roma', 7);  -- Ferrari

-- Nissan (2 modelos, igual que antes)
insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'altima', 8);  -- Nissan

insert into modelo (modelo_id, nombre, marca_id) 
values (modelo_id_seq.nextval, 'maxima', 8);  -- Nissan


Prompt tabla estado
----Tabla estado----
insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'AS', 'Aguascalientes');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'BC', 'Baja California');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'BS', 'Baja California Sur');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'CC', 'Campeche');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'CL', 'Coahuila');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'CS', 'Colima');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'DF', 'Ciudad de México');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'DG', 'Durango');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'GR', 'Guanajuato');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'HG', 'Hidalgo');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'JC', 'Jalisco');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'MC', 'México');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'MN', 'Michoacán');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'MS', 'Morelos');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'NT', 'Nayarit');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'NL', 'Nuevo León');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'OC', 'Oaxaca');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'PL', 'Puebla');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'QR', 'Quintana Roo');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'QT', 'Querétaro');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'SL', 'San Luis Potosí');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'SO', 'Sonora');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'TB', 'Tabasco');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'TC', 'Tamaulipas');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'TL', 'Tlaxcala');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'VR', 'Veracruz');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'YN', 'Yucatán');

insert into estado (estado_id, clave, nombre) 
values (estado_id_seq.nextval, 'ZS', 'Zacatecas');

Prompt Tabla placa
----Tabla placa---- 
insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'ABC1234567', false, 1);  -- Aguascalientes (1)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'DEF4567890', false, 2);  -- Baja California (2)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'LMN2345678', false, 2);  -- Baja California (3)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'GHI7890123', false, 3);  -- Baja California Sur (4)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'JKL0123456', false, 4);  -- Campeche (5)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'MNO3456789', false, 5);  -- Coahuila (6)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'PQR6789012', false, 6);  -- Colima (7)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'STU9012345', false, 7);  -- CDMX (8)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'XYZ1234567', false, 7);  -- CDMX (9)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'ABC7890123', false, 7);  -- CDMX  (10)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'VWX2345678', false, 8);  -- Durango (11)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'YZA5678901', false, 9);  -- Guanajuato (12)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'BCD8901234', false, 10);  -- Hidalgo (13)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'EFG1234567', false, 11);  -- Jalisco (14)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'RST6789012', false, 11);  -- Jalisco (15)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'HIJ4567890', false, 12);  -- México (16)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'UVW2345678', false, 12);  -- México (17)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'KLM7890123', false, 13);  -- Michoacán (18)

insert into placa (placa_id, numero_placa, es_inactiva, estado_id) 
values (placa_id_seq.nextval, 'NOP0123456', false, 14);  -- Morelos (19)

Prompt tabla propietario
---Tabla propietario---
insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados) 
values (propietario_id_seq.nextval, 'NING950608081', 'Galilea', 'Nicolas', 'Nicolas', 
  'NING950608MOAXCG04', 'galilea.nicolas@gmail.com', 0);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados) 
values (propietario_id_seq.nextval, 'HEMC800420KLA', 'Cecilia', 'Hernandez', 'Martinez', 
  'HEMC800420MDFNRN01', 'cecilia.martinez@gmail.com', 0);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados) 
values (propietario_id_seq.nextval, 'JUAR900408HLN', 'Juan', 'Ramírez', 'López', 
  'JUAR900408HDFJNL04', 'juan.ramirez@gmail.com', 0);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados) 
values (propietario_id_seq.nextval, 'ALVE950914HDF', 'Alejandra', 'Velázquez', null, 
  'ALVE950914HDFVLL05', 'alejandra.velazquez@gmail.com', 0);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados) 
values (propietario_id_seq.nextval, 'DULA850205LDA', 'Luis', 'Duran', 'Arenas', 
  'DUAL850205HJCNRN02', 'luis.sergio@gmail.com', 30);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados) 
values (propietario_id_seq.nextval, 'ROCJ901110JRC', 'Jorge', 'Rodriguez', 'Campos', 
  'RORJ901110HDFMPR09', 'jorge.campos@gmail.com', 70);

insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados) 
values (propietario_id_seq.nextval, 'RAHJ920315032', 'Gustavo', 'Ramos', 'Heredia', 
  'RAHJ920315HQTMSR01', 'gustavo.ramos@gmail.com', 0);
  
insert into propietario (propietario_id, rfc, nombre, apellido_paterno, apellido_materno, 
  curp, correo, puntos_negativos_acumulados) 
values (propietario_id_seq.nextval, 'MARP880720HLN', 'María', 'Pérez', 'Navarro', 
  'MARP880720HDFMPN09', 'maria.perez@gmail.com', 0);

Prompt tabla licencia
---Tabla licencia---
insert into licencia (licencia_id, tipo, descripcion) 
values (licencia_id_seq.nextval, 'A', 'Licencia para taxis tipo sedán.');

insert into licencia (licencia_id, tipo, descripcion) 
values (licencia_id_seq.nextval, 'B', 
  'Licencia para camionetas que no transportan pasajeros de pie.');

insert into licencia (licencia_id, tipo, descripcion) 
values (licencia_id_seq.nextval, 'C', 
  'Licencia para autobuses y camiones con capacidad de 20 o más pasajeros.');

prompt tabla licencia propietario
insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '12345678', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('10/01/2005','dd/mm/yyyy'), null, 1, 1);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '12345677', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('11/02/2006','dd/mm/yyyy'), null, 2, 1);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '12345777', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('12/03/2007','dd/mm/yyyy'), null, 3, 1);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '12347777', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('13/04/2008','dd/mm/yyyy'), null, 4, 2);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '12345578', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('14/05/2009','dd/mm/yyyy'), null, 5, 2);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '13345678', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('15/06/2010','dd/mm/yyyy'), null, 6, 2);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '11345678', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('16/07/2011','dd/mm/yyyy'), null, 7, 3);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '12344678', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('11/01/2012','dd/mm/yyyy'), null, 8, 3);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '87654321', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('18/07/2013','dd/mm/yyyy'), null, 1, 3);

insert into licencia_propietario (licencia_propietario_id, num_licencia, foto, firma, 
  huella_indice_der, huella_indice_izq, fecha_adquisicion, licencia_remplazo_id,
  propietario_id, licencia_id)
values (licencia_propietario_id_seq.nextval, '87664321', empty_blob(), empty_blob(), 
  empty_blob(), empty_blob(), to_date('14/09/2015','dd/mm/yyyy'), null, 2, 2);


Prompt tabla multa
insert into multa (propietario_id, folio, fecha_registro, descripcion, puntos_negativos, 
  documento_pdf) 
values (6, '00001', to_date('15/07/2023', 'dd/mm/yyyy'), 
  'Infracción por estacionarse en lugar prohibido, causando obstrucción.', 20, empty_blob());

insert into multa (propietario_id, folio, fecha_registro, descripcion, puntos_negativos, 
  documento_pdf) 
values (6, '00002', to_date('10/08/2023', 'dd/mm/yyyy'), 
  'Multa por exceso de velocidad en zona escolar.', 20, empty_blob());

insert into multa (propietario_id, folio, fecha_registro, descripcion, puntos_negativos, 
  documento_pdf) 
values (6, '00003', to_date('20/10/2023', 'dd/mm/yyyy'), 
  'Conducir sin luces delanteras durante la noche.', 15, empty_blob());

insert into multa (propietario_id, folio, fecha_registro, descripcion, puntos_negativos, 
  documento_pdf) 
values (6, '00004', to_date('05/03/2024', 'dd/mm/yyyy'), 
  'Violación de semáforo en rojo en cruce concurrido.', 15, empty_blob());

insert into multa (propietario_id, folio, fecha_registro, descripcion, puntos_negativos, 
  documento_pdf) 
values (5, '00001', to_date('05/07/2023', 'dd/mm/yyyy'), 
  'Estacionarse en lugar para personas con discapacidad sin permiso.', 15, empty_blob());

insert into multa (propietario_id, folio, fecha_registro, descripcion, puntos_negativos, 
  documento_pdf) 
values (5, '00002', to_date('12/09/2023', 'dd/mm/yyyy'), 
  'Multa por no llevar puesto el cinturón de seguridad', 15, empty_blob());

Prompt tabla status_vehiculo

insert into status_vehiculo (status_vehiculo_id, nombre, descripcion) 
values (status_vehiculo_id_seq.nextval, 'EN REGLA', 'Vehículo con todos los requisitos en orden.');

insert into status_vehiculo (status_vehiculo_id, nombre, descripcion) 
values (status_vehiculo_id_seq.nextval, 'CON LICENCIA EXPIRADA', 
  'Vehículo cuya licencia ha expirado.');

insert into status_vehiculo (status_vehiculo_id, nombre, descripcion) 
values (status_vehiculo_id_seq.nextval, 'CON ADEUDO DE IMPUESTO', 
  'Vehículo con pagos de impuestos pendientes.');

insert into status_vehiculo (status_vehiculo_id, nombre, descripcion) 
values (status_vehiculo_id_seq.nextval, 'CON VERIFICACIÓN PENDIENTE', 
  'Vehículo sin cumplir con la verificación obligatoria.');

Prompt tabla contaminante

insert into contaminante (contaminante_id, clave, nombre) 
values (contaminante_id_seq.nextval, 'HC', 'Hidrocarburos.');

insert into contaminante (contaminante_id, clave, nombre) 
values (contaminante_id_seq.nextval, 'CO', 'Monóxido de Carbono.');

insert into contaminante (contaminante_id, clave, nombre) 
values (contaminante_id_seq.nextval, 'NOX', 'Óxido de Nitrógeno.');

insert into contaminante (contaminante_id, clave, nombre) 
values (contaminante_id_seq.nextval, 'CO2', 'Dióxido de Carbono.');

Prompt tabla vehiculo

--Tabla vehiculo

-- Vehículos de tipo transporte_publico (es_transporte_publico = 1)
insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '1A2B3C4D5E6F7G8H9J', '2022', 1, 0, 0, '1A2B3C4D5E6F7G8H9K', 
to_date('01/07/2023', 'dd/mm/yyyy'), 2, 1, 1, 1); 

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '2B3C4D5E6F7G8H9I0K', '2021', 1, 0, 0, '2B3C4D5E6F7G8H9L0M', 
to_date('10/08/2023', 'dd/mm/yyyy'), 3, 1, 1, 2); 

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '3C4D5E6F7G8H9I0J1L', '2023', 1, 0, 0, '3C4D5E6F7G8H9M0N1P', 
to_date('05/09/2023', 'dd/mm/yyyy'), 6, 1, 3, 3); 

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '4D5E6F7G8H9I0J1K2M', '2020', 1, 0, 0, '4D5E6F7G8H9I0N1P3Q', 
to_date('15/10/2023', 'dd/mm/yyyy'), 7, 1, 5, 4); 


-- Vehículos de tipo carga (es_carga = 1)
insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '5E6F7G8H9I0J1K2L3N', '2018', 0, 1, 0, '5E6F7G8H9I0J1K2L', 
to_date('01/06/2023', 'dd/mm/yyyy'), 8, 1, 5, 5); 

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '6F7G8H9I0J1K2L3N4O', '2021', 0, 1, 0, '6F7G8H9I0J1K2L5P', 
to_date('10/09/2023', 'dd/mm/yyyy'), 11, 1, 4, 6); 

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '7G8H9I0J1K2L3N4O5P', '2022', 0, 1, 0, '7G8H9I0J1K2L6Q', 
to_date('20/09/2023', 'dd/mm/yyyy'), 12, 1, 8, 7); 

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '8H9I0J1K2L3N4O5P6Q', '2020', 0, 1, 0, '8H9I0J1K2L7R', 
to_date('30/10/2023', 'dd/mm/yyyy'), 13, 1, 9, 8); 


-- Vehículos de tipo particular (es_particular = 1)
insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, '9I0J1K2L3M4N5O6P', '2021', 0, 0, 1, '9I0J1K2L3M9S', 
to_date('02/11/2023', 'dd/mm/yyyy'), 14, 1, 10, 1); 

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, 'A0J1K2L3M4N5O6P7Q', '2020', 0, 0, 1, 'A0J1K2L3M10T', 
to_date('04/11/2023', 'dd/mm/yyyy'), 5, 1, 12, 2); 

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, 'B1K2L3M4N5O6P7Q8R', '2022', 0, 0, 1, 'B1K2L3M4N11U', 
to_date('12/11/2023', 'dd/mm/yyyy'), 16, 1, 13, 3); 

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, 'C2L3M4N5O6P7Q8R9S', '2023', 0, 0, 1, 'C2L3M4N5O12V', 
to_date('15/11/2023', 'dd/mm/yyyy'), 17, 1, 13, 4); 

-- Vehículos de tipo carga y particular (es_carga = 1 y es_particular = 1)
insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, 'D3M4N5O6P7Q8R9S0T', '2020', 0, 1, 1, 'D3M4N5O6P8R', 
to_date('28/11/2023', 'dd/mm/yyyy'), 18, 1, 6, 5); 

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, 'E4N5O6P7Q8R9S0T1U', '2021', 0, 1, 1, 'E4N5O6P8Q9S', 
to_date('05/12/2023', 'dd/mm/yyyy'), 19, 1, 17, 6); 

insert into vehiculo (vehiculo_id, numero_serie, anio, es_transporte_publico, es_carga, 
  es_particular, num_serie_dispo_medicion, fecha_status, placa_id, status_vehiculo_id, 
  modelo_id, propietario_id) 
values (vehiculo_id_seq.nextval, 'F5O6P7Q8R9S0T1U2V', '2023', 0, 1, 1, 'F5O6P7Q8S10T', 
to_date('07/12/2023', 'dd/mm/yyyy'), 9, 1, 17, 7); 


prompt tabla vehiculo_transporte_publico
insert into vehiculo_transporte_publico (vehiculo_id, pasajeros_sentados, pasajeros_parados, 
  licencia_id) 
values (1, 4, 0, 1);

insert into vehiculo_transporte_publico (vehiculo_id, pasajeros_sentados, pasajeros_parados, 
  licencia_id) 
values (2, 4, 0, 1);

insert into vehiculo_transporte_publico (vehiculo_id, pasajeros_sentados, pasajeros_parados, 
  licencia_id)
values (3, 4, 0, 1);

insert into vehiculo_transporte_publico (vehiculo_id, pasajeros_sentados, pasajeros_parados, 
  licencia_id)
values (4, 4, 0, 1);


prompt tabla vehiculo_carga
insert into vehiculo_carga (vehiculo_id, capacidad, unidad_capacidad, numero_remolques)
values (5, 1, 't', null);

insert into vehiculo_carga (vehiculo_id, capacidad, unidad_capacidad, numero_remolques)
values (6, 3, 'm3', null);

insert into vehiculo_carga (vehiculo_id, capacidad, unidad_capacidad, numero_remolques)
values (2, 1, 't', null);

insert into vehiculo_carga (vehiculo_id, capacidad, unidad_capacidad, numero_remolques)
values (8, 1, 'm3', null);


prompt tabla vehiculo_particular
insert into vehiculo_particular (vehiculo_id, num_bolsas_aire, cuenta_con_frenos_abs, 
tipo_transmision, porcentaje_impuesto, porcentaje_seguro)
values (9, 6, true, 'A', 16.50, 8.75);

insert into vehiculo_particular (vehiculo_id, num_bolsas_aire, cuenta_con_frenos_abs, 
tipo_transmision, porcentaje_impuesto, porcentaje_seguro)
values (10, 4, false, 'M', 11.56, 10.00);

insert into vehiculo_particular (vehiculo_id, num_bolsas_aire, cuenta_con_frenos_abs, 
tipo_transmision, porcentaje_impuesto, porcentaje_seguro)
values (11, 8, true, 'A', 13.00, 7.50);

insert into vehiculo_particular (vehiculo_id, num_bolsas_aire, cuenta_con_frenos_abs, 
tipo_transmision, porcentaje_impuesto, porcentaje_seguro)
values (12, 7, false, 'M', 10.50, 9.25);

prompt vehiculos que son de carga y particular al mismo tiempo

insert into vehiculo_particular (vehiculo_id, num_bolsas_aire, cuenta_con_frenos_abs, 
tipo_transmision, porcentaje_impuesto, porcentaje_seguro)
values (13, 7, true, 'A', 12.30, 8.75);

insert into vehiculo_particular(vehiculo_id, num_bolsas_aire, cuenta_con_frenos_abs, 
tipo_transmision, porcentaje_impuesto, porcentaje_seguro)
values (14, 4, false, 'M', 9.95, 6.80);

insert into vehiculo_particular (vehiculo_id, num_bolsas_aire, cuenta_con_frenos_abs, 
tipo_transmision, porcentaje_impuesto, porcentaje_seguro)
values (15, 8, true, 'A', 11.30, 8.50);
-------------------------------------------------------------------------------------
insert into vehiculo_carga (vehiculo_id, capacidad, unidad_capacidad, numero_remolques)
values (13, 4, 'm3', null);

insert into vehiculo_carga (vehiculo_id, capacidad, unidad_capacidad, numero_remolques)
values (14, 3, 'm3', null);

insert into vehiculo_carga (vehiculo_id, capacidad, unidad_capacidad, numero_remolques)
values (15, 5, 'm3', null);

prompt tabla contaminante_vehiculo
-- vehículo 1
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (1, 0.35, to_date('01/01/2024', 'dd/mm/yyyy'), 1, 1);

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (2, 0.32, to_date('15/02/2024', 'dd/mm/yyyy'), 1, 2);

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (3, 0.29, to_date('10/03/2024', 'dd/mm/yyyy'), 1, 3);

-- vehículo 2
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (4, 0.30, to_date('05/01/2024', 'dd/mm/yyyy'), 2, 4);

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (5, 0.33, to_date('20/02/2024', 'dd/mm/yyyy'), 2, 1);

-- vehículo 3
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (6, 0.31, to_date('03/01/2024', 'dd/mm/yyyy'), 3, 2);

-- vehículo 4
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (7, 0.28, to_date('15/02/2024', 'dd/mm/yyyy'), 4, 3);

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (8, 0.32, to_date('25/03/2024', 'dd/mm/yyyy'), 4, 4);

-- vehículo 5
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (9, 0.36, to_date('01/01/2024', 'dd/mm/yyyy'), 5, 1);

-- vehículo 6
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (10, 0.34, to_date('10/02/2024', 'dd/mm/yyyy'), 6, 2);

-- vehículo 7
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (11, 0.33, to_date('20/03/2024', 'dd/mm/yyyy'), 7, 3);

-- vehículo 8
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (12, 0.32, to_date('05/01/2024', 'dd/mm/yyyy'), 8, 4);

-- vehículo 9
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (13, 0.29, to_date('10/02/2024', 'dd/mm/yyyy'), 9, 1);

-- vehículo 10
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (14, 0.30, to_date('15/03/2024', 'dd/mm/yyyy'), 10, 2);

-- vehículo 11
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (15, 0.31, to_date('25/03/2024', 'dd/mm/yyyy'), 11, 3);

-- vehículo 12
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (16, 0.35, to_date('01/01/2024', 'dd/mm/yyyy'), 12, 4);

-- vehículo 13
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (17, 0.33, to_date('10/02/2024', 'dd/mm/yyyy'), 13, 1);

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (18, 0.30, to_date('25/03/2024', 'dd/mm/yyyy'), 13, 2);

-- vehículo 14
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (19, 0.28, to_date('05/01/2024', 'dd/mm/yyyy'), 14, 3);

-- vehículo 15
insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (20, 0.32, to_date('15/02/2024', 'dd/mm/yyyy'), 15, 4);

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (21, 0.29, to_date('20/03/2024', 'dd/mm/yyyy'), 15, 1);

insert into contaminante_vehiculo (contaminante_vehiculo_id, medicion, fecha_registro, 
  vehiculo_id, contaminante_id)
values (22, 0.34, to_date('10/04/2024', 'dd/mm/yyyy'), 15, 3);

prompt carga completada
commit; 
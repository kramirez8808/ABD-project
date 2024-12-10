--ELIMINAR TABLAS CREADAS ANTERIORMENTE
/*
drop table auditoria_pedidos cascade constraints;
drop table auditoria_vehiculo cascade constraints;
drop table cantones cascade constraints;
drop table clientes cascade constraints;
drop table direcciones_cliente cascade constraints;
drop table direcciones_empleado cascade constraints;
drop table direcciones_pedido cascade constraints;
drop table distritos cascade constraints;
drop table empleados cascade constraints;
drop table estados cascade constraints;
drop table facturas cascade constraints;
drop table licencias cascade constraints;
drop table licencias_empleado cascade constraints;
drop table pedidos cascade constraints;
drop table provincias cascade constraints;
drop table puestos cascade constraints;
drop table tipos_carga cascade constraints;
drop table vehiculos cascade constraints;
*/
/
create user test1 identified by 123;
grant create session to test1;
grant dba to test1;
GRANT RESOURCE TO test1;
/
--DESDE SQL PLUS
ALTER SYSTEM SET AUDIT_TRAIL=DB,EXTENDED SCOPE=SPFILE;
SHUTDOWN IMMEDIATE;
STARTUP;
/
--Aumentar limite de cursores
ALTER SYSTEM SET open_cursors = 1700 SCOPE=BOTH;
/
--CREACION DEL PERFIL
CREATE PROFILE FIDE_PROYECTO_FINAL_PROF LIMIT SESSIONS_PER_USER 2 FAILED_LOGIN_ATTEMPTS 5;
/
--Asignacion del perfil
ALTER USER test1 PROFILE FIDE_PROYECTO_FINAL_PROF;
/
--CREACION TABLESPACE
CREATE TABLESPACE FIDE_PROYECTO_FINAL_TBS
DATAFILE 'C:\ORACLE\ORADATA\ORCL\FIDE_PROYECTO_FINAL_TBS' SIZE 200M;
/
-- TABLES
CREATE TABLE fide_estados_tb (
    id_estado NUMBER NOT NULL,
    descripcion VARCHAR2(50)
);
ALTER TABLE fide_estados_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_ESTADOS_TB ADD CONSTRAINT FIDE_ESTADOS_TB_ID_ESTADO_PK PRIMARY KEY (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_ESTADOS_SEQ
START WITH 1
INCREMENT BY 1;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_ESTADOS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_ESTADOS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_ESTADO IS NULL THEN
        :NEW.ID_ESTADO := FIDE_ESTADOS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS ESTADOS
INSERT INTO fide_estados_tb (descripcion) VALUES ('Cancelado');
INSERT INTO fide_estados_tb (descripcion) VALUES ('No aceptado');
INSERT INTO fide_estados_tb (descripcion) VALUES ('Aceptado');
INSERT INTO fide_estados_tb (Descripcion) VALUES ('En Proceso');
INSERT INTO fide_estados_tb (Descripcion) VALUES ('Entregado');
INSERT INTO fide_estados_tb (Descripcion) VALUES ('Completado');
INSERT INTO fide_estados_tb (Descripcion) VALUES ('Activo');
INSERT INTO fide_estados_tb (Descripcion) VALUES ('Inactivo');
COMMIT;

CREATE TABLE fide_roles_tb (
    id_rol NUMBER NOT NULL,
    descripcion VARCHAR2(50),
    id_estado NUMBER
);
ALTER TABLE fide_roles_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_ROLES_TB ADD CONSTRAINT FIDE_ROLES_TB_ID_ROL_PK PRIMARY KEY (ID_ROL);
ALTER TABLE FIDE_ROLES_TB ADD CONSTRAINT FIDE_ROLES_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_ROLES_SEQ
START WITH 1
INCREMENT BY 1;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_ROLES_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_ROLES_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_ROL IS NULL THEN
        :NEW.ID_ROL := FIDE_ROLES_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS ROLES
INSERT INTO fide_roles_tb (DESCRIPCION, ID_ESTADO) VALUES ('Administrador', 7);
INSERT INTO fide_roles_tb (DESCRIPCION, ID_ESTADO) VALUES ('Usuario', 7);
INSERT INTO fide_roles_tb (DESCRIPCION, ID_ESTADO) VALUES ('Invitado', 7);
COMMIT;

CREATE TABLE fide_usuarios_tb (
    id_usuario NUMBER NOT NULL,
    usuario VARCHAR2(50),
    contrasena VARCHAR2(255),
    id_rol NUMBER,
    id_estado NUMBER
);
ALTER TABLE fide_usuarios_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_USUARIOS_TB ADD CONSTRAINT FIDE_USUARIOS_TB_ID_USUARIO_PK PRIMARY KEY (ID_USUARIO);
ALTER TABLE FIDE_USUARIOS_TB ADD CONSTRAINT FIDE_USUARIOS_TB_ID_ROL_FK FOREIGN KEY (ID_ROL) REFERENCES FIDE_ROLES_TB (ID_ROL);
ALTER TABLE FIDE_USUARIOS_TB ADD CONSTRAINT FIDE_USUARIOS_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);
COMMIT;

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_USUARIOS_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_USUARIOS_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_USUARIOS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_USUARIOS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_USUARIO IS NULL THEN
        :NEW.ID_USUARIO := FIDE_USUARIOS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS USUARIOS
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Juan', '123', 1, 7); --ADMINISTRADOR
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Maria', '456', 2, 7); --USUARIO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Carlos', 'carlos123', 3, 7); --INVITADO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Luis', '789', 1, 7); --ADMINISTRADOR
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Ana', '101', 2, 7); --USUARIO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Miguel', 'miguel123', 3, 7); --INVITADO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Rosa', 'rosa123', 1, 7); --ADMINISTRADOR
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Pablo', 'pablo456', 2, 7); --USUARIO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Sofia', 'sofia789', 3, 7); --INVITADO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Jorge', 'jorge101', 1, 7); --ADMINISTRADOR
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Clara', 'clara123', 2, 7); --USUARIO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Hector', 'hector456', 3, 7); --INVITADO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Laura', 'laura789', 1, 7); --ADMINISTRADOR
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Fernando', 'fernando101', 2, 7); --USUARIO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Elena', 'elena123', 3, 7); --INVITADO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Raul', 'raul456', 1, 7); --ADMINISTRADOR
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Patricia', 'patricia789', 2, 7); --USUARIO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Diego', 'diego101', 3, 7); --INVITADO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Natalia', 'natalia123', 1, 7); --ADMINISTRADOR
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Andres', 'andres456', 2, 7); --USUARIO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Paula', 'paula789', 3, 7); --INVITADO
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Esteban', 'esteban101', 1, 7); --ADMINISTRADOR
INSERT INTO fide_usuarios_tb (usuario, contrasena, id_rol, id_estado) VALUES ('Irene', 'irene123', 2, 7); --USUARIO
COMMIT;

CREATE TABLE fide_vehiculos_tb (
    id_vehiculo NUMBER NOT NULL,
    marca VARCHAR2(50),
    modelo VARCHAR2(50),
    anio INT,
    placa VARCHAR2(10),
    id_estado NUMBER
);
ALTER TABLE fide_vehiculos_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;


--LLAVES
ALTER TABLE FIDE_VEHICULOS_TB ADD CONSTRAINT FIDE_VEHICULOS_TB_ID_VEHICULO_PK PRIMARY KEY (ID_VEHICULO);
ALTER TABLE FIDE_VEHICULOS_TB ADD CONSTRAINT FIDE_VEHICULOS_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_VEHICULOS_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_VEHICULOS_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_VEHICULOS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_VEHICULOS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_VEHICULO IS NULL THEN
        :NEW.ID_VEHICULO := FIDE_VEHICULOS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS VEHICULOS
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Toyota', 'Hilux', 2018, 'CMV-000', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Nissan', 'Navara', 2019, 'CMV-002', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Mitsubishi', 'L200', 2020, 'CMV-004', 8);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Scania', 'R450', 2017, '678901', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Mercedes-Benz', 'Actros', 2018, '789012', 8);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('MAN', 'TGX', 2019, '890123', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Chevrolet', 'Colorado', 2021, 'CMV-004', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Mazda', 'BT-50', 2022, 'CMV-005', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Toyota', 'Hilux', 2018, 'CMV-000', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Nissan', 'Navara', 2019, 'CMV-002', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Mitsubishi', 'L200', 2020, 'CMV-004', 8);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Ford', 'Ranger', 2021, 'CMV-006', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Volvo', 'FH', 2016, '567890', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Scania', 'R450', 2017, '678901', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Mercedes-Benz', 'Actros', 2018, '789012', 8);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('MAN', 'TGX', 2019, '890123', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Toyota', 'Hilux', 2018, 'CMV-001', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Nissan', 'Frontier', 2019, 'CMV-002', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Ford', 'Ranger', 2020, 'CMV-003', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Chevrolet', 'Colorado', 2021, 'CMV-004', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Mazda', 'BT-50', 2022, 'CMV-005', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Honda', 'Ridgeline', 2023, 'CMV-006', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Mitsubishi', 'Triton', 2024, 'CMV-007', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Isuzu', 'D-Max', 2018, 'CMV-008', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Volkswagen', 'Amarok', 2019, 'CMV-009', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Fiat', 'Toro', 2020, 'CMV-010', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Hyundai', 'Santa Cruz', 2021, 'CMV-011', 7);
INSERT INTO fide_vehiculos_tb (Marca, Modelo, Anio, Placa, id_estado) VALUES ('Jeep', 'Gladiator', 2022, 'CMV-012', 7);
COMMIT;

CREATE TABLE fide_licencias_tb (
    id_licencia NUMBER NOT NULL,
    tipo VARCHAR2(50),
    id_estado NUMBER
);
ALTER TABLE fide_licencias_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_LICENCIAS_TB ADD CONSTRAINT FIDE_LICENCIAS_TB_ID_LICENCIA_PK PRIMARY KEY (ID_LICENCIA);
ALTER TABLE FIDE_LICENCIAS_TB ADD CONSTRAINT FIDE_LICENCIAS_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_LICENCIAS_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_LICENCIAS_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_LICENCIAS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_LICENCIAS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_LICENCIA IS NULL THEN
        :NEW.ID_LICENCIA := FIDE_LICENCIAS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS TIPOS DE LICENCIAS
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo A1', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo A2', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo A3', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo B1', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo B2', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo B3', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo B4', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo C1', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo C2', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo D1', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo D2', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo D3', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo E1', 7);
INSERT INTO fide_licencias_tb (Tipo, id_estado) VALUES ('Tipo E2', 7);
COMMIT;

CREATE TABLE fide_puestos_tb (
    id_puesto VARCHAR2(10) NOT NULL,
    salario NUMBER,
    descripcion VARCHAR2(100),
    id_estado NUMBER
);
ALTER TABLE fide_puestos_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_PUESTOS_TB ADD CONSTRAINT FIDE_PUESTOS_TB_ID_PUESTO_PK PRIMARY KEY (ID_PUESTO);
ALTER TABLE FIDE_PUESTOS_TB ADD CONSTRAINT FIDE_PUESTOS_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_PUESTOS_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_PUESTOS_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_PUESTOS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_PUESTOS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_PUESTO IS NULL THEN
        :NEW.ID_PUESTO := FIDE_PUESTOS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS PUESTOS
INSERT INTO fide_puestos_tb (ID_Puesto, Salario, Descripcion, id_estado) VALUES ('DRV-01', 750000, 'Conductor Nivel 1', 7);
INSERT INTO fide_puestos_tb (ID_Puesto, Salario, Descripcion, id_estado) VALUES ('DRV-02', 900000, 'Conductor Nivel 2', 7);
INSERT INTO fide_puestos_tb (ID_Puesto, Salario, Descripcion, id_estado) VALUES ('DRV-03', 1100000, 'Conductor Nivel 3', 7);
INSERT INTO fide_puestos_tb (ID_Puesto, Salario, Descripcion, id_estado) VALUES ('LOG-MGR', 920000, 'Administrador de Logistica', 7);
INSERT INTO fide_puestos_tb (ID_Puesto, Salario, Descripcion, id_estado) VALUES ('STR-MGR', 800000, 'Administrador de Almacen', 7);
INSERT INTO fide_puestos_tb (ID_Puesto, Salario, Descripcion, id_estado) VALUES ('DRV-MGR', 1000000, 'Administrador de Conductores', 7);
INSERT INTO fide_puestos_tb (ID_Puesto, Salario, Descripcion, id_estado) VALUES ('MTN-TEC', 850000, 'Tecnico de Mantenimiento', 7);
INSERT INTO fide_puestos_tb (ID_Puesto, Salario, Descripcion, id_estado) VALUES ('MTN-ENG', 1300000, 'Ingeniero de Mantenimiento', 7);
COMMIT;

CREATE TABLE fide_tipos_carga_tb (
    id_tipo_carga NUMBER NOT NULL,
    descripcion VARCHAR2(50),
    id_estado NUMBER
);
ALTER TABLE fide_tipos_carga_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_TIPOS_CARGA_TB ADD CONSTRAINT FIDE_TIPOS_CARGA_TB_ID_TIPO_CARGA_PK PRIMARY KEY (ID_TIPO_CARGA);
ALTER TABLE FIDE_TIPOS_CARGA_TB ADD CONSTRAINT FIDE_TIPOS_CARGA_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_TIPOS_CARGA_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_TIPOS_CARGA_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_TIPOS_CARGA_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_TIPOS_CARGA_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_TIPO_CARGA IS NULL THEN
        :NEW.ID_TIPO_CARGA := FIDE_TIPOS_CARGA_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS TIPOS DE CARGAS
-- Carga a granel: Este tipo de carga incluye materiales como granos, minerales, petróleo, gas, entre otros. Son transportados en grandes cantidades y no requieren embalaje.
-- Carga general: Este tipo de carga incluye mercancías empaquetadas individualmente, como electrodomésticos, muebles, y productos electrónicos.
-- Carga fraccionada: Este tipo de carga incluye mercancías que son demasiado grandes para ser enviadas como carga general, pero demasiado pequeñas para requerir un camión completo.
-- Carga de contenedor: Este tipo de carga se transporta en contenedores estandarizados que pueden ser cargados y descargados, apilados, transportados de manera eficiente a largas distancias.
-- Carga pesada o sobredimensionada: Este tipo de carga es demasiado grande o pesada para ser transportada en un camión estándar o contenedor. Puede requerir permisos especiales y equipos de manejo especializados.
-- Carga peligrosa: Este tipo de carga incluye materiales que son potencialmente peligrosos, como productos químicos, materiales radiactivos y explosivos.
-- Carga refrigerada: Este tipo de carga requiere control de temperatura durante el transporte. Incluye alimentos, productos farmacéuticos y ciertos productos químicos.
INSERT INTO fide_tipos_carga_tb (Descripcion, id_estado) VALUES ('Carga a granel', 7);
INSERT INTO fide_tipos_carga_tb (Descripcion, id_estado) VALUES ('Carga general', 7);
INSERT INTO fide_tipos_carga_tb (Descripcion, id_estado) VALUES ('Carga fraccionada', 7);
INSERT INTO fide_tipos_carga_tb (Descripcion, id_estado) VALUES ('Carga de contenedor', 7);
INSERT INTO fide_tipos_carga_tb (Descripcion, id_estado) VALUES ('Carga pesada o sobredimensionada', 7);
INSERT INTO fide_tipos_carga_tb (Descripcion, id_estado) VALUES ('Carga peligrosa', 7);
INSERT INTO fide_tipos_carga_tb (Descripcion, id_estado) VALUES ('Carga refrigerada', 7);
COMMIT;

CREATE TABLE fide_empleados_tb (
    id_empleado NUMBER NOT NULL,
    nombre VARCHAR2(50),
    apellido VARCHAR2(50),
    fecha_nacimiento DATE,
    fecha_contratacion DATE,
    id_puesto VARCHAR2(10),
    id_estado NUMBER
);
ALTER TABLE fide_empleados_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_EMPLEADOS_TB ADD CONSTRAINT FIDE_EMPLEADOS_TB_ID_EMPLEADO_PK PRIMARY KEY (ID_EMPLEADO);
ALTER TABLE FIDE_EMPLEADOS_TB ADD CONSTRAINT FIDE_EMPLEADOS_TB_ID_PUESTO_FK FOREIGN KEY (ID_PUESTO) REFERENCES FIDE_PUESTOS_TB (ID_PUESTO);
ALTER TABLE FIDE_EMPLEADOS_TB ADD CONSTRAINT FIDE_EMPLEADOS_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_EMPLEADOS_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_EMPLEADOS_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_EMPLEADOS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_EMPLEADOS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_EMPLEADO IS NULL THEN
        :NEW.ID_EMPLEADO := FIDE_EMPLEADOS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS EMPLEADOS
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Juan', 'Perez', TO_DATE('2003-03-03', 'YYYY-MM-DD'), TO_DATE('2020-01-01', 'YYYY-MM-DD'), 'DRV-01', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Maria', 'Gonzalez', TO_DATE('1998-08-08', 'YYYY-MM-DD'), TO_DATE('2021-11-11', 'YYYY-MM-DD'), 'DRV-02', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Pedro', 'Rodriguez', TO_DATE('1994-04-04', 'YYYY-MM-DD'), TO_DATE('2022-02-02', 'YYYY-MM-DD'), 'DRV-03', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Ana', 'Jimenez', TO_DATE('1995-05-05', 'YYYY-MM-DD'), TO_DATE('2024-12-22', 'YYYY-MM-DD'), 'MTN-TEC', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Luis', 'Hernandez', TO_DATE('1990-10-10', 'YYYY-MM-DD'), TO_DATE('2023-03-03', 'YYYY-MM-DD'), 'MTN-ENG', 7);

INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Jorge', 'Perez', TO_DATE('2003-03-03', 'YYYY-MM-DD'), TO_DATE('2020-01-01', 'YYYY-MM-DD'), 'DRV-01', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Emmanuel', 'Gonzalez', TO_DATE('1998-08-08', 'YYYY-MM-DD'), TO_DATE('2021-11-11', 'YYYY-MM-DD'), 'DRV-02', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Alberto', 'Rodriguez', TO_DATE('1994-04-04', 'YYYY-MM-DD'), TO_DATE('2022-02-02', 'YYYY-MM-DD'), 'DRV-03', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Morelio', 'Jimenez', TO_DATE('1995-05-05', 'YYYY-MM-DD'), TO_DATE('2024-12-22', 'YYYY-MM-DD'), 'MTN-TEC', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Jose', 'Hernandez', TO_DATE('1990-10-10', 'YYYY-MM-DD'), TO_DATE('2023-03-03', 'YYYY-MM-DD'), 'MTN-ENG', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('David', 'Perez', TO_DATE('2003-03-03', 'YYYY-MM-DD'), TO_DATE('2020-01-01', 'YYYY-MM-DD'), 'DRV-01', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Gabriel', 'Gonzalez', TO_DATE('1998-08-08', 'YYYY-MM-DD'), TO_DATE('2021-11-11', 'YYYY-MM-DD'), 'DRV-02', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Allan', 'Rodriguez', TO_DATE('1994-04-04', 'YYYY-MM-DD'), TO_DATE('2022-02-02', 'YYYY-MM-DD'), 'DRV-03', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Roberto', 'Jimenez', TO_DATE('1995-05-05', 'YYYY-MM-DD'), TO_DATE('2024-12-22', 'YYYY-MM-DD'), 'MTN-TEC', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Angela', 'Hernandez', TO_DATE('1990-10-10', 'YYYY-MM-DD'), TO_DATE('2023-03-03', 'YYYY-MM-DD'), 'MTN-ENG', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Nicole', 'Perez', TO_DATE('2003-03-03', 'YYYY-MM-DD'), TO_DATE('2020-01-01', 'YYYY-MM-DD'), 'DRV-01', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Valeria', 'Gonzalez', TO_DATE('1998-08-08', 'YYYY-MM-DD'), TO_DATE('2021-11-11', 'YYYY-MM-DD'), 'DRV-02', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Bryan', 'Rodriguez', TO_DATE('1994-04-04', 'YYYY-MM-DD'), TO_DATE('2022-02-02', 'YYYY-MM-DD'), 'DRV-03', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Gustavo', 'Jimenez', TO_DATE('1995-05-05', 'YYYY-MM-DD'), TO_DATE('2024-12-22', 'YYYY-MM-DD'), 'MTN-TEC', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Esteban', 'Hernandez', TO_DATE('1990-10-10', 'YYYY-MM-DD'), TO_DATE('2023-03-03', 'YYYY-MM-DD'), 'MTN-ENG', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Ruth', 'Perez', TO_DATE('2003-03-03', 'YYYY-MM-DD'), TO_DATE('2020-01-01', 'YYYY-MM-DD'), 'DRV-01', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Mary', 'Gonzalez', TO_DATE('1998-08-08', 'YYYY-MM-DD'), TO_DATE('2021-11-11', 'YYYY-MM-DD'), 'DRV-02', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Frank', 'Rodriguez', TO_DATE('1994-04-04', 'YYYY-MM-DD'), TO_DATE('2022-02-02', 'YYYY-MM-DD'), 'DRV-03', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Cristian', 'Jimenez', TO_DATE('1995-05-05', 'YYYY-MM-DD'), TO_DATE('2024-12-22', 'YYYY-MM-DD'), 'MTN-TEC', 7);
INSERT INTO fide_empleados_tb (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, id_estado) VALUES ('Gonzalo', 'Hernandez', TO_DATE('1990-10-10', 'YYYY-MM-DD'), TO_DATE('2023-03-03', 'YYYY-MM-DD'), 'MTN-ENG', 7);
COMMIT;

CREATE TABLE fide_licencias_empleado_tb (
    id_licencia_empleado NUMBER NOT NULL,
    id_empleado NUMBER,
    id_licencia NUMBER,
    fecha_expedicion DATE,
    fecha_vencimiento DATE,
    id_estado NUMBER
);
ALTER TABLE fide_licencias_empleado_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_LICENCIAS_EMPLEADO_TB ADD CONSTRAINT FIDE_LICENCIAS_EMPLEADO_TB_ID_EMPLEADO_PK PRIMARY KEY (ID_LICENCIA_EMPLEADO);
ALTER TABLE FIDE_LICENCIAS_EMPLEADO_TB ADD CONSTRAINT FIDE_LICENCIAS_EMPLEADO_TB_ID_EMPLEADO_FK FOREIGN KEY (ID_EMPLEADO) REFERENCES FIDE_EMPLEADOS_TB (ID_EMPLEADO);
ALTER TABLE FIDE_LICENCIAS_EMPLEADO_TB ADD CONSTRAINT FIDE_LICENCIAS_EMPLEADO_TB_ID_LICENCIA_FK FOREIGN KEY (ID_LICENCIA) REFERENCES FIDE_LICENCIAS_TB (ID_LICENCIA);
ALTER TABLE FIDE_LICENCIAS_EMPLEADO_TB ADD CONSTRAINT FIDE_LICENCIAS_EMPLEADO_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_LICENCIAS_EMPLEADO_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_LICENCIAS_EMPLEADO_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_LICENCIAS_EMPLEADO_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_LICENCIAS_EMPLEADO_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_LICENCIA_EMPLEADO IS NULL THEN
        :NEW.ID_LICENCIA_EMPLEADO := FIDE_LICENCIAS_EMPLEADO_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS
INSERT INTO fide_licencias_empleado_tb (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento, id_estado) VALUES (1, 1, TO_DATE('2020-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'), 7);
INSERT INTO fide_licencias_empleado_tb (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento, id_estado) VALUES (2, 2, TO_DATE('2021-11-11', 'YYYY-MM-DD'), TO_DATE('2026-11-11', 'YYYY-MM-DD'), 7);
INSERT INTO fide_licencias_empleado_tb (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento, id_estado) VALUES (3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), TO_DATE('2027-02-02', 'YYYY-MM-DD'), 7);
INSERT INTO fide_licencias_empleado_tb (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento, id_estado) VALUES (4, 4, TO_DATE('2024-12-22', 'YYYY-MM-DD'), TO_DATE('2029-12-22', 'YYYY-MM-DD'), 7);
INSERT INTO fide_licencias_empleado_tb (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento, id_estado) VALUES (5, 5, TO_DATE('2023-03-03', 'YYYY-MM-DD'), TO_DATE('2028-03-03', 'YYYY-MM-DD'), 7);
INSERT INTO fide_licencias_empleado_tb (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento, id_estado) VALUES (2, 13, TO_DATE('2030-03-03', 'YYYY-MM-DD'), TO_DATE('2035-03-03', 'YYYY-MM-DD'), 7);
COMMIT;

CREATE TABLE fide_clientes_tb (
    id_cliente NUMBER NOT NULL,
    nombre VARCHAR2(50),
    apellido VARCHAR2(50),
    telefono VARCHAR2(15),
    email VARCHAR2(100),
    id_estado NUMBER
);
ALTER TABLE fide_clientes_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_CLIENTES_TB ADD CONSTRAINT FIDE_CLIENTES_TB_ID_CLIENTE_PK PRIMARY KEY (ID_CLIENTE);
ALTER TABLE FIDE_CLIENTES_TB ADD CONSTRAINT FIDE_CLIENTES_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_CLIENTES_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_CLIENTES_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_CLIENTES_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_CLIENTES_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_CLIENTE IS NULL THEN
        :NEW.ID_CLIENTE := FIDE_CLIENTES_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Karla', 'Gomez', '1111-1111', 'karla@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Carlos', 'Hernandez', '2222-2222', 'carlos@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Luis', 'Martinez', '3333-3333', 'lusm@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Maria', 'Gonzalez', '4444-4444', 'mariag@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Carlos', 'Rodriguez', '5555-5555', 'carlor@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Anny', 'Lopez', '6666-6666', 'anylop@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Jorge', 'Hernandez', '7777-7777', 'jorgeh@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Sofia', 'Martinez', '8888-8888', 'sofiam@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Alvaro', 'Perez', '9999-9999', 'alvarop@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Valeria', 'Garcia', '1212-1212', 'valeriag@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Fernando', 'Ramirez', '1313-1313', 'fernandor@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Laura', 'Morales', '1414-1414', 'lauram@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('David', 'Jimenez', '1515-1515', 'davidj@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Camila', 'Ortiz', '1616-1616', 'camila@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Ricardo', 'Vargas', '1717-1717', 'ricardov@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Lucia', 'Navarro', '1818-1818', 'lucian@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Antonio', 'Mendoza', '1919-1919', 'antoniom@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Daniela', 'Reyes', '2020-2020', 'danielar@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Francisco', 'Castro', '2121-2121', 'franciscoc@gmail.com', 7);
INSERT INTO fide_clientes_tb (Nombre, Apellido, Telefono, Email, id_estado) VALUES ('Juan', 'Gomez', '1111-1111', 'juan@gmail.com', 7);
COMMIT;


CREATE TABLE fide_provincias_tb (
    id_provincia NUMBER NOT NULL,
    nombre VARCHAR2(50),
    id_estado NUMBER
);
ALTER TABLE fide_provincias_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_PROVINCIAS_TB ADD CONSTRAINT FIDE_PROVINCIAS_TB_ID_PROVINCIA_PK PRIMARY KEY (ID_PROVINCIA);
ALTER TABLE FIDE_PROVINCIAS_TB ADD CONSTRAINT FIDE_PROVINCIAS_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_PROVINCIAS_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_PROVINCIAS_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_PROVINCIAS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_PROVINCIAS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_PROVINCIA IS NULL THEN
        :NEW.ID_PROVINCIA := FIDE_PROVINCIAS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS PROVINCIAS
INSERT INTO fide_provincias_tb (Nombre, id_estado) VALUES ('San Jose', 7);
INSERT INTO fide_provincias_tb (Nombre, id_estado) VALUES ('Heredia', 7);
INSERT INTO fide_provincias_tb (Nombre, id_estado) VALUES ('Cartago', 7);
INSERT INTO fide_provincias_tb (Nombre, id_estado) VALUES ('Alajuela', 7);
INSERT INTO fide_provincias_tb (Nombre, id_estado) VALUES ('Limon', 7);
INSERT INTO fide_provincias_tb (Nombre, id_estado) VALUES ('Puntarenas', 7);
INSERT INTO fide_provincias_tb (Nombre, id_estado) VALUES ('Guanacaste', 7);
COMMIT;

CREATE TABLE fide_cantones_tb (
    id_canton NUMBER NOT NULL,
    id_provincia NUMBER,
    nombre VARCHAR2(50),
    id_estado NUMBER
);
ALTER TABLE fide_cantones_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_CANTONES_TB ADD CONSTRAINT FIDE_CANTONES_TB_ID_CANTON_PK PRIMARY KEY (ID_CANTON);
ALTER TABLE FIDE_CANTONES_TB ADD CONSTRAINT FIDE_CANTONES_TB_ID_PROVINCIA_FK FOREIGN KEY (ID_PROVINCIA) REFERENCES FIDE_PROVINCIAS_TB (ID_PROVINCIA);
ALTER TABLE FIDE_CANTONES_TB ADD CONSTRAINT FIDE_CANTONES_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_CANTONES_SEQ
START WITH 1
INCREMENT BY 1;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_CANTONES_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_CANTONES_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_CANTON IS NULL THEN
        :NEW.ID_CANTON := FIDE_CANTONES_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS CANTONES
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (1, 'San Jose', 7); --1
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (1, 'Escazu', 7); --2
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (1, 'Desamparados', 7); --3
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (2, 'Heredia', 7); --4
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (2, 'Barva', 7); --5
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (2, 'Santo Domingo', 7); --6
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (3, 'Cartago', 7); --7
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (3, 'Paraiso', 7); --8
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (3, 'La Union', 7); --9 
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (4, 'Orotina', 7); --10
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (4, 'San Carlos', 7); --11
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (4, 'Zarcero', 7); --12
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (5, 'Talamanca', 7); --13
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (5, 'Siquirres', 7); --14
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (5, 'Matina', 7); --15
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (6, 'Osa', 7); --16
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (6, 'Quepos', 7); --17
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (6, 'Golfito', 7); --18
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (7, 'Liberia', 7); --19
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (7, 'Nicoya', 7); --20
INSERT INTO fide_cantones_tb (ID_Provincia, Nombre, id_estado) VALUES (7, 'La Cruz', 7); --21
COMMIT;

CREATE TABLE fide_distritos_tb (
    id_distrito NUMBER NOT NULL,
    id_provincia NUMBER,
    id_canton NUMBER,
    nombre VARCHAR2(50),
    id_estado NUMBER
);
ALTER TABLE fide_distritos_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_DISTRITOS_TB ADD CONSTRAINT FIDE_DISTRITOS_TB_ID_DISTRITO_PK PRIMARY KEY (ID_DISTRITO);
ALTER TABLE FIDE_DISTRITOS_TB ADD CONSTRAINT FIDE_DISTRITOS_TB_ID_PROVINCIA_FK FOREIGN KEY (ID_PROVINCIA) REFERENCES FIDE_PROVINCIAS_TB (ID_PROVINCIA);
ALTER TABLE FIDE_DISTRITOS_TB ADD CONSTRAINT FIDE_DISTRITOS_TB_ID_CANTONES_FK FOREIGN KEY (ID_CANTON) REFERENCES FIDE_CANTONES_TB (ID_CANTON);
ALTER TABLE FIDE_DISTRITOS_TB ADD CONSTRAINT FIDE_DISTRITOS_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_DISTRITOS_SEQ
START WITH 1
INCREMENT BY 1;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_DISTRITOS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_DISTRITOS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_DISTRITO IS NULL THEN
        :NEW.ID_DISTRITO := FIDE_DISTRITOS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS DISTRITOS
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (1, 1, 'Carmen', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (1, 1, 'Merced', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (1, 1, 'Catedral', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (1, 2, 'Escazu', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (1, 2, 'San Antonio', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (1, 2, 'San Rafael', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (1, 3, 'Desamparados', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (1, 3, 'San Miguel', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (1, 3, 'San Rafael', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (2, 4, 'Heredia', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (2, 4, 'Mercedes', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (2, 4, 'Ulloa', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (2, 5, 'Barva', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (2, 5, 'San Pedro', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (2, 5, 'San Roque', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (2, 6, 'Santo Domingo', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (2, 6, 'Paracito', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (2, 6, 'Santa Rosa', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (3, 7, 'Oriental', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (3, 7, 'Occidental', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (3, 7, 'Carmen', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (3, 8, 'Paraiso', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (3, 8, 'Orosi', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (3, 8, 'Cachi', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (3, 9, 'Tres Rios', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (3, 9, 'San Diego', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (3, 9, 'Concepcion', 7);

INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (4, 10, 'Orotina', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (4, 11, 'La Fortuna', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (4, 12, 'Zarcero', 7);

INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (5, 13, 'Cahuita', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (5, 14, 'Siquirees', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (5, 15, 'Matina', 7);

INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (6, 16, 'Sierpe', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (6, 17, 'Savegre', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (6, 18, 'Golfito', 7);

INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (7, 19, 'Liberia', 7);
INSERT INTO fide_distritos_tb (ID_Provincia, ID_Canton, Nombre, id_estado) VALUES (7, 20, 'Nicoya', 7);

COMMIT;

CREATE TABLE fide_categorias_tb (
    id_categoria NUMBER NOT NULL,
    descripcion VARCHAR2(50),
    id_estado NUMBER
);
ALTER TABLE fide_categorias_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_CATEGORIAS_TB ADD CONSTRAINT FIDE_CATEGORIAS_TB_ID_CATEGORIA_PK PRIMARY KEY (ID_CATEGORIA);
ALTER TABLE FIDE_CATEGORIAS_TB ADD CONSTRAINT FIDE_CATEGORIAS_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_CATEGORIAS_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_CATEGORIAS_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_CATEGORIAS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_CATEGORIAS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_CATEGORIA IS NULL THEN
        :NEW.ID_CATEGORIA := FIDE_CATEGORIAS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS CATEGORIAS
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Electronica', 7); --1
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Alimentos', 7); --2
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Salud', 7); --3
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Electrodomesticos', 7); --4
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Ropa', 7); --5
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Jardin', 7); --6
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Deportes', 7); --7
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Juguetes' 7); --8
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Automoviles' 7); --9
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Libros', 7); --10
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Peliculas', 7); --11
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Mascotas', 7); --12
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Herramientas', 7); --13
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Oficina', 7); --14
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Camping', 7); --15
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Arte', 7); --16
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Joyeria', 7); --17
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Instrumentos musicales', 7); --18
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Belleza', 7); --19
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Equipaje', 7); --20
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Taller', 7);
INSERT INTO fide_categorias_tb (descripcion, id_estado) VALUES ('Papeleria', 7);
COMMIT;

CREATE TABLE fide_productos_tb (
    id_producto NUMBER NOT NULL,
    nombre VARCHAR2(50),
    descripcion VARCHAR2(100),
    id_categoria NUMBER,
    id_estado NUMBER
);
ALTER TABLE fide_productos_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_PRODUCTOS_TB ADD CONSTRAINT FIDE_PRODUCTOS_TB_ID_PRODUCTO_PK PRIMARY KEY (ID_PRODUCTO);
ALTER TABLE FIDE_PRODUCTOS_TB ADD CONSTRAINT FIDE_PRODUCTOS_TB_ID_CATEGORIA_FK FOREIGN KEY (ID_CATEGORIA) REFERENCES FIDE_CATEGORIAS_TB (ID_CATEGORIA);
ALTER TABLE FIDE_PRODUCTOS_TB ADD CONSTRAINT FIDE_PRODUCTOS_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_PRODUCTOS_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_PRODUCTOS_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_PRODUCTOS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_PRODUCTOS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_PRODUCTO IS NULL THEN
        :NEW.ID_PRODUCTO := FIDE_PRODUCTOS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS PRODUCTOS
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('MSI THIN 15bc', 'Laptop de alta potencia', 1, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Arroz Integral', 'Grano entero y sin procesar, alto en fibra', 2, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Paracetamol', 'Antiinflamatorio de receta general', 3, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Nevera Mave', 'Nevera inteligente', 4, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Camisa', 'Camiseta a escoger', 5, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Pala', 'Pala de uso general', 6, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Pesas', 'Pesas variadas', 7, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Set de Lego Star Wars', 'Estrella de la muerte', 8, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Neumaticos', 'Neumaticos 11cc', 9, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Frankenstein', 'Clasico literario', 10, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Rapidos y Furiosos', 'Pelicula del anio 2001', 11, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Collar', 'Collar para perro', 12, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Taladro', 'Taladro Phillips', 13, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Silla', 'Silla ergonomica', 14, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Tienda de camping', 'Tienda de camping para 4', 15, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Pintura', 'Pintura acrilica', 16, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Anillo', 'Anillo de plata', 17, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Guitarra', 'Guitarra Les Paul', 18, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Maquillaje', 'Bases', 19, 7);
INSERT INTO fide_productos_tb (nombre, descripcion, id_categoria, id_estado) VALUES ('Maleta', 'Maleta de viaje', 20, 7);
COMMIT;

CREATE TABLE fide_pedidos_tb (
    id_pedido NUMBER NOT NULL,
    id_cliente NUMBER,
    id_vehiculo NUMBER,
    id_tipo_carga NUMBER,
    fecha DATE,
    id_estado NUMBER,
    id_licencia_empleado NUMBER
);
ALTER TABLE fide_pedidos_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_PEDIDOS_TB ADD CONSTRAINT FIDE_PEDIDOS_TB_ID_PEDIDO_PK PRIMARY KEY (ID_PEDIDO);
ALTER TABLE FIDE_PEDIDOS_TB ADD CONSTRAINT FIDE_PEDIDOS_TB_ID_CLIENTE_FK FOREIGN KEY (ID_CLIENTE) REFERENCES FIDE_CLIENTES_TB (ID_CLIENTE);
ALTER TABLE FIDE_PEDIDOS_TB ADD CONSTRAINT FIDE_PEDIDOS_TB_ID_VEHICULO_FK FOREIGN KEY (ID_VEHICULO) REFERENCES FIDE_VEHICULOS_TB (ID_VEHICULO);
ALTER TABLE FIDE_PEDIDOS_TB ADD CONSTRAINT FIDE_PEDIDOS_TB_ID_TIPO_CARGA_FK FOREIGN KEY (ID_TIPO_CARGA) REFERENCES FIDE_TIPOS_CARGA_TB (ID_TIPO_CARGA);
ALTER TABLE FIDE_PEDIDOS_TB ADD CONSTRAINT FIDE_PEDIDOS_TB_ID_LICENCIA_EMPLEADO_FK FOREIGN KEY (ID_LICENCIA_EMPLEADO) REFERENCES FIDE_LICENCIAS_EMPLEADO_TB (ID_LICENCIA_EMPLEADO);
ALTER TABLE FIDE_PEDIDOS_TB ADD CONSTRAINT FIDE_PEDIDOS_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_PEDIDOS_SEQ
START WITH 1
INCREMENT BY 1;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_PEDIDOS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_PEDIDOS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_PEDIDO IS NULL THEN
        :NEW.ID_PEDIDO := FIDE_PEDIDOS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS PEDIDOS
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 2, 2, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 3, 3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 4, 4, 4, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 5, 5, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 6, 6, 6, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 7, 7, 7, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 8, 8, 1, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 9, 9, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 10, 10, 3, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 11, 11, 4, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 12, 12, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 13, 13, 6, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 14, 14, 7, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 15, 15, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 16, 16, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 17, 17, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 18, 18, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 19, 19, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 20, 20, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 2, 2, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 3, 3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 4, 4, 4, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 5, 5, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 6, 6, 6, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 7, 7, 7, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 8, 8, 1, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 9, 9, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 10, 10, 3, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 11, 11, 4, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 12, 12, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 13, 13, 6, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 14, 14, 7, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 15, 15, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 16, 16, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 17, 17, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 18, 18, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 19, 19, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 20, 20, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 2, 2, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 3, 3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 4, 4, 4, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 5, 5, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 6, 6, 6, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 7, 7, 7, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 8, 8, 1, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 9, 9, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 10, 10, 3, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 11, 11, 4, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 12, 12, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 13, 13, 6, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 14, 14, 7, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 15, 15, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 16, 16, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 17, 17, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 18, 18, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 19, 19, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 20, 20, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 2, 2, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 3, 3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 4, 4, 4, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 5, 5, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 6, 6, 6, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 7, 7, 7, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 8, 8, 1, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 9, 9, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 10, 10, 3, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 11, 11, 4, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 12, 12, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 13, 13, 6, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 14, 14, 7, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 15, 15, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 16, 16, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 17, 17, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 18, 18, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 19, 19, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 20, 20, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 2, 2, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 3, 3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 4, 4, 4, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 5, 5, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 6, 6, 6, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 7, 7, 7, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 8, 8, 1, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 9, 9, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 10, 10, 3, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 11, 11, 4, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 12, 12, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 13, 13, 6, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 14, 14, 7, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 15, 15, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 16, 16, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 17, 17, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 18, 18, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 19, 19, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 20, 20, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 2, 2, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 3, 3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 4, 4, 4, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 5, 5, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 6, 6, 6, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 7, 7, 7, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 8, 8, 1, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 9, 9, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 10, 10, 3, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 11, 11, 4, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 12, 12, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 13, 13, 6, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 14, 14, 7, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 15, 15, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 16, 16, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 17, 17, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 18, 18, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 19, 19, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 20, 20, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 2, 2, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 3, 3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 4, 4, 4, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 5, 5, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 6, 6, 6, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 7, 7, 7, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 8, 8, 1, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 9, 9, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 10, 10, 3, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 11, 11, 4, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 12, 12, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 13, 13, 6, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 14, 14, 7, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 15, 15, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 16, 16, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 17, 17, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 18, 18, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 19, 19, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 20, 20, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 2, 2, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 3, 3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 4, 4, 4, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 5, 5, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 6, 6, 6, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 7, 7, 7, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 8, 8, 1, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 9, 9, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 10, 10, 3, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 11, 11, 4, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 12, 12, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 13, 13, 6, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 14, 14, 7, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 15, 15, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 16, 16, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 17, 17, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 18, 18, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 19, 19, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 20, 20, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 2, 2, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 3, 3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 4, 4, 4, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 5, 5, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 6, 6, 6, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 7, 7, 7, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 8, 8, 1, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 9, 9, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 10, 10, 3, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 11, 11, 4, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 12, 12, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 13, 13, 6, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 14, 14, 7, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 15, 15, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 16, 16, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 17, 17, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 18, 18, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 19, 19, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 20, 20, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 2, 2, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 3, 3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 4, 4, 4, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 5, 5, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 6, 6, 6, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 7, 7, 7, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 8, 8, 1, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 9, 9, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 10, 10, 3, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 11, 11, 4, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 12, 12, 5, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 13, 13, 6, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 14, 14, 7, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 15, 15, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 16, 16, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 17, 17, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 18, 18, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 3);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 19, 19, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO fide_pedidos_tb (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ( 20, 20, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
COMMIT;

CREATE TABLE fide_detalles_pedido_tb (
    id_detalle NUMBER NOT NULL,
    id_pedido NUMBER,
    id_producto NUMBER,
    cantidad NUMBER,
    unidad_masa VARCHAR2(10),
    id_estado NUMBER
);
ALTER TABLE fide_detalles_pedido_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_DETALLES_PEDIDO_TB ADD CONSTRAINT FIDE_DETALLES_PEDIDO_TB_ID_DETALLE_PK PRIMARY KEY (ID_DETALLE);
ALTER TABLE FIDE_DETALLES_PEDIDO_TB ADD CONSTRAINT FIDE_DETALLES_PEDIDO_TB_ID_PEDIDO_FK FOREIGN KEY (ID_PEDIDO) REFERENCES FIDE_PEDIDOS_TB (ID_PEDIDO);
ALTER TABLE FIDE_DETALLES_PEDIDO_TB ADD CONSTRAINT FIDE_DETALLES_PEDIDO_TB_ID_PRODUCTO_FK FOREIGN KEY (ID_PRODUCTO) REFERENCES FIDE_PRODUCTOS_TB (ID_PRODUCTO);
ALTER TABLE FIDE_DETALLES_PEDIDO_TB ADD CONSTRAINT FIDE_DETALLES_PEDIDO_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_DETALLES_PEDIDO_SEQ
START WITH 1
INCREMENT BY 1;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_DETALLES_PEDIDO_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_DETALLES_PEDIDO_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_DETALLE IS NULL THEN
        :NEW.ID_DETALLE := FIDE_DETALLES_PEDIDO_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS DETALLES PEDIDO
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (1, 1, 100, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (1, 2, 50, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (2, 3, 200, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (2, 4, 25, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (3, 5, 150, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (3, 6, 30, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (4, 7, 100, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (4, 8, 50, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (4, 9, 50, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (5, 10, 200, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (5, 11, 25, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (6, 12, 150, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (6, 13, 30, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (7, 14, 100, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (7, 15, 50, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (8, 16, 200, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (8, 17, 25, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (9, 18, 150, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (9, 19, 30, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (10, 20, 200, 'unidades', 7);
INSERT INTO fide_detalles_pedido_tb (id_pedido, id_producto, cantidad, unidad_masa, id_estado) VALUES (10, 21, 200, 'unidades', 7);
COMMIT;

CREATE TABLE fide_facturas_tb (
    id_factura NUMBER NOT NULL,
    id_pedido NUMBER,
    fecha DATE,
    total NUMBER,
    id_estado NUMBER
)
PARTITION BY RANGE (fecha) (
    PARTITION p_2020 VALUES LESS THAN (TO_DATE('2021-01-01', 'YYYY-MM-DD')),
    PARTITION p_2021 VALUES LESS THAN (TO_DATE('2022-01-01', 'YYYY-MM-DD')),
    PARTITION p_2022 VALUES LESS THAN (TO_DATE('2023-01-01', 'YYYY-MM-DD')),
    PARTITION p_2023 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')),
    PARTITION p_2024 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD')),
    PARTITION p_2025 VALUES LESS THAN (TO_DATE('2026-01-01', 'YYYY-MM-DD')),
    PARTITION p_2026 VALUES LESS THAN (TO_DATE('2027-01-01', 'YYYY-MM-DD')),
    PARTITION p_2027 VALUES LESS THAN (TO_DATE('2028-01-01', 'YYYY-MM-DD')),
    PARTITION p_2028 VALUES LESS THAN (TO_DATE('2029-01-01', 'YYYY-MM-DD')),
    PARTITION p_2029 VALUES LESS THAN (TO_DATE('2030-01-01', 'YYYY-MM-DD')),
    PARTITION p_2030 VALUES LESS THAN (TO_DATE('2031-01-01', 'YYYY-MM-DD'))
);

ALTER TABLE fide_facturas_tb MOVE PARTITION p_2020 TABLESPACE FIDE_PROYECTO_FINAL_TBS;
ALTER TABLE fide_facturas_tb MOVE PARTITION p_2021 TABLESPACE FIDE_PROYECTO_FINAL_TBS;
ALTER TABLE fide_facturas_tb MOVE PARTITION p_2022 TABLESPACE FIDE_PROYECTO_FINAL_TBS;
ALTER TABLE fide_facturas_tb MOVE PARTITION p_2023 TABLESPACE FIDE_PROYECTO_FINAL_TBS;
ALTER TABLE fide_facturas_tb MOVE PARTITION p_2024 TABLESPACE FIDE_PROYECTO_FINAL_TBS;
ALTER TABLE fide_facturas_tb MOVE PARTITION p_2025 TABLESPACE FIDE_PROYECTO_FINAL_TBS;
ALTER TABLE fide_facturas_tb MOVE PARTITION p_2026 TABLESPACE FIDE_PROYECTO_FINAL_TBS;
ALTER TABLE fide_facturas_tb MOVE PARTITION p_2027 TABLESPACE FIDE_PROYECTO_FINAL_TBS;
ALTER TABLE fide_facturas_tb MOVE PARTITION p_2028 TABLESPACE FIDE_PROYECTO_FINAL_TBS;
ALTER TABLE fide_facturas_tb MOVE PARTITION p_2029 TABLESPACE FIDE_PROYECTO_FINAL_TBS;
ALTER TABLE fide_facturas_tb MOVE PARTITION p_2030 TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_FACTURAS_TB ADD CONSTRAINT FIDE_FACTURAS_TB_ID_FACTURA_PK PRIMARY KEY (ID_FACTURA);
ALTER TABLE FIDE_FACTURAS_TB ADD CONSTRAINT FIDE_FACTURAS_TB_ID_PEDIDO_FK FOREIGN KEY (ID_PEDIDO) REFERENCES FIDE_PEDIDOS_TB (ID_PEDIDO);
ALTER TABLE FIDE_FACTURAS_TB ADD CONSTRAINT FIDE_FACTURAS_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_FACTURAS_SEQ
START WITH 1
INCREMENT BY 1;

--Resetear secuencia
--DROP SEQUENCE FIDE_FACTURAS_SEQ;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_FACTURAS_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_FACTURAS_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_FACTURA IS NULL THEN
        :NEW.ID_FACTURA := FIDE_FACTURAS_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS FACTURAS
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (1, TO_DATE('2022-08-10', 'YYYY-MM-DD'), 100000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (2, TO_DATE('2022-07-09', 'YYYY-MM-DD'), 200000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (3, TO_DATE('2024-10-10', 'YYYY-MM-DD'), 300000, 4);

INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (4, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 400000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (5, TO_DATE('2023-03-20', 'YYYY-MM-DD'), 500000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (6, TO_DATE('2023-05-25', 'YYYY-MM-DD'), 600000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (7, TO_DATE('2023-07-30', 'YYYY-MM-DD'), 700000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (8, TO_DATE('2023-09-05', 'YYYY-MM-DD'), 800000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (9, TO_DATE('2023-11-10', 'YYYY-MM-DD'), 900000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (10, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 1000000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (11, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 1100000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (12, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 1200000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (13, TO_DATE('2024-07-30', 'YYYY-MM-DD'), 1300000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (14, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 1400000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (15, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 1500000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (16, TO_DATE('2025-01-15', 'YYYY-MM-DD'), 1600000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (17, TO_DATE('2025-03-20', 'YYYY-MM-DD'), 1700000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (18, TO_DATE('2025-05-25', 'YYYY-MM-DD'), 1800000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (19, TO_DATE('2025-07-30', 'YYYY-MM-DD'), 1900000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (20, TO_DATE('2025-09-05', 'YYYY-MM-DD'), 2000000, 5);
--20 inserts
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (21, TO_DATE('2025-11-10', 'YYYY-MM-DD'), 2100000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (22, TO_DATE('2026-01-15', 'YYYY-MM-DD'), 2200000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (23, TO_DATE('2026-03-20', 'YYYY-MM-DD'), 2300000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (24, TO_DATE('2026-05-25', 'YYYY-MM-DD'), 2400000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (25, TO_DATE('2026-07-30', 'YYYY-MM-DD'), 2500000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (26, TO_DATE('2026-09-05', 'YYYY-MM-DD'), 2600000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (27, TO_DATE('2026-11-10', 'YYYY-MM-DD'), 2700000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (28, TO_DATE('2027-01-15', 'YYYY-MM-DD'), 2800000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (29, TO_DATE('2027-03-20', 'YYYY-MM-DD'), 2900000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (30, TO_DATE('2027-05-25', 'YYYY-MM-DD'), 3000000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (31, TO_DATE('2027-07-30', 'YYYY-MM-DD'), 3100000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (32, TO_DATE('2027-09-05', 'YYYY-MM-DD'), 3200000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (33, TO_DATE('2027-11-10', 'YYYY-MM-DD'), 3300000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (34, TO_DATE('2028-01-15', 'YYYY-MM-DD'), 3400000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (35, TO_DATE('2028-03-20', 'YYYY-MM-DD'), 3500000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (36, TO_DATE('2028-05-25', 'YYYY-MM-DD'), 3600000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (37, TO_DATE('2028-07-30', 'YYYY-MM-DD'), 3700000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (38, TO_DATE('2028-09-05', 'YYYY-MM-DD'), 3800000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (39, TO_DATE('2028-11-10', 'YYYY-MM-DD'), 3900000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (40, TO_DATE('2029-01-15', 'YYYY-MM-DD'), 4000000, 3);
--40 inserts
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (41, TO_DATE('2029-03-20', 'YYYY-MM-DD'), 4100000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (42, TO_DATE('2029-05-25', 'YYYY-MM-DD'), 4200000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (43, TO_DATE('2029-07-30', 'YYYY-MM-DD'), 4300000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (44, TO_DATE('2029-09-05', 'YYYY-MM-DD'), 4400000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (45, TO_DATE('2029-11-10', 'YYYY-MM-DD'), 4500000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (46, TO_DATE('2030-01-15', 'YYYY-MM-DD'), 4600000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (47, TO_DATE('2030-03-20', 'YYYY-MM-DD'), 4700000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (48, TO_DATE('2030-05-25', 'YYYY-MM-DD'), 4800000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (49, TO_DATE('2030-07-30', 'YYYY-MM-DD'), 4900000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (50, TO_DATE('2030-09-05', 'YYYY-MM-DD'), 5000000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (51, TO_DATE('2030-11-10', 'YYYY-MM-DD'), 5100000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (52, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 5200000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (53, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 5300000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (54, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 5400000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (55, TO_DATE('2024-07-30', 'YYYY-MM-DD'), 5500000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (56, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 5600000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (57, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 5700000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (58, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 5800000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (59, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 5900000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (60, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 6000000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (61, TO_DATE('2024-07-30', 'YYYY-MM-DD'), 6100000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (62, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 6200000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (63, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 6300000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (64, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 6400000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (65, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 6500000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (66, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 6600000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (67, TO_DATE('2024-07-30', 'YYYY-MM-DD'), 6700000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (68, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 6800000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (69, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 6900000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (70, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 7000000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (71, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 7100000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (72, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 7200000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (73, TO_DATE('2024-07-30', 'YYYY-MM-DD'), 7300000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (74, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 7400000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (75, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 7500000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (76, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 7600000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (77, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 7700000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (78, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 7800000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (79, TO_DATE('2024-07-30', 'YYYY-MM-DD'), 7900000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (80, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 8000000, 5);
--80 insers
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (81, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 8100000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (82, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 8200000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (83, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 8300000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (84, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 8400000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (85, TO_DATE('2024-07-30', 'YYYY-MM-DD'), 8500000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (86, TO_DATE('2024-07-30', 'YYYY-MM-DD'), 8600000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (87, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 8700000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (88, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 8800000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (89, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 8900000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (90, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 9000000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (91, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 9100000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (92, TO_DATE('2024-07-30', 'YYYY-MM-DD'), 9200000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (93, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 9300000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (94, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 9400000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (95, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 9500000, 3);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (96, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 9600000, 2);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (97, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 9700000, 1);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (98, TO_DATE('2024-07-30', 'YYYY-MM-DD'), 9800000, 6);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (99, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 9900000, 5);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (100, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 10000000, 4);

INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (101, TO_DATE('2024-11-11', 'YYYY-MM-DD'), 12500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (102, TO_DATE('2024-11-12', 'YYYY-MM-DD'), 48990, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (103, TO_DATE('2024-11-13', 'YYYY-MM-DD'), 35000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (104, TO_DATE('2024-11-14', 'YYYY-MM-DD'), 22500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (105, TO_DATE('2024-11-15', 'YYYY-MM-DD'), 19999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (106, TO_DATE('2024-11-16', 'YYYY-MM-DD'), 55000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (107, TO_DATE('2024-11-17', 'YYYY-MM-DD'), 7500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (108, TO_DATE('2024-11-18', 'YYYY-MM-DD'), 80000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (109, TO_DATE('2024-11-19', 'YYYY-MM-DD'), 22000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (110, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 44050, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (111, TO_DATE('2024-11-21', 'YYYY-MM-DD'), 59999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (112, TO_DATE('2024-11-22', 'YYYY-MM-DD'), 47000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (113, TO_DATE('2024-11-23', 'YYYY-MM-DD'), 36000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (114, TO_DATE('2024-11-24', 'YYYY-MM-DD'), 48900, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (115, TO_DATE('2024-11-25', 'YYYY-MM-DD'), 75000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (116, TO_DATE('2024-11-26', 'YYYY-MM-DD'), 34999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (117, TO_DATE('2024-11-27', 'YYYY-MM-DD'), 52000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (118, TO_DATE('2024-11-28', 'YYYY-MM-DD'), 19950, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (119, TO_DATE('2024-11-29', 'YYYY-MM-DD'), 30000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (120, TO_DATE('2024-11-30', 'YYYY-MM-DD'), 15999, 4);

INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (121, TO_DATE('2024-11-11', 'YYYY-MM-DD'), 12500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (123, TO_DATE('2024-11-12', 'YYYY-MM-DD'), 48990, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (123, TO_DATE('2024-11-13', 'YYYY-MM-DD'), 35000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (124, TO_DATE('2024-11-14', 'YYYY-MM-DD'), 22500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (125, TO_DATE('2024-11-15', 'YYYY-MM-DD'), 19999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (126, TO_DATE('2024-11-16', 'YYYY-MM-DD'), 55000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (127, TO_DATE('2024-11-17', 'YYYY-MM-DD'), 7500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (128, TO_DATE('2024-11-18', 'YYYY-MM-DD'), 80000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (129, TO_DATE('2024-11-19', 'YYYY-MM-DD'), 22000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (130, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 44050, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (131, TO_DATE('2024-11-21', 'YYYY-MM-DD'), 59999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (132, TO_DATE('2024-11-22', 'YYYY-MM-DD'), 47000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (133, TO_DATE('2024-11-23', 'YYYY-MM-DD'), 36000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (134, TO_DATE('2024-11-24', 'YYYY-MM-DD'), 48900, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (135, TO_DATE('2024-11-25', 'YYYY-MM-DD'), 75000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (136, TO_DATE('2024-11-26', 'YYYY-MM-DD'), 34999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (137, TO_DATE('2024-11-27', 'YYYY-MM-DD'), 52000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (138, TO_DATE('2024-11-28', 'YYYY-MM-DD'), 19950, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (139, TO_DATE('2024-11-29', 'YYYY-MM-DD'), 30000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (140, TO_DATE('2024-11-30', 'YYYY-MM-DD'), 15999, 4);

INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (141, TO_DATE('2024-11-11', 'YYYY-MM-DD'), 12500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (142, TO_DATE('2024-11-12', 'YYYY-MM-DD'), 48990, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (143, TO_DATE('2024-11-13', 'YYYY-MM-DD'), 35000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (144, TO_DATE('2024-11-14', 'YYYY-MM-DD'), 22500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (145, TO_DATE('2024-11-15', 'YYYY-MM-DD'), 19999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (146, TO_DATE('2024-11-16', 'YYYY-MM-DD'), 55000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (147, TO_DATE('2024-11-17', 'YYYY-MM-DD'), 75000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (148, TO_DATE('2024-11-18', 'YYYY-MM-DD'), 80000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (149, TO_DATE('2024-11-19', 'YYYY-MM-DD'), 22000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (140, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 44050, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (151, TO_DATE('2024-11-21', 'YYYY-MM-DD'), 59999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (152, TO_DATE('2024-11-22', 'YYYY-MM-DD'), 47000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (153, TO_DATE('2024-11-23', 'YYYY-MM-DD'), 36000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (154, TO_DATE('2024-11-24', 'YYYY-MM-DD'), 48900, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (155, TO_DATE('2024-11-25', 'YYYY-MM-DD'), 75000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (156, TO_DATE('2024-11-26', 'YYYY-MM-DD'), 34999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (157, TO_DATE('2024-11-27', 'YYYY-MM-DD'), 52000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (158, TO_DATE('2024-11-28', 'YYYY-MM-DD'), 19950, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (159, TO_DATE('2024-11-29', 'YYYY-MM-DD'), 30000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (160, TO_DATE('2024-11-30', 'YYYY-MM-DD'), 15999, 4);

INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (161, TO_DATE('2024-11-11', 'YYYY-MM-DD'), 12500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (162, TO_DATE('2024-11-12', 'YYYY-MM-DD'), 48990, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (163, TO_DATE('2024-11-13', 'YYYY-MM-DD'), 35000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (164, TO_DATE('2024-11-14', 'YYYY-MM-DD'), 22500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (165, TO_DATE('2024-11-15', 'YYYY-MM-DD'), 19999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (166, TO_DATE('2024-11-16', 'YYYY-MM-DD'), 55000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (167, TO_DATE('2024-11-17', 'YYYY-MM-DD'), 75000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (168, TO_DATE('2024-11-18', 'YYYY-MM-DD'), 80000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (169, TO_DATE('2024-11-19', 'YYYY-MM-DD'), 22000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (170, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 44050, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (171, TO_DATE('2024-11-21', 'YYYY-MM-DD'), 59999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (172, TO_DATE('2024-11-22', 'YYYY-MM-DD'), 47000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (173, TO_DATE('2024-11-23', 'YYYY-MM-DD'), 36000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (174, TO_DATE('2024-11-24', 'YYYY-MM-DD'), 48900, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (175, TO_DATE('2024-11-25', 'YYYY-MM-DD'), 75000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (176, TO_DATE('2024-11-26', 'YYYY-MM-DD'), 34999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (177, TO_DATE('2024-11-27', 'YYYY-MM-DD'), 52000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (178, TO_DATE('2024-11-28', 'YYYY-MM-DD'), 19950, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (179, TO_DATE('2024-11-29', 'YYYY-MM-DD'), 30000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (180, TO_DATE('2024-11-30', 'YYYY-MM-DD'), 15999, 4);

INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (181, TO_DATE('2024-11-11', 'YYYY-MM-DD'), 12500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (182, TO_DATE('2024-11-12', 'YYYY-MM-DD'), 48990, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (183, TO_DATE('2024-11-13', 'YYYY-MM-DD'), 35000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (184, TO_DATE('2024-11-14', 'YYYY-MM-DD'), 22500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (185, TO_DATE('2024-11-15', 'YYYY-MM-DD'), 19999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (186, TO_DATE('2024-11-16', 'YYYY-MM-DD'), 55000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (187, TO_DATE('2024-11-17', 'YYYY-MM-DD'), 75000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (188, TO_DATE('2024-11-18', 'YYYY-MM-DD'), 80000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (189, TO_DATE('2024-11-19', 'YYYY-MM-DD'), 22000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (190, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 44050, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (191, TO_DATE('2024-11-21', 'YYYY-MM-DD'), 59999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (192, TO_DATE('2024-11-22', 'YYYY-MM-DD'), 47000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (193, TO_DATE('2024-11-23', 'YYYY-MM-DD'), 36000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (194, TO_DATE('2024-11-24', 'YYYY-MM-DD'), 48900, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (195, TO_DATE('2024-11-25', 'YYYY-MM-DD'), 75000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (196, TO_DATE('2024-11-26', 'YYYY-MM-DD'), 34999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (197, TO_DATE('2024-11-27', 'YYYY-MM-DD'), 52000, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (198, TO_DATE('2024-12-06', 'YYYY-MM-DD'), 30500, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (199, TO_DATE('2024-12-07', 'YYYY-MM-DD'), 12999, 4);
INSERT INTO fide_facturas_tb (id_pedido, Fecha, Total, ID_Estado) VALUES (200, TO_DATE('2024-12-08', 'YYYY-MM-DD'), 59000, 4);

COMMIT;

CREATE TABLE fide_direcciones_empleado_tb (
    id_direccion NUMBER NOT NULL,
    id_empleado NUMBER,
    id_provincia NUMBER,
    id_canton NUMBER,
    id_distrito NUMBER,
    detalles VARCHAR2(100),
    id_estado NUMBER
);
ALTER TABLE fide_direcciones_empleado_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_DIRECCIONES_EMPLEADO_TB ADD CONSTRAINT FIDE_DIRECCIONES_EMPLEADO_TB_ID_DIRECCION_PK PRIMARY KEY (ID_DIRECCION);
ALTER TABLE FIDE_DIRECCIONES_EMPLEADO_TB ADD CONSTRAINT FIDE_DIRECCIONES_EMPLEADO_TB_ID_EMPLEADO_FK FOREIGN KEY (ID_EMPLEADO) REFERENCES FIDE_EMPLEADOS_TB (ID_EMPLEADO);
ALTER TABLE FIDE_DIRECCIONES_EMPLEADO_TB ADD CONSTRAINT FIDE_DIRECCIONES_EMPLEADO_TB_ID_PROVINCIA_FK FOREIGN KEY (ID_PROVINCIA) REFERENCES FIDE_PROVINCIAS_TB (ID_PROVINCIA);
ALTER TABLE FIDE_DIRECCIONES_EMPLEADO_TB ADD CONSTRAINT FIDE_DIRECCIONES_EMPLEADO_TB_ID_CANTON_FK FOREIGN KEY (ID_CANTON) REFERENCES FIDE_CANTONES_TB (ID_CANTON);
ALTER TABLE FIDE_DIRECCIONES_EMPLEADO_TB ADD CONSTRAINT FIDE_DIRECCIONES_EMPLEADO_TB_ID_DISTRITOS_FK FOREIGN KEY (ID_DISTRITO) REFERENCES FIDE_DISTRITOS_TB (ID_DISTRITO);
ALTER TABLE FIDE_DIRECCIONES_EMPLEADO_TB ADD CONSTRAINT FIDE_DIRECCIONES_EMPLEADO_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_DIRECCIONES_EMPLEADO_SEQ
START WITH 1
INCREMENT BY 1;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_DIRECCIONES_EMPLEADO_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_DIRECCIONES_EMPLEADO_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_DIRECCION IS NULL THEN
        :NEW.ID_DIRECCION := FIDE_DIRECCIONES_EMPLEADO_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (1, 1, 1, 1, 'Calle 1, Casa 2', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (2, 2, 4, 10, 'Calle 2, Casa 3', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (3, 3, 7, 19, 'Calle 3, Casa 4', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (1, 1, 1, 1, 'Calle 1, Casa 2', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (2, 2, 4, 10, 'Calle 2, Casa 3', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (3, 3, 7, 19, 'Calle 3, Casa 4', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (1, 1, 1, 1, 'Calle 1, Casa 2', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (2, 2, 4, 10, 'Calle 2, Casa 3', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (3, 3, 7, 19, 'Calle 3, Casa 4', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (1, 1, 1, 1, 'Calle 1, Casa 2', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (2, 2, 4, 10, 'Calle 2, Casa 3', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (3, 3, 7, 19, 'Calle 3, Casa 4', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (1, 1, 1, 1, 'Calle 1, Casa 2', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (2, 2, 4, 10, 'Calle 2, Casa 3', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (3, 3, 7, 19, 'Calle 3, Casa 4', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (1, 1, 1, 1, 'Calle 1, Casa 2', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (2, 2, 4, 10, 'Calle 2, Casa 3', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (3, 3, 7, 19, 'Calle 3, Casa 4', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (2, 2, 4, 10, 'Calle 2, Casa 3', 7);
INSERT INTO fide_direcciones_empleado_tb (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (3, 3, 7, 19, 'Calle 3, Casa 4', 7);
COMMIT;

CREATE TABLE fide_direcciones_pedido_tb (
    id_direccion NUMBER NOT NULL,
    id_pedido NUMBER,
    id_provincia NUMBER,
    id_canton NUMBER,
    id_distrito NUMBER,
    detalles VARCHAR2(100),
    id_estado NUMBER
);
ALTER TABLE fide_direcciones_pedido_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_DIRECCIONES_PEDIDO_TB ADD CONSTRAINT FIDE_DIRECCIONES_PEDIDO_TB_ID_DIRECCION_PK PRIMARY KEY (ID_DIRECCION);
ALTER TABLE FIDE_DIRECCIONES_PEDIDO_TB ADD CONSTRAINT FIDE_DIRECCIONES_PEDIDO_TB_ID_PEDIDO_FK FOREIGN KEY (ID_PEDIDO) REFERENCES FIDE_PEDIDOS_TB (ID_PEDIDO);
ALTER TABLE FIDE_DIRECCIONES_PEDIDO_TB ADD CONSTRAINT FIDE_DIRECCIONES_PEDIDO_TB_ID_PROVINCIA_FK FOREIGN KEY (ID_PROVINCIA) REFERENCES FIDE_PROVINCIAS_TB (ID_PROVINCIA);
ALTER TABLE FIDE_DIRECCIONES_PEDIDO_TB ADD CONSTRAINT FIDE_DIRECCIONES_PEDIDO_TB_ID_CANTON_FK FOREIGN KEY (ID_CANTON) REFERENCES FIDE_CANTONES_TB (ID_CANTON);
ALTER TABLE FIDE_DIRECCIONES_PEDIDO_TB ADD CONSTRAINT FIDE_DIRECCIONES_PEDIDO_TB_ID_DISTRITOS_FK FOREIGN KEY (ID_DISTRITO) REFERENCES FIDE_DISTRITOS_TB (ID_DISTRITO);
ALTER TABLE FIDE_DIRECCIONES_PEDIDO_TB ADD CONSTRAINT FIDE_DIRECCIONES_PEDIDO_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_DIRECCIONES_PEDIDO_SEQ
START WITH 1
INCREMENT BY 1;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_DIRECCIONES_PEDIDO_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_DIRECCIONES_PEDIDO_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_DIRECCION IS NULL THEN
        :NEW.ID_DIRECCION := FIDE_DIRECCIONES_PEDIDO_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (1, 1, 1, 1, 'Direccion pedido 1', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (2, 2, 4, 10, 'Direccion pedido 2', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (3, 3, 7, 19, 'Direccion pedido 3', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (4, 1, 1, 1, 'Direccion pedido 4', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (5, 2, 4, 10, 'Direccion pedido 5', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (6, 3, 7, 19, 'Direccion pedido 6', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (7, 1, 1, 1, 'Direccion pedido 7', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (8, 2, 4, 10, 'Direccion pedido 8', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (9, 3, 7, 19, 'Direccion pedido 9', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (10, 1, 1, 1, 'Direccion pedido 10', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (11, 2, 4, 10, 'Direccion pedido 11', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (12, 3, 7, 19, 'Direccion pedido 12', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (13, 1, 1, 1, 'Direccion pedido 13', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (14, 2, 4, 10, 'Direccion pedido 14', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (15, 3, 7, 19, 'Direccion pedido 15', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (16, 1, 1, 1, 'Direccion pedido 16', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (17, 2, 4, 10, 'Direccion pedido 17', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (18, 3, 7, 19, 'Direccion pedido 18', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (19, 3, 7, 19, 'Direccion pedido 19', 7);
INSERT INTO fide_direcciones_pedido_tb (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, id_estado) VALUES (20, 3, 7, 19, 'Direccion pedido 20', 7);
COMMIT;

CREATE TABLE fide_direcciones_cliente_tb (
    id_direccion NUMBER NOT NULL,
    id_cliente NUMBER,
    id_provincia NUMBER,
    id_canton NUMBER,
    id_distrito NUMBER,
    detalles VARCHAR2(100),
    id_estado NUMBER
);
ALTER TABLE fide_direcciones_cliente_tb MOVE TABLESPACE FIDE_PROYECTO_FINAL_TBS;

--LLAVES
ALTER TABLE FIDE_DIRECCIONES_CLIENTE_TB ADD CONSTRAINT FIDE_DIRECCIONES_CLIENTE_TB_ID_DIRECCION_PK PRIMARY KEY (ID_DIRECCION);
ALTER TABLE FIDE_DIRECCIONES_CLIENTE_TB ADD CONSTRAINT FIDE_DIRECCIONES_CLIENTE_TB_ID_CLIENTE_FK FOREIGN KEY (ID_CLIENTE) REFERENCES FIDE_CLIENTES_TB (ID_CLIENTE);
ALTER TABLE FIDE_DIRECCIONES_CLIENTE_TB ADD CONSTRAINT FIDE_DIRECCIONES_CLIENTE_TB_ID_PROVINCIA_FK FOREIGN KEY (ID_PROVINCIA) REFERENCES FIDE_PROVINCIAS_TB (ID_PROVINCIA);
ALTER TABLE FIDE_DIRECCIONES_CLIENTE_TB ADD CONSTRAINT FIDE_DIRECCIONES_CLIENTE_TB_ID_CANTON_FK FOREIGN KEY (ID_CANTON) REFERENCES FIDE_CANTONES_TB (ID_CANTON);
ALTER TABLE FIDE_DIRECCIONES_CLIENTE_TB ADD CONSTRAINT FIDE_DIRECCIONES_CLIENTE_TB_ID_DISTRITOS_FK FOREIGN KEY (ID_DISTRITO) REFERENCES FIDE_DISTRITOS_TB (ID_DISTRITO);
ALTER TABLE FIDE_DIRECCIONES_CLIENTE_TB ADD CONSTRAINT FIDE_DIRECCIONES_CLIENTE_TB_ID_ESTADO_FK FOREIGN KEY (ID_ESTADO) REFERENCES FIDE_ESTADOS_TB (ID_ESTADO);

--SEQUENCIA AUTOINCREMENTAL
CREATE SEQUENCE FIDE_DIRECCIONES_CLIENTE_SEQ
START WITH 1
INCREMENT BY 1;

--TRIGGER PARA ID AUTOINCREMENTAL
CREATE OR REPLACE TRIGGER FIDE_DIRECCIONES_CLIENTE_TB_ID_AUTOINCREMENTAL_TRG
BEFORE INSERT ON FIDE_DIRECCIONES_CLIENTE_TB
FOR EACH ROW
BEGIN
    IF :NEW.ID_DIRECCION IS NULL THEN
        :NEW.ID_DIRECCION := FIDE_DIRECCIONES_CLIENTE_SEQ.NEXTVAL;
    END IF;
END;

--INSERTS
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (1, 1, 1, 3, '100 metros al este de la iglesia principal, casa color amarillo con port�n negro', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (2, 2, 4, 2, '200 metros norte y 50 metros oeste del supermercado La Canasta, casa de dos pisos color blanco', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (3, 3, 5, 1, 'Frente a la entrada principal del Parque Central, edificio azul con balcones', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (2, 1, 3, 4, 'Contiguo a la soda El Buen Gusto, apartamento en el segundo piso', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (1, 3, 2, 5, 'De la escuela central, 300 metros al oeste', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (1, 1, 1, 3, '100 metros al este de la iglesia principal, casa color amarillo con port�n negro', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (2, 2, 4, 2, '200 metros norte y 50 metros oeste del supermercado La Canasta, casa de dos pisos color blanco', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (3, 3, 5, 1, 'Frente a la entrada principal del Parque Central, edificio azul con balcones', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (2, 1, 3, 4, 'Contiguo a la soda El Buen Gusto, apartamento en el segundo piso', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (1, 3, 2, 5, 'De la escuela central, 300 metros al oeste', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (1, 1, 1, 3, '100 metros al este de la iglesia principal, casa color amarillo con port�n negro', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (2, 2, 4, 2, '200 metros norte y 50 metros oeste del supermercado La Canasta, casa de dos pisos color blanco', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (3, 3, 5, 1, 'Frente a la entrada principal del Parque Central, edificio azul con balcones', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (2, 1, 3, 4, 'Contiguo a la soda El Buen Gusto, apartamento en el segundo piso', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (1, 3, 2, 5, 'De la escuela central, 300 metros al oeste', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (1, 1, 1, 3, '100 metros al este de la iglesia principal, casa color amarillo con port�n negro', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (2, 2, 4, 2, '200 metros norte y 50 metros oeste del supermercado La Canasta, casa de dos pisos color blanco', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (3, 3, 5, 1, 'Frente a la entrada principal del Parque Central, edificio azul con balcones', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (2, 1, 3, 4, 'Contiguo a la soda El Buen Gusto, apartamento en el segundo piso', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (1, 3, 2, 5, 'De la escuela central, 300 metros al oeste', 7);
INSERT INTO fide_direcciones_cliente_tb (id_cliente, id_provincia, id_canton, id_distrito, detalles, id_estado) VALUES (1, 1, 1, 3, '100 metros al este de la iglesia principal, casa color amarillo con port�n negro', 7);
COMMIT;

-- COMPROBAR QUE LAS TABLAS HAYAN SIDO AGREGADAS AL TABLESPACE CREADO
SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES
WHERE TABLESPACE_NAME = 'FIDE_PROYECTO_FINAL_TBS';

-- FUNCIONES

-- Function para buscar clientes por su nombre
/
CREATE OR REPLACE FUNCTION FIDE_CLIENTES_TB_BUSCAR_CLIENTE_NOMBRE_FN(P_NOMBRE IN VARCHAR2)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Cliente, Nombre, Apellido, Telefono, Email, Id_estado
    FROM FIDE_CLIENTES_TB
    WHERE LOWER(Nombre) LIKE '%' || LOWER(P_NOMBRE) || '%';
    RETURN V_CURSOR;
END FIDE_CLIENTES_TB_BUSCAR_CLIENTE_NOMBRE_FN;
/

-- Function para buscar clientes por su correo
/
CREATE OR REPLACE FUNCTION FIDE_CLIENTES_TB_BUSCAR_CLIENTE_CORREO_FN(P_EMAIL IN VARCHAR2)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Cliente, Nombre, Apellido, Telefono, Email, Id_estado
    FROM FIDE_CLIENTES_TB
    WHERE LOWER(Email) LIKE '%' || LOWER(P_EMAIL) || '%';
    RETURN V_CURSOR;
END FIDE_CLIENTES_TB_BUSCAR_CLIENTE_CORREO_FN;
/

-- Function para buscar direccion por cliente ID
/
CREATE OR REPLACE FUNCTION FIDE_DIRECCIONES_CLIENTE_TB_BUSCAR_POR_ID_FN(P_ID_CLIENTE IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Direccion, ID_Cliente, Detalles, ID_Distrito, Id_estado
    FROM FIDE_DIRECCIONES_CLIENTE_TB
    WHERE ID_Cliente = P_ID_CLIENTE;
    RETURN V_CURSOR;
END FIDE_DIRECCIONES_CLIENTE_TB_BUSCAR_POR_ID_FN;
/

-- Function para buscar direccion por empleado ID
/
CREATE OR REPLACE FUNCTION FIDE_DIRECCIONES_EMPLEADO_TB_BUSCAR_POR_ID_FN(P_ID_EMPLEADO IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Direccion, ID_Empleado, Detalles, ID_Distrito, Id_estado
    FROM FIDE_DIRECCIONES_EMPLEADO_TB
    WHERE ID_Empleado = P_ID_EMPLEADO;
    RETURN V_CURSOR;
END FIDE_DIRECCIONES_EMPLEADO_TB_BUSCAR_POR_ID_FN;
/

-- Function para buscar orden por cliente ID
/
CREATE OR REPLACE FUNCTION FIDE_PEDIDOS_TB_BUSCAR_POR_CLIENTE_FN(P_ID_CLIENTE IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Pedido, ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado
    FROM FIDE_PEDIDOS_TB
    WHERE ID_Cliente = P_ID_CLIENTE;
    RETURN V_CURSOR;
END FIDE_PEDIDOS_TB_BUSCAR_POR_CLIENTE_FN;
/

-- Function para buscar direccion por pedido ID
/
CREATE OR REPLACE FUNCTION FIDE_DIRECCIONES_PEDIDO_TB_BUSCAR_POR_PEDIDO_FN(P_ID_PEDIDO IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Direccion, ID_Pedido, Detalles, ID_Distrito, Id_estado
    FROM FIDE_DIRECCIONES_PEDIDO_TB
    WHERE ID_Pedido = P_ID_PEDIDO;
    RETURN V_CURSOR;
END FIDE_DIRECCIONES_PEDIDO_TB_BUSCAR_POR_PEDIDO_FN;
/

-- Function para buscar la licencia del empleado por su empleado ID
/
CREATE OR REPLACE FUNCTION FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_EMPLEADO_FN(P_ID_EMPLEADO IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Licencia_Empleado, ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento, id_estado
    FROM FIDE_LICENCIAS_EMPLEADO_TB
    WHERE ID_Empleado = P_ID_EMPLEADO;
    RETURN V_CURSOR;
END FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_EMPLEADO_FN;
/

-- Function para buscar factura por pedido ID
/
CREATE OR REPLACE FUNCTION FIDE_FACTURAS_TB_BUSCAR_POR_PEDIDO_FN(P_ID_PEDIDO IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
    FROM FIDE_FACTURAS_TB
    WHERE ID_Pedido = P_ID_PEDIDO;
    RETURN V_CURSOR;
END FIDE_FACTURAS_TB_BUSCAR_POR_PEDIDO_FN;
/
--busca empleado por Nombre

/
CREATE OR REPLACE FUNCTION FIDE_EMPLEADOS_TB_BUSCAR_EMPLEADO_POR_NOMBRE_FN(P_NOMBRE IN VARCHAR2)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Empleado, Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion
    FROM FIDE_EMPLEADOS_TB
    WHERE LOWER(Nombre) LIKE '%' || LOWER(P_NOMBRE) || '%';
    RETURN V_CURSOR;
END FIDE_EMPLEADOS_TB_BUSCAR_EMPLEADO_POR_NOMBRE_FN;
/

--buscar empleado por ID_Empleado
/
CREATE OR REPLACE FUNCTION FIDE_EMPLEADOS_TB_BUSCAR_EMPLEADO_POR_ID_FN(P_EMPLEADO_ID IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Empleado, Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion
    FROM FIDE_EMPLEADOS_TB
    WHERE ID_Empleado = P_EMPLEADO_ID;
    RETURN V_CURSOR;
END FIDE_EMPLEADOS_TB_BUSCAR_EMPLEADO_POR_ID_FN;
/

--buscar vehiculo por placa
/
CREATE OR REPLACE FUNCTION FIDE_VEHICULOS_TB_BUSCAR_VEHICULO_PLACA_FN(P_PLACA IN VARCHAR2)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Vehiculo, Marca, Modelo, Anio, Placa, Id_estado
    FROM FIDE_VEHICULOS_TB
    WHERE LOWER(Placa) LIKE '%' || LOWER(P_PLACA) || '%';
    RETURN V_CURSOR;
END FIDE_VEHICULOS_TB_BUSCAR_VEHICULO_PLACA_FN;
/

--busca vehiculo por marca
/
CREATE OR REPLACE FUNCTION FIDE_VEHICULOS_TB_BUSCAR_VEHICULO_MARCA_FN(P_MARCA IN VARCHAR2)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Vehiculo, Marca, Modelo, Anio, Placa, Id_estado
    FROM FIDE_VEHICULOS_TB
    WHERE LOWER(Marca) LIKE '%' || LOWER(P_MARCA) || '%';
    RETURN V_CURSOR;
END FIDE_VEHICULOS_TB_BUSCAR_VEHICULO_MARCA_FN;
/

--busca pedido por id
/
CREATE OR REPLACE FUNCTION FIDE_PEDIDOS_TB_BUSCAR_POR_ID_FN(P_PEDIDO_ID IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Pedido, ID_Cliente, Fecha, ID_Estado
    FROM FIDE_PEDIDOS_TB
    WHERE ID_Pedido = P_PEDIDO_ID;
    RETURN V_CURSOR;
END FIDE_PEDIDOS_TB_BUSCAR_POR_ID_FN;
/

--busca pedido por id_Estado
/
CREATE OR REPLACE FUNCTION FIDE_PEDIDOS_TB_BUSCAR_POR_ESTADO_FN(P_PEDIDO_ID_ESTADO IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Pedido, ID_Cliente, Fecha, ID_Estado
    FROM FIDE_PEDIDOS_TB
    WHERE ID_Estado = P_PEDIDO_ID_ESTADO;
    RETURN V_CURSOR;
END FIDE_PEDIDOS_TB_BUSCAR_POR_ESTADO_FN;
/

--busca facturas por ID
/
CREATE OR REPLACE FUNCTION FIDE_FACTURAS_TB_BUSCAR_POR_ID_FN(P_FACTURA_ID IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
    FROM FIDE_FACTURAS_TB
    WHERE ID_Factura = P_FACTURA_ID;
    RETURN V_CURSOR;
END FIDE_FACTURAS_TB_BUSCAR_POR_ID_FN;
/

--buscar facturas por Total
/
CREATE OR REPLACE FUNCTION FIDE_FACTURAS_TB_BUSCAR_POR_TOTAL_FN(P_FACTURA_TOTAL IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
    FROM FIDE_FACTURAS_TB
    WHERE Total = P_FACTURA_TOTAL;
    RETURN V_CURSOR;
END FIDE_FACTURAS_TB_BUSCAR_POR_TOTAL_FN;
/

-- buscar detalles de pedido por id_pedido
/
CREATE OR REPLACE FUNCTION FIDE_DETALLES_PEDIDO_TB_BUSCAR_POR_PEDIDO_FN(P_PEDIDO_ID IN NUMBER)
RETURN SYS_REFCURSOR AS
    V_CURSOR SYS_REFCURSOR;
BEGIN
    OPEN V_CURSOR FOR
    SELECT ID_Detalle, ID_Pedido, ID_Producto, Cantidad, Unidad_Masa, ID_Estado
    FROM FIDE_DETALLES_PEDIDO_TB
    WHERE ID_Pedido = P_PEDIDO_ID;
    RETURN V_CURSOR;
END FIDE_DETALLES_PEDIDO_TB_BUSCAR_POR_PEDIDO_FN;
/

-- STORED PROCEDURES

-- Script para crear los SPs de la base de datos

/* SP de objeto Categoria */
/
CREATE OR REPLACE PROCEDURE FIDE_CATEGORIAS_TB_INSERTAR_SP (
    P_DESCRIPCION IN VARCHAR2,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_CATEGORIAS_TB (Descripcion, Id_estado)
    VALUES (P_DESCRIPCION, P_ID_ESTADO);
END FIDE_CATEGORIAS_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_CATEGORIAS_TB_VER_CATEGORIA_SP (
    P_ID_CATEGORIA IN NUMBER,
    P_DESCRIPCION OUT VARCHAR2,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT Descripcion, Id_estado
    INTO P_DESCRIPCION, P_ID_ESTADO
    FROM FIDE_CATEGORIAS_TB
    WHERE ID_Categoria = P_ID_CATEGORIA;
END FIDE_CATEGORIAS_TB_VER_CATEGORIA_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_CATEGORIAS_TB_VER_CATEGORIAS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Categoria, Descripcion, Id_estado
    FROM FIDE_CATEGORIAS_TB;
END FIDE_CATEGORIAS_TB_VER_CATEGORIAS_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_CATEGORIAS_TB_ACTUALIZAR_SP (
    P_ID_CATEGORIA IN NUMBER,
    P_DESCRIPCION IN VARCHAR2,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_CATEGORIAS_TB
    SET Descripcion = P_DESCRIPCION,
        Id_estado = P_ID_ESTADO
    WHERE ID_Categoria = P_ID_CATEGORIA;
END FIDE_CATEGORIAS_TB_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_CATEGORIAS_TB_INACTIVAR_SP (
    P_ID_CATEGORIA IN NUMBER
) AS
BEGIN
    UPDATE FIDE_CATEGORIAS_TB
    SET Id_estado = 8
    WHERE ID_Categoria = P_ID_CATEGORIA;
END FIDE_CATEGORIAS_TB_INACTIVAR_SP;
/

/* SP de objeto Producto */
/
CREATE OR REPLACE PROCEDURE FIDE_PRODUCTOS_TB_INSERTAR_SP (
    P_NOMBRE IN VARCHAR2,
    P_DESCRIPCION IN VARCHAR2,
    P_ID_CATEGORIA IN NUMBER,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_PRODUCTOS_TB (Nombre, Descripcion, ID_Categoria, Id_estado)
    VALUES (P_NOMBRE, P_DESCRIPCION, P_ID_CATEGORIA, P_ID_ESTADO);
END FIDE_PRODUCTOS_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_PRODUCTOS_TB_VER_PRODUCTO_SP (
    P_ID_PRODUCTO IN NUMBER,
    P_NOMBRE OUT VARCHAR2,
    P_DESCRIPCION OUT VARCHAR2,
    P_ID_CATEGORIA OUT NUMBER,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT Nombre, Descripcion, ID_Categoria, Id_estado
    INTO P_NOMBRE, P_DESCRIPCION, P_ID_CATEGORIA, P_ID_ESTADO
    FROM FIDE_PRODUCTOS_TB
    WHERE ID_Producto = P_ID_PRODUCTO;
END FIDE_PRODUCTOS_TB_VER_PRODUCTO_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_PRODUCTOS_TB_VER_PRODUCTOS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Producto, Nombre, Descripcion, ID_Categoria, Id_estado
    FROM FIDE_PRODUCTOS_TB;
END FIDE_PRODUCTOS_TB_VER_PRODUCTOS_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_PRODUCTOS_TB_ACTUALIZAR_SP (
    P_ID_PRODUCTO IN NUMBER,
    P_NOMBRE IN VARCHAR2,
    P_DESCRIPCION IN VARCHAR2,
    P_ID_CATEGORIA IN NUMBER,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_PRODUCTOS_TB
    SET Nombre = P_NOMBRE,
        Descripcion = P_DESCRIPCION,
        ID_Categoria = P_ID_CATEGORIA,
        Id_estado = P_ID_ESTADO
    WHERE ID_Producto = P_ID_PRODUCTO;
END FIDE_PRODUCTOS_TB_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_PRODUCTOS_TB_INACTIVAR_SP (
    P_ID_PRODUCTO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_PRODUCTOS_TB
    SET Id_estado = 8
    WHERE ID_Producto = P_ID_PRODUCTO;
END FIDE_PRODUCTOS_TB_INACTIVAR_SP;
/

/* SP de objeto Empleado */
/
CREATE OR REPLACE PROCEDURE FIDE_EMPLEADOS_TB_INSERTAR_SP (
    P_NOMBRE IN VARCHAR2,
    P_APELLIDO IN VARCHAR2,
    P_FECHA_NACIMIENTO IN DATE,
    P_FECHA_CONTRATACION IN DATE,
    P_ID_PUESTO IN VARCHAR2,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_EMPLEADOS_TB (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, Id_Estado)
    VALUES (P_NOMBRE, P_APELLIDO, P_FECHA_NACIMIENTO, P_FECHA_CONTRATACION, P_ID_PUESTO, P_ID_ESTADO);
END FIDE_EMPLEADOS_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_EMPLEADOS_TB_VER_EMPLEADO_SP (
    P_ID_EMPLEADO IN NUMBER,
    P_NOMBRE OUT VARCHAR2,
    P_APELLIDO OUT VARCHAR2,
    P_FECHA_NACIMIENTO OUT DATE,
    P_FECHA_CONTRATACION OUT DATE,
    P_ID_PUESTO OUT VARCHAR2,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, Id_Estado
    INTO P_NOMBRE, P_APELLIDO, P_FECHA_NACIMIENTO, P_FECHA_CONTRATACION, P_ID_PUESTO, P_ID_ESTADO
    FROM FIDE_EMPLEADOS_TB
    WHERE ID_Empleado = P_ID_EMPLEADO;
END FIDE_EMPLEADOS_TB_VER_EMPLEADO_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_EMPLEADOS_TB_VER_EMPLEADOS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Empleado, Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto, Id_Estado
    FROM FIDE_EMPLEADOS_TB;
END FIDE_EMPLEADOS_TB_VER_EMPLEADOS_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_EMPLEADOS_TB_ACTUALIZAR_SP (
    P_ID_EMPLEADO IN NUMBER,
    P_NOMBRE IN VARCHAR2,
    P_APELLIDO IN VARCHAR2,
    P_FECHA_NACIMIENTO IN DATE,
    P_FECHA_CONTRATACION IN DATE,
    P_ID_PUESTO IN VARCHAR2,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_EMPLEADOS_TB
    SET Nombre = P_NOMBRE,
        Apellido = P_APELLIDO,
        Fecha_Nacimiento = P_FECHA_NACIMIENTO,
        Fecha_Contratacion = P_FECHA_CONTRATACION,
        ID_Puesto = P_ID_PUESTO,
        ID_Estado = P_ID_ESTADO
    WHERE ID_Empleado = P_ID_EMPLEADO;
END FIDE_EMPLEADOS_TB_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_EMPLEADOS_TB_INACTIVAR_SP (
    P_ID_EMPLEADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_EMPLEADOS_TB
    SET ID_Estado = 8
    WHERE ID_Empleado = P_ID_EMPLEADO;
END FIDE_EMPLEADOS_TB_INACTIVAR_SP;
/

/* SP de objeto Cliente */
/
CREATE OR REPLACE PROCEDURE FIDE_CLIENTES_TB_INSERTAR_SP (
    P_NOMBRE IN VARCHAR2,
    P_APELLIDO  IN VARCHAR2,
    P_TELEFONO IN VARCHAR2,
    P_EMAIL IN VARCHAR2,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_CLIENTES_TB (Nombre, Apellido, Telefono, Email, Id_estado)
    VALUES (P_NOMBRE, P_APELLIDO, P_TELEFONO, P_EMAIL, P_ID_ESTADO);
END FIDE_CLIENTES_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_CLIENTES_TB_VER_CLIENTE_SP (
    P_ID_CLIENTE IN NUMBER,
    P_NOMBRE OUT VARCHAR2,
    P_APELLIDO OUT VARCHAR2,
    P_TELEFONO OUT VARCHAR2,
    P_EMAIL OUT VARCHAR2,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT Nombre, Apellido, Telefono, Email, Id_estado
    INTO P_NOMBRE, P_APELLIDO, P_TELEFONO, P_EMAIL, P_ID_ESTADO
    FROM FIDE_CLIENTES_TB
    WHERE ID_Cliente = P_ID_CLIENTE;
END FIDE_CLIENTES_TB_VER_CLIENTE_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_CLIENTES_TB_VER_CLIENTES_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Cliente, Nombre, Apellido, Telefono, Email, Id_estado
    FROM FIDE_CLIENTES_TB;
END FIDE_CLIENTES_TB_VER_CLIENTES_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_CLIENTES_TB_ACTUALIZAR_SP (
    P_ID_CLIENTE IN NUMBER,
    P_NOMBRE IN VARCHAR2,
    P_APELLIDO IN VARCHAR2,
    P_TELEFONO IN VARCHAR2,
    P_EMAIL IN VARCHAR2,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_CLIENTES_TB
    SET Nombre = P_NOMBRE,
        Apellido = P_APELLIDO,
        Telefono = P_TELEFONO,
        Email = P_EMAIL, 
        Id_estado = P_ID_ESTADO
    WHERE ID_Cliente = P_ID_CLIENTE;
END FIDE_CLIENTES_TB_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_CLIENTES_TB_INACTIVAR_SP (
    P_ID_CLIENTE IN NUMBER
) AS
BEGIN
    UPDATE FIDE_CLIENTES_TB
    SET Id_estado = 8 
    WHERE ID_Cliente = P_ID_CLIENTE;
END FIDE_CLIENTES_TB_INACTIVAR_SP;
/

/* SP de objeto Provincia */
/
CREATE OR REPLACE PROCEDURE FIDE_PROVINCIAS_TB_VER_PROVINCIA_SP (
    P_ID_PROVINCIA IN NUMBER,
    P_NOMBRE OUT VARCHAR2,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT Nombre, Id_estado
    INTO P_NOMBRE, P_ID_ESTADO
    FROM FIDE_PROVINCIAS_TB
    WHERE ID_Provincia = P_ID_PROVINCIA;
END FIDE_PROVINCIAS_TB_VER_PROVINCIA_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_PROVINCIAS_TB_VER_PROVINCIAS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Provincia, Nombre, id_estado
    FROM FIDE_PROVINCIAS_TB;
END FIDE_PROVINCIAS_TB_VER_PROVINCIAS_SP;
/
/* SP de objeto Canton */

/
CREATE OR REPLACE PROCEDURE FIDE_CANTONES_TB_VER_CANTON_SP (
    P_ID_CANTON IN NUMBER,
    P_NOMBRE OUT VARCHAR2,
    P_ID_PROVINCIA OUT NUMBER,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT Nombre, ID_Provincia, Id_estado
    INTO P_NOMBRE, P_ID_PROVINCIA, P_ID_ESTADO
    FROM FIDE_CANTONES_TB
    WHERE ID_Canton = P_ID_CANTON;
END FIDE_CANTONES_TB_VER_CANTON_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_CANTONES_TB_VER_CANTONES_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Canton, Nombre, ID_Provincia, Id_estado 
    FROM FIDE_CANTONES_TB;
END FIDE_CANTONES_TB_VER_CANTONES_SP;
/
/* SP de objeto Distrito */

/
CREATE OR REPLACE PROCEDURE FIDE_DISTRITOS_TB_VER_DISTRITO_SP (
    P_ID_DISTRITO IN NUMBER,
    P_NOMBRE OUT VARCHAR2,
    P_ID_CANTON OUT NUMBER, 
    P_ID_PROVINCIA OUT NUMBER, 
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT Nombre, ID_Canton, Id_Provincia, Id_estado
    INTO P_NOMBRE, P_ID_CANTON, P_ID_PROVINCIA, P_ID_ESTADO
    FROM FIDE_DISTRITOS_TB
    WHERE ID_Distrito = P_ID_DISTRITO;
END FIDE_DISTRITOS_TB_VER_DISTRITO_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DISTRITOS_TB_VER_DISTRITOS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT Id_Distrito, Nombre, ID_Canton, Id_Provincia, Id_estado
    FROM FIDE_DISTRITOS_TB;
END FIDE_DISTRITOS_TB_VER_DISTRITOS_SP;
/

/* SP de objeto DireccionCliente */
/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_CLIENTE_TB_INSERTAR_SP (
    P_ID_CLIENTE IN NUMBER,
    P_DETALLES IN VARCHAR2,
    P_PROVINCIA IN VARCHAR2,
    P_CANTON IN VARCHAR2,
    P_DISTRITO IN VARCHAR2,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_DIRECCIONES_CLIENTE_TB (ID_Cliente, ID_Provincia, ID_Canton, ID_Distrito, Detalles, Id_estado)
    VALUES (P_ID_CLIENTE, P_PROVINCIA, P_CANTON, P_DISTRITO, P_DETALLES, P_ID_ESTADO);
END FIDE_DIRECCIONES_CLIENTE_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_CLIENTE_TB_ACTUALIZAR_SP (
    P_ID_DIRECCION IN NUMBER,
    P_DETALLES IN VARCHAR2,
    P_PROVINCIA IN VARCHAR2,
    P_CANTON IN VARCHAR2,
    P_DISTRITO IN VARCHAR2, 
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_DIRECCIONES_CLIENTE_TB
    SET ID_Provincia = P_PROVINCIA,
        ID_Canton = P_CANTON,
        ID_Distrito = P_DISTRITO,
        Detalles = P_DETALLES, 
        Id_estado = P_ID_ESTADO
    WHERE ID_Direccion = P_ID_DIRECCION;
END FIDE_DIRECCIONES_CLIENTE_TB_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_CLIENTE_TB_VER_DIRECCION_SP (
    P_ID_DIRECCION IN NUMBER,
    P_ID_CLIENTE OUT NUMBER,
    P_DETALLES OUT VARCHAR2,
    P_DISTRITO OUT VARCHAR2,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT ID_Cliente, Detalles, ID_Distrito, Id_estado
    INTO P_ID_CLIENTE, P_DETALLES, P_DISTRITO, P_ID_ESTADO
    FROM FIDE_DIRECCIONES_CLIENTE_TB
    WHERE ID_Direccion = P_ID_DIRECCION;
END FIDE_DIRECCIONES_CLIENTE_TB_VER_DIRECCION_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_CLIENTE_TB_VER_DIRECCIONES_SP(
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Direccion, ID_Cliente, Detalles, ID_Distrito, Id_estado
    FROM FIDE_DIRECCIONES_CLIENTE_TB;
END FIDE_DIRECCIONES_CLIENTE_TB_VER_DIRECCIONES_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_CLIENTE_TB_INACTIVAR_SP (
    P__ID_DIRECCION IN NUMBER
) AS
BEGIN
    UPDATE FIDE_DIRECCIONES_CLIENTE_TB
    SET ID_Estado = 8
    WHERE ID_Direccion = P__ID_DIRECCION;
END FIDE_DIRECCIONES_CLIENTE_TB_INACTIVAR_SP;
/

-- SP de objeto Licencia

/
CREATE OR REPLACE PROCEDURE FIDE_LICENCIAS_TB_VER_LICENCIA_SP (
    P_ID_LICENCIA IN NUMBER,
    P_TIPO OUT VARCHAR2,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT Tipo, Id_estado
    INTO P_TIPO, P_ID_ESTADO
    FROM FIDE_LICENCIAS_TB
    WHERE ID_Licencia = P_ID_LICENCIA;
END FIDE_LICENCIAS_TB_VER_LICENCIA_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_LICENCIAS_TB_VER_LICENCIAS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Licencia, Tipo, Id_estado
    FROM FIDE_LICENCIAS_TB;
END FIDE_LICENCIAS_TB_VER_LICENCIAS_SP;
/

-- SP de objeto Estado

/
CREATE OR REPLACE PROCEDURE FIDE_ESTADOS_TB_VER_ESTADO_SP (
    P_ID_ESTADO IN NUMBER,
    P_DESCRIPCION OUT VARCHAR2
) AS
BEGIN
    SELECT Descripcion
    INTO P_DESCRIPCION
    FROM FIDE_ESTADOS_TB
    WHERE ID_Estado = P_ID_ESTADO;
END FIDE_ESTADOS_TB_VER_ESTADO_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_ESTADOS_TB_VER_ESTADOS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Estado, Descripcion
    FROM FIDE_ESTADOS_TB;
END FIDE_ESTADOS_TB_VER_ESTADOS_SP;
/

-- SP de objeto Tipos_Carga
/
CREATE OR REPLACE PROCEDURE FIDE_TIPOS_CARGA_TB_VER_TIPO_CARGA_SP (
    P_ID_TIPO IN NUMBER,
    P_DESCRIPCION OUT VARCHAR2,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT Descripcion, Id_estado 
    INTO P_DESCRIPCION, P_ID_ESTADO
    FROM FIDE_TIPOS_CARGA_TB
    WHERE ID_Tipo_Carga = P_ID_TIPO;
END FIDE_TIPOS_CARGA_TB_VER_TIPO_CARGA_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_TIPOS_CARGA_TB_VER_TIPOS_CARGA_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Tipo_Carga, Descripcion, Id_estado
    FROM FIDE_TIPOS_CARGA_TB;
END FIDE_TIPOS_CARGA_TB_VER_TIPOS_CARGA_SP;
/

-- SP de objeto Puesto
/
CREATE OR REPLACE PROCEDURE FIDE_PUESTOS_TB_VER_PUESTO_SP (
    P_ID_PUESTO IN VARCHAR2,
    P_DESCRIPCION OUT VARCHAR2,
    P_SALARIO OUT NUMBER,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT Descripcion, Salario, Id_estado
    INTO P_DESCRIPCION, P_SALARIO, P_ID_ESTADO
    FROM FIDE_PUESTOS_TB
    WHERE ID_Puesto = P_ID_PUESTO;
END FIDE_PUESTOS_TB_VER_PUESTO_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_PUESTOS_TB_VER_PUESTOS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Puesto, Descripcion, Salario, Id_estado
    FROM FIDE_PUESTOS_TB;
END FIDE_PUESTOS_TB_VER_PUESTOS_SP;
/

-- SP de objeto Vehiculo

/
CREATE OR REPLACE PROCEDURE FIDE_VEHICULOS_TB_VER_VEHICULO_SP (
    P_ID_VEHICULO IN NUMBER,
    P_MARCA OUT VARCHAR2,
    P_MODELO OUT VARCHAR2,
    P_ANIO OUT INT,
    P_PLACA OUT VARCHAR2,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT Marca, Modelo, Anio, Placa, Id_estado
    INTO P_MARCA, P_MODELO, P_ANIO, P_PLACA, P_ID_ESTADO
    FROM FIDE_VEHICULOS_TB
    WHERE ID_Vehiculo = P_ID_VEHICULO;
END FIDE_VEHICULOS_TB_VER_VEHICULO_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_VEHICULOS_TB_VER_VEHICULOS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Vehiculo, Marca, Modelo, Anio, Placa, Id_estado
    FROM FIDE_VEHICULOS_TB;
END FIDE_VEHICULOS_TB_VER_VEHICULOS_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_VEHICULOS_TB_INSERTAR_SP (
    P_MARCA IN VARCHAR2,
    P_MODELO IN VARCHAR2,
    P_ANIO IN NUMBER,
    P_PLACA IN VARCHAR2,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_VEHICULOS_TB (Marca, Modelo, Anio, Placa, Id_estado)
    VALUES (P_MARCA, P_MODELO, P_ANIO, P_PLACA, P_ID_ESTADO);
END FIDE_VEHICULOS_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_VEHICULOS_TB_ACTUALIZAR_SP (
    P_ID_VEHICULO IN NUMBER,
    P_MARCA IN VARCHAR2,
    P_MODELO IN VARCHAR2,
    P_ANIO IN NUMBER,
    P_PLACA IN VARCHAR2, 
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_VEHICULOS_TB
    SET Marca = P_MARCA,
        Modelo = P_MODELO,
        Anio = P_ANIO,
        Placa = P_PLACA,
        Id_estado = P_ID_ESTADO
    WHERE ID_Vehiculo = P_ID_VEHICULO;
END FIDE_VEHICULOS_TB_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_VEHICULOS_TB_INACTIVAR_SP (
    P_ID_VEHICULO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_VEHICULOS_TB
    SET Id_estado = 8
    WHERE ID_Vehiculo = P_ID_VEHICULO;
END FIDE_VEHICULOS_TB_INACTIVAR_SP;
/

-- SP de objeto Licencia_Empleado
/
CREATE OR REPLACE PROCEDURE FIDE_LICENCIAS_EMPLEADO_TB_INSERTAR_SP (
    P_ID_EMPLEADO IN NUMBER,
    P_ID_LICENCIA IN NUMBER,
    P_FECHA_EXPEDICION IN DATE,
    P_FECHA_VENCIMIENTO IN DATE,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_LICENCIAS_EMPLEADO_TB (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento, Id_estado)
    VALUES (P_ID_EMPLEADO, P_ID_LICENCIA, P_FECHA_EXPEDICION, P_FECHA_VENCIMIENTO, P_ID_ESTADO);
END FIDE_LICENCIAS_EMPLEADO_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_LICENCIAS_EMPLEADO_TB_VER_LICENCIA_SP (
    P_ID_LICENCIA_EMPLEADO IN NUMBER,
    P_ID_EMPLEADO OUT NUMBER,
    P_ID_LICENCIA OUT NUMBER,
    P_FECHA_EXPEDICION OUT DATE,
    P_FECHA_VENCIMIENTO OUT DATE, 
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento, Id_estado 
    INTO P_ID_EMPLEADO, P_ID_LICENCIA, P_FECHA_EXPEDICION, P_FECHA_VENCIMIENTO, P_ID_ESTADO
    FROM FIDE_LICENCIAS_EMPLEADO_TB
    WHERE ID_Licencia_Empleado = P_ID_LICENCIA_EMPLEADO;
END FIDE_LICENCIAS_EMPLEADO_TB_VER_LICENCIA_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_LICENCIAS_EMPLEADO_TB_VER_LICENCIAS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Licencia_Empleado, ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento, Id_estado
    FROM FIDE_LICENCIAS_EMPLEADO_TB;
END FIDE_LICENCIAS_EMPLEADO_TB_VER_LICENCIAS_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_LICENCIAS_EMPLEADO_TB_ACTUALIZAR_SP (
    P_ID_LICENCIA_EMPLEADO IN NUMBER,
    P_ID_LICENCIA IN NUMBER,
    P_FECHA_EXPEDICION IN DATE,
    P_FECHA_VENCIMIENTO IN DATE,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_LICENCIAS_EMPLEADO_TB
    SET ID_Licencia = P_ID_LICENCIA,
        Fecha_Expedicion = P_FECHA_EXPEDICION,
        Fecha_Vencimiento = P_FECHA_VENCIMIENTO,
        Id_estado = P_ID_ESTADO
    WHERE ID_Licencia_Empleado = P_ID_LICENCIA_EMPLEADO;
END FIDE_LICENCIAS_EMPLEADO_TB_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_LICENCIAS_EMPLEADO_TB_INACTIVAR_SP (
    P_ID_LICENCIA_EMPLEADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_LICENCIAS_EMPLEADO_TB
    SET ID_Estado = 8
    WHERE ID_Licencia_Empleado = P_ID_LICENCIA_EMPLEADO;
END FIDE_LICENCIAS_EMPLEADO_TB_INACTIVAR_SP;
/
-- SP de objeto Direccion_Empleado

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_EMPLEADO_TB_INSERTAR_SP (
    P_ID_EMPLEADO IN NUMBER,
    P_DETALLES IN VARCHAR2,
    P_ID_PROVINCIA IN NUMBER,
    P_ID_CANTON IN NUMBER,
    P_ID_DISTRITO IN NUMBER, 
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_DIRECCIONES_EMPLEADO_TB (ID_Empleado, Detalles, ID_Provincia, ID_Canton, ID_Distrito, Id_estado)
    VALUES (P_ID_EMPLEADO, P_DETALLES, P_ID_PROVINCIA, P_ID_CANTON, P_ID_DISTRITO, P_ID_ESTADO);
END FIDE_DIRECCIONES_EMPLEADO_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_EMPLEADO_TB_VER_DIRECION_SP (
    P_ID_DIRECCION IN NUMBER,
    P_ID_EMPLEADO OUT NUMBER,
    P_DETALLES OUT VARCHAR2,
    P_ID_DISTRITO OUT VARCHAR2,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT ID_Empleado, Detalles, ID_Distrito, Id_estado
    INTO P_ID_EMPLEADO, P_DETALLES, P_ID_DISTRITO, P_ID_ESTADO
    FROM FIDE_DIRECCIONES_EMPLEADO_TB
    WHERE ID_Direccion = P_ID_DIRECCION;
END FIDE_DIRECCIONES_EMPLEADO_TB_VER_DIRECION_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_EMPLEADO_TB_VER_DIRECIONES_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Direccion, ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles, Id_estado 
    FROM FIDE_DIRECCIONES_EMPLEADO_TB;
END FIDE_DIRECCIONES_EMPLEADO_TB_VER_DIRECIONES_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_EMPLEADO_TB_ACTUALIZAR_SP (
    P_ID_DIRECCION IN NUMBER,
    P_DETALLES IN VARCHAR2,
    P_ID_PROVINCIA IN NUMBER,
    P_ID_CANTON IN NUMBER,
    P_ID_DISTRITO IN NUMBER,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_DIRECCIONES_EMPLEADO_TB
    SET ID_Provincia = P_ID_PROVINCIA,
        ID_Canton = P_ID_CANTON,
        ID_Distrito = P_ID_DISTRITO,
        Detalles = P_DETALLES,
        Id_estado = P_ID_ESTADO
    WHERE ID_Direccion = P_ID_DIRECCION;
END FIDE_DIRECCIONES_EMPLEADO_TB_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_EMPLEADO_TB_INACTIVAR_SP (
    P_ID_DIRECCION IN NUMBER
) AS
BEGIN
    UPDATE FIDE_DIRECCIONES_EMPLEADO_TB
    SET ID_Estado = 8
    WHERE ID_Direccion = P_ID_DIRECCION;
END FIDE_DIRECCIONES_EMPLEADO_TB_INACTIVAR_SP;
/

-- SP de objeto Pedido
/
CREATE OR REPLACE PROCEDURE FIDE_PEDIDOS_TB_INSERTAR_SP (
    P_ID_CLIENTE IN NUMBER,
    P_ID_VEHICULO IN NUMBER,
    P_ID_TIPO_CARGA IN NUMBER,
    P_FECHA IN DATE,
    P_ID_ESTADO IN NUMBER,
    P_ID_LICENCIAS_EMPLEADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_PEDIDOS_TB (ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado)
    VALUES (P_ID_CLIENTE, P_ID_VEHICULO, P_ID_TIPO_CARGA, P_FECHA, P_ID_ESTADO, P_ID_LICENCIAS_EMPLEADO);
END FIDE_PEDIDOS_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_PEDIDOS_TB_VER_PEDIDO_SP (
    P_ID_PEDIDO IN NUMBER,
    P_ID_CLIENTE OUT NUMBER,
    P_ID_VEHICULO OUT NUMBER,
    P_ID_TIPO_CARGA OUT NUMBER,
    P_FECHA OUT DATE,
    P_ID_ESTADO OUT NUMBER,
    P_ID_LICENCIA_EMPLEADO OUT NUMBER
) AS
BEGIN
    SELECT  ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado
    INTO p_id_cliente, p_id_vehiculo, p_id_tipo_carga, p_fecha, p_id_estado, p_id_licencia_empleado
    FROM FIDE_PEDIDOS_TB
    WHERE ID_Pedido = P_ID_PEDIDO;
END FIDE_PEDIDOS_TB_VER_PEDIDO_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_PEDIDOS_TB_VER_PEDIDOS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Pedido, ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado
    FROM FIDE_PEDIDOS_TB;
END FIDE_PEDIDOS_TB_VER_PEDIDOS_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_PEDIDOS_TB_ACTUALIZAR_SP (
    P_ID_PEDIDO IN NUMBER,
    P_ID_CLIENTE IN NUMBER,
    P_ID_VEHICULO IN NUMBER,
    P_ID_TIPO_CARGA IN NUMBER,
    P_FECHA IN DATE,
    P_ID_ESTADO IN NUMBER,
    P_ID_LICENCIA_EMPLEADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_PEDIDOS_TB
    SET ID_Cliente = P_ID_CLIENTE,
        ID_Vehiculo = P_ID_VEHICULO,
        ID_Tipo_Carga = P_ID_TIPO_CARGA,
        Fecha = P_FECHA,
        ID_Estado = P_ID_ESTADO,
        ID_Licencia_Empleado = P_ID_LICENCIA_EMPLEADO
    WHERE ID_Pedido = P_ID_PEDIDO;
END FIDE_PEDIDOS_TB_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_PEDIDOS_TB_INACTIVAR_SP (
    P_ID_PEDIDO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_PEDIDOS_TB
    SET Id_estado = 8
    WHERE ID_Pedido = P_ID_PEDIDO;
END FIDE_PEDIDOS_TB_INACTIVAR_SP;
/

-- SP de objeto Direcciones_Pedido
/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_PEDIDO_TB_INSERTAR_SP(
    P_ID_PEDIDO IN NUMBER,
    P_DETALLES IN VARCHAR2,
    P_ID_PROVINCIA IN NUMBER,
    P_ID_CANTON IN NUMBER,
    P_ID_DISTRITO IN NUMBER,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_DIRECCIONES_PEDIDO_TB (ID_Pedido, Detalles, ID_Provincia, ID_Canton, ID_Distrito, Id_estado)
    VALUES (P_ID_PEDIDO, P_DETALLES, P_ID_PROVINCIA, P_ID_CANTON, P_ID_DISTRITO, P_ID_ESTADO);
END FIDE_DIRECCIONES_PEDIDO_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_PEDIDO_TB_VER_DIRECCION_SP (
    P_ID_DIRECCION IN NUMBER,
    P_ID_PEDIDO OUT NUMBER,
    P_DETALLES OUT VARCHAR2,
    P_ID_DISTRITO OUT VARCHAR2,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT ID_Pedido, Detalles, ID_Distrito, Id_estado
    INTO P_ID_PEDIDO, P_DETALLES, P_ID_DISTRITO, P_ID_ESTADO
    FROM FIDE_DIRECCIONES_PEDIDO_TB
    WHERE ID_Direccion = P_ID_DIRECCION;
END FIDE_DIRECCIONES_PEDIDO_TB_VER_DIRECCION_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_PEDIDO_TB_VER_DIRECCIONES_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Direccion, ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles, Id_estado
    FROM FIDE_DIRECCIONES_PEDIDO_TB;
END FIDE_DIRECCIONES_PEDIDO_TB_VER_DIRECCIONES_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_PEDIDO_TB_ACTUALIZAR_SP (
    P_ID_DIRECCION IN NUMBER,
    P_DETALLES IN VARCHAR2,
    P_ID_PROVINCIA IN NUMBER,
    P_ID_CANTON IN NUMBER,
    P_ID_DISTRITO IN NUMBER,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_DIRECCIONES_PEDIDO_TB
    SET ID_Provincia = P_ID_PROVINCIA,
        ID_Canton = P_ID_CANTON,
        ID_Distrito = P_ID_DISTRITO,
        Detalles = P_DETALLES,
        Id_estado = P_ID_ESTADO
    WHERE ID_Direccion = P_ID_DIRECCION;
END FIDE_DIRECCIONES_PEDIDO_TB_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DIRECCIONES_PEDIDO_TB_INACTIVAR_SP (
    P_ID_DIRECCION IN NUMBER
) AS
BEGIN
    UPDATE FIDE_DIRECCIONES_PEDIDO_TB
    SET ID_Estado = 8
    WHERE ID_Direccion = P_ID_DIRECCION;
END FIDE_DIRECCIONES_PEDIDO_TB_INACTIVAR_SP;
/

-- SP de objeto Factura
/
CREATE OR REPLACE PROCEDURE FIDE_FACTURAS_TB_INSERTAR_SP (
    P_ID_PEDIDO IN NUMBER,
    P_FECHA IN DATE,
    P_TOTAL IN NUMBER,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_FACTURAS_TB (ID_Pedido, Fecha, Total, ID_Estado)
    VALUES (P_ID_PEDIDO, P_FECHA, P_TOTAL, P_ID_ESTADO);
END FIDE_FACTURAS_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_FACTURAS_TB_VER_FACTURA_SP (
    P_ID_FACTURA IN NUMBER,
    P_ID_PEDIDO OUT NUMBER,
    P_FECHA OUT DATE,
    P_TOTAL OUT NUMBER,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT ID_Pedido, Fecha, Total, ID_Estado
    INTO P_ID_PEDIDO, P_FECHA, P_TOTAL, P_ID_ESTADO
    FROM FIDE_FACTURAS_TB
    WHERE ID_Factura = p_id_factura;
END FIDE_FACTURAS_TB_VER_FACTURA_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_FACTURAS_TB_VER_FACTURAS_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
    FROM FIDE_FACTURAS_TB;
END FIDE_FACTURAS_TB_VER_FACTURAS_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_FACTURAS_TB_VER_ACTUALIZAR_SP (
    P_ID_FACTURA IN NUMBER,
    P_FECHA IN DATE,
    P_TOTAL IN NUMBER,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_FACTURAS_TB
    SET Fecha = P_FECHA,
        Total = P_TOTAL,
        ID_Estado = P_ID_ESTADO
    WHERE ID_Factura = P_ID_FACTURA;
END FIDE_FACTURAS_TB_VER_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_FACTURAS_TB_VER_INACTIVAR_SP (
    P_ID_FACTURA IN NUMBER
) AS
BEGIN
    UPDATE FIDE_FACTURAS_TB
    SET ID_Estado = 8
    WHERE ID_Factura = P_ID_FACTURA;
END FIDE_FACTURAS_TB_VER_INACTIVAR_SP;
/

-- SP de objeto Detalle_Pedido
/
CREATE OR REPLACE PROCEDURE FIDE_DETALLES_PEDIDO_TB_INSERTAR_SP (
    P_ID_PEDIDO IN NUMBER,
    P_ID_PRODUCTO IN NUMBER,
    P_CANTIDAD IN NUMBER,
    P_UNIDAD_MASA IN VARCHAR2,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    INSERT INTO FIDE_DETALLES_PEDIDO_TB (ID_Pedido, ID_Producto, Cantidad, Unidad_Masa, Id_estado)
    VALUES (P_ID_PEDIDO, P_ID_PRODUCTO, P_CANTIDAD, P_UNIDAD_MASA, P_ID_ESTADO);
END FIDE_DETALLES_PEDIDO_TB_INSERTAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DETALLES_PEDIDO_TB_VER_DETALLE_SP (
    P_ID_DETALLE IN NUMBER,
    P_ID_PEDIDO OUT NUMBER,
    P_ID_PRODUCTO OUT NUMBER,
    P_CANTIDAD OUT NUMBER,
    P_UNIDAD_MASA OUT VARCHAR2,
    P_ID_ESTADO OUT NUMBER
) AS
BEGIN
    SELECT ID_Pedido, ID_Producto, Cantidad, Unidad_Masa, Id_estado
    INTO P_ID_PEDIDO, P_ID_PRODUCTO, P_CANTIDAD, P_UNIDAD_MASA, P_ID_ESTADO
    FROM FIDE_DETALLES_PEDIDO_TB
    WHERE ID_Detalle = P_ID_DETALLE;
END FIDE_DETALLES_PEDIDO_TB_VER_DETALLE_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DETALLES_PEDIDO_TB_VER_DETALLES_SP (
    P_CURSOR OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_CURSOR FOR
    SELECT ID_Detalle, ID_Pedido, ID_Producto, Cantidad, Unidad_Masa, Id_estado
    FROM FIDE_DETALLES_PEDIDO_TB;
END FIDE_DETALLES_PEDIDO_TB_VER_DETALLES_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DETALLES_PEDIDO_TB_ACTUALIZAR_SP (
    P_ID_DETALLE IN NUMBER,
    P_ID_PEDIDO IN NUMBER,
    P_ID_PRODUCTO IN NUMBER,
    P_CANTIDAD IN NUMBER,
    P_UNIDAD_MASA IN VARCHAR2,
    P_ID_ESTADO IN NUMBER
) AS
BEGIN
    UPDATE FIDE_DETALLES_PEDIDO_TB
    SET ID_Pedido = P_ID_PEDIDO,
        ID_Producto = P_ID_PRODUCTO,
        Cantidad = P_CANTIDAD,
        Unidad_Masa = P_UNIDAD_MASA,
        Id_estado = P_ID_ESTADO
    WHERE ID_Detalle = P_ID_DETALLE;
END FIDE_DETALLES_PEDIDO_TB_ACTUALIZAR_SP;
/

/
CREATE OR REPLACE PROCEDURE FIDE_DETALLES_PEDIDO_TB_INACTIVAR_SP (
    P_ID_DETALLE IN NUMBER
) AS
BEGIN
    UPDATE FIDE_DETALLES_PEDIDO_TB
    SET ID_Estado = 8
    WHERE ID_Detalle = P_ID_DETALLE;
END FIDE_DETALLES_PEDIDO_TB_INACTIVAR_SP;
/

-- VIEWS
/* Vista Informacion Empleado Completa */
CREATE OR REPLACE VIEW FIDE_EMPLEADOS_V AS
SELECT 
    E.ID_Empleado,
    E.Nombre,
    E.Apellido,
    E.Fecha_Nacimiento,
    E.Fecha_Contratacion,
    P.Descripcion AS Puesto,
    P.Salario AS Salario,
    ES.Descripcion AS Estado
FROM 
    FIDE_EMPLEADOS_TB E
    JOIN FIDE_PUESTOS_TB P ON E.ID_Puesto = P.ID_Puesto
    JOIN FIDE_ESTADOS_TB ES ON E.Id_estado = ES.Id_estado;


/* Vista Licencias de Empleados */
CREATE OR REPLACE VIEW FIDE_LICENCIAS_EMPLEADO_V AS
SELECT 
    E.ID_Empleado,
    E.Nombre,
    E.Apellido,
    L.Tipo AS Tipo_Licencia,
    LE.Fecha_Expedicion,
    LE.Fecha_Vencimiento,
    ES.Descripcion AS Estado
FROM 
    FIDE_EMPLEADOS_TB E
    JOIN FIDE_LICENCIAS_EMPLEADO_TB le ON E.ID_Empleado = LE.ID_Empleado
    JOIN FIDE_LICENCIAS_TB L ON LE.ID_Licencia = L.ID_Licencia
    JOIN FIDE_ESTADOS_TB ES ON LE.Id_estado = ES.Id_estado;


/* Vista Pedidos con Direcciones */
CREATE OR REPLACE VIEW FIDE_PEDIDOS_DIRECCIONES_V AS
SELECT 
    P.ID_Pedido,
    P.Fecha,
    E.Descripcion AS Estado,
    D.Detalles AS Direccion,
    PR.Nombre AS Provincia,
    C.Nombre AS Canton,
    DI.Nombre AS Distrito
FROM 
    FIDE_PEDIDOS_TB P
    JOIN FIDE_ESTADOS_TB E ON P.ID_Estado = E.ID_Estado
    JOIN FIDE_DIRECCIONES_PEDIDO_TB D ON P.ID_Pedido = D.ID_Pedido
    JOIN FIDE_PROVINCIAS_TB PR ON D.ID_Provincia = PR.ID_Provincia
    JOIN FIDE_CANTONES_TB C ON D.ID_Canton = C.ID_Canton
    JOIN FIDE_DISTRITOS_TB DI ON D.ID_Distrito = DI.ID_Distrito;


/* Vista Puestos y sus Salarios */
CREATE OR REPLACE VIEW FIDE_PUESTOS_SALARIOS_V AS
SELECT 
    P.ID_Puesto,
    P.Descripcion,
    P.Salario,
    ES.Descripcion AS ESTADO
FROM 
    FIDE_PUESTOS_TB P
    JOIN FIDE_ESTADOS_TB ES ON P.ID_Estado = ES.ID_Estado;


/* Vista Licencias Vencidas */
CREATE OR REPLACE VIEW FIDE_LICENCIAS_VENCIDAS_V AS
SELECT 
    E.ID_Empleado,
    E.Nombre,
    E.Apellido,
    L.Tipo AS Tipo_Licencia,
    LE.Fecha_Expedicion,
    LE.Fecha_Vencimiento
FROM 
    FIDE_EMPLEADOS_TB E
    JOIN FIDE_LICENCIAS_EMPLEADO_TB LE ON E.ID_Empleado = LE.ID_Empleado
    JOIN FIDE_LICENCIAS_TB L ON LE.ID_Licencia = L.ID_Licencia
WHERE 
    LE.Fecha_Vencimiento < SYSDATE;


-- TRIGGERS/AUDIT


CREATE OR REPLACE TRIGGER FIDE_AUDITORIA_VEHICULO_TB_INACTIVAR_TRG
AFTER DELETE ON FIDE_VEHICULOS_TB
FOR EACH ROW
BEGIN
    INSERT INTO FIDE_AUDITORIA_VEHICULO_TB (
        tipo_evento,
        usuario_bd,
        usuario_sistema,
        ip_maquina,
        nombre_maquina,
        datos_antes
    )
    VALUES (
        'INACTIVAR',
        USER,
        SYS_CONTEXT('USERENV', 'OS_USER'),
        SYS_CONTEXT('USERENV', 'IP_ADDRESS'),
        SYS_CONTEXT('USERENV', 'HOST'),
        'ID_VEHICULO: ' || :OLD.ID_VEHICULO || ', MARCA: ' || :OLD.MARCA || ', MODELO: ' || :OLD.MODELO || ', ANIO: ' || :OLD.ANIO || ', PLACA: ' || :OLD.PLACA);
END;


CREATE OR REPLACE TRIGGER FIDE_AUDITORIA_VEHICULO_TB_UPDATE_TRG
AFTER UPDATE ON FIDE_VEHICULOS_TB
FOR EACH ROW
BEGIN
    INSERT INTO FIDE_AUDITORIA_VEHICULO_TB (
        tipo_evento,
        usuario_bd,
        usuario_sistema,
        ip_maquina,
        nombre_maquina,
        datos_antes
    )
    VALUES (
        'UPDATE',
        USER,
        SYS_CONTEXT('USERENV', 'OS_USER'),
        SYS_CONTEXT('USERENV', 'IP_ADDRESS'),
        SYS_CONTEXT('USERENV', 'HOST'),
        'ID_VEHICULO: ' || :OLD.ID_VEHICULO || ', MARCA: ' || :OLD.MARCA || ', MODELO: ' || :OLD.MODELO || ', ANIO: ' || :OLD.ANIO || ', PLACA: ' || :OLD.PLACA);
END;


CREATE OR REPLACE TRIGGER FIDE_AUDITORIA_PEDIDO_TB_INSERT_TRG
AFTER INSERT ON FIDE_PEDIDOS_TB
FOR EACH ROW
DECLARE
    V_USUARIO_SO VARCHAR2(100);
    V_IP_MAQUINA VARCHAR2(45);
    V_NOMBRE_MAQUINA VARCHAR2(100);
BEGIN
    SELECT SYS_CONTEXT('USERENV', 'OS_USER') INTO V_USUARIO_SO FROM dual;
    SELECT SYS_CONTEXT('USERENV', 'IP_ADDRESS') INTO V_IP_MAQUINA FROM dual;
    SELECT SYS_CONTEXT('USERENV', 'HOST') INTO V_NOMBRE_MAQUINA FROM dual;
    INSERT INTO FIDE_AUDITORIA_PEDIDO_TB (tipo_evento,pedido_id, usuario_bd, fecha_hora, usuario_so, ip_maquina, nombre_maquina)
    VALUES ('insert',:NEW.id_pedido, USER, SYSDATE, V_USUARIO_SO, V_IP_MAQUINA, V_NOMBRE_MAQUINA);
END;


CREATE OR REPLACE TRIGGER FIDE_AUDITORIA_PEDIDO_TB_UPDATE_TRG
AFTER UPDATE ON FIDE_PEDIDOS_TB
FOR EACH ROW
DECLARE
    V_USUARIO_SO VARCHAR2(100);
    V_IP_MAQUINA VARCHAR2(45);
    V_NOMBRE_MAQUINA VARCHAR2(100);
BEGIN
    SELECT SYS_CONTEXT('USERENV', 'OS_USER') INTO V_USUARIO_SO FROM dual;
    SELECT SYS_CONTEXT('USERENV', 'IP_ADDRESS') INTO V_IP_MAQUINA FROM dual;
    SELECT SYS_CONTEXT('USERENV', 'HOST') INTO V_NOMBRE_MAQUINA FROM dual;

    INSERT INTO FIDE_AUDITORIA_PEDIDO_TB (tipo_evento, pedido_id, usuario_bd, fecha_hora, usuario_so, ip_maquina, nombre_maquina)
    VALUES ('UPDATE',:NEW.id_pedido, USER, SYSDATE, V_USUARIO_SO, V_IP_MAQUINA, V_NOMBRE_MAQUINA);
END;

--AUDITORIA TABLAS

AUDIT ALL BY test1 BY ACCESS;
AUDIT SELECT TABLE, UPDATE TABLE, INSERT TABLE, DELETE TABLE BY test1 BY ACCESS;
AUDIT EXECUTE PROCEDURE BY test1 BY ACCESS;
/
create audit policy auditoria actions all on FIDE_CLIENTES_TB;
/
audit policy auditoria;
/
select 'alter audit policy auditoria actions all on '||owner||'.'||table_name||';'
  from dba_tables
 where owner in ('TEST1');
 /
 --Para ver INSERTS, DELETES, TRUNCATE, SELECT
 SELECT username, extended_timestamp, owner, obj_name, action, action_name
FROM dba_audit_trail
WHERE owner = 'TEST1'
ORDER by timestamp;
/
--UNIFIED VIEW, logon y logoff
SELECT EVENT_TIMESTAMP, CURRENT_USER, DBUSERNAME, ACTION_NAME, OBJECT_NAME, SQL_TEXT FROM UNIFIED_AUDIT_TRAIL 
WHERE DBUSERNAME = 'TEST1';
 
-- PACKAGES
/
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_PUESTOS_PKG AS
    PROCEDURE FIDE_PUESTOS_VER_PUESTO_SP(P_ID_PUESTO IN NUMBER, P_DESCRIPCION OUT VARCHAR2, P_SALARIO OUT NUMBER);
    PROCEDURE FIDE_PUESTOS_VER_TODOS_SP(P_CURSOR OUT SYS_REFCURSOR);
    FUNCTION FIDE_PUESTOS_BUSCAR_POR_DESCRIPCION_FN(P_DESCRIPCION IN VARCHAR2) RETURN SYS_REFCURSOR;
END FIDE_PROYECTO_PUESTOS_PKG;
/

/
CREATE OR REPLACE PACKAGE BODY FIDE_PROYECTO_PUESTOS_PKG AS

    PROCEDURE FIDE_PUESTOS_VER_PUESTO_SP(
        P_ID_PUESTO IN NUMBER,
        P_DESCRIPCION OUT VARCHAR2,
        P_SALARIO OUT NUMBER
    ) AS
    BEGIN
        SELECT Descripcion, Salario
        INTO P_DESCRIPCION, P_SALARIO
        FROM FIDE_PUESTOS_TB
        WHERE ID_PUESTO = P_ID_PUESTO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            P_DESCRIPCION := NULL;
            P_SALARIO := NULL;
    END FIDE_PUESTOS_VER_PUESTO_SP;

    PROCEDURE FIDE_PUESTOS_VER_TODOS_SP(
        P_CURSOR OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN P_CURSOR FOR
        SELECT ID_PUESTO, Descripcion, Salario
        FROM FIDE_PUESTOS_TB;
    END FIDE_PUESTOS_VER_TODOS_SP;

    FUNCTION FIDE_PUESTOS_BUSCAR_POR_DESCRIPCION_FN(
        P_DESCRIPCION IN VARCHAR2
    ) RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_PUESTO, Descripcion, Salario
        FROM FIDE_PUESTOS_TB
        WHERE LOWER(Descripcion) LIKE '%' || LOWER(P_DESCRIPCION) || '%';
        RETURN V_CURSOR;
    END FIDE_PUESTOS_BUSCAR_POR_DESCRIPCION_FN;

END FIDE_PROYECTO_PUESTOS_PKG;
/

-- Paquete Clientes
/
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_CLIENTES_PKG AS
    FUNCTION FIDE_CLIENTES_TB_BUSCAR_CLIENTE_NOMBRE_FN(P_NOMBRE IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION FIDE_CLIENTES_TB_BUSCAR_CLIENTE_CORREO_FN(P_EMAIL IN VARCHAR2) RETURN SYS_REFCURSOR;
    PROCEDURE FIDE_CLIENTES_TB_INSERTAR_SP(P_NOMBRE IN VARCHAR2, P_APELLIDO IN VARCHAR2, P_TELEFONO IN VARCHAR2, P_EMAIL IN VARCHAR2, P_ID_ESTADO IN NUMBER);
    PROCEDURE FIDE_CLIENTES_TB_ACTUALIZAR_SP(P_ID_CLIENTE IN NUMBER, P_NOMBRE IN VARCHAR2, P_APELLIDO IN VARCHAR2, P_TELEFONO IN VARCHAR2, P_EMAIL IN VARCHAR2, P_ID_ESTADO IN NUMBER);
    PROCEDURE FIDE_CLIENTES_TB_INACTIVAR_SP(P_ID_CLIENTE IN NUMBER);
END FIDE_PROYECTO_CLIENTES_PKG;
/

/
CREATE OR REPLACE PACKAGE BODY FIDE_PROYECTO_CLIENTES_PKG AS
    FUNCTION FIDE_CLIENTES_TB_BUSCAR_CLIENTE_NOMBRE_FN(P_NOMBRE IN VARCHAR2)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Cliente, Nombre, Apellido, Telefono, Email
        FROM FIDE_CLIENTES_TB
        WHERE LOWER(Nombre) LIKE '%' || LOWER(P_NOMBRE) || '%';
        RETURN V_CURSOR;
    END FIDE_CLIENTES_TB_BUSCAR_CLIENTE_NOMBRE_FN;

    FUNCTION FIDE_CLIENTES_TB_BUSCAR_CLIENTE_CORREO_FN(P_EMAIL IN VARCHAR2)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Cliente, Nombre, Apellido, Telefono, Email
        FROM FIDE_CLIENTES_TB
        WHERE LOWER(Email) LIKE '%' || LOWER(P_EMAIL) || '%';
        RETURN V_CURSOR;
    END FIDE_CLIENTES_TB_BUSCAR_CLIENTE_CORREO_FN;

    PROCEDURE FIDE_CLIENTES_TB_INSERTAR_SP (
        P_NOMBRE IN VARCHAR2,
        P_APELLIDO  IN VARCHAR2,
        P_TELEFONO IN VARCHAR2,
        P_EMAIL IN VARCHAR2,
        P_ID_ESTADO IN NUMBER
    ) AS
    BEGIN
        INSERT INTO FIDE_CLIENTES_TB (Nombre, Apellido, Telefono, Email, Id_estado)
        VALUES (P_NOMBRE, P_APELLIDO, P_TELEFONO, P_EMAIL, P_ID_ESTADO);
    END FIDE_CLIENTES_TB_INSERTAR_SP;

    PROCEDURE FIDE_CLIENTES_TB_ACTUALIZAR_SP (
        P_ID_CLIENTE IN NUMBER,
        P_NOMBRE IN VARCHAR2,
        P_APELLIDO IN VARCHAR2,
        P_TELEFONO IN VARCHAR2,
        P_EMAIL IN VARCHAR2,
        P_ID_ESTADO IN NUMBER
    ) AS
    BEGIN
        UPDATE FIDE_CLIENTES_TB
        SET Nombre = P_NOMBRE,
            Apellido = P_APELLIDO,
            Telefono = P_TELEFONO,
            Email = P_EMAIL, 
            Id_estado = P_ID_ESTADO
        WHERE ID_Cliente = P_ID_CLIENTE;
    END FIDE_CLIENTES_TB_ACTUALIZAR_SP;

    PROCEDURE FIDE_CLIENTES_TB_INACTIVAR_SP (
        P_ID_CLIENTE IN NUMBER
    ) AS
    BEGIN
        UPDATE FIDE_CLIENTES_TB
        SET Id_estado = 8 
        WHERE ID_Cliente = P_ID_CLIENTE;
    END FIDE_CLIENTES_TB_INACTIVAR_SP;
END FIDE_PROYECTO_CLIENTES_PKG;
/


-- Paquete Direcciones
/
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_DIRECCIONES_PKG AS
    FUNCTION FIDE_DIRECCIONES_EMPLEADO_TB_BUSCAR_POR_ID_FN(P_ID_EMPLEADO IN NUMBER)
    RETURN SYS_REFCURSOR;
    FUNCTION FIDE_DIRECCIONES_PEDIDO_TB_BUSCAR_POR_PEDIDO_FN(P_ID_PEDIDO IN NUMBER)
    RETURN SYS_REFCURSOR;
    FUNCTION FIDE_DIRECCIONES_CLIENTE_TB_BUSCAR_POR_ID_FN(P_ID_CLIENTE IN NUMBER)
    RETURN SYS_REFCURSOR;
END FIDE_PROYECTO_DIRECCIONES_PKG;
/

/
CREATE OR REPLACE PACKAGE BODY FIDE_PROYECTO_DIRECCIONES_PKG AS
    FUNCTION FIDE_DIRECCIONES_EMPLEADO_TB_BUSCAR_POR_ID_FN(P_ID_EMPLEADO IN NUMBER)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Direccion, ID_Empleado, Detalles, ID_Distrito, Id_estado
        FROM FIDE_DIRECCIONES_EMPLEADO_TB
        WHERE ID_Empleado = P_ID_EMPLEADO;
        RETURN V_CURSOR;
    END FIDE_DIRECCIONES_EMPLEADO_TB_BUSCAR_POR_ID_FN;

    FUNCTION FIDE_DIRECCIONES_PEDIDO_TB_BUSCAR_POR_PEDIDO_FN(P_ID_PEDIDO IN NUMBER)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Direccion, ID_Pedido, Detalles, ID_Distrito, Id_estado
        FROM FIDE_DIRECCIONES_PEDIDO_TB
        WHERE ID_Pedido = P_ID_PEDIDO;
        RETURN V_CURSOR;
    END FIDE_DIRECCIONES_PEDIDO_TB_BUSCAR_POR_PEDIDO_FN;
    
    FUNCTION FIDE_DIRECCIONES_CLIENTE_TB_BUSCAR_POR_ID_FN(P_ID_CLIENTE IN NUMBER)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Direccion, ID_Cliente, Detalles, ID_Distrito, Id_estado
        FROM FIDE_DIRECCIONES_CLIENTE_TB
        WHERE ID_Cliente = P_ID_CLIENTE;
        RETURN V_CURSOR;
    END FIDE_DIRECCIONES_CLIENTE_TB_BUSCAR_POR_ID_FN;
END FIDE_PROYECTO_DIRECCIONES_PKG;
/


-- Paquete Pedidos 
/
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_PEDIDOS_PKG AS
    FUNCTION FIDE_PEDIDOS_TB_BUSCAR_POR_ID_FN(P_PEDIDO_ID IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION FIDE_PEDIDOS_TB_BUSCAR_POR_ESTADO_FN(P_PEDIDO_ID_ESTADO IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE FIDE_PEDIDOS_TB_INSERTAR_SP (P_ID_CLIENTE IN NUMBER, P_FECHA IN DATE, P_ID_ESTADO IN NUMBER);
    PROCEDURE FIDE_PEDIDOS_TB_VER_PEDIDO_SP (P_ID_PEDIDO IN NUMBER, P_CURSOR OUT SYS_REFCURSOR);
    PROCEDURE FIDE_PEDIDOS_TB_VER_ACTUALIZAR_SP (P_ID_PEDIDO IN NUMBER, P_ID_CLIENTE IN NUMBER, P_FECHA IN DATE, P_ID_ESTADO IN NUMBER);
    PROCEDURE FIDE_PEDIDOS_TB_INACTIVAR_SP (P_ID_PEDIDO IN NUMBER);
END FIDE_PROYECTO_PEDIDOS_PKG;
/

/
CREATE OR REPLACE PACKAGE BODY FIDE_PROYECTO_PEDIDOS_PKG AS

    FUNCTION FIDE_PEDIDOS_TB_BUSCAR_POR_ID_FN(P_PEDIDO_ID IN NUMBER)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Pedido, ID_Cliente, Fecha, ID_Estado
        FROM FIDE_PEDIDOS_TB
        WHERE ID_Pedido = P_PEDIDO_ID;
        RETURN V_CURSOR;
    END FIDE_PEDIDOS_TB_BUSCAR_POR_ID_FN;

    FUNCTION FIDE_PEDIDOS_TB_BUSCAR_POR_ESTADO_FN(P_PEDIDO_ID_ESTADO IN NUMBER)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Pedido, ID_Cliente, Fecha, ID_Estado
        FROM FIDE_PEDIDOS_TB
        WHERE ID_Estado = P_PEDIDO_ID_ESTADO;
        RETURN V_CURSOR;
    END FIDE_PEDIDOS_TB_BUSCAR_POR_ESTADO_FN;
    
    PROCEDURE FIDE_PEDIDOS_TB_INSERTAR_SP (
        P_ID_CLIENTE IN NUMBER,
        P_FECHA IN DATE,
        P_ID_ESTADO IN NUMBER
    ) AS
    BEGIN
        INSERT INTO FIDE_PEDIDOS_TB (ID_Cliente, Fecha, ID_Estado)
        VALUES (P_ID_CLIENTE, P_FECHA, P_ID_ESTADO);
    END FIDE_PEDIDOS_TB_INSERTAR_SP;

    PROCEDURE FIDE_PEDIDOS_TB_VER_PEDIDO_SP(
        P_ID_PEDIDO IN NUMBER,
        P_CURSOR OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN P_CURSOR FOR
        SELECT ID_Cliente, Fecha, ID_Estado
        FROM FIDE_PEDIDOS_TB
        WHERE ID_Pedido = P_ID_PEDIDO;
    END FIDE_PEDIDOS_TB_VER_PEDIDO_SP;

    PROCEDURE FIDE_PEDIDOS_TB_VER_ACTUALIZAR_SP(
        P_ID_PEDIDO IN NUMBER,
        P_ID_CLIENTE IN NUMBER,
        P_FECHA IN DATE,
        P_ID_ESTADO IN NUMBER
    ) AS
    BEGIN
        UPDATE FIDE_PEDIDOS_TB
        SET ID_Cliente = P_ID_CLIENTE,
            Fecha = P_FECHA,
            ID_Estado = P_ID_ESTADO
        WHERE ID_Pedido = P_ID_PEDIDO;
    END FIDE_PEDIDOS_TB_VER_ACTUALIZAR_SP;

    PROCEDURE FIDE_PEDIDOS_TB_INACTIVAR_SP (
        P_ID_PEDIDO IN NUMBER
    ) AS
    BEGIN
        UPDATE FIDE_PEDIDOS_TB
        SET Id_estado = 8
        WHERE ID_Pedido = P_ID_PEDIDO;
    END FIDE_PEDIDOS_TB_INACTIVAR_SP;
END FIDE_PROYECTO_PEDIDOS_PKG;
/


-- Paquete empleados 
/
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_EMPLEADOS_PKG AS
    FUNCTION FIDE_EMPLEADOS_TB_BUSCAR_EMPLEADO_POR_NOMBRE_FN(P_NOMBRE IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION FIDE_EMPLEADOS_TB_BUSCAR_EMPLEADO_POR_ID_FN(P_EMPLEADO_ID IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE FIDE_EMPLEADOS_TB_INSERTAR_SP (P_NOMBRE IN VARCHAR2, P_APELLIDO IN VARCHAR2, P_FECHA_NACIMIENTO IN DATE, P_FECHA_CONTRATACION IN DATE);
    PROCEDURE FIDE_EMPLEADOS_TB_ACTUALIZAR_SP (P_ID_EMPLEADO IN NUMBER, P_NOMBRE IN VARCHAR2, P_APELLIDO IN VARCHAR2, P_FECHA_NACIMIENTO IN DATE, P_FECHA_CONTRATACION IN DATE, P_ID_ESTADO IN NUMBER);
    PROCEDURE FIDE_EMPLEADOS_TB_INACTIVAR_SP (P_ID_EMPLEADO IN NUMBER);
END FIDE_PROYECTO_EMPLEADOS_PKG;
/

/
CREATE OR REPLACE PACKAGE BODY FIDE_PROYECTO_EMPLEADOS_PKG AS
    FUNCTION FIDE_EMPLEADOS_TB_BUSCAR_EMPLEADO_POR_NOMBRE_FN(P_NOMBRE IN VARCHAR2)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Empleado, Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion
        FROM FIDE_EMPLEADOS_TB
        WHERE LOWER(Nombre) LIKE '%' || LOWER(P_NOMBRE) || '%';
        RETURN V_CURSOR;
    END FIDE_EMPLEADOS_TB_BUSCAR_EMPLEADO_POR_NOMBRE_FN;

    FUNCTION FIDE_EMPLEADOS_TB_BUSCAR_EMPLEADO_POR_ID_FN(P_EMPLEADO_ID IN NUMBER)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Empleado, Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion
        FROM FIDE_EMPLEADOS_TB
        WHERE ID_Empleado = P_EMPLEADO_ID;
        RETURN V_CURSOR;
    END FIDE_EMPLEADOS_TB_BUSCAR_EMPLEADO_POR_ID_FN;

    PROCEDURE FIDE_EMPLEADOS_TB_INSERTAR_SP(P_NOMBRE IN VARCHAR2, P_APELLIDO IN VARCHAR2, P_FECHA_NACIMIENTO IN DATE, P_FECHA_CONTRATACION IN DATE) AS
    BEGIN
        INSERT INTO FIDE_EMPLEADOS_TB (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion)
        VALUES (P_NOMBRE, P_APELLIDO, P_FECHA_NACIMIENTO, P_FECHA_CONTRATACION);
    END FIDE_EMPLEADOS_TB_INSERTAR_SP;

    PROCEDURE FIDE_EMPLEADOS_TB_ACTUALIZAR_SP (
        P_ID_EMPLEADO IN NUMBER,
        P_NOMBRE IN VARCHAR2,
        P_APELLIDO IN VARCHAR2,
        P_FECHA_NACIMIENTO IN DATE,
        P_FECHA_CONTRATACION IN DATE,
        P_ID_ESTADO IN NUMBER
    ) AS
    BEGIN
        UPDATE FIDE_EMPLEADOS_TB
        SET Nombre = P_NOMBRE,
            Apellido = P_APELLIDO,
            Fecha_Nacimiento = P_FECHA_NACIMIENTO,
            Fecha_Contratacion = P_FECHA_CONTRATACION,
            ID_Estado = P_ID_ESTADO
        WHERE ID_Empleado = P_ID_EMPLEADO;
    END FIDE_EMPLEADOS_TB_ACTUALIZAR_SP;

    PROCEDURE FIDE_EMPLEADOS_TB_INACTIVAR_SP (
        P_ID_EMPLEADO IN NUMBER
    ) AS
    BEGIN
        UPDATE FIDE_EMPLEADOS_TB
        SET ID_Estado = 8
        WHERE ID_Empleado = P_ID_EMPLEADO;
    END FIDE_EMPLEADOS_TB_INACTIVAR_SP;
    
END FIDE_PROYECTO_EMPLEADOS_PKG;
/


-- Paquete Vehiculos

/
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_VEHICULOS_PKG AS
    FUNCTION FIDE_VEHICULOS_TB_BUSCAR_VEHICULO_PLACA_FN(P_PLACA IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION FIDE_VEHICULOS_TB_BUSCAR_VEHICULO_MARCA_FN(P_MARCA IN VARCHAR2) RETURN SYS_REFCURSOR;
    PROCEDURE FIDE_VEHICULOS_TB_INSERTAR_SP (P_MARCA IN VARCHAR2, P_MODELO IN VARCHAR2, P_ANIO IN NUMBER, P_PLACA IN VARCHAR2, P_ID_ESTADO IN NUMBER);
    PROCEDURE FIDE_VEHICULOS_TB_ACTUALIZAR_SP (P_ID_VEHICULO IN NUMBER, P_MARCA IN VARCHAR2, P_MODELO IN VARCHAR2, P_ANIO IN NUMBER, P_PLACA IN VARCHAR2, P_ID_ESTADO IN NUMBER);
    PROCEDURE FIDE_VEHICULOS_TB_INACTIVAR_SP (P_ID_VEHICULO IN NUMBER);
END FIDE_PROYECTO_VEHICULOS_PKG;
/

/
CREATE OR REPLACE PACKAGE BODY FIDE_PROYECTO_VEHICULOS_PKG AS
    FUNCTION FIDE_VEHICULOS_TB_BUSCAR_VEHICULO_PLACA_FN(P_PLACA IN VARCHAR2)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Vehiculo, Marca, Modelo, Anio, Placa, Id_estado
        FROM FIDE_VEHICULOS_TB
        WHERE LOWER(Placa) LIKE '%' || LOWER(P_PLACA) || '%';
        RETURN V_CURSOR;
    END FIDE_VEHICULOS_TB_BUSCAR_VEHICULO_PLACA_FN;

    FUNCTION FIDE_VEHICULOS_TB_BUSCAR_VEHICULO_MARCA_FN(P_MARCA IN VARCHAR2)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Vehiculo, Marca, Modelo, Anio, Placa, Id_estado
        FROM FIDE_VEHICULOS_TB
        WHERE LOWER(Marca) LIKE '%' || LOWER(P_MARCA) || '%';
        RETURN V_CURSOR;
    END FIDE_VEHICULOS_TB_BUSCAR_VEHICULO_MARCA_FN;
    
    PROCEDURE FIDE_VEHICULOS_TB_INSERTAR_SP (
        P_MARCA IN VARCHAR2,
        P_MODELO IN VARCHAR2,
        P_ANIO IN NUMBER,
        P_PLACA IN VARCHAR2,
        P_ID_ESTADO IN NUMBER
    ) AS
    BEGIN
        INSERT INTO FIDE_VEHICULOS_TB (Marca, Modelo, Anio, Placa, Id_estado)
        VALUES (P_MARCA, P_MODELO, P_ANIO, P_PLACA, P_ID_ESTADO);
    END FIDE_VEHICULOS_TB_INSERTAR_SP;

    PROCEDURE FIDE_VEHICULOS_TB_ACTUALIZAR_SP (
        P_ID_VEHICULO IN NUMBER,
        P_MARCA IN VARCHAR2,
        P_MODELO IN VARCHAR2,
        P_ANIO IN NUMBER,
        P_PLACA IN VARCHAR2, 
        P_ID_ESTADO IN NUMBER
    ) AS
    BEGIN
        UPDATE FIDE_VEHICULOS_TB
        SET Marca = P_MARCA,
            Modelo = P_MODELO,
            Anio = P_ANIO,
            Placa = P_PLACA,
            Id_estado = P_ID_ESTADO
        WHERE ID_Vehiculo = P_ID_VEHICULO;
    END FIDE_VEHICULOS_TB_ACTUALIZAR_SP;

    PROCEDURE FIDE_VEHICULOS_TB_INACTIVAR_SP (
        P_ID_VEHICULO IN NUMBER
    ) AS
    BEGIN
        UPDATE FIDE_VEHICULOS_TB
        SET Id_estado = 8
        WHERE ID_Vehiculo = P_ID_VEHICULO;
    END FIDE_VEHICULOS_TB_INACTIVAR_SP;
END FIDE_PROYECTO_VEHICULOS_PKG;
/


--Sexto paquete Facturas
/
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_FACTURAS_PKG AS
    FUNCTION FIDE_FACTURAS_TB_BUSCAR_POR_ID_FN(P_FACTURA_ID IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION FIDE_FACTURAS_TB_BUSCAR_POR_TOTAL_FN(P_FACTURA_TOTAL IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE FIDE_FACTURAS_TB_INSERTAR_SP (P_ID_PEDIDO IN NUMBER, P_FECHA IN DATE, P_TOTAL IN NUMBER, P_ID_ESTADO IN NUMBER);
    PROCEDURE FIDE_FACTURAS_TB_VER_ACTUALIZAR_SP (P_ID_FACTURA IN NUMBER, P_FECHA IN DATE, P_TOTAL IN NUMBER, P_ID_ESTADO IN NUMBER);
    PROCEDURE FIDE_FACTURAS_TB_VER_INACTIVAR_SP (P_ID_FACTURA IN NUMBER);
END FIDE_PROYECTO_FACTURAS_PKG;
/

/
CREATE OR REPLACE PACKAGE BODY FIDE_PROYECTO_FACTURAS_PKG AS
    
    FUNCTION FIDE_FACTURAS_TB_BUSCAR_POR_ID_FN(P_FACTURA_ID IN NUMBER)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
        FROM FIDE_FACTURAS_TB
        WHERE ID_Factura = P_FACTURA_ID;
        RETURN V_CURSOR;
    END FIDE_FACTURAS_TB_BUSCAR_POR_ID_FN;
    
    FUNCTION FIDE_FACTURAS_TB_BUSCAR_POR_TOTAL_FN(P_FACTURA_TOTAL IN NUMBER)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
        FROM FIDE_FACTURAS_TB
        WHERE Total = P_FACTURA_TOTAL;
        RETURN V_CURSOR;
    END FIDE_FACTURAS_TB_BUSCAR_POR_TOTAL_FN;
    
    PROCEDURE FIDE_FACTURAS_TB_INSERTAR_SP (
        P_ID_PEDIDO IN NUMBER,
        P_FECHA IN DATE,
        P_TOTAL IN NUMBER,
        P_ID_ESTADO IN NUMBER
    ) AS
    BEGIN
        INSERT INTO FIDE_FACTURAS_TB (ID_Pedido, Fecha, Total, ID_Estado)
        VALUES (P_ID_PEDIDO, P_FECHA, P_TOTAL, P_ID_ESTADO);
    END FIDE_FACTURAS_TB_INSERTAR_SP;
    
    PROCEDURE FIDE_FACTURAS_TB_VER_ACTUALIZAR_SP (
        P_ID_FACTURA IN NUMBER,
        P_FECHA IN DATE,
        P_TOTAL IN NUMBER,
        P_ID_ESTADO IN NUMBER
    ) AS
    BEGIN
        UPDATE FIDE_FACTURAS_TB
        SET Fecha = P_FECHA,
            Total = P_TOTAL,
            ID_Estado = P_ID_ESTADO
        WHERE ID_Factura = P_ID_FACTURA;
    END FIDE_FACTURAS_TB_VER_ACTUALIZAR_SP;

    PROCEDURE FIDE_FACTURAS_TB_VER_INACTIVAR_SP (
        P_ID_FACTURA IN NUMBER
    ) AS
    BEGIN
        UPDATE FIDE_FACTURAS_TB
        SET ID_Estado = 0
        WHERE ID_Factura = P_ID_FACTURA;
    END FIDE_FACTURAS_TB_VER_INACTIVAR_SP;
    
END FIDE_PROYECTO_FACTURAS_PKG;
/

-- Paquete Licencias 
/
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_LICENCIAS_PKG AS
    FUNCTION FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_EMPLEADO_FN(P_ID_EMPLEADO IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_ID_FN(P_ID_LICENCIA IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_FECHA_FN(P_FECHA_EXP_INICIO IN DATE, P_FECHA_EXP_FIN IN DATE)RETURN SYS_REFCURSOR;
END FIDE_PROYECTO_LICENCIAS_PKG;
/

/
CREATE OR REPLACE PACKAGE BODY FIDE_PROYECTO_LICENCIAS_PKG AS

    FUNCTION FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_EMPLEADO_FN(P_ID_EMPLEADO IN NUMBER)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_Licencia_Empleado, ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento
        FROM FIDE_LICENCIAS_EMPLEADO_TB
        WHERE ID_Empleado = P_ID_EMPLEADO;
        RETURN V_CURSOR;
    END FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_EMPLEADO_FN;

    FUNCTION FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_ID_FN(P_ID_LICENCIA IN NUMBER)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_EMPLEADO, ID_LICENCIA, FECHA_EXPEDICION, FECHA_VENCIMIENTO
        FROM FIDE_LICENCIAS_EMPLEADO_TB
        WHERE ID_LICENCIA = P_ID_LICENCIA;
        RETURN V_CURSOR;
    END FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_ID_FN;

    FUNCTION FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_FECHA_FN(P_FECHA_EXP_INICIO IN DATE, P_FECHA_EXP_FIN IN DATE)
    RETURN SYS_REFCURSOR AS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_EMPLEADO, ID_LICENCIA, FECHA_EXPEDICION, FECHA_VENCIMIENTO
        FROM FIDE_LICENCIAS_EMPLEADO_TB
        WHERE FECHA_EXPEDICION BETWEEN P_FECHA_EXP_INICIO AND P_FECHA_EXP_FIN;
        RETURN V_CURSOR;
    END FIDE_LICENCIAS_EMPLEADO_TB_BUSCAR_LICENCIA_POR_FECHA_FN;

END FIDE_PROYECTO_LICENCIAS_PKG;
/

-- Paquete estados
/
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_ESTADOS_PKG AS
    PROCEDURE FIDE_ESTADOS_TB_INSERTAR_SP(P_ID_ESTADO IN NUMBER, P_DESCRIPCION IN VARCHAR2);
    PROCEDURE FIDE_ESTADOS_TB_ACTUALIZAR_SP(P_ID_ESTADO IN NUMBER, P_DESCRIPCION IN VARCHAR2);
    PROCEDURE FIDE_ESTADOS_TB_INACTIVAR_SP(P_ID_ESTADO IN NUMBER);
    FUNCTION FIDE_ESTADOS_TB_OBTENER_FN(P_ID_ESTADO IN NUMBER) RETURN SYS_REFCURSOR;
END FIDE_PROYECTO_ESTADOS_PKG;
/

/
CREATE OR REPLACE PACKAGE BODY FIDE_PROYECTO_ESTADOS_PKG AS

    PROCEDURE FIDE_ESTADOS_TB_INSERTAR_SP(P_ID_ESTADO IN NUMBER, P_DESCRIPCION IN VARCHAR2) IS
    BEGIN
        INSERT INTO FIDE_ESTADOS_TB (ID_ESTADO, DESCRIPCION)
        VALUES (P_ID_ESTADO, P_DESCRIPCION);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error al insertar el estado: ' || SQLERRM);
    END FIDE_ESTADOS_TB_INSERTAR_SP;

    PROCEDURE FIDE_ESTADOS_TB_ACTUALIZAR_SP(P_ID_ESTADO IN NUMBER, P_DESCRIPCION IN VARCHAR2) IS
    BEGIN
        UPDATE FIDE_ESTADOS_TB
        SET DESCRIPCION = P_DESCRIPCION
        WHERE ID_ESTADO = P_ID_ESTADO;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error al actualizar el estado: ' || SQLERRM);
    END FIDE_ESTADOS_TB_ACTUALIZAR_SP;

    PROCEDURE FIDE_ESTADOS_TB_INACTIVAR_SP(P_ID_ESTADO IN NUMBER) IS
    BEGIN
        UPDATE FIDE_ESTADOS_TB
        SET Id_estado = 8
        WHERE ID_ESTADO = P_ID_ESTADO;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003, 'Error al eliminar el estado: ' || SQLERRM);
    END FIDE_ESTADOS_TB_INACTIVAR_SP;

    FUNCTION FIDE_ESTADOS_TB_OBTENER_FN(P_ID_ESTADO IN NUMBER) RETURN SYS_REFCURSOR IS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT ID_ESTADO, DESCRIPCION
        FROM FIDE_ESTADOS_TB
        WHERE ID_ESTADO = P_ID_ESTADO;
        RETURN V_CURSOR;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20004, 'Error al obtener el estado: ' || SQLERRM);
    END FIDE_ESTADOS_TB_OBTENER_FN;

END FIDE_PROYECTO_ESTADOS_PKG;
/

-- Paquete Tipos Carga
/
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_TIPOS_CARGA_PKG AS
    PROCEDURE FIDE_TIPOS_CARGA_TB_INSERTAR_SP(P_ID_TIPO NUMBER, P_DESCRIPCION VARCHAR2);
    PROCEDURE FIDE_TIPOS_CARGA_TB_ACTUALIZAR_SP(P_ID_TIPO NUMBER, P_DESCRIPCION VARCHAR2);
    PROCEDURE FIDE_TIPOS_CARGA_TB_INACTIVAR_SP(P_ID_TIPO NUMBER);
    FUNCTION FIDE_TIPOS_CARGA_TB_OBTENER_TIPO_CARGA_SP(P_ID_TIPO NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION FIDE_TIPOS_CARGA_TB_OBTENER_TIPOS_CARGA_SP RETURN SYS_REFCURSOR;
END FIDE_PROYECTO_TIPOS_CARGA_PKG;
/

/
CREATE OR REPLACE PACKAGE BODY FIDE_PROYECTO_TIPOS_CARGA_PKG AS

    PROCEDURE FIDE_TIPOS_CARGA_TB_INSERTAR_SP(P_ID_TIPO NUMBER, P_DESCRIPCION VARCHAR2) IS
    BEGIN
        INSERT INTO FIDE_TIPOS_CARGA_TB (Id_tipo_carga, descripcion)
        VALUES (P_ID_TIPO, P_DESCRIPCION);
    END FIDE_TIPOS_CARGA_TB_INSERTAR_SP;

    PROCEDURE FIDE_TIPOS_CARGA_TB_ACTUALIZAR_SP(P_ID_TIPO NUMBER, P_DESCRIPCION VARCHAR2) IS
    BEGIN
        UPDATE FIDE_TIPOS_CARGA_TB
        SET descripcion = P_DESCRIPCION
        WHERE Id_tipo_carga = P_ID_TIPO;
    END FIDE_TIPOS_CARGA_TB_ACTUALIZAR_SP;

    PROCEDURE FIDE_TIPOS_CARGA_TB_INACTIVAR_SP(P_ID_TIPO NUMBER) IS
    BEGIN
        UPDATE FIDE_TIPOS_CARGA_TB
        SET Id_estado = 8
        WHERE Id_tipo_carga = P_ID_TIPO;
    END FIDE_TIPOS_CARGA_TB_INACTIVAR_SP;

    FUNCTION FIDE_TIPOS_CARGA_TB_OBTENER_TIPO_CARGA_SP(P_ID_TIPO NUMBER) RETURN SYS_REFCURSOR IS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT Id_tipo_carga, descripcion
        FROM FIDE_TIPOS_CARGA_TB
        WHERE Id_tipo_carga = P_ID_TIPO;
        RETURN V_CURSOR;
    END FIDE_TIPOS_CARGA_TB_OBTENER_TIPO_CARGA_SP;

    FUNCTION FIDE_TIPOS_CARGA_TB_OBTENER_TIPOS_CARGA_SP RETURN SYS_REFCURSOR IS
        V_CURSOR SYS_REFCURSOR;
    BEGIN
        OPEN V_CURSOR FOR
        SELECT Id_tipo_carga, descripcion
        FROM FIDE_TIPOS_CARGA_TB;
        RETURN V_CURSOR;
    END FIDE_TIPOS_CARGA_TB_OBTENER_TIPOS_CARGA_SP;

END FIDE_PROYECTO_TIPOS_CARGA_PKG;
/

-- Paquete Puestos
/
CREATE OR REPLACE PACKAGE FIDE_PROYECTO_PUESTOS_PKG AS
    PROCEDURE FIDE_PUESTOS_TB_VER_PUESTO_SP (P_ID_PUESTO IN VARCHAR2, P_DESCRIPCION OUT VARCHAR2, P_SALARIO OUT NUMBER, P_ID_ESTADO OUT NUMBER);
    PROCEDURE FIDE_PUESTOS_TB_VER_PUESTOS_SP (P_CURSOR OUT SYS_REFCURSOR);
    FUNCTION FIDE_PUESTOS_TB_VER_PUESTOS_DESCRIPCION_FN(P_DESCRIPCION IN VARCHAR2) RETURN SYS_REFCURSOR;
END FIDE_PROYECTO_PUESTOS_PKG;
/


----------Creacion de tabla para encriptacion de contrase�as de usuarios--------
CREATE TABLE FIDE_CLAVES_TB(
ID_CLAVE NUMBER PRIMARY KEY,
CLAVE RAW(32)
);

--Insert de clave a nuestra tabla
INSERT INTO FIDE_CLAVES_TB(ID_CLAVE, CLAVE)
VALUES(1, UTL_RAW.CAST_TO_RAW('01234567890123456789012345678901'));
COMMIT;


--Correr comando antes de ejecutar el Procedure
GRANT EXECUTE ON DBMS_CRYPTO TO TEST1;

-- Procedimiento para encriptar contrase�as
CREATE OR REPLACE PROCEDURE FIDE_USUARIOS_ENCRIPTAR_CLAVE_SP(
    P_ID_USUARIO NUMBER,
    P_USUARIO VARCHAR2,
    P_CONTRASENA VARCHAR2,
    P_ID_ROL NUMBER,
    P_ID_ESTADO NUMBER
) AS
    L_KEY RAW(32);
    L_ENCRYPTED_PASSWORD RAW(2000);
BEGIN
    SELECT CLAVE INTO L_KEY
    FROM FIDE_CLAVES_TB
    WHERE ID_CLAVE = 1;
    
--encriptacion
    L_ENCRYPTED_PASSWORD := DBMS_CRYPTO.ENCRYPT(
        SRC => UTL_RAW.CAST_TO_RAW(P_CONTRASENA),
        TYP => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        KEY => L_KEY
    );
    
--Insercion de datos en la tabla
    INSERT INTO FIDE_USUARIOS_TB (ID_USUARIO, USUARIO, CONTRASENA, ID_ROL, ID_ESTADO)
    VALUES (P_ID_USUARIO, P_USUARIO, L_ENCRYPTED_PASSWORD, P_ID_ROL, P_ID_ESTADO);
    
    COMMIT;
END FIDE_USUARIOS_ENCRIPTAR_CLAVE_SP;


--TEST
BEGIN
    FIDE_USUARIOS_ENCRIPTAR_CLAVE_SP(
        P_ID_USUARIO => 4,
        P_USUARIO => 'Marcos',
        P_CONTRASENA => '123',
        P_ID_ROL => 1,
        P_ID_ESTADO => 7
    );
END;

--Procedimiento para validar usuario
CREATE OR REPLACE PROCEDURE FIDE_Usuarios_TB_VALIDAR_USUARIO_SP (
    P_USUARIO IN VARCHAR2,
    P_USUARIO_RETORNO OUT VARCHAR2,
    P_CONTRASENA IN VARCHAR2,
    P_ROL OUT VARCHAR2
) AS
BEGIN
    BEGIN
        SELECT U.USUARIO, R.DESCRIPCION
        INTO P_USUARIO_RETORNO, P_ROL
        FROM FIDE_USUARIOS_TB U
        INNER JOIN FIDE_ROLES_TB R ON R.ID_ROL = U.ID_ROL
        WHERE U.USUARIO = P_USUARIO AND U.CONTRASENA = P_CONTRASENA;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            P_USUARIO_RETORNO := NULL;
            P_ROL := NULL;
        WHEN TOO_MANY_ROWS THEN
            P_USUARIO_RETORNO := NULL;
            P_ROL := NULL;
        WHEN OTHERS THEN
            P_USUARIO_RETORNO := NULL;
            P_ROL := NULL;
            RAISE;
    END;
END FIDE_Usuarios_TB_VALIDAR_USUARIO_SP;



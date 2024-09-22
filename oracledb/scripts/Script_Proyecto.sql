-- Script para crear las tablas de la base de datos

CREATE TABLE Empleados (
    ID_Empleado NUMBER PRIMARY KEY,
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    Fecha_Nacimiento DATE,
    Fecha_Contratacion DATE
);


CREATE TABLE Licencias_Empleado (
    ID_Empleado NUMBER,
    ID_Licencia NUMBER,
    Fecha_Expedicion DATE,
    Fecha_Vencimiento DATE,
    PRIMARY KEY (ID_Empleado, ID_Licencia),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Licencia) REFERENCES Licencias(ID_Licencia)
);


CREATE TABLE Licencias (
    ID_Licencia NUMBER PRIMARY KEY,
    Tipo VARCHAR2(50)
);


CREATE TABLE Puestos_Empleado (
    ID_Empleado NUMBER,
    ID_Puesto NUMBER,
    Salario NUMBER,
    PRIMARY KEY (ID_Empleado, ID_Puesto),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Puesto) REFERENCES Puestos(ID_Puesto)
);


CREATE TABLE Puestos (
    ID_Puesto NUMBER PRIMARY KEY,
    Salario NUMBER,
    Descripcion VARCHAR2(100)
);


CREATE TABLE Direcciones_Empleado (
    ID_Direccion NUMBER PRIMARY KEY,
    ID_Empleado NUMBER,
    ID_Provincia NUMBER,
    ID_Canton NUMBER,
    ID_Distrito NUMBER,
    Detalles VARCHAR2(100),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Provincia) REFERENCES Provincias(ID_Provincia),
    FOREIGN KEY (ID_Canton) REFERENCES Cantones(ID_Canton),
    FOREIGN KEY (ID_Distrito) REFERENCES Distritos(ID_Distrito)
);


CREATE TABLE Direcciones_Pedido (
    ID_Direccion NUMBER PRIMARY KEY,
    ID_Pedido NUMBER,
    ID_Provincia NUMBER,
    ID_Canton NUMBER,
    ID_Distrito NUMBER,
    Detalles VARCHAR2(100),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido),
    FOREIGN KEY (ID_Provincia) REFERENCES Provincias(ID_Provincia),
    FOREIGN KEY (ID_Canton) REFERENCES Cantones(ID_Canton),
    FOREIGN KEY (ID_Distrito) REFERENCES Distritos(ID_Distrito)
);


CREATE TABLE Provincias (
    ID_Provincia NUMBER PRIMARY KEY,
    Nombre VARCHAR2(50)
);


CREATE TABLE Cantones (
    ID_Canton NUMBER PRIMARY KEY,
    ID_Provincia NUMBER,
    Nombre VARCHAR2(50),
    FOREIGN KEY (ID_Provincia) REFERENCES Provincias(ID_Provincia)
);


CREATE TABLE Distritos (
    ID_Distrito NUMBER PRIMARY KEY,
    ID_Provincia NUMBER,
    ID_Canton NUMBER,
    Nombre VARCHAR2(50),
    FOREIGN KEY (ID_Provincia) REFERENCES Provincias(ID_Provincia),
    FOREIGN KEY (ID_Canton) REFERENCES Cantones(ID_Canton)
);


CREATE TABLE Clientes (
    ID_Cliente NUMBER PRIMARY KEY,
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    Telefono VARCHAR2(15),
    Email VARCHAR2(100)
);


CREATE TABLE Direcciones_Cliente (
    ID_Direccion NUMBER PRIMARY KEY,
    ID_Provincia NUMBER,
    ID_Canton NUMBER,
    ID_Distrito NUMBER,
    Detalles VARCHAR2(100),
    FOREIGN KEY (ID_Provincia) REFERENCES Provincias(ID_Provincia),
    FOREIGN KEY (ID_Canton) REFERENCES Cantones(ID_Canton),
    FOREIGN KEY (ID_Distrito) REFERENCES Distritos(ID_Distrito)
);

CREATE TABLE Pedidos (
    ID_Pedido NUMBER PRIMARY KEY,
    ID_Cliente NUMBER,
    Fecha DATE,
    Monto NUMBER,
    ID_Estado NUMBER,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Estado) REFERENCES Estados(ID_Estado)
);


CREATE TABLE Carga_Tipos (
    ID_Tipo NUMBER PRIMARY KEY,
    Descripcion VARCHAR2(100)
);


CREATE TABLE Estados (
    ID_Estado NUMBER PRIMARY KEY,
    Descripcion VARCHAR2(100)
);

CREATE TABLE Facturaciones (
    ID_Factura NUMBER PRIMARY KEY,
    ID_Pedido NUMBER,
    Fecha DATE,
    Monto NUMBER,
    ID_Estado NUMBER,
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido),
    FOREIGN KEY (ID_Estado) REFERENCES Estados(ID_Estado)
);


CREATE TABLE Vehiculos (
    ID_Vehiculo NUMBER PRIMARY KEY,
    Marca VARCHAR2(50),
    Modelo VARCHAR2(50),
    Anio NUMBER,
    Placa VARCHAR2(10)
);

-- Script para crear los SPs de la base de datos

/* SP de objeto Empleado */
CREATE OR REPLACE PROCEDURE insertar_empleado (
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_fecha_nacimiento IN DATE,
    p_fecha_contratacion IN DATE
) AS
BEGIN
    INSERT INTO Empleados (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion)
    VALUES (p_nombre, p_apellido, p_fecha_nacimiento, p_fecha_contratacion);
END insertar_empleado;


CREATE OR REPLACE PROCEDURE ver_empleado (
    p_id_empleado IN NUMBER,
    p_nombre OUT VARCHAR2,
    p_apellido OUT VARCHAR2,
    p_fecha_nacimiento OUT DATE,
    p_fecha_contratacion OUT DATE
) AS
BEGIN
    SELECT Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion
    INTO p_nombre, p_apellido, p_fecha_nacimiento, p_fecha_contratacion
    FROM Empleados
    WHERE ID_Empleado = p_id_empleado;
END ver_empleado;


CREATE OR REPLACE PROCEDURE actualizar_empleado (
    p_id_empleado IN NUMBER,
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_fecha_nacimiento IN DATE,
    p_fecha_contratacion IN DATE
) AS
BEGIN
    UPDATE Empleados
    SET Nombre = p_nombre,
        Apellido = p_apellido,
        Fecha_Nacimiento = p_fecha_nacimiento,
        Fecha_Contratacion = p_fecha_contratacion
    WHERE ID_Empleado = p_id_empleado;
END actualizar_empleado;

CREATE OR REPLACE PROCEDURE eliminar_empleado (
    p_id_empleado IN NUMBER
) AS
BEGIN
    DELETE FROM Empleados
    WHERE ID_Empleado = p_id_empleado;
END eliminar_empleado;

/* SP de objeto Vehiculo */
CREATE OR REPLACE PROCEDURE insertar_vehiculo (
    p_marca IN VARCHAR2,
    p_modelo IN VARCHAR2,
    p_anio IN NUMBER,
    p_placa IN VARCHAR2
) AS
BEGIN
    INSERT INTO Vehiculos (Marca, Modelo, Anio, Placa)
    VALUES (p_marca, p_modelo, p_anio, p_placa);
END insertar_vehiculo;


CREATE OR REPLACE PROCEDURE ver_vehiculo (
    p_id_vehiculo IN NUMBER,
    p_marca OUT VARCHAR2,
    p_modelo OUT VARCHAR2,
    p_anio OUT NUMBER,
    p_placa OUT VARCHAR2
) AS
BEGIN
    SELECT Marca, Modelo, Anio, Placa
    INTO p_marca, p_modelo, p_anio, p_placa
    FROM Vehiculos
    WHERE ID_Vehiculo = p_id_vehiculo;
END leer_vehiculo;


CREATE OR REPLACE PROCEDURE actualizar_vehiculo (
    p_id_vehiculo IN NUMBER,
    p_marca IN VARCHAR2,
    p_modelo IN VARCHAR2,
    p_anio IN NUMBER,
    p_placa IN VARCHAR2
) AS
BEGIN
    UPDATE Vehiculos
    SET Marca = p_marca,
        Modelo = p_modelo,
        Anio = p_anio,
        Placa = p_placa
    WHERE ID_Vehiculo = p_id_vehiculo;
END actualizar_vehiculo;


CREATE OR REPLACE PROCEDURE eliminar_vehiculo (
    p_id_vehiculo IN NUMBER
) AS
BEGIN
    DELETE FROM Vehiculos
    WHERE ID_Vehiculo = p_id_vehiculo;
END eliminar_vehiculo;


/* SP de objeto Pedido */
CREATE OR REPLACE PROCEDURE insertar_pedido (
    p_id_cliente IN NUMBER,
    p_fecha IN DATE,
    p_monto IN NUMBER,
    p_id_estado IN NUMBER
) AS
BEGIN
    INSERT INTO Pedidos (ID_Cliente, Fecha, Monto, ID_Estado)
    VALUES (p_id_cliente, p_fecha, p_monto, p_id_estado);
END insertar_pedido;


CREATE OR REPLACE PROCEDURE ver_pedido (
    p_id_pedido IN NUMBER,
    p_id_cliente OUT NUMBER,
    p_fecha OUT DATE,
    p_monto OUT NUMBER,
    p_id_estado OUT NUMBER
) AS
BEGIN
    SELECT ID_Cliente, Fecha, Monto, ID_Estado
    INTO p_id_cliente, p_fecha, p_monto, p_id_estado
    FROM Pedidos
    WHERE ID_Pedido = p_id_pedido;
END leer_pedido;


CREATE OR REPLACE PROCEDURE actualizar_pedido (
    p_id_pedido IN NUMBER,
    p_id_cliente IN NUMBER,
    p_fecha IN DATE,
    p_monto IN NUMBER,
    p_id_estado IN NUMBER
) AS
BEGIN
    UPDATE Pedidos
    SET ID_Cliente = p_id_cliente,
        Fecha = p_fecha,
        Monto = p_monto,
        ID_Estado = p_id_estado
    WHERE ID_Pedido = p_id_pedido;
END actualizar_pedido;


CREATE OR REPLACE PROCEDURE eliminar_pedido (
    p_id_pedido IN NUMBER
) AS
BEGIN
    DELETE FROM Pedidos
    WHERE ID_Pedido = p_id_pedido;
END eliminar_pedido;


-- Script para crear las vistas de la base de datos

/* Vista Informacion Empleado Completa */
CREATE OR REPLACE VIEW vista_empleados_info AS
SELECT 
    e.ID_Empleado,
    e.Nombre,
    e.Apellido,
    e.Fecha_Nacimiento,
    e.Fecha_Contratacion,
    p.Descripcion AS Puesto,
    pe.Salario
FROM 
    Empleados e
    JOIN Puestos_Empleado pe ON e.ID_Empleado = pe.ID_Empleado
    JOIN Puestos p ON pe.ID_Puesto = p.ID_Puesto;

/* Vista Licencias de Empleados */
CREATE OR REPLACE VIEW vista_licencias_empleados AS
SELECT 
    e.ID_Empleado,
    e.Nombre,
    e.Apellido,
    l.Tipo AS Tipo_Licencia,
    le.Fecha_Expedicion,
    le.Fecha_Vencimiento
FROM 
    Empleados e
    JOIN Licencias_Empleado le ON e.ID_Empleado = le.ID_Empleado
    JOIN Licencias l ON le.ID_Licencia = l.ID_Licencia;

/* Vista Pedidos con Direcciones */
CREATE OR REPLACE VIEW vista_pedidos_direcciones AS
SELECT 
    p.ID_Pedido,
    p.Fecha,
    p.Estado,
    d.Detalles AS Direccion,
    prov.Nombre AS Provincia,
    cant.Nombre AS Canton,
    dist.Nombre AS Distrito
FROM 
    Pedidos p
    JOIN Direcciones_Pedido d ON p.ID_Pedido = d.ID_Pedido
    JOIN Provincias prov ON d.ID_Provincia = prov.ID_Provincia
    JOIN Cantones cant ON d.ID_Canton = cant.ID_Canton
    JOIN Distritos dist ON d.ID_Distrito = dist.ID_Distrito;

/* Vista Puestos y sus Salarios */
CREATE OR REPLACE VIEW vista_puestos_salarios AS
SELECT 
    p.ID_Puesto,
    p.Descripcion,
    p.Salario
FROM 
    Puestos p;

/* Vista Licencias Vencidas */
CREATE OR REPLACE VIEW vista_licencias_vencidas AS
SELECT 
    e.ID_Empleado,
    e.Nombre,
    e.Apellido,
    l.Tipo AS Tipo_Licencia,
    le.Fecha_Expedicion,
    le.Fecha_Vencimiento
FROM 
    Empleados e
    JOIN Licencias_Empleado le ON e.ID_Empleado = le.ID_Empleado
    JOIN Licencias l ON le.ID_Licencia = l.ID_Licencia
WHERE 
    le.Fecha_Vencimiento < SYSDATE;

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

/*empleado*/

CREATE OR REPLACE PROCEDURE insertar_empleado (
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_fecha_nacimiento IN DATE,
    p_fecha_contratacion IN DATE
)

CREATE OR REPLACE PROCEDURE leer_empleado (
    p_id_empleado IN NUMBER,
    p_nombre OUT VARCHAR2,
    p_apellido OUT VARCHAR2,
    p_fecha_nacimiento OUT DATE,
    p_fecha_contratacion OUT DATE
)

CREATE OR REPLACE PROCEDURE actualizar_empleado (
    p_id_empleado IN NUMBER,
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_fecha_nacimiento IN DATE,
    p_fecha_contratacion IN DATE
)

CREATE OR REPLACE PROCEDURE eliminar_empleado (
    p_id_empleado IN NUMBER
)

/*vehiculo*/

CREATE OR REPLACE PROCEDURE insertar_vehiculo (
    p_marca IN VARCHAR2,
    p_modelo IN VARCHAR2,
    p_anio IN NUMBER,
    p_placa IN VARCHAR2
) 

CREATE OR REPLACE PROCEDURE leer_vehiculo (
    p_id_vehiculo IN NUMBER,
    p_marca OUT VARCHAR2,
    p_modelo OUT VARCHAR2,
    p_anio OUT NUMBER,
    p_placa OUT VARCHAR2
)

CREATE OR REPLACE PROCEDURE actualizar_vehiculo (
    p_id_vehiculo IN NUMBER,
    p_marca IN VARCHAR2,
    p_modelo IN VARCHAR2,
    p_anio IN NUMBER,
    p_placa IN VARCHAR2
)

CREATE OR REPLACE PROCEDURE eliminar_vehiculo (
    p_id_vehiculo IN NUMBER
)

/*pedidos*/

CREATE OR REPLACE PROCEDURE insertar_pedido (
    p_id_cliente IN NUMBER,
    p_fecha IN DATE,
    p_monto IN NUMBER,
    p_id_estado IN NUMBER
)

CREATE OR REPLACE PROCEDURE leer_pedido (
    p_id_pedido IN NUMBER,
    p_id_cliente OUT NUMBER,
    p_fecha OUT DATE,
    p_monto OUT NUMBER,
    p_id_estado OUT NUMBER
)

CREATE OR REPLACE PROCEDURE actualizar_pedido (
    p_id_pedido IN NUMBER,
    p_id_cliente IN NUMBER,
    p_fecha IN DATE,
    p_monto IN NUMBER,
    p_id_estado IN NUMBER
)

CREATE OR REPLACE PROCEDURE eliminar_pedido (
    p_id_pedido IN NUMBER
)


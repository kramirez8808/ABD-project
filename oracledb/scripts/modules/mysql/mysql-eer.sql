-- TABLES

-- DROP TABLE Roles;
CREATE TABLE Roles (
    ID_Rol INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(50)
);

-- DROP TABLE Usuarios;
CREATE TABLE Usuarios (
    ID_Usuario INT AUTO_INCREMENT PRIMARY KEY,
    Usuario VARCHAR(50),
    Contrasena VARCHAR(255),
    ID_Rol INT,
    FOREIGN KEY (ID_Rol) REFERENCES Roles(ID_Rol)
);

-- DROP TABLE Categorias;
CREATE TABLE Categorias (
    ID_Categoria INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(50)
);

-- DROP TABLE Productos;
CREATE TABLE Productos (
    ID_Producto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50),
    Descripcion VARCHAR(100),
    ID_Categoria INT,
    FOREIGN KEY (ID_Categoria) REFERENCES Categorias(ID_Categoria)
);

-- DROP TABLE Vehiculos;
CREATE TABLE Vehiculos (
    ID_Vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    Marca VARCHAR(50),
    Modelo VARCHAR(50),
    Anio INT,
    Placa VARCHAR(10)
);

-- DROP TABLE Estados;
CREATE TABLE Estados (
    ID_Estado INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(100)
);

-- DROP TABLE Licencias;
CREATE TABLE Licencias (
    ID_Licencia INT AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(50)
);

-- DROP TABLE Puestos;
CREATE TABLE Puestos (
    ID_Puesto VARCHAR(10) PRIMARY KEY,
    Salario DECIMAL(10, 2),
    Descripcion VARCHAR(100)
);

-- DROP TABLE Tipos_Carga;
CREATE TABLE Tipos_Carga (
    ID_Tipo INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(100)
);

-- DROP TABLE Empleados;
CREATE TABLE Empleados (
    ID_Empleado INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Fecha_Nacimiento DATE,
    Fecha_Contratacion DATE,
    ID_Puesto VARCHAR(10),
    FOREIGN KEY (ID_Puesto) REFERENCES Puestos(ID_Puesto)
);

-- DROP TABLE Licencias_Empleado;
CREATE TABLE Licencias_Empleado (
    id_licencia_empleado INT AUTO_INCREMENT PRIMARY KEY,
    ID_Empleado INT,
    ID_Licencia INT,
    Fecha_Expedicion DATE,
    Fecha_Vencimiento DATE,
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Licencia) REFERENCES Licencias(ID_Licencia)
);

-- DROP TABLE Clientes;
CREATE TABLE Clientes (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Telefono VARCHAR(15),
    Email VARCHAR(100)
);

-- DROP TABLE Provincias;
CREATE TABLE Provincias (
    ID_Provincia INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50)
);

-- DROP TABLE Cantones;
CREATE TABLE Cantones (
    ID_Canton INT AUTO_INCREMENT PRIMARY KEY,
    ID_Provincia INT,
    Nombre VARCHAR(50),
    FOREIGN KEY (ID_Provincia) REFERENCES Provincias(ID_Provincia)
);

-- DROP TABLE Distritos;
CREATE TABLE Distritos (
    ID_Distrito INT AUTO_INCREMENT PRIMARY KEY,
    ID_Provincia INT,
    ID_Canton INT,
    Nombre VARCHAR(50),
    FOREIGN KEY (ID_Provincia) REFERENCES Provincias(ID_Provincia),
    FOREIGN KEY (ID_Canton) REFERENCES Cantones(ID_Canton)
);

-- DROP TABLE Pedidos;
CREATE TABLE Pedidos (
    ID_Pedido INT AUTO_INCREMENT PRIMARY KEY,
    ID_Cliente INT,
    ID_Vehiculo INT,
    ID_Tipo_Carga INT,
    Fecha DATE,
    ID_Estado INT,
    ID_Licencia_Empleado INT,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Vehiculo) REFERENCES Vehiculos(ID_Vehiculo),
    FOREIGN KEY (ID_Tipo_Carga) REFERENCES Tipos_Carga(ID_Tipo),
    FOREIGN KEY (ID_Estado) REFERENCES Estados(ID_Estado),
    FOREIGN KEY (ID_Licencia_Empleado) REFERENCES Licencias_Empleado(id_licencia_empleado)
);

-- DROP TABLE DetallesPedido;
CREATE TABLE DetallesPedido (
    ID_Detalle INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pedido INT,
    ID_Producto INT,
    Cantidad DECIMAL(10, 2),
    UnidadMasa VARCHAR(10),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido),
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);

-- DROP TABLE Facturas;
CREATE TABLE Facturas (
    ID_Factura INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pedido INT,
    Fecha DATE,
    Total DECIMAL(10, 2),
    ID_Estado INT,
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido),
    FOREIGN KEY (ID_Estado) REFERENCES Estados(ID_Estado)
);

-- DROP TABLE Direcciones_Empleado;
CREATE TABLE Direcciones_Empleado (
    ID_Direccion INT AUTO_INCREMENT PRIMARY KEY,
    ID_Empleado INT,
    ID_Provincia INT,
    ID_Canton INT,
    ID_Distrito INT,
    Detalles VARCHAR(100),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Provincia) REFERENCES Provincias(ID_Provincia),
    FOREIGN KEY (ID_Canton) REFERENCES Cantones(ID_Canton),
    FOREIGN KEY (ID_Distrito) REFERENCES Distritos(ID_Distrito)
);

-- DROP TABLE Direcciones_Pedido;
CREATE TABLE Direcciones_Pedido (
    ID_Direccion INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pedido INT,
    ID_Provincia INT,
    ID_Canton INT,
    ID_Distrito INT,
    Detalles VARCHAR(100),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido),
    FOREIGN KEY (ID_Provincia) REFERENCES Provincias(ID_Provincia),
    FOREIGN KEY (ID_Canton) REFERENCES Cantones(ID_Canton),
    FOREIGN KEY (ID_Distrito) REFERENCES Distritos(ID_Distrito)
);

-- DROP TABLE Direcciones_Cliente;
CREATE TABLE Direcciones_Cliente (
    ID_Direccion INT AUTO_INCREMENT PRIMARY KEY,
    ID_Cliente INT,
    ID_Provincia INT,
    ID_Canton INT,
    ID_Distrito INT,
    Detalles VARCHAR(100),
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Provincia) REFERENCES Provincias(ID_Provincia),
    FOREIGN KEY (ID_Canton) REFERENCES Cantones(ID_Canton),
    FOREIGN KEY (ID_Distrito) REFERENCES Distritos(ID_Distrito)
);

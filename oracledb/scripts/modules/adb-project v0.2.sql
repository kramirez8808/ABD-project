-- TABLES
CREATE TABLE fide_estados_tb (
    id_estado NUMBER NOT NULL,
    descripcion VARCHAR2(50)
);

CREATE TABLE fide_roles_tb (
    id_rol NUMBER NOT NULL,
    descripcion VARCHAR2(50)
    id_estado NUMBER
);

CREATE TABLE fide_usuarios_tb (
    id_usuario NUMBER NOT NULL,
    usuario VARCHAR2(50),
    contrasena VARCHAR2(255),
    id_rol NUMBER,
    id_estado NUMBER
);

CREATE TABLE fide_categorias_tb (
    id_categoria NUMBER NOT NULL,
    descripcion VARCHAR2(50),
    id_estado NUMBER
);

CREATE TABLE fide_productos_tb (
    id_producto NUMBER NOT NULL,
    nombre VARCHAR2(50),
    descripcion VARCHAR2(100),
    id_categoria NUMBER,
    id_estado NUMBER
);

CREATE TABLE fide_vehiculos_tb (
    id_vehiculo NUMBER NOT NULL,
    marca VARCHAR2(50),
    modelo VARCHAR2(50),
    anio INT,
    placa VARCHAR2(10),
    id_estado NUMBER
);

CREATE TABLE fide_licencias_tb (
    id_licencia NUMBER NOT NULL,
    tipo VARCHAR2(50),
    id_estado NUMBER
);

CREATE TABLE fide_puestos_tb (
    id_puesto VARCHAR2(10) NOT NULL,
    salario NUMBER,
    descripcion VARCHAR2(100),
    id_estado NUMBER
);

CREATE TABLE fide_tipos_carga_tb (
    id_tipo_carga NUMBER NOT NULL,
    descripcion VARCHAR2(50),
    id_estado NUMBER
);

CREATE TABLE fide_empleados_tb (
    id_empleado NUMBER NOT NULL,
    nombre VARCHAR2(50),
    apellido VARCHAR2(50),
    fecha_nacimiento DATE,
    fecha_contratacion DATE,
    id_puesto VARCHAR2(10),
    id_estado NUMBER
);

CREATE TABLE fide_licencias_empleado_tb (
    id_licencia_empleado NUMBER NOT NULL,
    id_empleado NUMBER,
    id_licencia NUMBER,
    fecha_expedicion DATE,
    fecha_vencimiento DATE,
    id_estado NUMBER
);

CREATE TABLE fide_clientes_tb (
    id_cliente NUMBER NOT NULL,
    nombre VARCHAR2(50),
    apellido VARCHAR2(50),
    telefono VARCHAR2(15),
    email VARCHAR2(100),
    id_estado NUMBER
);

CREATE TABLE fide_provincias_tb (
    id_provincia NUMBER NOT NULL,
    nombre VARCHAR2(50),
    id_estado NUMBER
);

CREATE TABLE fide_cantones_tb (
    id_canton NUMBER NOT NULL,
    id_provincia NUMBER,
    nombre VARCHAR2(50),
    id_estado NUMBER
);

CREATE TABLE fide_distritos_tb (
    id_distrito NUMBER NOT NULL,
    id_provincia NUMBER,
    id_canton NUMBER,
    nombre VARCHAR2(50),
    id_estado NUMBER
);

CREATE TABLE fide_pedidos_tb (
    id_pedido NUMBER NOT NULL,
    id_cliente NUMBER,
    id_vehiculo NUMBER,
    id_tipo_carga NUMBER,
    fecha DATE,
    id_estado NUMBER,
    id_licencia_empleado NUMBER
);

CREATE TABLE fide_detalles_pedido_tb (
    id_detalle NUMBER NOT NULL,
    id_pedido NUMBER,
    id_producto NUMBER,
    cantidad NUMBER,
    unidad_masa VARCHAR2(10),
    id_estado NUMBER
);

CREATE TABLE fide_facturas_tb (
    id_factura NUMBER NOT NULL,
    id_pedido NUMBER,
    fecha DATE,
    total NUMBER,
    id_estado NUMBER
);

CREATE TABLE fide_direcciones_empleado_tb (
    id_direccion NUMBER NOT NULL,
    id_empleado NUMBER,
    id_provincia NUMBER,
    id_canton NUMBER,
    id_distrito NUMBER,
    detalles VARCHAR2(100),
    id_estado NUMBER
);

CREATE TABLE fide_direcciones_pedido_tb (
    id_direccion NUMBER NOT NULL,
    id_pedido NUMBER,
    id_provincia NUMBER,
    id_canton NUMBER,
    id_distrito NUMBER,
    detalles VARCHAR2(100),
    id_estado NUMBER
);

CREATE TABLE fide_direcciones_cliente_tb (
    id_direccion NUMBER NOT NULL,
    id_cliente NUMBER,
    id_provincia NUMBER,
    id_canton NUMBER,
    id_distrito NUMBER,
    detalles VARCHAR2(100),
    id_estado NUMBER
);

-- PRIMARY KEYS
ALTER TABLE fide_estados_tb ADD CONSTRAINT estados_id_estado_pk PRIMARY KEY (id_estado);
ALTER TABLE fide_roles_tb ADD CONSTRAINT roles_id_rol_pk PRIMARY KEY (id_rol);
ALTER TABLE fide_usuarios_tb ADD CONSTRAINT usuarios_id_usuario_pk PRIMARY KEY (id_usuario);
ALTER TABLE fide_categorias_tb ADD CONSTRAINT categorias_id_categoria_pk PRIMARY KEY (id_categoria);
ALTER TABLE fide_productos_tb ADD CONSTRAINT productos_id_producto_pk PRIMARY KEY (id_producto);
ALTER TABLE fide_vehiculos_tb ADD CONSTRAINT vehiculos_id_vehiculo_pk PRIMARY KEY (id_vehiculo);
ALTER TABLE fide_licencias_tb ADD CONSTRAINT licencias_id_licencia_pk PRIMARY KEY (id_licencia);
ALTER TABLE fide_puestos_tb ADD CONSTRAINT puestos_id_puesto_pk PRIMARY KEY (id_puesto);
ALTER TABLE fide_tipos_carga_tb ADD CONSTRAINT tipos_carga_id_tipo_carga_pk PRIMARY KEY (id_tipo_carga);
ALTER TABLE fide_empleados_tb ADD CONSTRAINT empleados_id_empleado_pk PRIMARY KEY (id_empleado);
ALTER TABLE fide_licencias_empleado_tb ADD CONSTRAINT licencias_empleado_id_licencia_empleado_pk PRIMARY KEY (id_licencia_empleado);
ALTER TABLE fide_clientes_tb ADD CONSTRAINT clientes_id_cliente_pk PRIMARY KEY (id_cliente);
ALTER TABLE fide_provincias_tb ADD CONSTRAINT provincias_id_provincia_pk PRIMARY KEY (id_provincia);
ALTER TABLE fide_cantones_tb ADD CONSTRAINT cantones_id_canton_pk PRIMARY KEY (id_canton);
ALTER TABLE fide_distritos_tb ADD CONSTRAINT distritos_id_distrito_pk PRIMARY KEY (id_distrito);
ALTER TABLE fide_pedidos_tb ADD CONSTRAINT pedidos_id_pedido_pk PRIMARY KEY (id_pedido);
ALTER TABLE fide_detalles_pedido_tb ADD CONSTRAINT detalles_pedido_id_detalle_pk PRIMARY KEY (id_detalle);
ALTER TABLE fide_facturas_tb ADD CONSTRAINT facturas_id_factura_pk PRIMARY KEY (id_factura);
ALTER TABLE fide_direcciones_empleado_tb ADD CONSTRAINT direcciones_empleado_id_direccion_pk PRIMARY KEY (id_direccion);
ALTER TABLE fide_direcciones_pedido_tb ADD CONSTRAINT direcciones_pedido_id_direccion_pk PRIMARY KEY (id_direccion);
ALTER TABLE fide_direcciones_cliente_tb ADD CONSTRAINT direcciones_cliente_id_direccion_pk PRIMARY KEY (id_direccion);

-- FOREIGN KEYS
ALTER TABLE fide_roles_tb ADD CONSTRAINT roles_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_usuarios_tb ADD CONSTRAINT usuarios_id_rol_fk FOREIGN KEY (id_rol) REFERENCES fide_roles_tb (id_rol);
ALTER TABLE fide_usuarios_tb ADD CONSTRAINT usuarios_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_productos_tb ADD CONSTRAINT productos_id_categoria_fk FOREIGN KEY (id_categoria) REFERENCES fide_categorias_tb (id_categoria);
ALTER TABLE fide_productos_tb ADD CONSTRAINT productos_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_vehiculos_tb ADD CONSTRAINT vehiculos_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_licencias_tb ADD CONSTRAINT licencias_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_puestos_tb ADD CONSTRAINT puestos_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_tipos_carga_tb ADD CONSTRAINT tipos_carga_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_empleados_tb ADD CONSTRAINT empleados_id_puesto_fk FOREIGN KEY (id_puesto) REFERENCES fide_puestos_tb (id_puesto);
ALTER TABLE fide_empleados_tb ADD CONSTRAINT empleados_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_licencias_empleado_tb ADD CONSTRAINT licencias_empleado_id_empleado_fk FOREIGN KEY (id_empleado) REFERENCES fide_empleados_tb (id_empleado);
ALTER TABLE fide_licencias_empleado_tb ADD CONSTRAINT licencias_empleado_id_licencia_fk FOREIGN KEY (id_licencia) REFERENCES fide_licencias_tb (id_licencia);
ALTER TABLE fide_licencias_empleado_tb ADD CONSTRAINT licencias_empleado_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_clientes_tb ADD CONSTRAINT clientes_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_provincias_tb ADD CONSTRAINT provincias_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_cantones_tb ADD CONSTRAINT cantones_id_provincia_fk FOREIGN KEY (id_provincia) REFERENCES fide_provincias_tb (id_provincia);
ALTER TABLE fide_cantones_tb ADD CONSTRAINT cantones_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_distritos_tb ADD CONSTRAINT distritos_id_provincia_fk FOREIGN KEY (id_provincia) REFERENCES fide_provincias_tb (id_provincia);
ALTER TABLE fide_distritos_tb ADD CONSTRAINT distritos_id_canton_fk FOREIGN KEY (id_canton) REFERENCES fide_cantones_tb (id_canton);
ALTER TABLE fide_distritos_tb ADD CONSTRAINT distritos_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_pedidos_tb ADD CONSTRAINT pedidos_id_cliente_fk FOREIGN KEY (id_cliente) REFERENCES fide_clientes_tb (id_cliente);
ALTER TABLE fide_pedidos_tb ADD CONSTRAINT pedidos_id_vehiculo_fk FOREIGN KEY (id_vehiculo) REFERENCES fide_vehiculos_tb (id_vehiculo);
ALTER TABLE fide_pedidos_tb ADD CONSTRAINT pedidos_id_tipo_carga_fk FOREIGN KEY (id_tipo_carga) REFERENCES fide_tipos_carga_tb (id_tipo_carga);
ALTER TABLE fide_pedidos_tb ADD CONSTRAINT pedidos_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);
ALTER TABLE fide_pedidos_tb ADD CONSTRAINT pedidos_id_licencia_empleado_fk FOREIGN KEY (id_licencia_empleado) REFERENCES fide_licencias_empleado_tb (id_licencia_empleado);

ALTER TABLE fide_detalles_pedido_tb ADD CONSTRAINT detalles_pedido_id_pedido_fk FOREIGN KEY (id_pedido) REFERENCES fide_pedidos_tb (id_pedido);
ALTER TABLE fide_detalles_pedido_tb ADD CONSTRAINT detalles_pedido_id_producto_fk FOREIGN KEY (id_producto) REFERENCES fide_productos_tb (id_producto);
ALTER TABLE fide_detalles_pedido_tb ADD CONSTRAINT detalles_pedido_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_facturas_tb ADD CONSTRAINT facturas_id_pedido_fk FOREIGN KEY (id_pedido) REFERENCES fide_pedidos_tb (id_pedido);
ALTER TABLE fide_facturas_tb ADD CONSTRAINT facturas_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_direcciones_empleado_tb ADD CONSTRAINT direcciones_empleado_id_empleado_fk FOREIGN KEY (id_empleado) REFERENCES fide_empleados_tb (id_empleado);
ALTER TABLE fide_direcciones_empleado_tb ADD CONSTRAINT direcciones_empleado_id_provincia_fk FOREIGN KEY (id_provincia) REFERENCES fide_provincias_tb (id_provincia);
ALTER TABLE fide_direcciones_empleado_tb ADD CONSTRAINT direcciones_empleado_id_canton_fk FOREIGN KEY (id_canton) REFERENCES fide_cantones_tb (id_canton);
ALTER TABLE fide_direcciones_empleado_tb ADD CONSTRAINT direcciones_empleado_id_distrito_fk FOREIGN KEY (id_distrito) REFERENCES fide_distritos_tb (id_distrito);
ALTER TABLE fide_direcciones_empleado_tb ADD CONSTRAINT direcciones_empleado_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_direcciones_pedido_tb ADD CONSTRAINT direcciones_pedido_id_pedido_fk FOREIGN KEY (id_pedido) REFERENCES fide_pedidos_tb (id_pedido);
ALTER TABLE fide_direcciones_pedido_tb ADD CONSTRAINT direcciones_pedido_id_provincia_fk FOREIGN KEY (id_provincia) REFERENCES fide_provincias_tb (id_provincia);
ALTER TABLE fide_direcciones_pedido_tb ADD CONSTRAINT direcciones_pedido_id_canton_fk FOREIGN KEY (id_canton) REFERENCES fide_cantones_tb (id_canton);
ALTER TABLE fide_direcciones_pedido_tb ADD CONSTRAINT direcciones_pedido_id_distrito_fk FOREIGN KEY (id_distrito) REFERENCES fide_distritos_tb (id_distrito);
ALTER TABLE fide_direcciones_pedido_tb ADD CONSTRAINT direcciones_pedido_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

ALTER TABLE fide_direcciones_cliente_tb ADD CONSTRAINT direcciones_cliente_id_cliente_fk FOREIGN KEY (id_cliente) REFERENCES fide_clientes_tb (id_cliente);
ALTER TABLE fide_direcciones_cliente_tb ADD CONSTRAINT direcciones_cliente_id_provincia_fk FOREIGN KEY (id_provincia) REFERENCES fide_provincias_tb (id_provincia);
ALTER TABLE fide_direcciones_cliente_tb ADD CONSTRAINT direcciones_cliente_id_canton_fk FOREIGN KEY (id_canton) REFERENCES fide_cantones_tb (id_canton);
ALTER TABLE fide_direcciones_cliente_tb ADD CONSTRAINT direcciones_cliente_id_distrito_fk FOREIGN KEY (id_distrito) REFERENCES fide_distritos_tb (id_distrito);
ALTER TABLE fide_direcciones_cliente_tb ADD CONSTRAINT direcciones_cliente_id_estado_fk FOREIGN KEY (id_estado) REFERENCES fide_estados_tb (id_estado);

-- CUSTOM AUTOINCREMENT CONSTRAINTS


-- FUNCTIONS

-- Clientes
-- Function to search clients by a string in their name
/
CREATE OR REPLACE FUNCTION buscar_clientes_nombre(p_nombre IN VARCHAR2)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Cliente, Nombre, Apellido, Telefono, Email
    FROM Clientes
    WHERE LOWER(Nombre) LIKE '%' || LOWER(p_nombre) || '%';
    RETURN l_cursor;
END buscar_clientes_nombre;
/

-- Function to search clients by a string in their email
/
CREATE OR REPLACE FUNCTION buscar_clientes_email(p_email IN VARCHAR2)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Cliente, Nombre, Apellido, Telefono, Email
    FROM Clientes
    WHERE LOWER(Email) LIKE '%' || LOWER(p_email) || '%';
    RETURN l_cursor;
END buscar_clientes_email;
/

-- Function to search directions by client ID
/
CREATE OR REPLACE FUNCTION buscar_direcciones_por_cliente(p_id_cliente IN NUMBER)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Direccion, ID_Cliente, Detalles, ID_Distrito
    FROM Direcciones_Cliente
    WHERE ID_Cliente = p_id_cliente;
    RETURN l_cursor;
END buscar_direcciones_por_cliente;
/

-- Function to search direction by employee ID
/
CREATE OR REPLACE FUNCTION buscar_direcciones_por_empleado(p_id_empleado IN NUMBER)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Direccion, ID_Empleado, Detalles, ID_Distrito
    FROM Direcciones_Empleado
    WHERE ID_Empleado = p_id_empleado;
    RETURN l_cursor;
END buscar_direcciones_por_empleado;
/

-- Function to search order by client ID
/
CREATE OR REPLACE FUNCTION buscar_pedidos_por_cliente(p_id_cliente IN NUMBER)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Pedido, Descripcion, ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado
    FROM Pedidos
    WHERE ID_Cliente = p_id_cliente;
    RETURN l_cursor;
END buscar_pedidos_por_cliente;
/

-- Function to search direction by Order ID
/
CREATE OR REPLACE FUNCTION buscar_direcciones_por_pedido(p_id_pedido IN NUMBER)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Direccion, ID_Pedido, Detalles, ID_Distrito
    FROM Direcciones_Pedido
    WHERE ID_Pedido = p_id_pedido;
    RETURN l_cursor;
END buscar_direcciones_por_pedido;
/

-- Function to search license_employee by employee ID
/
CREATE OR REPLACE FUNCTION buscar_licencias_por_empleado(p_id_empleado IN NUMBER)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Licencia_Empleado, ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento
    FROM Licencias_Empleado
    WHERE ID_Empleado = p_id_empleado;
    RETURN l_cursor;
END buscar_licencias_por_empleado;
/

-- Function to search invoice by order ID
/
CREATE OR REPLACE FUNCTION buscar_factura_por_pedido(p_id_pedido IN NUMBER)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
    FROM Facturas
    WHERE ID_Pedido = p_id_pedido;
    RETURN l_cursor;
END buscar_factura_por_pedido;
/

--busca empleado por Nombre
/
CREATE OR REPLACE FUNCTION buscar_empleado_nombre(p_nombre IN VARCHAR2)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Empleado, Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion
    FROM Empleados
    WHERE LOWER(Nombre) LIKE '%' || LOWER(p_nombre) || '%';
    RETURN l_cursor;
END buscar_empleado_nombre;
/

--buscar empleado por ID_Empleado
/
CREATE OR REPLACE FUNCTION buscar_empleado_ID(p_Empleado_ID IN NUMBER)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Empleado, Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion
    FROM Empleados
    WHERE ID_Empleado = p_Empleado_ID;
    RETURN l_cursor;
END buscar_empleado_ID;
/

--buscar vehiculo por placa
/
CREATE OR REPLACE FUNCTION buscar_vehiculo_placa(p_placa IN VARCHAR2)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Vehiculo, Marca, Modelo, Anio, Placa
    FROM Vehiculos
    WHERE LOWER(Placa) LIKE '%' || LOWER(p_placa) || '%';
    RETURN l_cursor;
END buscar_vehiculo_placa;
/

--busca vehiculo por marca
/
CREATE OR REPLACE FUNCTION buscar_vehiculo_marca(p_marca IN VARCHAR2)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Vehiculo, Marca, Modelo, Anio, Placa
    FROM Vehiculos
    WHERE LOWER(Marca) LIKE '%' || LOWER(p_marca) || '%';
    RETURN l_cursor;
END buscar_vehiculo_marca;
/

--busca pedido por id
/
CREATE OR REPLACE FUNCTION buscar_pedido_ID(p_pedido_ID IN NUMBER)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Pedido, ID_Cliente, Fecha, ID_Estado
    FROM Pedidos
    WHERE ID_Pedido = p_pedido_ID;
    RETURN l_cursor;
END buscar_pedido_ID;
/

--busca pedido por id_Estado
/
CREATE OR REPLACE FUNCTION buscar_pedido_ID_Estado(p_pedido_ID_Estado IN NUMBER)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Pedido, ID_Cliente, Fecha, ID_Estado
    FROM Pedidos
    WHERE ID_Estado = p_pedido_ID_Estado;
    RETURN l_cursor;
END buscar_pedido_ID_Estado;
/

--busca facturas por ID
/
CREATE OR REPLACE FUNCTION buscar_factura_ID(p_factura_ID IN NUMBER)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
    FROM Facturas
    WHERE ID_Factura = p_factura_ID;
    RETURN l_cursor;
END buscar_factura_ID;
/

--buscar facturas por Total
/
CREATE OR REPLACE FUNCTION buscar_factura_total(p_factura_Total IN NUMBER)
RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
    SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
    FROM Facturas
    WHERE Total = p_factura_Total;
    RETURN l_cursor;
END buscar_factura_Total;
/





-- STORED PROCEDURES
/
CREATE OR REPLACE PACKAGE BODY PKG_PUESTOS AS

    PROCEDURE ver_puesto(
        p_id_puesto IN NUMBER,
        p_descripcion OUT VARCHAR2,
        p_salario OUT NUMBER
    ) AS
    BEGIN
        SELECT Descripcion, Salario
        INTO p_descripcion, p_salario
        FROM Puestos
        WHERE ID_Puesto = p_id_puesto;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_descripcion := NULL;
            p_salario := NULL;
    END ver_puesto;

    PROCEDURE ver_puestos(
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
        SELECT ID_Puesto, Descripcion, Salario
        FROM Puestos;
    END ver_puestos;

    FUNCTION buscar_puestos_descripcion(p_descripcion IN VARCHAR2)
    RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_Puesto, Descripcion, Salario
        FROM Puestos
        WHERE LOWER(Descripcion) LIKE '%' || LOWER(p_descripcion) || '%';
        RETURN l_cursor;
    END buscar_puestos_descripcion;

END PKG_PUESTOS;
/

-- Script para crear los SPs de la base de datos

/* SP de objeto Empleado */
/
CREATE OR REPLACE PROCEDURE insertar_empleado (
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_fecha_nacimiento IN DATE,
    p_fecha_contratacion IN DATE,
    p_id_puesto IN VARCHAR2
) AS
BEGIN
    INSERT INTO Empleados (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto)
    VALUES (p_nombre, p_apellido, p_fecha_nacimiento, p_fecha_contratacion, p_id_puesto);
END insertar_empleado;
/

/
CREATE OR REPLACE PROCEDURE ver_empleado (
    p_id_empleado IN NUMBER,
    p_nombre OUT VARCHAR2,
    p_apellido OUT VARCHAR2,
    p_fecha_nacimiento OUT DATE,
    p_fecha_contratacion OUT DATE,
    p_id_puesto OUT VARCHAR2
) AS
BEGIN
    SELECT Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto
    INTO p_nombre, p_apellido, p_fecha_nacimiento, p_fecha_contratacion, p_id_puesto
    FROM Empleados
    WHERE ID_Empleado = p_id_empleado;
END ver_empleado;
/

/
CREATE OR REPLACE PROCEDURE ver_empleados (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Empleado, Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto
    FROM Empleados;
END ver_empleados;
/

/
CREATE OR REPLACE PROCEDURE actualizar_empleado (
    p_id_empleado IN NUMBER,
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_fecha_nacimiento IN DATE,
    p_fecha_contratacion IN DATE,
    p_id_puesto IN VARCHAR2
) AS
BEGIN
    UPDATE Empleados
    SET Nombre = p_nombre,
        Apellido = p_apellido,
        Fecha_Nacimiento = p_fecha_nacimiento,
        Fecha_Contratacion = p_fecha_contratacion,
        ID_Puesto = p_id_puesto
    WHERE ID_Empleado = p_id_empleado;
END actualizar_empleado;
/

/
CREATE OR REPLACE PROCEDURE eliminar_empleado (
    p_id_empleado IN NUMBER
) AS
BEGIN
    DELETE FROM Empleados
    WHERE ID_Empleado = p_id_empleado;
END eliminar_empleado;
/

/* SP de objeto Cliente */
/
CREATE OR REPLACE PROCEDURE insertar_cliente (
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_telefono IN VARCHAR2,
    p_email IN VARCHAR2
) AS
BEGIN
    INSERT INTO Clientes (Nombre, Apellido, Telefono, Email)
    VALUES (p_nombre, p_apellido, p_telefono, p_email);
END insertar_cliente;
/

/
CREATE OR REPLACE PROCEDURE ver_cliente (
    p_id_cliente IN NUMBER,
    p_nombre OUT VARCHAR2,
    p_apellido OUT VARCHAR2,
    p_telefono OUT VARCHAR2,
    p_correo OUT VARCHAR2
) AS
BEGIN
    SELECT Nombre, Apellido, Telefono, Email
    INTO p_nombre, p_apellido, p_telefono, p_correo
    FROM Clientes
    WHERE ID_Cliente = p_id_cliente;
END ver_cliente;
/

/
CREATE OR REPLACE PROCEDURE actualizar_cliente (
    p_id_cliente IN NUMBER,
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
) AS
BEGIN
    UPDATE Clientes
    SET Nombre = p_nombre,
        Apellido = p_apellido,
        Telefono = p_telefono,
        Email = p_correo
    WHERE ID_Cliente = p_id_cliente;
END actualizar_cliente;
/

/
CREATE OR REPLACE PROCEDURE eliminar_cliente (
    p_id_cliente IN NUMBER
) AS
BEGIN
    DELETE FROM Clientes
    WHERE ID_Cliente = p_id_cliente;
END eliminar_cliente;
/

/
CREATE OR REPLACE PROCEDURE ver_clientes (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Cliente, Nombre, Apellido, Telefono, Email
    FROM Clientes;
END ver_clientes;
/

/* SP de objeto Provincia */
/
CREATE OR REPLACE PROCEDURE ver_provincia (
    p_id_provincia IN NUMBER,
    p_nombre OUT VARCHAR2
) AS
BEGIN
    SELECT Nombre
    INTO p_nombre
    FROM Provincias
    WHERE ID_Provincia = p_id_provincia;
END ver_provincia;
/

/
CREATE OR REPLACE PROCEDURE ver_provincias (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Provincia, Nombre
    FROM Provincias;
END ver_provincias;
/

/* SP de objeto Canton */
/
CREATE OR REPLACE PROCEDURE ver_canton (
    p_id_canton IN NUMBER,
    p_nombre OUT VARCHAR2,
    p_id_provincia OUT NUMBER
) AS
BEGIN
    SELECT Nombre, ID_Provincia
    INTO p_nombre, p_id_provincia
    FROM Cantones
    WHERE ID_Canton = p_id_canton;
END ver_canton;
/

/
CREATE OR REPLACE PROCEDURE ver_cantones (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Canton, Nombre, ID_Provincia
    FROM Cantones;
END ver_cantones;
/

/* SP de objeto Distrito */
/
CREATE OR REPLACE PROCEDURE ver_distrito (
    p_id_distrito IN NUMBER,
    p_nombre OUT VARCHAR2,
    p_id_canton OUT NUMBER
) AS
BEGIN
    SELECT Nombre, ID_Canton
    INTO p_nombre, p_id_canton
    FROM Distritos
    WHERE ID_Distrito = p_id_distrito;
END ver_distrito;
/

/
CREATE OR REPLACE PROCEDURE ver_distritos (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Distrito, Nombre, ID_Canton
    FROM Distritos;
END ver_distritos;
/

/* SP de objeto DireccionCliente */
/
CREATE OR REPLACE PROCEDURE insertar_direccion_cliente (
    p_id_cliente IN NUMBER,
    p_detalles IN VARCHAR2,
    p_provincia IN VARCHAR2,
    p_canton IN VARCHAR2,
    p_distrito IN VARCHAR2
) AS
BEGIN
    INSERT INTO Direcciones_Cliente (ID_Cliente, ID_Provincia, ID_Canton, ID_Distrito, Detalles)
    VALUES (p_id_cliente, p_provincia, p_canton, p_distrito, p_detalles);
END insertar_direccion_cliente;
/

/
CREATE OR REPLACE PROCEDURE actualizar_direccion_cliente (
    p_id_direccion IN NUMBER,
    p_detalles IN VARCHAR2,
    p_provincia IN VARCHAR2,
    p_canton IN VARCHAR2,
    p_distrito IN VARCHAR2
) AS
BEGIN
    UPDATE Direcciones_Cliente
    SET ID_Provincia = p_provincia,
        ID_Canton = p_canton,
        ID_Distrito = p_distrito,
        Detalles = p_detalles
    WHERE ID_Direccion = p_id_direccion;
END actualizar_direccion_cliente;
/

/
CREATE OR REPLACE PROCEDURE ver_direccion_cliente (
    p_id_direccion IN NUMBER,
    p_id_cliente OUT NUMBER,
    p_detalles OUT VARCHAR2,
    p_id_distrito OUT VARCHAR2
) AS
BEGIN
    SELECT ID_Cliente, Detalles, ID_Distrito
    INTO p_id_cliente, p_detalles, p_id_distrito
    FROM Direcciones_Cliente
    WHERE ID_Direccion = p_id_direccion;
END ver_direccion_cliente;
/

-- DROP PROCEDURE ver_direcciones_clientes;
/
CREATE OR REPLACE PROCEDURE ver_direcciones_clientes(
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Direccion, ID_Cliente, Detalles, ID_Distrito
    FROM Direcciones_Cliente;
END ver_direcciones_clientes;
/

/
CREATE OR REPLACE PROCEDURE eliminar_direccion_cliente (
    p_id_direccion IN NUMBER
) AS
BEGIN
    DELETE FROM Direcciones_Cliente
    WHERE ID_Direccion = p_id_direccion;
END eliminar_direccion_cliente;
/

-- SP de objeto Licencia
/
CREATE OR REPLACE PROCEDURE ver_licencia (
    p_id_licencia IN NUMBER,
    p_tipo OUT VARCHAR2
) AS
BEGIN
    SELECT Tipo
    INTO p_tipo
    FROM Licencias
    WHERE ID_Licencia = p_id_licencia;
END ver_licencia;
/

/
CREATE OR REPLACE PROCEDURE ver_licencias (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Licencia, Tipo
    FROM Licencias;
END ver_licencias;
/

-- SP de objeto Estado
/
CREATE OR REPLACE PROCEDURE ver_estado (
    p_id_estado IN NUMBER,
    p_descripcion OUT VARCHAR2
) AS
BEGIN
    SELECT Descripcion
    INTO p_descripcion
    FROM Estados
    WHERE ID_Estado = p_id_estado;
END ver_estado;
/

/
CREATE OR REPLACE PROCEDURE ver_estados (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Estado, Descripcion
    FROM Estados;
END ver_estados;
/

-- SP de objeto Tipos_Carga
/
CREATE OR REPLACE PROCEDURE ver_tipo_carga (
    p_id_tipo IN NUMBER,
    p_descripcion OUT VARCHAR2
) AS
BEGIN
    SELECT Descripcion
    INTO p_descripcion
    FROM Tipos_Carga
    WHERE ID_Tipo = p_id_tipo;
END ver_tipo_carga;
/

/
CREATE OR REPLACE PROCEDURE ver_tipos_carga (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Tipo, Descripcion
    FROM Tipos_Carga;
END ver_tipos_carga;
/

-- SP de objeto Puesto
/
CREATE OR REPLACE PROCEDURE ver_puesto (
    p_id_puesto IN VARCHAR2,
    p_descripcion OUT VARCHAR2,
    p_salario OUT NUMBER
) AS
BEGIN
    SELECT Descripcion, Salario
    INTO p_descripcion, p_salario
    FROM Puestos
    WHERE ID_Puesto = p_id_puesto;
END ver_puesto;
/

/
CREATE OR REPLACE PROCEDURE ver_puestos (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Puesto, Descripcion, Salario
    FROM Puestos;
END ver_puestos;
/

-- SP de objeto Vehiculo
/
CREATE OR REPLACE PROCEDURE ver_vehiculo (
    p_id_vehiculo IN NUMBER,
    p_marca OUT VARCHAR2,
    p_modelo OUT VARCHAR2,
    p_anio OUT INT,
    p_placa OUT VARCHAR2
) AS
BEGIN
    SELECT Marca, Modelo, Anio, Placa
    INTO p_marca, p_modelo, p_anio, p_placa
    FROM Vehiculos
    WHERE ID_Vehiculo = p_id_vehiculo;
END ver_vehiculo;
/

/
CREATE OR REPLACE PROCEDURE ver_vehiculos (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Vehiculo, Marca, Modelo, Anio, Placa
    FROM Vehiculos;
END ver_vehiculos;
/

/
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
/

/
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
/

/
CREATE OR REPLACE PROCEDURE eliminar_vehiculo (
    p_id_vehiculo IN NUMBER
) AS
BEGIN
    DELETE FROM Vehiculos
    WHERE ID_Vehiculo = p_id_vehiculo;
END eliminar_vehiculo;
/

-- SP de objeto Licencia_Empleado
/
CREATE OR REPLACE PROCEDURE insertar_licencia_empleado (
    p_id_empleado IN NUMBER,
    p_id_licencia IN NUMBER,
    p_fecha_expedicion IN DATE,
    p_fecha_vencimiento IN DATE
) AS
BEGIN
    INSERT INTO Licencias_Empleado (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento)
    VALUES (p_id_empleado, p_id_licencia, p_fecha_expedicion, p_fecha_vencimiento);
END insertar_licencia_empleado;
/

/
CREATE OR REPLACE PROCEDURE ver_licencia_empleado (
    p_id_licencia_empleado IN NUMBER,
    p_id_empleado OUT NUMBER,
    p_id_licencia OUT NUMBER,
    p_fecha_expedicion OUT DATE,
    p_fecha_vencimiento OUT DATE
) AS
BEGIN
    SELECT ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento
    INTO p_id_empleado, p_id_licencia, p_fecha_expedicion, p_fecha_vencimiento
    FROM Licencias_Empleado
    WHERE ID_Licencia_Empleado = p_id_licencia_empleado;
END ver_licencia_empleado;
/

/
CREATE OR REPLACE PROCEDURE ver_licencias_empleados (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Licencia_Empleado, ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento
    FROM Licencias_Empleado;
END ver_licencias_empleados;
/

/
CREATE OR REPLACE PROCEDURE actualizar_licencia_empleado (
    p_id_licencia_empleado IN NUMBER,
    p_id_licencia IN NUMBER,
    p_fecha_expedicion IN DATE,
    p_fecha_vencimiento IN DATE
) AS
BEGIN
    UPDATE Licencias_Empleado
    SET ID_Licencia = p_id_licencia,
        Fecha_Expedicion = p_fecha_expedicion,
        Fecha_Vencimiento = p_fecha_vencimiento
    WHERE ID_Licencia_Empleado = p_id_licencia_empleado;
END actualizar_licencia_empleado;
/

/
CREATE OR REPLACE PROCEDURE eliminar_licencia_empleado (
    p_id_licencia_empleado IN NUMBER
) AS
BEGIN
    DELETE FROM Licencias_Empleado
    WHERE ID_Licencia_Empleado = p_id_licencia_empleado;
END eliminar_licencia_empleado;
/

-- SP de objeto Direccion_Empleado
/
CREATE OR REPLACE PROCEDURE insertar_direccion_empleado (
    p_id_empleado IN NUMBER,
    p_detalles IN VARCHAR2,
    p_id_provincia IN NUMBER,
    p_id_canton IN NUMBER,
    p_id_distrito IN NUMBER
) AS
BEGIN
    INSERT INTO Direcciones_Empleado (ID_Empleado, Detalles, ID_Provincia, ID_Canton, ID_Distrito)
    VALUES (p_id_empleado, p_detalles, p_id_provincia, p_id_canton, p_id_distrito);
END insertar_direccion_empleado;
/

/
CREATE OR REPLACE PROCEDURE ver_direccion_empleado (
    p_id_direccion IN NUMBER,
    p_id_empleado OUT NUMBER,
    p_detalles OUT VARCHAR2,
    p_id_distrito OUT VARCHAR2
) AS
BEGIN
    SELECT ID_Empleado, Detalles, ID_Distrito
    INTO p_id_empleado, p_detalles, p_id_distrito
    FROM Direcciones_Empleado
    WHERE ID_Direccion = p_id_direccion;
END ver_direccion_empleado;
/

/
CREATE OR REPLACE PROCEDURE ver_direcciones_empleados (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Direccion, ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles
    FROM Direcciones_Empleado;
END ver_direcciones_empleados;
/

/
CREATE OR REPLACE PROCEDURE actualizar_direccion_empleado (
    p_id_direccion IN NUMBER,
    p_detalles IN VARCHAR2,
    p_id_provincia IN NUMBER,
    p_id_canton IN NUMBER,
    p_id_distrito IN NUMBER
) AS
BEGIN
    UPDATE Direcciones_Empleado
    SET ID_Provincia = p_id_provincia,
        ID_Canton = p_id_canton,
        ID_Distrito = p_id_distrito,
        Detalles = p_detalles
    WHERE ID_Direccion = p_id_direccion;
END actualizar_direccion_empleado;
/

/
CREATE OR REPLACE PROCEDURE eliminar_direccion_empleado (
    p_id_direccion IN NUMBER
) AS
BEGIN
    DELETE FROM Direcciones_Empleado
    WHERE ID_Direccion = p_id_direccion;
END eliminar_direccion_empleado;
/

-- SP de objeto Pedido
/
CREATE OR REPLACE PROCEDURE insertar_pedido (
    p_descripcion IN VARCHAR2,
    p_id_cliente IN NUMBER,
    p_id_vehiculo IN NUMBER,
    p_id_tipo_carga IN NUMBER,
    p_fecha IN DATE,
    p_id_estado IN NUMBER,
    p_id_licencia_empleado IN NUMBER
) AS
BEGIN
    INSERT INTO Pedidos (Descripcion, ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado)
    VALUES (p_descripcion, p_id_cliente, p_id_vehiculo, p_id_tipo_carga, p_fecha, p_id_estado, p_id_licencia_empleado);
END insertar_pedido;
/

/
CREATE OR REPLACE PROCEDURE ver_pedido (
    p_id_pedido IN NUMBER,
    p_descripcion OUT VARCHAR2,
    p_id_cliente OUT NUMBER,
    p_id_vehiculo OUT NUMBER,
    p_id_tipo_carga OUT NUMBER,
    p_fecha OUT DATE,
    p_id_estado OUT NUMBER,
    p_id_licencia_empleado OUT NUMBER
) AS
BEGIN
    SELECT Descripcion, ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado
    INTO p_descripcion, p_id_cliente, p_id_vehiculo, p_id_tipo_carga, p_fecha, p_id_estado, p_id_licencia_empleado
    FROM Pedidos
    WHERE ID_Pedido = p_id_pedido;
END ver_pedido;
/

/
CREATE OR REPLACE PROCEDURE ver_pedidos (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Pedido, Descripcion, ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado
    FROM Pedidos;
END ver_pedidos;
/

/
CREATE OR REPLACE PROCEDURE actualizar_pedido (
    p_id_pedido IN NUMBER,
    p_descripcion IN VARCHAR2,
    p_id_cliente IN NUMBER,
    p_id_vehiculo IN NUMBER,
    p_id_tipo_carga IN NUMBER,
    p_fecha IN DATE,
    p_id_estado IN NUMBER,
    p_id_licencia_empleado IN NUMBER
) AS
BEGIN
    UPDATE Pedidos
    SET Descripcion = p_descripcion,
        ID_Cliente = p_id_cliente,
        ID_Vehiculo = p_id_vehiculo,
        ID_Tipo_Carga = p_id_tipo_carga,
        Fecha = p_fecha,
        ID_Estado = p_id_estado,
        ID_Licencia_Empleado = p_id_licencia_empleado
    WHERE ID_Pedido = p_id_pedido;
END actualizar_pedido;
/

/
CREATE OR REPLACE PROCEDURE eliminar_pedido (
    p_id_pedido IN NUMBER
) AS
BEGIN
    DELETE FROM Pedidos
    WHERE ID_Pedido = p_id_pedido;
END eliminar_pedido;
/

-- SP de objeto Direcciones_Pedido
/
CREATE OR REPLACE PROCEDURE insertar_direccion_pedido (
    p_id_pedido IN NUMBER,
    p_detalles IN VARCHAR2,
    p_id_provincia IN NUMBER,
    p_id_canton IN NUMBER,
    p_id_distrito IN NUMBER
) AS
BEGIN
    INSERT INTO Direcciones_Pedido (ID_Pedido, Detalles, ID_Provincia, ID_Canton, ID_Distrito)
    VALUES (p_id_pedido, p_detalles, p_id_provincia, p_id_canton, p_id_distrito);
END insertar_direccion_pedido;
/

/
CREATE OR REPLACE PROCEDURE ver_direccion_pedido (
    p_id_direccion IN NUMBER,
    p_id_pedido OUT NUMBER,
    p_detalles OUT VARCHAR2,
    p_id_distrito OUT VARCHAR2
) AS
BEGIN
    SELECT ID_Pedido, Detalles, ID_Distrito
    INTO p_id_pedido, p_detalles, p_id_distrito
    FROM Direcciones_Pedido
    WHERE ID_Direccion = p_id_direccion;
END ver_direccion_pedido;
/

/
CREATE OR REPLACE PROCEDURE ver_direcciones_pedidos (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Direccion, ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles
    FROM Direcciones_Pedido;
END ver_direcciones_pedidos;
/

/
CREATE OR REPLACE PROCEDURE actualizar_direccion_pedido (
    p_id_direccion IN NUMBER,
    p_detalles IN VARCHAR2,
    p_id_provincia IN NUMBER,
    p_id_canton IN NUMBER,
    p_id_distrito IN NUMBER
) AS
BEGIN
    UPDATE Direcciones_Pedido
    SET ID_Provincia = p_id_provincia,
        ID_Canton = p_id_canton,
        ID_Distrito = p_id_distrito,
        Detalles = p_detalles
    WHERE ID_Direccion = p_id_direccion;
END actualizar_direccion_pedido;
/

/
CREATE OR REPLACE PROCEDURE eliminar_direccion_pedido (
    p_id_direccion IN NUMBER
) AS
BEGIN
    DELETE FROM Direcciones_Pedido
    WHERE ID_Direccion = p_id_direccion;
END eliminar_direccion_pedido;
/


-- SP de objeto Factura
/
CREATE OR REPLACE PROCEDURE insertar_factura (
    p_id_pedido IN NUMBER,
    p_fecha IN DATE,
    p_total IN NUMBER,
    p_id_estado IN NUMBER
) AS
BEGIN
    INSERT INTO Facturas (ID_Pedido, Fecha, Total, ID_Estado)
    VALUES (p_id_pedido, p_fecha, p_total, p_id_estado);
END insertar_factura;
/

/
CREATE OR REPLACE PROCEDURE ver_factura (
    p_id_factura IN NUMBER,
    p_id_pedido OUT NUMBER,
    p_fecha OUT DATE,
    p_total OUT NUMBER,
    p_id_estado OUT NUMBER
) AS
BEGIN
    SELECT ID_Pedido, Fecha, Total, ID_Estado
    INTO p_id_pedido, p_fecha, p_total, p_id_estado
    FROM Facturas
    WHERE ID_Factura = p_id_factura;
END ver_factura;
/

/
CREATE OR REPLACE PROCEDURE ver_facturas (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
    FROM Facturas;
END ver_facturas;
/

/
CREATE OR REPLACE PROCEDURE actualizar_factura (
    p_id_factura IN NUMBER,
    p_fecha IN DATE,
    p_total IN NUMBER,
    p_id_estado IN NUMBER
) AS
BEGIN
    UPDATE Facturas
    SET Fecha = p_fecha,
        Total = p_total,
        ID_Estado = p_id_estado
    WHERE ID_Factura = p_id_factura;
END actualizar_factura;
/

/
CREATE OR REPLACE PROCEDURE eliminar_factura (
    p_id_factura IN NUMBER
) AS
BEGIN
    DELETE FROM Facturas
    WHERE ID_Factura = p_id_factura;
END eliminar_factura;
/

-- VIEWS
/* Vista Informacion Empleado Completa */
CREATE OR REPLACE VIEW vista_empleados_info AS
SELECT 
    e.ID_Empleado,
    e.Nombre,
    e.Apellido,
    e.Fecha_Nacimiento,
    e.Fecha_Contratacion,
    p.Descripcion AS Puesto,
    p.Salario AS Salario
FROM 
    Empleados e
    JOIN Puestos p ON e.ID_Puesto = p.ID_Puesto;

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
    est.Descripcion AS Estado,
    d.Detalles AS Direccion,
    prov.Nombre AS Provincia,
    cant.Nombre AS Canton,
    dist.Nombre AS Distrito
FROM 
    Pedidos p
    JOIN Estados est ON p.ID_Estado = est.ID_Estado
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






-- TRIGGERS/AUDIT
/
CREATE TABLE auditoria_vehiculo (
    id_auditoria NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    tipo_evento VARCHAR2(10),
    usuario_bd VARCHAR2(30),
    fecha_evento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_sistema VARCHAR2(30),
    ip_maquina VARCHAR2(45),
    nombre_maquina VARCHAR2(100),
    datos_antes CLOB
);
/

/
CREATE OR REPLACE TRIGGER trg_auditoria_delete
AFTER DELETE ON VEHICULOS
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_vehiculo (
        tipo_evento,
        usuario_bd,
        usuario_sistema,
        ip_maquina,
        nombre_maquina,
        datos_antes
    )
    VALUES (
        'DELETE',
        USER,
        SYS_CONTEXT('USERENV', 'OS_USER'),
        SYS_CONTEXT('USERENV', 'IP_ADDRESS'),
        SYS_CONTEXT('USERENV', 'HOST'),
        'ID_VEHICULO: ' || :OLD.ID_VEHICULO || ', MARCA: ' || :OLD.MARCA || ', MODELO: ' || :OLD.MODELO || ', ANIO: ' || :OLD.ANIO || ', PLACA: ' || :OLD.PLACA);
END;
/

/
CREATE OR REPLACE TRIGGER trg_auditoria_update
AFTER UPDATE ON VEHICULOS
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_vehiculo (
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
/

--DROP TABLE auditoria_pedidos;
/
CREATE TABLE auditoria_pedidos (
    audit_id            NUMBER GENERATED BY DEFAULT AS IDENTITY,
    tipo_evento         VARCHAR2(10),
    pedido_id           NUMBER,
    usuario_bd          VARCHAR2(30),
    fecha_hora          DATE,
    usuario_so          VARCHAR2(100),
    ip_maquina          VARCHAR2(45),
    nombre_maquina      VARCHAR2(100)
);
/

/
CREATE OR REPLACE TRIGGER trg_auditoria_pedidos_inserts
AFTER INSERT ON pedidos
FOR EACH ROW
DECLARE
    v_usuario_so    VARCHAR2(100);
    v_ip_maquina    VARCHAR2(45);
    v_nombre_maquina VARCHAR2(100);
BEGIN
   
    SELECT SYS_CONTEXT('USERENV', 'OS_USER') INTO v_usuario_so FROM dual;


    SELECT SYS_CONTEXT('USERENV', 'IP_ADDRESS') INTO v_ip_maquina FROM dual;


    SELECT SYS_CONTEXT('USERENV', 'HOST') INTO v_nombre_maquina FROM dual;
    
    INSERT INTO auditoria_pedidos (tipo_evento,pedido_id, usuario_bd, fecha_hora, usuario_so, ip_maquina, nombre_maquina)
    VALUES ('insert',:NEW.id_pedido, USER, SYSDATE, v_usuario_so, v_ip_maquina, v_nombre_maquina);
END;
/

/
CREATE OR REPLACE  TRIGGER trg_auditoria_pedidos_updates
AFTER UPDATE ON pedidos
FOR EACH ROW
DECLARE
    v_usuario_so     VARCHAR2(100);
    v_ip_maquina     VARCHAR2(45);
    v_nombre_maquina VARCHAR2(100);
BEGIN
    SELECT SYS_CONTEXT('USERENV', 'OS_USER') INTO v_usuario_so FROM dual;
    SELECT SYS_CONTEXT('USERENV', 'IP_ADDRESS') INTO v_ip_maquina FROM dual;
    SELECT SYS_CONTEXT('USERENV', 'HOST') INTO v_nombre_maquina FROM dual;

    INSERT INTO auditoria_pedidos (tipo_evento, pedido_id, usuario_bd, fecha_hora, usuario_so, ip_maquina, nombre_maquina)
    VALUES ('UPDATE',:NEW.id_pedido, USER, SYSDATE, v_usuario_so, v_ip_maquina, v_nombre_maquina);
END;
/

/
CREATE OR REPLACE TRIGGER trg_prevent_delete_factura
BEFORE DELETE ON facturas
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20002, 'No se permite la eliminaci�n de facturas.');
END;
/

-- PACKAGES
-- Primer paquete Clientes
/
CREATE OR REPLACE PACKAGE pkg_clientes AS
    FUNCTION buscar_clientes_nombre(p_nombre IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION buscar_clientes_email(p_email IN VARCHAR2) RETURN SYS_REFCURSOR;
    PROCEDURE insertar_cliente(p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_telefono IN VARCHAR2, p_email IN VARCHAR2);
    PROCEDURE actualizar_cliente(p_id_cliente IN NUMBER, p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_telefono IN VARCHAR2, p_email IN VARCHAR2);
    PROCEDURE eliminar_cliente(p_id_cliente IN NUMBER);
END pkg_clientes;
/

/
CREATE OR REPLACE PACKAGE BODY pkg_clientes AS
    FUNCTION buscar_clientes_nombre(p_nombre IN VARCHAR2) RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_Cliente, Nombre, Apellido, Telefono, Email
        FROM Clientes
        WHERE LOWER(Nombre) LIKE '%' || LOWER(p_nombre) || '%';
        RETURN l_cursor;
    END buscar_clientes_nombre;

    FUNCTION buscar_clientes_email(p_email IN VARCHAR2) RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_Cliente, Nombre, Apellido, Telefono, Email
        FROM Clientes
        WHERE LOWER(Email) LIKE '%' || LOWER(p_email) || '%';
        RETURN l_cursor;
    END buscar_clientes_email;

    PROCEDURE insertar_cliente(p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_telefono IN VARCHAR2, p_email IN VARCHAR2) AS
    BEGIN
        INSERT INTO Clientes (Nombre, Apellido, Telefono, Email)
        VALUES (p_nombre, p_apellido, p_telefono, p_email);
    END insertar_cliente;

    PROCEDURE actualizar_cliente(p_id_cliente IN NUMBER, p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_telefono IN VARCHAR2, p_email IN VARCHAR2) AS
    BEGIN
        UPDATE Clientes
        SET Nombre = p_nombre, Apellido = p_apellido, Telefono = p_telefono, Email = p_email
        WHERE ID_Cliente = p_id_cliente;
    END actualizar_cliente;

    PROCEDURE eliminar_cliente(p_id_cliente IN NUMBER) AS
    BEGIN
        DELETE FROM Clientes WHERE ID_Cliente = p_id_cliente;
    END eliminar_cliente;
END pkg_clientes;
/


-- Segundo Paquete Direcciones
/
CREATE OR REPLACE PACKAGE PKG_DIRECCIONES AS
    FUNCTION buscar_direcciones_por_empleado(p_id_empleado IN NUMBER)
    RETURN SYS_REFCURSOR;

    FUNCTION buscar_direcciones_por_pedido(p_id_pedido IN NUMBER)
    RETURN SYS_REFCURSOR;
END PKG_DIRECCIONES;
/

/
CREATE OR REPLACE PACKAGE BODY PKG_DIRECCIONES AS
    FUNCTION buscar_direcciones_por_empleado(p_id_empleado IN NUMBER)
    RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_DIRECCION, DETALLES, ID_DISTRITO
        FROM Direcciones_Empleado
        WHERE ID_EMPLEADO = p_id_empleado;
        RETURN l_cursor;
    END buscar_direcciones_por_empleado;

    FUNCTION buscar_direcciones_por_pedido(p_id_pedido IN NUMBER)
    RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_DIRECCION, DETALLES, ID_DISTRITO
        FROM Direcciones_Pedido
        WHERE ID_PEDIDO = p_id_pedido;
        RETURN l_cursor;
    END buscar_direcciones_por_pedido;
END PKG_DIRECCIONES;
/


--Tercer paquete Pedidos 
/
CREATE OR REPLACE PACKAGE PKG_PEDIDOS AS
    FUNCTION buscar_pedido_ID(p_pedido_ID IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION buscar_pedido_ID_Estado(p_id_estado IN NUMBER) RETURN SYS_REFCURSOR;
    
    PROCEDURE insertar_pedido(
        p_id_cliente IN NUMBER,
        p_fecha IN DATE,
        p_id_estado IN NUMBER
    );
    
    PROCEDURE ver_pedido(
        p_id_pedido IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    );
    
    PROCEDURE actualizar_pedido(
        p_id_pedido IN NUMBER,
        p_id_cliente IN NUMBER,
        p_fecha IN DATE,
        p_id_estado IN NUMBER
    );
    
    PROCEDURE eliminar_pedido(
        p_id_pedido IN NUMBER
    );
END PKG_PEDIDOS;
/

/
CREATE OR REPLACE PACKAGE BODY PKG_PEDIDOS AS
    FUNCTION buscar_pedido_ID(p_pedido_ID IN NUMBER) RETURN SYS_REFCURSOR IS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_Pedido, ID_Cliente, Fecha, ID_Estado
        FROM Pedidos
        WHERE ID_Pedido = p_pedido_ID;
        RETURN l_cursor;
    END buscar_pedido_ID;

    FUNCTION buscar_pedido_ID_Estado(p_id_estado IN NUMBER) RETURN SYS_REFCURSOR IS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_Pedido, ID_Cliente, Fecha, ID_Estado
        FROM Pedidos
        WHERE ID_Estado = p_id_estado;
        RETURN l_cursor;
    END buscar_pedido_ID_Estado;
    PROCEDURE insertar_pedido(
        p_id_cliente IN NUMBER,
        p_fecha IN DATE,
        p_id_estado IN NUMBER
    ) AS
    BEGIN
        INSERT INTO Pedidos (ID_Cliente, Fecha, ID_Estado)
        VALUES (p_id_cliente, p_fecha, p_id_estado);
    END insertar_pedido;

    PROCEDURE ver_pedido(
        p_id_pedido IN NUMBER,
        p_cursor OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
        SELECT ID_Cliente, Fecha, ID_Estado
        FROM Pedidos
        WHERE ID_Pedido = p_id_pedido;
    END ver_pedido;

    PROCEDURE actualizar_pedido(
        p_id_pedido IN NUMBER,
        p_id_cliente IN NUMBER,
        p_fecha IN DATE,
        p_id_estado IN NUMBER
    ) AS
    BEGIN
        UPDATE Pedidos
        SET ID_Cliente = p_id_cliente,
            Fecha = p_fecha,
            ID_Estado = p_id_estado
        WHERE ID_Pedido = p_id_pedido;
    END actualizar_pedido;

    PROCEDURE eliminar_pedido(
        p_id_pedido IN NUMBER
    ) AS
    BEGIN
        DELETE FROM Pedidos
        WHERE ID_Pedido = p_id_pedido;
    END eliminar_pedido;
END PKG_PEDIDOS;
/



--Cuarto Paquete, empleados 
/
CREATE OR REPLACE PACKAGE pkg_empleados AS
    FUNCTION buscar_empleado_nombre(p_nombre IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION buscar_empleado_ID(p_Empleado_ID IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE insertar_empleado(p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_fecha_nacimiento IN DATE, p_fecha_contratacion IN DATE);
    PROCEDURE actualizar_empleado(p_id_empleado IN NUMBER, p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_fecha_nacimiento IN DATE, p_fecha_contratacion IN DATE);
    PROCEDURE eliminar_empleado(p_id_empleado IN NUMBER);
END pkg_empleados;
/

/
CREATE OR REPLACE PACKAGE BODY pkg_empleados AS
    FUNCTION buscar_empleado_nombre(p_nombre IN VARCHAR2) RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_Empleado, Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion
        FROM Empleados
        WHERE LOWER(Nombre) LIKE '%' || LOWER(p_nombre) || '%';
        RETURN l_cursor;
    END buscar_empleado_nombre;

    FUNCTION buscar_empleado_ID(p_Empleado_ID IN NUMBER) RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_Empleado, Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion
        FROM Empleados
        WHERE ID_Empleado = p_Empleado_ID;
        RETURN l_cursor;
    END buscar_empleado_ID;

    PROCEDURE insertar_empleado(p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_fecha_nacimiento IN DATE, p_fecha_contratacion IN DATE) AS
    BEGIN
        INSERT INTO Empleados (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion)
        VALUES (p_nombre, p_apellido, p_fecha_nacimiento, p_fecha_contratacion);
    END insertar_empleado;

    PROCEDURE actualizar_empleado(p_id_empleado IN NUMBER, p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_fecha_nacimiento IN DATE, p_fecha_contratacion IN DATE) AS
    BEGIN
        UPDATE Empleados
        SET Nombre = p_nombre, Apellido = p_apellido, Fecha_Nacimiento = p_fecha_nacimiento, Fecha_Contratacion = p_fecha_contratacion
        WHERE ID_Empleado = p_id_empleado;
    END actualizar_empleado;

    PROCEDURE eliminar_empleado(p_id_empleado IN NUMBER) AS
    BEGIN
        DELETE FROM Empleados WHERE ID_Empleado = p_id_empleado;
    END eliminar_empleado;
END pkg_empleados;
/


--Quinto Paquete Vehiculos

/
CREATE OR REPLACE PACKAGE pkg_vehiculos AS
    FUNCTION buscar_vehiculo_placa(p_placa IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION buscar_vehiculo_marca(p_marca IN VARCHAR2) RETURN SYS_REFCURSOR;
    PROCEDURE insertar_vehiculo(p_marca IN VARCHAR2, p_modelo IN VARCHAR2, p_anio IN NUMBER, p_placa IN VARCHAR2);
    PROCEDURE actualizar_vehiculo(p_id_vehiculo IN NUMBER, p_marca IN VARCHAR2, p_modelo IN VARCHAR2, p_anio IN NUMBER, p_placa IN VARCHAR2);
    PROCEDURE eliminar_vehiculo(p_id_vehiculo IN NUMBER);
END pkg_vehiculos;
/

/
CREATE OR REPLACE PACKAGE BODY pkg_vehiculos AS
    FUNCTION buscar_vehiculo_placa(p_placa IN VARCHAR2) RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_Vehiculo, Marca, Modelo, Anio, Placa
        FROM Vehiculos
        WHERE LOWER(Placa) LIKE '%' || LOWER(p_placa) || '%';
        RETURN l_cursor;
    END buscar_vehiculo_placa;

    FUNCTION buscar_vehiculo_marca(p_marca IN VARCHAR2) RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_Vehiculo, Marca, Modelo, Anio, Placa
        FROM Vehiculos
        WHERE LOWER(Marca) LIKE '%' || LOWER(p_marca) || '%';
        RETURN l_cursor;
    END buscar_vehiculo_marca;

    PROCEDURE insertar_vehiculo(p_marca IN VARCHAR2, p_modelo IN VARCHAR2, p_anio IN NUMBER, p_placa IN VARCHAR2) AS
    BEGIN
        INSERT INTO Vehiculos (Marca, Modelo, Anio, Placa)
        VALUES (p_marca, p_modelo, p_anio, p_placa);
    END insertar_vehiculo;

    PROCEDURE actualizar_vehiculo(p_id_vehiculo IN NUMBER, p_marca IN VARCHAR2, p_modelo IN VARCHAR2, p_anio IN NUMBER, p_placa IN VARCHAR2) AS
    BEGIN
        UPDATE Vehiculos
        SET Marca = p_marca, Modelo = p_modelo, Anio = p_anio, Placa = p_placa
        WHERE ID_Vehiculo = p_id_vehiculo;
    END actualizar_vehiculo;

    PROCEDURE eliminar_vehiculo(p_id_vehiculo IN NUMBER) AS
    BEGIN
        DELETE FROM Vehiculos WHERE ID_Vehiculo = p_id_vehiculo;
    END eliminar_vehiculo;
END pkg_vehiculos;
/


--Sexto paquete Facturas

/
CREATE OR REPLACE PACKAGE pkg_facturas AS
    FUNCTION buscar_factura_ID(p_factura_ID IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION buscar_factura_total(p_factura_total IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE insertar_factura(p_id_pedido IN NUMBER, p_fecha IN DATE, p_total IN NUMBER, p_id_estado IN NUMBER);
    PROCEDURE actualizar_factura(p_id_factura IN NUMBER, p_id_pedido IN NUMBER, p_fecha IN DATE, p_total IN NUMBER, p_id_estado IN NUMBER);
    PROCEDURE eliminar_factura(p_id_factura IN NUMBER);
END pkg_facturas;
/

/
CREATE OR REPLACE PACKAGE BODY pkg_facturas AS
    FUNCTION buscar_factura_ID(p_factura_ID IN NUMBER) RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
        FROM Facturas
        WHERE ID_Factura = p_factura_ID;
        RETURN l_cursor;
    END buscar_factura_ID;

    FUNCTION buscar_factura_total(p_factura_total IN NUMBER) RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
        FROM Facturas
        WHERE Total = p_factura_total;
        RETURN l_cursor;
    END buscar_factura_total;

    PROCEDURE insertar_factura(p_id_pedido IN NUMBER, p_fecha IN DATE, p_total IN NUMBER, p_id_estado IN NUMBER) AS
    BEGIN
        INSERT INTO Facturas (ID_Pedido, Fecha, Total, ID_Estado)
        VALUES (p_id_pedido, p_fecha, p_total, p_id_estado);
    END insertar_factura;

    PROCEDURE actualizar_factura(p_id_factura IN NUMBER, p_id_pedido IN NUMBER, p_fecha IN DATE, p_total IN NUMBER, p_id_estado IN NUMBER) AS
    BEGIN
        UPDATE Facturas
        SET ID_Pedido = p_id_pedido, Fecha = p_fecha, Total = p_total, ID_Estado = p_id_estado
        WHERE ID_Factura = p_id_factura;
    END actualizar_factura;

    PROCEDURE eliminar_factura(p_id_factura IN NUMBER) AS
    BEGIN
        DELETE FROM Facturas WHERE ID_Factura = p_id_factura;
    END eliminar_factura;
END pkg_facturas;
/

--Septimo paquete Licencias 
/
CREATE OR REPLACE PACKAGE PKG_LICENCIAS AS
    FUNCTION buscar_licencias_por_empleado(p_id_empleado IN NUMBER)
    RETURN SYS_REFCURSOR;
    
    FUNCTION buscar_licencia_por_id(p_id_licencia IN NUMBER)
    RETURN SYS_REFCURSOR;
    
    FUNCTION buscar_licencias_por_fecha(p_fecha_exp_inicio IN DATE, p_fecha_exp_fin IN DATE)
    RETURN SYS_REFCURSOR;
END PKG_LICENCIAS;
/

/
CREATE OR REPLACE PACKAGE BODY PKG_LICENCIAS AS

    FUNCTION buscar_licencias_por_empleado(p_id_empleado IN NUMBER)
    RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_EMPLEADO, ID_LICENCIA, FECHA_EXPEDICION, FECHA_VENCIMIENTO
        FROM Licencias_Empleado
        WHERE ID_EMPLEADO = p_id_empleado;
        RETURN l_cursor;
    END buscar_licencias_por_empleado;

    FUNCTION buscar_licencia_por_id(p_id_licencia IN NUMBER)
    RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_EMPLEADO, ID_LICENCIA, FECHA_EXPEDICION, FECHA_VENCIMIENTO
        FROM Licencias_Empleado
        WHERE ID_LICENCIA = p_id_licencia;
        RETURN l_cursor;
    END buscar_licencia_por_id;

    FUNCTION buscar_licencias_por_fecha(p_fecha_exp_inicio IN DATE, p_fecha_exp_fin IN DATE)
    RETURN SYS_REFCURSOR AS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_EMPLEADO, ID_LICENCIA, FECHA_EXPEDICION, FECHA_VENCIMIENTO
        FROM Licencias_Empleado
        WHERE FECHA_EXPEDICION BETWEEN p_fecha_exp_inicio AND p_fecha_exp_fin;
        RETURN l_cursor;
    END buscar_licencias_por_fecha;

END PKG_LICENCIAS;
/

--Octavo Paquete estados
/
CREATE OR REPLACE PACKAGE PKG_ESTADOS AS

    PROCEDURE insertar_estado(p_id_estado IN NUMBER, p_descripcion IN VARCHAR2);
    PROCEDURE actualizar_estado(p_id_estado IN NUMBER, p_descripcion IN VARCHAR2);
    PROCEDURE eliminar_estado(p_id_estado IN NUMBER);
    FUNCTION obtener_estado(p_id_estado IN NUMBER) RETURN SYS_REFCURSOR;

END PKG_ESTADOS;
/

/
CREATE OR REPLACE PACKAGE BODY PKG_ESTADOS AS

    PROCEDURE insertar_estado(p_id_estado IN NUMBER, p_descripcion IN VARCHAR2) IS
    BEGIN
        INSERT INTO Estados (ID_ESTADO, DESCRIPCION)
        VALUES (p_id_estado, p_descripcion);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error al insertar el estado: ' || SQLERRM);
    END insertar_estado;

    PROCEDURE actualizar_estado(p_id_estado IN NUMBER, p_descripcion IN VARCHAR2) IS
    BEGIN
        UPDATE Estados
        SET DESCRIPCION = p_descripcion
        WHERE ID_ESTADO = p_id_estado;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error al actualizar el estado: ' || SQLERRM);
    END actualizar_estado;

    PROCEDURE eliminar_estado(p_id_estado IN NUMBER) IS
    BEGIN
        DELETE FROM Estados
        WHERE ID_ESTADO = p_id_estado;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003, 'Error al eliminar el estado: ' || SQLERRM);
    END eliminar_estado;

    FUNCTION obtener_estado(p_id_estado IN NUMBER) RETURN SYS_REFCURSOR IS
        l_cursor SYS_REFCURSOR;
    BEGIN
        OPEN l_cursor FOR
        SELECT ID_ESTADO, DESCRIPCION
        FROM Estados
        WHERE ID_ESTADO = p_id_estado;
        RETURN l_cursor;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20004, 'Error al obtener el estado: ' || SQLERRM);
    END obtener_estado;

END PKG_ESTADOS;
/

--Noveno Paquete, Tipos Carga
/
CREATE OR REPLACE PACKAGE PKG_TIPO_CARGA AS
    PROCEDURE insertar_tipos(p_id_tipo NUMBER, p_descripcion VARCHAR2);
    PROCEDURE actualizar_tipos(p_id_tipo NUMBER, p_descripcion VARCHAR2);
    PROCEDURE eliminar_tipos(p_id_tipo NUMBER);
    FUNCTION obtener_tipos(p_id_tipo NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION obtener_todos_tipos RETURN SYS_REFCURSOR;
END PKG_TIPO_CARGA;
/

/
CREATE OR REPLACE PACKAGE BODY PKG_TIPO_CARGA AS

    PROCEDURE insertar_tipos(p_id_tipo NUMBER, p_descripcion VARCHAR2) IS
    BEGIN
        INSERT INTO tipos_carga (id_tipo, descripcion)
        VALUES (p_id_tipo, p_descripcion);
    END insertar_tipos;

    PROCEDURE actualizar_tipos(p_id_tipo NUMBER, p_descripcion VARCHAR2) IS
    BEGIN
        UPDATE tipos_carga
        SET descripcion = p_descripcion
        WHERE id_tipo = p_id_tipo;
    END actualizar_tipos;

    PROCEDURE eliminar_tipos(p_id_tipo NUMBER) IS
    BEGIN
        DELETE FROM tipos_carga
        WHERE id_tipo = p_id_tipo;
    END eliminar_tipos;

    FUNCTION obtener_tipos(p_id_tipo NUMBER) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
        SELECT id_tipo, descripcion
        FROM tipos_carga
        WHERE id_tipo = p_id_tipo;
        RETURN v_cursor;
    END obtener_tipos;

    FUNCTION obtener_todos_tipos RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
        SELECT id_tipo, descripcion
        FROM tipos_carga;
        RETURN v_cursor;
    END obtener_todos_tipos;

END PKG_TIPO_CARGA;
/




--Decimo paquete, Puestos
/
CREATE OR REPLACE PACKAGE PKG_PUESTOS AS
    PROCEDURE ver_puesto(
        p_id_puesto IN NUMBER,
        p_descripcion OUT VARCHAR2,
        p_salario OUT NUMBER
    );

    PROCEDURE ver_puestos(
        p_cursor OUT SYS_REFCURSOR
    );

    FUNCTION buscar_puestos_descripcion(p_descripcion IN VARCHAR2)
    RETURN SYS_REFCURSOR;
END PKG_PUESTOS;
/








-- INSERTS
-- Inserts para tabla Provincias
INSERT INTO Provincias (Nombre) VALUES ('San Jose');
INSERT INTO Provincias (Nombre) VALUES ('Heredia');
INSERT INTO Provincias (Nombre) VALUES ('Cartago');

-- Inserts para tabla Cantones
INSERT INTO Cantones (ID_Provincia, Nombre) VALUES (1, 'San Jose');
INSERT INTO Cantones (ID_Provincia, Nombre) VALUES (1, 'Escazu');
INSERT INTO Cantones (ID_Provincia, Nombre) VALUES (1, 'Desamparados ');

INSERT INTO Cantones (ID_Provincia, Nombre) VALUES (2, 'Heredia ');
INSERT INTO Cantones (ID_Provincia, Nombre) VALUES (2, 'Barva');
INSERT INTO Cantones (ID_Provincia, Nombre) VALUES (2, 'Santo Domingo');

INSERT INTO Cantones (ID_Provincia, Nombre) VALUES (3, 'Cartago ');
INSERT INTO Cantones (ID_Provincia, Nombre) VALUES (3, 'Paraiso');
INSERT INTO Cantones (ID_Provincia, Nombre) VALUES (3, 'La Union');

-- Inserts para tabla Distritos
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (1, 1, 'Carmen');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (1, 1, 'Merced');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (1, 1, 'Catedral');

INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (1, 2, 'Escazu');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (1, 2, 'San Antonio');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (1, 2, 'San Rafael');

INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (1, 3, 'Desamparados');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (1, 3, 'San Miguel');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (1, 3, 'San Rafael');

INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (2, 4, 'Heredia');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (2, 4, 'Mercedes');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (2, 4, 'Ulloa');

INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (2, 5, 'Barva');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (2, 5, 'San Pedro');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (2, 5, 'San Roque');

INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (2, 6, 'Santo Domingo');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (2, 6, 'Paracito');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (2, 6, 'Santa Rosa');

INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (3, 7, 'Oriental');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (3, 7, 'Occidental');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (3, 7, 'Carmen');

INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (3, 8, 'Paraíso');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (3, 8, 'Orosi');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (3, 8, 'Cachí');

INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (3, 9, 'Tres Ríos');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (3, 9, 'San Diego');
INSERT INTO Distritos (ID_Provincia, ID_Canton, Nombre) VALUES (3, 9, 'Concepción');

-- Inserts para tabla Licencias
INSERT INTO Licencias (Tipo) VALUES ('Tipo A1');
INSERT INTO Licencias (Tipo) VALUES ('Tipo A2');
INSERT INTO Licencias (Tipo) VALUES ('Tipo A3');

INSERT INTO Licencias (Tipo) VALUES ('Tipo B1');
INSERT INTO Licencias (Tipo) VALUES ('Tipo B2');
INSERT INTO Licencias (Tipo) VALUES ('Tipo B3');
INSERT INTO Licencias (Tipo) VALUES ('Tipo B4');

INSERT INTO Licencias (Tipo) VALUES ('Tipo C1');
INSERT INTO Licencias (Tipo) VALUES ('Tipo C2');

INSERT INTO Licencias (Tipo) VALUES ('Tipo D1');
INSERT INTO Licencias (Tipo) VALUES ('Tipo D2');
INSERT INTO Licencias (Tipo) VALUES ('Tipo D3');

INSERT INTO Licencias (Tipo) VALUES ('Tipo E1');
INSERT INTO Licencias (Tipo) VALUES ('Tipo E2');

-- Inserts para tabla Estados
INSERT INTO Estados (Descripcion) VALUES ('Cancelado');
INSERT INTO Estados (Descripcion) VALUES ('No aceptado');
INSERT INTO Estados (Descripcion) VALUES ('Aceptado');
INSERT INTO Estados (Descripcion) VALUES ('En Proceso');
INSERT INTO Estados (Descripcion) VALUES ('Entregado');
INSERT INTO Estados (Descripcion) VALUES ('Completado');

-- Inserts para tabla Tipos_Carga
-- Carga a granel: Este tipo de carga incluye materiales como granos, minerales, petróleo, gas, entre otros. Son transportados en grandes cantidades y no requieren embalaje.
-- Carga general: Este tipo de carga incluye mercancías empaquetadas individualmente, como electrodomésticos, muebles, y productos electrónicos.
-- Carga fraccionada: Este tipo de carga incluye mercancías que son demasiado grandes para ser enviadas como carga general, pero demasiado pequeñas para requerir un camión completo.
-- Carga de contenedor: Este tipo de carga se transporta en contenedores estandarizados que pueden ser cargados y descargados, apilados, transportados de manera eficiente a largas distancias.
-- Carga pesada o sobredimensionada: Este tipo de carga es demasiado grande o pesada para ser transportada en un camión estándar o contenedor. Puede requerir permisos especiales y equipos de manejo especializados.
-- Carga peligrosa: Este tipo de carga incluye materiales que son potencialmente peligrosos, como productos químicos, materiales radiactivos y explosivos.
-- Carga refrigerada: Este tipo de carga requiere control de temperatura durante el transporte. Incluye alimentos, productos farmacéuticos y ciertos productos químicos.
INSERT INTO Tipos_Carga (Descripcion) VALUES ('Carga a granel');
INSERT INTO Tipos_Carga (Descripcion) VALUES ('Carga general');
INSERT INTO Tipos_Carga (Descripcion) VALUES ('Carga fraccionada');
INSERT INTO Tipos_Carga (Descripcion) VALUES ('Carga de contenedor');
INSERT INTO Tipos_Carga (Descripcion) VALUES ('Carga pesada o sobredimensionada');
INSERT INTO Tipos_Carga (Descripcion) VALUES ('Carga peligrosa');
INSERT INTO Tipos_Carga (Descripcion) VALUES ('Carga refrigerada');

-- Inserts para tabla Puestos
INSERT INTO Puestos (ID_Puesto, Salario, Descripcion) VALUES ('DRV-01', 750000, 'Conductor Nivel 1');
INSERT INTO Puestos (ID_Puesto, Salario, Descripcion) VALUES ('DRV-02', 900000, 'Conductor Nivel 2');
INSERT INTO Puestos (ID_Puesto, Salario, Descripcion) VALUES ('DRV-03', 1100000, 'Conductor Nivel 3');
INSERT INTO Puestos (ID_Puesto, Salario, Descripcion) VALUES ('LOG-MGR', 920000, 'Administrador de Logistica');
INSERT INTO Puestos (ID_Puesto, Salario, Descripcion) VALUES ('STR-MGR', 800000, 'Administrador de Almacen');
INSERT INTO Puestos (ID_Puesto, Salario, Descripcion) VALUES ('DRV-MGR', 1000000, 'Administrador de Conductores');
INSERT INTO Puestos (ID_Puesto, Salario, Descripcion) VALUES ('MTN-TEC', 850000, 'Tecnico de Mantenimiento');
INSERT INTO Puestos (ID_Puesto, Salario, Descripcion) VALUES ('MTN-ENG', 1300000, 'Ingeniero de Mantenimiento');

-- Inserts para tabla Vehiculos
-- Vehículos de carga liviana
INSERT INTO Vehiculos (Marca, Modelo, Anio, Placa) VALUES ('Toyota', 'Hilux', 2018, 'CMV-000');
INSERT INTO Vehiculos (Marca, Modelo, Anio, Placa) VALUES ('Nissan', 'Navara', 2019, 'CMV-002');
INSERT INTO Vehiculos (Marca, Modelo, Anio, Placa) VALUES ('Mitsubishi', 'L200', 2020, 'CMV-004');
INSERT INTO Vehiculos (Marca, Modelo, Anio, Placa) VALUES ('Ford', 'Ranger', 2021, 'CMV-006');

-- Vehículos de carga pesada
INSERT INTO Vehiculos (Marca, Modelo, Anio, Placa) VALUES ('Volvo', 'FH', 2016, '567890');
INSERT INTO Vehiculos (Marca, Modelo, Anio, Placa) VALUES ('Scania', 'R450', 2017, '678901');
INSERT INTO Vehiculos (Marca, Modelo, Anio, Placa) VALUES ('Mercedes-Benz', 'Actros', 2018, '789012');
INSERT INTO Vehiculos (Marca, Modelo, Anio, Placa) VALUES ('MAN', 'TGX', 2019, '890123');

-- Inserts para tabla Empleados
INSERT INTO Empleados (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto) VALUES ('Juan', 'Perez', TO_DATE('2003-03-03', 'YYYY-MM-DD'), TO_DATE('2020-01-01', 'YYYY-MM-DD'), 'DRV-01');
INSERT INTO Empleados (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto) VALUES ('Maria', 'Gonzalez', TO_DATE('1998-08-08', 'YYYY-MM-DD'), TO_DATE('2021-11-11', 'YYYY-MM-DD'), 'DRV-02');
INSERT INTO Empleados (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto) VALUES ('Pedro', 'Rodriguez', TO_DATE('1994-04-04', 'YYYY-MM-DD'), TO_DATE('2022-02-02', 'YYYY-MM-DD'), 'DRV-03');
INSERT INTO Empleados (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto) VALUES ('Ana', 'Jimenez', TO_DATE('1995-05-05', 'YYYY-MM-DD'), TO_DATE('2024-12-22', 'YYYY-MM-DD'), 'MTN-TEC');
INSERT INTO Empleados (Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto) VALUES ('Luis', 'Hernandez', TO_DATE('1990-10-10', 'YYYY-MM-DD'), TO_DATE('2023-03-03', 'YYYY-MM-DD'), 'MTN-ENG');

-- Inserts para tabla Licencias_Empleado
INSERT INTO Licencias_Empleado (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento) VALUES (1, 1, TO_DATE('2020-01-01', 'YYYY-MM-DD'), TO_DATE('2025-01-01', 'YYYY-MM-DD'));
INSERT INTO Licencias_Empleado (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento) VALUES (2, 2, TO_DATE('2021-11-11', 'YYYY-MM-DD'), TO_DATE('2026-11-11', 'YYYY-MM-DD'));
INSERT INTO Licencias_Empleado (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento) VALUES (3, 3, TO_DATE('2022-02-02', 'YYYY-MM-DD'), TO_DATE('2027-02-02', 'YYYY-MM-DD'));
INSERT INTO Licencias_Empleado (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento) VALUES (4, 4, TO_DATE('2024-12-22', 'YYYY-MM-DD'), TO_DATE('2029-12-22', 'YYYY-MM-DD'));
INSERT INTO Licencias_Empleado (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento) VALUES (5, 5, TO_DATE('2023-03-03', 'YYYY-MM-DD'), TO_DATE('2028-03-03', 'YYYY-MM-DD'));
INSERT INTO Licencias_Empleado (ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento) VALUES (2, 13, TO_DATE('2030-03-03', 'YYYY-MM-DD'), TO_DATE('2035-03-03', 'YYYY-MM-DD'));

-- Inserts para tabla Direcciones_Empleado
INSERT INTO Direcciones_Empleado (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles) VALUES (1, 1, 1, 1, 'Calle 1, Casa 2');
INSERT INTO Direcciones_Empleado (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles) VALUES (2, 2, 4, 10, 'Calle 2, Casa 3');
INSERT INTO Direcciones_Empleado (ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles) VALUES (3, 3, 7, 19, 'Calle 3, Casa 4');

-- Inserts para tabla Pedidos
INSERT INTO Pedidos (Descripcion, ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ('Pedido 1', 1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 3, 1);
INSERT INTO Pedidos (Descripcion, ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ('Pedido 2', 2, 2, 2, TO_DATE('2022-02-02', 'YYYY-MM-DD'), 3, 2);
INSERT INTO Pedidos (Descripcion, ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado) VALUES ('Pedido 3', 4, 3, 3, TO_DATE('2022-03-03', 'YYYY-MM-DD'), 3, 3);

-- Inserts para tabla Direcciones_Pedido
INSERT INTO Direcciones_Pedido (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles) VALUES (1, 1, 1, 1, 'Test insert direccion pedido 1');
INSERT INTO Direcciones_Pedido (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles) VALUES (2, 2, 4, 10, 'Test insert direccion pedido 2');
INSERT INTO Direcciones_Pedido (ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles) VALUES (5, 3, 7, 19, 'Test insert direccion pedido 3');

-- Inserts para tabla Clientes
-- Inserts para tabla Clientes
INSERT INTO Clientes (Nombre, Apellido, Telefono, Email) VALUES ('Karla', 'Gómez', '1111-1111', 'karla@gomez.com');
INSERT INTO Clientes (Nombre, Apellido, Telefono, Email) VALUES ('Carlos', 'Hernández', '2222-2222', 'carlos@hdz.com');
INSERT INTO Clientes (Nombre, Apellido, Telefono, Email) VALUES ('Luis', 'Martínez', '3333-3333', 'lusm@cosevi.com');

-- Inserts para tabla Facturas
INSERT INTO Facturas (Fecha, Total, ID_Estado) VALUES (TO_DATE('1988-08-08', 'YYYY-MM-DD'), 100000, 6);
INSERT INTO Facturas (Fecha, Total, ID_Estado) VALUES (TO_DATE('1999-09-09', 'YYYY-MM-DD'), 200000, 5);
INSERT INTO Facturas (Fecha, Total, ID_Estado) VALUES (TO_DATE('2000-10-10', 'YYYY-MM-DD'), 300000, 4);
-- Tablas ordenadas
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

CREATE TABLE Empleados (
    ID_Empleado NUMBER PRIMARY KEY,
    Nombre VARCHAR2(50),
    Apellido VARCHAR2(50),
    Fecha_Nacimiento DATE,
    Fecha_Contratacion DATE
);

CREATE TABLE Licencias (
    ID_Licencia NUMBER PRIMARY KEY,
    Tipos VARCHAR2(50)
);

CREATE TABLE Puestos (
    ID_Puesto NUMBER PRIMARY KEY,
    Salario NUMBER,
    Descripcion VARCHAR2(100)
);

CREATE TABLE Estados (
    ID_Estado NUMBER PRIMARY KEY,
    Descripcion VARCHAR2(100)
);

CREATE TABLE Vehiculos (
    ID_Vehiculo NUMBER PRIMARY KEY,
    Marca VARCHAR2(50),
    Modelo VARCHAR2(50),
    Anio NUMBER,
    Placa VARCHAR2(10)
);

CREATE TABLE Tipos_Carga (
    ID_Tipos NUMBER PRIMARY KEY,
    Descripcion VARCHAR2(100)
);

CREATE TABLE Pedidos (
    ID_Pedido NUMBER PRIMARY KEY,
    ID_Cliente NUMBER,
    Fecha DATE,
    Total NUMBER,
    ID_Estado NUMBER,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Estado) REFERENCES Estados(ID_Estado)
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

CREATE TABLE Puestos_Empleado (
    ID_Empleado NUMBER,
    ID_Puesto NUMBER,
    Salario NUMBER,
    PRIMARY KEY (ID_Empleado, ID_Puesto),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Puesto) REFERENCES Puestos(ID_Puesto)
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

CREATE TABLE Facturas (
    ID_Factura NUMBER PRIMARY KEY,
    ID_Pedido NUMBER,
    Fecha DATE,
    Total NUMBER,
    ID_Estado NUMBER,
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido),
    FOREIGN KEY (ID_Estado) REFERENCES Estados(ID_Estado)
);


//Vistas


CREATE OR REPLACE VIEW Vista_Clientes_Direcciones AS
SELECT 
    c.ID_Cliente,
    c.Nombre,
    c.Apellido,
    d.Detalles AS Direccion,
    p.Nombre AS Provincia,
    ct.Nombre AS Canton,
    dt.Nombre AS Distrito
FROM 
    Clientes c
    JOIN Direcciones_Cliente d ON c.ID_Cliente = d.ID_Direccion
    JOIN Provincias p ON d.ID_Provincia = p.ID_Provincia
    JOIN Cantones ct ON d.ID_Canton = ct.ID_Canton
    JOIN Distritos dt ON d.ID_Distrito = dt.ID_Distrito;



CREATE OR REPLACE VIEW Vista_Empleados_Puestos AS
SELECT 
    e.ID_Empleado,
    e.Nombre,
    e.Apellido,
    p.Descripcion AS Puesto,
    pe.Salario
FROM 
    Empleados e
    JOIN Puestos_Empleado pe ON e.ID_Empleado = pe.ID_Empleado
    JOIN Puestos p ON pe.ID_Puesto = p.ID_Puesto;
    
    
    CREATE OR REPLACE VIEW Vista_Pedidos_Estados AS
SELECT 
    p.ID_Pedido,
    c.Nombre AS Cliente,
    p.Fecha,
    e.Descripcion AS Estado
FROM 
    Pedidos p
    JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
    JOIN Estados e ON p.ID_Estado = e.ID_Estado;
    
    CREATE OR REPLACE VIEW Vista_Vehiculos_Empleados AS
SELECT 
    v.ID_Vehiculo,
    v.Marca,
    v.Modelo,
    v.Anio,
    e.Nombre AS Conductor
FROM 
    Vehiculos v
    JOIN Direcciones_Empleado de ON v.ID_Vehiculo = de.ID_Direccion
    JOIN Empleados e ON de.ID_Empleado = e.ID_Empleado;
    
    CREATE OR REPLACE VIEW Vista_Facturacion_Pedidos AS
SELECT 
    f.ID_Factura,
    p.ID_Pedido,
    c.Nombre AS Cliente,
    f.Fecha,
    e.Descripcion AS Estado
FROM 
    Facturas f
    JOIN Pedidos p ON f.ID_Pedido = p.ID_Pedido
    JOIN Clientes c ON p.ID_Cliente = c.ID_Cliente
    JOIN Estados e ON f.ID_Estado = e.ID_Estado;


//PAQUETES 


// Primer paquete Clientes
CREATE OR REPLACE PACKAGE pkg_clientes AS
    FUNCTION buscar_clientes_nombre(p_nombre IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION buscar_clientes_email(p_email IN VARCHAR2) RETURN SYS_REFCURSOR;
    PROCEDURE insertar_cliente(p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_telefono IN VARCHAR2, p_email IN VARCHAR2);
    PROCEDURE actualizar_cliente(p_id_cliente IN NUMBER, p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_telefono IN VARCHAR2, p_email IN VARCHAR2);
    PROCEDURE eliminar_cliente(p_id_cliente IN NUMBER);
END pkg_clientes;
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
CREATE OR REPLACE PACKAGE PKG_DIRECCIONES AS
    FUNCTION buscar_direcciones_por_empleado(p_id_empleado IN NUMBER)
    RETURN SYS_REFCURSOR;

    FUNCTION buscar_direcciones_por_pedido(p_id_pedido IN NUMBER)
    RETURN SYS_REFCURSOR;
END PKG_DIRECCIONES;
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

CREATE OR REPLACE PACKAGE pkg_empleados AS
    FUNCTION buscar_empleado_nombre(p_nombre IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION buscar_empleado_ID(p_Empleado_ID IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE insertar_empleado(p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_fecha_nacimiento IN DATE, p_fecha_contratacion IN DATE);
    PROCEDURE actualizar_empleado(p_id_empleado IN NUMBER, p_nombre IN VARCHAR2, p_apellido IN VARCHAR2, p_fecha_nacimiento IN DATE, p_fecha_contratacion IN DATE);
    PROCEDURE eliminar_empleado(p_id_empleado IN NUMBER);
END pkg_empleados;
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

CREATE OR REPLACE PACKAGE pkg_vehiculos AS
    FUNCTION buscar_vehiculo_placa(p_placa IN VARCHAR2) RETURN SYS_REFCURSOR;
    FUNCTION buscar_vehiculo_marca(p_marca IN VARCHAR2) RETURN SYS_REFCURSOR;
    PROCEDURE insertar_vehiculo(p_marca IN VARCHAR2, p_modelo IN VARCHAR2, p_anio IN NUMBER, p_placa IN VARCHAR2);
    PROCEDURE actualizar_vehiculo(p_id_vehiculo IN NUMBER, p_marca IN VARCHAR2, p_modelo IN VARCHAR2, p_anio IN NUMBER, p_placa IN VARCHAR2);
    PROCEDURE eliminar_vehiculo(p_id_vehiculo IN NUMBER);
END pkg_vehiculos;
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

CREATE OR REPLACE PACKAGE pkg_facturas AS
    FUNCTION buscar_factura_ID(p_factura_ID IN NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION buscar_factura_total(p_factura_total IN NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE insertar_factura(p_id_pedido IN NUMBER, p_fecha IN DATE, p_total IN NUMBER, p_id_estado IN NUMBER);
    PROCEDURE actualizar_factura(p_id_factura IN NUMBER, p_id_pedido IN NUMBER, p_fecha IN DATE, p_total IN NUMBER, p_id_estado IN NUMBER);
    PROCEDURE eliminar_factura(p_id_factura IN NUMBER);
END pkg_facturas;
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
CREATE OR REPLACE PACKAGE PKG_LICENCIAS AS
    FUNCTION buscar_licencias_por_empleado(p_id_empleado IN NUMBER)
    RETURN SYS_REFCURSOR;
    
    FUNCTION buscar_licencia_por_id(p_id_licencia IN NUMBER)
    RETURN SYS_REFCURSOR;
    
    FUNCTION buscar_licencias_por_fecha(p_fecha_exp_inicio IN DATE, p_fecha_exp_fin IN DATE)
    RETURN SYS_REFCURSOR;
END PKG_LICENCIAS;
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
CREATE OR REPLACE PACKAGE PKG_ESTADOS AS

    PROCEDURE insertar_estado(p_id_estado IN NUMBER, p_descripcion IN VARCHAR2);
    PROCEDURE actualizar_estado(p_id_estado IN NUMBER, p_descripcion IN VARCHAR2);
    PROCEDURE eliminar_estado(p_id_estado IN NUMBER);
    FUNCTION obtener_estado(p_id_estado IN NUMBER) RETURN SYS_REFCURSOR;

END PKG_ESTADOS;
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
CREATE OR REPLACE PACKAGE PKG_TIPO_CARGA AS
    PROCEDURE insertar_tipos(p_id_tipo NUMBER, p_descripcion VARCHAR2);
    PROCEDURE actualizar_tipos(p_id_tipo NUMBER, p_descripcion VARCHAR2);
    PROCEDURE eliminar_tipos(p_id_tipo NUMBER);
    FUNCTION obtener_tipos(p_id_tipo NUMBER) RETURN SYS_REFCURSOR;
    FUNCTION obtener_todos_tipos RETURN SYS_REFCURSOR;
END PKG_TIPO_CARGA;
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





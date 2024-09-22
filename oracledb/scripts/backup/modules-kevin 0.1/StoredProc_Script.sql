-- Script para crear los SPs de la base de datos

/* SP de objeto Empleado */
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

CREATE OR REPLACE PROCEDURE ver_empleados (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Empleado, Nombre, Apellido, Fecha_Nacimiento, Fecha_Contratacion, ID_Puesto
    FROM Empleados;
END ver_empleados;


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

CREATE OR REPLACE PROCEDURE eliminar_empleado (
    p_id_empleado IN NUMBER
) AS
BEGIN
    DELETE FROM Empleados
    WHERE ID_Empleado = p_id_empleado;
END eliminar_empleado;

/* SP de objeto Cliente */
CREATE OR REPLACE PROCEDURE insertar_cliente (
    p_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
) AS
BEGIN
    INSERT INTO Clientes (Nombre, Apellido, Telefono, Correo)
    VALUES (p_nombre, p_apellido, p_telefono, p_correo);
END insertar_cliente;

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

CREATE OR REPLACE PROCEDURE eliminar_cliente (
    p_id_cliente IN NUMBER
) AS
BEGIN
    DELETE FROM Clientes
    WHERE ID_Cliente = p_id_cliente;
END eliminar_cliente;

CREATE OR REPLACE PROCEDURE ver_clientes (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Cliente, Nombre, Apellido, Telefono, Email
    FROM Clientes;
END ver_clientes;

/* SP de objeto Provincia */
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

CREATE OR REPLACE PROCEDURE ver_provincias (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Provincia, Nombre
    FROM Provincias;
END ver_provincias;

/* SP de objeto Canton */
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

CREATE OR REPLACE PROCEDURE ver_cantones (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Canton, Nombre, ID_Provincia
    FROM Cantones;
END ver_cantones;

/* SP de objeto Distrito */
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

CREATE OR REPLACE PROCEDURE ver_distritos (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Distrito, Nombre, ID_Canton
    FROM Distritos;
END ver_distritos;


/* SP de objeto DireccionCliente */
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

-- DROP PROCEDURE ver_direcciones_clientes;
CREATE OR REPLACE PROCEDURE ver_direcciones_clientes(
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Direccion, ID_Cliente, Detalles, ID_Distrito
    FROM Direcciones_Cliente;
END ver_direcciones_clientes;

CREATE OR REPLACE PROCEDURE eliminar_direccion_cliente (
    p_id_direccion IN NUMBER
) AS
BEGIN
    DELETE FROM Direcciones_Cliente
    WHERE ID_Direccion = p_id_direccion;
END eliminar_direccion_cliente;

-- SP de objeto Licencia
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

CREATE OR REPLACE PROCEDURE ver_licencias (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Licencia, Tipo
    FROM Licencias;
END ver_licencias;

-- SP de objeto Estado
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

CREATE OR REPLACE PROCEDURE ver_estados (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Estado, Descripcion
    FROM Estados;
END ver_estados;

-- SP de objeto Tipos_Carga
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
-- Test ver_tipo_carga
DECLARE
    v_descripcion Tipos_Carga.Descripcion%TYPE;
BEGIN
    ver_tipo_carga(1, v_descripcion);
    DBMS_OUTPUT.PUT_LINE('Descripcion: ' || v_descripcion);
END;

CREATE OR REPLACE PROCEDURE ver_tipos_carga (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Tipo, Descripcion
    FROM Tipos_Carga;
END ver_tipos_carga;

-- SP de objeto Puesto
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

CREATE OR REPLACE PROCEDURE ver_puestos (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Puesto, Descripcion, Salario
    FROM Puestos;
END ver_puestos;

-- SP de objeto Vehiculo
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

CREATE OR REPLACE PROCEDURE ver_vehiculos (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Vehiculo, Marca, Modelo, Anio, Placa
    FROM Vehiculos;
END ver_vehiculos;

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

-- SP de objeto Licencia_Empleado
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

CREATE OR REPLACE PROCEDURE ver_licencias_empleados (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Licencia_Empleado, ID_Empleado, ID_Licencia, Fecha_Expedicion, Fecha_Vencimiento
    FROM Licencias_Empleado;
END ver_licencias_empleados;

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

CREATE OR REPLACE PROCEDURE eliminar_licencia_empleado (
    p_id_licencia_empleado IN NUMBER
) AS
BEGIN
    DELETE FROM Licencias_Empleado
    WHERE ID_Licencia_Empleado = p_id_licencia_empleado;
END eliminar_licencia_empleado;

-- SP de objeto Direccion_Empleado
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

-- Test ver_direccion_empleado
DECLARE
    v_id_empleado Direcciones_Empleado.ID_Empleado%TYPE;
    v_detalles Direcciones_Empleado.Detalles%TYPE;
    v_id_distrito Direcciones_Empleado.ID_Distrito%TYPE;
BEGIN
    ver_direccion_empleado(3, v_id_empleado, v_detalles, v_id_distrito);
    DBMS_OUTPUT.PUT_LINE('ID_Empleado: ' || v_id_empleado);
    DBMS_OUTPUT.PUT_LINE('Detalles: ' || v_detalles);
    DBMS_OUTPUT.PUT_LINE('ID_Distrito: ' || v_id_distrito);
END;


CREATE OR REPLACE PROCEDURE ver_direcciones_empleados (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Direccion, ID_Empleado, ID_Provincia, ID_Canton, ID_Distrito, Detalles
    FROM Direcciones_Empleado;
END ver_direcciones_empleados;

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

CREATE OR REPLACE PROCEDURE eliminar_direccion_empleado (
    p_id_direccion IN NUMBER
) AS
BEGIN
    DELETE FROM Direcciones_Empleado
    WHERE ID_Direccion = p_id_direccion;
END eliminar_direccion_empleado;

-- SP de objeto Pedido
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

CREATE OR REPLACE PROCEDURE ver_pedidos (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Pedido, Descripcion, ID_Cliente, ID_Vehiculo, ID_Tipo_Carga, Fecha, ID_Estado, ID_Licencia_Empleado
    FROM Pedidos;
END ver_pedidos;

-- Test ver_pedidos
DECLARE
    v_id_pedido Pedidos.ID_Pedido%TYPE;
    v_descripcion Pedidos.Descripcion%TYPE;
    v_id_cliente Pedidos.ID_Cliente%TYPE;
    v_id_vehiculo Pedidos.ID_Vehiculo%TYPE;
    v_id_tipo_carga Pedidos.ID_Tipo_Carga%TYPE;
    v_fecha Pedidos.Fecha%TYPE;
    v_id_estado Pedidos.ID_Estado%TYPE;
    v_id_licencia_empleado Pedidos.ID_Licencia_Empleado%TYPE;
    v_cursor SYS_REFCURSOR;
BEGIN
    ver_pedidos(v_cursor);
    LOOP
        FETCH v_cursor INTO v_id_pedido, v_descripcion, v_id_cliente, v_id_vehiculo, v_id_tipo_carga, v_fecha, v_id_estado, v_id_licencia_empleado;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID_Pedido: ' || v_id_pedido);
        DBMS_OUTPUT.PUT_LINE('Descripcion: ' || v_descripcion);
        DBMS_OUTPUT.PUT_LINE('ID_Cliente: ' || v_id_cliente);
        DBMS_OUTPUT.PUT_LINE('ID_Vehiculo: ' || v_id_vehiculo);
        DBMS_OUTPUT.PUT_LINE('ID_Tipo_Carga: ' || v_id_tipo_carga);
        DBMS_OUTPUT.PUT_LINE('Fecha: ' || v_fecha);
        DBMS_OUTPUT.PUT_LINE('ID_Estado: ' || v_id_estado);
        DBMS_OUTPUT.PUT_LINE('ID_Licencia_Empleado: ' || v_id_licencia_empleado);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
    CLOSE v_cursor;
END;

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

CREATE OR REPLACE PROCEDURE eliminar_pedido (
    p_id_pedido IN NUMBER
) AS
BEGIN
    DELETE FROM Pedidos
    WHERE ID_Pedido = p_id_pedido;
END eliminar_pedido;

-- SP de objeto Direcciones_Pedido
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

CREATE OR REPLACE PROCEDURE ver_direcciones_pedidos (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Direccion, ID_Pedido, ID_Provincia, ID_Canton, ID_Distrito, Detalles
    FROM Direcciones_Pedido;
END ver_direcciones_pedidos;

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

CREATE OR REPLACE PROCEDURE eliminar_direccion_pedido (
    p_id_direccion IN NUMBER
) AS
BEGIN
    DELETE FROM Direcciones_Pedido
    WHERE ID_Direccion = p_id_direccion;
END eliminar_direccion_pedido;


-- SP de objeto Factura
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

CREATE OR REPLACE PROCEDURE ver_facturas (
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT ID_Factura, ID_Pedido, Fecha, Total, ID_Estado
    FROM Facturas;
END ver_facturas;

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

CREATE OR REPLACE PROCEDURE eliminar_factura (
    p_id_factura IN NUMBER
) AS
BEGIN
    DELETE FROM Facturas
    WHERE ID_Factura = p_id_factura;
END eliminar_factura;
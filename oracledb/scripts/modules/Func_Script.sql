
-- Clientes
-- Function to search clients by a string in their name
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

-- Test function
SET SERVEROUTPUT ON;
DECLARE
    l_cursor SYS_REFCURSOR;
    l_record Clientes%ROWTYPE;
BEGIN
    l_cursor := buscar_clientes_nombre('ale');
    LOOP
        FETCH l_cursor INTO l_record;
        EXIT WHEN l_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID_Cliente: ' || l_record.ID_Cliente);
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || l_record.Nombre);
        DBMS_OUTPUT.PUT_LINE('Apellido: ' || l_record.Apellido);
        DBMS_OUTPUT.PUT_LINE('Telefono: ' || l_record.Telefono);
        DBMS_OUTPUT.PUT_LINE('Email: ' || l_record.Email);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
    CLOSE l_cursor;
END;

-- Function to search clients by a string in their email
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

-- Function to search directions by client ID
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

-- Function to search direction by employee ID
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

-- Function to search order by client ID
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

-- Function to search direction by Order ID
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

-- Function to search license_employee by employee ID
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

-- Test function
SET SERVEROUTPUT ON;
DECLARE
    l_cursor SYS_REFCURSOR;
    l_record Licencias_Empleado%ROWTYPE;
BEGIN
    l_cursor := buscar_licencias_por_empleado(1);
    LOOP
        FETCH l_cursor INTO l_record;
        EXIT WHEN l_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID_Licencia: ' || l_record.ID_Licencia);
        DBMS_OUTPUT.PUT_LINE('ID_Empleado: ' || l_record.ID_Empleado);
        DBMS_OUTPUT.PUT_LINE('Fecha_Expedicion: ' || l_record.Fecha_Expedicion);
        DBMS_OUTPUT.PUT_LINE('Fecha_Vencimiento: ' || l_record.Fecha_Vencimiento);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
    CLOSE l_cursor;
END;

-- Function to search invoice by order ID
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

--busca empleado por Nombre
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


DECLARE
    l_cursor SYS_REFCURSOR;
    l_record Empleados%ROWTYPE;
BEGIN
    l_cursor := buscar_empleado_nombre('Brandon');
    LOOP
        FETCH l_cursor INTO l_record;
        EXIT WHEN l_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID_Empleado: ' || l_record.ID_Empleado);
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || l_record.Nombre);
        DBMS_OUTPUT.PUT_LINE('Apellido: ' || l_record.Apellido);
        DBMS_OUTPUT.PUT_LINE('Fecha_Nacimiento: ' || l_record.Fecha_Nacimiento);
        DBMS_OUTPUT.PUT_LINE('Fecha_Contratacion: ' || l_record.Fecha_Contratacion);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
    CLOSE l_cursor;
END;

--buscar empleado por ID_Empleado
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

--buscar vehiculo por placa
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

--busca vehiculo por marca
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

--busca pedido por id
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

--busca pedido por id_Estado
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

--busca facturas por ID
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

--buscar facturas por Total
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

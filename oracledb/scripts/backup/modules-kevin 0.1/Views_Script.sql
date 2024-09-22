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
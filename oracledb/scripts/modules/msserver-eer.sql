-- TABLES
CREATE TABLE fide_estados_tb (
    id_estado INT NOT NULL,
    descripcion VARCHAR(50)
);

CREATE TABLE fide_roles_tb (
    id_rol INT NOT NULL,
    descripcion VARCHAR(50),
    id_estado INT
);

CREATE TABLE fide_usuarios_tb (
    id_usuario INT NOT NULL,
    usuario VARCHAR(50),
    contrasena VARCHAR(255),
    id_rol INT,
    id_estado INT
);

CREATE TABLE fide_categorias_tb (
    id_categoria INT NOT NULL,
    descripcion VARCHAR(50),
    id_estado INT
);

CREATE TABLE fide_productos_tb (
    id_producto INT NOT NULL,
    nombre VARCHAR(50),
    descripcion VARCHAR(100),
    id_categoria INT,
    id_estado INT
);

CREATE TABLE fide_vehiculos_tb (
    id_vehiculo INT NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    anio INT,
    placa VARCHAR(10),
    id_estado INT
);

CREATE TABLE fide_licencias_tb (
    id_licencia INT NOT NULL,
    tipo VARCHAR(50),
    id_estado INT
);

CREATE TABLE fide_puestos_tb (
    id_puesto VARCHAR(10) NOT NULL,
    salario DECIMAL(10, 2),
    descripcion VARCHAR(100),
    id_estado INT
);

CREATE TABLE fide_tipos_carga_tb (
    id_tipo_carga INT NOT NULL,
    descripcion VARCHAR(50),
    id_estado INT
);

CREATE TABLE fide_empleados_tb (
    id_empleado INT NOT NULL,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    fecha_nacimiento DATE,
    fecha_contratacion DATE,
    id_puesto VARCHAR(10),
    id_estado INT
);

CREATE TABLE fide_licencias_empleado_tb (
    id_licencia_empleado INT NOT NULL,
    id_empleado INT,
    id_licencia INT,
    fecha_expedicion DATE,
    fecha_vencimiento DATE,
    id_estado INT
);

CREATE TABLE fide_clientes_tb (
    id_cliente INT NOT NULL,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    telefono VARCHAR(15),
    email VARCHAR(100),
    id_estado INT
);

CREATE TABLE fide_provincias_tb (
    id_provincia INT NOT NULL,
    nombre VARCHAR(50),
    id_estado INT
);

CREATE TABLE fide_cantones_tb (
    id_canton INT NOT NULL,
    id_provincia INT,
    nombre VARCHAR(50),
    id_estado INT
);

CREATE TABLE fide_distritos_tb (
    id_distrito INT NOT NULL,
    id_provincia INT,
    id_canton INT,
    nombre VARCHAR(50),
    id_estado INT
);

CREATE TABLE fide_pedidos_tb (
    id_pedido INT NOT NULL,
    id_cliente INT,
    id_vehiculo INT,
    id_tipo_carga INT,
    fecha DATE,
    id_estado INT,
    id_licencia_empleado INT
);

CREATE TABLE fide_detalles_pedido_tb (
    id_detalle INT NOT NULL,
    id_pedido INT,
    id_producto INT,
    cantidad DECIMAL(10, 2),
    unidad_masa VARCHAR(10),
    id_estado INT
);

CREATE TABLE fide_facturas_tb (
    id_factura INT NOT NULL,
    id_pedido INT,
    fecha DATE,
    total DECIMAL(10, 2),
    id_estado INT
);

CREATE TABLE fide_direcciones_empleado_tb (
    id_direccion INT NOT NULL,
    id_empleado INT,
    id_provincia INT,
    id_canton INT,
    id_distrito INT,
    detalles VARCHAR(100),
    id_estado INT
);

CREATE TABLE fide_direcciones_pedido_tb (
    id_direccion INT NOT NULL,
    id_pedido INT,
    id_provincia INT,
    id_canton INT,
    id_distrito INT,
    detalles VARCHAR(100),
    id_estado INT
);

CREATE TABLE fide_direcciones_cliente_tb (
    id_direccion INT NOT NULL,
    id_cliente INT,
    id_provincia INT,
    id_canton INT,
    id_distrito INT,
    detalles VARCHAR(100),
    id_estado INT
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
CREATE DATABASE Le_Dukes_bar;

-- Operaciones de Venta y Servicio 

CREATE TABLE Clientes (
    cliente_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Mesas (
    mesa_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_mesa VARCHAR(50) UNIQUE NOT NULL,
    capacidad SMALLINT NOT NULL 
);

CREATE TABLE Metodos_Pago (
    metodo_pago_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_metodo VARCHAR(50) UNIQUE NOT NULL,
    es_digital BOOLEAN
);

CREATE TABLE Pedidos (
    pedido_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    empleado_id INT NOT NULL,
    mesa_id INT,
    fecha_hora_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tipo_pedido VARCHAR(20) NOT NULL,
    estado_pedido VARCHAR(20) NOT NULL,
    monto_final_neto DECIMAL(10, 2) NOT NULL,

    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
    FOREIGN KEY (empleado_id) REFERENCES Empleados(empleado_id),
    FOREIGN KEY (mesa_id) REFERENCES Mesas(mesa_id)
);

CREATE TABLE Detalle_Pedido (
    pedido_id INT NOT NULL,
    item_id INT NOT NULL,
    cantidad SMALLINT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal_linea DECIMAL(10, 2) NOT NULL,

    PRIMARY KEY (pedido_id, item_id),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (item_id) REFERENCES Menu_Items(item_id)
);

CREATE TABLE Reservas (
    reserva_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    mesa_id INT NOT NULL,
    fecha_hora_reserva DATETIME NOT NULL,
    cantidad_personas SMALLINT NOT NULL,
    motivo VARCHAR(50),

    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
    FOREIGN KEY (mesa_id) REFERENCES Mesas(mesa_id)
);

CREATE TABLE Pagos (
    pago_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT UNIQUE NOT NULL, -- Generalmente un pedido tiene un solo pago final
    metodo_pago_id INT NOT NULL,
    monto_pagado DECIMAL(10, 2) NOT NULL,
    fecha_hora_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado_pago VARCHAR(20) NOT NULL,

    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (metodo_pago_id) REFERENCES Metodos_Pago(metodo_pago_id)
);

CREATE TABLE Repartidores (
    repartidor_id INT PRIMARY KEY AUTO_INCREMENT,
    empleado_id INT,
    nombre_empresa_delivery VARCHAR(50) NOT NULL,

    FOREIGN KEY (empleado_id) REFERENCES Empleados(empleado_id)
);

CREATE TABLE Servicios_Delivery (
    servicio_delivery_id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT UNIQUE NOT NULL,
    repartidor_id INT NOT NULL,
    direccion_entrega VARCHAR(255) NOT NULL,
    tarifa_delivery DECIMAL(10, 2),
    estado_delivery VARCHAR(20) NOT NULL,

    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (repartidor_id) REFERENCES Repartidores(repartidor_id)
); 	

-- Inventario y Menu

CREATE TABLE Categorias_Menu (
    categoria_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR(50) UNIQUE NOT NULL
);

 CREATE TABLE Menu_Items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    categoria_id INT NOT NULL,
    nombre_item VARCHAR(100) UNIQUE NOT NULL,
    precio_venta DECIMAL(10, 2) NOT NULL,
    es_activo BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (categoria_id) REFERENCES Categorias_Menu(categoria_id)
);

CREATE TABLE Ingredientes (
    ingrediente_id INT PRIMARY KEY AUTO_INCREMENT,
    proveedor_principal_id INT,
    nombre_ingrediente VARCHAR(100) UNIQUE NOT NULL,
    unidad_medida VARCHAR(20) NOT NULL,
    costo_unidad_promedio DECIMAL(10, 2),

    FOREIGN KEY (proveedor_principal_id) REFERENCES Proveedores(proveedor_id)
);

CREATE TABLE Recetas (
    item_id INT NOT NULL,
    ingrediente_id INT NOT NULL,
    cantidad_requerida DECIMAL(8, 3) NOT NULL,

    PRIMARY KEY (item_id, ingrediente_id),
    FOREIGN KEY (item_id) REFERENCES Menu_Items(item_id),
    FOREIGN KEY (ingrediente_id) REFERENCES Ingredientes(ingrediente_id)
);

CREATE TABLE Movimientos_Stock (
    movimiento_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ingrediente_id INT NOT NULL,
    empleado_id INT NOT NULL,
    tipo_movimiento VARCHAR(50) NOT NULL,
    cantidad_afectada DECIMAL(10, 3) NOT NULL,
    fecha_hora_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,

    FOREIGN KEY (ingrediente_id) REFERENCES Ingredientes(ingrediente_id),
    FOREIGN KEY (empleado_id) REFERENCES Empleados(empleado_id)
);

-- Gestión de Negocio y Finanzas

CREATE TABLE Proveedores (
    proveedor_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_proveedor VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    contacto_principal VARCHAR(100)
);

CREATE TABLE Cargos (
    cargo_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre_cargo VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Empleados (
    empleado_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    cargo_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    
    FOREIGN KEY (cargo_id) REFERENCES Cargos(cargo_id)
);

CREATE TABLE Costos_Fijos (
    costo_id INT PRIMARY KEY AUTO_INCREMENT,
    tipo_costo VARCHAR(50) NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_periodo DATE NOT NULL
);

   CREATE TABLE Facturas_Compra (
    factura_compra_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    proveedor_id INT NOT NULL,
    empleado_id INT NOT NULL,
    monto_total DECIMAL(10, 2) NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE,
    estado_pago VARCHAR(20) NOT NULL,

    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(proveedor_id),
    FOREIGN KEY (empleado_id) REFERENCES Empleados(empleado_id)
);
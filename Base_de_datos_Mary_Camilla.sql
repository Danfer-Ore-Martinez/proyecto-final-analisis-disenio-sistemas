-- Base de datos propuesta para Inversiones Mary Camilla E.I.R.L.
-- Motor sugerido: MySQL 8.0
CREATE DATABASE IF NOT EXISTS mary_camilla;
USE mary_camilla;

CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  razon_social VARCHAR(150) NOT NULL,
  direccion VARCHAR(220) NOT NULL,
  telefono VARCHAR(25),
  correo VARCHAR(120)
);

CREATE TABLE preventista (
  id_preventista INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  telefono VARCHAR(25),
  activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  unidad_medida VARCHAR(30) NOT NULL,
  precio_venta DECIMAL(10,2) NOT NULL,
  stock_actual DECIMAL(12,2) NOT NULL DEFAULT 0,
  activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE almacen (
  id_almacen INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  ubicacion VARCHAR(180) NOT NULL
);

CREATE TABLE pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  id_preventista INT NOT NULL,
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado ENUM('Registrado','En preparación','Preparado','En reparto','Entregado','Cancelado') NOT NULL DEFAULT 'Registrado',
  observacion VARCHAR(250),
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  FOREIGN KEY (id_preventista) REFERENCES preventista(id_preventista)
);

CREATE TABLE detalle_pedido (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad DECIMAL(12,2) NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
  UNIQUE (id_pedido, id_producto)
);

CREATE TABLE picker (
  id_picker INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  telefono VARCHAR(25)
);

CREATE TABLE preparacion (
  id_preparacion INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_picker INT NOT NULL,
  id_almacen INT NOT NULL,
  fecha_programada DATETIME,
  fecha_preparacion DATETIME,
  estado ENUM('Pendiente','En proceso','Completa','Observada') NOT NULL DEFAULT 'Pendiente',
  FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
  FOREIGN KEY (id_picker) REFERENCES picker(id_picker),
  FOREIGN KEY (id_almacen) REFERENCES almacen(id_almacen)
);

CREATE TABLE vehiculo (
  id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(15) NOT NULL UNIQUE,
  capacidad_kg DECIMAL(10,2),
  activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE empleado_reparto (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  cargo ENUM('Conductor','Repartidor') NOT NULL,
  telefono VARCHAR(25)
);

CREATE TABLE entrega (
  id_entrega INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_vehiculo INT NOT NULL,
  id_conductor INT NOT NULL,
  id_repartidor INT NOT NULL,
  fecha_salida DATETIME,
  fecha_entrega DATETIME,
  estado ENUM('Programada','En camino','Entregada','No entregada','Devuelta') NOT NULL DEFAULT 'Programada',
  FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
  FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
  FOREIGN KEY (id_conductor) REFERENCES empleado_reparto(id_empleado),
  FOREIGN KEY (id_repartidor) REFERENCES empleado_reparto(id_empleado)
);

CREATE TABLE guia_revision (
  id_guia INT AUTO_INCREMENT PRIMARY KEY,
  id_entrega INT NOT NULL,
  fecha_revision DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  observacion VARCHAR(250),
  conforme BOOLEAN NOT NULL DEFAULT TRUE,
  FOREIGN KEY (id_entrega) REFERENCES entrega(id_entrega)
);

CREATE TABLE pago (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  monto DECIMAL(10,2) NOT NULL,
  metodo ENUM('Efectivo','Transferencia','Otro') NOT NULL,
  estado ENUM('Pendiente','Pagado','Anulado') NOT NULL DEFAULT 'Pagado',
  FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);

CREATE TABLE incidencia (
  id_incidencia INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_entrega INT NULL,
  tipo ENUM('Sin stock','Cliente ausente','Producto diferente','Producto faltante','Rechazo del pedido','Otro') NOT NULL,
  descripcion VARCHAR(300) NOT NULL,
  resolucion VARCHAR(300) NOT NULL,
  fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado ENUM('Pendiente','Resuelta','Cancelada') NOT NULL DEFAULT 'Pendiente',
  FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
  FOREIGN KEY (id_entrega) REFERENCES entrega(id_entrega)
);

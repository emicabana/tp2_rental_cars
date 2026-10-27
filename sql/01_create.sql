CREATE DATABASE IF NOT EXISTS RENTAL_CARS
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE RENTAL_CARS;

CREATE TABLE SUCURSALES (
    id        INT          NOT NULL AUTO_INCREMENT,
    nombre    VARCHAR(80)  NOT NULL,
    direccion VARCHAR(120),
    ciudad    VARCHAR(50)  NOT NULL,
    telefono  VARCHAR(30),
    CONSTRAINT PK_SUCURSALES PRIMARY KEY (id)
);

CREATE TABLE CATEGORIAS (
    id          INT          NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(50)  NOT NULL,
    descripcion VARCHAR(120),
    CONSTRAINT PK_CATEGORIAS PRIMARY KEY (id),
    CONSTRAINT UQ_CATEGORIAS_NOMBRE UNIQUE (nombre)
);

CREATE TABLE CLIENTES (
    id                INT          NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(50)  NOT NULL,
    email             VARCHAR(50),
    telefono          VARCHAR(50),
    ciudad            VARCHAR(50),
    fecha_registro    DATE         NOT NULL,
    licencia_conducir VARCHAR(30)  NOT NULL,
    CONSTRAINT PK_CLIENTES PRIMARY KEY (id),
    CONSTRAINT UQ_CLIENTES_LICENCIA UNIQUE (licencia_conducir)
);

CREATE TABLE EMPLEADOS (
    id            INT           NOT NULL AUTO_INCREMENT,
    nombre        VARCHAR(80)   NOT NULL,
    cargo         VARCHAR(50)   NOT NULL,
    id_sucursal   INT           NOT NULL,
    fecha_ingreso DATE          NOT NULL,
    salario       DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_EMPLEADOS PRIMARY KEY (id),
    CONSTRAINT FK_EMPLEADOS_SUCURSAL FOREIGN KEY (id_sucursal)
        REFERENCES SUCURSALES (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE VEHICULOS (
    id           INT           NOT NULL AUTO_INCREMENT,
    marca        VARCHAR(50)   NOT NULL,
    modelo       VARCHAR(50)   NOT NULL,
    anio         INT           NOT NULL,
    precio_dia   DECIMAL(9,2)  NOT NULL,
    estado       TINYINT(1)    NOT NULL DEFAULT 1,
    id_categoria INT           NOT NULL,
    id_sucursal  INT           NOT NULL,
    patente      VARCHAR(15)   NOT NULL,
    km_actual    INT           NOT NULL DEFAULT 0,
    CONSTRAINT PK_VEHICULOS PRIMARY KEY (id),
    CONSTRAINT UQ_VEHICULOS_PATENTE UNIQUE (patente),
    CONSTRAINT FK_VEHICULOS_CATEGORIA FOREIGN KEY (id_categoria)
        REFERENCES CATEGORIAS (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_VEHICULOS_SUCURSAL FOREIGN KEY (id_sucursal)
        REFERENCES SUCURSALES (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ALQUILERES (
    id_alquiler            INT           NOT NULL AUTO_INCREMENT,
    id_cliente             INT           NOT NULL,
    id_vehiculo            INT           NOT NULL,
    fecha_inicio           DATE          NOT NULL,
    fecha_fin              DATE          NOT NULL,
    total                  DECIMAL(9,2)  NOT NULL,
    id_empleado            INT           NOT NULL,
    id_sucursal_retiro     INT           NOT NULL,
    id_sucursal_devolucion INT           NOT NULL,
    estado                 VARCHAR(20)   NOT NULL,
    CONSTRAINT PK_ALQUILERES PRIMARY KEY (id_alquiler),
    CONSTRAINT FK_ALQUILERES_CLIENTE FOREIGN KEY (id_cliente)
        REFERENCES CLIENTES (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_ALQUILERES_VEHICULO FOREIGN KEY (id_vehiculo)
        REFERENCES VEHICULOS (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_ALQUILERES_EMPLEADO FOREIGN KEY (id_empleado)
        REFERENCES EMPLEADOS (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_ALQUILERES_SUC_RETIRO FOREIGN KEY (id_sucursal_retiro)
        REFERENCES SUCURSALES (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_ALQUILERES_SUC_DEVOLUCION FOREIGN KEY (id_sucursal_devolucion)
        REFERENCES SUCURSALES (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE RESERVAS (
    id            INT         NOT NULL AUTO_INCREMENT,
    id_cliente    INT         NOT NULL,
    id_vehiculo   INT         NOT NULL,
    fecha_reserva DATE        NOT NULL,
    fecha_inicio  DATE        NOT NULL,
    fecha_fin     DATE        NOT NULL,
    estado        VARCHAR(20) NOT NULL,
    CONSTRAINT PK_RESERVAS PRIMARY KEY (id),
    CONSTRAINT FK_RESERVAS_CLIENTE FOREIGN KEY (id_cliente)
        REFERENCES CLIENTES (id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT FK_RESERVAS_VEHICULO FOREIGN KEY (id_vehiculo)
        REFERENCES VEHICULOS (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE PAGOS (
    id          INT           NOT NULL AUTO_INCREMENT,
    id_alquiler INT           NOT NULL,
    fecha_pago  DATE          NOT NULL,
    monto       DECIMAL(9,2)  NOT NULL,
    CONSTRAINT PK_PAGOS PRIMARY KEY (id),
    CONSTRAINT FK_PAGOS_ALQUILER FOREIGN KEY (id_alquiler)
        REFERENCES ALQUILERES (id_alquiler)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE SEGUROS (
    id            INT           NOT NULL AUTO_INCREMENT,
    id_alquiler   INT           NOT NULL,
    compania      VARCHAR(80)   NOT NULL,
    numero_poliza VARCHAR(50)   NOT NULL,
    cobertura     VARCHAR(100),
    costo         DECIMAL(9,2)  NOT NULL,
    CONSTRAINT PK_SEGUROS PRIMARY KEY (id),
    CONSTRAINT UQ_SEGUROS_POLIZA UNIQUE (numero_poliza),
    CONSTRAINT FK_SEGUROS_ALQUILER FOREIGN KEY (id_alquiler)
        REFERENCES ALQUILERES (id_alquiler)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE MULTAS (
    id          INT           NOT NULL AUTO_INCREMENT,
    id_alquiler INT           NOT NULL,
    fecha       DATE          NOT NULL,
    motivo      VARCHAR(120)  NOT NULL,
    monto       DECIMAL(9,2)  NOT NULL,
    pagada      TINYINT(1)    NOT NULL DEFAULT 0,
    CONSTRAINT PK_MULTAS PRIMARY KEY (id),
    CONSTRAINT FK_MULTAS_ALQUILER FOREIGN KEY (id_alquiler)
        REFERENCES ALQUILERES (id_alquiler)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE CHECK_ALQUILER (
    id                INT          NOT NULL AUTO_INCREMENT,
    id_alquiler       INT          NOT NULL,
    tipo              VARCHAR(10)  NOT NULL,
    fecha             DATETIME     NOT NULL,
    km                INT          NOT NULL,
    nivel_combustible INT          NOT NULL,
    CONSTRAINT PK_CHECK_ALQUILER PRIMARY KEY (id),
    CONSTRAINT FK_CHECK_ALQUILER_ALQUILER FOREIGN KEY (id_alquiler)
        REFERENCES ALQUILERES (id_alquiler)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE MANTENIMIENTOS (
    id            INT           NOT NULL AUTO_INCREMENT,
    id_vehiculo   INT           NOT NULL,
    fecha         DATE          NOT NULL,
    tipo          VARCHAR(50)   NOT NULL,
    costo         DECIMAL(9,2)  NOT NULL,
    observaciones VARCHAR(200),
    CONSTRAINT PK_MANTENIMIENTOS PRIMARY KEY (id),
    CONSTRAINT FK_MANTENIMIENTOS_VEHICULO FOREIGN KEY (id_vehiculo)
        REFERENCES VEHICULOS (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
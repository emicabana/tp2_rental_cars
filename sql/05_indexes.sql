SET NAMES utf8mb4;
USE RENTAL_CARS;

-- Consulta 2.1 / 2.16: orden y mínimo por año del vehículo
CREATE INDEX IDX_VEHICULOS_ANIO ON VEHICULOS (anio);

-- Consulta 2.19: vehículos más caros por día
CREATE INDEX IDX_VEHICULOS_PRECIO_DIA ON VEHICULOS (precio_dia);

-- Consulta 2.2: clientes por fecha de registro
CREATE INDEX IDX_CLIENTES_FECHA_REGISTRO ON CLIENTES (fecha_registro);

-- Consulta 2.4: búsqueda de empleados por nombre (LIKE 'L%')
CREATE INDEX IDX_EMPLEADOS_NOMBRE ON EMPLEADOS (nombre);

-- Consulta 2.18 y vista de ingresos: alquileres por estado y fecha de inicio
CREATE INDEX IDX_ALQUILERES_ESTADO_FECHA ON ALQUILERES (estado, fecha_inicio);

-- Consulta 2.20: multas por estado de pago
CREATE INDEX IDX_MULTAS_PAGADA ON MULTAS (pagada);

-- Consulta 2.15: sucursales por ciudad
CREATE INDEX IDX_SUCURSALES_CIUDAD ON SUCURSALES (ciudad);

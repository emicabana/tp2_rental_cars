SET NAMES utf8mb4;
USE RENTAL_CARS;

-- 3.1 Nuevo cliente: licencia nueva y ciudad existente en el sistema (San Juan)
INSERT INTO CLIENTES (nombre, email, telefono, ciudad, fecha_registro, licencia_conducir)
VALUES ('Rocío Ibarra', 'rocio.ibarra@mail.com', '264-5551009', 'San Juan', CURDATE(), 'LIC-0009');

-- 3.2 Actualizar salario a 200000.00 de los vendedores/as que ingresaron antes del 2021-01-01
UPDATE EMPLEADOS
SET salario = 200000.00
WHERE cargo IN ('Vendedor', 'Vendedora')
  AND fecha_ingreso < '2021-01-01';

-- 3.3 Borrar un vehículo específico (el 10: Peugeot 208) Se verifica que no tenga alquileres, reservas ni mantenimientos asociados, para evitar el error de integridad referencial.
DELETE FROM VEHICULOS
WHERE id = 10
  AND NOT EXISTS (SELECT 1 FROM ALQUILERES     WHERE id_vehiculo = 10)
  AND NOT EXISTS (SELECT 1 FROM RESERVAS       WHERE id_vehiculo = 10)
  AND NOT EXISTS (SELECT 1 FROM MANTENIMIENTOS WHERE id_vehiculo = 10);

-- 3.4 Cambio de sucursal: el vehículo 9 (Fiat Cronos) se traslada de la sucursal 4 (Córdoba) a la sucursal 3 (Mendoza)
UPDATE VEHICULOS
SET id_sucursal = 3
WHERE id = 9;

-- Restricciones de validación (ALTER TABLE)
ALTER TABLE CHECK_ALQUILER
    ADD CONSTRAINT CHK_CHECK_ALQUILER_TIPO
        CHECK (tipo IN ('salida', 'entrada')),
    ADD CONSTRAINT CHK_CHECK_ALQUILER_COMBUSTIBLE
        CHECK (nivel_combustible BETWEEN 0 AND 100);

ALTER TABLE ALQUILERES
    ADD CONSTRAINT CHK_ALQUILERES_ESTADO
        CHECK (estado IN ('activo', 'finalizado', 'cancelado'));

ALTER TABLE RESERVAS
    ADD CONSTRAINT CHK_RESERVAS_ESTADO
        CHECK (estado IN ('pendiente', 'confirmada', 'cancelada'));

ALTER TABLE EMPLEADOS
    ADD CONSTRAINT CHK_EMPLEADOS_SALARIO
        CHECK (salario > 0);
SET NAMES utf8mb4;
USE RENTAL_CARS;

DELIMITER $$

-- 6.1 Registrar un alquiler. El procedimiento no recibe sucursales, así que el retiro y la devolución se asignan a la sucursal donde está el vehículo.
DROP PROCEDURE IF EXISTS SP_REGISTRAR_ALQUILER$$
CREATE PROCEDURE SP_REGISTRAR_ALQUILER (
    IN p_id_cliente   INT,
    IN p_id_vehiculo  INT,
    IN p_id_empleado  INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin    DATE
)
BEGIN
    DECLARE v_estado      TINYINT(1);
    DECLARE v_precio_dia  DECIMAL(9,2);
    DECLARE v_id_sucursal INT;
    DECLARE v_dias        INT;
    DECLARE v_total       DECIMAL(9,2);
    DECLARE v_existe      INT DEFAULT 0;

    IF NOT EXISTS (SELECT 1 FROM CLIENTES WHERE id = p_id_cliente) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: el cliente no existe';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM EMPLEADOS WHERE id = p_id_empleado) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: el empleado no existe';
    END IF;

    SELECT COUNT(*) INTO v_existe FROM VEHICULOS WHERE id = p_id_vehiculo;
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: el vehículo no existe';
    END IF;

    SELECT estado, precio_dia, id_sucursal
      INTO v_estado, v_precio_dia, v_id_sucursal
    FROM VEHICULOS
    WHERE id = p_id_vehiculo;

    -- a) Verificar que el vehículo esté disponible (estado = TRUE)
    IF v_estado <> TRUE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: el vehículo no está disponible';
    END IF;

    IF p_fecha_fin <= p_fecha_inicio THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: la fecha de fin debe ser posterior a la fecha de inicio';
    END IF;

    -- b) Calcular el total: días de alquiler x precio por día
    SET v_dias  = DATEDIFF(p_fecha_fin, p_fecha_inicio);
    SET v_total = v_dias * v_precio_dia;

    -- c) Insertar el alquiler con estado 'activo' (los triggers registran la auditoría y marcan el vehículo como no disponible)
    INSERT INTO ALQUILERES
        (id_cliente, id_vehiculo, fecha_inicio, fecha_fin, total,
         id_empleado, id_sucursal_retiro, id_sucursal_devolucion, estado)
    VALUES
        (p_id_cliente, p_id_vehiculo, p_fecha_inicio, p_fecha_fin, v_total,
         p_id_empleado, v_id_sucursal, v_id_sucursal, 'activo');

    -- d) Mensaje de éxito
    SELECT 'Alquiler registrado correctamente' AS mensaje,
           LAST_INSERT_ID()                    AS id_alquiler,
           v_total                             AS total;
END$$

-- 6.2 Registrar una multa
DROP PROCEDURE IF EXISTS SP_CALCULAR_MULTA$$
CREATE PROCEDURE SP_CALCULAR_MULTA (
    IN p_id_alquiler INT,
    IN p_motivo      VARCHAR(120),
    IN p_monto       DECIMAL(9,2)
)
BEGIN
    -- a) Verificar que el alquiler exista
    IF NOT EXISTS (SELECT 1 FROM ALQUILERES WHERE id_alquiler = p_id_alquiler) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: el alquiler no existe';
    END IF;

    -- b) Insertar la multa (pagada = FALSE, fecha actual)
    INSERT INTO MULTAS (id_alquiler, fecha, motivo, monto, pagada)
    VALUES (p_id_alquiler, CURDATE(), p_motivo, p_monto, FALSE);

    -- c) Mensaje de éxito
    SELECT 'Multa registrada correctamente' AS mensaje;
END$$

DELIMITER ;

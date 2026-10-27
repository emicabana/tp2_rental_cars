SET NAMES utf8mb4;
USE RENTAL_CARS;

-- Tabla de auditoría (debe existir antes del trigger 5.1)
CREATE TABLE IF NOT EXISTS AUDITORIA_ALQUILERES (
    id_auditoria   INT          NOT NULL AUTO_INCREMENT,
    id_alquiler    INT          NOT NULL,
    id_cliente     INT          NOT NULL,
    id_vehiculo    INT          NOT NULL,
    fecha_registro DATETIME     NOT NULL,
    accion         VARCHAR(50)  NOT NULL,
    CONSTRAINT PK_AUDITORIA_ALQUILERES PRIMARY KEY (id_auditoria)
) ENGINE = InnoDB;

DELIMITER $$

-- 5.1 Auditoría: después de insertar un alquiler
DROP TRIGGER IF EXISTS TR_AUDITAR_ALQUILER$$
CREATE TRIGGER TR_AUDITAR_ALQUILER
AFTER INSERT ON ALQUILERES
FOR EACH ROW
BEGIN
    INSERT INTO AUDITORIA_ALQUILERES
        (id_alquiler, id_cliente, id_vehiculo, fecha_registro, accion)
    VALUES
        (NEW.id_alquiler, NEW.id_cliente, NEW.id_vehiculo, NOW(), 'NUEVO ALQUILER');
END$$

-- 5.2 Si el alquiler se inserta 'activo', el vehículo pasa a no disponible
DROP TRIGGER IF EXISTS TR_ACTUALIZAR_ESTADO_VEHICULO$$
CREATE TRIGGER TR_ACTUALIZAR_ESTADO_VEHICULO
AFTER INSERT ON ALQUILERES
FOR EACH ROW
BEGIN
    IF NEW.estado = 'activo' THEN
        UPDATE VEHICULOS
        SET estado = FALSE
        WHERE id = NEW.id_vehiculo;
    END IF;
END$$

DELIMITER ;

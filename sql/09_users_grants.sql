SET NAMES utf8mb4;
USE RENTAL_CARS;

-- 7.1 Usuario vendedor
CREATE USER IF NOT EXISTS 'vendedor_user'@'localhost'
    IDENTIFIED BY 'V3nd3dor#Rental2026!';

-- 7.2 Solo lectura sobre VEHICULOS, CATEGORIAS y SUCURSALES
GRANT SELECT ON RENTAL_CARS.VEHICULOS  TO 'vendedor_user'@'localhost';
GRANT SELECT ON RENTAL_CARS.CATEGORIAS TO 'vendedor_user'@'localhost';
GRANT SELECT ON RENTAL_CARS.SUCURSALES TO 'vendedor_user'@'localhost';

-- 7.3 Lectura y escritura sobre ALQUILERES y PAGOS (registra alquileres y cobros)
GRANT SELECT, INSERT, UPDATE, DELETE ON RENTAL_CARS.ALQUILERES TO 'vendedor_user'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON RENTAL_CARS.PAGOS      TO 'vendedor_user'@'localhost';

-- 7.4 Administrador con todos los privilegios sobre la base completa
CREATE USER IF NOT EXISTS 'admin_user'@'localhost'
    IDENTIFIED BY 'Adm1n_Rental#2026!';

GRANT ALL PRIVILEGES ON RENTAL_CARS.* TO 'admin_user'@'localhost';

-- 7.5 Revocar DELETE sobre ALQUILERES al vendedor
REVOKE DELETE ON RENTAL_CARS.ALQUILERES FROM 'vendedor_user'@'localhost';

FLUSH PRIVILEGES;


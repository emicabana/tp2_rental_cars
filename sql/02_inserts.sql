SET NAMES utf8mb4;
USE RENTAL_CARS;

INSERT INTO SUCURSALES (id, nombre, direccion, ciudad, telefono) VALUES
    (1, 'Sucursal Centro',     'Av. Libertador 450',  'San Juan', '264-4201111'),
    (2, 'Sucursal Aeropuerto', 'Ruta 20 km 12',       'San Juan', '264-4202222'),
    (3, 'Sucursal Mendoza',    'Av. San Martín 1200', 'Mendoza',  '261-4303333'),
    (4, 'Sucursal Córdoba',    'Bv. Chacabuco 800',   'Córdoba',  '351-4404444');

INSERT INTO CATEGORIAS (id, nombre, descripcion) VALUES
    (1, 'Económico', 'Autos compactos de bajo consumo'),
    (2, 'Sedán',     'Autos medianos de cuatro puertas'),
    (3, 'SUV',       'Vehículos utilitarios deportivos'),
    (4, 'Premium',   'Autos de alta gama');

INSERT INTO CLIENTES (id, nombre, email, telefono, ciudad, fecha_registro, licencia_conducir) VALUES
    (1, 'Lucía Fernández',  'lucia.fernandez@mail.com',  '264-5551001', 'San Juan',     '2023-05-12', 'LIC-0001'),
    (2, 'Martín Gómez',     'martin.gomez@mail.com',     '261-5551002', 'Mendoza',      '2023-09-03', 'LIC-0002'),
    (3, 'Sofía Ledesma',    'sofia.ledesma@mail.com',    '351-5551003', 'Córdoba',
        LAST_DAY(CURDATE() - INTERVAL 2 MONTH) + INTERVAL 3  DAY, 'LIC-0003'),
    (4, 'Diego Paz',        'diego.paz@mail.com',        '264-5551004', 'San Juan',
        LAST_DAY(CURDATE() - INTERVAL 2 MONTH) + INTERVAL 10 DAY, 'LIC-0004'),
    (5, 'Valeria Quiroga',  'valeria.quiroga@mail.com',  '261-5551005', 'Mendoza',      '2024-02-20', 'LIC-0005'),
    (6, 'Nicolás Ortega',   'nicolas.ortega@mail.com',   '351-5551006', 'Córdoba',      '2024-07-15', 'LIC-0006'),
    (7, 'Camila Herrera',   'camila.herrera@mail.com',   '264-5551007', 'San Juan',
        LAST_DAY(CURDATE() - INTERVAL 2 MONTH) + INTERVAL 18 DAY, 'LIC-0007'),
    (8, 'Federico Molina',  'federico.molina@mail.com',  '11-55551008', 'Buenos Aires', '2024-10-05', 'LIC-0008');

INSERT INTO EMPLEADOS (id, nombre, cargo, id_sucursal, fecha_ingreso, salario) VALUES
    (1, 'Laura Benítez',    'Gerente',        1, '2019-03-01', 350000.00),
    (2, 'Leandro Cabrera',  'Vendedor',       1, '2020-06-15', 180000.00),
    (3, 'Carla Domínguez',  'Vendedora',      2, '2020-11-20', 180000.00),
    (4, 'Pablo Reyes',      'Vendedor',       3, '2022-02-10', 180000.00),
    (5, 'Lorena Suárez',    'Vendedora',      4, '2018-08-01', 175000.00),
    (6, 'Gustavo Rivas',    'Mecánico',       2, '2021-04-05', 220000.00),
    (7, 'Ana Torres',       'Administrativa', 3, '2023-01-09', 160000.00);

INSERT INTO VEHICULOS (id, marca, modelo, anio, precio_dia, estado, id_categoria, id_sucursal, patente, km_actual) VALUES
    (1,  'Toyota',        'Etios',        2018, 18000.00, 1, 1, 1, 'AB123CD', 62000),
    (2,  'Volkswagen',    'Gol Trend',    2019, 17500.00, 1, 1, 1, 'AC234DE', 48000),
    (3,  'Chevrolet',     'Cruze',        2020, 28000.00, 1, 2, 2, 'AD345EF', 35000),
    (4,  'Toyota',        'Corolla',      2021, 30000.00, 0, 2, 2, 'AE456FG', 28000),
    (5,  'Ford',          'EcoSport',     2019, 35000.00, 1, 3, 3, 'AF567GH', 41000),
    (6,  'Jeep',          'Renegade',     2022, 42000.00, 0, 3, 3, 'AG678HI', 19000),
    (7,  'BMW',           'Serie 3',      2023, 75000.00, 1, 4, 4, 'AH789IJ', 12000),
    (8,  'Mercedes-Benz', 'Clase C',      2022, 85000.00, 1, 4, 4, 'AI890JK', 15000),
    (9,  'Fiat',          'Cronos',       2020, 20000.00, 1, 1, 4, 'AJ901KL', 33000),
    (10, 'Peugeot',       '208',          2017, 16000.00, 1, 1, 1, 'AK012LM', 87000);

INSERT INTO ALQUILERES (id_alquiler, id_cliente, id_vehiculo, fecha_inicio, fecha_fin, total,
                        id_empleado, id_sucursal_retiro, id_sucursal_devolucion, estado) VALUES
    (1,  1, 1, '2024-01-10', '2024-01-15',  90000.00, 2, 1, 1, 'finalizado'),
    (2,  2, 5, '2024-03-05', '2024-03-12', 245000.00, 4, 3, 3, 'finalizado'),
    (3,  1, 3, '2024-06-01', '2024-06-04',  84000.00, 3, 2, 1, 'finalizado'),
    (4,  5, 7, '2024-08-20', '2024-08-23', 225000.00, 5, 4, 3, 'finalizado'),
    (5,  6, 2, '2024-09-10', '2024-09-20', 175000.00, 2, 1, 1, 'finalizado'),
    (6,  3, 4, '2024-10-05', '2024-10-12', 210000.00, 3, 2, 2, 'activo'),
    (7,  4, 6, '2024-10-18', '2024-10-25', 294000.00, 4, 3, 3, 'activo'),
    (8,  2, 8, '2024-11-02', '2024-11-05', 255000.00, 5, 4, 4, 'finalizado'),
    (9,  7, 1, '2025-02-14', '2025-02-18',  72000.00, 2, 1, 2, 'finalizado'),
    (10, 8, 3, '2025-05-03', '2025-05-06',  84000.00, 3, 2, 2, 'cancelado');

INSERT INTO RESERVAS (id, id_cliente, id_vehiculo, fecha_reserva, fecha_inicio, fecha_fin, estado) VALUES
    (1, 3, 4, '2024-09-28', '2024-10-05', '2024-10-12', 'confirmada'),
    (2, 4, 6, '2024-10-10', '2024-10-18', '2024-10-25', 'confirmada'),
    (3, 7, 1, '2025-02-01', '2025-02-14', '2025-02-18', 'confirmada'),
    (4, 6, 2, '2024-08-30', '2024-09-10', '2024-09-20', 'confirmada'),
    (5, 8, 8, '2025-06-01', '2025-06-15', '2025-06-20', 'cancelada');

INSERT INTO PAGOS (id, id_alquiler, fecha_pago, monto) VALUES
    (1, 1, '2024-01-15',  90000.00),
    (2, 2, '2024-03-12', 245000.00),
    (3, 3, '2024-06-04',  84000.00),
    (4, 4, '2024-08-23', 225000.00),
    (5, 5, '2024-09-20', 175000.00),
    (6, 6, '2024-10-05', 100000.00),
    (7, 7, '2024-10-18', 150000.00),
    (8, 8, '2024-11-05', 255000.00),
    (9, 9, '2025-02-18',  72000.00);

INSERT INTO SEGUROS (id, id_alquiler, compania, numero_poliza, cobertura, costo) VALUES
    (1, 1, 'La Segunda',          'POL-1001', 'Cobertura total',          8000.00),
    (2, 2, 'Sancor Seguros',      'POL-1002', 'Terceros completo',        6500.00),
    (3, 4, 'La Caja',             'POL-1003', 'Todo riesgo',             12000.00),
    (4, 8, 'Federación Patronal', 'POL-1004', 'Todo riesgo',             15000.00);

INSERT INTO MULTAS (id, id_alquiler, fecha, motivo, monto, pagada) VALUES
    (1, 1, '2024-01-16', 'Devolución con retraso',      5000.00, 1),
    (2, 3, '2024-06-05', 'Exceso de velocidad',        12000.00, 0),
    (3, 5, '2024-09-22', 'Combustible faltante',        3500.00, 1),
    (4, 8, '2024-11-06', 'Daño menor en paragolpes',   20000.00, 1);

INSERT INTO CHECK_ALQUILER (id, id_alquiler, tipo, fecha, km, nivel_combustible) VALUES
    (1,  1, 'salida',  '2024-01-10 09:00:00', 61500, 100),
    (2,  1, 'entrada', '2024-01-15 18:30:00', 62000,  80),
    (3,  2, 'salida',  '2024-03-05 10:15:00', 40200, 100),
    (4,  2, 'entrada', '2024-03-12 17:45:00', 41000,  75),
    (5,  3, 'salida',  '2024-06-01 08:30:00', 34800, 100),
    (6,  3, 'entrada', '2024-06-04 19:00:00', 35000,  60),
    (7,  4, 'salida',  '2024-08-20 11:00:00', 11500, 100),
    (8,  4, 'entrada', '2024-08-23 16:20:00', 12000,  90),
    (9,  5, 'salida',  '2024-09-10 09:45:00', 47500, 100),
    (10, 5, 'entrada', '2024-09-20 18:00:00', 48000,  50);

INSERT INTO MANTENIMIENTOS (id, id_vehiculo, fecha, tipo, costo, observaciones) VALUES
    (1, 1, '2024-02-01', 'Cambio de aceite',    15000.00, 'Aceite y filtro'),
    (2, 3, '2024-04-10', 'Cambio de frenos',    42000.00, 'Pastillas delanteras'),
    (3, 5, '2024-05-22', 'Alineación y balanceo', 18000.00, NULL),
    (4, 7, '2024-09-15', 'Service oficial',     65000.00, 'Service de 10.000 km'),
    (5, 2, '2024-07-08', 'Cambio de neumáticos', 96000.00, 'Cuatro neumáticos nuevos');
SET NAMES utf8mb4;
USE RENTAL_CARS;

-- 2.1 Marca, modelo y año de todos los vehículos, del más antiguo al más nuevo
SELECT marca, modelo, anio
FROM VEHICULOS
ORDER BY anio ASC;

-- 2.2 Nombre, email y ciudad de los clientes registrados el mes anterior
SELECT nombre, email, ciudad
FROM CLIENTES
WHERE fecha_registro >= DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH)
  AND fecha_registro <  DATE_FORMAT(CURDATE(), '%Y-%m-01');

-- 2.3 Marca, modelo y precio por día de los vehículos de la categoría id = 2
SELECT marca, modelo, precio_dia
FROM VEHICULOS
WHERE id_categoria = 2;

-- 2.4 Todos los datos de los empleados cuyo nombre comienza con "L"
SELECT *
FROM EMPLEADOS
WHERE nombre LIKE 'L%';

-- 2.5 Nombre y cargo de los empleados con salario distinto a 180000.00
SELECT nombre, cargo
FROM EMPLEADOS
WHERE salario <> 180000.00;

-- 2.6 Marca y modelo del vehículo con el nombre de su categoría
SELECT V.marca, V.modelo, C.nombre AS categoria
FROM VEHICULOS V
JOIN CATEGORIAS C ON C.id = V.id_categoria;

-- 2.7 Fecha de inicio, cliente, vehículo y empleado que atendió
SELECT A.fecha_inicio,
       CL.nombre                        AS cliente,
       CONCAT(V.marca, ' ', V.modelo)   AS vehiculo,
       E.nombre                         AS empleado
FROM ALQUILERES A
JOIN CLIENTES CL ON CL.id = A.id_cliente
JOIN VEHICULOS V ON V.id  = A.id_vehiculo
JOIN EMPLEADOS E ON E.id  = A.id_empleado
ORDER BY A.fecha_inicio;

-- 2.8 Nombre del cliente, su ciudad y la fecha de registro
SELECT nombre, ciudad, fecha_registro
FROM CLIENTES;

-- 2.9 Marca y modelo del vehículo con el nombre y la ciudad de su sucursal
SELECT V.marca, V.modelo, S.nombre AS sucursal, S.ciudad
FROM VEHICULOS V
JOIN SUCURSALES S ON S.id = V.id_sucursal;

-- 2.10 Alquiler con la sucursal de retiro y la de devolución (el alquiler no tiene nombre: se identifica por su id y su cliente)
SELECT A.id_alquiler,
       CL.nombre   AS cliente,
       SR.nombre   AS sucursal_retiro,
       SD.nombre   AS sucursal_devolucion
FROM ALQUILERES A
JOIN CLIENTES CL   ON CL.id = A.id_cliente
JOIN SUCURSALES SR ON SR.id = A.id_sucursal_retiro
JOIN SUCURSALES SD ON SD.id = A.id_sucursal_devolucion;

-- 2.11 Cantidad de vehículos por categoría (incluye categorías sin vehículos)
SELECT C.nombre AS categoria, COUNT(V.id) AS cantidad
FROM CATEGORIAS C
LEFT JOIN VEHICULOS V ON V.id_categoria = C.id
GROUP BY C.id, C.nombre;

-- 2.12 Precio promedio por día de los vehículos agrupados por categoría
SELECT C.nombre AS categoria, AVG(V.precio_dia) AS precio_promedio_dia
FROM CATEGORIAS C
JOIN VEHICULOS V ON V.id_categoria = C.id
GROUP BY C.id, C.nombre;

-- 2.13 Empleado y total de alquileres gestionados (de mayor a menor)
SELECT E.nombre AS empleado, COUNT(A.id_alquiler) AS total_alquileres
FROM EMPLEADOS E
LEFT JOIN ALQUILERES A ON A.id_empleado = E.id
GROUP BY E.id, E.nombre
ORDER BY total_alquileres DESC, E.nombre;

-- 2.14 Clientes con más de 1 alquiler registrado
SELECT CL.id, CL.nombre, COUNT(A.id_alquiler) AS cantidad_alquileres
FROM CLIENTES CL
JOIN ALQUILERES A ON A.id_cliente = CL.id
GROUP BY CL.id, CL.nombre
HAVING COUNT(A.id_alquiler) > 1;

-- 2.15 Ciudad y cantidad de sucursales en cada una
SELECT ciudad, COUNT(*) AS cantidad_sucursales
FROM SUCURSALES
GROUP BY ciudad;

-- 2.16 Marca, modelo y año del vehículo más antiguo de la flota (incluye empates)
SELECT marca, modelo, anio
FROM VEHICULOS
WHERE anio = (SELECT MIN(anio) FROM VEHICULOS);

-- 2.17 Vehículos que nunca han sido alquilados
SELECT V.id, V.marca, V.modelo, V.patente
FROM VEHICULOS V
LEFT JOIN ALQUILERES A ON A.id_vehiculo = V.id
WHERE A.id_alquiler IS NULL;

-- 2.18 Alquileres 'activo' que comenzaron en octubre de 2024
SELECT *
FROM ALQUILERES
WHERE estado = 'activo'
  AND fecha_inicio >= '2024-10-01'
  AND fecha_inicio <  '2024-11-01';

-- 2.19 Los 3 vehículos con el precio por día más alto
SELECT marca, modelo, precio_dia
FROM VEHICULOS
ORDER BY precio_dia DESC
LIMIT 3;

-- 2.20 Cantidad total de multas pagadas y monto total recaudado
SELECT COUNT(*)                 AS multas_pagadas,
       COALESCE(SUM(monto), 0)  AS monto_total_recaudado
FROM MULTAS
WHERE pagada = 1;

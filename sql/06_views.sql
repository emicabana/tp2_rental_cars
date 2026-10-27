SET NAMES utf8mb4;
USE RENTAL_CARS;

-- 4.1 Alquileres con datos "amigables" en lugar de IDs
CREATE OR REPLACE VIEW VW_ALQUILERES_DETALLE AS
SELECT A.id_alquiler,
       A.fecha_inicio,
       A.fecha_fin,
       CL.nombre   AS cliente,
       V.marca,
       V.modelo,
       E.nombre    AS empleado,
       SR.nombre   AS sucursal_retiro,
       SD.nombre   AS sucursal_devolucion,
       A.total
FROM ALQUILERES A
JOIN CLIENTES CL   ON CL.id = A.id_cliente
JOIN VEHICULOS V   ON V.id  = A.id_vehiculo
JOIN EMPLEADOS E   ON E.id  = A.id_empleado
JOIN SUCURSALES SR ON SR.id = A.id_sucursal_retiro
JOIN SUCURSALES SD ON SD.id = A.id_sucursal_devolucion;

-- 4.2 Cantidad de vehículos por sucursal (incluye sucursales sin vehículos)
CREATE OR REPLACE VIEW VW_VEHICULOS_POR_SUCURSAL AS
SELECT S.id            AS id_sucursal,
       S.nombre        AS sucursal,
       S.ciudad,
       COUNT(V.id)     AS total_vehiculos
FROM SUCURSALES S
LEFT JOIN VEHICULOS V ON V.id_sucursal = S.id
GROUP BY S.id, S.nombre, S.ciudad;

-- 4.3 Ingresos por categoría (solo alquileres 'finalizado'). La condición del estado va en el ON del LEFT JOIN para que las categorías sin alquileres finalizados aparezcan con 0.
CREATE OR REPLACE VIEW VW_INGRESOS_POR_CATEGORIA AS
SELECT C.id                          AS id_categoria,
       C.nombre                      AS categoria,
       COUNT(A.id_alquiler)          AS alquileres_finalizados,
       COALESCE(SUM(A.total), 0)     AS monto_total_facturado
FROM CATEGORIAS C
LEFT JOIN VEHICULOS V  ON V.id_categoria = C.id
LEFT JOIN ALQUILERES A ON A.id_vehiculo  = V.id
                      AND A.estado = 'finalizado'
GROUP BY C.id, C.nombre;


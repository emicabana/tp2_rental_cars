# TP N° 2 — Modelo de datos: Alquiler de autos (RENTAL_CARS)

## 1. De qué se trata el modelo

El modelo representa el **negocio de una empresa de alquiler de vehículos con
varias sucursales**. La empresa tiene una **flota** de vehículos organizada en
**categorías** y repartida entre **sucursales**. Los **clientes** reservan y
alquilan vehículos; cada alquiler lo gestiona un **empleado**, se retira en una
sucursal y se devuelve en la misma o en otra. Alrededor del alquiler se
registran los **pagos**, los **seguros**, las **multas** y los **controles de
estado** (salida y entrada) del vehículo. La flota también tiene su historial
de **mantenimientos**.

## 2. Qué representa cada tabla

| Tabla | Qué representa |
|---|---|
| SUCURSALES | Locales de la empresa (nombre, dirección, ciudad, teléfono) |
| CATEGORIAS | Clasificación de la flota (Económico, Sedán, SUV, Premium) |
| CLIENTES | Personas que alquilan; incluyen licencia de conducir y fecha de registro |
| EMPLEADOS | Personal de cada sucursal, con cargo, fecha de ingreso y salario |
| VEHICULOS | Flota: marca, modelo, año, precio por día, patente, km y disponibilidad (estado) |
| ALQUILERES | Contrato de alquiler: cliente, vehículo, fechas, total, empleado, sucursal de retiro y de devolución, estado |
| RESERVAS | Reservas anticipadas de un vehículo por un cliente |
| PAGOS | Pagos realizados por un alquiler |
| SEGUROS | Pólizas contratadas para un alquiler |
| MULTAS | Sanciones asociadas a un alquiler (con indicador de pago) |
| CHECK_ALQUILER | Control del vehículo al retirarlo ('salida') y al devolverlo ('entrada'): km y combustible |
| MANTENIMIENTOS | Servicios de mantenimiento de cada vehículo |
| AUDITORIA_ALQUILERES | Registro de auditoría de nuevos alquileres (se agrega en la Sección 5) |

## 3. Relaciones y su relación inversa

La clave foránea está siempre del lado "muchos".

| Relación (lectura directa) | Cardinalidad | Relación inversa |
|---|---|---|
| EMPLEADOS → SUCURSALES (el empleado trabaja en una sucursal) | N : 1 | Una sucursal tiene muchos empleados (1 : N) |
| VEHICULOS → CATEGORIAS | N : 1 | Una categoría agrupa muchos vehículos (1 : N) |
| VEHICULOS → SUCURSALES (dónde está el vehículo) | N : 1 | Una sucursal alberga muchos vehículos (1 : N) |
| ALQUILERES → CLIENTES | N : 1 | Un cliente tiene muchos alquileres (1 : N) |
| ALQUILERES → VEHICULOS | N : 1 | Un vehículo se alquila muchas veces (1 : N) |
| ALQUILERES → EMPLEADOS | N : 1 | Un empleado gestiona muchos alquileres (1 : N) |
| ALQUILERES → SUCURSALES (retiro) | N : 1 | Una sucursal es punto de retiro de muchos alquileres (1 : N) |
| ALQUILERES → SUCURSALES (devolución) | N : 1 | Una sucursal es punto de devolución de muchos alquileres (1 : N) |
| RESERVAS → CLIENTES | N : 1 | Un cliente hace muchas reservas (1 : N) |
| RESERVAS → VEHICULOS | N : 1 | Un vehículo puede reservarse muchas veces (1 : N) |
| PAGOS → ALQUILERES | N : 1 | Un alquiler puede tener varios pagos (1 : N) |
| SEGUROS → ALQUILERES | N : 1 | Un alquiler puede tener varios seguros (1 : N) |
| MULTAS → ALQUILERES | N : 1 | Un alquiler puede tener varias multas (1 : N) |
| CHECK_ALQUILER → ALQUILERES | N : 1 | Un alquiler tiene varios controles (salida y entrada) (1 : N) |
| MANTENIMIENTOS → VEHICULOS | N : 1 | Un vehículo tiene muchos mantenimientos (1 : N) |

Entre **CLIENTES y VEHICULOS** hay una relación **muchos a muchos** que se
resuelve con las tablas intermedias ALQUILERES y RESERVAS. Entre
**ALQUILERES y SUCURSALES** existen dos relaciones 1:N independientes
(retiro y devolución).

## 4. Requerimientos funcionales (deducidos del modelo)

- RF1. Administrar sucursales, categorías, clientes, empleados y vehículos (alta, baja, modificación y consulta).
- RF2. Registrar y consultar reservas de vehículos con su estado (pendiente, confirmada o cancelada).
- RF3. Registrar alquileres con cliente, vehículo, empleado, fechas, sucursal de retiro y de devolución, total y estado (activo, finalizado o cancelado).
- RF4. Calcular el total del alquiler como días × precio por día del vehículo (SP_REGISTRAR_ALQUILER).
- RF5. Controlar la disponibilidad del vehículo: impedir alquilar un vehículo no disponible y marcarlo como no disponible al iniciar un alquiler activo.
- RF6. Registrar pagos, seguros y multas asociados a cada alquiler; las multas nacen sin pagar (SP_CALCULAR_MULTA).
- RF7. Registrar el control del vehículo a la salida y a la entrada (km y nivel de combustible).
- RF8. Registrar el historial de mantenimientos de cada vehículo.
- RF9. Consultar la flota por categoría, sucursal, año y precio, y detectar vehículos nunca alquilados.
- RF10. Consultar clientes registrados en un período y clientes frecuentes.
- RF11. Obtener estadísticas: alquileres por empleado, vehículos por categoría y sucursal, ingresos por categoría, multas recaudadas.
- RF12. Auditar cada nuevo alquiler (TR_AUDITAR_ALQUILER).
- RF13. Ofrecer vistas resumidas (VW_ALQUILERES_DETALLE, VW_VEHICULOS_POR_SUCURSAL, VW_INGRESOS_POR_CATEGORIA).
- RF14. Gestionar dos perfiles: vendedor (consulta de flota; gestión de alquileres y pagos, sin borrar alquileres) y administrador (todos los privilegios).

## 5. Requerimientos no funcionales (deducidos del modelo)

- RNF1. **Integridad referencial**: todas las relaciones tienen clave foránea InnoDB; los borrados son RESTRICT y las actualizaciones de clave son CASCADE.
- RNF2. **Integridad de datos**: claves primarias en todas las tablas, restricciones UNIQUE en patente, licencia de conducir y número de póliza, y campos obligatorios con NOT NULL.
- RNF3. **Consistencia**: el estado del vehículo se actualiza automáticamente mediante un trigger cuando se crea un alquiler activo.
- RNF4. **Precisión monetaria**: importes con DECIMAL(9,2) o DECIMAL(10,2), nunca FLOAT.
- RNF5. **Seguridad**: mínimo privilegio; el vendedor solo lee la flota y no puede borrar alquileres.
- RNF6. **Rendimiento**: índices sobre año, precio, fecha de registro, nombre de empleado, estado de alquiler y estado de multas.
- RNF7. **Trazabilidad**: cada alquiler nuevo queda en la tabla de auditoría con fecha y hora.
- RNF8. **Reproducibilidad**: el entorno se levanta con Docker (MySQL 8) y los scripts numerados se ejecutan en orden.
- RNF9. **Soporte de caracteres**: utf8mb4 para tildes y la letra ñ.
- RNF10. **Mantenibilidad**: scripts separados por responsabilidad.

## 6. Decisiones de diseño tomadas

- **Motor**: MySQL 8 (el enunciado usa `'usuario'@'localhost'` y los procedimientos con mensajes de error).
- **Tipo de `licencia_conducir`**: el diagrama lo muestra cortado (`VARCHAR(3…`); se asumió `VARCHAR(30)`.
- **Nombre de la tabla de controles**: el diagrama muestra `CHECK_ALQUIL…` y el enunciado la llama `CHECK_ALQUILER`; se usó ese nombre.
- **Consulta 2.10**: el alquiler no tiene "nombre"; se muestra su `id_alquiler` junto con el cliente.
- **SP_REGISTRAR_ALQUILER**: no recibe sucursales, por lo que el retiro y la devolución se asignan a la sucursal donde está el vehículo.
- **Fechas dinámicas** en los datos de prueba (cliente registrado "el mes anterior") para que la consulta 2.2 devuelva resultados siempre.
- **Operaciones DML** (Sección 3) en `04_alterations.sql`, porque el enunciado no pide ningún ALTER TABLE.

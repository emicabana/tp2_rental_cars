# TP N° 2 — Sección 8: Preguntas teóricas

## 1. ¿Por qué ALQUILERES tiene claves foráneas hacia SUCURSALES dos veces (id_sucursal_retiro e id_sucursal_devolucion)? ¿Qué tipo de relación representa esto?

Porque el **retiro** y la **devolución** del vehículo son dos hechos distintos y pueden ocurrir en sucursales diferentes (por ejemplo, retirar en Córdoba y devolver en Mendoza, como el alquiler 4 de los datos de prueba). Una sola clave foránea solo podría expresar una de las dos sucursales.

Representa **dos relaciones uno a muchos (1:N) independientes** entre SUCURSALES y ALQUILERES:

- Una sucursal es el punto de retiro de muchos alquileres, y cada alquiler se retira en una sola sucursal.
- Una sucursal es el punto de devolución de muchos alquileres, y cada alquiler se devuelve en una sola sucursal.

Es una **relación múltiple entre las mismas dos tablas**, donde cada relación cumple un rol distinto. En las consultas hay que unir la tabla SUCURSALES dos veces con alias distintos (consulta 2.10 y vista VW_ALQUILERES_DETALLE).

## 2. Si intentamos borrar una CATEGORIA que tiene vehículos asociados, ¿qué debería hacer la base de datos? ¿Por qué? Menciona al menos dos opciones (RESTRICT, CASCADE, SET NULL) y justifica cuál sería la más adecuada.

| Opción | Qué haría | Problema |
|---|---|---|
| **RESTRICT** | Rechaza el borrado mientras existan vehículos de esa categoría | Obliga a reasignar los vehículos primero (es lo deseable) |
| **CASCADE** | Borra también todos los vehículos de la categoría | Arrastra la flota y, por las claves siguientes, alquileres, pagos y multas: se perdería el historial del negocio con un solo DELETE |
| **SET NULL** | Deja `id_categoria` en NULL en esos vehículos | `id_categoria` es `NOT NULL`; además dejaría vehículos sin precio de referencia ni clasificación |

La opción más adecuada es **RESTRICT** (la usada en el script). Una categoría es un dato maestro del que depende la flota, y borrarla por error no debería destruir ni "descategorizar" vehículos. Con RESTRICT la base protege la integridad referencial y obliga a una decisión consciente: reasignar los vehículos a otra categoría y recién después eliminar la categoría vacía. Se comprobó que `DELETE FROM CATEGORIAS WHERE id = 1;` falla con el error 1451.

## 3. Observando VEHICULOS, ¿por qué la categoría está en una tabla separada (CATEGORIAS) y no directamente como un campo de texto en VEHICULOS?

Por **normalización** y calidad de datos:

- **Sin redundancia**: el nombre y la descripción de "SUV" se guardan una sola vez, no en cada vehículo de esa categoría.
- **Consistencia**: con un campo de texto aparecerían variantes ("SUV", "suv", "Suv ", "S.U.V."), que rompen los agrupamientos (consultas 2.11 y 2.12) y la vista de ingresos.
- **Un único punto de cambio**: renombrar una categoría o editar su descripción afecta un solo registro.
- **Integridad**: la clave foránea garantiza que cada vehículo pertenezca a una categoría que existe.
- **Extensibilidad**: se pueden agregar atributos a la categoría (tarifa base, requisitos, etc.) sin tocar VEHICULOS.
- **Eficiencia**: guardar y comparar un entero es más liviano que repetir texto en cada fila.

## 4. ¿Qué tipo de relación existe entre SUCURSALES y EMPLEADOS? Justifica.

Es una relación **uno a muchos (1:N)** desde SUCURSALES hacia EMPLEADOS:

- Una **sucursal** tiene **varios empleados** (la Sucursal Centro tiene a Laura y a Leandro).
- Un **empleado** trabaja en **una sola sucursal**, porque la clave foránea `id_sucursal` está en EMPLEADOS y es `NOT NULL`.

No es muchos a muchos, porque el modelo no permite que un empleado pertenezca a dos sucursales (haría falta una tabla intermedia); y no es uno a uno, porque una sucursal tiene muchos empleados. Desde el empleado, la misma relación es **muchos a uno (N:1)**.

## 5. ¿Por qué CHECK_ALQUILER tiene un campo `tipo` con valores 'salida' o 'entrada' en lugar de tener dos tablas separadas? ¿Qué ventaja aporta este diseño?

Porque el control de salida y el de entrada son **el mismo tipo de hecho**: una inspección del vehículo en un momento dado, con los mismos datos (fecha y
hora, kilometraje, nivel de combustible). Lo único que cambia es el momento del alquiler en que se hace. Por eso se modela como una sola entidad con un
atributo que la distingue.

Ventajas:

- **Menos duplicación**: una sola tabla en lugar de dos con columnas idénticas; el esquema es más simple y fácil de mantener.
- **Comparaciones sencillas**: los kilómetros recorridos o el combustible consumido se obtienen comparando las dos filas de un mismo alquiler (`km` de 'entrada' menos `km` de 'salida'), sin unir tablas distintas.
- **Flexibilidad**: si mañana se agrega un control intermedio (por ejemplo, 'extensión'), alcanza con un nuevo valor de `tipo`, sin crear otra tabla.
- **Consultas uniformes**: un único `SELECT` con `WHERE tipo = ...` o con agrupación sirve para todos los controles.

Como contrapartida, `tipo` es un texto libre, por lo que podría guardarse un valor erróneo. Para evitarlo, en `04_alterations.sql` se agregó la restricción `CHK_CHECK_ALQUILER_TIPO`, que limita los valores a `'salida'` y `'entrada'`.

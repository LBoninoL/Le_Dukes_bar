# Le_Dukes_bar - Bonino
Este modelo de negocios se centra en un sistema de gestión de un bar; que ofrece servicio en el local, reservas para eventos y delivery (propio y por terceros como PedidosYa).
## Modelo Entidad - Relación
El modelo E-R se adjuntó junto al script en el archivo: **Le_Dukes_bar - Bonino**
## Listado de Tablas
El modelo de datos y la creación de las tablas se estructuraron en 3 grupos funcionales, definidos por el tipo de actividad para facilitar su comprensión. Estas son: 
* Operaciones de Venta y Servicio: imagen 1 a 9
* Inventario y Menú: imagen 10 a 14
* Gestión de Negocio y Finanzas: imagen 15 a 19

Aquí adjunto el link en donde se encuentran las tablas y el informe de negocio: [Le Dukes bar - Bonino](https://drive.google.com/drive/folders/1Ib1sFbvP0P76Iod3waNxBesoVib_EONU?usp=drive_link)


## Vistas:
* Vista_Ventas_Diarias_Resumen:

  Tablas Componentes: Pedidos.
  Objetivo: Busca facilitar la obtención de métricas de rendimiento diarias clave para el departamento de contabilidad y la gerencia.
            Consolida los datos de ventas para mostrar la actividad del bar por día. Extrae la fecha de la marca de tiempo de los pedidos y calcula el total de
            transacciones y el monto neto total generado.
  
* Vista_Costo_Plato_Actual:

  Tablas que la componen: Menu_Items, Recetas, Ingredientes.
  Objetivo: Calcular y mostrar el costo de producción de cada Menu_Item en tiempo real (o basado en el último costo_unidad_promedio registrado en Ingredientes).

* Vista_Pedidos_Delivery_Pendientes:

  Tablas que la componen: Pedidos, Clientes, Servicios_Delivery.
  Objetivo: Generar una lista de todos los pedidos de tipo 'Delivery' cuyo estado_pedido esté en 'En preparación' o 'Listo para recoger'.	

* Vista_Flujo_Caja_Simple:
  
  Tablas que la componen: Pagos, Facturas_Compra, Costos_Fijos, Metodos_Pago.
  Objetivo: Resumir los movimientos de dinero. Ingresos (de Pagos) y los egresos (de Facturas_Compra y Costos_Fijos) por fecha para una visión rápida de liquidez.	


## Funciones:

  * FN_Costo_Produccion_Item:

  Vista que Complementa: Vista_Costo_Plato_Actual
  Objetivo: Calcular el costo total de la materia prima para un Menu_Item. Es la base para la columna Costo_Total_Produccion de la vista. 
  Manipula: Recetas, Ingredientes.
  
  * FN_Costo_Fijo_Mensual_Promedio:

  Vista que Complementa: Vista_Flujo_Caja_Simple	 
  Objetivo: Devolver el monto promedio mensual de un tipo de costo fijo (tipo_costo), útil para proyectar egresos en la vista de flujo.
  Manipula: Costos_Fijos.  
  
  * FN_Horas_Transcurridas_Pedido:

  Vista que Complementa: Vista_Pedidos_Delivery_Pendientes
  Objetivo: Calcular cuántas horas o minutos han pasado desde que se generó un pedido. Crucial para medir la eficiencia del delivery. 
  Manipula: Pedidos (fecha_hora_pedido).

  * FN_Stock_Actual_Ingrediente:

  Vista que Complementa:Vista_Costo_Plato_Actual	
  Objetivo: Calcular el stock disponible de un ingrediente. Esto ayuda a identificar si un plato se puede preparar (control de inventario). 
  Manipula: Movimientos_Stock.


## Stored Procedures:

  * P_Registrar_Nuevo_Pedido:

  Parámetros: @cliente_id, @mesa_id, @tipo_pedido, items_json
  Tablas con las que Interactúa: Pedidos, Items_Pedidos, Mesas.
  Objetivo: Automatizar la creación de un nuevo pedido, insertando en Pedidos e Items_Pedidos y actualizando el estado de la Mesa. Esto garantiza la integridad 
            referencial al crear un pedido completo en una sola transacción.	 

  * SP_Procesar_Pago_Pedido:

  Parámetros: @pedido_id, @monto_final, @metodo_pago_id.
  Tablas con las que Interactúa: Pedidos, Pagos. 
	Objetivo: Marcar un pedido como pagado y registrar la transacción. Finaliza el ciclo de venta, actualiza Pedidos a 'Completado' e inserta el registro en la tabla 
            Pagos (alimentando Vista_Flujo_Caja_Simple).	


  * SP_Actualizar_Costo_Ingrediente

  Parámetros: @ingrediente_id, @costo_unitario_nuevo.
  Tablas con las que Interactúa: Ingredientes.
  Objetivo: Actualizar el costo_unidad_promedio de un ingrediente. Asegurar que los costos reflejados por la Función FN_Costo_Produccion_Item y la 
            Vista_Costo_Plato_Actual sean siempre los más recientes.


* SP_Cerrar_Caja_Diaria

  Parámetros: @fecha_cierre, @monto_total_ingresos.
  Tablas con las que Interactúa: Pagos.
  Objetivo: Calcular el total de ingresos por ventas en efectivo/tarjeta para un día específico y registrar el cierre. 

  

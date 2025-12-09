[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/WgYJif60)
# [NOMBRE DEL PROYECTO]
### Nombre y carné de los integrantes: 
* Brasly Villarebia Morales
* Elder Leon Perez

### Estado del proyecto: Bueno
### Enlace del video:
# Proyecto: Diseño e Implementación de una Solución de Inteligencia de Negocios – BikeStores

## 📘 Descripción General del Proyecto

Este proyecto consiste en la construcción completa de una solución de **Inteligencia de Negocios** utilizando únicamente tecnologías Microsoft.  
La solución parte de la base de datos transaccional **BikeStores**, y evoluciona hacia la implementación de:

- **ETL profesional con SSIS**  
- **Data Warehouse (DW) modelado en estrella**  
- **Cubo OLAP en SQL Server Analysis Services (SSAS)**  
- **Reportes en SQL Server Reporting Services (SSRS)**  

La fuente del esquema original proviene de:  
**https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/**

---

# 🎯 Objetivos del Proyecto

1. Transformar los datos desde BikeStores hacia un DataWarehouse adecuado.  
2. Modelar un cubo OLAP enfocado en ventas.  
3. Construir dos reportes profesionales:
   - **Reporte de Ventas** (consultando al DW)  
   - **Reporte de Inventario** (consultando al OLTP original)  
4. Publicar el cubo y los reportes en el servidor.  
5. Diseñar el ETL y su orquestación (job SQL Agent).  

---

#  Arquitectura de la Solución

```
BikeStores (OLTP)
     ↓
BikeStores_Stage (Staging)
     ↓
BikeStores_DW (Data Warehouse)
     ↓
SSAS (Cubo OLAP)
     ↓
SSRS (Reportes)
```

---

#  1. Base OLTP: BikeStores

Diseñada para operación transaccional en 3FN.

## ✔️ Decisiones clave

### Separación por esquemas:

- `production` → productos, categorías, marcas, inventario.  
- `sales` → clientes, staff, tiendas, órdenes.

### Ventajas:
- Organización lógica.
- Claridad entre datos maestros y operativos.
- Mantenimiento simplificado.

## ✔️ Modelo de ventas encabezado-detalle

- `orders` → información administrativa.  
- `order_items` → detalle de productos vendidos.  

## ✔️ Inventarios

- `stocks` almacena cantidad por tienda-producto.
- No maneja histórico → se manejará en DW.

---

#  2. Base de Staging: BikeStores_Stage

Una copia sin constraints del OLTP para facilitar el ETL.

## ✔️ Características:

- Tablas **idénticas** al OLTP, pero:
  - Sin PRIMARY KEY  
  - Sin FOREIGN KEY  
  - Sin IDENTITY  
- Optimizada para cargas masivas.

## ✔️ Justificación
- Se puede truncar y recargar sin conflictos.
- Permite limpiar y validar datos antes del DW.
- ETL más rápido y flexible.

---

#  3. Data Warehouse: BikeStores_DW

---

#  DimDate

Dimensión del tiempo con atributos derivados:

- Día, mes, año, trimestre  
- Festivos, días hábiles  
- Primer/último día del mes, etc.  

Es la base para análisis temporal eficiente.

---

#  DimCustomers (SCD Tipo 2)

- Combina nombre + apellido en `FullName`.  
- `CustomerKey` surrogate key.  
- Tabla histórica: `DimCustomers_Hist`.

Justificación:
- Permite análisis históricos respetando los datos de la época.

---

#  DimStaff (SCD Tipo 2)

Similar a clientes:
-  tabla histórica.
- Útil para movimientos de personal o cambios de tienda.

---

#  DimProducts (SCD Tipo 1 y Tipo 2)

Desnormalizada con atributos de:

- Products  
- Categories  
- Brands  

Versionada con DimProducts_Hist.

Justificación:
- Mejora rendimiento del cubo.
- Reduce joins.

---

#  DimStores (SCD Tipo 1)

- Cambios poco frecuentes.
- No requiere histórico.

---

# DimOrders

Contiene metadatos administrativos de las órdenes.

Separación evita duplicación en hechos.

---

#  DimStocks

Aporta inventario por tienda-producto.

Útil para análisis comparativos y disponibilidad.

---

# 📊 FactSales — Tabla de Hechos

Incluye:

- ProductKey  
- CustomerKey  
- StaffKey  
- StoreKey  
- OrderKey  
- OrderDateKey  
- RequiredDateKey  
- ShippedDateKey  

Medidas:

- Cantidad  
- Precio  
- Descuento  
- Monto bruto  
- Monto descuento  
- Monto neto  

Justificación:
- Acumula todo lo necesario para análisis de ventas.  
- Medidas precalculadas optimizan el rendimiento.

---

# 🚀 ETL – Transformaciones

Incluyó:

- Extracción OLTP → Stage  
- Limpieza y validación  
- SCD2 para Staff y Customers  
- Unión de catálogos en DimProducts  
- Carga incremental usando `cargarFTVentas`  

Orquestado con SQL Server Agent.

---

# 📦 Cubo OLAP (SSAS)

Dimensiones:

- Clientes  
- Productos  
- Staff  
- Tiempo  
- Órdenes  
- Tiendas  

Jerarquías:
- Categoría → Marca → Producto  
- Año → Mes → Día  

Medidas:
- Total vendido  
- Cantidad vendida  
- Descuento aplicado  
- Total neto  

---

# 📊 Reportes SSRS

#Link publicacion http://eldermsi/ReportServer

## Reporte de Ventas (consultando DW)
Incluye:
- Total vendido por categoría  
- Cantidad vendida por producto  
- Filtros:
  - Cliente  
  - Marca  
  - Fechas  

## Reporte de Inventario (consultando OLTP)
Incluye:
- Inventario por producto y marca  
- Filtros:
  - Categoría  
  - Sucursal  
  - Marca  

---

# 📋 Tabla de Aspectos Logrados y No Logrados

| Requisito | Estado |
|----------|--------|
| Transformaciones ETL | ✅ Logrado |
| Orquestador SQL Agent | ✅ Logrado |
| Modelado del DW | ✅ Logrado |
| Dos dimensiones SCD2 | ✅ Customers y Staff |
| Modelado del Cubo SSAS | ✅ Logrado |
| Reporte de Ventas | ⚠️ Logrado parcialmente |
| Reporte de Inventario | ✅ Logrado |
| Publicación de reportes | ✅ Logrado |
| Validación de datos | ⚠️ Revisión final pendiente |

---


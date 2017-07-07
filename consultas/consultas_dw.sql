----------------------------------
---------- consulta 1-------------

--Venta vista por mes o por año, por sucursal, por región, por cliente y demás combinaciones entre las perspectivas. 
--El mínimo nivel de detalle que se quiere tener disponible para el análisis de las ventas ($ vendidos y unidades vendidas) 
--es el de la facturas.

SELECT t.anio, t.mes, p.nombre as producto, c.nombre as cliente, ci.descripcion as ciudad, mp.descripcion as forma_de_pago, sum(v.monto_vendido) as monto, sum(v.cantidad_vendida) as cantidad
FROM venta v, tiempo t, sucursal s, ciudad ci, provincia prov, region r, clientes c, medio_de_pago mp, producto p
WHERE t.id_tiempo = v.id_tiempo AND c.id_cliente = v.id_cliente AND s.id_sucursal = v.id_sucursal AND ci.id_ciudad = s.id_ciudad
      AND prov.id_provincia = ci.id_provincia AND r.id_region = prov.id_region AND c.id_cliente = v.id_cliente
      AND mp.id_medio_de_pago = v.id_medio_de_pago AND p.id_producto = v.id_producto
GROUP BY ROLLUP(t.anio, t.mes), CUBE (p.nombre, c.nombre, ci.descripcion, mp.descripcion)
ORDER BY t.anio, t.mes, p.nombre, c.nombre, ci.descripcion, mp.descripcion;
--rollup año mes -- cube resto

----------------------------------
---------- consulta 2-------------

--Es necesario conocer también de que manera influye, en las ventas de productos, la zona geográfica en la que están ubicados los locales.

select s.id_sucursal, s.direccion, p.nombre as producto, sum(v.cantidad_vendida) as cantidad_vendida, rank() over(order by s.id_sucursal, sum(v.cantidad_vendida) desc) as ranking
from sucursal s, venta v,producto p
where v.id_sucursal = s.id_sucursal and p.id_producto = v.id_producto
group by s.id_sucursal, p.id_producto --, v.cantidad_vendida, p.nombre
order by ranking

-------------------------------------------------------------------------------------------------------------------------------------------------

--Las sucursales que mas vendieron en plata

select s.id_sucursal, s.direccion as producto, sum(v.monto_vendido) as cantidad_vendida, rank() over(order by s.id_sucursal, sum(v.monto_vendido) desc) as ranking
from sucursal s, venta v,producto p
where v.id_sucursal = s.id_sucursal and p.id_producto = v.id_producto
group by s.id_sucursal --, p.id_producto --, v.cantidad_vendida, p.nombre
order by ranking

----------------------------------
---------- consulta 3-------------

--De cada cliente se desea conocer cuales son los que generan mayores ingresos a la cooperativa.

select c.id_cliente, c.nombre, sum(v.monto_vendido) as ingresos_totales, rank() over(order by sum(v.monto_vendido) desc) as ranking_ventas
from venta v, clientes c
where v.id_cliente = c.id_cliente
group by c.id_cliente
order by ranking_ventas



----------------------------------
---------- consulta 4-------------

--Se necesitará hacer análisis diarios, mensuales, trimestrales y anuales.

SELECT t.anio, t.trimestre, t.mes, v.fecha_venta, sum(v.monto_vendido) as monto
FROM venta v, tiempo t
WHERE t.id_tiempo = v.id_tiempo
GROUP BY ROLLUP (t.anio, t.trimestre, t.mes, v.fecha_venta)
ORDER BY t.anio, t.trimestre, t.mes, v.fecha_venta;
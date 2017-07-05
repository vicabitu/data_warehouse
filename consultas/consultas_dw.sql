----------------------------------
---------- consulta 1-------------

SELECT v.fecha_venta, t.mes, t.anio, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida
FROM venta v, tiempo t, sucursal s, ciudad ci, provincia prov, region r, clientes c, medio_de_pago mp, producto p
WHERE t.id_tiempo = v.id_tiempo AND c.id_cliente = v.id_cliente AND s.id_sucursal = v.id_sucursal AND ci.id_ciudad = s.id_ciudad
      AND prov.id_provincia = ci.id_provincia AND r.id_region = prov.id_region AND c.id_cliente = v.id_cliente
      AND mp.id_medio_de_pago = v.id_medio_de_pago AND p.id_producto = v.id_producto
GROUP BY CUBE (v.fecha_venta, t.mes, t.anio, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida);

----------------------------------
---------- consulta 2-------------

----------------------------------
---------- consulta 3-------------

----------------------------------
---------- consulta 4-------------

--SELECT v.fecha_venta, t.mes, t.anio, t.trimestre, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida
--FROM venta v, tiempo t, sucursal s, ciudad ci, provincia prov, region r, clientes c, medio_de_pago mp, producto p
--WHERE t.id_tiempo = v.id_tiempo AND c.id_cliente = v.id_cliente AND s.id_sucursal = v.id_sucursal AND ci.id_ciudad = s.id_ciudad
--      AND prov.id_provincia = ci.id_provincia AND r.id_region = prov.id_region AND c.id_cliente = v.id_cliente
--      AND mp.id_medio_de_pago = v.id_medio_de_pago AND p.id_producto = v.id_producto
--GROUP BY GROUPING SETS ((c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida, v.fecha_venta), 
--			(c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida, t.mes), 
--			(c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida, t.anio), 
--			(c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida, t.trimestre));

--SELECT v.fecha_venta, t.mes, t.anio, t.trimestre, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida
--FROM venta v, tiempo t, sucursal s, ciudad ci, provincia prov, region r, clientes c, medio_de_pago mp, producto p
--WHERE t.id_tiempo = v.id_tiempo AND c.id_cliente = v.id_cliente AND s.id_sucursal = v.id_sucursal AND ci.id_ciudad = s.id_ciudad
--      AND prov.id_provincia = ci.id_provincia AND r.id_region = prov.id_region AND c.id_cliente = v.id_cliente
--     AND mp.id_medio_de_pago = v.id_medio_de_pago AND p.id_producto = v.id_producto
--GROUP BY GROUPING SETS ((v.fecha_venta, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida), 
--			(t.mes, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida), 
--			(t.anio, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida), 
--			(t.trimestre, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida));

SELECT v.fecha_venta, t.mes, t.anio, t.trimestre, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida
FROM venta v, tiempo t, sucursal s, ciudad ci, provincia prov, region r, clientes c, medio_de_pago mp, producto p
WHERE t.id_tiempo = v.id_tiempo AND c.id_cliente = v.id_cliente AND s.id_sucursal = v.id_sucursal AND ci.id_ciudad = s.id_ciudad
      AND prov.id_provincia = ci.id_provincia AND r.id_region = prov.id_region AND c.id_cliente = v.id_cliente
      AND mp.id_medio_de_pago = v.id_medio_de_pago AND p.id_producto = v.id_producto
GROUP BY GROUPING SETS ((v.fecha_venta, t.mes, t.anio, t.trimestre, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida), 
			(t.mes, v.fecha_venta, t.anio, t.trimestre, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida), 
			(t.anio, v.fecha_venta, t.mes, t.trimestre, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida), 
			(t.trimestre, v.fecha_venta, t.mes, t.anio, t.trimestre, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida));


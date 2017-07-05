----------------------------------
---------- consulta 1-------------

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

----------------------------------
---------- consulta 3-------------

----------------------------------
---------- consulta 4-------------

SELECT t.anio, t.trimestre, t.mes, v.fecha_venta, sum(v.monto_vendido) as monto
FROM venta v, tiempo t
WHERE t.id_tiempo = v.id_tiempo
GROUP BY ROLLUP (t.anio, t.trimestre, t.mes, v.fecha_venta)
ORDER BY t.anio, t.trimestre, t.mes, v.fecha_venta;
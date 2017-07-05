----------------------------------
---------- consulta 1-------------

SELECT t.mes, t.anio, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida
FROM venta v, tiempo t, sucursal s, ciudad ci, provincia prov, region r, clientes c, medio_de_pago mp, producto p
WHERE t.id_tiempo = v.id_tiempo AND c.id_cliente = v.id_cliente AND s.id_sucursal = v.id_sucursal AND ci.id_ciudad = s.id_ciudad
      AND prov.id_provincia = ci.id_provincia AND r.id_region = prov.id_region AND c.id_cliente = v.id_cliente
      AND mp.id_medio_de_pago = v.id_medio_de_pago AND p.id_producto = v.id_producto
GROUP BY cube (t.mes, t.anio, c.nombre, p.nombre, s.direccion, ci.descripcion, prov.descripcion, r.descripcion, mp.descripcion, v.monto_vendido, v.cantidad_vendida)

----------------------------------
---------- consulta 2-------------

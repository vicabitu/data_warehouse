
/*Carga inicial del data warehouse*/


insert into region values (1, 'Patagonia');
insert into provincia values (1, 1, 'Chubut');
insert into ciudad values (1, 1, 'Trelew');
insert into ciudad values (2, 1, 'Comodoro');
insert into ciudad values (3, 1, 'Esquel');
insert into sucursal values (1, 1, 'Moreno 1500');
insert into sucursal values (2, 2, 'Rivadavia 154');
insert into sucursal values (3, 3, 'Sarmiento 380');

-------------------------------------------------------------------------------------------------------------

insert into medio_de_pago values(10, 'Efectivo', 1, 1, 'Compra');
insert into medio_de_pago values(11, 'Tarjeta de credito', 2, 2, 'Compra con tarjeta');
insert into medio_de_pago values(12, 'Cuenta corriente', 3, 3, 'Compra con cuenta');
insert into medio_de_pago values(13, 'Tarjeta de debito', 4, 4, 'Compra con tarjeta de debito');
insert into medio_de_pago values(14, 'Cheque', 5, 5, 'Compra con cheque');

------------------------------------------------------------------------------------------------------------------------

insert into categoria values(1, 10, 'frutas');
insert into categoria values(2, 20, 'hortalizas y legumbres');

-------------------------------------------------------------------

--Alta de tipos de clientes

insert into tipo_cliente values(1, 'Fabrica');
insert into tipo_cliente values(2, 'Pyme');
insert into tipo_cliente values(3, 'Cooperativa');
insert into tipo_cliente values(4, 'Supermercado');

------------------------------------------------------------------------------------------------------------------------

CREATE EXTENSION dblink;

select dblink_connect('conexion_DW_comodoro', 'dbname=comodoro');
select dblink_connect('conexion_DW_esquel', 'dbname=esquel');
select dblink_connect('conexion_DW_trelew', 'dbname=trelew');


INSERT INTO equivalencia_clientes (cliente_comodoro)
SELECT  nro_cliente
FROM dblink ('conexion_DW_comodoro','
SELECT nro_cliente
FROM clientes'
) as consulta(nro_cliente int)

INSERT INTO equivalencia_clientes (cliente_esquel)
SELECT  nro_cliente
FROM dblink ('conexion_DW_esquel','
SELECT nro_cliente
FROM clientes'
) as consulta(nro_cliente int)

INSERT INTO equivalencia_clientes (cliente_trelew)
SELECT  nro_cliente
FROM dblink ('conexion_DW_trelew','
SELECT nro_cliente
FROM clientes'
) as consulta(nro_cliente int);

DELETE FROM equivalencia_clientes WHERE cliente_esquel = 2
UPDATE equivalencia_clientes SET cliente_esquel = 2 WHERE cliente_comodoro = 1
DELETE FROM equivalencia_clientes WHERE cliente_esquel = 4
UPDATE equivalencia_clientes SET cliente_esquel = 4 WHERE cliente_comodoro = 4
DELETE FROM equivalencia_clientes WHERE cliente_esquel = 23
UPDATE equivalencia_clientes SET cliente_esquel = 23 WHERE cliente_trelew = 2
DELETE FROM equivalencia_clientes WHERE cliente_esquel = 30
UPDATE equivalencia_clientes SET cliente_esquel = 30 WHERE cliente_comodoro = 9
DELETE FROM equivalencia_clientes WHERE cliente_esquel = 35
UPDATE equivalencia_clientes SET cliente_esquel = 35 WHERE cliente_comodoro = 7

----

INSERT INTO equivalencia_productos (producto_trelew)
SELECT  nro_producto
FROM dblink ('conexion_DW_trelew','
SELECT nro_producto
FROM productos'
) as consulta(nro_producto int)

INSERT INTO equivalencia_productos (producto_comodoro)
SELECT  codigo_producto
FROM dblink ('conexion_DW_comodoro','
SELECT codigo_producto
FROM productos'
) as consulta(codigo_producto int)

UPDATE equivalencia_productos SET producto_esquel = 1 WHERE producto_comodoro = 1
UPDATE equivalencia_productos SET producto_esquel = 2 WHERE producto_comodoro = 2
UPDATE equivalencia_productos SET producto_esquel = 3 WHERE producto_comodoro = 3
UPDATE equivalencia_productos SET producto_esquel = 4 WHERE producto_comodoro = 4
UPDATE equivalencia_productos SET producto_esquel = 5 WHERE producto_comodoro = 5
UPDATE equivalencia_productos SET producto_esquel = 6 WHERE producto_comodoro = 6
UPDATE equivalencia_productos SET producto_esquel = 7 WHERE producto_comodoro = 7
UPDATE equivalencia_productos SET producto_esquel = 8 WHERE producto_comodoro = 8
UPDATE equivalencia_productos SET producto_esquel = 9 WHERE producto_comodoro = 9
UPDATE equivalencia_productos SET producto_esquel = 10 WHERE producto_comodoro = 10
UPDATE equivalencia_productos SET producto_esquel = 11 WHERE producto_comodoro = 11
UPDATE equivalencia_productos SET producto_esquel = 12 WHERE producto_comodoro = 12
UPDATE equivalencia_productos SET producto_esquel = 13 WHERE producto_comodoro = 13
UPDATE equivalencia_productos SET producto_esquel = 14 WHERE producto_comodoro = 14
UPDATE equivalencia_productos SET producto_esquel = 15 WHERE producto_comodoro = 15
UPDATE equivalencia_productos SET producto_esquel = 16 WHERE producto_comodoro = 16
UPDATE equivalencia_productos SET producto_esquel = 17 WHERE producto_comodoro = 17
UPDATE equivalencia_productos SET producto_esquel = 18 WHERE producto_comodoro = 18
UPDATE equivalencia_productos SET producto_esquel = 19 WHERE producto_comodoro = 19
UPDATE equivalencia_productos SET producto_esquel = 20 WHERE producto_comodoro = 20



------

--select * from dblink('conexion_DW_comodoro', 'select codigo_cliente from clientes') as curso_alumno(codigo_cliente int)

--create or replace function carga_tabla_de_equivalencia_clientes() returns void as
--$body$

--begin

--		insert into equivalencia_clientes
--			(cliente_trelew),
--			(select codigo_cliente
--			from dblink ('conexion_DW_comodoro', 'select codigo_cliente from clientes') as
--				cliente(codigo_cliente int)),
--			(cliente_esquel)

--	return;
--end $body$
--language 'plpgsql'

--INSERT INTO teClientes (CSN)
--	SELECT nro_cliente
--	FROM dblink (myconn, ‘SELECT nro_cliente FROM Clientes’) as
--                          consulta(nro_cliente integer)

-----------

--CREATE TABLE tmpVentas(
--    fecha date,
--    idFactura int,
--    idCliente int,
--    idProducto int,
--    idSucursal int,
--    medio_de_pago int,
--    monto real,
--    cantidad_vendida int,
--    nombre_producto_vendido int,
--    categoria int,
--    subcategoria int,
--    precio real,
--    nombre_cliente int,
--    tipo_cliente int
--)

CREATE OR REPLACE FUNCTION carga_datawarehouse_trelew() returns void as $$
DECLARE

BEGIN

  SELECT *
  INTO tmpVentas
  FROM DBLINK (conexion_DW_trelew,
    'SELECT
    v.fecha_vta as fecha,
    v.nro_factura as idFactura,
    v.nro_cliente as idCliente,
    dv.nro_producto as idProducto, '
    dv.unidad * dv.precio as monto_vendido,
    + 0 +'as Sucursal,
    v.forma_pago as forma_de_pago,
    dv.unidad as cantidad_vendida,
    p.nombre as nombre_producto,
    p.nro_categoria as categoria,'
    + 0 + 'as subcategoria,
    dv.precio as precio_producto,
    c.nombre as nombre_cliente,
    c.tipo as tipo_cliente,
    c.direccion as direccion,'
    + "-" + 'descripcion_tipo_cliente

    FROM ventas v, detalle_venta dv, clientes c, producto p

    WHERE v.idFactura = dv.idFactura and
          AND v.nro_cliente = c.nro_cliente
          AND dv.nro_producto = p.nro_producto
          AND date_part ( ‘month’,   fecha) =  '
          + pMes +
          'and date_part (‘year’,  fecha) = '
          + pAño
  )

  INSERT INTO clientes
  SELECT DISTINCT teC.cliente_unificado, v.nombre_cliente, v.tipo_cliente, v.direccion
  FROM tmpVentas v, equivalencia_clientes teC
  WHERE v.idCliente = teC.cliente_trelew AND teC.cliente_unificado not in (SELECT id_cliente from clientes)

  INSERT INTO tipo_cliente
  SELECT DISTINCT v.tipo_cliente, v.descripcion_tipo_cliente
  FROM tmpVentas v
  WHERE v.tipo_cliente not in (SELECT id_tipo_cliente FROM tipo_cliente)

  INSERT INTO tiempo
  SELECT DISTINCT
  FROM

  INSERT INTO venta
  SELECT v.idTiempo, v.fecha, teC.cliente_unificado, v.forma_de_pago, v.sucursal, teProductos.producto_unificado, v.monto_vendido, v.cantidad_vendida
  FROM tmpVentas v, equivalencia_clientes teC, equivalencia_productos teP
  WHERE v.idCliente = equivalencia_clientes.cliente_trelew AND v.idProducto =equivalencia_productos.producto_trelew


  INSERT INTO producto
  SELECT DISTINCT CDW, nombre, categoria
  FROM tmpVentas v, equivalencia_productos teP
  WHERE v.idProducto = teP.producto_trelew AND teP.producto_unificado not in (SELECT id_producto FROM producto)


END;
$$ LANGUAGE plpgsql;

  ---------

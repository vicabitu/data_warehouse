
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

--Alta medios de pago

insert into medio_de_pago values(10, 'Efectivo', 1, 1, 'Compra');
insert into medio_de_pago values(11, 'Tarjeta de credito', 2, 2, 'Compra con tarjeta');
insert into medio_de_pago values(12, 'Cuenta corriente', 3, 3, 'Compra con cuenta');
insert into medio_de_pago values(13, 'Tarjeta de debito', 4, 4, 'Compra con tarjeta de debito');
insert into medio_de_pago values(14, 'Cheque', 5, 5, 'Compra con cheque');

------------------------------------------------------------------------------------------------------------------------

--Alta categoria

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

/*Carga tabla de equivalencia de clientes*/

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

/*----------------------------------------------------------------------------------------------------------------------------------*/

/*Carga tabla de equivalencia de productos*/

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


/*----------------------------------------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE FUNCTION sacar_trimestre(mes int) returns int as $$
BEGIN
  CASE mes
    WHEN 1 THEN return 1;
    WHEN 2 THEN return 1;
    WHEN 3 THEN return 1;
    WHEN 4 THEN return 2;
    WHEN 5 THEN return 2;
    WHEN 6 THEN return 2;
    WHEN 7 THEN return 3;
    WHEN 8 THEN return 3;
    WHEN 9 THEN return 3;
    WHEN 10 THEN return 4;
    WHEN 11 THEN return 4;
    WHEN 12 THEN return 4;
  END CASE;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION carga_datawarehouse_trelew(pMes int, pAnio int) returns void as $$

BEGIN

	create temp table tmpVentas(

		fecha_venta date,
		id_cliente integer,
		id_medio_de_pago integer,
		id_sucursal integer,
		id_producto integer,
		monto_vendido real,
		cantidad_vendida integer,
		nombre_cliente varchar(30),
		id_tipo_cliente integer,
		nombre_producto varchar(30),
		id_categoria_producto integer

	);

	insert into tmpVentas
	select *
	from dblink('conexion_DW_trelew',
		'select v.fecha_vta, v.nro_cliente, 1, 1, dv.nro_producto,
			dv.precio * dv.unidad, dv.unidad, c.nombre, c.tipo, p.nombre, p.nro_categoria
			from venta v, detalle_venta dv, productos p, clientes c
			where v.nro_factura = dv.nro_factura and
				v.nro_cliente = c.nro_cliente and
				dv.nro_producto = p.nro_producto and
				(select date_part(''month'', fecha_vta)) = '|| pMes ||' and 
				(select date_part(''year'', fecha_vta)) = '|| pAnio ||';')

			as tablaTemp(fecha_vta date, id_cliente integer, id_medio_de_pago integer,
				id_sucursal integer, id_producto integer, monto_vendido real,
				cantidad_vendida integer, nombre_cliente varchar(30), id_tipo_cliente integer,
				nombre_producto varchar(30), id_categoria_producto integer);

	INSERT INTO clientes
	SELECT DISTINCT teC.cliente_unificado, v.nombre_cliente, v.id_tipo_cliente
	FROM tmpVentas v, equivalencia_clientes teC
	WHERE v.id_cliente = teC.cliente_trelew AND teC.cliente_unificado not in (SELECT id_cliente from clientes);

	IF NOT EXISTS(SELECT * FROM tiempo WHERE mes = pMes AND anio = pAnio) THEN

	  INSERT INTO tiempo VALUES (pMes, pAnio, sacar_trimestre(pMes));

	END IF;

	INSERT INTO venta
	SELECT DISTINCT t.id_tiempo, teC.cliente_unificado, v.id_medio_de_pago, v.id_sucursal, teP.producto_unificado, v.monto_vendido, v.cantidad_vendida, v.fecha_venta
	FROM tmpVentas v, equivalencia_clientes teC, equivalencia_productos teP, tiempo t
	WHERE v.id_cliente = teC.cliente_trelew AND v.id_producto = teP.producto_trelew AND t.mes = pMes AND t.anio = pAnio;

	INSERT INTO producto
	SELECT DISTINCT tep.producto_unificado, v.nombre_producto, v.id_categoria_producto
	FROM tmpVentas v, equivalencia_productos teP
	WHERE v.id_producto = teP.producto_trelew AND teP.producto_unificado not in (SELECT id_producto FROM producto);

END;
$$ LANGUAGE plpgsql;

drop table tmpVentas

select carga_datawarehouse_trelew(08, 2011)

select date_part('month', date '2013-05-30')


CREATE OR REPLACE FUNCTION carga_datawarehouse_comodoro(pMes int, pAnio int) returns void as $$
DECLARE

BEGIN

  SELECT *
  INTO tmpVentas
  FROM DBLINK ('conexion_DW_comodoro',
    'SELECT
    v.fecha_venta as fecha,
    v.id_factura as idFactura,
    v.codigo_cliente as idCliente,
    dv.codigo_producto as idProducto,
    ' + 1 + ' as Sucursal,
    v.codigo_medio_de_pago as forma_de_pago,
    dv.unidad * dv.precio as monto_vendido,
    dv.unidad as cantidad_vendida,
    p.nombre as nombre_producto,
    p.codigo_categoria as categoria,
    p.codigo_subcategoria as subcategoria,
    dv.precio as precio_producto,
    c.nombre as nombre_cliente,
    c.codigo_tipo as tipo_cliente,
    c.direccion as direccion

    FROM venta v, detalle_de_venta dv, clientes c, producto p

    WHERE v.idFactura = dv.idFactura and
          AND cat.nro_categoria = p.nro_categoria
          AND v.nro_cliente = c.nro_cliente
          AND dv.nro_producto = p.nro_producto
          AND date_part ( ‘month’,   v.fecha) =
          '+ pMes + '
          'and date_part (‘year’,  v.fecha) = '
          + pAnio'
  );

  INSERT INTO clientes
  SELECT DISTINCT teC.cliente_unificado, v.nombre_cliente, v.tipo_cliente, v.direccion
  FROM tmpVentas v, equivalencia_clientes teC
  WHERE v.idCliente = teC.cliente_comodoro AND teC.cliente_unificado not in (SELECT id_cliente from clientes)

  IF NOT EXISTS(SELECT * FROM tiempo WHERE mes = pMes AND anio = pAnio)
  BEGIN
      INSERT INTO tiempo VALUES (pMes, pAnio, sacar_trimestre(pMes))
  END

  INSERT INTO venta
  SELECT t.id_tiempo, v.fecha, teC.cliente_unificado, v.forma_de_pago, v.sucursal, teProductos.producto_unificado, v.monto_vendido, v.cantidad_vendida
  FROM tmpVentas v, equivalencia_clientes teC, equivalencia_productos teP, tiempo t
  WHERE v.idCliente = equivalencia_clientes.cliente_comodoro AND v.idProducto = equivalencia_productos.producto_comodoro AND t.mes = pMes AND t.anio = pAnio

  INSERT INTO producto
  SELECT DISTINCT tep.producto_unificado, v.nombre_producto, v.categoria
  FROM tmpVentas v, equivalencia_productos teP
  WHERE v.idProducto = teP.producto_comodoro AND teP.producto_unificado not in (SELECT id_producto FROM producto)

  DROP TABLE tmpVentas;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION carga_datawarehouse_esquel(pMes int, pAnio int) returns void as $$
DECLARE

BEGIN

  SELECT *
  INTO tmpVentas
  FROM DBLINK (conexion_DW_esquel,
    'SELECT
    v.fecha_venta as fecha,
    v.id_factura as idFactura,
    v.codigo_cliente as idCliente,
    dv.codigo_producto as idProducto, '
    + 2 +'as Sucursal,
    v.codigo_medio_de_pago as forma_de_pago,
    dv.unidad * dv.precio as monto_vendido,
    dv.unidad as cantidad_vendida,
    p.nombre as nombre_producto,
    p.codigo_categoria as categoria,
    p.codigo_subcategoria as subcategoria,
    dv.precio as precio_producto,
    c.nombre as nombre_cliente,
    c.codigo_tipo as tipo_cliente,
    c.direccion as direccion

    FROM venta v, detalle_de_venta dv, clientes c, producto p

    WHERE v.idFactura = dv.idFactura and
          AND cat.nro_categoria = p.nro_categoria
          AND v.nro_cliente = c.nro_cliente
          AND dv.nro_producto = p.nro_producto
          AND date_part ( ‘month’,   v.fecha) =  '
          + pMes +
          'and date_part (‘year’,  v.fecha) = '
          + pAnio
  );

  INSERT INTO clientes
  SELECT DISTINCT teC.cliente_unificado, v.nombre_cliente, v.tipo_cliente, v.direccion
  FROM tmpVentas v, equivalencia_clientes teC
  WHERE v.idCliente = teC.cliente_esquel AND teC.cliente_unificado not in (SELECT id_cliente from clientes)

  IF NOT EXISTS(SELECT * FROM tiempo WHERE mes = pMes AND anio = pAnio)
  BEGIN
      INSERT INTO tiempo VALUES (pMes, pAnio, sacar_trimestre(pMes))
  END

  INSERT INTO venta
  SELECT t.id_tiempo, v.fecha, teC.cliente_unificado, v.forma_de_pago, v.sucursal, teProductos.producto_unificado, v.monto_vendido, v.cantidad_vendida
  FROM tmpVentas v, equivalencia_clientes teC, equivalencia_productos teP, tiempo t
  WHERE v.idCliente = equivalencia_clientes.cliente_esquel AND v.idProducto = equivalencia_productos.producto_esquel AND t.mes = pMes AND t.anio = pAnio

  INSERT INTO producto
  SELECT DISTINCT tep.producto_unificado, v.nombre_producto, v.categoria
  FROM tmpVentas v, equivalencia_productos teP
  WHERE v.idProducto = teP.producto_esquel AND teP.producto_unificado not in (SELECT id_producto FROM producto)

  DROP TABLE tmpVentas;

END;
$$ LANGUAGE plpgsql;

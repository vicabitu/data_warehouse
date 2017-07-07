

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

--Conexiones a las bases de datos operacionales

select dblink_connect('conexion_DW_comodoro', 'dbname=comodoro');
select dblink_connect('conexion_DW_esquel', 'dbname=esquel');
select dblink_connect('conexion_DW_trelew', 'dbname=trelew');

/*Carga tabla de equivalencia de clientes*/

INSERT INTO equivalencia_clientes (cliente_comodoro)
SELECT  codigo_cliente
FROM dblink ('conexion_DW_comodoro','
SELECT codigo_cliente
FROM clientes'
) as consulta(codigo_cliente int);

INSERT INTO equivalencia_clientes (cliente_esquel)
SELECT  codigo_cliente
FROM dblink ('conexion_DW_esquel','
SELECT codigo_cliente
FROM clientes'
) as consulta(codigo_cliente int);

INSERT INTO equivalencia_clientes (cliente_trelew)
SELECT  nro_cliente
FROM dblink ('conexion_DW_trelew','
SELECT nro_cliente
FROM clientes'
) as consulta(nro_cliente int);


--Modificaciones necesarias a la tabla de quivalencia para que se unifiquen los id
DELETE FROM equivalencia_clientes WHERE cliente_esquel = 2;
UPDATE equivalencia_clientes SET cliente_esquel = 2 WHERE cliente_comodoro = 1;
DELETE FROM equivalencia_clientes WHERE cliente_esquel = 4;
UPDATE equivalencia_clientes SET cliente_esquel = 4 WHERE cliente_comodoro = 4;
DELETE FROM equivalencia_clientes WHERE cliente_esquel = 23;
UPDATE equivalencia_clientes SET cliente_esquel = 23 WHERE cliente_trelew = 2;
DELETE FROM equivalencia_clientes WHERE cliente_esquel = 30;
UPDATE equivalencia_clientes SET cliente_esquel = 30 WHERE cliente_comodoro = 9;
DELETE FROM equivalencia_clientes WHERE cliente_esquel = 35;
UPDATE equivalencia_clientes SET cliente_esquel = 35 WHERE cliente_comodoro = 7;

/*----------------------------------------------------------------------------------------------------------------------------------*/

/*Carga tabla de equivalencia de productos*/

INSERT INTO equivalencia_productos (producto_trelew)
SELECT  nro_producto
FROM dblink ('conexion_DW_trelew','
SELECT nro_producto
FROM productos'
) as consulta(nro_producto int);

INSERT INTO equivalencia_productos (producto_comodoro)
SELECT  codigo_producto
FROM dblink ('conexion_DW_comodoro','
SELECT codigo_producto
FROM producto'
) as consulta(codigo_producto int);

--Modificaciones necesarias a la tabla de quivalencia para que se unifiquen los id
UPDATE equivalencia_productos SET producto_esquel = 1 WHERE producto_comodoro = 1;
UPDATE equivalencia_productos SET producto_esquel = 2 WHERE producto_comodoro = 2;
UPDATE equivalencia_productos SET producto_esquel = 3 WHERE producto_comodoro = 3;
UPDATE equivalencia_productos SET producto_esquel = 4 WHERE producto_comodoro = 4;
UPDATE equivalencia_productos SET producto_esquel = 5 WHERE producto_comodoro = 5;
UPDATE equivalencia_productos SET producto_esquel = 6 WHERE producto_comodoro = 6;
UPDATE equivalencia_productos SET producto_esquel = 7 WHERE producto_comodoro = 7;
UPDATE equivalencia_productos SET producto_esquel = 8 WHERE producto_comodoro = 8;
UPDATE equivalencia_productos SET producto_esquel = 9 WHERE producto_comodoro = 9;
UPDATE equivalencia_productos SET producto_esquel = 10 WHERE producto_comodoro = 10;
UPDATE equivalencia_productos SET producto_esquel = 11 WHERE producto_comodoro = 11;
UPDATE equivalencia_productos SET producto_esquel = 12 WHERE producto_comodoro = 12;
UPDATE equivalencia_productos SET producto_esquel = 13 WHERE producto_comodoro = 13;
UPDATE equivalencia_productos SET producto_esquel = 14 WHERE producto_comodoro = 14;
UPDATE equivalencia_productos SET producto_esquel = 15 WHERE producto_comodoro = 15;
UPDATE equivalencia_productos SET producto_esquel = 16 WHERE producto_comodoro = 16;
UPDATE equivalencia_productos SET producto_esquel = 17 WHERE producto_comodoro = 17;
UPDATE equivalencia_productos SET producto_esquel = 18 WHERE producto_comodoro = 18;
UPDATE equivalencia_productos SET producto_esquel = 19 WHERE producto_comodoro = 19;
UPDATE equivalencia_productos SET producto_esquel = 20 WHERE producto_comodoro = 20;


/*----------------------------------------------------------------------------------------------------------------------------------*/

--Funcion que retorna el numero de trimestre segun el numero de mes que
--recibe como parametro
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


--Funcion que retorna el id de pago segun la cadena de forma de pago que reciba
CREATE OR REPLACE FUNCTION get_id_forma_pago(f_p varchar(20)) returns int as $$
BEGIN
  CASE f_p
    WHEN 'crédito' THEN return 11;
    WHEN 'débito' THEN return 13;
    WHEN 'efectivo' THEN return 10;
  END CASE;
END;
$$ LANGUAGE plpgsql;


--
--
--
--Script ETL para la sucursal de Trelew
CREATE OR REPLACE FUNCTION carga_datawarehouse_trelew(pMes integer, pAnio integer) returns void AS $$

BEGIN

  CREATE TEMP TABLE tmpVentas(

    fecha date,
    idFactura integer,
    idCliente integer,
    idProducto integer,
    forma_de_pago varchar(20),
    monto_vendido real,
    cantidad_vendida integer,
    nombre_producto varchar(30),
    categoria integer,
    precio integer,
    nombre_cliente varchar(30),
    tipo_cliente integer

  );

  INSERT INTO tmpVentas
  SELECT *
  FROM DBLINK ('conexion_DW_trelew',
    'SELECT
    v.fecha_vta,
    v.nro_factura,
    v.nro_cliente,
    dv.nro_producto,
    v.forma_pago,
    dv.unidad * dv.precio,
    dv.unidad,
    p.nombre,
    p.nro_categoria,
    dv.precio,
    c.nombre,
    c.tipo

    FROM venta v, detalle_venta dv, clientes c, productos p

    WHERE v.nro_factura = dv.nro_factura
          AND v.nro_cliente = c.nro_cliente
          AND dv.nro_producto = p.nro_producto
          AND (select date_part(''month'', fecha_vta)) = '|| pMes ||'
          AND (select date_part(''year'', fecha_vta)) = '|| pAnio ||';'

    ) AS tablaTemp(fecha date, idFactura integer, idCliente integer,
      idProducto integer, forma_de_pago varchar(20), monto_vendido real,
      cantidad_vendida integer, nombre_producto varchar(30),
      categoria integer, precio real,
      nombre_cliente varchar(30), tipo_cliente integer);


  INSERT INTO clientes
  SELECT DISTINCT teC.cliente_unificado, v.nombre_cliente, v.tipo_cliente
  FROM tmpVentas v, equivalencia_clientes teC
  WHERE v.idCliente = teC.cliente_trelew AND teC.cliente_unificado not in (SELECT id_cliente from clientes);

  BEGIN
	IF NOT EXISTS(SELECT * FROM tiempo WHERE mes = pMes AND anio = pAnio) THEN

	 INSERT INTO tiempo VALUES (default, pMes, pAnio, (SELECT sacar_trimestre(pMes)));

	END IF;
  EXCEPTION
	WHEN others THEN
	--pass
  END;

  INSERT INTO producto
  SELECT DISTINCT tep.producto_unificado, v.nombre_producto, v.categoria
  FROM tmpVentas v, equivalencia_productos teP
  WHERE v.idProducto = teP.producto_trelew AND teP.producto_unificado not in (SELECT id_producto FROM producto);

  INSERT INTO venta
  SELECT t.id_tiempo, v.fecha, teC.cliente_unificado, (SELECT get_id_forma_pago(v.forma_de_pago)), 1, teP.producto_unificado, v.monto_vendido, v.cantidad_vendida
  FROM tmpVentas v, equivalencia_clientes teC, equivalencia_productos teP, tiempo t
  WHERE v.idCliente = teC.cliente_trelew AND v.idProducto = teP.producto_trelew;

  DROP TABLE tmpVentas;

END
$$ LANGUAGE 'plpgsql';

--select carga_datawarehouse_trelew(04, 2011);

--Script ETL para la sucursal de Comodoro
CREATE OR REPLACE FUNCTION carga_datawarehouse_comodoro(pMes int, pAnio int) returns void as $$
DECLARE

BEGIN

CREATE TEMP TABLE tmpVentas(

  fecha date,
  idFactura integer,
  idCliente integer,
  idProducto integer,
  forma_de_pago integer,
  monto_vendido integer,
  cantidad_vendida integer,
  nombre_producto varchar(30),
  categoria integer,
  subcategoria integer,
  precio real,
  nombre_cliente varchar(30),
  tipo_cliente integer

);

  INSERT INTO tmpVentas
  SELECT *
  FROM DBLINK ('conexion_DW_comodoro',
    'SELECT
    v.fecha_venta,
    v.id_factura,
    v.codigo_cliente,
    dv.codigo_producto,
    v.codigo_medio_de_pago,
    dv.unidad * dv.precio,
    dv.unidad,
    p.nombre,
    p.codigo_categoria,
    p.codigo_subcategoria,
    dv.precio,
    c.nombre,
    c.codigo_tipo

    FROM venta v, detalle_de_venta dv, clientes c, producto p

    WHERE v.id_factura = dv.id_factura
          AND v.codigo_cliente = c.codigo_cliente
          AND dv.codigo_producto = p.codigo_producto
          AND (select date_part(''month'', fecha_venta)) = '|| pMes ||'
  	  AND (select date_part(''year'', fecha_venta)) = '|| pAnio ||';'

  ) AS tablaTemp(fecha date, idFactura integer, idCliente integer,
    idProducto integer, forma_de_pago integer, monto_vendido real,
    cantidad_vendida integer, nombre_producto varchar(30),
    categoria integer, subcategoria integer, precio real,
    nombre_cliente varchar(30), tipo_cliente integer);

  INSERT INTO clientes
  SELECT DISTINCT teC.cliente_unificado, v.nombre_cliente, v.tipo_cliente
  FROM tmpVentas v, equivalencia_clientes teC
  WHERE v.idCliente = teC.cliente_comodoro AND teC.cliente_unificado not in (SELECT id_cliente from clientes);

  BEGIN
	IF NOT EXISTS(SELECT * FROM tiempo WHERE mes = pMes AND anio = pAnio) THEN

	INSERT INTO tiempo VALUES (default, pMes, pAnio, (SELECT sacar_trimestre(pMes)));

	END IF;
  EXCEPTION
	WHEN others THEN
	--pass
  END;

  INSERT INTO producto
  SELECT DISTINCT teP.producto_unificado, v.nombre_producto, v.categoria
  FROM tmpVentas v, equivalencia_productos teP
  WHERE v.idProducto = teP.producto_comodoro AND teP.producto_unificado not in (SELECT id_producto FROM producto);

  INSERT INTO venta
  SELECT t.id_tiempo, v.fecha, teC.cliente_unificado, v.forma_de_pago, 2, teP.producto_unificado, v.monto_vendido, v.cantidad_vendida
  FROM tmpVentas v, equivalencia_clientes teC, equivalencia_productos teP, tiempo t
  WHERE v.idCliente = teC.cliente_comodoro AND v.idProducto = teP.producto_comodoro AND t.mes = pMes AND t.anio = pAnio;

  DROP TABLE tmpVentas;

END;
$$ LANGUAGE plpgsql;

--SELECT carga_datawarehouse_comodoro(8,2011);

--Script ETL para la sucursal de Esquel
CREATE OR REPLACE FUNCTION carga_datawarehouse_esquel(pMes int, pAnio int) returns void as $$
DECLARE

BEGIN

  CREATE TEMP TABLE tmpVentas(

    fecha date,
    idFactura integer,
    idCliente integer,
    idProducto integer,
    forma_de_pago integer,
    monto_vendido integer,
    cantidad_vendida integer,
    nombre_producto varchar(30),
    categoria integer,
    subcategoria integer,
    precio real,
    nombre_cliente varchar(30),
    tipo_cliente integer

  );

  INSERT INTO tmpVentas
  SELECT *
  FROM DBLINK ('conexion_DW_esquel',
    'SELECT
    v.fecha_venta,
    v.id_factura,
    v.codigo_cliente,
    dv.codigo_producto,
    v.codigo_medio_de_pago,
    dv.unidad * dv.precio,
    dv.unidad,
    p.nombre,
    p.codigo_categoria,
    p.codigo_subcategoria,
    dv.precio,
    c.nombre,
    c.codigo_tipo

    FROM venta v, detalle_de_venta dv, clientes c, producto p

    WHERE v.id_factura = dv.id_factura
          AND v.codigo_cliente = c.codigo_cliente
          AND dv.codigo_producto = p.codigo_producto
          AND (select date_part(''month'', fecha_venta)) = '|| pMes ||'
  	  AND (select date_part(''year'', fecha_venta)) = '|| pAnio ||';'

  ) AS tablaTemp(fecha date, idFactura integer, idCliente integer,
    idProducto integer, forma_de_pago integer, monto_vendido real,
    cantidad_vendida integer, nombre_producto varchar(30),
    categoria integer, subcategoria integer, precio real,
    nombre_cliente varchar(30), tipo_cliente integer);


  INSERT INTO clientes
  SELECT DISTINCT teC.cliente_unificado, v.nombre_cliente, v.tipo_cliente
  FROM tmpVentas v, equivalencia_clientes teC
  WHERE v.idCliente = teC.cliente_esquel AND teC.cliente_unificado not in (SELECT id_cliente from clientes);

  BEGIN
	IF NOT EXISTS(SELECT * FROM tiempo WHERE mes = pMes AND anio = pAnio) THEN

	INSERT INTO tiempo VALUES (default, pMes, pAnio, (SELECT sacar_trimestre(pMes)));

	END IF;
  EXCEPTION
	WHEN others THEN
	--pass
  END;

  INSERT INTO producto
  SELECT DISTINCT tep.producto_unificado, v.nombre_producto, v.categoria
  FROM tmpVentas v, equivalencia_productos teP
  WHERE v.idProducto = teP.producto_esquel AND teP.producto_unificado not in (SELECT id_producto FROM producto);

  INSERT INTO venta
  SELECT t.id_tiempo, v.fecha, teC.cliente_unificado, v.forma_de_pago, 3, teP.producto_unificado, v.monto_vendido, v.cantidad_vendida
  FROM tmpVentas v, equivalencia_clientes teC, equivalencia_productos teP, tiempo t
  WHERE v.idCliente = teC.cliente_esquel AND v.idProducto = teP.producto_esquel AND t.mes = pMes AND t.anio = pAnio;

  DROP TABLE tmpVentas;

END;
$$ LANGUAGE plpgsql;


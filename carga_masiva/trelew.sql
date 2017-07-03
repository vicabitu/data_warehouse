--Sitema Viejo

-- Funcion para número entero al azar
CREATE OR REPLACE FUNCTION azar(desde integer, hasta integer) RETURNS integer AS $$
BEGIN
	RETURN (SELECT trunc(random() * (hasta) + desde));
END
$$ LANGUAGE plpgsql;
--Se ejecuta:
--SELECT azar(1,100);

--Funcion para fecha al azar (año-mes-día)
CREATE OR REPLACE FUNCTION fechaAzar() RETURNS date as $$
BEGIN
	RETURN (SELECT date(now() - trunc(random()  * 2900) * '1 day'::interval));
END
$$ LANGUAGE plpgsql;
--Se ejecuta:
--SELECT fechaAzar();

--Funcion para forma de pago al azar
CREATE OR REPLACE FUNCTION formaPagoAzar() RETURNS varchar(20) AS $$
DECLARE
	nroFormaPago integer;
BEGIN
	nroFormaPago = (SELECT azar(1,3));
	CASE nroFormaPago
    WHEN 1 THEN
        RETURN 'crédito';
    WHEN 2 THEN
        RETURN 'débito';
    ELSE
	RETURN 'efectivo';
    END CASE;
END
$$ LANGUAGE plpgsql;
--Se ejecuta
--SELECT formaPagoAzar();

-- Funcion de carga
CREATE OR REPLACE FUNCTION cargaSistemaViejo() RETURNS integer AS $$
DECLARE
	x integer;
	y integer;
	NroClienteAux integer;
	NroProductoAux integer;
	Unidad integer;
	ArregloDetalle integer[];
BEGIN
	--Categorías
	INSERT INTO categoria VALUES (1, 'Congelados');
	INSERT INTO categoria VALUES (2, 'Sin Conservantes');
	INSERT INTO categoria VALUES (3, 'Con Conservantes');

	--Producto
	INSERT INTO productos VALUES (1,'Papa',azar(1,3),azar(50,300));
	INSERT INTO productos VALUES (2,'Zapallo',azar(1,3),azar(50,300));
	INSERT INTO productos VALUES (3,'Uvas',azar(1,3),azar(50,300));
	INSERT INTO productos VALUES (4,'Manzana',azar(1,3),azar(50,300));
	INSERT INTO productos VALUES (5,'Banana',azar(1,3),azar(50,300));
	INSERT INTO productos VALUES (6,'Cebolla',azar(1,3),azar(50,300));
	INSERT INTO productos VALUES (7,'Rúcula',azar(1,3),azar(50,300));
	INSERT INTO productos VALUES (8,'Frutilla',azar(1,3),azar(50,300));
	INSERT INTO productos VALUES (9,'Lechuga',azar(1,3),azar(50,300));
	INSERT INTO productos VALUES (10,'Cerezas',azar(1,3),azar(50,300));

	--Clientes
	INSERT INTO clientes VALUES (1, 'Matías Mazzaglia', azar(1,3), 'Belgrano 514');
	INSERT INTO clientes VALUES (2, 'Ian Aguila', azar(1,3), 'Rivadavia 165');
	INSERT INTO clientes VALUES (3, 'Maximiliano Aranda', azar(1,3), 'Pellegrini 765');
	INSERT INTO clientes VALUES (4, 'Germán Acosta', azar(1,3), 'Moreno 612');
	INSERT INTO clientes VALUES (5, 'Tania Bianchini', azar(1,3), 'Sarmiento 1453');

	--Ventas y Detalles
	FOR x IN 1..300
	LOOP
		NroClienteAux = (SELECT azar(1,5));
		Unidad = (SELECT azar(1,10));
		y=0;
		--Venta
		INSERT INTO venta VALUES((SELECT fechaAzar()), x, NroClienteAux, (SELECT nombre FROM clientes WHERE nro_cliente = NroClienteAux), (SELECT formaPagoAzar()));
		--Detalle Venta
		FOR y IN 1..(SELECT azar(1,5))
		LOOP
			NroProductoAux = (SELECT nro_producto FROM productos prod WHERE prod.nro_producto NOT IN
													(SELECT nro_producto FROM detalle_Venta WHERE nro_factura = x)
											     ORDER BY random() LIMIT 1 );
			INSERT INTO detalle_venta VALUES(x, NroProductoAux, 'Nuestra venta', Unidad, (SELECT precio_actual FROM productos WHERE nro_producto = NroProductoAux) * Unidad);
		END LOOP;
	END LOOP;
	RETURN 0;
END;
$$ LANGUAGE plpgsql;

SELECT cargaSistemaViejo();

CREATE EXTENSION dblink;

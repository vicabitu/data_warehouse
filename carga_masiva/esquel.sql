﻿
/*Carga masiva de la sucursal Esquel*/

/*Sistema de facturacion nuevo (desde enero 2011)*/

-------------------------------------------------------------------

--Alta de tipos de clientes

insert into tipos_cliente values(1, 'Fabrica');

insert into tipos_cliente values(2, 'Pyme');

insert into tipos_cliente values(3, 'Cooperativa');

insert into tipos_cliente values(4, 'Supermercado');

--------------------------------------------------------------------

--Alta de clientes

insert into clientes values(1, 'Jorge Ramirez', 2, 'La Prida 250');

insert into clientes values(2, 'Juan Perez', 3, 'Colombia 1500');

insert into clientes values(20, 'Ornela Pereira', 1, 'Cooperativa');

insert into clientes values(4, 'Martina Rodriguez', 3, 'Mitre 1800');

insert into clientes values(23, 'Ian Aguila', 4, 'Rivadavia 165');

insert into clientes values(6, 'Julia Jones', 4, 'Mitre 852');

insert into clientes values(35, 'Lorena Vidal', 4, 'Ameghino 350');

insert into clientes values(8, 'Marta Lombardi', 1, 'Irigoyen 741');

insert into clientes values(30, 'Jorge James', 2, 'Ruta 3');

insert into clientes values(10, 'Beatriz Pineda', 4, 'Sargento Cabral 123');

------------------------------------------------------------------------------------------------------------------------

--Alta de categorias

insert into categoria values(1, 10, 'frutas');

insert into categoria values(2, 20, 'hortalizas y legumbres');

---------------------------------------------------------------------------------------------------------------------------

--Alta de productos

insert into producto values(1, 'Manzana', 1, 10, 36.5);
insert into producto values(2, 'Banana', 1, 10, 36.5);
insert into producto values(3, 'Frutilla', 1, 10, 50);
insert into producto values(7, 'Limon', 1, 10, 42);
insert into producto values(8, 'Mandarina', 1, 10, 35.75);
insert into producto values(9, 'Naranja', 1, 10, 37.80);
insert into producto values(10, 'Pomelo', 1, 10, 50);
insert into producto values(11, 'Durazno', 1, 12, 70);
insert into producto values(12, 'Ciruela', 1, 12, 40);
insert into producto values(4, 'Berenjena', 2, 20, 45.5);
insert into producto values(5, 'Espinaca', 2, 20, 38);
insert into producto values(6, 'Choclo', 2, 20, 46);
insert into producto values(13, 'Zapallito', 2, 21, 38.25);
insert into producto values(14, 'Zapallo', 2, 21, 30);
insert into producto values(15, 'Tomate', 2, 21, 55);
insert into producto values(16, 'Lechuga', 2, 22, 22);
insert into producto values(17, 'zanahoria', 2, 23, 15);
insert into producto values(18, 'Papa', 2, 24, 21.50);
insert into producto values(19, 'Pepino', 2, 21, 42);
insert into producto values(20, 'Pimientos', 2, 22, 34);

---------------------------------------------------------------------------------------------------------------------------

--ALta de medios de pago

insert into medio_de_pago values(10, 'Efectivo', 1, 1, 'Compra');

insert into medio_de_pago values(11, 'Tarjeta de credito', 2, 2, 'Compra con tarjeta');

insert into medio_de_pago values(12, 'Cuenta corriente', 3, 3, 'Compra con cuenta');

insert into medio_de_pago values(13, 'Tarjeta de debito', 4, 4, 'Compra con tarjeta de debito');

insert into medio_de_pago values(14, 'Cheque', 5, 5, 'Compra con cheque');

----------------------------------------------------------------------------------------------------------------------------

--Funcion que se utiliza para obtener una fecha
--Retorna una fecha (tipo date) al azar entre 2011 y 2017
create or replace function fecha_al_azar() returns date as $$
begin
	return (select date(now() - trunc(random() * 2300) * '1 day'::interval));
end
$$ language plpgsql;

----------------------------------------------------------------------------------------------------------------------------

create or replace function cliente_al_azar() returns integer as $$
declare
	aux_random integer;
begin
  aux_random := (select trunc(random() * (10-1+1)) + 1);
  CASE aux_random
    WHEN 1 THEN return 1;
    WHEN 2 THEN return 2;
    WHEN 3 THEN return 20;
    WHEN 4 THEN return 4;
    WHEN 5 THEN return 23;
    WHEN 6 THEN return 6;
    WHEN 7 THEN return 35;
    WHEN 8 THEN return 8;
    WHEN 9 THEN return 30;
    WHEN 10 THEN return 10;
  END CASE;
end
$$ language plpgsql;

---------------------------------------------------------------------------------------------------------------------------------

--Funcion de carga masiva para la sucursal, se dan de alta las facturas (tabla factura) y 
--por cada factura 15 detalles de factura (tabla detalle_de_factura)
create or replace function carga_de_ventas() returns void as
$body$
declare
	i integer;
	j integer;
	producto_en_detalle integer;
	unidades_vendidas integer;
	precio_producto real;
	nombre_producto_vendido varchar(30);

begin

	for i in 1..300 loop


		insert into venta values((select fecha_al_azar()), i, (select cliente_al_azar()), ('venta: ' || i), (select trunc(random() * (14-10+1)) + 10));


		for j in 1..15 loop

			--Selecciono un codigo de producto al azar que ya no este dentro de los seleccionados para la venta
			producto_en_detalle := (select codigo_producto from producto
							where producto.codigo_producto not in (select codigo_producto
								from detalle_de_venta where id_factura = i)
							order by random()
							limit 1);

			unidades_vendidas := (select trunc(random() * (50-1+1)) + 1);

			precio_producto := (select precio_actual from producto where producto.codigo_producto = producto_en_detalle);

			nombre_producto_vendido := (select nombre from producto where producto.codigo_producto = producto_en_detalle);

			insert into detalle_de_venta values(i, (producto_en_detalle), ('Producto vendido: ' || nombre_producto_vendido), (unidades_vendidas),
							   (unidades_vendidas * precio_producto));

		end loop;

	end loop;


	return;
end $body$
language 'plpgsql';

SELECT carga_de_ventas();
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE EXTENSION dblink;

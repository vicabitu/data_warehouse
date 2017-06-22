
/*Carga masiva de la sucursal Comodoro Rivadavia*/ 

/*Sistema de facturacion nuevo (desde enero 2011)*/

-------------------------------------------------------------------

insert into tipos_cliente values(1, 'Fabrica')

insert into tipos_cliente values(2, 'Pyme')

insert into tipos_cliente values(3, 'Cooperativa')

--------------------------------------------------------------------

insert into clientes values((select floor(random() * (10-1+1)) + 1), 'Ramiro Lopez', 2, 'Alem 353')

insert into clientes values(1, 'Juan Perez', 3, 'Colombia 1500')

insert into clientes values(2, 'Romina Martinez', 1, '9 de Julio 500')

insert into clientes values(3, 'Jorge Alvarez', 2, 'Pasaje Cordoba 50')

insert into clientes values(4, 'Martina Rodriguez', 3, 'Mitre 1800')

delete from clientes where codigo_cliente = 40


------------------------------------------------------------------------------------------------------------------------

insert into categoria values(1, 10, 'frutas')

insert into categoria values(2, 20, 'hortalizas y legumbres')


delete from categoria where codigo_categoria = 3

---------------------------------------------------------------------------------------------------------------------------

insert into producto values(1, 'Manzana', 1, 10, 36.5)

insert into producto values(2, 'Banana', 1, 10, 36.5)

insert into producto values(3, 'Frutilla', 1, 10, 50)

insert into producto values(4, 'Berenjena', 2, 20, 45.5)

insert into producto values(5, 'Espinaca', 2, 20, 38)

insert into producto values(6, 'Choclo', 2, 20, 46)

select * from producto

---------------------------------------------------------------------------------------------------------------------------

insert into medio_de_pago values(10, 'Efectivo', 1, 1, 'Compra')

insert into medio_de_pago values(11, 'Tarjeta de credito', 2, 2, 'Compra con tarjeta')

insert into medio_de_pago values(12, 'Cuenta corriente', 3, 3, 'Compra con cuenta')

insert into medio_de_pago values(13, 'Tarjeta de debito', 4, 4, 'Compra con tarjeta de debito')

select * from medio_de_pago
----------------------------------------------------------------------------------------------------------------------------

create or replace function fecha_al_azar() returns date as $$
begin
	return (select date(now() - trunc(random() * 2000) * '1 day'::interval));
end
$$ language plpgsql;


---------------------------------------------------------------------------------------------------------------------------------

create or replace function carga_de_ventas() returns void as
$body$
declare
	i integer;
	j integer;
	producto_en_detalle integer;
	
begin

	for i in 24..25 loop

		insert into venta values((select fecha_al_azar()), i, (select floor(random() * (4-1+1)) + 1), ('venta: ' || i), (select floor(random() * (13-10+1)) + 10));

		for j in 1..6 loop

			producto_en_detalle := (select codigo_producto from producto 
							where producto.codigo_producto not in (select codigo_producto
								from detalle_de_venta where id_factura = i)
							order by random()
							limit 1);

			insert into detalle_de_venta values(i, 
							   (producto_en_detalle), 

							   (select nombre from producto
								where producto.codigo_producto = producto_en_detalle), 

							   (select floor(random() * (50-1+1)) + 1), 

							   (select floor(random() * (70-1+1)) + 1));

		end loop;  

	end loop;
	

	return;
end $body$
language 'plpgsql'

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

(select trunc(random() * (15-1+1)) + 1)

select fecha_al_azar()

select carga_de_ventas()

select floor(random() * (15-1+1)) + 1


producto := (select nro_producto from producto 
			where producto.nro_producto not in (select codigo_producto
				from detalle_de_venta where id_factura = i)
			order by random()
			limit 1);



(select producto.nombre, producto.codigo_producto from producto
where producto.codigo_producto in (select codigo_producto

	from detalle_de_venta where id_factura = 16)
)





			 
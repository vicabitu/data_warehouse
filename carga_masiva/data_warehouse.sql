
/*Carga masiva del data warehouse*/

/*Creacion de tablas*/

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

insert into medio_de_p'conexion_DW_comodoro'ago values(11, 'Tarjeta de credito', 2, 2, 'Compra con tarjeta');

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

select * from dblink('conexion_DW_comodoro', 'select codigo_cliente from clientes') as curso_alumno(codigo_cliente int)

create or replace function carga_tabla_de_equivalencia_clientes() returns void as
$body$
	
begin

		insert into equivalencia_clientes
			(cliente_trelew),
			(select codigo_cliente
			from dblink ('conexion_DW_comodoro', 'select codigo_cliente from clientes') as 
				cliente(codigo_cliente int)),
			(cliente_esquel)


	

	return;
end $body$
language 'plpgsql'

INSERT INTO teClientes (CSN)
	SELECT nro_cliente
	FROM dblink (myconn, ‘SELECT nro_cliente FROM Clientes’) as
                          consulta(nro_cliente integer)






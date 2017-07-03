
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

INSERT INTO equivalencia_productos

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

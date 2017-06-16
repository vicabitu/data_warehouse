
/*Sistema Facturacion I*/

/*Creacion de tablas*/

create table clientes(

	nro_cliente integer not null,
	nombre varchar(30),
	tipo integer,
	direccion varchar(30),

)

alter table clientes add constraint pk_clientes primary key (nro_cliente);

------------------------------------------------------------------------------------------

create table productos (

	nro_producto integer not null,
	nombre varchar(30),
	nro_categoria integer,
	precio_actual real,

)

alter table productos add constraint pk_productos primary key (nro_producto);
alter table productos add constraint fk_categoria foreign key (nro_categoria) references categoria (nro_categoria);

--------------------------------------------------------------------------------------------

create table categoria (

	nro_categoria integer not null,
	descripcion varchar(30)

)

alter table categoria add constraint pk_categoria primary key (nro_categoria);

-------------------------------------------------------------------------------------------

create table ventas (

	fecha_venta date,
	nro_factura integer,
	nro_cliente integer,
	nombre varchar(30),
	forma_de_pago varchar(30)
)

alter table add constraint pk_ventas primary key (nro_factura);
alter table add constraint fk_nro_cliente foreign key (nro_cliente) references clientes (nro_cliente); 

------------------------------------------------------------------------------------------

create table detalle_venta (

	nro_factura integer,
	nro_producto integer,
	descripcion varchar(30),
	unidad varchar(10),
	precio real 

)


alter table add constraint pk_ventas primary key (nro_factura, nro_producto);

------------------------------------------------------------------------------------------

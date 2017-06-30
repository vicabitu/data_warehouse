
/*Sistema facturacion II*/

/*Creacion de tablas*/

create table clientes (

	codigo_cliente integer not null,
	nombre varchar(30),
	codigo_tipo integer,
	direccion varchar(30)

)

alter table clientes add constraint pk_cliente primary key (codigo_cliente);
alter table clientes add constraint fk_codigo_tipo foreign key (codigo_tipo) references tipos_cliente (codigo_tipo);  

--------------------------------------------------------------------------------------

create table tipos_cliente (

	codigo_tipo integer not null,
	descripcion varchar(30)

)

alter table tipos_cliente add constraint pk_tipos_cliente primary key (codigo_tipo)

-----------------------------------------------------------------------------------------

create table producto (

	codigo_producto integer not null,
	nombre varchar(30),
	codigo_categoria integer,
	codigo_subcategoria integer,
	precio_actual real

)

alter table producto add constraint pk_producto primary key (codigo_producto);
alter table producto add constraint fk_codigo_categoria foreign key (codigo_categoria) references categoria (codigo_categoria);

--------------------------------------------------------------------------------------------

create table categoria (

	codigo_categoria integer,
	codigo_subcategoria integer,
	descripcion varchar(30)

)

alter table categoria add constraint pk_categoria primary key (codigo_categoria);

-------------------------------------------------------------------------------------------------

create table venta (

	fecha_venta date,
	id_factura integer,
	codigo_cliente integer,
	nombre varchar(30),
	codigo_medio_de_pago integer

)

alter table venta add constraint pk_venta primary key (id_factura);
alter table venta add constraint fk_codigo_cliente foreign key (codigo_cliente) references clientes (codigo_cliente);
alter table venta add constraint fk_medio_de_pago foreign key (codigo_medio_de_pago) references medio_de_pago (codigo_medio_de_pago); 

-------------------------------------------------------------------------------------------------

create table detalle_de_venta (

	id_factura integer,
	codigo_producto integer,
	descripcion varchar(50),
	unidad varchar(10),
	precio real

)

alter table detalle_de_venta add constraint pk_detalle_de_venta primary key (id_factura, codigo_producto);
alter table detalle_de_venta add constraint fk_producto foreign key (codigo_producto) references producto (codigo_producto);
alter table detalle_de_venta add constraint fk_venta foreign key (id_factura) references venta (id_factura);

-------------------------------------------------------------------------------------------------

create table medio_de_pago (

	codigo_medio_de_pago integer,
	descripcion varchar(50),
	valor integer,
	unidad integer,
	tipo_operacion varchar(30)

)

alter table medio_de_pago add constraint pk_medio_de_pago primary key (codigo_medio_de_pago);

--------------------------------------------------------------------------------------------------

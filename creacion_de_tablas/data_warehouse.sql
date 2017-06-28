/*Data Warehouse*/

/*Creacion de tablas*/

create table clientes(

	id_cliente integer,
	nombre varchar(30),
	apellido varchar(30),
	id_tipo_cliente integer,
	direccion varchar (30)

)

alter table clientes add constraint pk_clientes primary key (id_cliente);
alter table clientes add constraint fk_clientes foreign key (id_tipo_cliente) references tipo_cliente (id_tipo_cliente)

-----------------------------------------------------------------------------------------------------------------------------

create table tipo_cliente(

	id_tipo_cliente integer,
	descripcion varchar(50),

)

alter table tipo_cliente add constraint pk_tipo_cliente primary key (id_tipo_cliente)

---------------------------------------------------------------------------------------------------------------------------------

create table producto(

	id_producto integer,
	nombre varchar(30),
	id_categoria integer

)

alter table producto add constraint pk_producto primary key (id_producto)
alter table producto add constraint fk_id_cateoria foreign key (id_categoria) references categoria (id_categoria)

---------------------------------------------------------------------------------------------------------------------------------

create table categoria(

	id_categoria integer,
	id_subcategoria integer,
	descripcion varchar(50)

)

alter table categoria add constraint pk_categoria primary key (id_categoria)

---------------------------------------------------------------------------------------------------------------------------------

/*Tabla de hechos*/

create table venta(

	fecha_venta date,
	id_factura integer,
	id_cliente integer,
	id_medio_de_pago integer,
	id_sucursal integer,
	nombre

)

---------------------------------------------------------------------------------------------------------------------------------

create table detalle_de_venta(

	id_factura integer,
	id_producto integer,
	descripcion varchar(50),
	unidad integer,
	precio real

)

---------------------------------------------------------------------------------------------------------------------------------

create table medio_de_pago(

	id_medio_de_pago integer,
	descripcion varchar(50),
	valor integer,
	unidad integer,
	tipo_de_operacion

)


---------------------------------------------------------------------------------------------------------------------------------

create table region(

	id_region integer,
	descripcion varchar(50)

)

alter table region add constraint pk_region primary key (id_region)

---------------------------------------------------------------------------------------------------------------------------------

create table provincia(

	id_provincia integer,
	id_region integer,
	descripcion varchar(50)

)


alter table provincia add constraint pk_provincia primary key (id_provincia)
alter table provincia add constraint fk_id_region foreign key (id_region) references region (id_region)

---------------------------------------------------------------------------------------------------------------------------------

create table ciudad(

	id_ciudad integer,
	id_provincia integer,
	descripcion varchar(50)

) 

alter table ciudad add constraint pk_ciudad primary key (id_ciudad)
alter table ciudad add constraint fk_id_provicnia foreign key (id_provincia) references provincia (id_provincia)


---------------------------------------------------------------------------------------------------------------------------------

create table sucursal(

	id_sucursal integer,
	id_ciudad integer,
	direccion varchar(50)

)

alter table sucursal add constraint pk_sucursal primary key (id_sucursal)
alter table sucursal add constraint fk_id_ciudad foreign key (id_ciudad) references ciudad (id_ciudad)

---------------------------------------------------------------------------------------------------------------------------------
/*Data Warehouse*/


/*Creacion de tablas*/


/*Tabla de hechos*/

create table venta(

	id_tiempo integer,
	fecha_venta date,
	id_cliente integer,
	id_medio_de_pago integer,
	id_sucursal integer,
	id_producto integer,
	monto_vendido real,
	cantidad_vendida integer

)

alter table venta add constraint fk_tiempo foreign key (id_tiempo) references tiempo (id_tiempo);
alter table venta add constraint fk_cliente foreign key (id_cliente) references clientes (id_cliente);
alter table venta add constraint fk_medio_de_pago foreign key (id_medio_de_pago) references medio_de_pago (id_medio_de_pago);
alter table venta add constraint fk_sucursal foreign key (id_sucursal) references sucursal (id_sucursal);
alter table venta add constraint fk_producto foreign key (id_producto) references producto (id_producto);


---------------------------------------------------------------------------------------------------------------------------------

create table clientes(

	id_cliente integer,
	nombre varchar(30),
	id_tipo_cliente integer,
	direccion varchar (30)

)

alter table clientes add constraint pk_clientes primary key (id_cliente);
alter table clientes add constraint fk_clientes foreign key (id_tipo_cliente) references tipo_cliente (id_tipo_cliente)

-----------------------------------------------------------------------------------------------------------------------------

create table tipo_cliente(

	id_tipo_cliente integer,
	descripcion varchar(50)

)

alter table tipo_cliente add constraint pk_tipo_cliente primary key (id_tipo_cliente)

---------------------------------------------------------------------------------------------------------------------------------

create table producto(

	id_producto integer,
	nombre varchar(30),
	id_categoria integer,
	id_subcategoria integer

)

alter table producto add constraint pk_producto primary key (id_producto)
alter table producto add constraint fk_id_cateoria foreign key (id_categoria, id_subcategoria) references categoria (id_categoria, id_subcategoria)

---------------------------------------------------------------------------------------------------------------------------------

create table categoria(

	id_categoria integer,
	id_subcategoria integer,
	descripcion varchar(50)

)

alter table categoria add constraint pk_categoria primary key (id_categoria, id_subcategoria)

---------------------------------------------------------------------------------------------------------------------------------

--La tabla subcategoria ya no va mas

/*create table subcategoria(

	id_subcategoria integer,
	descripcion varchar(50)
)

alter table add constraint pk_subcategoria primary key (id_subcategoria)*/
---------------------------------------------------------------------------------------------------------------------------------


create table tiempo(

	id_tiempo serial,
	mes integer,
	anio integer,
	trimestre integer

)

alter table tiempo add constraint pk_tiempo primary key (id_tiempo)
---------------------------------------------------------------------------------------------------------------------------------

create table medio_de_pago(

	id_medio_de_pago integer,
	descripcion varchar(50),
	valor integer,
	unidad integer,
	tipo_de_operacion varchar(50)

)

alter table medio_de_pago add constraint pk_medio_de_pago primary key (id_medio_de_pago)

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
---------------------------------------------------------------------------------------------------------------------------------

create table equivalencia_clientes(

	cliente_trelew integer,
	cliente_comodoro integer,
	cliente_esquel integer,
	cliente_unificado serial

)

alter table equivalencia_clientes add constraint pk_equivalencia_clientes primary key (cliente_unificado)

---------------------------------------------------------------------------------------------------------------------------------

create table equivalencia_productos(

	producto_trelew integer,
	producto_comodoro integer,
	producto_esquel integer,
	producto_unificado serial

)

alter table equivalencia_productos add constraint pk_equivalencia_productos primary key (producto_unificado)

---------------------------------------------------------------------------------------------------------------------------------

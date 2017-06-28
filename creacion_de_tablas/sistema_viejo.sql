
/*Sistema Facturacion I*/

/*Creacion de tablas*/

CREATE TABLE clientes(

nro_cliente integer not null,
nombre varchar(30),
tipo integer,
direccion varchar(30)

);

ALTER TABLE clientes add constraint pk_clientes primary key (nro_cliente);

------------------------------------------------------------------------------------------
CREATE TABLE categoria (

nro_categ integer not null,
descripcion varchar(30)

);

ALTER TABLE categoria add constraint pk_categoria primary key (nro_categ);

-------------------------------------------------------------------------------------------


CREATE TABLE productos (

nro_producto integer not null,
nombre varchar(30),
nro_categoria integer,
precio_actual real

);

ALTER TABLE productos add constraint pk_productos primary key (nro_producto);
ALTER TABLE productos add constraint fk_categoria foreign key (nro_categoria) references categoria (nro_categ);

--------------------------------------------------------------------------------------------

CREATE TABLE venta (

fecha_vta date,
nro_factura integer,
nro_cliente integer,
nombre varchar(30),
forma_pago varchar(30)
);

ALTER TABLE venta add constraint pk_venta primary key (nro_factura);
ALTER TABLE venta add constraint fk_nro_cliente foreign key (nro_cliente) references clientes (nro_cliente);

------------------------------------------------------------------------------------------

CREATE TABLE detalle_venta (

nro_factura integer,
nro_producto integer,
descripcion varchar(30),
unidad integer,
precio real

);

ALTER TABLE detalle_venta add constraint pk_detalle_venta primary key (nro_factura, nro_producto);
ALTER TABLE detalle_venta add constraint fk_nro_factura foreign key (nro_factura) references venta (nro_factura);

------------------------------------------------------------------------------------------

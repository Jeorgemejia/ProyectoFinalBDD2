create database db_SistemaBancario
go
use db_SistemaBancario



create table tbl_Cliente (
    IdCliente int identity(1,1) primary key,
    TipoCliente varchar(20) not null,
    Nombres varchar(100) not null,
    Apellidos varchar(100) not null,
    DPI varchar(20) null,
    NIT varchar(20) null,
    FechaNacimiento date not null,
    Telefono varchar(20) not null,
    Email varchar(100) not null,
    Direccion varchar(200) not null,
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
	FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime
)

select * from tbl_Cliente;

-- validar tipo de cliente:
ALTER TABLE tbl_Cliente
ADD CONSTRAINT CHK_Cliente_Tipo
CHECK (TipoCliente IN ('INDIVIDUAL', 'EMPRESARIAL'));


create table tbl_Sucursal (
    CodigoSucursal int identity(1,1) primary key,
    Nombre varchar(100) not null,
    Direccion varchar(200) not null,
    Telefono varchar(20) not null,
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
	FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime
)


-- tabla sucursal datos unicos
ALTER TABLE tbl_Sucursal
ADD CONSTRAINT UQ_Sucursal_Nombre UNIQUE(Nombre);



create TABLE tbl_moneda (
    CodigoMoneda int identity(1,1) primary key,
    Nombre varchar(50) not null,
    Simbolo varchar(10) not null,
    TipoCambio decimal(18,4) not null,
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
    FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime
)

create table tbl_TipoCuenta (
    CodigoTipoCuenta int identity(1,1) primary key,
    Nombre varchar(50) not null,
    SaldoMinimo decimal(18,2) not null,
    TasaInteres decimal(5,2) not null,
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
    FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime
)

create table tbl_CuentaBancaria (
    CodigoCuenta int identity(1,1) primary key,
    NumeroCuenta varchar(20) not null,
    CodigoCliente int not null,
    CodigoSucursal int not null,
    CodigoTipoCuenta int not null,
    CodigoMoneda int not null,
    SaldoActual decimal(18,2) not null,
    FechaApertura date not null,
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
    FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime,
    foreign key (CodigoCliente) references tbl_Cliente(IdCliente),
    foreign key (CodigoSucursal) references tbl_Sucursal(CodigoSucursal),
    foreign key (CodigoTipoCuenta) references tbl_TipoCuenta(CodigoTipoCuenta),
    foreign key (CodigoMoneda) references tbl_moneda(CodigoMoneda)
)

-- modificar para que cutna bancaria sea única.
ALTER TABLE tbl_CuentaBancaria
ADD CONSTRAINT UQ_Cuenta_Numero UNIQUE(NumeroCuenta);


Create table tbl_TipoTarjeta (
    CodigoTipoTarjeta int identity(1,1) primary key,
    Nombre varchar(50) not null, -- Débito, Crédito
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
    FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime
)




create table tbl_Tarjeta (
    CodigoTarjeta int identity(1,1) primary key,
    NumeroTarjeta varchar(20) not null,
    CodigoCuenta int not null,
    CodigoTipoTarjeta int not null,
    LimiteCredito decimal(18,2) null,
    SaldoUtilizado decimal(18,2) null,
    FechaEmision date not null,
    FechaVencimiento date not null,
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
    FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime,
    foreign key (CodigoCuenta) references tbl_CuentaBancaria(CodigoCuenta),
    foreign key (CodigoTipoTarjeta) references tbl_TipoTarjeta(CodigoTipoTarjeta)
)
-- numero de tarjeta unico

ALTER TABLE tbl_Tarjeta
ADD CONSTRAINT UQ_Tarjeta_Numero UNIQUE(NumeroTarjeta);

create table tbl_TipoPrestamo (
    CodigoTipoPrestamo int identity(1,1) primary key,
    Nombre varchar(50) not null,
    TasaInteres decimal(5,2) not null,
    PlazoMaximoMeses int not null,
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
    FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime
)

create table tbl_Prestamo (
    CodigoPrestamo int identity(1,1) primary key,
    CodigoCliente int not null,
    CodigoSucursal int not null,
    CodigoTipoPrestamo int not null,
    CodigoMoneda int not null,
    MontoSolicitado decimal(18,2) not null,
    TasaInteres decimal(5,2) not null,
    PlazoMeses int not null,
    FechaDesembolso date not null,
    SaldoPendiente decimal(18,2) not null,
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
    FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime,
    foreign key (CodigoCliente) references tbl_Cliente(IdCliente),
    foreign key (CodigoSucursal) references tbl_Sucursal(CodigoSucursal),
    foreign key (CodigoTipoPrestamo) references tbl_TipoPrestamo(CodigoTipoPrestamo),
    foreign key (CodigoMoneda) references tbl_moneda(CodigoMoneda)
)

create table tbl_TipoTransaccion (
    CodigoTipoTransaccion int identity(1,1) primary key,
    Nombre varchar(50) not null, -- Depósito, Retiro, Transferencia, Pago de préstamo, Pago de tarjeta
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
    FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime
)

create table tbl_Transaccion (
    CodigoTransaccion int identity(1,1) primary key,
    CodigoCuentaOrigen int null,
    CodigoCuentaDestino int null,
    CodigoTipoTransaccion int not null,
    CodigoMoneda int not null,
    Monto decimal(18,2) not null,
    TipoCambioAplicado decimal(18,4) not null,
    FechaHora datetime not null,
    Descripcion varchar(200) null,
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
    FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime,
    foreign key (CodigoCuentaOrigen) references tbl_CuentaBancaria(CodigoCuenta),
    foreign key (CodigoCuentaDestino) references tbl_CuentaBancaria(CodigoCuenta),
    foreign key (CodigoTipoTransaccion) references tbl_TipoTransaccion(CodigoTipoTransaccion),
    foreign key (CodigoMoneda) references tbl_moneda(CodigoMoneda)
)

create table tbl_PagoPrestamo (
    CodigoPagoPrestamo int identity(1,1) primary key,
    CodigoPrestamo int not null,
    CodigoTransaccion int not null,
    MontoCapital decimal(18,2) not null,
    MontoInteres decimal(18,2) not null,
    FechaPago date not null,
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
    FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime,
    foreign key (CodigoPrestamo) references tbl_Prestamo(CodigoPrestamo),
    foreign key (CodigoTransaccion) references tbl_Transaccion(CodigoTransaccion)
)   

create table tbl_UsuarioSistema (
    CodigoUsuario int identity(1,1) primary key,
    CodigoSucursal int not null,
    Usuario varchar(50) not null,
    Contraseña varchar(200) not null,
    CorreoRecuperacion varchar(100) not null, -- Para recuperación de contraseña
    Rol varchar(50) not null,
    Estado bit default 1,
    UsuarioCreacion Varchar(50),
    FechaCreacion DateTime,
    UsuarioModificacion Varchar(50),
    FechaModificacion DateTime,
    UsuarioEliminacion Varchar(50),
    FechaEliminacion DateTime,
    foreign key (CodigoSucursal) references tbl_Sucursal(CodigoSucursal)
)

--Usuarios únicos
ALTER TABLE tbl_UsuarioSistema
ADD CONSTRAINT UQ_Usuario UNIQUE(Usuario);

create table tbl_Auditoria (
    CodigoAuditoria int identity(1,1) primary key,
    TablaAfectada varchar(50) not null,
    Accion varchar(20) not null, -- Insert, Update, Delete
    RegistroId int not null,
    Usuario varchar(50) not null,
    FechaHora datetime not null,
    ValoresAnteriores varchar(max) null,
    ValoresNuevos varchar(max) null
)

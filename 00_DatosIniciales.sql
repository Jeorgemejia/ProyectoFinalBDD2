-- =============================================
-- DATOS INICIALES — Ejecutar DESPUÉS del schema
-- =============================================
USE db_SistemaBancario;
GO

-- Monedas
INSERT INTO tbl_moneda (Nombre, Simbolo, TipoCambio, Estado, UsuarioCreacion, FechaCreacion) VALUES
('Quetzal Guatemalteco', 'Q',   1.0000, 1, 'SISTEMA', GETDATE()),
('Dólar Estadounidense', 'USD', 7.7800, 1, 'SISTEMA', GETDATE()),
('Euro',                 '€',   8.4200, 1, 'SISTEMA', GETDATE());

-- Tipos de cuenta
INSERT INTO tbl_TipoCuenta (Nombre, SaldoMinimo, TasaInteres, Estado, UsuarioCreacion, FechaCreacion) VALUES
('Monetaria',          0.00,  0.00, 1, 'SISTEMA', GETDATE()),
('Ahorro',           100.00,  3.50, 1, 'SISTEMA', GETDATE()),
('Ahorro Plus',      500.00,  5.00, 1, 'SISTEMA', GETDATE()),
('Depósito a Plazo', 1000.00, 7.00, 1, 'SISTEMA', GETDATE());

-- Tipos de tarjeta
INSERT INTO tbl_TipoTarjeta (Nombre, Estado, UsuarioCreacion, FechaCreacion) VALUES
('Débito',   1, 'SISTEMA', GETDATE()),
('Crédito',  1, 'SISTEMA', GETDATE()),
('Prepago',  1, 'SISTEMA', GETDATE());

-- Tipos de préstamo
INSERT INTO tbl_TipoPrestamo (Nombre, TasaInteres, PlazoMaximoMeses, Estado, UsuarioCreacion, FechaCreacion) VALUES
('Personal',        18.00, 36,  1, 'SISTEMA', GETDATE()),
('Hipotecario',      9.00, 240, 1, 'SISTEMA', GETDATE()),
('Vehicular',       12.00, 72,  1, 'SISTEMA', GETDATE()),
('Empresarial',     15.00, 120, 1, 'SISTEMA', GETDATE()),
('Estudiantil',      6.00, 60,  1, 'SISTEMA', GETDATE());

-- Tipos de transacción
INSERT INTO tbl_TipoTransaccion (Nombre, Estado, UsuarioCreacion, FechaCreacion) VALUES
('Depósito',          1, 'SISTEMA', GETDATE()),
('Retiro',            1, 'SISTEMA', GETDATE()),
('Transferencia',     1, 'SISTEMA', GETDATE()),
('Pago de Préstamo',  1, 'SISTEMA', GETDATE()),
('Pago de Tarjeta',   1, 'SISTEMA', GETDATE());

-- Sucursal principal
INSERT INTO tbl_Sucursal (Nombre, Direccion, Telefono, Estado, UsuarioCreacion, FechaCreacion) VALUES
('Central',         'Av. Reforma 10-00, Zona 9, Guatemala', '2200-0000', 1, 'SISTEMA', GETDATE()),
('Zona 10',         '5a Av. 10-55, Zona 10, Guatemala',     '2200-0100', 1, 'SISTEMA', GETDATE()),
('Quetzaltenango',  '4a Calle 12-70, Zona 1, Xela',         '7700-0200', 1, 'SISTEMA', GETDATE());

-- Usuario administrador (contraseña: Admin2024)
-- ⚠️  En producción usar BCrypt hash
INSERT INTO tbl_UsuarioSistema
  (CodigoSucursal, Usuario, Contraseña, CorreoRecuperacion, Rol, Estado, UsuarioCreacion, FechaCreacion)
VALUES
  (1, 'admin',  'Admin2024',  'admin@banca.com',   'ADMIN',  1, 'SISTEMA', GETDATE()),
  (1, 'cajero1','Cajero2024', 'cajero1@banca.com', 'CAJERO', 1, 'SISTEMA', GETDATE());

-- Cliente de prueba
INSERT INTO tbl_Cliente
  (TipoCliente,Nombres,Apellidos,DPI,FechaNacimiento,Telefono,Email,Direccion,Estado,UsuarioCreacion,FechaCreacion)
VALUES
  ('INDIVIDUAL','Juan Carlos','Pérez López','1234567890101','1985-06-15','5555-0001','jcperez@email.com','Zona 7, Guatemala',1,'admin',GETDATE()),
  ('INDIVIDUAL','María Elena','García Ruiz', '2345678901202','1992-03-22','5555-0002','megarcia@email.com','Zona 5, Guatemala',1,'admin',GETDATE()),
  ('EMPRESARIAL','Tech Solutions','S.A.',   NULL,'2010-01-01','2222-0001','info@techsol.com','Zona 10, Guatemala',1,'admin',GETDATE());

-- NIT para empresarial
UPDATE tbl_Cliente SET NIT='123456-7' WHERE Nombres='Tech Solutions';

-- Cuenta de prueba
INSERT INTO tbl_CuentaBancaria
  (NumeroCuenta,CodigoCliente,CodigoSucursal,CodigoTipoCuenta,CodigoMoneda,SaldoActual,FechaApertura,Estado,UsuarioCreacion,FechaCreacion)
VALUES
  ('001-01-00000001',1,1,2,1,5000.00,'2024-01-10',1,'admin',GETDATE()),
  ('001-01-00000002',2,1,1,1,1200.00,'2024-02-15',1,'admin',GETDATE()),
  ('001-02-00000001',3,1,4,2,25000.00,'2023-11-01',1,'admin',GETDATE());
GO

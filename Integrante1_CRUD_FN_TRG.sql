-- =========================================== --
-- =========================================== --
--      Script Base Datos SQL SERVER           --
--      INTEGRANTE 1                           --
--      Tablas: tbl_Cliente,                   --
--              tbl_CuentaBancaria,            --
--              tbl_TipoCuenta,                --
--              tbl_Transaccion,               --
--              tbl_TipoTransaccion,           --
--              tbl_Auditoria                  --
-- =========================================== --
-- =========================================== --

USE db_SistemaBancario;
GO

-- =============================================
-- =============================================
--          DATOS DE PRUEBA (10 por tabla)     --
-- =============================================
-- =============================================

-- TipoTransaccion
INSERT INTO tbl_TipoTransaccion (Nombre, Estado, UsuarioCreacion, FechaCreacion) VALUES
('Depósito',            1, 'admin', GETDATE()),
('Retiro',              1, 'admin', GETDATE()),
('Transferencia',       1, 'admin', GETDATE()),
('Pago de Préstamo',    1, 'admin', GETDATE()),
('Pago de Tarjeta',     1, 'admin', GETDATE()),
('Apertura de Cuenta',  1, 'admin', GETDATE()),
('Cierre de Cuenta',    1, 'admin', GETDATE()),
('Cargo por Comisión',  1, 'admin', GETDATE()),
('Abono de Intereses',  1, 'admin', GETDATE()),
('Conversión Moneda',   1, 'admin', GETDATE());
GO

-- TipoCuenta
INSERT INTO tbl_TipoCuenta (Nombre, SaldoMinimo, TasaInteres, Estado, UsuarioCreacion, FechaCreacion) VALUES
('Monetaria',            0.00,  0.00, 1, 'admin', GETDATE()),
('Ahorro',             100.00,  3.50, 1, 'admin', GETDATE()),
('Ahorro Plus',        500.00,  5.00, 1, 'admin', GETDATE()),
('Depósito a Plazo',  1000.00,  7.00, 1, 'admin', GETDATE()),
('Cuenta Empresarial', 500.00,  2.00, 1, 'admin', GETDATE()),
('Cuenta Joven',         0.00,  1.50, 1, 'admin', GETDATE()),
('Cuenta Senior',      200.00,  4.00, 1, 'admin', GETDATE()),
('Cuenta VIP',        5000.00,  6.50, 1, 'admin', GETDATE()),
('Cuenta Nómina',        0.00,  1.00, 1, 'admin', GETDATE()),
('Cuenta Inversión',  2000.00,  8.00, 1, 'admin', GETDATE());
GO

-- Clientes
INSERT INTO tbl_Cliente (TipoCliente, Nombres, Apellidos, DPI, NIT, FechaNacimiento, Telefono, Email, Direccion, Estado, UsuarioCreacion, FechaCreacion) VALUES
('INDIVIDUAL',   'Juan Carlos',   'Pérez López',      '1234567890101', NULL,        '1985-06-15', '5555-0001', 'jcperez@email.com',    'Zona 7, Guatemala',       1, 'admin', GETDATE()),
('INDIVIDUAL',   'María Elena',   'García Ruiz',       '2345678901202', NULL,        '1992-03-22', '5555-0002', 'megarcia@email.com',   'Zona 5, Guatemala',       1, 'admin', GETDATE()),
('EMPRESARIAL',  'Tech Solutions', 'S.A.',              NULL,           '123456-7',  '2010-01-01', '2222-0001', 'info@techsol.com',     'Zona 10, Guatemala',      1, 'admin', GETDATE()),
('INDIVIDUAL',   'Carlos Alberto', 'Méndez Torres',    '3456789012303', NULL,        '1978-11-08', '5555-0003', 'camendez@email.com',   'Zona 1, Guatemala',       1, 'admin', GETDATE()),
('INDIVIDUAL',   'Ana Lucía',     'Rodríguez Gómez',  '4567890123404', NULL,        '1990-07-30', '5555-0004', 'alrodriguez@email.com','Mixco, Guatemala',        1, 'admin', GETDATE()),
('EMPRESARIAL',  'Importadora GT', 'S.A.',              NULL,           '234567-8',  '2005-03-15', '2222-0002', 'info@impgt.com',       'Villa Nueva, Guatemala',  1, 'admin', GETDATE()),
('INDIVIDUAL',   'Pedro Antonio', 'López Morales',    '5678901234505', NULL,        '1995-04-12', '5555-0005', 'palopez@email.com',    'Antigua Guatemala',       1, 'admin', GETDATE()),
('INDIVIDUAL',   'Sofía Beatriz', 'Hernández Cruz',   '6789012345606', NULL,        '1988-09-05', '5555-0006', 'sbhernandez@email.com','Quetzaltenango',          1, 'admin', GETDATE()),
('EMPRESARIAL',  'Constructora',  'Chapina S.A.',      NULL,           '345678-9',  '2000-06-20', '2222-0003', 'info@constchap.com',   'Escuintla, Guatemala',    1, 'admin', GETDATE()),
('INDIVIDUAL',   'Roberto José',  'Castillo Vega',    '7890123456707', NULL,        '1982-12-18', '5555-0007', 'rjcastillo@email.com', 'Zona 15, Guatemala',      1, 'admin', GETDATE());
GO
select * from tbl_Cliente
-- CuentaBancaria
INSERT INTO tbl_CuentaBancaria (NumeroCuenta, CodigoCliente, CodigoSucursal, CodigoTipoCuenta, CodigoMoneda, SaldoActual, FechaApertura, Estado, UsuarioCreacion, FechaCreacion) VALUES
('001-01-00000010', 1,  1, 2, 1,  5000.00, '2024-01-10', 1, 'admin', GETDATE()),
('001-01-00000012', 2,  1, 1, 1,  1200.00, '2024-02-15', 1, 'admin', GETDATE()),
('001-02-00000011', 3,  1, 4, 2, 25000.00, '2023-11-01', 1, 'admin', GETDATE()),
('002-01-00000001', 4,  2, 2, 1,  3500.00, '2024-03-20', 1, 'admin', GETDATE()),
('002-01-00000002', 5,  2, 1, 1,   800.00, '2024-04-05', 1, 'admin', GETDATE()),
('003-01-00000001', 6,  3, 5, 1, 15000.00, '2023-08-12', 1, 'admin', GETDATE()),
('001-01-00000003', 7,  1, 2, 2,  2200.00, '2024-01-25', 1, 'admin', GETDATE()),
('002-02-00000001', 8,  2, 3, 1,  7500.00, '2023-12-10', 1, 'admin', GETDATE()),
('003-02-00000001', 9,  3, 5, 2, 50000.00, '2023-06-30', 1, 'admin', GETDATE()),
('001-02-00000002', 10, 1, 4, 1, 10000.00, '2024-05-01', 1, 'admin', GETDATE());
GO
select * from tbl_CuentaBancaria

-- Transacciones
INSERT INTO tbl_Transaccion (CodigoCuentaOrigen, CodigoCuentaDestino, CodigoTipoTransaccion, CodigoMoneda, Monto, TipoCambioAplicado, FechaHora, Descripcion, Estado, UsuarioCreacion, FechaCreacion) VALUES
(1,  NULL, 1, 1,  1000.00, 1.0000, GETDATE(), 'Depósito en efectivo',         1, 'cajero1', GETDATE()),
(2,  NULL, 2, 1,   500.00, 1.0000, GETDATE(), 'Retiro ventanilla',             1, 'cajero1', GETDATE()),
(10,  2,    3, 1,   250.00, 1.0000, GETDATE(), 'Transferencia entre cuentas',   1, 'cajero1', GETDATE()),
(3,  NULL, 1, 2,  5000.00, 7.7800, GETDATE(), 'Depósito USD',                  1, 'cajero1', GETDATE()),
(4,  NULL, 2, 1,  1000.00, 1.0000, GETDATE(), 'Retiro ATM',                    1, 'cajero1', GETDATE()),
(5,  4,    3, 1,   300.00, 1.0000, GETDATE(), 'Pago de servicios',             1, 'cajero1', GETDATE()),
(6,  NULL, 4, 1,  2500.00, 1.0000, GETDATE(), 'Pago cuota préstamo',           1, 'cajero1', GETDATE()),
(7,  NULL, 1, 2,   500.00, 7.7800, GETDATE(), 'Depósito USD remesa',           1, 'cajero1', GETDATE()),
(8,  NULL, 5, 1,  1500.00, 1.0000, GETDATE(), 'Pago tarjeta crédito',          1, 'cajero1', GETDATE()),
(9,  NULL, 2, 2, 10000.00, 7.7800, GETDATE(), 'Retiro empresarial USD',        1, 'cajero1', GETDATE());
GO

select * from tbl_CuentaBancaria

-- Auditoria
INSERT INTO tbl_Auditoria (TablaAfectada, Accion, RegistroId, Usuario, FechaHora, ValoresAnteriores, ValoresNuevos) VALUES
('tbl_Cliente',        'Insert', 1,  'admin',   GETDATE(), NULL,                                    'Nuevo cliente: Juan Carlos Pérez'),
('tbl_Cliente',        'Update', 2,  'admin',   GETDATE(), 'Email: old@email.com',                  'Email: megarcia@email.com'),
('tbl_CuentaBancaria', 'Insert', 1,  'cajero1', GETDATE(), NULL,                                    'Nueva cuenta: 001-01-00000001'),
('tbl_CuentaBancaria', 'Update', 2,  'cajero1', GETDATE(), 'Saldo: 1000.00',                        'Saldo: 1200.00'),
('tbl_Transaccion',    'Insert', 1,  'cajero1', GETDATE(), NULL,                                    'Depósito Q1000.00'),
('tbl_Cliente',        'Delete', 5,  'admin',   GETDATE(), 'Estado: 1',                             'Estado: 0'),
('tbl_TipoCuenta',     'Insert', 5,  'admin',   GETDATE(), NULL,                                    'Nueva tipo: Cuenta Empresarial'),
('tbl_Transaccion',    'Insert', 3,  'cajero1', GETDATE(), NULL,                                    'Transferencia Q250.00'),
('tbl_CuentaBancaria', 'Delete', 5,  'admin',   GETDATE(), 'Estado: 1',                             'Estado: 0'),
('tbl_TipoTransaccion','Insert', 10, 'admin',   GETDATE(), NULL,                                    'Nuevo tipo: Conversión Moneda');
GO


-- =============================================
-- =============================================
--    STORED PROCEDURES CRUD - tbl_Cliente     --
-- =============================================
-- =============================================

	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para consultar datos de la tabla tbl_Cliente
	-- =============================================

		CREATE PROCEDURE usp_ConsultarClientes
		AS
		BEGIN
			BEGIN TRY
				SELECT *
				FROM tbl_Cliente
				WHERE Estado = 1
				ORDER BY IdCliente ASC;
			END TRY

			BEGIN CATCH
				THROW;
			END CATCH
		END
		GO

		-- Ejecutar Stored Procedure
		EXEC usp_ConsultarClientes;

		-- Consultar Tabla
		SELECT * FROM tbl_Cliente ORDER BY IdCliente ASC;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para agregar datos de la tabla tbl_Cliente
	-- =============================================

		CREATE PROCEDURE usp_AgregarCliente
		(
			@TipoCliente    VARCHAR(20),
			@Nombres        VARCHAR(100),
			@Apellidos      VARCHAR(100),
			@DPI            VARCHAR(20)  = NULL,
			@NIT            VARCHAR(20)  = NULL,
			@FechaNacimiento DATE,
			@Telefono       VARCHAR(20),
			@Email          VARCHAR(100),
			@Direccion      VARCHAR(200),
			@UsuarioCreacion VARCHAR(50),
			@Resultado      BIT OUTPUT,
			@Mensaje        NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				-- Validar tipo de cliente
				IF @TipoCliente NOT IN ('INDIVIDUAL', 'EMPRESARIAL')
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Tipo de cliente inválido. Use INDIVIDUAL o EMPRESARIAL.';
					RETURN;
				END

				-- Validar DPI duplicado
				IF EXISTS (SELECT 1 FROM tbl_Cliente WHERE DPI = @DPI AND @DPI IS NOT NULL)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Ya existe un cliente registrado con ese DPI.';
					RETURN;
				END

				-- Validar Email duplicado
				IF EXISTS (SELECT 1 FROM tbl_Cliente WHERE Email = @Email)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Ya existe un cliente registrado con ese correo electrónico.';
					RETURN;
				END

				INSERT INTO tbl_Cliente
				(
					TipoCliente, Nombres, Apellidos, DPI, NIT,
					FechaNacimiento, Telefono, Email, Direccion,
					Estado, UsuarioCreacion, FechaCreacion
				)
				VALUES
				(
					@TipoCliente, @Nombres, @Apellidos, @DPI, @NIT,
					@FechaNacimiento, @Telefono, @Email, @Direccion,
					1, @UsuarioCreacion, GETDATE()
				);

				SET @Resultado = 1;
				SET @Mensaje = 'Cliente agregado correctamente.';

			END TRY
			BEGIN CATCH
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		-- Ejecutar Stored Procedure
		DECLARE @Resultado BIT;
		DECLARE @Mensaje   NVARCHAR(500);

		EXEC usp_AgregarCliente
			'INDIVIDUAL', 'Luis Fernando', 'Ajú Morales', '8901234567808', NULL,
			'1993-02-14', '5555-0008', 'lfaju@email.com', 'Zona 3, Guatemala', 'admin',
			@Resultado = @Resultado OUTPUT,
			@Mensaje   = @Mensaje   OUTPUT;

		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;

		-- Consultar tabla
		SELECT * FROM tbl_Cliente ORDER BY IdCliente ASC;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para editar datos de la tabla tbl_Cliente
	-- =============================================

		CREATE PROCEDURE usp_EditarCliente
		(
			@IdCliente      INT,
			@TipoCliente    VARCHAR(20),
			@Nombres        VARCHAR(100),
			@Apellidos      VARCHAR(100),
			@DPI            VARCHAR(20)  = NULL,
			@NIT            VARCHAR(20)  = NULL,
			@FechaNacimiento DATE,
			@Telefono       VARCHAR(20),
			@Email          VARCHAR(100),
			@Direccion      VARCHAR(200),
			@UsuarioModificacion VARCHAR(50),
			@Resultado      BIT OUTPUT,
			@Mensaje        NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				-- Validar que existe
				IF NOT EXISTS (SELECT 1 FROM tbl_Cliente WHERE IdCliente = @IdCliente AND Estado = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'No se encontró el cliente o está inactivo.';
					RETURN;
				END

				-- Validar Email duplicado en otro registro
				IF EXISTS (SELECT 1 FROM tbl_Cliente WHERE Email = @Email AND IdCliente <> @IdCliente)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'El correo electrónico ya está en uso por otro cliente.';
					RETURN;
				END

				UPDATE tbl_Cliente
				SET
					TipoCliente          = @TipoCliente,
					Nombres              = @Nombres,
					Apellidos            = @Apellidos,
					DPI                  = @DPI,
					NIT                  = @NIT,
					FechaNacimiento      = @FechaNacimiento,
					Telefono             = @Telefono,
					Email                = @Email,
					Direccion            = @Direccion,
					UsuarioModificacion  = @UsuarioModificacion,
					FechaModificacion    = GETDATE()
				WHERE IdCliente = @IdCliente;

				IF @@ROWCOUNT = 0
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'No se pudo actualizar el cliente.';
				END
				ELSE
				BEGIN
					SET @Resultado = 1;
					SET @Mensaje = 'Cliente actualizado correctamente.';
				END

			END TRY
			BEGIN CATCH
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		-- Ejecutar Stored Procedure
		DECLARE @Resultado BIT;
		DECLARE @Mensaje   NVARCHAR(500);

		EXEC usp_EditarCliente
			1, 'INDIVIDUAL', 'Juan Carlos', 'Pérez López Actualizado', '1234567890101', NULL,
			'1985-06-15', '5555-9999', 'jcperez_nuevo@email.com', 'Zona 7, Guatemala', 'admin',
			@Resultado = @Resultado OUTPUT,
			@Mensaje   = @Mensaje   OUTPUT;

		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;

		-- Consultar tabla
		SELECT * FROM tbl_Cliente ORDER BY IdCliente ASC;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para eliminar (baja lógica) datos de tbl_Cliente
	-- =============================================

		CREATE PROCEDURE usp_EliminarCliente
		(
			@IdCliente           INT,
			@UsuarioEliminacion  VARCHAR(50),
			@Resultado           BIT OUTPUT,
			@Mensaje             NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				-- Validar que existe y está activo
				IF NOT EXISTS (SELECT 1 FROM tbl_Cliente WHERE IdCliente = @IdCliente AND Estado = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'No se encontró el cliente o ya está inactivo.';
					RETURN;
				END

				-- Validar que no tiene cuentas activas
				IF EXISTS (SELECT 1 FROM tbl_CuentaBancaria WHERE CodigoCliente = @IdCliente AND Activa = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'No se puede desactivar el cliente porque tiene cuentas bancarias activas.';
					RETURN;
				END

				UPDATE tbl_Cliente
				SET
					Estado              = 0,
					UsuarioEliminacion  = @UsuarioEliminacion,
					FechaEliminacion    = GETDATE()
				WHERE IdCliente = @IdCliente;

				IF @@ROWCOUNT = 0
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'No se pudo desactivar el cliente.';
				END
				ELSE
				BEGIN
					SET @Resultado = 1;
					SET @Mensaje = 'Cliente desactivado correctamente.';
				END

			END TRY
			BEGIN CATCH
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		-- Ejecutar Stored Procedure
		DECLARE @Resultado BIT;
		DECLARE @Mensaje   NVARCHAR(500);

		EXEC usp_EliminarCliente 10, 'admin',
			@Resultado = @Resultado OUTPUT,
			@Mensaje   = @Mensaje   OUTPUT;

		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;

		-- Consultar tabla
		SELECT * FROM tbl_Cliente ORDER BY IdCliente ASC;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para buscar clientes en tbl_Cliente
	-- =============================================

		CREATE PROCEDURE usp_BuscarCliente
		(
			@Busqueda VARCHAR(100)
		)
		AS
		BEGIN
			BEGIN TRY
				SELECT *
				FROM tbl_Cliente
				WHERE Estado = 1
				  AND (
					Nombres  LIKE '%' + @Busqueda + '%' OR
					Apellidos LIKE '%' + @Busqueda + '%' OR
					DPI      LIKE '%' + @Busqueda + '%' OR
					Email    LIKE '%' + @Busqueda + '%'
				  )
				ORDER BY IdCliente ASC;
			END TRY

			BEGIN CATCH
				THROW;
			END CATCH
		END;
		GO

		-- Ejecutar Stored Procedure
		EXEC usp_BuscarCliente @Busqueda = 'Juan';

		-- Consultar tabla
		SELECT * FROM tbl_Cliente ORDER BY IdCliente ASC;


-- =============================================
-- =============================================
--  STORED PROCEDURES CRUD - tbl_TipoCuenta   --
-- =============================================
-- =============================================

	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para consultar tbl_TipoCuenta
	-- =============================================

		CREATE PROCEDURE usp_ConsultarTipoCuenta
		AS
		BEGIN
			BEGIN TRY
				SELECT * FROM tbl_TipoCuenta
				WHERE Estado = 1
				ORDER BY CodigoTipoCuenta ASC;
			END TRY
			BEGIN CATCH
				THROW;
			END CATCH
		END;
		GO

		EXEC usp_ConsultarTipoCuenta;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para agregar datos a tbl_TipoCuenta
	-- =============================================

		CREATE PROCEDURE usp_AgregarTipoCuenta
		(
			@Nombre          VARCHAR(50),
			@SaldoMinimo     DECIMAL(18,2),
			@TasaInteres     DECIMAL(5,2),
			@UsuarioCreacion VARCHAR(50),
			@Resultado       BIT OUTPUT,
			@Mensaje         NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				IF EXISTS (SELECT 1 FROM tbl_TipoCuenta WHERE Nombre = @Nombre AND Estado = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Ya existe un tipo de cuenta con ese nombre.';
					RETURN;
				END

				IF @TasaInteres < 0 OR @SaldoMinimo < 0
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'La tasa de interés y saldo mínimo no pueden ser negativos.';
					RETURN;
				END

				INSERT INTO tbl_TipoCuenta (Nombre, SaldoMinimo, TasaInteres, Estado, UsuarioCreacion, FechaCreacion)
				VALUES (@Nombre, @SaldoMinimo, @TasaInteres, 1, @UsuarioCreacion, GETDATE());

				SET @Resultado = 1;
				SET @Mensaje = 'Tipo de cuenta agregado correctamente.';
			END TRY
			BEGIN CATCH
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		DECLARE @Resultado BIT; DECLARE @Mensaje NVARCHAR(500);
		EXEC usp_AgregarTipoCuenta 'Cuenta Estudiante', 0.00, 0.50, 'admin',
			@Resultado = @Resultado OUTPUT, @Mensaje = @Mensaje OUTPUT;
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para editar datos de tbl_TipoCuenta
	-- =============================================

		CREATE PROCEDURE usp_EditarTipoCuenta
		(
			@CodigoTipoCuenta    INT,
			@Nombre              VARCHAR(50),
			@SaldoMinimo         DECIMAL(18,2),
			@TasaInteres         DECIMAL(5,2),
			@UsuarioModificacion VARCHAR(50),
			@Resultado           BIT OUTPUT,
			@Mensaje             NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				IF NOT EXISTS (SELECT 1 FROM tbl_TipoCuenta WHERE CodigoTipoCuenta = @CodigoTipoCuenta AND Estado = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Tipo de cuenta no encontrado.';
					RETURN;
				END

				UPDATE tbl_TipoCuenta
				SET Nombre = @Nombre, SaldoMinimo = @SaldoMinimo, TasaInteres = @TasaInteres,
					UsuarioModificacion = @UsuarioModificacion, FechaModificacion = GETDATE()
				WHERE CodigoTipoCuenta = @CodigoTipoCuenta;

				SET @Resultado = 1;
				SET @Mensaje = 'Tipo de cuenta actualizado correctamente.';
			END TRY
			BEGIN CATCH
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		DECLARE @Resultado BIT; DECLARE @Mensaje NVARCHAR(500);
		EXEC usp_EditarTipoCuenta 1, 'Monetaria Plus', 50.00, 0.50, 'admin',
			@Resultado = @Resultado OUTPUT, @Mensaje = @Mensaje OUTPUT;
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para eliminar (baja lógica) tbl_TipoCuenta
	-- =============================================

		CREATE PROCEDURE usp_EliminarTipoCuenta
		(
			@CodigoTipoCuenta   INT,
			@UsuarioEliminacion VARCHAR(50),
			@Resultado          BIT OUTPUT,
			@Mensaje            NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				IF NOT EXISTS (SELECT 1 FROM tbl_TipoCuenta WHERE CodigoTipoCuenta = @CodigoTipoCuenta AND Estado = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Tipo de cuenta no encontrado.';
					RETURN;
				END

				IF EXISTS (SELECT 1 FROM tbl_CuentaBancaria WHERE CodigoTipoCuenta = @CodigoTipoCuenta AND Activa = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'No se puede eliminar porque hay cuentas bancarias activas con este tipo.';
					RETURN;
				END

				UPDATE tbl_TipoCuenta
				SET Estado = 0, UsuarioEliminacion = @UsuarioEliminacion, FechaEliminacion = GETDATE()
				WHERE CodigoTipoCuenta = @CodigoTipoCuenta;

				SET @Resultado = 1;
				SET @Mensaje = 'Tipo de cuenta eliminado correctamente.';
			END TRY
			BEGIN CATCH
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		DECLARE @Resultado BIT; DECLARE @Mensaje NVARCHAR(500);
		EXEC usp_EliminarTipoCuenta 10, 'admin',
			@Resultado = @Resultado OUTPUT, @Mensaje = @Mensaje OUTPUT;
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para buscar datos en tbl_TipoCuenta
	-- =============================================

		CREATE PROCEDURE usp_BuscarTipoCuenta
		(
			@Nombre VARCHAR(50)
		)
		AS
		BEGIN
			BEGIN TRY
				SELECT * FROM tbl_TipoCuenta
				WHERE Nombre LIKE '%' + @Nombre + '%' AND Estado = 1
				ORDER BY CodigoTipoCuenta ASC;
			END TRY
			BEGIN CATCH
				THROW;
			END CATCH
		END;
		GO

		EXEC usp_BuscarTipoCuenta @Nombre = 'Ahorro';


-- =============================================
-- =============================================
--  STORED PROCEDURES CRUD - tbl_CuentaBancaria
-- =============================================
-- =============================================

	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para consultar tbl_CuentaBancaria
	-- =============================================

		CREATE PROCEDURE usp_ConsultarCuentasBancarias
		AS
		BEGIN
			BEGIN TRY
				SELECT c.*, cl.Nombres + ' ' + cl.Apellidos AS NombreCliente,
					   s.Nombre AS NombreSucursal,
					   tc.Nombre AS TipoCuenta,
					   m.Simbolo AS Moneda
				FROM tbl_CuentaBancaria c
				INNER JOIN tbl_Cliente     cl ON c.CodigoCliente    = cl.IdCliente
				INNER JOIN tbl_Sucursal    s  ON c.CodigoSucursal   = s.CodigoSucursal
				INNER JOIN tbl_TipoCuenta  tc ON c.CodigoTipoCuenta = tc.CodigoTipoCuenta
				INNER JOIN tbl_moneda      m  ON c.CodigoMoneda     = m.CodigoMoneda
				WHERE c.Activa = 1
				ORDER BY c.CodigoCuenta ASC;
			END TRY
			BEGIN CATCH
				THROW;
			END CATCH
		END;
		GO

		EXEC usp_ConsultarCuentasBancarias;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para agregar datos a tbl_CuentaBancaria
	-- =============================================

		CREATE PROCEDURE usp_AgregarCuentaBancaria
		(
			@CodigoCliente   INT,
			@CodigoSucursal  INT,
			@CodigoTipoCuenta INT,
			@CodigoMoneda    INT,
			@SaldoInicial    DECIMAL(18,2),
			@UsuarioCreacion VARCHAR(50),
			@Resultado       BIT OUTPUT,
			@Mensaje         NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				-- Validar cliente activo
				IF NOT EXISTS (SELECT 1 FROM tbl_Cliente WHERE IdCliente = @CodigoCliente AND Estado = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'El cliente no existe o está inactivo.';
					RETURN;
				END

				-- Validar saldo mínimo
				DECLARE @SaldoMinimo DECIMAL(18,2);
				SELECT @SaldoMinimo = SaldoMinimo FROM tbl_TipoCuenta WHERE CodigoTipoCuenta = @CodigoTipoCuenta;

				IF @SaldoInicial < @SaldoMinimo
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'El saldo inicial no puede ser menor al saldo mínimo requerido: Q' + CAST(@SaldoMinimo AS VARCHAR);
					RETURN;
				END

				-- Generar número de cuenta automático
				DECLARE @Secuencia INT;
				SELECT @Secuencia = ISNULL(MAX(CodigoCuenta), 0) + 1 FROM tbl_CuentaBancaria;

				DECLARE @NumeroCuenta VARCHAR(20);
				SET @NumeroCuenta = RIGHT('000' + CAST(@CodigoSucursal AS VARCHAR), 3) + '-' +
									RIGHT('00' + CAST(@CodigoTipoCuenta AS VARCHAR), 2) + '-' +
									RIGHT('00000000' + CAST(@Secuencia AS VARCHAR), 8);

				INSERT INTO tbl_CuentaBancaria
				(NumeroCuenta, CodigoCliente, CodigoSucursal, CodigoTipoCuenta, CodigoMoneda,
				 SaldoActual, FechaApertura, Activa, UsuarioCreacion, FechaCreacion)
				VALUES
				(@NumeroCuenta, @CodigoCliente, @CodigoSucursal, @CodigoTipoCuenta, @CodigoMoneda,
				 @SaldoInicial, GETDATE(), 1, @UsuarioCreacion, GETDATE());

				SET @Resultado = 1;
				SET @Mensaje = 'Cuenta bancaria creada correctamente. Número: ' + @NumeroCuenta;

			END TRY
			BEGIN CATCH
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		DECLARE @Resultado BIT; DECLARE @Mensaje NVARCHAR(500);
		EXEC usp_AgregarCuentaBancaria 1, 1, 2, 1, 500.00, 'cajero1',
			@Resultado = @Resultado OUTPUT, @Mensaje = @Mensaje OUTPUT;
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para cerrar (baja lógica) tbl_CuentaBancaria
	-- =============================================

		CREATE PROCEDURE usp_CerrarCuentaBancaria
		(
			@CodigoCuenta       INT,
			@UsuarioEliminacion VARCHAR(50),
			@Resultado          BIT OUTPUT,
			@Mensaje            NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				IF NOT EXISTS (SELECT 1 FROM tbl_CuentaBancaria WHERE CodigoCuenta = @CodigoCuenta AND Activa = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'La cuenta no existe o ya está cerrada.';
					RETURN;
				END

				DECLARE @Saldo DECIMAL(18,2);
				SELECT @Saldo = SaldoActual FROM tbl_CuentaBancaria WHERE CodigoCuenta = @CodigoCuenta;

				IF @Saldo > 0
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'No se puede cerrar la cuenta. Saldo disponible: Q' + CAST(@Saldo AS VARCHAR) + '. Retire el saldo antes de cerrar.';
					RETURN;
				END

				UPDATE tbl_CuentaBancaria
				SET Activa = 0, UsuarioEliminacion = @UsuarioEliminacion, FechaEliminacion = GETDATE()
				WHERE CodigoCuenta = @CodigoCuenta;

				SET @Resultado = 1;
				SET @Mensaje = 'Cuenta bancaria cerrada correctamente.';
			END TRY
			BEGIN CATCH
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		DECLARE @Resultado BIT; DECLARE @Mensaje NVARCHAR(500);
		EXEC usp_CerrarCuentaBancaria 10, 'admin',
			@Resultado = @Resultado OUTPUT, @Mensaje = @Mensaje OUTPUT;
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para buscar cuentas en tbl_CuentaBancaria
	-- =============================================

		CREATE PROCEDURE usp_BuscarCuentaBancaria
		(
			@Busqueda VARCHAR(100)
		)
		AS
		BEGIN
			BEGIN TRY
				SELECT c.*, cl.Nombres + ' ' + cl.Apellidos AS NombreCliente,
					   tc.Nombre AS TipoCuenta, m.Simbolo AS Moneda
				FROM tbl_CuentaBancaria c
				INNER JOIN tbl_Cliente    cl ON c.CodigoCliente    = cl.IdCliente
				INNER JOIN tbl_TipoCuenta tc ON c.CodigoTipoCuenta = tc.CodigoTipoCuenta
				INNER JOIN tbl_moneda     m  ON c.CodigoMoneda     = m.CodigoMoneda
				WHERE c.Activa = 1
				  AND (c.NumeroCuenta LIKE '%' + @Busqueda + '%'
				    OR cl.Nombres    LIKE '%' + @Busqueda + '%'
				    OR cl.Apellidos  LIKE '%' + @Busqueda + '%')
				ORDER BY c.CodigoCuenta ASC;
			END TRY
			BEGIN CATCH
				THROW;
			END CATCH
		END;
		GO

		EXEC usp_BuscarCuentaBancaria @Busqueda = 'Juan';


-- =============================================
-- =============================================
--  STORED PROCEDURES CRUD - tbl_Transaccion  --
-- =============================================
-- =============================================

	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para consultar tbl_Transaccion
	-- =============================================

		CREATE PROCEDURE usp_ConsultarTransacciones
		AS
		BEGIN
			BEGIN TRY
				SELECT TOP 200
					t.*,
					co.NumeroCuenta  AS CuentaOrigen,
					cd.NumeroCuenta  AS CuentaDestino,
					tt.Nombre        AS TipoTransaccion,
					m.Simbolo        AS Moneda,
					cl.Nombres + ' ' + cl.Apellidos AS NombreCliente
				FROM tbl_Transaccion t
				INNER JOIN tbl_TipoTransaccion tt ON t.CodigoTipoTransaccion = tt.CodigoTipoTransaccion
				INNER JOIN tbl_moneda          m  ON t.CodigoMoneda          = m.CodigoMoneda
				LEFT  JOIN tbl_CuentaBancaria  co ON t.CodigoCuentaOrigen    = co.CodigoCuenta
				LEFT  JOIN tbl_CuentaBancaria  cd ON t.CodigoCuentaDestino   = cd.CodigoCuenta
				LEFT  JOIN tbl_Cliente         cl ON co.CodigoCliente        = cl.IdCliente
				WHERE t.Estado = 1
				ORDER BY t.FechaHora DESC;
			END TRY
			BEGIN CATCH
				THROW;
			END CATCH
		END;
		GO

		EXEC usp_ConsultarTransacciones;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp Depositar en cuenta bancaria
	-- =============================================

		CREATE PROCEDURE usp_Depositar
		(
			@CodigoCuenta    INT,
			@CodigoMoneda    INT,
			@Monto           DECIMAL(18,2),
			@Descripcion     VARCHAR(200) = NULL,
			@UsuarioCreacion VARCHAR(50),
			@Resultado       BIT OUTPUT,
			@Mensaje         NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION;

				IF NOT EXISTS (SELECT 1 FROM tbl_CuentaBancaria WHERE CodigoCuenta = @CodigoCuenta AND Activa = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Cuenta no encontrada o inactiva.';
					ROLLBACK TRANSACTION;
					RETURN;
				END

				IF @Monto <= 0
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'El monto del depósito debe ser mayor a cero.';
					ROLLBACK TRANSACTION;
					RETURN;
				END

				DECLARE @TipoCambio DECIMAL(18,4);
				SELECT @TipoCambio = TipoCambio FROM tbl_moneda WHERE CodigoMoneda = @CodigoMoneda;

				UPDATE tbl_CuentaBancaria
				SET SaldoActual = SaldoActual + @Monto,
					UsuarioModificacion = @UsuarioCreacion,
					FechaModificacion = GETDATE()
				WHERE CodigoCuenta = @CodigoCuenta;

				INSERT INTO tbl_Transaccion
				(CodigoCuentaOrigen, CodigoTipoTransaccion, CodigoMoneda, Monto,
				 TipoCambioAplicado, FechaHora, Descripcion, Estado, UsuarioCreacion, FechaCreacion)
				VALUES
				(@CodigoCuenta, 1, @CodigoMoneda, @Monto,
				 @TipoCambio, GETDATE(), ISNULL(@Descripcion, 'Depósito'), 1, @UsuarioCreacion, GETDATE());

				COMMIT TRANSACTION;
				SET @Resultado = 1;
				SET @Mensaje = 'Depósito de Q' + CAST(@Monto AS VARCHAR) + ' realizado correctamente.';

			END TRY
			BEGIN CATCH
				IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		DECLARE @Resultado BIT; DECLARE @Mensaje NVARCHAR(500);
		EXEC usp_Depositar 1, 1, 2500.00, 'Depósito prueba', 'cajero1',
			@Resultado = @Resultado OUTPUT, @Mensaje = @Mensaje OUTPUT;
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp Retirar de cuenta bancaria
	-- =============================================

		CREATE PROCEDURE usp_Retirar
		(
			@CodigoCuenta    INT,
			@CodigoMoneda    INT,
			@Monto           DECIMAL(18,2),
			@Descripcion     VARCHAR(200) = NULL,
			@UsuarioCreacion VARCHAR(50),
			@Resultado       BIT OUTPUT,
			@Mensaje         NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION;

				DECLARE @SaldoActual DECIMAL(18,2);
				SELECT @SaldoActual = SaldoActual
				FROM tbl_CuentaBancaria
				WHERE CodigoCuenta = @CodigoCuenta AND Activa = 1;

				IF @SaldoActual IS NULL
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Cuenta no encontrada o inactiva.';
					ROLLBACK TRANSACTION;
					RETURN;
				END

				IF @Monto <= 0
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'El monto del retiro debe ser mayor a cero.';
					ROLLBACK TRANSACTION;
					RETURN;
				END

				IF @SaldoActual < @Monto
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Saldo insuficiente. Saldo disponible: Q' + CAST(@SaldoActual AS VARCHAR);
					ROLLBACK TRANSACTION;
					RETURN;
				END

				DECLARE @TipoCambio DECIMAL(18,4);
				SELECT @TipoCambio = TipoCambio FROM tbl_moneda WHERE CodigoMoneda = @CodigoMoneda;

				UPDATE tbl_CuentaBancaria
				SET SaldoActual = SaldoActual - @Monto,
					UsuarioModificacion = @UsuarioCreacion,
					FechaModificacion = GETDATE()
				WHERE CodigoCuenta = @CodigoCuenta;

				INSERT INTO tbl_Transaccion
				(CodigoCuentaOrigen, CodigoTipoTransaccion, CodigoMoneda, Monto,
				 TipoCambioAplicado, FechaHora, Descripcion, Estado, UsuarioCreacion, FechaCreacion)
				VALUES
				(@CodigoCuenta, 2, @CodigoMoneda, @Monto,
				 @TipoCambio, GETDATE(), ISNULL(@Descripcion, 'Retiro'), 1, @UsuarioCreacion, GETDATE());

				COMMIT TRANSACTION;
				SET @Resultado = 1;
				SET @Mensaje = 'Retiro de Q' + CAST(@Monto AS VARCHAR) + ' realizado correctamente.';

			END TRY
			BEGIN CATCH
				IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		DECLARE @Resultado BIT; DECLARE @Mensaje NVARCHAR(500);
		EXEC usp_Retirar 1, 1, 500.00, 'Retiro prueba', 'cajero1',
			@Resultado = @Resultado OUTPUT, @Mensaje = @Mensaje OUTPUT;
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp Transferir entre cuentas
	-- =============================================

		CREATE PROCEDURE usp_Transferir
		(
			@CodigoCuentaOrigen  INT,
			@CodigoCuentaDestino INT,
			@CodigoMoneda        INT,
			@Monto               DECIMAL(18,2),
			@Descripcion         VARCHAR(200) = NULL,
			@UsuarioCreacion     VARCHAR(50),
			@Resultado           BIT OUTPUT,
			@Mensaje             NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION;

				IF @CodigoCuentaOrigen = @CodigoCuentaDestino
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'La cuenta origen y destino no pueden ser la misma.';
					ROLLBACK TRANSACTION;
					RETURN;
				END

				DECLARE @SaldoOrigen DECIMAL(18,2);
				SELECT @SaldoOrigen = SaldoActual
				FROM tbl_CuentaBancaria
				WHERE CodigoCuenta = @CodigoCuentaOrigen AND Activa = 1;

				IF @SaldoOrigen IS NULL
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Cuenta origen no encontrada o inactiva.';
					ROLLBACK TRANSACTION;
					RETURN;
				END

				IF NOT EXISTS (SELECT 1 FROM tbl_CuentaBancaria WHERE CodigoCuenta = @CodigoCuentaDestino AND Activa = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Cuenta destino no encontrada o inactiva.';
					ROLLBACK TRANSACTION;
					RETURN;
				END

				IF @Monto <= 0
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'El monto de la transferencia debe ser mayor a cero.';
					ROLLBACK TRANSACTION;
					RETURN;
				END

				IF @SaldoOrigen < @Monto
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Saldo insuficiente en cuenta origen. Disponible: Q' + CAST(@SaldoOrigen AS VARCHAR);
					ROLLBACK TRANSACTION;
					RETURN;
				END

				DECLARE @TipoCambio DECIMAL(18,4);
				SELECT @TipoCambio = TipoCambio FROM tbl_moneda WHERE CodigoMoneda = @CodigoMoneda;

				UPDATE tbl_CuentaBancaria SET SaldoActual = SaldoActual - @Monto,
					UsuarioModificacion = @UsuarioCreacion, FechaModificacion = GETDATE()
				WHERE CodigoCuenta = @CodigoCuentaOrigen;

				UPDATE tbl_CuentaBancaria SET SaldoActual = SaldoActual + @Monto,
					UsuarioModificacion = @UsuarioCreacion, FechaModificacion = GETDATE()
				WHERE CodigoCuenta = @CodigoCuentaDestino;

				INSERT INTO tbl_Transaccion
				(CodigoCuentaOrigen, CodigoCuentaDestino, CodigoTipoTransaccion, CodigoMoneda, Monto,
				 TipoCambioAplicado, FechaHora, Descripcion, Estado, UsuarioCreacion, FechaCreacion)
				VALUES
				(@CodigoCuentaOrigen, @CodigoCuentaDestino, 3, @CodigoMoneda, @Monto,
				 @TipoCambio, GETDATE(), ISNULL(@Descripcion,'Transferencia'), 1, @UsuarioCreacion, GETDATE());

				COMMIT TRANSACTION;
				SET @Resultado = 1;
				SET @Mensaje = 'Transferencia de Q' + CAST(@Monto AS VARCHAR) + ' realizada correctamente.';

			END TRY
			BEGIN CATCH
				IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		DECLARE @Resultado BIT; DECLARE @Mensaje NVARCHAR(500);
		EXEC usp_Transferir 1, 2, 1, 300.00, 'Transferencia prueba', 'cajero1',
			@Resultado = @Resultado OUTPUT, @Mensaje = @Mensaje OUTPUT;
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para buscar transacciones por cuenta
	-- =============================================

		CREATE PROCEDURE usp_BuscarTransaccionesPorCuenta
		(
			@CodigoCuenta INT
		)
		AS
		BEGIN
			BEGIN TRY
				SELECT t.*, tt.Nombre AS TipoTransaccion, m.Simbolo AS Moneda
				FROM tbl_Transaccion t
				INNER JOIN tbl_TipoTransaccion tt ON t.CodigoTipoTransaccion = tt.CodigoTipoTransaccion
				INNER JOIN tbl_moneda          m  ON t.CodigoMoneda          = m.CodigoMoneda
				WHERE (t.CodigoCuentaOrigen = @CodigoCuenta OR t.CodigoCuentaDestino = @CodigoCuenta)
				  AND t.Estado = 1
				ORDER BY t.FechaHora DESC;
			END TRY
			BEGIN CATCH
				THROW;
			END CATCH
		END;
		GO

		EXEC usp_BuscarTransaccionesPorCuenta @CodigoCuenta = 1;


-- =============================================
-- =============================================
--  STORED PROCEDURES - tbl_TipoTransaccion   --
-- =============================================
-- =============================================

	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para consultar tbl_TipoTransaccion
	-- =============================================

		CREATE PROCEDURE usp_ConsultarTipoTransaccion
		AS
		BEGIN
			BEGIN TRY
				SELECT * FROM tbl_TipoTransaccion WHERE Estado = 1 ORDER BY CodigoTipoTransaccion ASC;
			END TRY
			BEGIN CATCH
				THROW;
			END CATCH
		END;
		GO

		EXEC usp_ConsultarTipoTransaccion;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para agregar datos a tbl_TipoTransaccion
	-- =============================================

		CREATE PROCEDURE usp_AgregarTipoTransaccion
		(
			@Nombre          VARCHAR(50),
			@UsuarioCreacion VARCHAR(50),
			@Resultado       BIT OUTPUT,
			@Mensaje         NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				IF EXISTS (SELECT 1 FROM tbl_TipoTransaccion WHERE Nombre = @Nombre AND Estado = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Ya existe un tipo de transacción con ese nombre.';
					RETURN;
				END

				INSERT INTO tbl_TipoTransaccion (Nombre, Estado, UsuarioCreacion, FechaCreacion)
				VALUES (@Nombre, 1, @UsuarioCreacion, GETDATE());

				SET @Resultado = 1;
				SET @Mensaje = 'Tipo de transacción agregado correctamente.';
			END TRY
			BEGIN CATCH
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		DECLARE @Resultado BIT; DECLARE @Mensaje NVARCHAR(500);
		EXEC usp_AgregarTipoTransaccion 'Débito Automático', 'admin',
			@Resultado = @Resultado OUTPUT, @Mensaje = @Mensaje OUTPUT;
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para editar tbl_TipoTransaccion
	-- =============================================

		CREATE PROCEDURE usp_EditarTipoTransaccion
		(
			@CodigoTipoTransaccion INT,
			@Nombre                VARCHAR(50),
			@UsuarioModificacion   VARCHAR(50),
			@Resultado             BIT OUTPUT,
			@Mensaje               NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				IF NOT EXISTS (SELECT 1 FROM tbl_TipoTransaccion WHERE CodigoTipoTransaccion = @CodigoTipoTransaccion AND Estado = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Tipo de transacción no encontrado.';
					RETURN;
				END

				UPDATE tbl_TipoTransaccion
				SET Nombre = @Nombre, UsuarioModificacion = @UsuarioModificacion, FechaModificacion = GETDATE()
				WHERE CodigoTipoTransaccion = @CodigoTipoTransaccion;

				SET @Resultado = 1;
				SET @Mensaje = 'Tipo de transacción actualizado correctamente.';
			END TRY
			BEGIN CATCH
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		DECLARE @Resultado BIT; DECLARE @Mensaje NVARCHAR(500);
		EXEC usp_EditarTipoTransaccion 10, 'Conversión de Divisas', 'admin',
			@Resultado = @Resultado OUTPUT, @Mensaje = @Mensaje OUTPUT;
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: usp para eliminar (baja lógica) tbl_TipoTransaccion
	-- =============================================

		CREATE PROCEDURE usp_EliminarTipoTransaccion
		(
			@CodigoTipoTransaccion INT,
			@UsuarioEliminacion    VARCHAR(50),
			@Resultado             BIT OUTPUT,
			@Mensaje               NVARCHAR(500) OUTPUT
		)
		AS
		BEGIN
			BEGIN TRY
				IF NOT EXISTS (SELECT 1 FROM tbl_TipoTransaccion WHERE CodigoTipoTransaccion = @CodigoTipoTransaccion AND Estado = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'Tipo de transacción no encontrado.';
					RETURN;
				END

				IF EXISTS (SELECT 1 FROM tbl_Transaccion WHERE CodigoTipoTransaccion = @CodigoTipoTransaccion AND Estado = 1)
				BEGIN
					SET @Resultado = 0;
					SET @Mensaje = 'No se puede eliminar porque existen transacciones registradas con este tipo.';
					RETURN;
				END

				UPDATE tbl_TipoTransaccion
				SET Estado = 0, UsuarioEliminacion = @UsuarioEliminacion, FechaEliminacion = GETDATE()
				WHERE CodigoTipoTransaccion = @CodigoTipoTransaccion;

				SET @Resultado = 1;
				SET @Mensaje = 'Tipo de transacción eliminado correctamente.';
			END TRY
			BEGIN CATCH
				SET @Resultado = 0;
				SET @Mensaje = ERROR_MESSAGE();
			END CATCH
		END;
		GO

		DECLARE @Resultado BIT; DECLARE @Mensaje NVARCHAR(500);
		EXEC usp_EliminarTipoTransaccion 11, 'admin',
			@Resultado = @Resultado OUTPUT, @Mensaje = @Mensaje OUTPUT;
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;


-- =============================================
-- =============================================
--  STORED PROCEDURES - REPORTES (mínimo 3)   --
-- =============================================
-- =============================================

	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: Reporte 1 - Estado de cuenta por cliente
	-- =============================================

		CREATE PROCEDURE usp_ReporteEstadoCuenta
		(
			@CodigoCliente INT
		)
		AS
		BEGIN
			BEGIN TRY
				-- Datos del cliente
				SELECT
					cl.Nombres + ' ' + cl.Apellidos AS NombreCliente,
					cl.DPI, cl.Email, cl.Telefono,
					c.NumeroCuenta, tc.Nombre AS TipoCuenta,
					m.Nombre AS Moneda, m.Simbolo,
					c.SaldoActual, c.FechaApertura
				FROM tbl_CuentaBancaria c
				INNER JOIN tbl_Cliente    cl ON c.CodigoCliente    = cl.IdCliente
				INNER JOIN tbl_TipoCuenta tc ON c.CodigoTipoCuenta = tc.CodigoTipoCuenta
				INNER JOIN tbl_moneda     m  ON c.CodigoMoneda     = m.CodigoMoneda
				WHERE cl.IdCliente = @CodigoCliente AND c.Activa = 1;

				-- Últimas 20 transacciones del cliente
				SELECT TOP 20
					t.CodigoTransaccion, tt.Nombre AS Tipo,
					t.Monto, m.Simbolo, t.Descripcion, t.FechaHora
				FROM tbl_Transaccion t
				INNER JOIN tbl_TipoTransaccion tt ON t.CodigoTipoTransaccion = tt.CodigoTipoTransaccion
				INNER JOIN tbl_moneda          m  ON t.CodigoMoneda          = m.CodigoMoneda
				INNER JOIN tbl_CuentaBancaria  co ON t.CodigoCuentaOrigen    = co.CodigoCuenta
				WHERE co.CodigoCliente = @CodigoCliente AND t.Estado = 1
				ORDER BY t.FechaHora DESC;
			END TRY
			BEGIN CATCH
				THROW;
			END CATCH
		END;
		GO

		EXEC usp_ReporteEstadoCuenta @CodigoCliente = 1;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: Reporte 2 - Movimientos del día por sucursal
	-- =============================================

		CREATE PROCEDURE usp_ReporteMovimientosDiarios
		(
			@Fecha DATE = NULL
		)
		AS
		BEGIN
			BEGIN TRY
				IF @Fecha IS NULL SET @Fecha = CAST(GETDATE() AS DATE);

				SELECT
					s.Nombre AS Sucursal,
					tt.Nombre AS TipoTransaccion,
					COUNT(*)  AS CantidadOperaciones,
					SUM(t.Monto) AS MontoTotal,
					m.Simbolo AS Moneda
				FROM tbl_Transaccion t
				INNER JOIN tbl_TipoTransaccion  tt ON t.CodigoTipoTransaccion = tt.CodigoTipoTransaccion
				INNER JOIN tbl_moneda            m  ON t.CodigoMoneda          = m.CodigoMoneda
				INNER JOIN tbl_CuentaBancaria   co  ON t.CodigoCuentaOrigen    = co.CodigoCuenta
				INNER JOIN tbl_Sucursal          s  ON co.CodigoSucursal       = s.CodigoSucursal
				WHERE CAST(t.FechaHora AS DATE) = @Fecha AND t.Estado = 1
				GROUP BY s.Nombre, tt.Nombre, m.Simbolo
				ORDER BY s.Nombre, tt.Nombre;
			END TRY
			BEGIN CATCH
				THROW;
			END CATCH
		END;
		GO

		EXEC usp_ReporteMovimientosDiarios @Fecha = NULL;


	-- =============================================
	-- Author:      Integrante 1
	-- Create date: 26/05/2026
	-- Description: Reporte 3 - Saldos totales por tipo de cuenta
	-- =============================================

		CREATE PROCEDURE usp_ReporteSaldosPorTipoCuenta
		AS
		BEGIN
			BEGIN TRY
				SELECT
					tc.Nombre           AS TipoCuenta,
					COUNT(c.CodigoCuenta) AS TotalCuentas,
					SUM(c.SaldoActual)  AS SaldoTotal,
					AVG(c.SaldoActual)  AS SaldoPromedio,
					MIN(c.SaldoActual)  AS SaldoMinimo,
					MAX(c.SaldoActual)  AS SaldoMaximo,
					m.Simbolo           AS Moneda
				FROM tbl_CuentaBancaria c
				INNER JOIN tbl_TipoCuenta tc ON c.CodigoTipoCuenta = tc.CodigoTipoCuenta
				INNER JOIN tbl_moneda     m  ON c.CodigoMoneda     = m.CodigoMoneda
				WHERE c.Activa = 1
				GROUP BY tc.Nombre, m.Simbolo
				ORDER BY SaldoTotal DESC;
			END TRY
			BEGIN CATCH
				THROW;
			END CATCH
		END;
		GO

		EXEC usp_ReporteSaldosPorTipoCuenta;


-- =============================================
-- =============================================
--     FUNCIONES - INTEGRANTE 1              --
-- =============================================
-- =============================================

	/*====================================================
	=         FUNCIONES ESCALARES                        =
	====================================================*/

		-- 1. Obtener nombre completo del cliente
		CREATE FUNCTION dbo.fn_NombreCliente (@IdCliente INT)
		RETURNS VARCHAR(200)
		AS
		BEGIN
			DECLARE @Nombre VARCHAR(200);
			SELECT @Nombre = Nombres + ' ' + Apellidos
			FROM tbl_Cliente WHERE IdCliente = @IdCliente;
			RETURN @Nombre;
		END;
		GO

		-- Ejemplo de uso
		SELECT dbo.fn_NombreCliente(1);
		GO


		-- 2. Calcular saldo total de un cliente (todas sus cuentas)
		CREATE FUNCTION dbo.fn_SaldoTotalCliente (@IdCliente INT)
		RETURNS DECIMAL(18,2)
		AS
		BEGIN
			DECLARE @Total DECIMAL(18,2);
			SELECT @Total = ISNULL(SUM(SaldoActual), 0)
			FROM tbl_CuentaBancaria
			WHERE CodigoCliente = @IdCliente AND Activa = 1;
			RETURN @Total;
		END;
		GO

		-- Ejemplo de uso
		SELECT dbo.fn_SaldoTotalCliente(1);
		GO


		-- 3. Calcular cantidad de transacciones de una cuenta
		CREATE FUNCTION dbo.fn_TotalTransaccionesCuenta (@CodigoCuenta INT)
		RETURNS INT
		AS
		BEGIN
			DECLARE @Total INT;
			SELECT @Total = COUNT(*)
			FROM tbl_Transaccion
			WHERE (CodigoCuentaOrigen = @CodigoCuenta OR CodigoCuentaDestino = @CodigoCuenta)
			  AND Estado = 1;
			RETURN @Total;
		END;
		GO

		-- Ejemplo de uso
		SELECT dbo.fn_TotalTransaccionesCuenta(1);
		GO


		-- 4. Calcular interés mensual de una cuenta
		CREATE FUNCTION dbo.fn_InteresmensualCuenta (@CodigoCuenta INT)
		RETURNS DECIMAL(18,2)
		AS
		BEGIN
			DECLARE @Interes DECIMAL(18,2);
			SELECT @Interes = ROUND(c.SaldoActual * (tc.TasaInteres / 100) / 12, 2)
			FROM tbl_CuentaBancaria c
			INNER JOIN tbl_TipoCuenta tc ON c.CodigoTipoCuenta = tc.CodigoTipoCuenta
			WHERE c.CodigoCuenta = @CodigoCuenta AND c.Activa = 1;
			RETURN ISNULL(@Interes, 0);
		END;
		GO

		-- Ejemplo de uso
		SELECT dbo.fn_InteresmensuAlCuenta(1);
		GO


		-- 5. Obtener edad del cliente
		CREATE FUNCTION dbo.fn_EdadCliente (@IdCliente INT)
		RETURNS INT
		AS
		BEGIN
			DECLARE @Edad INT;
			SELECT @Edad = DATEDIFF(YEAR, FechaNacimiento, GETDATE())
			FROM tbl_Cliente WHERE IdCliente = @IdCliente;
			RETURN @Edad;
		END;
		GO

		-- Ejemplo de uso
		SELECT dbo.fn_EdadCliente(1);
		GO


	/*====================================================
	=       FUNCIONES DE TABLA EN LÍNEA                 =
	====================================================*/

		-- 1. Clientes activos
		CREATE FUNCTION dbo.fn_ClientesActivos()
		RETURNS TABLE
		AS
		RETURN (
			SELECT * FROM tbl_Cliente WHERE Estado = 1
		);
		GO

		-- Ejemplo de uso
		SELECT * FROM dbo.fn_ClientesActivos();
		GO


		-- 2. Cuentas activas por cliente
		CREATE FUNCTION dbo.fn_CuentasPorCliente (@IdCliente INT)
		RETURNS TABLE
		AS
		RETURN (
			SELECT c.*, tc.Nombre AS TipoCuenta, m.Simbolo AS Moneda
			FROM tbl_CuentaBancaria c
			INNER JOIN tbl_TipoCuenta tc ON c.CodigoTipoCuenta = tc.CodigoTipoCuenta
			INNER JOIN tbl_moneda     m  ON c.CodigoMoneda     = m.CodigoMoneda
			WHERE c.CodigoCliente = @IdCliente AND c.Activa = 1
		);
		GO

		-- Ejemplo de uso
		SELECT * FROM dbo.fn_CuentasPorCliente(1);
		GO


		-- 3. Transacciones por rango de fechas
		CREATE FUNCTION dbo.fn_TransaccionesPorFecha (@FechaInicio DATE, @FechaFin DATE)
		RETURNS TABLE
		AS
		RETURN (
			SELECT t.*, tt.Nombre AS TipoTransaccion, m.Simbolo AS Moneda
			FROM tbl_Transaccion t
			INNER JOIN tbl_TipoTransaccion tt ON t.CodigoTipoTransaccion = tt.CodigoTipoTransaccion
			INNER JOIN tbl_moneda          m  ON t.CodigoMoneda          = m.CodigoMoneda
			WHERE CAST(t.FechaHora AS DATE) BETWEEN @FechaInicio AND @FechaFin
			  AND t.Estado = 1
		);
		GO

		-- Ejemplo de uso
		SELECT * FROM dbo.fn_TransaccionesPorFecha('2024-01-01', '2026-12-31');
		GO


		-- 4. Cuentas con saldo superior a un monto
		CREATE FUNCTION dbo.fn_CuentasConSaldoMinimo (@MontoMinimo DECIMAL(18,2))
		RETURNS TABLE
		AS
		RETURN (
			SELECT c.*, cl.Nombres + ' ' + cl.Apellidos AS NombreCliente
			FROM tbl_CuentaBancaria c
			INNER JOIN tbl_Cliente cl ON c.CodigoCliente = cl.IdCliente
			WHERE c.SaldoActual >= @MontoMinimo AND c.Activa = 1
		);
		GO

		-- Ejemplo de uso
		SELECT * FROM dbo.fn_CuentasConSaldoMinimo(1000);
		GO


		-- 5. Transacciones por tipo
		CREATE FUNCTION dbo.fn_TransaccionesPorTipo (@CodigoTipo INT)
		RETURNS TABLE
		AS
		RETURN (
			SELECT * FROM tbl_Transaccion
			WHERE CodigoTipoTransaccion = @CodigoTipo AND Estado = 1
		);
		GO

		-- Ejemplo de uso
		SELECT * FROM dbo.fn_TransaccionesPorTipo(1);
		GO


	/*====================================================
	=     FUNCIONES MULTI-SENTENCIA (TVF)               =
	====================================================*/

		-- 1. Resumen financiero de un cliente
		CREATE FUNCTION dbo.fn_ResumenFinancieroCliente (@IdCliente INT)
		RETURNS @Resultado TABLE
		(
			NumeroCuenta    VARCHAR(20),
			TipoCuenta      VARCHAR(50),
			SaldoActual     DECIMAL(18,2),
			TotalDepositos  DECIMAL(18,2),
			TotalRetiros    DECIMAL(18,2),
			InteressMensual DECIMAL(18,2)
		)
		AS
		BEGIN
			INSERT INTO @Resultado
			SELECT
				c.NumeroCuenta,
				tc.Nombre,
				c.SaldoActual,
				ISNULL((SELECT SUM(Monto) FROM tbl_Transaccion
						WHERE CodigoCuentaOrigen = c.CodigoCuenta AND CodigoTipoTransaccion = 1 AND Estado = 1), 0),
				ISNULL((SELECT SUM(Monto) FROM tbl_Transaccion
						WHERE CodigoCuentaOrigen = c.CodigoCuenta AND CodigoTipoTransaccion = 2 AND Estado = 1), 0),
				ROUND(c.SaldoActual * (tc.TasaInteres / 100) / 12, 2)
			FROM tbl_CuentaBancaria c
			INNER JOIN tbl_TipoCuenta tc ON c.CodigoTipoCuenta = tc.CodigoTipoCuenta
			WHERE c.CodigoCliente = @IdCliente AND c.Activa = 1;

			RETURN;
		END;
		GO

		-- Ejemplo de uso
		SELECT * FROM dbo.fn_ResumenFinancieroCliente(1);
		GO


		-- 2. Historial de transacciones detallado por cuenta
		CREATE FUNCTION dbo.fn_HistorialCuenta (@CodigoCuenta INT)
		RETURNS @Tabla TABLE
		(
			FechaHora       DATETIME,
			TipoTransaccion VARCHAR(50),
			Monto           DECIMAL(18,2),
			Moneda          VARCHAR(10),
			CuentaDestino   VARCHAR(20),
			Descripcion     VARCHAR(200)
		)
		AS
		BEGIN
			INSERT INTO @Tabla
			SELECT
				t.FechaHora,
				tt.Nombre,
				t.Monto,
				m.Simbolo,
				cd.NumeroCuenta,
				t.Descripcion
			FROM tbl_Transaccion t
			INNER JOIN tbl_TipoTransaccion tt ON t.CodigoTipoTransaccion = tt.CodigoTipoTransaccion
			INNER JOIN tbl_moneda          m  ON t.CodigoMoneda          = m.CodigoMoneda
			LEFT  JOIN tbl_CuentaBancaria  cd ON t.CodigoCuentaDestino   = cd.CodigoCuenta
			WHERE (t.CodigoCuentaOrigen = @CodigoCuenta OR t.CodigoCuentaDestino = @CodigoCuenta)
			  AND t.Estado = 1
			ORDER BY t.FechaHora DESC;

			RETURN;
		END;
		GO

		-- Ejemplo de uso
		SELECT * FROM dbo.fn_HistorialCuenta(1);
		GO


		-- 3. Clientes con mayor movimiento bancario
		CREATE FUNCTION dbo.fn_ClientesMayorMovimiento (@Top INT)
		RETURNS @Tabla TABLE
		(
			NombreCliente     VARCHAR(200),
			TotalTransacciones INT,
			MontoTotalMovido  DECIMAL(18,2)
		)
		AS
		BEGIN
			INSERT INTO @Tabla
			SELECT TOP (@Top)
				cl.Nombres + ' ' + cl.Apellidos,
				COUNT(t.CodigoTransaccion),
				SUM(t.Monto)
			FROM tbl_Transaccion t
			INNER JOIN tbl_CuentaBancaria co ON t.CodigoCuentaOrigen = co.CodigoCuenta
			INNER JOIN tbl_Cliente        cl ON co.CodigoCliente     = cl.IdCliente
			WHERE t.Estado = 1
			GROUP BY cl.Nombres, cl.Apellidos
			ORDER BY SUM(t.Monto) DESC;

			RETURN;
		END;
		GO

		-- Ejemplo de uso
		SELECT * FROM dbo.fn_ClientesMayorMovimiento(5);
		GO


		-- 4. Estadísticas de cuentas por tipo
		CREATE FUNCTION dbo.fn_EstadisticasTipoCuenta()
		RETURNS @Tabla TABLE
		(
			TipoCuenta     VARCHAR(50),
			TotalCuentas   INT,
			SaldoTotal     DECIMAL(18,2),
			SaldoPromedio  DECIMAL(18,2),
			TasaInteres    DECIMAL(5,2)
		)
		AS
		BEGIN
			INSERT INTO @Tabla
			SELECT
				tc.Nombre,
				COUNT(c.CodigoCuenta),
				SUM(c.SaldoActual),
				AVG(c.SaldoActual),
				tc.TasaInteres
			FROM tbl_CuentaBancaria c
			INNER JOIN tbl_TipoCuenta tc ON c.CodigoTipoCuenta = tc.CodigoTipoCuenta
			WHERE c.Activa = 1
			GROUP BY tc.Nombre, tc.TasaInteres;

			RETURN;
		END;
		GO

		-- Ejemplo de uso
		SELECT * FROM dbo.fn_EstadisticasTipoCuenta();
		GO


		-- 5. Transacciones de alto monto
		CREATE FUNCTION dbo.fn_TransaccionesAltoMonto (@MontoMinimo DECIMAL(18,2))
		RETURNS @Tabla TABLE
		(
			CodigoTransaccion INT,
			NombreCliente     VARCHAR(200),
			TipoTransaccion   VARCHAR(50),
			Monto             DECIMAL(18,2),
			FechaHora         DATETIME
		)
		AS
		BEGIN
			INSERT INTO @Tabla
			SELECT
				t.CodigoTransaccion,
				cl.Nombres + ' ' + cl.Apellidos,
				tt.Nombre,
				t.Monto,
				t.FechaHora
			FROM tbl_Transaccion t
			INNER JOIN tbl_TipoTransaccion tt ON t.CodigoTipoTransaccion = tt.CodigoTipoTransaccion
			INNER JOIN tbl_CuentaBancaria  co ON t.CodigoCuentaOrigen    = co.CodigoCuenta
			INNER JOIN tbl_Cliente         cl ON co.CodigoCliente        = cl.IdCliente
			WHERE t.Monto >= @MontoMinimo AND t.Estado = 1
			ORDER BY t.Monto DESC;

			RETURN;
		END;
		GO

		-- Ejemplo de uso
		SELECT * FROM dbo.fn_TransaccionesAltoMonto(5000);
		GO


-- =============================================
-- =============================================
--     TRIGGERS - INTEGRANTE 1               --
-- =============================================
-- =============================================

	---------------------------------------
	-- TRIGGERS DML AFTER
	---------------------------------------

		-- 1. Registrar en auditoría al insertar un cliente
		CREATE TRIGGER trg_AuditarInsertCliente
		ON tbl_Cliente
		AFTER INSERT
		AS
		BEGIN
			INSERT INTO tbl_Auditoria (TablaAfectada, Accion, RegistroId, Usuario, FechaHora, ValoresNuevos)
			SELECT
				'tbl_Cliente', 'Insert', i.IdCliente,
				ISNULL(i.UsuarioCreacion, 'sistema'), GETDATE(),
				'Nombres: ' + i.Nombres + ' ' + i.Apellidos + ' | DPI: ' + ISNULL(i.DPI, 'N/A') + ' | Email: ' + i.Email
			FROM inserted i;
		END;
		GO

		-- Prueba trigger
		INSERT INTO tbl_Cliente (TipoCliente, Nombres, Apellidos, DPI, FechaNacimiento, Telefono, Email, Direccion, Estado, UsuarioCreacion, FechaCreacion)
		VALUES ('INDIVIDUAL', 'Trigger', 'Test', '9999999999999', '2000-01-01', '5555-9999', 'trigger@test.com', 'Zona Test', 1, 'admin', GETDATE());
		SELECT * FROM tbl_Auditoria ORDER BY CodigoAuditoria DESC;


		-- 2. Registrar en auditoría al actualizar un cliente
		CREATE TRIGGER trg_AuditarUpdateCliente
		ON tbl_Cliente
		AFTER UPDATE
		AS
		BEGIN
			INSERT INTO tbl_Auditoria (TablaAfectada, Accion, RegistroId, Usuario, FechaHora, ValoresAnteriores, ValoresNuevos)
			SELECT
				'tbl_Cliente', 'Update', i.IdCliente,
				ISNULL(i.UsuarioModificacion, 'sistema'), GETDATE(),
				'Email anterior: ' + d.Email + ' | Tel anterior: ' + d.Telefono,
				'Email nuevo: '    + i.Email + ' | Tel nuevo: '    + i.Telefono
			FROM inserted i
			INNER JOIN deleted d ON i.IdCliente = d.IdCliente;
		END;
		GO

		-- Prueba trigger
		UPDATE tbl_Cliente SET Telefono = '5555-1111', UsuarioModificacion = 'admin', FechaModificacion = GETDATE()
		WHERE IdCliente = 1;
		SELECT * FROM tbl_Auditoria ORDER BY CodigoAuditoria DESC;


		-- 3. Actualizar FechaModificacion automáticamente al modificar saldo de cuenta
		CREATE TRIGGER trg_ActualizarFechaModCuenta
		ON tbl_CuentaBancaria
		AFTER UPDATE
		AS
		BEGIN
			IF UPDATE(SaldoActual)
			BEGIN
				UPDATE c
				SET FechaModificacion = GETDATE()
				FROM tbl_CuentaBancaria c
				INNER JOIN inserted i ON c.CodigoCuenta = i.CodigoCuenta;
			END
		END;
		GO

		-- Prueba trigger
		UPDATE tbl_CuentaBancaria SET SaldoActual = SaldoActual + 100 WHERE CodigoCuenta = 1;
		SELECT CodigoCuenta, SaldoActual, FechaModificacion FROM tbl_CuentaBancaria WHERE CodigoCuenta = 1;


		-- 4. Registrar auditoría al realizar una transacción
		CREATE TRIGGER trg_AuditarTransaccion
		ON tbl_Transaccion
		AFTER INSERT
		AS
		BEGIN
			INSERT INTO tbl_Auditoria (TablaAfectada, Accion, RegistroId, Usuario, FechaHora, ValoresNuevos)
			SELECT
				'tbl_Transaccion', 'Insert', i.CodigoTransaccion,
				ISNULL(i.UsuarioCreacion, 'sistema'), GETDATE(),
				'Tipo: ' + CAST(i.CodigoTipoTransaccion AS VARCHAR) +
				' | Monto: ' + CAST(i.Monto AS VARCHAR) +
				' | Cuenta: ' + CAST(ISNULL(i.CodigoCuentaOrigen, 0) AS VARCHAR)
			FROM inserted i;
		END;
		GO

		-- Prueba trigger (insertar transacción directa de prueba)
		INSERT INTO tbl_Transaccion (CodigoCuentaOrigen, CodigoTipoTransaccion, CodigoMoneda, Monto, TipoCambioAplicado, FechaHora, Descripcion, Estado, UsuarioCreacion, FechaCreacion)
		VALUES (1, 1, 1, 100.00, 1.0000, GETDATE(), 'Prueba trigger auditoría', 1, 'admin', GETDATE());
		SELECT * FROM tbl_Auditoria ORDER BY CodigoAuditoria DESC;


		-- 5. Verificar saldo mínimo tras retiro y marcar cuenta en observación
		CREATE TRIGGER trg_AlertaSaldoMinimo
		ON tbl_CuentaBancaria
		AFTER UPDATE
		AS
		BEGIN
			IF UPDATE(SaldoActual)
			BEGIN
				INSERT INTO tbl_Auditoria (TablaAfectada, Accion, RegistroId, Usuario, FechaHora, ValoresAnteriores, ValoresNuevos)
				SELECT
					'tbl_CuentaBancaria', 'AlertaSaldo', i.CodigoCuenta,
					'sistema', GETDATE(),
					'Saldo anterior: ' + CAST(d.SaldoActual AS VARCHAR),
					'Saldo actual: '   + CAST(i.SaldoActual AS VARCHAR) + ' — SALDO BAJO'
				FROM inserted i
				INNER JOIN deleted        d  ON i.CodigoCuenta    = d.CodigoCuenta
				INNER JOIN tbl_TipoCuenta tc ON i.CodigoTipoCuenta = tc.CodigoTipoCuenta
				WHERE i.SaldoActual < tc.SaldoMinimo;
			END
		END;
		GO

		-- Prueba trigger
		UPDATE tbl_CuentaBancaria SET SaldoActual = 0 WHERE CodigoCuenta = 2;
		SELECT * FROM tbl_Auditoria ORDER BY CodigoAuditoria DESC;


	---------------------------------------
	-- TRIGGERS DML INSTEAD OF
	---------------------------------------

		-- 6. Evitar eliminar clientes con cuentas activas
		CREATE TRIGGER trg_EvitarEliminarClienteConCuentas
		ON tbl_Cliente
		INSTEAD OF DELETE
		AS
		BEGIN
			IF EXISTS (
				SELECT 1 FROM deleted d
				INNER JOIN tbl_CuentaBancaria c ON d.IdCliente = c.CodigoCliente
				WHERE c.Activa = 1
			)
			BEGIN
				RAISERROR('No se puede eliminar el cliente porque tiene cuentas bancarias activas.', 16, 1);
			END
			ELSE
			BEGIN
				DELETE FROM tbl_Cliente
				WHERE IdCliente IN (SELECT IdCliente FROM deleted);
			END
		END;
		GO

		-- Prueba trigger
		DELETE FROM tbl_Cliente WHERE IdCliente = 1;
		SELECT * FROM tbl_Cliente;


		-- 7. Evitar transacciones con monto negativo o cero
		CREATE TRIGGER trg_ValidarMontoTransaccion
		ON tbl_Transaccion
		INSTEAD OF INSERT
		AS
		BEGIN
			IF EXISTS (SELECT 1 FROM inserted WHERE Monto <= 0)
			BEGIN
				RAISERROR('El monto de la transacción debe ser mayor a cero.', 16, 1);
			END
			ELSE
			BEGIN
				INSERT INTO tbl_Transaccion
				(CodigoCuentaOrigen, CodigoCuentaDestino, CodigoTipoTransaccion, CodigoMoneda,
				 Monto, TipoCambioAplicado, FechaHora, Descripcion, Estado, UsuarioCreacion, FechaCreacion)
				SELECT
					CodigoCuentaOrigen, CodigoCuentaDestino, CodigoTipoTransaccion, CodigoMoneda,
					Monto, TipoCambioAplicado, FechaHora, Descripcion, Estado, UsuarioCreacion, FechaCreacion
				FROM inserted;
			END
		END;
		GO

		-- Prueba trigger (debe fallar)
		INSERT INTO tbl_Transaccion (CodigoCuentaOrigen, CodigoTipoTransaccion, CodigoMoneda, Monto, TipoCambioAplicado, FechaHora, Estado, UsuarioCreacion, FechaCreacion)
		VALUES (1, 1, 1, -500.00, 1.0000, GETDATE(), 1, 'admin', GETDATE());


		-- 8. Evitar cerrar cuenta con saldo positivo
		CREATE TRIGGER trg_EvitarCerrarCuentaConSaldo
		ON tbl_CuentaBancaria
		INSTEAD OF DELETE
		AS
		BEGIN
			IF EXISTS (SELECT 1 FROM deleted WHERE SaldoActual > 0)
			BEGIN
				RAISERROR('No se puede cerrar una cuenta con saldo disponible. Retire el saldo primero.', 16, 1);
			END
			ELSE
			BEGIN
				DELETE FROM tbl_CuentaBancaria
				WHERE CodigoCuenta IN (SELECT CodigoCuenta FROM deleted);
			END
		END;
		GO

		-- Prueba trigger (debe fallar)
		DELETE FROM tbl_CuentaBancaria WHERE CodigoCuenta = 1;


		-- 9. Validar email único al insertar cliente
		CREATE TRIGGER trg_ValidarEmailUnicoCliente
		ON tbl_Cliente
		INSTEAD OF INSERT
		AS
		BEGIN
			IF EXISTS (
				SELECT 1 FROM inserted i
				INNER JOIN tbl_Cliente c ON i.Email = c.Email
			)
			BEGIN
				RAISERROR('No se puede registrar el cliente. El correo electrónico ya está en uso.', 16, 1);
			END
			ELSE
			BEGIN
				INSERT INTO tbl_Cliente
				(TipoCliente, Nombres, Apellidos, DPI, NIT, FechaNacimiento,
				 Telefono, Email, Direccion, Estado, UsuarioCreacion, FechaCreacion)
				SELECT
					TipoCliente, Nombres, Apellidos, DPI, NIT, FechaNacimiento,
					Telefono, Email, Direccion, Estado, UsuarioCreacion, FechaCreacion
				FROM inserted;
			END
		END;
		GO

		-- Prueba trigger (email duplicado - debe fallar)
		INSERT INTO tbl_Cliente (TipoCliente, Nombres, Apellidos, DPI, FechaNacimiento, Telefono, Email, Direccion, Estado, UsuarioCreacion, FechaCreacion)
		VALUES ('INDIVIDUAL', 'Duplicado', 'Test', '1111111111111', '1990-01-01', '5555-0000', 'jcperez@email.com', 'Zona 1', 1, 'admin', GETDATE());


		-- 10. Validar tipo de cliente al actualizar
		CREATE TRIGGER trg_ValidarTipoClienteUpdate
		ON tbl_Cliente
		INSTEAD OF UPDATE
		AS
		BEGIN
			IF EXISTS (SELECT 1 FROM inserted WHERE TipoCliente NOT IN ('INDIVIDUAL', 'EMPRESARIAL'))
			BEGIN
				RAISERROR('Tipo de cliente inválido. Solo se permite INDIVIDUAL o EMPRESARIAL.', 16, 1);
			END
			ELSE
			BEGIN
				UPDATE c
				SET
					TipoCliente         = i.TipoCliente,
					Nombres             = i.Nombres,
					Apellidos           = i.Apellidos,
					DPI                 = i.DPI,
					NIT                 = i.NIT,
					FechaNacimiento     = i.FechaNacimiento,
					Telefono            = i.Telefono,
					Email               = i.Email,
					Direccion           = i.Direccion,
					Estado              = i.Estado,
					UsuarioModificacion = i.UsuarioModificacion,
					FechaModificacion   = GETDATE()
				FROM tbl_Cliente c
				INNER JOIN inserted i ON c.IdCliente = i.IdCliente;
			END
		END;
		GO

		-- Prueba trigger (tipo inválido - debe fallar)
		UPDATE tbl_Cliente SET TipoCliente = 'CORPORATIVO' WHERE IdCliente = 1;
		SELECT * FROM tbl_Cliente ORDER BY IdCliente;

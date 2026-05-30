USE db_SistemaBancario
GO

--  INTEGRANTE 1
--  Tablas: 
--  tbl_Cliente,
--  tbl_CuentaBancaria,
--  tbl_TipoCuenta,
--  tbl_Transaccion,
--  tbl_TipoTransaccion,
--  tbl_Auditoria

-- =============================================
--              STORED PROCEDURES 
-- =============================================

CREATE PROCEDURE usp_ConsultarCliente
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_Cliente
		ORDER BY IdCliente ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO

CREATE PROCEDURE usp_AgregarCliente
(
	@TipoCliente VARCHAR(20),
	@Nombres VARCHAR(100),
	@Apellidos VARCHAR(100),
	@DPI VARCHAR(20) = NULL,
	@NIT VARCHAR(20) = NULL,
	@FechaNacimiento DATE,
	@Telefono VARCHAR(20),
	@Email VARCHAR(100),
	@Direccion VARCHAR(200),
	@UsuarioCreacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO tbl_Cliente
		(
			TipoCliente, Nombres, Apellidos, DPI, NIT, FechaNacimiento,
			Telefono, Email, Direccion, Estado, UsuarioCreacion, FechaCreacion
		)
		VALUES
		(
			@TipoCliente, @Nombres, @Apellidos, @DPI, @NIT, @FechaNacimiento,
			@Telefono, @Email, @Direccion, 1, @UsuarioCreacion, GETDATE()
		);

		SET @Resultado = 1;
		SET @Mensaje = 'Cliente agregado correctamente BDD';
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EditarCliente
(
	@IdCliente INT,
	@TipoCliente VARCHAR(20),
	@Nombres VARCHAR(100),
	@Apellidos VARCHAR(100),
	@DPI VARCHAR(20) = NULL,
	@NIT VARCHAR(20) = NULL,
	@FechaNacimiento DATE,
	@Telefono VARCHAR(20),
	@Email VARCHAR(100),
	@Direccion VARCHAR(200),
	@Estado BIT,
	@UsuarioModificacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE tbl_Cliente
		SET
			TipoCliente = @TipoCliente,
			Nombres = @Nombres,
			Apellidos = @Apellidos,
			DPI = @DPI,
			NIT = @NIT,
			FechaNacimiento = @FechaNacimiento,
			Telefono = @Telefono,
			Email = @Email,
			Direccion = @Direccion,
			Estado = @Estado,
			UsuarioModificacion = @UsuarioModificacion,
			FechaModificacion = GETDATE()
		WHERE IdCliente = @IdCliente;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro el cliente';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Cliente actualizado correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EliminarCliente
(
	@IdCliente INT,
	@UsuarioEliminacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE tbl_Cliente
		SET
			Estado = 0,
			UsuarioEliminacion = @UsuarioEliminacion,
			FechaEliminacion = GETDATE()
		WHERE IdCliente = @IdCliente;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro el cliente';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Cliente eliminado correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_BuscarCliente
(
	@Nombres VARCHAR(100)
)
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_Cliente
		WHERE Nombres LIKE '%' + @Nombres + '%'
		   OR Apellidos LIKE '%' + @Nombres + '%'
		ORDER BY IdCliente ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END;
GO

CREATE PROCEDURE usp_ConsultarCuentaBancaria
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_CuentaBancaria
		ORDER BY CodigoCuenta ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO

CREATE PROCEDURE usp_AgregarCuentaBancaria
(
	@NumeroCuenta VARCHAR(20),
	@CodigoCliente INT,
	@CodigoSucursal INT,
	@CodigoTipoCuenta INT,
	@CodigoMoneda INT,
	@SaldoActual DECIMAL(18,2),
	@FechaApertura DATE,
	@UsuarioCreacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO tbl_CuentaBancaria
		(
			NumeroCuenta, CodigoCliente, CodigoSucursal, CodigoTipoCuenta,
			CodigoMoneda, SaldoActual, FechaApertura, Estado, UsuarioCreacion, FechaCreacion
		)
		VALUES
		(
			@NumeroCuenta, @CodigoCliente, @CodigoSucursal, @CodigoTipoCuenta,
			@CodigoMoneda, @SaldoActual, @FechaApertura, 1, @UsuarioCreacion, GETDATE()
		);

		SET @Resultado = 1;
		SET @Mensaje = 'Cuenta bancaria agregada correctamente BDD';
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EditarCuentaBancaria
(
	@CodigoCuenta INT,
	@NumeroCuenta VARCHAR(20),
	@CodigoCliente INT,
	@CodigoSucursal INT,
	@CodigoTipoCuenta INT,
	@CodigoMoneda INT,
	@SaldoActual DECIMAL(18,2),
	@FechaApertura DATE,
	@Estado BIT,
	@UsuarioModificacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE tbl_CuentaBancaria
		SET
			NumeroCuenta = @NumeroCuenta,
			CodigoCliente = @CodigoCliente,
			CodigoSucursal = @CodigoSucursal,
			CodigoTipoCuenta = @CodigoTipoCuenta,
			CodigoMoneda = @CodigoMoneda,
			SaldoActual = @SaldoActual,
			FechaApertura = @FechaApertura,
			Estado = @Estado,
			UsuarioModificacion = @UsuarioModificacion,
			FechaModificacion = GETDATE()
		WHERE CodigoCuenta = @CodigoCuenta;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro la cuenta bancaria';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Cuenta bancaria actualizada correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EliminarCuentaBancaria
(
	@CodigoCuenta INT,
	@UsuarioEliminacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE tbl_CuentaBancaria
		SET
			Estado = 0,
			UsuarioEliminacion = @UsuarioEliminacion,
			FechaEliminacion = GETDATE()
		WHERE CodigoCuenta = @CodigoCuenta;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro la cuenta bancaria';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Cuenta bancaria eliminada correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_BuscarCuentaBancaria
(
	@NumeroCuenta VARCHAR(20)
)
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_CuentaBancaria
		WHERE NumeroCuenta LIKE '%' + @NumeroCuenta + '%'
		ORDER BY CodigoCuenta ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END;
GO

CREATE PROCEDURE usp_ConsultarTipoCuenta
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_TipoCuenta
		ORDER BY CodigoTipoCuenta ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO

CREATE PROCEDURE usp_AgregarTipoCuenta
(
	@Nombre VARCHAR(50),
	@SaldoMinimo DECIMAL(18,2),
	@TasaInteres DECIMAL(5,2),
	@UsuarioCreacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO tbl_TipoCuenta
		(
			Nombre, SaldoMinimo, TasaInteres, Estado, UsuarioCreacion, FechaCreacion
		)
		VALUES
		(
			@Nombre, @SaldoMinimo, @TasaInteres, 1, @UsuarioCreacion, GETDATE()
		);

		SET @Resultado = 1;
		SET @Mensaje = 'Tipo cuenta agregado correctamente BDD';
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EditarTipoCuenta
(
	@CodigoTipoCuenta INT,
	@Nombre VARCHAR(50),
	@SaldoMinimo DECIMAL(18,2),
	@TasaInteres DECIMAL(5,2),
	@Estado BIT,
	@UsuarioModificacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE tbl_TipoCuenta
		SET
			Nombre = @Nombre,
			SaldoMinimo = @SaldoMinimo,
			TasaInteres = @TasaInteres,
			Estado = @Estado,
			UsuarioModificacion = @UsuarioModificacion,
			FechaModificacion = GETDATE()
		WHERE CodigoTipoCuenta = @CodigoTipoCuenta;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro el tipo cuenta';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Tipo cuenta actualizado correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EliminarTipoCuenta
(
	@CodigoTipoCuenta INT,
	@UsuarioEliminacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE tbl_TipoCuenta
		SET
			Estado = 0,
			UsuarioEliminacion = @UsuarioEliminacion,
			FechaEliminacion = GETDATE()
		WHERE CodigoTipoCuenta = @CodigoTipoCuenta;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro el tipo cuenta';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Tipo cuenta eliminado correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_BuscarTipoCuenta
(
	@Nombre VARCHAR(50)
)
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_TipoCuenta
		WHERE Nombre LIKE '%' + @Nombre + '%'
		ORDER BY CodigoTipoCuenta ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END;
GO

CREATE PROCEDURE usp_ConsultarTransaccion
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_Transaccion
		ORDER BY CodigoTransaccion ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO

CREATE PROCEDURE usp_AgregarTransaccion
(
	@CodigoCuentaOrigen INT = NULL,
	@CodigoCuentaDestino INT = NULL,
	@CodigoTipoTransaccion INT,
	@CodigoMoneda INT,
	@Monto DECIMAL(18,2),
	@TipoCambioAplicado DECIMAL(18,4),
	@FechaHora DATETIME,
	@Descripcion VARCHAR(200) = NULL,
	@UsuarioCreacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO tbl_Transaccion
		(
			CodigoCuentaOrigen, CodigoCuentaDestino, CodigoTipoTransaccion,
			CodigoMoneda, Monto, TipoCambioAplicado, FechaHora,
			Descripcion, Estado, UsuarioCreacion, FechaCreacion
		)
		VALUES
		(
			@CodigoCuentaOrigen, @CodigoCuentaDestino, @CodigoTipoTransaccion,
			@CodigoMoneda, @Monto, @TipoCambioAplicado, @FechaHora,
			@Descripcion, 1, @UsuarioCreacion, GETDATE()
		);

		SET @Resultado = 1;
		SET @Mensaje = 'Transaccion agregada correctamente BDD';
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EditarTransaccion
(
	@CodigoTransaccion INT,
	@CodigoCuentaOrigen INT = NULL,
	@CodigoCuentaDestino INT = NULL,
	@CodigoTipoTransaccion INT,
	@CodigoMoneda INT,
	@Monto DECIMAL(18,2),
	@TipoCambioAplicado DECIMAL(18,4),
	@FechaHora DATETIME,
	@Descripcion VARCHAR(200) = NULL,
	@Estado BIT,
	@UsuarioModificacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE tbl_Transaccion
		SET
			CodigoCuentaOrigen = @CodigoCuentaOrigen,
			CodigoCuentaDestino = @CodigoCuentaDestino,
			CodigoTipoTransaccion = @CodigoTipoTransaccion,
			CodigoMoneda = @CodigoMoneda,
			Monto = @Monto,
			TipoCambioAplicado = @TipoCambioAplicado,
			FechaHora = @FechaHora,
			Descripcion = @Descripcion,
			Estado = @Estado,
			UsuarioModificacion = @UsuarioModificacion,
			FechaModificacion = GETDATE()
		WHERE CodigoTransaccion = @CodigoTransaccion;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro la transaccion';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Transaccion actualizada correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EliminarTransaccion
(
	@CodigoTransaccion INT,
	@UsuarioEliminacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE tbl_Transaccion
		SET
			Estado = 0,
			UsuarioEliminacion = @UsuarioEliminacion,
			FechaEliminacion = GETDATE()
		WHERE CodigoTransaccion = @CodigoTransaccion;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro la transaccion';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Transaccion eliminada correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_BuscarTransaccion
(
	@Descripcion VARCHAR(200)
)
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_Transaccion
		WHERE Descripcion LIKE '%' + @Descripcion + '%'
		ORDER BY CodigoTransaccion ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END;
GO

CREATE PROCEDURE usp_ConsultarTipoTransaccion
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_TipoTransaccion
		ORDER BY CodigoTipoTransaccion ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO

CREATE PROCEDURE usp_AgregarTipoTransaccion
(
	@Nombre VARCHAR(50),
	@UsuarioCreacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO tbl_TipoTransaccion
		(
			Nombre, Estado, UsuarioCreacion, FechaCreacion
		)
		VALUES
		(
			@Nombre, 1, @UsuarioCreacion, GETDATE()
		);

		SET @Resultado = 1;
		SET @Mensaje = 'Tipo transaccion agregado correctamente BDD';
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EditarTipoTransaccion
(
	@CodigoTipoTransaccion INT,
	@Nombre VARCHAR(50),
	@Estado BIT,
	@UsuarioModificacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE tbl_TipoTransaccion
		SET
			Nombre = @Nombre,
			Estado = @Estado,
			UsuarioModificacion = @UsuarioModificacion,
			FechaModificacion = GETDATE()
		WHERE CodigoTipoTransaccion = @CodigoTipoTransaccion;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro el tipo transaccion';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Tipo transaccion actualizado correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EliminarTipoTransaccion
(
	@CodigoTipoTransaccion INT,
	@UsuarioEliminacion VARCHAR(50) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE tbl_TipoTransaccion
		SET
			Estado = 0,
			UsuarioEliminacion = @UsuarioEliminacion,
			FechaEliminacion = GETDATE()
		WHERE CodigoTipoTransaccion = @CodigoTipoTransaccion;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro el tipo transaccion';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Tipo transaccion eliminado correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_BuscarTipoTransaccion
(
	@Nombre VARCHAR(50)
)
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_TipoTransaccion
		WHERE Nombre LIKE '%' + @Nombre + '%'
		ORDER BY CodigoTipoTransaccion ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END;
GO

CREATE PROCEDURE usp_ConsultarAuditoria
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_Auditoria
		ORDER BY CodigoAuditoria ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
GO

CREATE PROCEDURE usp_AgregarAuditoria
(
	@TablaAfectada VARCHAR(50),
	@Accion VARCHAR(20),
	@RegistroId INT,
	@Usuario VARCHAR(50),
	@FechaHora DATETIME,
	@ValoresAnteriores VARCHAR(MAX) = NULL,
	@ValoresNuevos VARCHAR(MAX) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO tbl_Auditoria
		(
			TablaAfectada, Accion, RegistroId, Usuario, FechaHora,
			ValoresAnteriores, ValoresNuevos
		)
		VALUES
		(
			@TablaAfectada, @Accion, @RegistroId, @Usuario, @FechaHora,
			@ValoresAnteriores, @ValoresNuevos
		);

		SET @Resultado = 1;
		SET @Mensaje = 'Auditoria agregada correctamente BDD';
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EditarAuditoria
(
	@CodigoAuditoria INT,
	@TablaAfectada VARCHAR(50),
	@Accion VARCHAR(20),
	@RegistroId INT,
	@Usuario VARCHAR(50),
	@FechaHora DATETIME,
	@ValoresAnteriores VARCHAR(MAX) = NULL,
	@ValoresNuevos VARCHAR(MAX) = NULL,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		UPDATE tbl_Auditoria
		SET
			TablaAfectada = @TablaAfectada,
			Accion = @Accion,
			RegistroId = @RegistroId,
			Usuario = @Usuario,
			FechaHora = @FechaHora,
			ValoresAnteriores = @ValoresAnteriores,
			ValoresNuevos = @ValoresNuevos
		WHERE CodigoAuditoria = @CodigoAuditoria;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro la auditoria';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Auditoria actualizada correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_EliminarAuditoria
(
	@CodigoAuditoria INT,
	@Resultado BIT OUTPUT,
	@Mensaje NVARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		DELETE FROM tbl_Auditoria
		WHERE CodigoAuditoria = @CodigoAuditoria;

		IF @@ROWCOUNT = 0
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'No se encontro la auditoria';
		END
		ELSE
		BEGIN
			SET @Resultado = 1;
			SET @Mensaje = 'Auditoria eliminada correctamente BDD';
		END
	END TRY
	BEGIN CATCH
		SET @Resultado = 0;
		SET @Mensaje = ERROR_MESSAGE();
	END CATCH
END;
GO

CREATE PROCEDURE usp_BuscarAuditoria
(
	@TablaAfectada VARCHAR(50)
)
AS
BEGIN
	BEGIN TRY
		SELECT *
		FROM tbl_Auditoria
		WHERE TablaAfectada LIKE '%' + @TablaAfectada + '%'
		ORDER BY CodigoAuditoria ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END;
GO

-- =============================================
--              STORED PROCEDURES REPORTES
-- =============================================

CREATE PROCEDURE usp_ReporteClientesPorTipo
AS
BEGIN
	BEGIN TRY
		SELECT TipoCliente, COUNT(IdCliente) AS CantidadClientes
		FROM tbl_Cliente
		GROUP BY TipoCliente
		ORDER BY TipoCliente ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END;
GO

CREATE PROCEDURE usp_ReporteSaldosPorSucursal
AS
BEGIN
	BEGIN TRY
		SELECT s.Nombre AS Sucursal, COUNT(c.CodigoCuenta) AS CantidadCuentas,
			   ISNULL(SUM(c.SaldoActual), 0) AS SaldoTotal
		FROM tbl_Sucursal s
		LEFT JOIN tbl_CuentaBancaria c ON s.CodigoSucursal = c.CodigoSucursal
		GROUP BY s.Nombre
		ORDER BY s.Nombre ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END;
GO

CREATE PROCEDURE usp_ReporteTransaccionesPorTipo
AS
BEGIN
	BEGIN TRY
		SELECT tt.Nombre AS TipoTransaccion, COUNT(t.CodigoTransaccion) AS CantidadTransacciones,
			   ISNULL(SUM(t.Monto), 0) AS MontoTotal
		FROM tbl_TipoTransaccion tt
		LEFT JOIN tbl_Transaccion t ON tt.CodigoTipoTransaccion = t.CodigoTipoTransaccion
		GROUP BY tt.Nombre
		ORDER BY tt.Nombre ASC;
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END;
GO

-- =============================================
--              FUNCIONES ESCALARES
-- =============================================

CREATE FUNCTION dbo.fn_NombreCliente (@IdCliente INT)
RETURNS VARCHAR(201)
AS
BEGIN
	DECLARE @Nombre VARCHAR(201);

	SELECT @Nombre = Nombres + ' ' + Apellidos
	FROM tbl_Cliente
	WHERE IdCliente = @IdCliente;

	RETURN @Nombre;
END;
GO

CREATE FUNCTION dbo.fn_SaldoCuenta (@CodigoCuenta INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
	DECLARE @Saldo DECIMAL(18,2);

	SELECT @Saldo = SaldoActual
	FROM tbl_CuentaBancaria
	WHERE CodigoCuenta = @CodigoCuenta;

	RETURN @Saldo;
END;
GO

CREATE FUNCTION dbo.fn_NombreTipoCuenta (@CodigoTipoCuenta INT)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Nombre VARCHAR(50);

	SELECT @Nombre = Nombre
	FROM tbl_TipoCuenta
	WHERE CodigoTipoCuenta = @CodigoTipoCuenta;

	RETURN @Nombre;
END;
GO

CREATE FUNCTION dbo.fn_MontoTransaccion (@CodigoTransaccion INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
	DECLARE @Monto DECIMAL(18,2);

	SELECT @Monto = Monto
	FROM tbl_Transaccion
	WHERE CodigoTransaccion = @CodigoTransaccion;

	RETURN @Monto;
END;
GO

CREATE FUNCTION dbo.fn_NombreTipoTransaccion (@CodigoTipoTransaccion INT)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Nombre VARCHAR(50);

	SELECT @Nombre = Nombre
	FROM tbl_TipoTransaccion
	WHERE CodigoTipoTransaccion = @CodigoTipoTransaccion;

	RETURN @Nombre;
END;
GO

CREATE FUNCTION dbo.fn_TotalAuditoriaTabla (@TablaAfectada VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @Cantidad INT;

	SELECT @Cantidad = COUNT(*)
	FROM tbl_Auditoria
	WHERE TablaAfectada = @TablaAfectada;

	RETURN @Cantidad;
END;
GO

-- =============================================
--              FUNCIONES DE TABLA EN LINEA
-- =============================================

CREATE FUNCTION dbo.fn_ClientesActivos()
RETURNS TABLE
AS
RETURN (
	SELECT *
	FROM tbl_Cliente
	WHERE Estado = 1
);
GO

CREATE FUNCTION dbo.fn_CuentasPorCliente (@IdCliente INT)
RETURNS TABLE
AS
RETURN (
	SELECT *
	FROM tbl_CuentaBancaria
	WHERE CodigoCliente = @IdCliente
);
GO

CREATE FUNCTION dbo.fn_TiposCuentaActivos()
RETURNS TABLE
AS
RETURN (
	SELECT *
	FROM tbl_TipoCuenta
	WHERE Estado = 1
);
GO

CREATE FUNCTION dbo.fn_TransaccionesPorCuenta (@CodigoCuenta INT)
RETURNS TABLE
AS
RETURN (
	SELECT *
	FROM tbl_Transaccion
	WHERE CodigoCuentaOrigen = @CodigoCuenta
	   OR CodigoCuentaDestino = @CodigoCuenta
);
GO

CREATE FUNCTION dbo.fn_TiposTransaccionActivos()
RETURNS TABLE
AS
RETURN (
	SELECT *
	FROM tbl_TipoTransaccion
	WHERE Estado = 1
);
GO

CREATE FUNCTION dbo.fn_AuditoriaPorTabla (@TablaAfectada VARCHAR(50))
RETURNS TABLE
AS
RETURN (
	SELECT *
	FROM tbl_Auditoria
	WHERE TablaAfectada = @TablaAfectada
);
GO

-- =============================================
--              FUNCIONES MULTI-STATEMENT (TVF)
-- =============================================

CREATE FUNCTION dbo.fn_DetalleCuenta (@CodigoCuenta INT)
RETURNS @Resultado TABLE
(
	NumeroCuenta VARCHAR(20),
	Cliente VARCHAR(201),
	TipoCuenta VARCHAR(50),
	SaldoActual DECIMAL(18,2),
	FechaApertura DATE
)
AS
BEGIN
	INSERT INTO @Resultado
	SELECT c.NumeroCuenta, cl.Nombres + ' ' + cl.Apellidos, tc.Nombre, c.SaldoActual, c.FechaApertura
	FROM tbl_CuentaBancaria c
	INNER JOIN tbl_Cliente cl ON c.CodigoCliente = cl.IdCliente
	INNER JOIN tbl_TipoCuenta tc ON c.CodigoTipoCuenta = tc.CodigoTipoCuenta
	WHERE c.CodigoCuenta = @CodigoCuenta;

	RETURN;
END;
GO

CREATE FUNCTION dbo.fn_DetalleTransaccion (@CodigoTransaccion INT)
RETURNS @Resultado TABLE
(
	TipoTransaccion VARCHAR(50),
	Monto DECIMAL(18,2),
	FechaHora DATETIME,
	Descripcion VARCHAR(200)
)
AS
BEGIN
	INSERT INTO @Resultado
	SELECT tt.Nombre, t.Monto, t.FechaHora, t.Descripcion
	FROM tbl_Transaccion t
	INNER JOIN tbl_TipoTransaccion tt ON t.CodigoTipoTransaccion = tt.CodigoTipoTransaccion
	WHERE t.CodigoTransaccion = @CodigoTransaccion;

	RETURN;
END;
GO

CREATE FUNCTION dbo.fn_ResumenCliente (@IdCliente INT)
RETURNS @Tabla TABLE
(
	Cliente VARCHAR(201),
	CantidadCuentas INT,
	SaldoTotal DECIMAL(18,2)
)
AS
BEGIN
	INSERT INTO @Tabla
	SELECT cl.Nombres + ' ' + cl.Apellidos,
		   COUNT(c.CodigoCuenta),
		   ISNULL(SUM(c.SaldoActual), 0)
	FROM tbl_Cliente cl
	LEFT JOIN tbl_CuentaBancaria c ON cl.IdCliente = c.CodigoCliente
	WHERE cl.IdCliente = @IdCliente
	GROUP BY cl.Nombres, cl.Apellidos;

	RETURN;
END;
GO

CREATE FUNCTION dbo.fn_ResumenTipoCuenta (@CodigoTipoCuenta INT)
RETURNS @Tabla TABLE
(
	TipoCuenta VARCHAR(50),
	CantidadCuentas INT,
	SaldoTotal DECIMAL(18,2)
)
AS
BEGIN
	INSERT INTO @Tabla
	SELECT tc.Nombre, COUNT(c.CodigoCuenta), ISNULL(SUM(c.SaldoActual), 0)
	FROM tbl_TipoCuenta tc
	LEFT JOIN tbl_CuentaBancaria c ON tc.CodigoTipoCuenta = c.CodigoTipoCuenta
	WHERE tc.CodigoTipoCuenta = @CodigoTipoCuenta
	GROUP BY tc.Nombre;

	RETURN;
END;
GO

CREATE FUNCTION dbo.fn_ResumenTipoTransaccion (@CodigoTipoTransaccion INT)
RETURNS @Tabla TABLE
(
	TipoTransaccion VARCHAR(50),
	CantidadTransacciones INT,
	MontoTotal DECIMAL(18,2)
)
AS
BEGIN
	INSERT INTO @Tabla
	SELECT tt.Nombre, COUNT(t.CodigoTransaccion), ISNULL(SUM(t.Monto), 0)
	FROM tbl_TipoTransaccion tt
	LEFT JOIN tbl_Transaccion t ON tt.CodigoTipoTransaccion = t.CodigoTipoTransaccion
	WHERE tt.CodigoTipoTransaccion = @CodigoTipoTransaccion
	GROUP BY tt.Nombre;

	RETURN;
END;
GO

CREATE FUNCTION dbo.fn_ResumenAuditoriaUsuario (@Usuario VARCHAR(50))
RETURNS @Tabla TABLE
(
	Usuario VARCHAR(50),
	CantidadRegistros INT,
	UltimoRegistro DATETIME
)
AS
BEGIN
	INSERT INTO @Tabla
	SELECT Usuario, COUNT(*), MAX(FechaHora)
	FROM tbl_Auditoria
	WHERE Usuario = @Usuario
	GROUP BY Usuario;

	RETURN;
END;
GO

-- =============================================
--              TRIGGERS DML AFTER
-- =============================================

create trigger trg_RegistrarCreacionCliente
on tbl_Cliente
after insert
as
begin
	update c
	set FechaCreacion = GETDATE()
	from tbl_Cliente c
	inner join inserted i on c.IdCliente = i.IdCliente
end;
GO

create trigger trg_RegistrarCreacionCuenta
on tbl_CuentaBancaria
after insert
as
begin
	update c
	set FechaCreacion = GETDATE()
	from tbl_CuentaBancaria c
	inner join inserted i on c.CodigoCuenta = i.CodigoCuenta
end;
GO

create trigger trg_RegistrarCreacionTipoCuenta
on tbl_TipoCuenta
after insert
as
begin
	update tc
	set FechaCreacion = GETDATE()
	from tbl_TipoCuenta tc
	inner join inserted i on tc.CodigoTipoCuenta = i.CodigoTipoCuenta
end;
GO

create trigger trg_RegistrarCreacionTransaccion
on tbl_Transaccion
after insert
as
begin
	update t
	set FechaCreacion = GETDATE()
	from tbl_Transaccion t
	inner join inserted i on t.CodigoTransaccion = i.CodigoTransaccion
end;
GO

create trigger trg_RegistrarCreacionTipoTransaccion
on tbl_TipoTransaccion
after insert
as
begin
	update tt
	set FechaCreacion = GETDATE()
	from tbl_TipoTransaccion tt
	inner join inserted i on tt.CodigoTipoTransaccion = i.CodigoTipoTransaccion
end;
GO

create trigger trg_AuditarClienteInsert
on tbl_Cliente
after insert
as
begin
	insert into tbl_Auditoria (TablaAfectada, Accion, RegistroId, Usuario, FechaHora, ValoresNuevos)
	select 'tbl_Cliente', 'Insert', IdCliente, ISNULL(UsuarioCreacion, 'Sistema'), GETDATE(), Nombres + ' ' + Apellidos
	from inserted
end;
GO

-- =============================================
--              TRIGGERS DML INSTEAD OF
-- =============================================

create trigger trg_ValidarTipoCliente
on tbl_Cliente
instead of insert
as
begin
	if exists (select 1 from inserted where TipoCliente not in ('INDIVIDUAL', 'EMPRESARIAL'))
	begin
		raiserror('El tipo de cliente debe ser INDIVIDUAL o EMPRESARIAL.', 16, 1)
	end
	else
	begin
		insert into tbl_Cliente (TipoCliente, Nombres, Apellidos, DPI, NIT, FechaNacimiento, Telefono, Email, Direccion, Estado, UsuarioCreacion, FechaCreacion)
		select TipoCliente, Nombres, Apellidos, DPI, NIT, FechaNacimiento, Telefono, Email, Direccion, Estado, UsuarioCreacion, FechaCreacion
		from inserted
	end
end;
GO

create trigger trg_ValidarSaldoCuenta
on tbl_CuentaBancaria
instead of insert
as
begin
	if exists (select 1 from inserted where SaldoActual < 0)
	begin
		raiserror('El saldo de la cuenta no puede ser negativo.', 16, 1)
	end
	else
	begin
		insert into tbl_CuentaBancaria (NumeroCuenta, CodigoCliente, CodigoSucursal, CodigoTipoCuenta, CodigoMoneda, SaldoActual, FechaApertura, Estado, UsuarioCreacion, FechaCreacion)
		select NumeroCuenta, CodigoCliente, CodigoSucursal, CodigoTipoCuenta, CodigoMoneda, SaldoActual, FechaApertura, Estado, UsuarioCreacion, FechaCreacion
		from inserted
	end
end;
GO

create trigger trg_ValidarSaldoMinimoTipoCuenta
on tbl_TipoCuenta
instead of insert
as
begin
	if exists (select 1 from inserted where SaldoMinimo < 0)
	begin
		raiserror('El saldo minimo no puede ser negativo.', 16, 1)
	end
	else
	begin
		insert into tbl_TipoCuenta (Nombre, SaldoMinimo, TasaInteres, Estado, UsuarioCreacion, FechaCreacion)
		select Nombre, SaldoMinimo, TasaInteres, Estado, UsuarioCreacion, FechaCreacion
		from inserted
	end
end;
GO

create trigger trg_ValidarMontoTransaccion
on tbl_Transaccion
instead of insert
as
begin
	if exists (select 1 from inserted where Monto <= 0)
	begin
		raiserror('El monto de la transaccion debe ser positivo.', 16, 1)
	end
	else
	begin
		insert into tbl_Transaccion (CodigoCuentaOrigen, CodigoCuentaDestino, CodigoTipoTransaccion, CodigoMoneda, Monto, TipoCambioAplicado, FechaHora, Descripcion, Estado, UsuarioCreacion, FechaCreacion)
		select CodigoCuentaOrigen, CodigoCuentaDestino, CodigoTipoTransaccion, CodigoMoneda, Monto, TipoCambioAplicado, FechaHora, Descripcion, Estado, UsuarioCreacion, FechaCreacion
		from inserted
	end
end;
GO

create trigger trg_EvitarTipoTransaccionDuplicado
on tbl_TipoTransaccion
instead of insert
as
begin
	if exists (select 1 from inserted i join tbl_TipoTransaccion t on i.Nombre = t.Nombre)
	begin
		raiserror('No se pueden agregar tipos de transaccion duplicados.', 16, 1)
	end
	else
	begin
		insert into tbl_TipoTransaccion (Nombre, Estado, UsuarioCreacion, FechaCreacion)
		select Nombre, Estado, UsuarioCreacion, FechaCreacion
		from inserted
	end
end;
GO

create trigger trg_ValidarAccionAuditoria
on tbl_Auditoria
instead of insert
as
begin
	if exists (select 1 from inserted where Accion not in ('Insert', 'Update', 'Delete'))
	begin
		raiserror('La accion de auditoria debe ser Insert, Update o Delete.', 16, 1)
	end
	else
	begin
		insert into tbl_Auditoria (TablaAfectada, Accion, RegistroId, Usuario, FechaHora, ValoresAnteriores, ValoresNuevos)
		select TablaAfectada, Accion, RegistroId, Usuario, FechaHora, ValoresAnteriores, ValoresNuevos
		from inserted
	end
end;
GO

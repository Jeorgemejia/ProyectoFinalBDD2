-- usp_ConsultarCuentaBancaria
CREATE PROCEDURE usp_ConsultarCuentaBancaria
AS
BEGIN
    BEGIN TRY
        -- Consulta todos los registros necesarios para devolver la informacion solicitada.
        SELECT *
        FROM tbl_CuentaBancaria
        ORDER BY CodigoCuenta ASC;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- usp_AgregarCuentaBancaria
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

-- usp_EditarCuentaBancaria
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

-- usp_EliminarCuentaBancaria
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

-- usp_BuscarCuentaBancaria
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

DECLARE @R BIT, @M NVARCHAR(500);
EXEC usp_AgregarCuentaBancaria
  @NumeroCuenta='000-00-00000001',
  @CodigoCliente=1,
  @CodigoSucursal=1,
  @CodigoTipoCuenta=1,
  @CodigoMoneda=1,
  @SaldoActual=100.00,
  @FechaApertura=GETDATE(),
  @UsuarioCreacion='test',
  @Resultado=@R OUTPUT,
  @Mensaje=@M OUTPUT;
SELECT @R AS Resultado, @M AS Mensaje;
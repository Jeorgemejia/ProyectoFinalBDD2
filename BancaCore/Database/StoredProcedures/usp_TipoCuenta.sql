-- usp_ConsultarTipoCuenta
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

-- usp_AgregarTipoCuenta
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

-- usp_EditarTipoCuenta
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

-- usp_EliminarTipoCuenta
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

-- usp_BuscarTipoCuenta
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

DECLARE @R BIT, @M NVARCHAR(500);
EXEC usp_AgregarTipoCuenta @Nombre='PRUEBA', @SaldoMinimo=0, @TasaInteres=0, @UsuarioCreacion='test', @Resultado=@R OUTPUT, @Mensaje=@M OUTPUT;
SELECT @R AS Resultado, @M AS Mensaje;
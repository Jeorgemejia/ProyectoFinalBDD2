


		-- =============================================
		-- Author:		Elvis Morales
		-- Create date: 22/03/2026
		-- Description:	usp para consultar datos de la tabla huespedes 
		-- =============================================

			CREATE PROCEDURE usp_ConsultarHuespedes
			AS
			BEGIN
				BEGIN TRY
					SELECT *
					FROM tbl_Huespedes
					ORDER BY CodigoHuesped ASC;
				END TRY
				
				BEGIN CATCH
					THROW;
				END CATCH
			END

			-- Ejecutar Stored procedure

			EXEC usp_ConsultarHuespedes;

			-- Consultar Tabla

			Select * From tbl_Huespedes order by CodigoHuesped asc;



		-- =============================================
		-- Author:		Elvis Morales
		-- Create date: 22/03/2026
		-- Description:	usp para agregar datos de la tabla huespedes 
		-- =============================================

			CREATE PROCEDURE usp_AgregarHuespedes
			(
				@Nombre VARCHAR(100),
				@TipoIdentificacion VARCHAR(50),
				@NumeroIdentificacion BIGINT,
				@FechaNacimiento DATETIME,
				@Genero CHAR(1),
				@Telefono INT = NULL,
				@Direccion VARCHAR(255) = NULL,
				@Puntuacion DECIMAL(10,2) = NULL,
				@Estado BIT,
				@Resultado BIT OUTPUT,
				@Mensaje NVARCHAR(500) OUTPUT
			)
			AS
			BEGIN
				BEGIN TRY
					INSERT INTO tbl_Huespedes
					(
						Nombre,
						TipoIdentificacion,
						NumeroIdentificacion,
						FechaNacimiento,
						Genero,
						Telefono,
						Direccion,
						Puntuacion,
						Estado
					)
					VALUES
					(
						@Nombre,
						@TipoIdentificacion,
						@NumeroIdentificacion,
						@FechaNacimiento,
						@Genero,
						@Telefono,
						@Direccion,
						@Puntuacion,
						@Estado
					);

					SET @Resultado = 1;
					SET @Mensaje = 'Huésped agregado correctamente BDD';

				END TRY

				BEGIN CATCH
					SET @Resultado = 0;
					SET @Mensaje = ERROR_MESSAGE();
				END CATCH
			END;

			-- Ejecutar Stored procedure

			DECLARE @Resultado BIT;
			DECLARE @Mensaje NVARCHAR(500);

			EXEC usp_AgregarHuespedes 'Elvis Morales', 'DPI', 124587896512, '2026-01-31', 'O', 	78888478,'Cuilapa Santa Rosa', 5.5, 1,
				 @Resultado = @Resultado OUTPUT,
				 @Mensaje = @Mensaje OUTPUT;

			SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;

			-- Consultar tabla

			Select * From tbl_Huespedes order by CodigoHuesped asc;



		-- =============================================
		-- Author:		Elvis Morales
		-- Create date: 22/03/2026
		-- Description:	Stored procedure para actualizar datos huespedes
		-- =============================================

			CREATE PROCEDURE usp_EditarHuespedes
			(
				@CodigoHuesped INT,
				@Nombre VARCHAR(100),
				@TipoIdentificacion VARCHAR(50),
				@NumeroIdentificacion BIGINT,
				@FechaNacimiento DATETIME,
				@Genero CHAR(1),
				@Telefono INT = NULL,
				@Direccion VARCHAR(255) = NULL,
				@Puntuacion DECIMAL(10,2) = NULL,
				@Estado BIT,
				@Resultado BIT OUTPUT,
				@Mensaje NVARCHAR(500) OUTPUT
			)
			AS
			BEGIN
				BEGIN TRY

					UPDATE tbl_Huespedes
					SET 
						Nombre = @Nombre,
						TipoIdentificacion = @TipoIdentificacion,
						NumeroIdentificacion = @NumeroIdentificacion,
						FechaNacimiento = @FechaNacimiento,
						Genero = @Genero,
						Telefono = @Telefono,
						Direccion = @Direccion,
						Puntuacion = @Puntuacion,
						Estado = @Estado
					WHERE CodigoHuesped = @CodigoHuesped;

					IF @@ROWCOUNT = 0
					BEGIN
						SET @Resultado = 0;
						SET @Mensaje = 'No se encontró el huésped';
					END
					ELSE
					BEGIN
						SET @Resultado = 1;
						SET @Mensaje = 'Huésped actualizado correctamente BDD';
					END

				END TRY
				BEGIN CATCH
					SET @Resultado = 0;
					SET @Mensaje = ERROR_MESSAGE();
				END CATCH
			END;

			-- Ejecutar Stored procedure

			DECLARE @Resultado BIT;
			DECLARE @Mensaje NVARCHAR(500);

			EXEC usp_EditarHuespedes 1,'Juan Perez','Dpi',1234567890101,'1995-05-10','M',55550000,'Zona 1',5.0,1,
				 @Resultado = @Resultado OUTPUT,
				 @Mensaje = @Mensaje OUTPUT;

			SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;

			-- Consultar tabla

			Select * From tbl_Huespedes order by CodigoHuesped asc;


		
		-- =============================================
		-- Author:		Elvis Morales
		-- Create date: 22/03/2026
		-- Description:	Stored procedure para eliminar datos huespedes
		-- =============================================
		-- =============================================

			CREATE PROCEDURE usp_EliminarHuespedes
			(
				@CodigoHuesped INT,
				@Resultado BIT OUTPUT,
				@Mensaje NVARCHAR(500) OUTPUT
			)
			AS
			BEGIN
				BEGIN TRY

					DELETE FROM tbl_Huespedes
					WHERE CodigoHuesped = @CodigoHuesped;

					IF @@ROWCOUNT = 0
					BEGIN
						SET @Resultado = 0;
						SET @Mensaje = 'No se encontró el huésped';
					END
					ELSE
					BEGIN
						SET @Resultado = 1;
						SET @Mensaje = 'Huésped eliminado correctamente BDD';
					END

				END TRY
				BEGIN CATCH
					SET @Resultado = 0;
					SET @Mensaje = ERROR_MESSAGE();
				END CATCH
			END;

			-- Ejecutar Stored procedure

			DECLARE @Resultado BIT;
			DECLARE @Mensaje NVARCHAR(500);

			EXEC usp_EliminarHuespedes 2,
				 @Resultado = @Resultado OUTPUT,
				 @Mensaje = @Mensaje OUTPUT;

			SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;

			-- Consultar tabla

			Select * From tbl_Huespedes order by CodigoHuesped asc;


		-- =============================================
		-- Author:		Elvis Morales
		-- Create date: 22/03/2026
		-- Description:	Stored procedure para buscar datos huespedes
		-- =============================================
		-- =============================================

			CREATE PROCEDURE usp_BuscarHuespedes
			(
				@Nombre VARCHAR(100)
			)
			AS
			BEGIN
				BEGIN TRY

					SELECT *
					FROM tbl_Huespedes
					WHERE Nombre LIKE '%' + @Nombre + '%'
					ORDER BY CodigoHuesped ASC;

				END TRY
				
				BEGIN CATCH
					THROW;
				END CATCH
			END;

			-- Ejecutar Stored procedure

			EXEC usp_BuscarHuespedes @Nombre = 'El';

			-- Consultar tabla

			Select * From tbl_Huespedes order by CodigoHuesped asc;




-- =============================================
-- =============================================
--				Script FUNCIONES		      --	
-- =============================================
-- =============================================

	/*====================================================
	=            FUNCIONES ESCALARES                     =
	====================================================*/

			-- Ejemplo de uso
			SELECT dbo.fn_NombreEmpleado(1);
			GO

			-- 1. Obtener nombre de empleado
			CREATE FUNCTION dbo.fn_NombreEmpleado (@CodigoEmpleado INT)
			RETURNS VARCHAR(100)
			AS
			BEGIN
				DECLARE @Nombre VARCHAR(100);

				SELECT @Nombre = Nombre
				FROM tbl_Empleados
				WHERE CodigoEmpleado = @CodigoEmpleado;

				RETURN @Nombre;
			END;
			GO

			-- 2. Calcular edad de huésped
			CREATE FUNCTION dbo.fn_EdadHuesped (@CodigoHuesped INT)
			RETURNS INT
			AS
			BEGIN
				DECLARE @Edad INT;

				SELECT @Edad = DATEDIFF(YEAR, FechaNacimiento, GETDATE())
				FROM tbl_Huespedes
				WHERE CodigoHuesped = @CodigoHuesped;

				RETURN @Edad;
			END;
			GO

			-- 3. Total pagado por hospedaje
			CREATE FUNCTION dbo.fn_TotalPagado (@CodigoHospedaje INT)
			RETURNS DECIMAL(10,2)
			AS
			BEGIN
				DECLARE @Total DECIMAL(10,2);

				SELECT @Total = ISNULL(SUM(TotalPago), 0)
				FROM tbl_Pagos
				WHERE CodigoHospedaje = @CodigoHospedaje;

				RETURN @Total;
			END;
			GO

			-- 4. Cantidad de consumos
			CREATE FUNCTION dbo.fn_TotalConsumos (@CodigoHospedaje INT)
			RETURNS INT
			AS
			BEGIN
				DECLARE @Cantidad INT;

				SELECT @Cantidad = COUNT(*)
				FROM tbl_ConsumosEnc
				WHERE CodigoHospedaje = @CodigoHospedaje;

				RETURN @Cantidad;
			END;
			GO

			-- 5. Precio habitación
			CREATE FUNCTION dbo.fn_PrecioHabitacion (@CodigoHabitacion INT)
			RETURNS DECIMAL(10,2)
			AS
			BEGIN
				DECLARE @Precio DECIMAL(10,2);

				SELECT @Precio = Precio
				FROM tbl_Habitaciones
				WHERE CodigoHabitacion = @CodigoHabitacion;

				RETURN @Precio;
			END;
			GO


	/*====================================================
	=        FUNCIONES DE TABLA EN LÍNEA                =
	====================================================*/

			-- Ejemplo de uso
			SELECT * FROM dbo.fn_EmpleadosActivos();
			GO

			-- 1. Empleados activos
			CREATE FUNCTION dbo.fn_EmpleadosActivos()
			RETURNS TABLE
			AS
			RETURN (
				SELECT *
				FROM tbl_Empleados
				WHERE Estado = 1
			);
			GO

			-- 2. Habitaciones activas
			CREATE FUNCTION dbo.fn_HabitacionesActivas()
			RETURNS TABLE
			AS
			RETURN (
				SELECT *
				FROM tbl_Habitaciones
				WHERE Estado = 1
			);
			GO

			-- 3. Hospedajes por huésped
			CREATE FUNCTION dbo.fn_HospedajesPorHuesped (@CodigoHuesped INT)
			RETURNS TABLE
			AS
			RETURN (
				SELECT *
				FROM tbl_Hospedajes
				WHERE CodigoHuesped = @CodigoHuesped
			);
			GO

			-- 4. Consumos por hospedaje
			CREATE FUNCTION dbo.fn_ConsumosPorHospedaje (@CodigoHospedaje INT)
			RETURNS TABLE
			AS
			RETURN (
				SELECT *
				FROM tbl_ConsumosEnc
				WHERE CodigoHospedaje = @CodigoHospedaje
			);
			GO

			-- 5. Pagos realizados
			CREATE FUNCTION dbo.fn_PagosRealizados()
			RETURNS TABLE
			AS
			RETURN (
				SELECT *
				FROM tbl_Pagos
				WHERE Estado = 1
			);
			GO
		
	/*====================================================
	=      FUNCIONES MULTI-STATEMENT (TVF)              =
	====================================================*/

			-- Ejemplo de uso
			SELECT * FROM dbo.fn_DetalleHospedaje(1);
			GO

			-- 1. Detalle de hospedaje
			CREATE FUNCTION dbo.fn_DetalleHospedaje (@CodigoHospedaje INT)
			RETURNS @Resultado TABLE
			(
				Huesped        VARCHAR(100),
				Habitacion     VARCHAR(10),
				FechaIngreso   DATETIME,
				FechaSalida    DATETIME,
				Total          DECIMAL(10,2)
			)
			AS
			BEGIN
				INSERT INTO @Resultado
				SELECT 
					h.Nombre,
					ha.Numero,
					ho.FechaIngreso,
					ho.FechaSalida,
					ho.MontoTotal
				FROM tbl_Hospedajes ho
				INNER JOIN tbl_Huespedes h 
					ON ho.CodigoHuesped = h.CodigoHuesped
				INNER JOIN tbl_Habitaciones ha 
					ON ho.CodigoHabitacion = ha.CodigoHabitacion
				WHERE ho.CodigoHospedaje = @CodigoHospedaje;

				RETURN;
			END;
			GO

			-- 2. Resumen de pagos
			CREATE FUNCTION dbo.fn_ResumenPagos (@CodigoHospedaje INT)
			RETURNS @Tabla TABLE
			(
				TotalPagado   DECIMAL(10,2),
				CantidadPagos INT
			)
			AS
			BEGIN
				INSERT INTO @Tabla
				SELECT 
					SUM(TotalPago),
					COUNT(*)
				FROM tbl_Pagos
				WHERE CodigoHospedaje = @CodigoHospedaje;

				RETURN;
			END;
			GO

			-- 3. Detalle de consumos
			CREATE FUNCTION dbo.fn_DetalleConsumos (@CodigoConsumoEnc INT)
			RETURNS @Tabla TABLE
			(
				Servicio VARCHAR(100),
				Cantidad INT,
				Total    DECIMAL(10,2)
			)
			AS
			BEGIN
				INSERT INTO @Tabla
				SELECT 
					s.Nombre,
					d.Cantidad,
					d.MontoTotal
				FROM tbl_ConsumosDet d
				INNER JOIN tbl_Servicios s 
					ON d.CodigoServicio = s.CodigoServicio
				WHERE d.CodigoConsumoEnc = @CodigoConsumoEnc;

				RETURN;
			END;
			GO

			-- 4. Empleados por salario
			CREATE FUNCTION dbo.fn_EmpleadosPorSalario (@SalarioMin DECIMAL(10,2))
			RETURNS @Tabla TABLE
			(
				Nombre  VARCHAR(100),
				Salario DECIMAL(10,2)
			)
			AS
			BEGIN
				INSERT INTO @Tabla
				SELECT 
					Nombre,
					Salario
				FROM tbl_Empleados
				WHERE Salario >= @SalarioMin;

				RETURN;
			END;
			GO

			-- 5. Habitaciones por tipo
			CREATE FUNCTION dbo.fn_HabitacionesPorTipo (@Tipo VARCHAR(50))
			RETURNS @Tabla TABLE
			(
				Numero VARCHAR(10),
				Precio DECIMAL(10,2)
			)
			AS
			BEGIN
				INSERT INTO @Tabla
				SELECT 
					Numero,
					Precio
				FROM tbl_Habitaciones
				WHERE Tipo = @Tipo;

				RETURN;
			END;
			GO
			
	
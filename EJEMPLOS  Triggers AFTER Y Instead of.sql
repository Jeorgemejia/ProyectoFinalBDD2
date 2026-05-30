
	-- TRIGGERS DML AFTER
	---------------------------------------
	-- 1.	Calcular total de pago: Al insertar un pago, calcular automáticamente: TotalPago = Monto + Propina + Impuesto – Descuento
        create trigger trg_CalcularTotalPago
        on tbl_Pagos 
        after insert
        as        begin
            update p
            set TotalPago = Monto + Propina + Impuesto - Descuento
            from tbl_Pagos p
            inner join inserted i on p.CodigoPago = i.CodigoPago
        end;
		

		--Prueba trigger
        insert into tbl_Pagos (CodigoHospedaje, FechaPago, MetodoPago, ReferenciaPago, Monto, Propina, Impuesto, Descuento, Estado)
        values
        (9, GETDATE(), 'Efectivo', NULL, 650, 20, 30, 0, 1),
        (10, GETDATE(), 'Tarjeta', 12345, 1600, 50, 80, 20, 1);


		

        
        -- 2.	Actualizar última conexión: Cuando un usuario se actualice, registrar UltimoAcceso.
        create trigger trg_ActualizarUltimoAcceso
        on tbl_Usuarios
        after update
        as
        begin
            update u
            set UltimoAcceso = GETDATE()
            from tbl_Usuarios u
            inner join inserted i on u.CodigoUsuario = i.CodigoUsuario
        end;

        --prueba trigger
        update tbl_Usuarios
        set Usuario = 'cperez_actualizado'
        where CodigoUsuario = 6;
        select * from tbl_Usuarios
		GO
select * from tbl_planillasDet


		
		-- 3.	Marcar planilla como pagada: Si todos los detalles están pagados (Estado=1), actualizar encabezado a “Pagada”.
        create trigger trg_MarcarPlanillaPagada
        on tbl_PlanillasDet
        after update
        as
        begin
            declare @CodigoPlanillaEnc int
            select @CodigoPlanillaEnc = CodigoPlanillaEnc from inserted

            if not exists (select 1 from tbl_PlanillasDet where CodigoPlanillaEnc = @CodigoPlanillaEnc and Estado = 0)
            begin
                update tbl_PlanillasEnc
                set Estado = 'Pagada'
                where CodigoPlanillaEnc = @CodigoPlanillaEnc
            end
        end;
		
        
        --prueba trigger
        update tbl_PlanillasDet
        set Estado = 1
        where CodigoPlanillaEnc = 2;    
		
		






        -- 4.	Actualizar monto total en hospedaje: Cuando se inserte consumo, sumar al MontoConsumos del hospedaje.
		create trigger trg_ActualizarMontoConsumos
		on tbl_ConsumosDet
		after insert
		as
		begin
			update h
			set MontoConsumos = MontoConsumos + i.PrecioTotal,
				MontoTotal = MontoHabitacion + MontoAnticipo + MontoConsumos + i.PrecioTotal
			from tbl_Hospedajes h
			inner join tbl_ConsumosEnc ce on h.CodigoHospedaje = ce.CodigoHospedaje
			inner join inserted i on ce.CodigoConsumoEnc = i.CodigoConsumoEnc
		end;
	


		-- 5.	Validar límite de huéspedes (solo advertencia): Al insertar hospedaje, mostrar mensaje si supera capacidad habitación.
		 create trigger trg_ValidarLimiteHuespedes
		on tbl_Hospedajes
		after insert
		as
		begin
			declare @CodigoHabitacion int, @CantidadHuespedes int, @Capacidad int
			select @CodigoHabitacion = CodigoHabitacion from inserted

			select @CantidadHuespedes = count(*)
			from tbl_Hospedajes
			where CodigoHabitacion = @CodigoHabitacion

			select @Capacidad = CantidadHuesped
			from tbl_Habitaciones
			where CodigoHabitacion = @CodigoHabitacion

			if @CantidadHuespedes > @Capacidad
			begin
				raiserror('Advertencia: Se ha superado la capacidad de huéspedes para esta habitación.', 16, 1)
			end
		end;
		GO
		-- 6.	Actualizar precio total en consumo detalle: Actualizar PrecioTotal = Cantidad * PrecioUnitario.
		create trigger trg_ActualizarPrecioTotal
		on tbl_ConsumosDet
		after insert, update
		as
		begin
			update i
			set PrecioTotal = i.Cantidad * i.PrecioUnitario
			from tbl_ConsumosDet i
			inner join inserted new on i.CodigoConsumoDet = new.CodigoConsumoDet
		end;
	



	-- Prueba trigger
	update tbl_ConsumosDet
	set Cantidad = 3
	where CodigoConsumoDet = 1;
	



		-- 7.	Registrar creación automática: Al insertar empleados, llenar FechaCreacion.
		create trigger trg_RegistrarCreacionEmpleado
		on tbl_Empleados
		after insert
		as
		begin
			update e
			set FechaCreacion = getdate()
			from tbl_Empleados e
			inner join inserted i on e.CodigoEmpleado = i.CodigoEmpleado
		end;
	

	-- Prueba trigger
	insert into tbl_Empleados (Nombre, NumeroDpi, Genero, Cargo, Salario, FechaNacimiento, FechaContratacion, Estado, UsuarioCreacion)
	values ('Test Empleado', 3060678900606, 'M', 'Test', 4000, '1990-01-01', '2023-01-01', 1, 'admin');
	



		-- 8.	Desactivar habitación al eliminar hospedaje: Al eliminar hospedaje, activar habitación (Estado=1).
		create trigger trg_DesactivarHabitacionAlEliminarHospedaje
		on tbl_Hospedajes
		after delete
		as
		begin
			update h
			set Estado = 1
			from tbl_Habitaciones h
			inner join deleted d on h.CodigoHabitacion = d.CodigoHabitacion
		end;
	


	-- Prueba trigger
	delete from tbl_Hospedajes
	where CodigoHospedaje = 1;
	



		-- 9.	Incrementar puntuación huésped: Al insertar hospedaje, aumentar puntuación del huésped.
		create trigger trg_IncrementarPuntuacionHuesped
		on tbl_Hospedajes
		after insert
		as
		begin
			update h
			set Puntuacion = Puntuacion + 1
			from tbl_Huespedes h
			inner join inserted i on h.CodigoHuesped = i.CodigoHuesped
		end;
		


		-- 10.	Validar descuento excesivo (solo aviso): Si descuento > monto, mostrar advertencia.
		create trigger trg_ValidarDescuentoExcesivo

		on tbl_Pagos
		after insert, update
		as
		begin
			if exists (select 1 from inserted where Descuento > Monto)
			begin
				raiserror('Advertencia: El descuento no puede ser mayor que el monto del pago.', 16, 1)
			end
		end;
	


	-- Prueba trigger

	insert into tbl_Pagos (CodigoHospedaje, FechaPago, MetodoPago, ReferenciaPago, Monto, Propina, Impuesto, Descuento, Estado)
	values (9, GETDATE(), 'Efectivo', NULL, 650, 20, 30, 700, 1);
	



	---------------------------------------
	-- TRIGGERS DML INSTEAD OF
	---------------------------------------


		-- 11.	Evitar eliminar empleados activos
		create trigger trg_EvitarEliminarEmpleadosActivos
		on tbl_Empleados
		instead of delete
		as
		begin
			if exists (select 1 from deleted where Estado = 1)
			begin
				raiserror('No se pueden eliminar empleados activos. Cambie su estado a inactivo antes de eliminar.', 16, 1)
			end
			else
			begin
				delete from tbl_Empleados
				where CodigoEmpleado in (select CodigoEmpleado from deleted)
			end
		end;
	

		
		--prueba trigger
	delete from tbl_Empleados
	where CodigoEmpleado = 2; 
	
	select * from tbl_empleados
	


	
		-- 12.	Evitar correo duplicado, al agregar usuarios
		create trigger trg_EvitarCorreoDuplicado
		on tbl_Usuarios
		instead of insert
		as
		begin
			if exists (select 1 
			from inserted i 
			join tbl_Usuarios u on i.Correo = u.Correo)
			begin
				raiserror('No se pueden agregar usuarios con correo duplicado.', 16, 1)
			end
			else
			begin
				insert into tbl_Usuarios 
				(CodigoEmpleado, Correo, Usuario, Contrasenia, Rol, IntentosFallidos, Estado, UsuarioCreacion, FechaCreacion)
				select CodigoEmpleado, Correo, Usuario, Contrasenia, Rol, IntentosFallidos, Estado, UsuarioCreacion, FechaCreacion
				from inserted
			end
		end;
	

	-- Prueba trigger
	insert into tbl_Usuarios (CodigoEmpleado, Correo, Usuario, Contrasenia, Rol, IntentosFallidos, Estado, UsuarioCreacion)
	values (2, 'test@example.com', 'testuser', 'password', 'User', 0, 1, 'admin');
	




	-- 13.	Validar monto positivo en pagos, al insertar pagos nuevos
		create trigger trg_ValidarMontoPositivo
		on tbl_Pagos
		instead of insert
		as
		begin
			if exists (select 1 from inserted where Monto <= 0)
			begin
				raiserror('El monto del pago debe ser positivo.', 16, 1)
			end
			else
			begin
				insert into tbl_Pagos (CodigoHospedaje, FechaPago, MetodoPago, ReferenciaPago, Monto, Propina, Impuesto, Descuento, Estado)
				select CodigoHospedaje, FechaPago, MetodoPago, ReferenciaPago, Monto, Propina, Impuesto, Descuento, Estado
				from inserted
			end
		end;
	


	-- Prueba trigger
	insert into tbl_Pagos (CodigoHospedaje, FechaPago, MetodoPago, ReferenciaPago, Monto, Propina, Impuesto, Descuento, Estado)
	values (9, GETDATE(), 'Efectivo', NULL, -100, 20, 30, 0, 1);
	

		-- 14.	Evitar modificar salario a valor negativo
		create trigger trg_EvitarSalarioNegativo
		ON Tbl_empleados
		INSTEAD of update
		AS
		BEGIN
			IF EXISTS (SELECT 1 FROM inserted WHERE Salario < 0)
			BEGIN
				RAISERROR('El salario no puede ser negativo.', 16, 1)
			END
			ELSE
			BEGIN
				UPDATE e
				SET Salario = i.Salario,
					Nombre = i.Nombre,
					NumeroDpi = i.NumeroDpi,
					Genero = i.Genero,
					Cargo = i.Cargo,
					FechaNacimiento = i.FechaNacimiento,
					FechaContratacion = i.FechaContratacion,
					Estado = i.Estado,
					UsuarioModificacion = i.UsuarioModificacion,
					FechaModificacion = GETDATE()
				FROM tbl_Empleados e
				INNER JOIN inserted i ON e.CodigoEmpleado = i.CodigoEmpleado
			END
		END;
	


	-- Prueba trigger
	update tbl_Empleados
	set Salario = -5000
	where CodigoEmpleado = 3;
	GO

		-- 15.	Validar tipo de moneda, solo se acepta USD y QTZ, al agergar encabezado planilla
		create trigger trg_ValidarTipoMoneda
		on tbl_PlanillasEnc
		instead of insert
		as
		begin
			if exists (select 1 from inserted where TipoMoneda not in ('USD', 'GTQ'))
			begin
				raiserror('El tipo de moneda debe ser USD o GTQ.', 16, 1)
			end
			else
			begin
				insert into tbl_PlanillasEnc (FechaPlanilla, TipoPlanilla, Banco, DocReferencia, TipoMoneda, MontoTotal, Estado, UsuarioCreacion, FechaCreacion)
				select FechaPlanilla, TipoPlanilla, Banco, DocReferencia, TipoMoneda, MontoTotal, Estado, UsuarioCreacion, FechaCreacion
				from inserted
			end
		end;
		


	-- Prueba trigger
	insert into tbl_PlanillasEnc (FechaPlanilla, TipoPlanilla, Banco, DocReferencia, TipoMoneda, MontoTotal, Estado, UsuarioCreacion)
	values (GETDATE(), 'Mensual', 'BI', 1006, 'EUR', 20000, 'Creada', 'admin');
	

		-- 16.	Evitar eliminación de habitación ocupada
		create trigger trg_EvitarEliminarHabitacionOcupada
		on tbl_Habitaciones
		instead of delete
		as
		begin	
			if exists (select 1 from deleted d 
			join tbl_Hospedajes h on d.CodigoHabitacion = h.CodigoHabitacion
			where h.Estado = 1)
			begin
				raiserror('No se puede eliminar una habitación que está actualmente ocupada.', 16, 1)
			end
			else
			begin
				delete from tbl_Habitaciones
				where CodigoHabitacion in (select CodigoHabitacion from deleted)
			end
		end;
	

	-- Prueba trigger
	delete from tbl_Habitaciones
	where CodigoHabitacion = 2;
	

		-- 17.	Validar turno, solo se permiten M, T, N, al agregar servicios a la habitacion
		create trigger trg_ValidarTurnoServicio
		on tbl_ServiciosHabitacion
		instead of insert
		as
		begin
			if exists (select 1 from inserted where Turno not in ('M', 'T', 'N'))
			begin
				raiserror('El turno debe ser M (Mañana), T (Tarde) o N (Noche).', 16, 1)
			end
			else
			begin
				insert into tbl_ServiciosHabitacion (CodigoEmpleado, CodigoHabitacion, TipoServicio, Turno, FechaInicio, FechaFin, Observaciones, Estado, UsuarioCreacion, FechaCreacion)
				select CodigoEmpleado, CodigoHabitacion, TipoServicio, Turno, FechaInicio, FechaFin, Observaciones, Estado, UsuarioCreacion, FechaCreacion
				from inserted
			end
		end;
	

	-- Prueba trigger
	insert into tbl_ServiciosHabitacion (CodigoEmpleado, CodigoHabitacion, TipoServicio,
Turno, FechaInicio, FechaFin, Estado, UsuarioCreacion)
values (2, 2, 'Limpieza', 'X', GETDATE(), GETDATE(), 1, 'admin');
	

		-- 18.	Validar precio servicio, no puede ser negativo al insertarlo
		create trigger trg_ValidarPrecioServicio
		on tbl_Servicios
		instead of insert
		as
		begin
			if exists (select 1 from inserted where PrecioUnitario < 0)
			begin
				raiserror('El precio del servicio no puede ser negativo.', 16, 1)
			end
			else
			begin
				insert into tbl_Servicios (Nombre, Tipo, Categoria, UnidadMedida, PrecioUnitario, TiempoPreparacion, Estado, UsuarioCreacion, FechaCreacion)
				select Nombre, Tipo, Categoria, UnidadMedida, PrecioUnitario, TiempoPreparacion, Estado, UsuarioCreacion, FechaCreacion
				from inserted
			end
		end;
	


	-- Prueba trigger

	insert into tbl_Servicios (Nombre, Tipo, Categoria, UnidadMedida, PrecioUnitario, TiempoPreparacion, Estado, UsuarioCreacion)
	values ('Servicio Test', 'Test', 'Test', 'Unidad', -50, 10, 1, 'admin');
	

		-- 19.	Validar identificación única huésped, no se permite identificacion duplicada al agregar huesped


		create trigger trg_ValidarIdentificacionUnicaHuesped
		on tbl_Huespedes
		instead of insert
		as
		begin
			if exists (select 1 from inserted i 
			join tbl_Huespedes h on i.NumeroIdentificacion = h.NumeroIdentificacion
			where i.TipoIdentificacion = h.TipoIdentificacion)
			begin
				raiserror('No se pueden agregar huéspedes con el mismo tipo y número de identificación.', 16, 1)
			end
			else
			begin
				insert into tbl_Huespedes (Nombre, TipoIdentificacion, NumeroIdentificacion, FechaNacimiento, Genero, Telefono, Direccion, Puntuacion, Estado, UsuarioCreacion, FechaCreacion)
				select Nombre, TipoIdentificacion, NumeroIdentificacion, FechaNacimiento, Genero, Telefono, Direccion, Puntuacion, Estado, UsuarioCreacion, FechaCreacion
				from inserted
			end
		end;
	


	-- Prueba trigger
	insert into tbl_Huespedes (Nombre, TipoIdentificacion, NumeroIdentificacion, FechaNacimiento, Genero, Telefono, Direccion, Puntuacion, Estado, UsuarioCreacion)
	values ('Test Huesped', 'DPI', 4010123450101, '1990-01-01', 'M', 55500000, 'Test Address', 5, 1, 'admin');
	

		-- 20.	Evitar eliminar consumos activos
		create trigger trg_EvitarEliminarConsumosActivos
		on tbl_ConsumosEnc
		instead of delete
		as
		begin
			if exists (select 1 from deleted where Estado = 1)
			begin
				raiserror('No se pueden eliminar consumos activos. Cambie su estado a inactivo antes de eliminar.', 16, 1)
			end
			else
			begin
				delete from tbl_ConsumosEnc
				where CodigoConsumoEnc in (select CodigoConsumoEnc from deleted)
			end
		end;
	


-- Prueba trigger
	delete from tbl_ConsumosEnc
	where CodigoConsumoEnc = 5;
	



using BancaCore.Models;
using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;

// =============================================
// ClienteRepository
// =============================================
namespace BancaCore.Data.Repositories
{
    public class MonedaRepository
    {
        private readonly DbContext _db;
        public MonedaRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<Moneda>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<Moneda>("SELECT * FROM tbl_moneda WHERE Estado=1 ORDER BY Nombre");
        }

        public async Task<Moneda?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<Moneda>("SELECT * FROM tbl_moneda WHERE CodigoMoneda=@id", new { id });
        }

        public async Task<(bool Resultado, string Mensaje)> CreateAsync(Moneda m, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", m.Nombre);
            p.Add("Simbolo", m.Simbolo);
            p.Add("TipoCambio", m.TipoCambio);
            p.Add("UsuarioCreacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_AgregarMoneda", p, commandType: CommandType.StoredProcedure);

            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<IEnumerable<Moneda>> SearchAsync(string nombre)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", nombre);
            return await conn.QueryAsync<Moneda>("usp_BuscarMoneda", p, commandType: CommandType.StoredProcedure);
        }

        public async Task<(bool Resultado, string Mensaje)> UpdateAsync(Moneda m, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoMoneda", m.CodigoMoneda);
            p.Add("Nombre", m.Nombre);
            p.Add("Simbolo", m.Simbolo);
            p.Add("TipoCambio", m.TipoCambio);
            p.Add("Estado", m.Estado);
            p.Add("UsuarioModificacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EditarMoneda", p, commandType: CommandType.StoredProcedure);

            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoMoneda", id);
            p.Add("UsuarioEliminacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EliminarMoneda", p, commandType: CommandType.StoredProcedure);

            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }
    }

    public class TipoCuentaRepository
    {
        private readonly DbContext _db;
        public TipoCuentaRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<TipoCuenta>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoCuenta>("SELECT * FROM tbl_TipoCuenta WHERE Estado=1 ORDER BY Nombre");
        }

        public async Task<IEnumerable<TipoCuenta>> SearchAsync(string nombre)
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoCuenta>("SELECT * FROM tbl_TipoCuenta WHERE Nombre LIKE '%' + @nombre + '%' AND Estado=1 ORDER BY Nombre", new { nombre });
        }

        public async Task<TipoCuenta?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<TipoCuenta>("SELECT * FROM tbl_TipoCuenta WHERE CodigoTipoCuenta=@id", new { id });
        }

        public async Task<int> CreateAsync(TipoCuenta t, string usuario)
        {
            using var conn = _db.Open();
            return await conn.ExecuteScalarAsync<int>(@"
                INSERT INTO tbl_TipoCuenta (Nombre,SaldoMinimo,TasaInteres,Estado,UsuarioCreacion,FechaCreacion)
                VALUES (@Nombre,@SaldoMinimo,@TasaInteres,1,@usuario,GETDATE());
                SELECT SCOPE_IDENTITY();",
                new { t.Nombre, t.SaldoMinimo, t.TasaInteres, usuario });
        }

        public async Task<bool> UpdateAsync(TipoCuenta t, string usuario)
        {
            using var conn = _db.Open();
            var rows = await conn.ExecuteAsync(@"
                UPDATE tbl_TipoCuenta SET Nombre=@Nombre, SaldoMinimo=@SaldoMinimo, TasaInteres=@TasaInteres,
                  UsuarioModificacion=@usuario, FechaModificacion=GETDATE()
                WHERE CodigoTipoCuenta=@CodigoTipoCuenta",
                new { t.Nombre, t.SaldoMinimo, t.TasaInteres, usuario, t.CodigoTipoCuenta });
            return rows > 0;
        }

        public async Task<bool> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var rows = await conn.ExecuteAsync(@"
                UPDATE tbl_TipoCuenta SET Estado=0, UsuarioEliminacion=@usuario, FechaEliminacion=GETDATE()
                WHERE CodigoTipoCuenta=@id", new { id, usuario });
            return rows > 0;
        }
    }

    public class TipoTransaccionRepository
    {
        private readonly DbContext _db;
        public TipoTransaccionRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<TipoTransaccion>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoTransaccion>("SELECT * FROM tbl_TipoTransaccion WHERE Estado=1 ORDER BY Nombre");
        }

        public async Task<TipoTransaccion?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<TipoTransaccion>("SELECT * FROM tbl_TipoTransaccion WHERE CodigoTipoTransaccion=@id", new { id });
        }

        public async Task<int> CreateAsync(TipoTransaccion t, string usuario)
        {
            using var conn = _db.Open();
            return await conn.ExecuteScalarAsync<int>(@"
                INSERT INTO tbl_TipoTransaccion (Nombre,Estado,UsuarioCreacion,FechaCreacion)
                VALUES (@Nombre,1,@usuario,GETDATE()); SELECT SCOPE_IDENTITY();",
                new { t.Nombre, usuario });
        }

        public async Task<IEnumerable<TipoTransaccion>> SearchAsync(string nombre)
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoTransaccion>("SELECT * FROM tbl_TipoTransaccion WHERE Nombre LIKE '%' + @nombre + '%' AND Estado=1 ORDER BY Nombre", new { nombre });
        }

        public async Task<bool> UpdateAsync(TipoTransaccion t, string usuario)
        {
            using var conn = _db.Open();
            var rows = await conn.ExecuteAsync(@"
                UPDATE tbl_TipoTransaccion SET Nombre=@Nombre, UsuarioModificacion=@usuario, FechaModificacion=GETDATE()
                WHERE CodigoTipoTransaccion=@CodigoTipoTransaccion",
                new { t.Nombre, usuario, t.CodigoTipoTransaccion });
            return rows > 0;
        }

        public async Task<bool> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var rows = await conn.ExecuteAsync(@"
                UPDATE tbl_TipoTransaccion SET Estado=0, UsuarioEliminacion=@usuario, FechaEliminacion=GETDATE()
                WHERE CodigoTipoTransaccion=@id", new { id, usuario });
            return rows > 0;
        }
    }

    public class TipoPrestamoRepository
    {
        private readonly DbContext _db;
        public TipoPrestamoRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<TipoPrestamo>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoPrestamo>("usp_ConsultarTipoPrestamo", commandType: CommandType.StoredProcedure);
        }

        public async Task<TipoPrestamo?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<TipoPrestamo>("SELECT * FROM tbl_TipoPrestamo WHERE CodigoTipoPrestamo=@id", new { id });
        }

        public async Task<(bool Resultado, string Mensaje)> CreateAsync(TipoPrestamo t, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", t.Nombre);
            p.Add("TasaInteres", t.TasaInteres);
            p.Add("PlazoMaximoMeses", t.PlazoMaximoMeses);
            p.Add("UsuarioCreacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_AgregarTipoPrestamo", p, commandType: CommandType.StoredProcedure);
            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> UpdateAsync(TipoPrestamo t, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoTipoPrestamo", t.CodigoTipoPrestamo);
            p.Add("Nombre", t.Nombre);
            p.Add("TasaInteres", t.TasaInteres);
            p.Add("PlazoMaximoMeses", t.PlazoMaximoMeses);
            p.Add("Estado", t.Estado);
            p.Add("UsuarioModificacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EditarTipoPrestamo", p, commandType: CommandType.StoredProcedure);
            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoTipoPrestamo", id);
            p.Add("UsuarioEliminacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EliminarTipoPrestamo", p, commandType: CommandType.StoredProcedure);
            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<IEnumerable<TipoPrestamo>> SearchAsync(string nombre)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", nombre);
            return await conn.QueryAsync<TipoPrestamo>("usp_BuscarTipoPrestamo", p, commandType: CommandType.StoredProcedure);
        }
    }

    public class TipoTarjetaRepository
    {
        private readonly DbContext _db;
        public TipoTarjetaRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<TipoTarjeta>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoTarjeta>("SELECT * FROM tbl_TipoTarjeta WHERE Estado=1 ORDER BY Nombre");
        }

        public async Task<TipoTarjeta?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<TipoTarjeta>("SELECT * FROM tbl_TipoTarjeta WHERE CodigoTipoTarjeta=@id", new { id });
        }

        public async Task<(bool Resultado, string Mensaje)> CreateAsync(TipoTarjeta t, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", t.Nombre);
            p.Add("UsuarioCreacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_AgregarTipoTarjeta", p, commandType: CommandType.StoredProcedure);
            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> UpdateAsync(TipoTarjeta t, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoTipoTarjeta", t.CodigoTipoTarjeta);
            p.Add("Nombre", t.Nombre);
            p.Add("Estado", t.Estado);
            p.Add("UsuarioModificacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EditarTipoTarjeta", p, commandType: CommandType.StoredProcedure);
            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoTipoTarjeta", id);
            p.Add("UsuarioEliminacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EliminarTipoTarjeta", p, commandType: CommandType.StoredProcedure);
            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<IEnumerable<TipoTarjeta>> SearchAsync(string nombre)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", nombre);
            return await conn.QueryAsync<TipoTarjeta>("usp_BuscarTipoTarjeta", p, commandType: CommandType.StoredProcedure);
        }
    }

    public class TarjetaRepository
    {
        private readonly DbContext _db;
        public TarjetaRepository(DbContext db) { _db = db; }

        private const string SelectBase = @"SELECT t.*, c.NumeroCuenta, tt.Nombre AS NombreTipoTarjeta, cl.Nombres+' '+cl.Apellidos AS NombreCliente
            FROM tbl_Tarjeta t
            INNER JOIN tbl_CuentaBancaria c ON t.CodigoCuenta = c.CodigoCuenta
            INNER JOIN tbl_TipoTarjeta tt ON t.CodigoTipoTarjeta = tt.CodigoTipoTarjeta
            INNER JOIN tbl_Cliente cl ON c.CodigoCliente = cl.IdCliente";

        public async Task<IEnumerable<Tarjeta>> GetAllAsync()
        {
            using var conn = _db.Open();
            // Use stored procedure usp_ConsultarTarjeta
            return await conn.QueryAsync<Tarjeta>("usp_ConsultarTarjeta", commandType: CommandType.StoredProcedure);
        }

        public async Task<Tarjeta?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<Tarjeta>(SelectBase + " WHERE t.CodigoTarjeta=@id", new { id });
        }

        public async Task<(bool Resultado, string Mensaje)> CreateAsync(Tarjeta t, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("NumeroTarjeta", t.NumeroTarjeta);
            p.Add("CodigoCuenta", t.CodigoCuenta);
            p.Add("CodigoTipoTarjeta", t.CodigoTipoTarjeta);
            p.Add("LimiteCredito", t.LimiteCredito);
            p.Add("SaldoUtilizado", t.SaldoUtilizado);
            p.Add("FechaEmision", t.FechaEmision);
            p.Add("FechaVencimiento", t.FechaVencimiento);
            p.Add("UsuarioCreacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_AgregarTarjeta", p, commandType: CommandType.StoredProcedure);
            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> UpdateAsync(Tarjeta t, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoTarjeta", t.CodigoTarjeta);
            p.Add("NumeroTarjeta", t.NumeroTarjeta);
            p.Add("CodigoCuenta", t.CodigoCuenta);
            p.Add("CodigoTipoTarjeta", t.CodigoTipoTarjeta);
            p.Add("LimiteCredito", t.LimiteCredito);
            p.Add("SaldoUtilizado", t.SaldoUtilizado);
            p.Add("FechaEmision", t.FechaEmision);
            p.Add("FechaVencimiento", t.FechaVencimiento);
            p.Add("Estado", t.Estado);
            p.Add("UsuarioModificacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EditarTarjeta", p, commandType: CommandType.StoredProcedure);
            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoTarjeta", id);
            p.Add("UsuarioEliminacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EliminarTarjeta", p, commandType: CommandType.StoredProcedure);
            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<IEnumerable<Tarjeta>> SearchAsync(string numero)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("NumeroTarjeta", numero);
            return await conn.QueryAsync<Tarjeta>("usp_BuscarTarjeta", p, commandType: CommandType.StoredProcedure);
        }
    }

    public class PagoPrestamoRepository
    {
        private readonly DbContext _db;
        public PagoPrestamoRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<PagoPrestamo>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<PagoPrestamo>("SELECT * FROM tbl_PagoPrestamo WHERE Estado=1 ORDER BY FechaPago DESC");
        }

        public async Task<int> CreateAsync(PagoPrestamo p, string usuario)
        {
            using var conn = _db.Open();
            return await conn.ExecuteScalarAsync<int>(@"
                INSERT INTO tbl_PagoPrestamo (CodigoPrestamo,CodigoTransaccion,MontoCapital,MontoInteres,FechaPago,Estado,UsuarioCreacion,FechaCreacion)
                VALUES (@CodigoPrestamo,@CodigoTransaccion,@MontoCapital,@MontoInteres,@FechaPago,1,@usuario,GETDATE()); SELECT SCOPE_IDENTITY();",
                new { p.CodigoPrestamo, p.CodigoTransaccion, p.MontoCapital, p.MontoInteres, p.FechaPago, usuario });
        }
    }

    public class UsuarioSistemaRepository
    {
        private readonly DbContext _db;
        public UsuarioSistemaRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<UsuarioSistema>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<UsuarioSistema>(@"SELECT u.*, s.Nombre AS NombreSucursal FROM tbl_UsuarioSistema u INNER JOIN tbl_Sucursal s ON u.CodigoSucursal = s.CodigoSucursal WHERE u.Estado=1 ORDER BY u.Usuario");
        }

        public async Task<UsuarioSistema?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<UsuarioSistema>("SELECT * FROM tbl_UsuarioSistema WHERE CodigoUsuario=@id", new { id });
        }

        public async Task<int> CreateAsync(UsuarioSistema u, string usuario)
        {
            using var conn = _db.Open();
            return await conn.ExecuteScalarAsync<int>(@"
                INSERT INTO tbl_UsuarioSistema (CodigoSucursal,Usuario,Contraseña,CorreoRecuperacion,Rol,Estado,UsuarioCreacion,FechaCreacion)
                VALUES (@CodigoSucursal,@Usuario,@Contraseña,@CorreoRecuperacion,@Rol,1,@usuario,GETDATE()); SELECT SCOPE_IDENTITY();",
                new { u.CodigoSucursal, u.Usuario, u.Contraseña, u.CorreoRecuperacion, u.Rol, usuario });
        }

        public async Task<bool> UpdateAsync(UsuarioSistema u, string usuario)
        {
            using var conn = _db.Open();
            var rows = await conn.ExecuteAsync(@"
                UPDATE tbl_UsuarioSistema SET CodigoSucursal=@CodigoSucursal, Usuario=@Usuario, Contraseña=@Contraseña, CorreoRecuperacion=@CorreoRecuperacion, Rol=@Rol,
                  UsuarioModificacion=@usuario, FechaModificacion=GETDATE()
                WHERE CodigoUsuario=@CodigoUsuario",
                new { u.CodigoSucursal, u.Usuario, u.Contraseña, u.CorreoRecuperacion, u.Rol, usuario, u.CodigoUsuario });
            return rows > 0;
        }

        public async Task<bool> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var rows = await conn.ExecuteAsync(@"
                UPDATE tbl_UsuarioSistema SET Estado=0, UsuarioEliminacion=@usuario, FechaEliminacion=GETDATE()
                WHERE CodigoUsuario=@id", new { id, usuario });
            return rows > 0;
        }
    }

    public class AuditoriaRepository
    {
        private readonly DbContext _db;
        public AuditoriaRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<Auditoria>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<Auditoria>("SELECT * FROM tbl_Auditoria ORDER BY FechaHora DESC");
        }
    }
    public class ClienteRepository
    {
        private readonly DbContext _db;
        public ClienteRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<Cliente>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<Cliente>("usp_ConsultarCliente", commandType: CommandType.StoredProcedure);
        }

        public async Task<Cliente?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<Cliente>("SELECT * FROM tbl_Cliente WHERE IdCliente = @id", new { id });
        }

        public async Task<(bool Resultado, string Mensaje)> CreateAsync(Cliente c, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("TipoCliente", c.TipoCliente);
            p.Add("Nombres", c.Nombres);
            p.Add("Apellidos", c.Apellidos);
            p.Add("DPI", c.DPI);
            p.Add("NIT", c.NIT);
            p.Add("FechaNacimiento", c.FechaNacimiento);
            p.Add("Telefono", c.Telefono);
            p.Add("Email", c.Email);
            p.Add("Direccion", c.Direccion);
            p.Add("UsuarioCreacion", usuario);
            p.Add("Resultado", dbType: System.Data.DbType.Boolean, direction: System.Data.ParameterDirection.Output);
            p.Add("Mensaje", dbType: System.Data.DbType.String, size: 500, direction: System.Data.ParameterDirection.Output);

            await conn.ExecuteAsync("usp_AgregarCliente", p, commandType: CommandType.StoredProcedure);

            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> UpdateAsync(Cliente c, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("IdCliente", c.IdCliente);
            p.Add("TipoCliente", c.TipoCliente);
            p.Add("Nombres", c.Nombres);
            p.Add("Apellidos", c.Apellidos);
            p.Add("DPI", c.DPI);
            p.Add("NIT", c.NIT);
            p.Add("FechaNacimiento", c.FechaNacimiento);
            p.Add("Telefono", c.Telefono);
            p.Add("Email", c.Email);
            p.Add("Direccion", c.Direccion);
            p.Add("Estado", c.Estado);
            p.Add("UsuarioModificacion", usuario);
            p.Add("Resultado", dbType: System.Data.DbType.Boolean, direction: System.Data.ParameterDirection.Output);
            p.Add("Mensaje", dbType: System.Data.DbType.String, size: 500, direction: System.Data.ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EditarCliente", p, commandType: CommandType.StoredProcedure);

            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("IdCliente", id);
            p.Add("UsuarioEliminacion", usuario);
            p.Add("Resultado", dbType: System.Data.DbType.Boolean, direction: System.Data.ParameterDirection.Output);
            p.Add("Mensaje", dbType: System.Data.DbType.String, size: 500, direction: System.Data.ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EliminarCliente", p, commandType: CommandType.StoredProcedure);

            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<IEnumerable<Cliente>> SearchAsync(string nombres)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombres", nombres);
            return await conn.QueryAsync<Cliente>("usp_BuscarCliente", p, commandType: CommandType.StoredProcedure);
        }
    }
}

// =============================================
// SucursalRepository
// =============================================
namespace BancaCore.Data.Repositories
{
    public class SucursalRepository
    {
        private readonly DbContext _db;
        public SucursalRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<Sucursal>> GetAllAsync()
        {
            using var conn = _db.Open();
            // Use stored procedure usp_ConsultarSucursal to fetch branches
            return await conn.QueryAsync<Sucursal>(
                "usp_ConsultarSucursal", commandType: System.Data.CommandType.StoredProcedure);
        }

        public async Task<IEnumerable<Sucursal>> SearchAsync(string nombre)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", nombre);
            return await conn.QueryAsync<Sucursal>("usp_BuscarSucursal", p, commandType: System.Data.CommandType.StoredProcedure);
        }

        public async Task<Sucursal?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<Sucursal>(
                "SELECT * FROM tbl_Sucursal WHERE CodigoSucursal=@id", new { id });
        }

        public async Task<(bool Resultado, string Mensaje)> CreateAsync(Sucursal s, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", s.Nombre);
            p.Add("Direccion", s.Direccion);
            p.Add("Telefono", s.Telefono);
            p.Add("UsuarioCreacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_AgregarSucursal", p, commandType: CommandType.StoredProcedure);

            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? "");
        }

        public async Task<(bool Resultado, string Mensaje)> UpdateAsync(Sucursal s, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoSucursal", s.CodigoSucursal);
            p.Add("Nombre", s.Nombre);
            p.Add("Direccion", s.Direccion);
            p.Add("Telefono", s.Telefono);
            p.Add("Estado", s.Estado);
            p.Add("UsuarioModificacion", usuario);
            p.Add("Resultado", dbType: System.Data.DbType.Boolean, direction: System.Data.ParameterDirection.Output);
            p.Add("Mensaje", dbType: System.Data.DbType.String, size: 500, direction: System.Data.ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EditarSucursal", p, commandType: System.Data.CommandType.StoredProcedure);

            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoSucursal", id);
            p.Add("UsuarioEliminacion", usuario);
            p.Add("Resultado", dbType: System.Data.DbType.Boolean, direction: System.Data.ParameterDirection.Output);
            p.Add("Mensaje", dbType: System.Data.DbType.String, size: 500, direction: System.Data.ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EliminarSucursal", p, commandType: System.Data.CommandType.StoredProcedure);

            var resultado = p.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }
    }
}

// =============================================
// CatalogosRepository
// =============================================
namespace BancaCore.Data.Repositories
{
    public class CatalogosRepository
    {
        private readonly DbContext _db;
        public CatalogosRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<Moneda>> GetMonedasAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<Moneda>("SELECT * FROM tbl_moneda WHERE Estado=1");
        }

        public async Task<IEnumerable<TipoCuenta>> GetTiposCuentaAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoCuenta>("SELECT * FROM tbl_TipoCuenta WHERE Estado=1");
        }

        public async Task<IEnumerable<TipoTarjeta>> GetTiposTarjetaAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoTarjeta>("SELECT * FROM tbl_TipoTarjeta WHERE Estado=1");
        }

        public async Task<IEnumerable<TipoPrestamo>> GetTiposPrestamoAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoPrestamo>("SELECT * FROM tbl_TipoPrestamo WHERE Estado=1");
        }

        public async Task<IEnumerable<TipoTransaccion>> GetTiposTransaccionAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoTransaccion>("SELECT * FROM tbl_TipoTransaccion WHERE Estado=1");
        }
    }
}

// =============================================
// CuentaRepository
// =============================================
namespace BancaCore.Data.Repositories
{
    public class CuentaRepository
    {
        private readonly DbContext _db;
        public CuentaRepository(DbContext db) { _db = db; }

        private const string SelectBase = @"
            SELECT c.*, cl.Nombres+' '+cl.Apellidos AS NombreCliente,
                   s.Nombre AS NombreSucursal, tc.Nombre AS NombreTipoCuenta,
                   m.Simbolo AS SimboloMoneda
            FROM tbl_CuentaBancaria c
            INNER JOIN tbl_Cliente    cl ON c.CodigoCliente    = cl.IdCliente
            INNER JOIN tbl_Sucursal   s  ON c.CodigoSucursal   = s.CodigoSucursal
            INNER JOIN tbl_TipoCuenta tc ON c.CodigoTipoCuenta = tc.CodigoTipoCuenta
            INNER JOIN tbl_moneda     m  ON c.CodigoMoneda     = m.CodigoMoneda";

        public async Task<IEnumerable<CuentaBancaria>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<CuentaBancaria>(
                SelectBase + " WHERE c.Estado=1 ORDER BY c.FechaApertura DESC");
        }

        public async Task<CuentaBancaria?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<CuentaBancaria>(
                SelectBase + " WHERE c.CodigoCuenta=@id", new { id });
        }

        public async Task<IEnumerable<CuentaBancaria>> GetByClienteAsync(int clienteId)
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<CuentaBancaria>(
                SelectBase + " WHERE c.CodigoCliente=@clienteId AND c.Estado=1", new { clienteId });
        }

        public async Task<int> CreateAsync(CuentaBancaria c, string usuario)
        {
            using var conn = _db.Open();
            var seq = await conn.ExecuteScalarAsync<int>(
                "SELECT ISNULL(MAX(CodigoCuenta),0)+1 FROM tbl_CuentaBancaria");
            c.NumeroCuenta = $"{c.CodigoSucursal:D3}-{c.CodigoTipoCuenta:D2}-{seq:D8}";

            return await conn.ExecuteScalarAsync<int>(@"
                INSERT INTO tbl_CuentaBancaria
                  (NumeroCuenta,CodigoCliente,CodigoSucursal,CodigoTipoCuenta,CodigoMoneda,
                   SaldoActual,FechaApertura,Estado,UsuarioCreacion,FechaCreacion)
                VALUES
                  (@NumeroCuenta,@CodigoCliente,@CodigoSucursal,@CodigoTipoCuenta,@CodigoMoneda,
                   @SaldoActual,@FechaApertura,1,@usuario,GETDATE());
                SELECT SCOPE_IDENTITY();",
                new { c.NumeroCuenta, c.CodigoCliente, c.CodigoSucursal, c.CodigoTipoCuenta,
                      c.CodigoMoneda, c.SaldoActual, c.FechaApertura, usuario });
        }

        public async Task<bool> UpdateAsync(CuentaBancaria c, string usuario)
        {
            using var conn = _db.Open();
            var rows = await conn.ExecuteAsync(@"
                UPDATE tbl_CuentaBancaria SET
                  CodigoCliente=@CodigoCliente, CodigoSucursal=@CodigoSucursal,
                  CodigoTipoCuenta=@CodigoTipoCuenta, CodigoMoneda=@CodigoMoneda,
                  UsuarioModificacion=@usuario, FechaModificacion=GETDATE()
                WHERE CodigoCuenta=@CodigoCuenta",
                new { c.CodigoCliente, c.CodigoSucursal, c.CodigoTipoCuenta, c.CodigoMoneda, usuario, c.CodigoCuenta });
            return rows > 0;
        }

        public async Task<bool> CerrarAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var rows = await conn.ExecuteAsync(@"
                UPDATE tbl_CuentaBancaria SET Estado=0,
                  UsuarioEliminacion=@usuario, FechaEliminacion=GETDATE()
                WHERE CodigoCuenta=@id", new { id, usuario });
            return rows > 0;
        }
    }
}

// =============================================
// TransaccionRepository
// =============================================
namespace BancaCore.Data.Repositories
{
    public class TransaccionRepository
    {
        private readonly DbContext _db;
        public TransaccionRepository(DbContext db) { _db = db; }

        private const string SelectBase = @"
            SELECT t.*,
                   co.NumeroCuenta AS NumeroCuentaOrigen,
                   cd.NumeroCuenta AS NumeroCuentaDestino,
                   tt.Nombre       AS NombreTipoTransaccion,
                   m.Simbolo       AS SimboloMoneda,
                   cl.Nombres+' '+cl.Apellidos AS NombreCliente
            FROM tbl_Transaccion t
            INNER JOIN tbl_TipoTransaccion tt ON t.CodigoTipoTransaccion = tt.CodigoTipoTransaccion
            INNER JOIN tbl_moneda          m  ON t.CodigoMoneda          = m.CodigoMoneda
            LEFT  JOIN tbl_CuentaBancaria  co ON t.CodigoCuentaOrigen    = co.CodigoCuenta
            LEFT  JOIN tbl_CuentaBancaria  cd ON t.CodigoCuentaDestino   = cd.CodigoCuenta
            LEFT  JOIN tbl_Cliente         cl ON co.CodigoCliente        = cl.IdCliente";

        public async Task<IEnumerable<Transaccion>> GetAllAsync(int top = 200)
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<Transaccion>(
                SelectBase + $" ORDER BY t.FechaHora DESC OFFSET 0 ROWS FETCH NEXT {top} ROWS ONLY");
        }

        public async Task<IEnumerable<Transaccion>> GetByCuentaAsync(int cuentaId)
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<Transaccion>(
                SelectBase + @" WHERE t.CodigoCuentaOrigen=@cuentaId OR t.CodigoCuentaDestino=@cuentaId
                ORDER BY t.FechaHora DESC", new { cuentaId });
        }

        public async Task DepositarAsync(int cuentaId, decimal monto, int moneda, string descripcion, string usuario)
        {
            using var conn = _db.Open();
            await conn.OpenAsync();
            using var tx = conn.BeginTransaction();
            try
            {
                var tipoCambio = await conn.ExecuteScalarAsync<decimal>(
                    "SELECT TipoCambio FROM tbl_moneda WHERE CodigoMoneda=@moneda",
                    new { moneda }, tx);

                await conn.ExecuteAsync(@"
                    UPDATE tbl_CuentaBancaria SET SaldoActual=SaldoActual+@monto,
                      UsuarioModificacion=@usuario, FechaModificacion=GETDATE()
                    WHERE CodigoCuenta=@cuentaId", new { monto, usuario, cuentaId }, tx);

                await conn.ExecuteAsync(@"
                    INSERT INTO tbl_Transaccion
                      (CodigoCuentaOrigen,CodigoTipoTransaccion,CodigoMoneda,Monto,
                       TipoCambioAplicado,FechaHora,Descripcion,Estado,UsuarioCreacion,FechaCreacion)
                    VALUES (@cuentaId,1,@moneda,@monto,@tipoCambio,GETDATE(),@descripcion,1,@usuario,GETDATE())",
                    new { cuentaId, moneda, monto, tipoCambio, descripcion, usuario }, tx);

                tx.Commit();
            }
            catch { tx.Rollback(); throw; }
        }

        public async Task RetirarAsync(int cuentaId, decimal monto, int moneda, string descripcion, string usuario)
        {
            using var conn = _db.Open();
            await conn.OpenAsync();
            using var tx = conn.BeginTransaction();
            try
            {
                var saldo = await conn.ExecuteScalarAsync<decimal>(
                    "SELECT SaldoActual FROM tbl_CuentaBancaria WHERE CodigoCuenta=@cuentaId AND Estado=1",
                    new { cuentaId }, tx);

                if (saldo < monto)
                    throw new InvalidOperationException("Saldo insuficiente.");

                var tipoCambio = await conn.ExecuteScalarAsync<decimal>(
                    "SELECT TipoCambio FROM tbl_moneda WHERE CodigoMoneda=@moneda",
                    new { moneda }, tx);

                await conn.ExecuteAsync(@"
                    UPDATE tbl_CuentaBancaria SET SaldoActual=SaldoActual-@monto,
                      UsuarioModificacion=@usuario, FechaModificacion=GETDATE()
                    WHERE CodigoCuenta=@cuentaId", new { monto, usuario, cuentaId }, tx);

                await conn.ExecuteAsync(@"
                    INSERT INTO tbl_Transaccion
                      (CodigoCuentaOrigen,CodigoTipoTransaccion,CodigoMoneda,Monto,
                       TipoCambioAplicado,FechaHora,Descripcion,Estado,UsuarioCreacion,FechaCreacion)
                    VALUES (@cuentaId,2,@moneda,@monto,@tipoCambio,GETDATE(),@descripcion,1,@usuario,GETDATE())",
                    new { cuentaId, moneda, monto, tipoCambio, descripcion, usuario }, tx);

                tx.Commit();
            }
            catch { tx.Rollback(); throw; }
        }

        public async Task TransferirAsync(int origen, int destino, decimal monto, int moneda, string descripcion, string usuario)
        {
            using var conn = _db.Open();
            await conn.OpenAsync();
            using var tx = conn.BeginTransaction();
            try
            {
                var saldo = await conn.ExecuteScalarAsync<decimal>(
                    "SELECT SaldoActual FROM tbl_CuentaBancaria WHERE CodigoCuenta=@origen AND Estado=1",
                    new { origen }, tx);

                if (saldo < monto)
                    throw new InvalidOperationException("Saldo insuficiente en cuenta origen.");

                var tipoCambio = await conn.ExecuteScalarAsync<decimal>(
                    "SELECT TipoCambio FROM tbl_moneda WHERE CodigoMoneda=@moneda",
                    new { moneda }, tx);

                await conn.ExecuteAsync(@"
                    UPDATE tbl_CuentaBancaria SET SaldoActual=SaldoActual-@monto,
                      UsuarioModificacion=@usuario, FechaModificacion=GETDATE()
                    WHERE CodigoCuenta=@origen", new { monto, usuario, origen }, tx);

                await conn.ExecuteAsync(@"
                    UPDATE tbl_CuentaBancaria SET SaldoActual=SaldoActual+@monto,
                      UsuarioModificacion=@usuario, FechaModificacion=GETDATE()
                    WHERE CodigoCuenta=@destino", new { monto, usuario, destino }, tx);

                await conn.ExecuteAsync(@"
                    INSERT INTO tbl_Transaccion
                      (CodigoCuentaOrigen,CodigoCuentaDestino,CodigoTipoTransaccion,CodigoMoneda,Monto,
                       TipoCambioAplicado,FechaHora,Descripcion,Estado,UsuarioCreacion,FechaCreacion)
                    VALUES (@origen,@destino,3,@moneda,@monto,@tipoCambio,GETDATE(),@descripcion,1,@usuario,GETDATE())",
                    new { origen, destino, moneda, monto, tipoCambio, descripcion, usuario }, tx);

                tx.Commit();
            }
            catch { tx.Rollback(); throw; }
        }
    }
}

// =============================================
// PrestamoRepository
// =============================================
namespace BancaCore.Data.Repositories
{
    public class PrestamoRepository
    {
        private readonly DbContext _db;
        public PrestamoRepository(DbContext db) { _db = db; }

        private const string SelectBase = @"
            SELECT p.*, cl.Nombres+' '+cl.Apellidos AS NombreCliente,
                   tp.Nombre AS NombreTipoPrestamo,
                   m.Nombre AS NombreMoneda, m.Simbolo AS SimboloMoneda
            FROM tbl_Prestamo p
            INNER JOIN tbl_Cliente      cl ON p.CodigoCliente      = cl.IdCliente
            INNER JOIN tbl_TipoPrestamo tp ON p.CodigoTipoPrestamo = tp.CodigoTipoPrestamo
            INNER JOIN tbl_moneda       m  ON p.CodigoMoneda       = m.CodigoMoneda";

        public async Task<IEnumerable<Prestamo>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<Prestamo>("usp_ConsultarPrestamo", commandType: CommandType.StoredProcedure);
        }

        public async Task<Prestamo?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<Prestamo>(
                SelectBase + " WHERE p.CodigoPrestamo=@id", new { id });
        }

        public async Task<(bool Resultado, string Mensaje)> CreateAsync(Prestamo p, string usuario)
        {
            using var conn = _db.Open();
            var par = new DynamicParameters();
            par.Add("CodigoCliente", p.CodigoCliente);
            par.Add("CodigoSucursal", p.CodigoSucursal);
            par.Add("CodigoTipoPrestamo", p.CodigoTipoPrestamo);
            par.Add("CodigoMoneda", p.CodigoMoneda);
            par.Add("MontoSolicitado", p.MontoSolicitado);
            par.Add("TasaInteres", p.TasaInteres);
            par.Add("PlazoMeses", p.PlazoMeses);
            par.Add("FechaDesembolso", p.FechaDesembolso);
            par.Add("SaldoPendiente", p.SaldoPendiente);
            par.Add("UsuarioCreacion", usuario);
            par.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            par.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_AgregarPrestamo", par, commandType: CommandType.StoredProcedure);
            var resultado = par.Get<bool>("Resultado");
            var mensaje = par.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> UpdateAsync(Prestamo p, string usuario)
        {
            using var conn = _db.Open();
            var par = new DynamicParameters();
            par.Add("CodigoPrestamo", p.CodigoPrestamo);
            par.Add("CodigoCliente", p.CodigoCliente);
            par.Add("CodigoSucursal", p.CodigoSucursal);
            par.Add("CodigoTipoPrestamo", p.CodigoTipoPrestamo);
            par.Add("CodigoMoneda", p.CodigoMoneda);
            par.Add("MontoSolicitado", p.MontoSolicitado);
            par.Add("TasaInteres", p.TasaInteres);
            par.Add("PlazoMeses", p.PlazoMeses);
            par.Add("FechaDesembolso", p.FechaDesembolso);
            par.Add("SaldoPendiente", p.SaldoPendiente);
            par.Add("Estado", p.Estado);
            par.Add("UsuarioModificacion", usuario);
            par.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            par.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EditarPrestamo", par, commandType: CommandType.StoredProcedure);
            var resultado = par.Get<bool>("Resultado");
            var mensaje = par.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var par = new DynamicParameters();
            par.Add("CodigoPrestamo", id);
            par.Add("UsuarioEliminacion", usuario);
            par.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            par.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EliminarPrestamo", par, commandType: CommandType.StoredProcedure);
            var resultado = par.Get<bool>("Resultado");
            var mensaje = p.Get<string>("Mensaje");
            return (resultado, mensaje ?? string.Empty);
        }

        public async Task<IEnumerable<Prestamo>> SearchAsync(int clienteId)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoCliente", clienteId);
            return await conn.QueryAsync<Prestamo>("usp_BuscarPrestamo", p, commandType: CommandType.StoredProcedure);
        }
    }
}

// =============================================
// UsuarioRepository
// =============================================
namespace BancaCore.Data.Repositories
{
    public class UsuarioRepository
    {
        private readonly DbContext _db;
        public UsuarioRepository(DbContext db) { _db = db; }

        public async Task<UsuarioSistema?> ValidarLoginAsync(string usuario, string password)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<UsuarioSistema>(@"
                SELECT u.*, s.Nombre AS NombreSucursal
                FROM tbl_UsuarioSistema u
                INNER JOIN tbl_Sucursal s ON u.CodigoSucursal = s.CodigoSucursal
                WHERE u.Usuario=@usuario AND u.Contraseña=@password AND u.Estado=1",
                new { usuario, password });
        }

        public async Task<IEnumerable<UsuarioSistema>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<UsuarioSistema>(@"
                SELECT u.*, s.Nombre AS NombreSucursal
                FROM tbl_UsuarioSistema u
                INNER JOIN tbl_Sucursal s ON u.CodigoSucursal = s.CodigoSucursal
                WHERE u.Estado=1 ORDER BY u.Usuario");
        }
    }
}

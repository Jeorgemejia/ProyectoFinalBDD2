using System.Data;
using Dapper;
using BancaCore.Data;
using BancaCore.Models;

namespace BancaCore.Data.Repositories
{
    public class TipoCuentaRepository
    {
        private readonly DbContext _db;
        public TipoCuentaRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<TipoCuenta>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoCuenta>("usp_ConsultarTipoCuenta", commandType: CommandType.StoredProcedure);
        }

        public async Task<TipoCuenta?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<TipoCuenta>("SELECT * FROM tbl_TipoCuenta WHERE CodigoTipoCuenta=@id", new { id });
        }

        public async Task<IEnumerable<TipoCuenta>> SearchAsync(string nombre)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", nombre);
            return await conn.QueryAsync<TipoCuenta>("usp_BuscarTipoCuenta", p, commandType: CommandType.StoredProcedure);
        }

        public async Task<(bool Resultado, string Mensaje)> CreateAsync(TipoCuenta t, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", t.Nombre);
            p.Add("SaldoMinimo", t.SaldoMinimo);
            p.Add("TasaInteres", t.TasaInteres);
            p.Add("UsuarioCreacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_AgregarTipoCuenta", p, commandType: CommandType.StoredProcedure);
            return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> UpdateAsync(TipoCuenta t, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoTipoCuenta", t.CodigoTipoCuenta);
            p.Add("Nombre", t.Nombre);
            p.Add("SaldoMinimo", t.SaldoMinimo);
            p.Add("TasaInteres", t.TasaInteres);
            p.Add("Estado", t.Estado);
            p.Add("UsuarioModificacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EditarTipoCuenta", p, commandType: CommandType.StoredProcedure);
            return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoTipoCuenta", id);
            p.Add("UsuarioEliminacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EliminarTipoCuenta", p, commandType: CommandType.StoredProcedure);
            return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? string.Empty);
        }
    }
}
using BancaCore.Models;
using BancaCore.Data.Repositories;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Data;
using Dapper;

namespace BancaCore.Controllers
{
    public class TransaccionesController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly UsuarioRepository _usuarioRepo;
        private readonly TransaccionRepository _transaccionRepo;
        private readonly CuentaRepository _cuentaRepo;
        private readonly MonedaRepository _monedaRepo;
        private readonly TipoTransaccionRepository _tipoTransaccionRepo;

        public TransaccionesController(ILogger<HomeController> logger,
            UsuarioRepository usuarioRepo,
            TransaccionRepository transaccionRepo,
            CuentaRepository cuentaRepo,
            MonedaRepository monedaRepo,
            TipoTransaccionRepository tipoTransaccionRepo)
        {
            _logger = logger;
            _usuarioRepo = usuarioRepo;
            _transaccionRepo = transaccionRepo;
            _cuentaRepo = cuentaRepo;
            _monedaRepo = monedaRepo;
            _tipoTransaccionRepo = tipoTransaccionRepo;
        }

        public async Task<IActionResult> Index()
        {
            var transacciones = await _transaccionRepo.GetAllAsync();
            return View(transacciones);
        }

        private async Task CargarCuentas()
        {
            ViewBag.Cuentas = await _cuentaRepo.GetAllAsync();
        }

        private async Task CargarMonedas()
        {
            ViewBag.Monedas = await _monedaRepo.GetAllAsync();
        }

        // Reemplazar los métodos POST de TransaccionesController por los siguientes

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Deposito(int cuentaId, decimal monto, int moneda, string descripcion)
        {
            var (resultado, mensaje) = await _transaccionRepo.DepositarAsync(cuentaId, monto, moneda, descripcion, User.Identity!.Name!);
            if (!resultado)
            {
                ModelState.AddModelError(string.Empty, mensaje);
                await CargarCuentas(); await CargarMonedas();
                return View();
            }

            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Retiro(int cuentaId, decimal monto, int moneda, string descripcion)
        {
            var (resultado, mensaje) = await _transaccionRepo.RetirarAsync(cuentaId, monto, moneda, descripcion, User.Identity!.Name!);
            if (!resultado)
            {
                ModelState.AddModelError(string.Empty, mensaje);
                await CargarCuentas(); await CargarMonedas();
                return View();
            }

            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Transferencia(int cuentaOrigen, int cuentaDestino, decimal monto, int moneda, string descripcion)
        {
            var (resultado, mensaje) = await _transaccionRepo.TransferirAsync(cuentaOrigen, cuentaDestino, monto, moneda, descripcion, User.Identity!.Name!);
            if (!resultado)
            {
                ModelState.AddModelError(string.Empty, mensaje);
                await CargarCuentas(); await CargarMonedas();
                return View();
            }

            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }

    public class TipoTransaccionRepository
    {
        private readonly DbContext _db;
        public TipoTransaccionRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<TipoTransaccion>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<TipoTransaccion>("usp_ConsultarTipoTransaccion", commandType: CommandType.StoredProcedure);
        }

        public async Task<TipoTransaccion?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<TipoTransaccion>("SELECT * FROM tbl_TipoTransaccion WHERE CodigoTipoTransaccion=@id", new { id });
        }

        public async Task<IEnumerable<TipoTransaccion>> SearchAsync(string nombre)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", nombre);
            return await conn.QueryAsync<TipoTransaccion>("usp_BuscarTipoTransaccion", p, commandType: CommandType.StoredProcedure);
        }

        public async Task<(bool Resultado, string Mensaje)> CreateAsync(TipoTransaccion t, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("Nombre", t.Nombre);
            p.Add("UsuarioCreacion", usuario);
            p.Add("Resultado", dbType: System.Data.DbType.Boolean, direction: System.Data.ParameterDirection.Output);
            p.Add("Mensaje", dbType: System.Data.DbType.String, size: 500, direction: System.Data.ParameterDirection.Output);

            await conn.ExecuteAsync("usp_AgregarTipoTransaccion", p, commandType: CommandType.StoredProcedure);

            return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> UpdateAsync(TipoTransaccion t, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoTipoCuenta", t.CodigoTipoCuenta); // nombre param en SP: @CodigoTipoCuenta
            p.Add("Nombre", t.Nombre);
            p.Add("SaldoMinimo", t.SaldoMinimo);
            p.Add("TasaInteres", t.TasaInteres);
            p.Add("Estado", t.Estado);
            p.Add("UsuarioModificacion", usuario);
            p.Add("Resultado", dbType: System.Data.DbType.Boolean, direction: System.Data.ParameterDirection.Output);
            p.Add("Mensaje", dbType: System.Data.DbType.String, size: 500, direction: System.Data.ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EditarTipoCuenta", p, commandType: CommandType.StoredProcedure);

            return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoTipoCuenta", id);
            p.Add("UsuarioEliminacion", usuario);
            p.Add("Resultado", dbType: System.Data.DbType.Boolean, direction: System.Data.ParameterDirection.Output);
            p.Add("Mensaje", dbType: System.Data.DbType.String, size: 500, direction: System.Data.ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EliminarTipoCuenta", p, commandType: CommandType.StoredProcedure);

            return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? string.Empty);
        }
    }

    public class CuentaRepository
    {
        private readonly DbContext _db;
        public CuentaRepository(DbContext db) { _db = db; }

        public async Task<IEnumerable<CuentaBancaria>> GetAllAsync()
        {
            using var conn = _db.Open();
            return await conn.QueryAsync<CuentaBancaria>("usp_ConsultarCuentaBancaria",
                commandType: CommandType.StoredProcedure);
        }

        public async Task<CuentaBancaria?> GetByIdAsync(int id)
        {
            using var conn = _db.Open();
            return await conn.QueryFirstOrDefaultAsync<CuentaBancaria>("SELECT * FROM tbl_CuentaBancaria WHERE CodigoCuenta=@id", new { id });
        }

        public async Task<(bool Resultado, string Mensaje)> CreateAsync(CuentaBancaria c, string usuario)
        {
            using var conn = _db.Open();
            var seq = await conn.ExecuteScalarAsync<int>("SELECT ISNULL(MAX(CodigoCuenta),0)+1 FROM tbl_CuentaBancaria");
            c.NumeroCuenta = $"{c.CodigoSucursal:D3}-{c.CodigoTipoCuenta:D2}-{seq:D8}";

            var p = new DynamicParameters();
            p.Add("NumeroCuenta", c.NumeroCuenta);
            p.Add("CodigoCliente", c.CodigoCliente);
            p.Add("CodigoSucursal", c.CodigoSucursal);
            p.Add("CodigoTipoCuenta", c.CodigoTipoCuenta);
            p.Add("CodigoMoneda", c.CodigoMoneda);
            p.Add("SaldoActual", c.SaldoActual);
            p.Add("FechaApertura", c.FechaApertura);
            p.Add("UsuarioCreacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_AgregarCuentaBancaria", p, commandType: CommandType.StoredProcedure);
            return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> UpdateAsync(CuentaBancaria c, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoCuenta", c.CodigoCuenta);
            p.Add("NumeroCuenta", c.NumeroCuenta);
            p.Add("CodigoCliente", c.CodigoCliente);
            p.Add("CodigoSucursal", c.CodigoSucursal);
            p.Add("CodigoTipoCuenta", c.CodigoTipoCuenta);
            p.Add("CodigoMoneda", c.CodigoMoneda);
            p.Add("SaldoActual", c.SaldoActual);
            p.Add("FechaApertura", c.FechaApertura);
            p.Add("Estado", c.Estado);
            p.Add("UsuarioModificacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EditarCuentaBancaria", p, commandType: CommandType.StoredProcedure);
            return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? string.Empty);
        }

        public async Task<(bool Resultado, string Mensaje)> CerrarAsync(int id, string usuario)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("CodigoCuenta", id);
            p.Add("UsuarioEliminacion", usuario);
            p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("usp_EliminarCuentaBancaria", p, commandType: CommandType.StoredProcedure);
            return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? string.Empty);
        }

        public async Task<IEnumerable<CuentaBancaria>> SearchAsync(string numeroCuenta)
        {
            using var conn = _db.Open();
            var p = new DynamicParameters();
            p.Add("NumeroCuenta", numeroCuenta);
            return await conn.QueryAsync<CuentaBancaria>("usp_BuscarCuentaBancaria", p, commandType: CommandType.StoredProcedure);
        }
    }
}

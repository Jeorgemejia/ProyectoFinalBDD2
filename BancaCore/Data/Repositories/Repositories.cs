using BancaCore.Models;
using BancaCore.Data.Repositories;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace BancaCore.Controllers
{
    public class TransaccionesController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly UsuarioRepository _usuarioRepo;
        private readonly TransaccionRepository _transaccionRepo;
        private readonly CuentaRepository _cuentaRepo;
        private readonly MonedaRepository _monedaRepo;

        public TransaccionesController(ILogger<HomeController> logger,
            UsuarioRepository usuarioRepo,
            TransaccionRepository transaccionRepo,
            CuentaRepository cuentaRepo,
            MonedaRepository monedaRepo)
        {
            _logger = logger;
            _usuarioRepo = usuarioRepo;
            _transaccionRepo = transaccionRepo;
            _cuentaRepo = cuentaRepo;
            _monedaRepo = monedaRepo;
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
            var (resultado, mensaje) = await _repo.DepositarAsync(cuentaId, monto, moneda, descripcion, User.Identity!.Name!);
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
            var (resultado, mensaje) = await _repo.RetirarAsync(cuentaId, monto, moneda, descripcion, User.Identity!.Name!);
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
            var (resultado, mensaje) = await _repo.TransferirAsync(cuentaOrigen, cuentaDestino, monto, moneda, descripcion, User.Identity!.Name!);
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
}

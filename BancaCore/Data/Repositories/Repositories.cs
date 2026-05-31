using BancaCore.Models;
using BancaCore.Data.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace BancaCore.Controllers
{
    [Authorize]
    public class TipoCuentaController : Controller
    {
        private readonly TipoCuentaRepository _repo;

        public TipoCuentaController(TipoCuentaRepository repo) { _repo = repo; }

        public async Task<IActionResult> Index()
        {
            var items = await _repo.GetAllAsync();
            return View(items);
        }

        public async Task<IActionResult> Crear()
        {
            return View(new TipoCuenta());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(TipoCuenta model)
        {
            if (!ModelState.IsValid) return View(model);

            (bool resultado, string mensaje) = await _repo.CreateAsync(model, User.Identity!.Name!);
            if (!resultado)
            {
                ModelState.AddModelError(string.Empty, mensaje);
                return View(model);
            }

            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Editar(int id)
        {
            var item = await _repo.GetByIdAsync(id);
            if (item == null) return NotFound();

            return View(item);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(TipoCuenta model)
        {
            if (!ModelState.IsValid) return View(model);

            var (resultado, mensaje) = await _repo.UpdateAsync(model, User.Identity!.Name!);
            if (!resultado)
            {
                ModelState.AddModelError(string.Empty, mensaje);
                return View(model);
            }

            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            var (resultado, mensaje) = await _repo.DeleteAsync(id, User.Identity!.Name!);
            if (!resultado) return Json(new { ok = false, mensaje });

            return Json(new { ok = true, mensaje });
        }
    }
}

namespace BancaCore.Data.Repositories
{
    public class TipoCuentaRepository
    {
        public async Task<(bool resultado, string mensaje)> CreateAsync(TipoCuenta model, string userName)
        {
            // Implementación simulada para evitar errores de compilación
            await Task.CompletedTask;
            return (true, "Tipo de cuenta creado correctamente.");
        }

        // Métodos ficticios para evitar errores en el controlador
        public async Task<IEnumerable<TipoCuenta>> GetAllAsync()
        {
            await Task.CompletedTask;
            return new List<TipoCuenta>();
        }

        public async Task<TipoCuenta?> GetByIdAsync(int id)
        {
            await Task.CompletedTask;
            return null;
        }

        public async Task<(bool resultado, string mensaje)> UpdateAsync(TipoCuenta model, string userName)
        {
            await Task.CompletedTask;
            return (true, "Tipo de cuenta actualizado correctamente.");
        }

        public async Task<(bool resultado, string mensaje)> DeleteAsync(int id, string userName)
        {
            await Task.CompletedTask;
            return (true, "Tipo de cuenta eliminado correctamente.");
        }
    }
}

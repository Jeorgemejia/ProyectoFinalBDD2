using BancaCore.Data;
using BancaCore.Data.Repositories;
using BancaCore.Models;
using Dapper;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Security.Claims;

// =============================================
// AuthController
// =============================================
namespace BancaCore.Controllers
{
    public class AuthController : Controller
    {
        private readonly UsuarioRepository _usuarioRepo;
        public AuthController(UsuarioRepository usuarioRepo)
        {
            _usuarioRepo = usuarioRepo;
        }

        public IActionResult Login() => View();

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(string usuario, string password)
        {
            var user = await _usuarioRepo.ValidarLoginAsync(usuario, password);
            if (user == null)
            {
                ViewBag.Error = "Usuario o contraseña incorrectos.";
                return View();
            }

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name,  user.Usuario),
                new Claim(ClaimTypes.Role,  user.Rol),
                new Claim("Sucursal",       user.CodigoSucursal.ToString()),
                new Claim("NombreSucursal", user.NombreSucursal)
            };

            var identity  = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var principal = new ClaimsPrincipal(identity);
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);
            return RedirectToAction("Index", "Home");
        }

        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Login");
        }

        public IActionResult Acceso() => View();
    }
}

    // =============================================
    // MonedasController
    // =============================================
    [Authorize]
    public class MonedasController : Controller
    {
        private readonly MonedaRepository _repo;
        public MonedasController(MonedaRepository repo) { _repo = repo; }

        public async Task<IActionResult> Index(string q = null)
        {
            if (!string.IsNullOrWhiteSpace(q))
            {
                ViewBag.Query = q;
                return View(await _repo.SearchAsync(q));
            }
            return View(await _repo.GetAllAsync());
        }

        public IActionResult Crear() => View(new Moneda());

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(Moneda model)
        {
            if (!ModelState.IsValid) return View(model);
            var (resultado, mensaje) = await _repo.CreateAsync(model, User.Identity!.Name!);
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
            var m = await _repo.GetByIdAsync(id);
            if (m == null) return NotFound();
            return View(m);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(Moneda model)
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

        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            var m = await _repo.GetByIdAsync(id);
            if (m == null) return NotFound();
            return View("Eliminar", m);
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            var (resultado, mensaje) = await _repo.DeleteAsync(id, User.Identity!.Name!);
            if (!resultado)
            {
                var m = await _repo.GetByIdAsync(id);
                if (m == null) return NotFound();
                ModelState.AddModelError(string.Empty, mensaje);
                return View("Eliminar", m);
            }
            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }
    }

    // =============================================
    // TiposCuentaController
    // =============================================
    [Authorize]
    public class TiposCuentaController : Controller
    {
        private readonly TipoCuentaRepository _repo;
        public TiposCuentaController(TipoCuentaRepository repo) { _repo = repo; }

        public async Task<IActionResult> Index(string q = null)
        {
            if (!string.IsNullOrWhiteSpace(q))
            {
                ViewBag.Query = q;
                return View(await _repo.SearchAsync(q));
            }
            return View(await _repo.GetAllAsync());
        }
        public IActionResult Crear() => View(new TipoCuenta());

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(TipoCuenta model)
        {
            if (!ModelState.IsValid) return View(model);
            await _repo.CreateAsync(model, User.Identity!.Name!);
            TempData["OK"] = "Tipo de cuenta creado.";
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Editar(int id)
        {
            var t = await _repo.GetByIdAsync(id);
            if (t == null) return NotFound();
            return View(t);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(TipoCuenta model)
        {
            if (!ModelState.IsValid) return View(model);
            await _repo.UpdateAsync(model, User.Identity!.Name!);
            TempData["OK"] = "Tipo de cuenta actualizado.";
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            var t = await _repo.GetByIdAsync(id);
            if (t == null) return NotFound();
            return View("Eliminar", t);
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            await _repo.DeleteAsync(id, User.Identity!.Name!);
            TempData["OK"] = "Tipo de cuenta eliminado.";
            return RedirectToAction(nameof(Index));
        }
    }

    // =============================================
    // TiposTransaccionController
    // =============================================
    [Authorize]
    public class TiposTransaccionController : Controller
    {
        private readonly TipoTransaccionRepository _repo;
        public TiposTransaccionController(TipoTransaccionRepository repo) { _repo = repo; }

        public async Task<IActionResult> Index(string q = null)
        {
            if (!string.IsNullOrWhiteSpace(q))
            {
                ViewBag.Query = q;
                return View(await _repo.SearchAsync(q));
            }
            return View(await _repo.GetAllAsync());
        }
        public IActionResult Crear() => View(new TipoTransaccion());

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(TipoTransaccion model)
        {
            if (!ModelState.IsValid) return View(model);
            await _repo.CreateAsync(model, User.Identity!.Name!);
            TempData["OK"] = "Tipo de transacción creado.";
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Editar(int id)
        {
            var t = await _repo.GetByIdAsync(id);
            if (t == null) return NotFound();
            return View(t);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(TipoTransaccion model)
        {
            if (!ModelState.IsValid) return View(model);
            await _repo.UpdateAsync(model, User.Identity!.Name!);
            TempData["OK"] = "Tipo de transacción actualizado.";
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            var t = await _repo.GetByIdAsync(id);
            if (t == null) return NotFound();
            return View("Eliminar", t);
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            await _repo.DeleteAsync(id, User.Identity!.Name!);
            TempData["OK"] = "Tipo de transacción eliminado.";
            return RedirectToAction(nameof(Index));
        }
    }

    // =============================================
    // TiposPrestamoController
    // =============================================
    [Authorize]
    public class TiposPrestamoController : Controller
    {
        private readonly TipoPrestamoRepository _repo;
        public TiposPrestamoController(TipoPrestamoRepository repo) { _repo = repo; }

        public async Task<IActionResult> Index() => View(await _repo.GetAllAsync());
        public IActionResult Crear() => View(new TipoPrestamo());

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(TipoPrestamo model)
        {
            if (!ModelState.IsValid) return View(model);
            var (resultado, mensaje) = await _repo.CreateAsync(model, User.Identity!.Name!);
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
            var t = await _repo.GetByIdAsync(id);
            if (t == null) return NotFound();
            return View(t);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(TipoPrestamo model)
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

        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            var t = await _repo.GetByIdAsync(id);
            if (t == null) return NotFound();
            return View("Eliminar", t);
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            await _repo.DeleteAsync(id, User.Identity!.Name!);
            TempData["OK"] = "Tipo de préstamo eliminado.";
            return RedirectToAction(nameof(Index));
        }
    }

    // =============================================
    // TiposTarjetaController
    // =============================================
    [Authorize]
    public class TiposTarjetaController : Controller
    {
        private readonly TipoTarjetaRepository _repo;
        public TiposTarjetaController(TipoTarjetaRepository repo) { _repo = repo; }

        public async Task<IActionResult> Index() => View(await _repo.GetAllAsync());
        public IActionResult Crear() => View(new TipoTarjeta());

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(TipoTarjeta model)
        {
            if (!ModelState.IsValid) return View(model);
            var (resultado, mensaje) = await _repo.CreateAsync(model, User.Identity!.Name!);
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
            var t = await _repo.GetByIdAsync(id);
            if (t == null) return NotFound();
            return View(t);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(TipoTarjeta model)
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

        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            var t = await _repo.GetByIdAsync(id);
            if (t == null) return NotFound();
            return View("Eliminar", t);
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            var (resultado, mensaje) = await _repo.DeleteAsync(id, User.Identity!.Name!);
            if (!resultado)
            {
                var t = await _repo.GetByIdAsync(id);
                if (t == null) return NotFound();
                ModelState.AddModelError(string.Empty, mensaje);
                return View("Eliminar", t);
            }
            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }
    }

    // =============================================
    // TarjetasController
    // =============================================
    [Authorize]
    public class TarjetasController : Controller
    {
        private readonly TarjetaRepository _repo;
        private readonly CuentaRepository _cuentas;
        private readonly TipoTarjetaRepository _tipos;

        public TarjetasController(TarjetaRepository repo, CuentaRepository cuentas, TipoTarjetaRepository tipos)
        {
            _repo = repo; _cuentas = cuentas; _tipos = tipos;
        }

        public async Task<IActionResult> Index() => View(await _repo.GetAllAsync());

        public async Task<IActionResult> Detalle(int id)
        {
            var t = await _repo.GetByIdAsync(id);
            if (t == null) return NotFound();
            return View(t);
        }

        public async Task<IActionResult> Crear()
        {
            ViewBag.Cuentas = new SelectList(await _cuentas.GetAllAsync(), "CodigoCuenta", "NumeroCuenta");
            ViewBag.Tipos = new SelectList(await _tipos.GetAllAsync(), "CodigoTipoTarjeta", "Nombre");
            return View(new Tarjeta { FechaEmision = DateTime.Today, FechaVencimiento = DateTime.Today.AddYears(3) });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(Tarjeta model)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.Cuentas = new SelectList(await _cuentas.GetAllAsync(), "CodigoCuenta", "NumeroCuenta");
                ViewBag.Tipos = new SelectList(await _tipos.GetAllAsync(), "CodigoTipoTarjeta", "Nombre");
                return View(model);
            }
            var (resultado, mensaje) = await _repo.CreateAsync(model, User.Identity!.Name!);
            if (!resultado)
            {
                ModelState.AddModelError(string.Empty, mensaje);
                ViewBag.Cuentas = new SelectList(await _cuentas.GetAllAsync(), "CodigoCuenta", "NumeroCuenta");
                ViewBag.Tipos = new SelectList(await _tipos.GetAllAsync(), "CodigoTipoTarjeta", "Nombre");
                return View(model);
            }
            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Editar(int id)
        {
            var t = await _repo.GetByIdAsync(id);
            if (t == null) return NotFound();
            ViewBag.Cuentas = new SelectList(await _cuentas.GetAllAsync(), "CodigoCuenta", "NumeroCuenta");
            ViewBag.Tipos = new SelectList(await _tipos.GetAllAsync(), "CodigoTipoTarjeta", "Nombre");
            return View(t);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(Tarjeta model)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.Cuentas = new SelectList(await _cuentas.GetAllAsync(), "CodigoCuenta", "NumeroCuenta");
                ViewBag.Tipos = new SelectList(await _tipos.GetAllAsync(), "CodigoTipoTarjeta", "Nombre");
                return View(model);
            }
            var (resultado, mensaje) = await _repo.UpdateAsync(model, User.Identity!.Name!);
            if (!resultado)
            {
                ModelState.AddModelError(string.Empty, mensaje);
                ViewBag.Cuentas = new SelectList(await _cuentas.GetAllAsync(), "CodigoCuenta", "NumeroCuenta");
                ViewBag.Tipos = new SelectList(await _tipos.GetAllAsync(), "CodigoTipoTarjeta", "Nombre");
                return View(model);
            }
            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            var t = await _repo.GetByIdAsync(id);
            if (t == null) return NotFound();
            return View("Eliminar", t);
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            var (resultado, mensaje) = await _repo.DeleteAsync(id, User.Identity!.Name!);
            if (!resultado)
            {
                var t = await _repo.GetByIdAsync(id);
                if (t == null) return NotFound();
                ModelState.AddModelError(string.Empty, mensaje);
                return View("Eliminar", t);
            }
            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }
    }

    // =============================================
    // UsuariosController
    // =============================================
    [Authorize(Roles = "ADMIN")]
    public class UsuariosController : Controller
    {
        private readonly UsuarioSistemaRepository _repo;
        private readonly SucursalRepository _sucursales;
        public UsuariosController(UsuarioSistemaRepository repo, SucursalRepository sucursales) { _repo = repo; _sucursales = sucursales; }

        public async Task<IActionResult> Index() => View(await _repo.GetAllAsync());

        public async Task<IActionResult> Crear()
        {
            ViewBag.Sucursales = new SelectList(await _sucursales.GetAllAsync(), "CodigoSucursal", "Nombre");
            return View(new UsuarioSistema());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(UsuarioSistema model)
        {
            if (!ModelState.IsValid) { ViewBag.Sucursales = new SelectList(await _sucursales.GetAllAsync(), "CodigoSucursal", "Nombre"); return View(model); }
            await _repo.CreateAsync(model, User.Identity!.Name!);
            TempData["OK"] = "Usuario creado.";
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Editar(int id)
        {
            var u = await _repo.GetByIdAsync(id);
            if (u == null) return NotFound();
            ViewBag.Sucursales = new SelectList(await _sucursales.GetAllAsync(), "CodigoSucursal", "Nombre");
            return View(u);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(UsuarioSistema model)
        {
            if (!ModelState.IsValid) { ViewBag.Sucursales = new SelectList(await _sucursales.GetAllAsync(), "CodigoSucursal", "Nombre"); return View(model); }
            await _repo.UpdateAsync(model, User.Identity!.Name!);
            TempData["OK"] = "Usuario actualizado.";
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            var u = await _repo.GetByIdAsync(id);
            if (u == null) return NotFound();
            return View("Eliminar", u);
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            await _repo.DeleteAsync(id, User.Identity!.Name!);
            TempData["OK"] = "Usuario eliminado.";
            return RedirectToAction(nameof(Index));
        }
    }

    // =============================================
    // PagosPrestamoController
    // =============================================
    [Authorize]
    public class PagosPrestamoController : Controller
    {
        private readonly PagoPrestamoRepository _repo;
        private readonly PrestamoRepository _prestamos;
        private readonly TransaccionRepository _trans;

        public PagosPrestamoController(PagoPrestamoRepository repo, PrestamoRepository prestamos, TransaccionRepository trans)
        {
            _repo = repo; _prestamos = prestamos; _trans = trans;
        }

        public async Task<IActionResult> Index() => View(await _repo.GetAllAsync());

        public async Task<IActionResult> Crear()
        {
            ViewBag.Prestamos = new SelectList(await _prestamos.GetAllAsync(), "CodigoPrestamo", "NombreCliente");
            ViewBag.Transacciones = new SelectList(await _trans.GetAllAsync(200), "CodigoTransaccion", "CodigoTransaccion");
            return View(new PagoPrestamo { FechaPago = DateTime.Today });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(PagoPrestamo model)
        {
            if (!ModelState.IsValid) { ViewBag.Prestamos = new SelectList(await _prestamos.GetAllAsync(), "CodigoPrestamo", "NombreCliente"); ViewBag.Transacciones = new SelectList(await _trans.GetAllAsync(200), "CodigoTransaccion", "CodigoTransaccion"); return View(model); }
            await _repo.CreateAsync(model, User.Identity!.Name!);
            TempData["OK"] = "Pago registrado.";
            return RedirectToAction(nameof(Index));
        }
    }

    // =============================================
    // AuditoriaController
    // =============================================
    [Authorize(Roles = "ADMIN")]
    public class AuditoriaController : Controller
    {
        private readonly AuditoriaRepository _repo;
        public AuditoriaController(AuditoriaRepository repo) { _repo = repo; }

        public async Task<IActionResult> Index() => View(await _repo.GetAllAsync());
    }

// =============================================
// HomeController
// =============================================
namespace BancaCore.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        private readonly DbContext _db;
        public HomeController(DbContext db) { _db = db; }

        public async Task<IActionResult> Index()
        {
            using var conn = _db.Open();
            ViewBag.TotalClientes    = await conn.ExecuteScalarAsync<int>("SELECT COUNT(*) FROM tbl_Cliente WHERE Estado=1");
            ViewBag.TotalCuentas     = await conn.ExecuteScalarAsync<int>("SELECT COUNT(*) FROM tbl_CuentaBancaria WHERE Estado=1");
            ViewBag.TotalSaldos      = await conn.ExecuteScalarAsync<decimal>("SELECT ISNULL(SUM(SaldoActual),0) FROM tbl_CuentaBancaria WHERE Estado=1");
            ViewBag.TotalPrestamos   = await conn.ExecuteScalarAsync<int>("SELECT COUNT(*) FROM tbl_Prestamo WHERE Estado=1");
            ViewBag.TransaccionesHoy = await conn.ExecuteScalarAsync<int>("SELECT COUNT(*) FROM tbl_Transaccion WHERE CAST(FechaHora AS DATE)=CAST(GETDATE() AS DATE)");
            ViewBag.UltimasTransacciones = await conn.QueryAsync(@"
                SELECT TOP 10 t.CodigoTransaccion, tt.Nombre AS Tipo,
                       co.NumeroCuenta AS CuentaOrigen, t.Monto, m.Simbolo, t.FechaHora
                FROM tbl_Transaccion t
                INNER JOIN tbl_TipoTransaccion tt ON t.CodigoTipoTransaccion = tt.CodigoTipoTransaccion
                INNER JOIN tbl_moneda m ON t.CodigoMoneda = m.CodigoMoneda
                LEFT  JOIN tbl_CuentaBancaria co ON t.CodigoCuentaOrigen = co.CodigoCuenta
                ORDER BY t.FechaHora DESC");
            return View();
        }
    }
}

// =============================================
// ClientesController
// =============================================
namespace BancaCore.Controllers
{
    [Authorize]
    public class ClientesController : Controller
    {
        private readonly ClienteRepository _repo;
        public ClientesController(ClienteRepository repo) { _repo = repo; }

        public async Task<IActionResult> Index() => View(await _repo.GetAllAsync());

        public async Task<IActionResult> Detalle(int id)
        {
            var c = await _repo.GetByIdAsync(id);
            if (c == null) return NotFound();
            return View(c);
        }

        public IActionResult Crear() => View(new Cliente());

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(Cliente model)
        {
            if (!ModelState.IsValid) return View(model);

            var (resultado, mensaje) = await _repo.CreateAsync(model, User.Identity!.Name!);
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
            var c = await _repo.GetByIdAsync(id);
            if (c == null) return NotFound();
            return View(c);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(Cliente model)
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

        // GET: Mostrar vista de confirmación para eliminación
        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            var c = await _repo.GetByIdAsync(id);
            if (c == null) return NotFound();
            return View("Eliminar", c);
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            var (resultado, mensaje) = await _repo.DeleteAsync(id, User.Identity!.Name!);
            if (!resultado)
            {
                var c = await _repo.GetByIdAsync(id);
                if (c == null) return NotFound();
                ModelState.AddModelError(string.Empty, mensaje);
                return View("Eliminar", c);
            }

            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }
    }
}

// =============================================
// SucursalesController
// =============================================
namespace BancaCore.Controllers
{
    [Authorize(Roles = "ADMIN")]
    public class SucursalesController : Controller
    {
        private readonly SucursalRepository _repo;
        public SucursalesController(SucursalRepository repo) { _repo = repo; }

        public async Task<IActionResult> Index() => View(await _repo.GetAllAsync());

        public IActionResult Crear() => View(new Sucursal());

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(Sucursal model)
        {
            if (!ModelState.IsValid) return View(model);
            var (resultado, mensaje) = await _repo.CreateAsync(model, User.Identity!.Name!);
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
            var s = await _repo.GetByIdAsync(id);
            if (s == null) return NotFound();
            return View(s);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(Sucursal model)
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

        // GET: Confirmar eliminación de sucursal
        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            var s = await _repo.GetByIdAsync(id);
            if (s == null) return NotFound();
            return View("Eliminar", s);
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            var (resultado, mensaje) = await _repo.DeleteAsync(id, User.Identity!.Name!);
            if (!resultado)
            {
                var s = await _repo.GetByIdAsync(id);
                if (s == null) return NotFound();
                ModelState.AddModelError(string.Empty, mensaje);
                return View("Eliminar", s);
            }
            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }
    }
}

// =============================================
// CuentasController
// =============================================
namespace BancaCore.Controllers
{
    [Authorize]
    public class CuentasController : Controller
    {
        private readonly CuentaRepository      _repo;
        private readonly ClienteRepository     _clientes;
        private readonly SucursalRepository    _sucursales;
        private readonly CatalogosRepository   _catalogos;
        private readonly TransaccionRepository _transacciones;

        public CuentasController(
            CuentaRepository repo,
            ClienteRepository clientes,
            SucursalRepository sucursales,
            CatalogosRepository catalogos,
            TransaccionRepository transacciones)
        {
            _repo          = repo;
            _clientes      = clientes;
            _sucursales    = sucursales;
            _catalogos     = catalogos;
            _transacciones = transacciones;
        }

        public async Task<IActionResult> Index() => View(await _repo.GetAllAsync());

        public async Task<IActionResult> Detalle(int id)
        {
            var cuenta = await _repo.GetByIdAsync(id);
            if (cuenta == null) return NotFound();
            ViewBag.Transacciones = await _transacciones.GetByCuentaAsync(id);
            return View(cuenta);
        }

        public async Task<IActionResult> Editar(int id)
        {
            var c = await _repo.GetByIdAsync(id);
            if (c == null) return NotFound();
            await CargarSelectLists();
            return View(c);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(CuentaBancaria model)
        {
            if (!ModelState.IsValid) { await CargarSelectLists(); return View(model); }
            await _repo.UpdateAsync(model, User.Identity!.Name!);
            TempData["OK"] = "Cuenta actualizada.";
            return RedirectToAction(nameof(Index));
        }

        // GET: Mostrar confirmación para cerrar cuenta
        public async Task<IActionResult> ConfirmarCerrar(int id)
        {
            var c = await _repo.GetByIdAsync(id);
            if (c == null) return NotFound();
            return View("Eliminar", c);
        }

        public async Task<IActionResult> Crear()
        {
            await CargarSelectLists();
            return View(new CuentaBancaria { FechaApertura = DateTime.Today });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(CuentaBancaria model)
        {
            if (!ModelState.IsValid) { await CargarSelectLists(); return View(model); }
            await _repo.CreateAsync(model, User.Identity!.Name!);
            TempData["OK"] = "Cuenta bancaria creada exitosamente.";
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> Cerrar(int id)
        {
            await _repo.CerrarAsync(id, User.Identity!.Name!);
            TempData["OK"] = "Cuenta cerrada.";
            return RedirectToAction(nameof(Index));
        }

        private async Task CargarSelectLists()
        {
            ViewBag.Clientes    = new SelectList(await _clientes.GetAllAsync(),              "IdCliente",        "NombreCompleto");
            ViewBag.Sucursales  = new SelectList(await _sucursales.GetAllAsync(),            "CodigoSucursal",   "Nombre");
            ViewBag.TiposCuenta = new SelectList(await _catalogos.GetTiposCuentaAsync(),     "CodigoTipoCuenta", "Nombre");
            ViewBag.Monedas     = new SelectList(await _catalogos.GetMonedasAsync(),         "CodigoMoneda",     "Nombre");
        }
    }
}

// =============================================
// TransaccionesController
// =============================================
namespace BancaCore.Controllers
{
    [Authorize]
    public class TransaccionesController : Controller
    {
        private readonly TransaccionRepository _repo;
        private readonly CuentaRepository      _cuentas;
        private readonly CatalogosRepository   _catalogos;

        public TransaccionesController(
            TransaccionRepository repo,
            CuentaRepository cuentas,
            CatalogosRepository catalogos)
        {
            _repo      = repo;
            _cuentas   = cuentas;
            _catalogos = catalogos;
        }

        public async Task<IActionResult> Index() => View(await _repo.GetAllAsync());

        public async Task<IActionResult> Deposito()
        {
            await CargarCuentas();
            await CargarMonedas();
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Deposito(int cuentaId, decimal monto, int moneda, string descripcion)
        {
            try
            {
                await _repo.DepositarAsync(cuentaId, monto, moneda, descripcion, User.Identity!.Name!);
                TempData["OK"] = $"Depósito de {monto:N2} realizado exitosamente.";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["ERR"] = ex.Message;
                await CargarCuentas(); await CargarMonedas();
                return View();
            }
        }

        public async Task<IActionResult> Retiro()
        {
            await CargarCuentas(); await CargarMonedas();
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Retiro(int cuentaId, decimal monto, int moneda, string descripcion)
        {
            try
            {
                await _repo.RetirarAsync(cuentaId, monto, moneda, descripcion, User.Identity!.Name!);
                TempData["OK"] = $"Retiro de {monto:N2} realizado exitosamente.";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["ERR"] = ex.Message;
                await CargarCuentas(); await CargarMonedas();
                return View();
            }
        }

        public async Task<IActionResult> Transferencia()
        {
            await CargarCuentas(); await CargarMonedas();
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Transferencia(int cuentaOrigen, int cuentaDestino, decimal monto, int moneda, string descripcion)
        {
            try
            {
                await _repo.TransferirAsync(cuentaOrigen, cuentaDestino, monto, moneda, descripcion, User.Identity!.Name!);
                TempData["OK"] = $"Transferencia de {monto:N2} realizada exitosamente.";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["ERR"] = ex.Message;
                await CargarCuentas(); await CargarMonedas();
                return View();
            }
        }

        private async Task CargarCuentas()
        {
            var cuentas = await _cuentas.GetAllAsync();
            ViewBag.Cuentas = new SelectList(
                cuentas.Select(c => new { c.CodigoCuenta, Display = $"{c.NumeroCuenta} — {c.NombreCliente}" }),
                "CodigoCuenta", "Display");
        }

        private async Task CargarMonedas()
        {
            ViewBag.Monedas = new SelectList(await _catalogos.GetMonedasAsync(), "CodigoMoneda", "Nombre");
        }
    }
}

// =============================================
// PrestamosController
// =============================================
namespace BancaCore.Controllers
{
    [Authorize]
    public class PrestamosController : Controller
    {
        private readonly PrestamoRepository  _repo;
        private readonly ClienteRepository   _clientes;
        private readonly SucursalRepository  _sucursales;
        private readonly CatalogosRepository _catalogos;

        public PrestamosController(
            PrestamoRepository repo,
            ClienteRepository clientes,
            SucursalRepository sucursales,
            CatalogosRepository catalogos)
        {
            _repo       = repo;
            _clientes   = clientes;
            _sucursales = sucursales;
            _catalogos  = catalogos;
        }

        public async Task<IActionResult> Index() => View(await _repo.GetAllAsync());

        public async Task<IActionResult> Detalle(int id)
        {
            var p = await _repo.GetByIdAsync(id);
            if (p == null) return NotFound();
            return View(p);
        }

        public async Task<IActionResult> Crear()
        {
            await CargarSelectLists();
            return View(new Prestamo { FechaDesembolso = DateTime.Today });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(Prestamo model)
        {
            if (!ModelState.IsValid) { await CargarSelectLists(); return View(model); }
            var (resultado, mensaje) = await _repo.CreateAsync(model, User.Identity!.Name!);
            if (!resultado)
            {
                ModelState.AddModelError(string.Empty, mensaje);
                await CargarSelectLists();
                return View(model);
            }
            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Editar(int id)
        {
            var p = await _repo.GetByIdAsync(id);
            if (p == null) return NotFound();
            await CargarSelectLists();
            return View(p);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(Prestamo model)
        {
            if (!ModelState.IsValid) { await CargarSelectLists(); return View(model); }
            var (resultado, mensaje) = await _repo.UpdateAsync(model, User.Identity!.Name!);
            if (!resultado)
            {
                ModelState.AddModelError(string.Empty, mensaje);
                await CargarSelectLists();
                return View(model);
            }
            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }

        // GET: confirmación para eliminar
        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            var p = await _repo.GetByIdAsync(id);
            if (p == null) return NotFound();
            return View("Eliminar", p);
        }

        [HttpPost]
        public async Task<IActionResult> Eliminar(int id)
        {
            var (resultado, mensaje) = await _repo.DeleteAsync(id, User.Identity!.Name!);
            if (!resultado)
            {
                var p = await _repo.GetByIdAsync(id);
                if (p == null) return NotFound();
                ModelState.AddModelError(string.Empty, mensaje);
                return View("Eliminar", p);
            }
            TempData["OK"] = mensaje;
            return RedirectToAction(nameof(Index));
        }

        private async Task CargarSelectLists()
        {
            ViewBag.Clientes   = new SelectList(await _clientes.GetAllAsync(),               "IdCliente",          "NombreCompleto");
            ViewBag.Sucursales = new SelectList(await _sucursales.GetAllAsync(),             "CodigoSucursal",     "Nombre");
            ViewBag.Tipos      = new SelectList(await _catalogos.GetTiposPrestamoAsync(),    "CodigoTipoPrestamo", "Nombre");
            ViewBag.Monedas    = new SelectList(await _catalogos.GetMonedasAsync(),          "CodigoMoneda",       "Nombre");
        }
    }
}

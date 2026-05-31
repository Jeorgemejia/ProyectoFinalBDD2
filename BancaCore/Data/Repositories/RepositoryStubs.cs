using BancaCore.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace BancaCore.Data.Repositories
{
    // Stubs mínimos para resolver los errores CS0246.
    // Reemplaza con la implementación real (Dapper / SP / DbContext) cuando esté disponible.

    public class ClienteRepository
    {
        public async Task<IEnumerable<Cliente>> GetAllAsync() { await Task.CompletedTask; return new List<Cliente>(); }
        public async Task<Cliente?> GetByIdAsync(int id) { await Task.CompletedTask; return null; }
        public async Task<(bool, string)> CreateAsync(Cliente model, string user) { await Task.CompletedTask; return (true, "Cliente creado (stub)"); }
        public async Task<(bool, string)> UpdateAsync(Cliente model, string user) { await Task.CompletedTask; return (true, "Cliente actualizado (stub)"); }
        public async Task<(bool, string)> DeleteAsync(int id, string user) { await Task.CompletedTask; return (true, "Cliente eliminado (stub)"); }
    }

    public class PrestamoRepository
    {
        public async Task<IEnumerable<Prestamo>> GetAllAsync() { await Task.CompletedTask; return new List<Prestamo>(); }
        public async Task<Prestamo?> GetByIdAsync(int id) { await Task.CompletedTask; return null; }
        public async Task<(bool, string)> CreateAsync(Prestamo model, string user) { await Task.CompletedTask; return (true, "Préstamo creado (stub)"); }
        public async Task<(bool, string)> UpdateAsync(Prestamo model, string user) { await Task.CompletedTask; return (true, "Préstamo actualizado (stub)"); }
        public async Task<(bool, string)> DeleteAsync(int id, string user) { await Task.CompletedTask; return (true, "Préstamo eliminado (stub)"); }
    }

    public class SucursalRepository
    {
        public async Task<IEnumerable<Sucursal>> GetAllAsync() { await Task.CompletedTask; return new List<Sucursal>(); }
        public async Task<Sucursal?> GetByIdAsync(int id) { await Task.CompletedTask; return null; }
        public async Task<(bool, string)> CreateAsync(Sucursal model, string user) { await Task.CompletedTask; return (true, "Sucursal creada (stub)"); }
        public async Task<(bool, string)> UpdateAsync(Sucursal model, string user) { await Task.CompletedTask; return (true, "Sucursal actualizada (stub)"); }
        public async Task<(bool, string)> DeleteAsync(int id, string user) { await Task.CompletedTask; return (true, "Sucursal eliminada (stub)"); }
    }

    public class CatalogosRepository
    {
        public async Task<IEnumerable<TipoCuenta>> GetTiposCuentaAsync() { await Task.CompletedTask; return new List<TipoCuenta>(); }
        public async Task<IEnumerable<TipoPrestamo>> GetTiposPrestamoAsync() { await Task.CompletedTask; return new List<TipoPrestamo>(); }
        public async Task<IEnumerable<Moneda>> GetMonedasAsync() { await Task.CompletedTask; return new List<Moneda>(); }
    }

    public class TransaccionRepository
    {
        public async Task<IEnumerable<Transaccion>> GetAllAsync() { await Task.CompletedTask; return new List<Transaccion>(); }
        public async Task<IEnumerable<Transaccion>> GetByCuentaAsync(int cuentaId) { await Task.CompletedTask; return new List<Transaccion>(); }
        public async Task DepositarAsync(int cuentaId, decimal monto, int moneda, string descripcion, string user) { await Task.CompletedTask; }
        public async Task RetirarAsync(int cuentaId, decimal monto, int moneda, string descripcion, string user) { await Task.CompletedTask; }
        public async Task TransferirAsync(int origen, int destino, decimal monto, int moneda, string descripcion, string user) { await Task.CompletedTask; }
        public async Task<IEnumerable<Transaccion>> GetAllAsync(int top) { await Task.CompletedTask; return new List<Transaccion>(); }
    }

    public class CuentaRepository
    {
        public async Task<IEnumerable<CuentaBancaria>> GetAllAsync() { await Task.CompletedTask; return new List<CuentaBancaria>(); }
        public async Task<CuentaBancaria?> GetByIdAsync(int id) { await Task.CompletedTask; return null; }
        public async Task<(int codigo, string mensaje)> CreateAsync(CuentaBancaria model, string user) { await Task.CompletedTask; return (0, "Stub"); }
        public async Task<(bool, string)> UpdateAsync(CuentaBancaria model, string user) { await Task.CompletedTask; return (true, "Actualizado (stub)"); }
        public async Task<(bool, string)> DeleteAsync(int id, string user) { await Task.CompletedTask; return (true, "Cuenta cerrada (stub)"); }
    }

    public class TarjetaRepository
    {
        public async Task<IEnumerable<Tarjeta>> GetAllAsync() { await Task.CompletedTask; return new List<Tarjeta>(); }
        public async Task<Tarjeta?> GetByIdAsync(int id) { await Task.CompletedTask; return null; }
        public async Task<(bool, string)> CreateAsync(Tarjeta model, string user) { await Task.CompletedTask; return (true, "Tarjeta creada (stub)"); }
        public async Task<(bool, string)> UpdateAsync(Tarjeta model, string user) { await Task.CompletedTask; return (true, "Tarjeta actualizada (stub)"); }
        public async Task<(bool, string)> DeleteAsync(int id, string user) { await Task.CompletedTask; return (true, "Tarjeta eliminada (stub)"); }
    }

    public class TipoTarjetaRepository
    {
        public async Task<IEnumerable<TipoTarjeta>> GetAllAsync() { await Task.CompletedTask; return new List<TipoTarjeta>(); }
        public async Task<TipoTarjeta?> GetByIdAsync(int id) { await Task.CompletedTask; return null; }
        public async Task<(bool, string)> CreateAsync(TipoTarjeta model, string user) { await Task.CompletedTask; return (true, "Tipo tarjeta creado (stub)"); }
        public async Task<(bool, string)> UpdateAsync(TipoTarjeta model, string user) { await Task.CompletedTask; return (true, "Tipo tarjeta actualizado (stub)"); }
        public async Task<(bool, string)> DeleteAsync(int id, string user) { await Task.CompletedTask; return (true, "Tipo tarjeta eliminado (stub)"); }
    }

    public class TipoPrestamoRepository
    {
        public async Task<IEnumerable<TipoPrestamo>> GetAllAsync() { await Task.CompletedTask; return new List<TipoPrestamo>(); }
        public async Task<TipoPrestamo?> GetByIdAsync(int id) { await Task.CompletedTask; return null; }
        public async Task<(bool, string)> CreateAsync(TipoPrestamo model, string user) { await Task.CompletedTask; return (true, "Tipo préstamo creado (stub)"); }
        public async Task<(bool, string)> UpdateAsync(TipoPrestamo model, string user) { await Task.CompletedTask; return (true, "Tipo préstamo actualizado (stub)"); }
        public async Task<(bool, string)> DeleteAsync(int id, string user) { await Task.CompletedTask; return (true, "Tipo préstamo eliminado (stub)"); }
        public async Task<IEnumerable<TipoPrestamo>> SearchAsync(string q) { await Task.CompletedTask; return new List<TipoPrestamo>(); }
    }

    public class TipoTransaccionRepository
    {
        public async Task<IEnumerable<TipoTransaccion>> GetAllAsync() { await Task.CompletedTask; return new List<TipoTransaccion>(); }
        public async Task<TipoTransaccion?> GetByIdAsync(int id) { await Task.CompletedTask; return null; }
        public async Task<(bool, string)> CreateAsync(TipoTransaccion model, string user) { await Task.CompletedTask; return (true, "Tipo transacción creado (stub)"); }
        public async Task<(bool, string)> UpdateAsync(TipoTransaccion model, string user) { await Task.CompletedTask; return (true, "Tipo transacción actualizado (stub)"); }
        public async Task<(bool, string)> DeleteAsync(int id, string user) { await Task.CompletedTask; return (true, "Tipo transacción eliminado (stub)"); }
        public async Task<IEnumerable<TipoTransaccion>> SearchAsync(string q) { await Task.CompletedTask; return new List<TipoTransaccion>(); }
    }

    public class MonedaRepository
    {
        public async Task<IEnumerable<Moneda>> GetAllAsync() { await Task.CompletedTask; return new List<Moneda>(); }
        public async Task<Moneda?> GetByIdAsync(int id) { await Task.CompletedTask; return null; }
        public async Task<(bool, string)> CreateAsync(Moneda model, string user) { await Task.CompletedTask; return (true, "Moneda creada (stub)"); }
        public async Task<(bool, string)> UpdateAsync(Moneda model, string user) { await Task.CompletedTask; return (true, "Moneda actualizada (stub)"); }
        public async Task<(bool, string)> DeleteAsync(int id, string user) { await Task.CompletedTask; return (true, "Moneda eliminada (stub)"); }
        public async Task<IEnumerable<Moneda>> SearchAsync(string q) { await Task.CompletedTask; return new List<Moneda>(); }
    }

    public class UsuarioSistemaRepository
    {
        public async Task<IEnumerable<UsuarioSistema>> GetAllAsync() { await Task.CompletedTask; return new List<UsuarioSistema>(); }
        public async Task<UsuarioSistema?> GetByIdAsync(int id) { await Task.CompletedTask; return null; }
        public async Task<(bool, string)> CreateAsync(UsuarioSistema model, string user) { await Task.CompletedTask; return (true, "Usuario creado (stub)"); }
        public async Task<(bool, string)> UpdateAsync(UsuarioSistema model, string user) { await Task.CompletedTask; return (true, "Usuario actualizado (stub)"); }
        public async Task<(bool, string)> DeleteAsync(int id, string user) { await Task.CompletedTask; return (true, "Usuario eliminado (stub)"); }
        public async Task<UsuarioSistema?> ValidarLoginAsync(string usuario, string password) { await Task.CompletedTask; return null; }
    }

    public class PagoPrestamoRepository
    {
        public async Task<IEnumerable<PagoPrestamo>> GetAllAsync() { await Task.CompletedTask; return new List<PagoPrestamo>(); }
        public async Task<(bool, string)> CreateAsync(PagoPrestamo model, string user) { await Task.CompletedTask; return (true, "Pago (stub)"); }
    }

    public class AuditoriaRepository
    {
        public async Task<IEnumerable<Auditoria>> GetAllAsync() { await Task.CompletedTask; return new List<Auditoria>(); }
    }

    // Añade más métodos que necesites conforme avances.
}
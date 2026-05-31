using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using BancaCore.Models;

namespace BancaCore.Data.Repositories
{
    public static class RepositorySearchExtensions
    {
        public static async Task<IEnumerable<Moneda>> SearchAsync(this MonedaRepository repo, string q)
        {
            if (repo == null) throw new ArgumentNullException(nameof(repo));
            var all = await repo.GetAllAsync();
            if (string.IsNullOrWhiteSpace(q)) return all;

            var term = q.Trim();
            return all.Where(m =>
                (!string.IsNullOrEmpty(m.Nombre) && m.Nombre.Contains(term, StringComparison.OrdinalIgnoreCase)) ||
                (!string.IsNullOrEmpty(m.Simbolo) && m.Simbolo.Contains(term, StringComparison.OrdinalIgnoreCase)) ||
                m.CodigoMoneda.ToString().Contains(term, StringComparison.OrdinalIgnoreCase));
        }

        public static async Task<IEnumerable<TipoTransaccion>> SearchAsync(this TipoTransaccionRepository repo, string q)
        {
            if (repo == null) throw new ArgumentNullException(nameof(repo));
            var all = await repo.GetAllAsync();
            if (string.IsNullOrWhiteSpace(q)) return all;

            var term = q.Trim();
            return all.Where(t =>
                (!string.IsNullOrEmpty(t.Nombre) && t.Nombre.Contains(term, StringComparison.OrdinalIgnoreCase)) ||
                t.CodigoTipoTransaccion.ToString().Contains(term, StringComparison.OrdinalIgnoreCase));
        }
    }
}
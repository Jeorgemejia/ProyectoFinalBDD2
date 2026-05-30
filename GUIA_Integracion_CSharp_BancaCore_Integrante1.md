# Guia de integracion C# MVC - Integrante 1

Script SQL generado:

`C:\Users\cesar mejia\Documents\Codex\2026-05-28\files-mentioned-by-the-user-ejemplos\BancaCore_Integrante1_BD.sql`

Proyecto revisado:

`C:\Users\cesar mejia\Documents\Codex\2026-05-28\files-mentioned-by-the-user-ejemplos\BancaCore_extracted\BancaCore\BancaCore`

## 1. Ejecutar SQL

1. Abrir SQL Server Management Studio.
2. Seleccionar la base `db_SistemaBancario`.
3. Ejecutar `BancaCore_Integrante1_BD.sql`.
4. Si algun objeto ya existe, eliminar ese procedimiento, funcion o trigger y volver a ejecutar el bloque.

## 2. Archivo principal a modificar

Modificar:

`Data\Repositories\Repositories.cs`

El archivo ya tiene estos `using`, pero validar que esten arriba:

```csharp
using Dapper;
using System.Data;
```

## 3. Codigo para copiar en los repositorios

### ClienteRepository

Reemplazar los metodos actuales de `ClienteRepository` por estos. Se respetan los nombres usados por los controllers: `GetAllAsync`, `GetByIdAsync`, `CreateAsync`, `UpdateAsync`, `DeleteAsync`. Se agrega `BuscarAsync`.

```csharp
public async Task<IEnumerable<Cliente>> GetAllAsync()
{
    using var conn = _db.Open();
    return await conn.QueryAsync<Cliente>(
        "usp_ConsultarCliente",
        commandType: CommandType.StoredProcedure);
}

public async Task<Cliente?> GetByIdAsync(int id)
{
    using var conn = _db.Open();
    return await conn.QueryFirstOrDefaultAsync<Cliente>(
        "SELECT * FROM tbl_Cliente WHERE IdCliente=@id", new { id });
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
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_AgregarCliente", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
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
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_EditarCliente", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
{
    using var conn = _db.Open();
    var p = new DynamicParameters();
    p.Add("IdCliente", id);
    p.Add("UsuarioEliminacion", usuario);
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_EliminarCliente", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<IEnumerable<Cliente>> BuscarAsync(string nombres)
{
    using var conn = _db.Open();
    return await conn.QueryAsync<Cliente>(
        "usp_BuscarCliente",
        new { Nombres = nombres },
        commandType: CommandType.StoredProcedure);
}
```

### CuentaRepository

Reemplazar los metodos CRUD de `CuentaRepository`. Se respeta `CerrarAsync` porque asi lo llama `CuentasController`.

```csharp
public async Task<IEnumerable<CuentaBancaria>> GetAllAsync()
{
    using var conn = _db.Open();
    return await conn.QueryAsync<CuentaBancaria>(SelectBase + " WHERE c.Estado=1 ORDER BY c.FechaApertura DESC");
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
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
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
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
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
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<IEnumerable<CuentaBancaria>> BuscarAsync(string numeroCuenta)
{
    using var conn = _db.Open();
    return await conn.QueryAsync<CuentaBancaria>(
        "usp_BuscarCuentaBancaria",
        new { NumeroCuenta = numeroCuenta },
        commandType: CommandType.StoredProcedure);
}
```

### TipoCuentaRepository

```csharp
public async Task<IEnumerable<TipoCuenta>> GetAllAsync()
{
    using var conn = _db.Open();
    return await conn.QueryAsync<TipoCuenta>(
        "usp_ConsultarTipoCuenta",
        commandType: CommandType.StoredProcedure);
}

public async Task<TipoCuenta?> GetByIdAsync(int id)
{
    using var conn = _db.Open();
    return await conn.QueryFirstOrDefaultAsync<TipoCuenta>(
        "SELECT * FROM tbl_TipoCuenta WHERE CodigoTipoCuenta=@id", new { id });
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
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
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
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
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
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<IEnumerable<TipoCuenta>> BuscarAsync(string nombre)
{
    using var conn = _db.Open();
    return await conn.QueryAsync<TipoCuenta>(
        "usp_BuscarTipoCuenta",
        new { Nombre = nombre },
        commandType: CommandType.StoredProcedure);
}
```

### TransaccionRepository

Recomendacion: dejar `DepositarAsync`, `RetirarAsync` y `TransferirAsync` como estan si el sistema ya opera bien, porque tienen reglas de saldo. Agregar estos metodos CRUD para cumplir la parte de base de datos.

```csharp
public async Task<(bool Resultado, string Mensaje)> CreateAsync(Transaccion t, string usuario)
{
    using var conn = _db.Open();
    var p = new DynamicParameters();
    p.Add("CodigoCuentaOrigen", t.CodigoCuentaOrigen);
    p.Add("CodigoCuentaDestino", t.CodigoCuentaDestino);
    p.Add("CodigoTipoTransaccion", t.CodigoTipoTransaccion);
    p.Add("CodigoMoneda", t.CodigoMoneda);
    p.Add("Monto", t.Monto);
    p.Add("TipoCambioAplicado", t.TipoCambioAplicado);
    p.Add("FechaHora", t.FechaHora);
    p.Add("Descripcion", t.Descripcion);
    p.Add("UsuarioCreacion", usuario);
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_AgregarTransaccion", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<(bool Resultado, string Mensaje)> UpdateAsync(Transaccion t, string usuario)
{
    using var conn = _db.Open();
    var p = new DynamicParameters();
    p.Add("CodigoTransaccion", t.CodigoTransaccion);
    p.Add("CodigoCuentaOrigen", t.CodigoCuentaOrigen);
    p.Add("CodigoCuentaDestino", t.CodigoCuentaDestino);
    p.Add("CodigoTipoTransaccion", t.CodigoTipoTransaccion);
    p.Add("CodigoMoneda", t.CodigoMoneda);
    p.Add("Monto", t.Monto);
    p.Add("TipoCambioAplicado", t.TipoCambioAplicado);
    p.Add("FechaHora", t.FechaHora);
    p.Add("Descripcion", t.Descripcion);
    p.Add("Estado", t.Estado);
    p.Add("UsuarioModificacion", usuario);
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_EditarTransaccion", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
{
    using var conn = _db.Open();
    var p = new DynamicParameters();
    p.Add("CodigoTransaccion", id);
    p.Add("UsuarioEliminacion", usuario);
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_EliminarTransaccion", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<IEnumerable<Transaccion>> BuscarAsync(string descripcion)
{
    using var conn = _db.Open();
    return await conn.QueryAsync<Transaccion>(
        "usp_BuscarTransaccion",
        new { Descripcion = descripcion },
        commandType: CommandType.StoredProcedure);
}
```

### TipoTransaccionRepository

```csharp
public async Task<IEnumerable<TipoTransaccion>> GetAllAsync()
{
    using var conn = _db.Open();
    return await conn.QueryAsync<TipoTransaccion>(
        "usp_ConsultarTipoTransaccion",
        commandType: CommandType.StoredProcedure);
}

public async Task<TipoTransaccion?> GetByIdAsync(int id)
{
    using var conn = _db.Open();
    return await conn.QueryFirstOrDefaultAsync<TipoTransaccion>(
        "SELECT * FROM tbl_TipoTransaccion WHERE CodigoTipoTransaccion=@id", new { id });
}

public async Task<(bool Resultado, string Mensaje)> CreateAsync(TipoTransaccion t, string usuario)
{
    using var conn = _db.Open();
    var p = new DynamicParameters();
    p.Add("Nombre", t.Nombre);
    p.Add("UsuarioCreacion", usuario);
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_AgregarTipoTransaccion", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<(bool Resultado, string Mensaje)> UpdateAsync(TipoTransaccion t, string usuario)
{
    using var conn = _db.Open();
    var p = new DynamicParameters();
    p.Add("CodigoTipoTransaccion", t.CodigoTipoTransaccion);
    p.Add("Nombre", t.Nombre);
    p.Add("Estado", t.Estado);
    p.Add("UsuarioModificacion", usuario);
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_EditarTipoTransaccion", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id, string usuario)
{
    using var conn = _db.Open();
    var p = new DynamicParameters();
    p.Add("CodigoTipoTransaccion", id);
    p.Add("UsuarioEliminacion", usuario);
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_EliminarTipoTransaccion", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<IEnumerable<TipoTransaccion>> BuscarAsync(string nombre)
{
    using var conn = _db.Open();
    return await conn.QueryAsync<TipoTransaccion>(
        "usp_BuscarTipoTransaccion",
        new { Nombre = nombre },
        commandType: CommandType.StoredProcedure);
}
```

### AuditoriaRepository

`AuditoriaController` actualmente solo lista registros. Con `GetAllAsync` basta para que no se rompa. Agregar los demas si quieren exponer CRUD o probar desde C#.

```csharp
public async Task<IEnumerable<Auditoria>> GetAllAsync()
{
    using var conn = _db.Open();
    return await conn.QueryAsync<Auditoria>(
        "usp_ConsultarAuditoria",
        commandType: CommandType.StoredProcedure);
}

public async Task<Auditoria?> GetByIdAsync(int id)
{
    using var conn = _db.Open();
    return await conn.QueryFirstOrDefaultAsync<Auditoria>(
        "SELECT * FROM tbl_Auditoria WHERE CodigoAuditoria=@id", new { id });
}

public async Task<(bool Resultado, string Mensaje)> CreateAsync(Auditoria a)
{
    using var conn = _db.Open();
    var p = new DynamicParameters();
    p.Add("TablaAfectada", a.TablaAfectada);
    p.Add("Accion", a.Accion);
    p.Add("RegistroId", a.RegistroId);
    p.Add("Usuario", a.Usuario);
    p.Add("FechaHora", a.FechaHora);
    p.Add("ValoresAnteriores", a.ValoresAnteriores);
    p.Add("ValoresNuevos", a.ValoresNuevos);
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_AgregarAuditoria", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<(bool Resultado, string Mensaje)> UpdateAsync(Auditoria a)
{
    using var conn = _db.Open();
    var p = new DynamicParameters();
    p.Add("CodigoAuditoria", a.CodigoAuditoria);
    p.Add("TablaAfectada", a.TablaAfectada);
    p.Add("Accion", a.Accion);
    p.Add("RegistroId", a.RegistroId);
    p.Add("Usuario", a.Usuario);
    p.Add("FechaHora", a.FechaHora);
    p.Add("ValoresAnteriores", a.ValoresAnteriores);
    p.Add("ValoresNuevos", a.ValoresNuevos);
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_EditarAuditoria", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<(bool Resultado, string Mensaje)> DeleteAsync(int id)
{
    using var conn = _db.Open();
    var p = new DynamicParameters();
    p.Add("CodigoAuditoria", id);
    p.Add("Resultado", dbType: DbType.Boolean, direction: ParameterDirection.Output);
    p.Add("Mensaje", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

    await conn.ExecuteAsync("usp_EliminarAuditoria", p, commandType: CommandType.StoredProcedure);
    return (p.Get<bool>("Resultado"), p.Get<string>("Mensaje") ?? "");
}

public async Task<IEnumerable<Auditoria>> BuscarAsync(string tablaAfectada)
{
    using var conn = _db.Open();
    return await conn.QueryAsync<Auditoria>(
        "usp_BuscarAuditoria",
        new { TablaAfectada = tablaAfectada },
        commandType: CommandType.StoredProcedure);
}
```

## 4. Cambios necesarios en controllers

Como `CreateAsync`, `UpdateAsync`, `DeleteAsync` y `CerrarAsync` ahora devuelven `(Resultado, Mensaje)`, se deben ajustar los controllers que hoy esperan `int` o `bool`.

### Crear y Editar

Cambiar:

```csharp
await _repo.CreateAsync(model, User.Identity!.Name!);
TempData["OK"] = "Registro creado.";
```

Por:

```csharp
var (resultado, mensaje) = await _repo.CreateAsync(model, User.Identity!.Name!);
if (!resultado)
{
    ModelState.AddModelError(string.Empty, mensaje);
    return View(model);
}

TempData["OK"] = mensaje;
return RedirectToAction(nameof(Index));
```

Para `Editar`, usar el mismo patron con `UpdateAsync`.

### Eliminar o Cerrar

Cambiar:

```csharp
await _repo.DeleteAsync(id, User.Identity!.Name!);
TempData["OK"] = "Registro eliminado.";
```

Por:

```csharp
var (resultado, mensaje) = await _repo.DeleteAsync(id, User.Identity!.Name!);
TempData[resultado ? "OK" : "ERR"] = mensaje;
return RedirectToAction(nameof(Index));
```

En `CuentasController`, cambiar `CerrarAsync` igual:

```csharp
var (resultado, mensaje) = await _repo.CerrarAsync(id, User.Identity!.Name!);
TempData[resultado ? "OK" : "ERR"] = mensaje;
return RedirectToAction(nameof(Index));
```

## 5. Views

No es obligatorio modificar vistas para que compile, excepto si se agrega busqueda nueva con `BuscarAsync`.

Para mostrar errores de `ModelState`, validar que las vistas `Crear.cshtml` y `Editar.cshtml` tengan:

```html
<div asp-validation-summary="ModelOnly" class="text-danger"></div>
```

Los modulos existentes que deben revisarse son:

- `Views\Clientes\Crear.cshtml`
- `Views\Clientes\Editar.cshtml`
- `Views\Cuentas\Crear.cshtml`
- `Views\Cuentas\Editar.cshtml`
- `Views\TiposCuenta\Crear.cshtml`
- `Views\TiposCuenta\Editar.cshtml`
- `Views\TiposTransaccion\Crear.cshtml`
- `Views\TiposTransaccion\Editar.cshtml`

## 6. Reportes SQL disponibles

- `usp_ReporteClientesPorTipo`
- `usp_ReporteSaldosPorSucursal`
- `usp_ReporteTransaccionesPorTipo`

Se pueden consumir desde un nuevo `ReportesController` usando `QueryAsync` con `CommandType.StoredProcedure`.

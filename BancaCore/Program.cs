using BancaCore.Data;
using BancaCore.Data.Repositories;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.IO;

var builder = WebApplication.CreateBuilder(args);

// MVC
builder.Services.AddControllersWithViews();

// DI - Data layer
builder.Services.AddSingleton<DbContext>();
builder.Services.AddScoped<ClienteRepository>();
builder.Services.AddScoped<SucursalRepository>();
builder.Services.AddScoped<CuentaRepository>();
builder.Services.AddScoped<TransaccionRepository>();
builder.Services.AddScoped<PrestamoRepository>();
builder.Services.AddScoped<UsuarioRepository>();
builder.Services.AddScoped<CatalogosRepository>();
// Newly added repositories
builder.Services.AddScoped<MonedaRepository>();
builder.Services.AddScoped<TipoCuentaRepository>();
builder.Services.AddScoped<TipoTransaccionRepository>();
builder.Services.AddScoped<TipoPrestamoRepository>();
builder.Services.AddScoped<TipoTarjetaRepository>();
builder.Services.AddScoped<TarjetaRepository>();
builder.Services.AddScoped<PagoPrestamoRepository>();
builder.Services.AddScoped<UsuarioSistemaRepository>();
builder.Services.AddScoped<AuditoriaRepository>();

// Cookie Auth
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(opt =>
    {
        opt.LoginPath    = "/Auth/Login";
        opt.LogoutPath   = "/Auth/Logout";
        opt.AccessDeniedPath = "/Auth/Acceso";
        opt.ExpireTimeSpan = TimeSpan.FromHours(8);
    });

builder.Services.AddSession(opt =>
{
    opt.IdleTimeout = TimeSpan.FromHours(8);
    opt.Cookie.HttpOnly = true;
});

var app = builder.Build();

// Ejecutar scripts SQL de StoredProcedures al arrancar
async Task ExecuteSqlScriptsAsync(IHostEnvironment env, IConfiguration config)
{
    var connStr = config.GetConnectionString("BancaDB");
    if (string.IsNullOrWhiteSpace(connStr)) return;

    var scriptsFolder = Path.Combine(env.ContentRootPath, "BancaCore", "Database", "StoredProcedures");
    if (!Directory.Exists(scriptsFolder)) return;

    var files = Directory.GetFiles(scriptsFolder, "*.sql").OrderBy(f => f);
    await using var conn = new SqlConnection(connStr);
    await conn.OpenAsync();

    foreach (var file in files)
    {
        var script = await File.ReadAllTextAsync(file);
        var batches = Regex.Split(script, @"^\s*GO\s*;?\s*$", RegexOptions.Multiline | RegexOptions.IgnoreCase);
        foreach (var batch in batches)
        {
            if (string.IsNullOrWhiteSpace(batch)) continue;
            await using var cmd = conn.CreateCommand();
            cmd.CommandText = batch;
            await cmd.ExecuteNonQueryAsync();
        }
    }

    await conn.CloseAsync();
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

app.UseSession();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Auth}/{action=Login}/{id?}");

try
{
    await ExecuteSqlScriptsAsync(app.Environment, app.Configuration);
}
catch (Exception ex)
{
    // opcional: registrar el error; lanzar para ver fallo al iniciar
    throw;
}

app.Run();

using BancaCore.Data;
using BancaCore.Data.Repositories;
using Microsoft.AspNetCore.Authentication.Cookies;

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

app.Run();

using System.ComponentModel.DataAnnotations;

namespace BancaCore.Models
{
    public class Cliente
    {
        public int IdCliente { get; set; }

        [Required] [Display(Name = "Tipo Cliente")]
        public string TipoCliente { get; set; } = "INDIVIDUAL";

        [Required] [Display(Name = "Nombres")]
        public string Nombres { get; set; } = "";

        [Required] [Display(Name = "Apellidos")]
        public string Apellidos { get; set; } = "";

        [Display(Name = "DPI")]
        public string? DPI { get; set; }

        [Display(Name = "NIT")]
        public string? NIT { get; set; }

        [Required] [DataType(DataType.Date)] [Display(Name = "Fecha Nacimiento")]
        public DateTime FechaNacimiento { get; set; }

        [Required] [Display(Name = "Teléfono")]
        public string Telefono { get; set; } = "";

        [Required] [EmailAddress] [Display(Name = "Email")]
        public string Email { get; set; } = "";

        [Required] [Display(Name = "Dirección")]
        public string Direccion { get; set; } = "";

        public bool Estado { get; set; } = true;
        [ScaffoldColumn(false)]
        public string? UsuarioCreacion { get; set; }
        [ScaffoldColumn(false)]
        public DateTime? FechaCreacion { get; set; }
        public string? UsuarioModificacion { get; set; }
        public DateTime? FechaModificacion { get; set; }

        public string NombreCompleto => $"{Nombres} {Apellidos}";
    }

    public class Sucursal
    {
        public int CodigoSucursal { get; set; }

        [Required] [Display(Name = "Nombre")]
        public string Nombre { get; set; } = "";

        [Required] [Display(Name = "Dirección")]
        public string Direccion { get; set; } = "";

        [Required] [Display(Name = "Teléfono")]
        public string Telefono { get; set; } = "";

        public bool Estado { get; set; } = true;
        [ScaffoldColumn(false)]
        public string? UsuarioCreacion { get; set; }
        [ScaffoldColumn(false)]
        public DateTime? FechaCreacion { get; set; }
        // Función integrada: nombre obtenido mediante dbo.fn_NombreSucursal
        public string NombreFunc { get; set; } = "";
    }

    public class Moneda
    {
        public int CodigoMoneda { get; set; }

        [Required] [Display(Name = "Nombre")]
        public string Nombre { get; set; } = "";

        [Required] [Display(Name = "Símbolo")]
        public string Simbolo { get; set; } = "";

        [Required] [Display(Name = "Tipo de Cambio")]
        public decimal TipoCambio { get; set; }

        public bool Estado { get; set; } = true;
        // Tipo de cambio obtenido mediante función dbo.fn_TipoCambioMoneda
        public decimal TipoCambioFunc { get; set; }
    }

    public class TipoCuenta
    {
        public int CodigoTipoCuenta { get; set; }

        [Required] [Display(Name = "Nombre")]
        public string Nombre { get; set; } = "";

        [Display(Name = "Saldo Mínimo")]
        public decimal SaldoMinimo { get; set; }

        [Display(Name = "Tasa Interés (%)")]
        public decimal TasaInteres { get; set; }

        public bool Estado { get; set; } = true;
    }

    public class CuentaBancaria
    {
        public int CodigoCuenta { get; set; }

        [Display(Name = "Número de Cuenta")]
        public string NumeroCuenta { get; set; } = "";

        [Display(Name = "Cliente")]
        public int CodigoCliente { get; set; }

        [Display(Name = "Sucursal")]
        public int CodigoSucursal { get; set; }

        [Display(Name = "Tipo de Cuenta")]
        public int CodigoTipoCuenta { get; set; }

        [Display(Name = "Moneda")]
        public int CodigoMoneda { get; set; }

        [Display(Name = "Saldo Actual")]
        public decimal SaldoActual { get; set; }

        [DataType(DataType.Date)] [Display(Name = "Fecha Apertura")]
        public DateTime FechaApertura { get; set; }

        public bool Estado { get; set; } = true;
        [ScaffoldColumn(false)]
        public string? UsuarioCreacion { get; set; }
        [ScaffoldColumn(false)]
        public DateTime? FechaCreacion { get; set; }

        // Navegación (join)
        public string NombreCliente { get; set; } = "";
        public string NombreSucursal { get; set; } = "";
        public string NombreTipoCuenta { get; set; } = "";
        public string SimboloMoneda { get; set; } = "";
    }

    public class TipoTarjeta
    {
        public int CodigoTipoTarjeta { get; set; }
        public string Nombre { get; set; } = "";
        public bool Estado { get; set; } = true;
        // Nombre obtenido mediante función dbo.fn_NombreTipoTarjeta
        public string NombreFunc { get; set; } = "";
    }

    public class Tarjeta
    {
        public int CodigoTarjeta { get; set; }

        [Required] [Display(Name = "Número Tarjeta")]
        public string NumeroTarjeta { get; set; } = "";

        [Display(Name = "Cuenta")]
        public int CodigoCuenta { get; set; }

        [Display(Name = "Tipo Tarjeta")]
        public int CodigoTipoTarjeta { get; set; }

        [Display(Name = "Límite de Crédito")]
        public decimal? LimiteCredito { get; set; }

        [Display(Name = "Saldo Utilizado")]
        public decimal? SaldoUtilizado { get; set; }

        [DataType(DataType.Date)] [Display(Name = "Fecha Emisión")]
        public DateTime FechaEmision { get; set; }

        [DataType(DataType.Date)] [Display(Name = "Fecha Vencimiento")]
        public DateTime FechaVencimiento { get; set; }

        public bool Estado { get; set; } = true;
        public string NumeroCuenta { get; set; } = "";
        public string NombreTipoTarjeta { get; set; } = "";
        public string NombreCliente { get; set; } = "";
        // Disponible calculado mediante dbo.fn_DisponibleTarjeta
        public decimal Disponible { get; set; }
        // Nombre tipo tarjeta desde función
        public string NombreTipoTarjetaFunc { get; set; } = "";
    }

    public class TipoPrestamo
    {
        public int CodigoTipoPrestamo { get; set; }
        public string Nombre { get; set; } = "";
        public decimal TasaInteres { get; set; }
        public int PlazoMaximoMeses { get; set; }
        public bool Estado { get; set; } = true;
        // Tasa desde función dbo.fn_TasaTipoPrestamo
        public decimal TasaDesdeFuncion { get; set; }
    }

    public class Prestamo
    {
        public int CodigoPrestamo { get; set; }

        [Display(Name = "Cliente")] public int CodigoCliente { get; set; }
        [Display(Name = "Sucursal")] public int CodigoSucursal { get; set; }
        [Display(Name = "Tipo Préstamo")] public int CodigoTipoPrestamo { get; set; }
        [Display(Name = "Moneda")] public int CodigoMoneda { get; set; }

        [Required] [Display(Name = "Monto Solicitado")]
        public decimal MontoSolicitado { get; set; }

        [Display(Name = "Tasa Interés (%)")]
        public decimal TasaInteres { get; set; }

        [Display(Name = "Plazo (meses)")]
        public int PlazoMeses { get; set; }

        [DataType(DataType.Date)] [Display(Name = "Fecha Desembolso")]
        public DateTime FechaDesembolso { get; set; }

        [Display(Name = "Saldo Pendiente")]
        public decimal SaldoPendiente { get; set; }

        public bool Estado { get; set; } = true;
        public string? UsuarioCreacion { get; set; }
        public DateTime? FechaCreacion { get; set; }

        public string NombreCliente { get; set; } = "";
        public string NombreTipoPrestamo { get; set; } = "";
        public string NombreMoneda { get; set; } = "";
        public string SimboloMoneda { get; set; } = "";
        public string NombreSucursal { get; set; } = "";
        // Campos calculados por funciones de BD
        public decimal CuotaPrestamo { get; set; }
        public decimal TasaDesdeFuncion { get; set; }
        public string NombreSucursalFunc { get; set; } = "";
    }

    public class TipoTransaccion
    {
        public int CodigoTipoTransaccion { get; set; }
        public string Nombre { get; set; } = "";
        public bool Estado { get; set; } = true;
    }

    public class Transaccion
    {
        public int CodigoTransaccion { get; set; }
        public int? CodigoCuentaOrigen { get; set; }
        public int? CodigoCuentaDestino { get; set; }

        [Required] [Display(Name = "Tipo Transacción")]
        public int CodigoTipoTransaccion { get; set; }

        [Display(Name = "Moneda")] public int CodigoMoneda { get; set; }

        [Required] [Display(Name = "Monto")]
        public decimal Monto { get; set; }

        public decimal TipoCambioAplicado { get; set; } = 1;
        public DateTime FechaHora { get; set; }

        [Display(Name = "Descripción")]
        public string? Descripcion { get; set; }

        public bool Estado { get; set; } = true;
        public string? UsuarioCreacion { get; set; }

        public string NumeroCuentaOrigen { get; set; } = "";
        public string NumeroCuentaDestino { get; set; } = "";
        public string NombreTipoTransaccion { get; set; } = "";
        public string SimboloMoneda { get; set; } = "";
        public string NombreCliente { get; set; } = "";
    }

    public class UsuarioSistema
    {
        public int CodigoUsuario { get; set; }
        public int CodigoSucursal { get; set; }

        [Required] public string Usuario { get; set; } = "";
        [Required] public string Contraseña { get; set; } = "";
        [Required] [EmailAddress] public string CorreoRecuperacion { get; set; } = "";
        [Required] public string Rol { get; set; } = "CAJERO";

        public bool Estado { get; set; } = true;
        public string NombreSucursal { get; set; } = "";
    }

    public class PagoPrestamo
    {
        public int CodigoPagoPrestamo { get; set; }
        public int CodigoPrestamo { get; set; }
        public int CodigoTransaccion { get; set; }
        public decimal MontoCapital { get; set; }
        public decimal MontoInteres { get; set; }
        [DataType(DataType.Date)] public DateTime FechaPago { get; set; }
        public bool Estado { get; set; } = true;
        public string? UsuarioCreacion { get; set; }
        public DateTime? FechaCreacion { get; set; }
    }

    public class Auditoria
    {
        public int CodigoAuditoria { get; set; }
        public string TablaAfectada { get; set; } = "";
        public string Accion { get; set; } = "";
        public int RegistroId { get; set; }
        public string Usuario { get; set; } = "";
        public DateTime FechaHora { get; set; }
        public string? ValoresAnteriores { get; set; }
        public string? ValoresNuevos { get; set; }
    }
}

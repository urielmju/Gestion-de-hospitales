using System;

namespace Sistemahospital.Models
{
    public class Pago
    {
        public int IDPago { get; set; }
        public int IDPaciente { get; set; }
        public string NombrePaciente { get; set; }
        public int IDTratamiento { get; set; }
        public string DescripcionTratamiento { get; set; }
        public int IDHospital { get; set; }
        public string NombreHospital { get; set; }
        public DateTime Fecha { get; set; }
        public decimal Monto { get; set; }
        public string MetodoPago { get; set; }
        public string Estado { get; set; }
    }
}
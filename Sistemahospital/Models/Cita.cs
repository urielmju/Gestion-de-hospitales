using System;

namespace Sistemahospital.Models
{
    public class Cita
    {
        public int IDCita { get; set; }
        public int IDPaciente { get; set; }
        public string NombrePaciente { get; set; }
        public int IDMedico { get; set; }
        public string NombreMedico { get; set; }
        public int IDHospital { get; set; }
        public string NombreHospital { get; set; }
        public DateTime FechaHora { get; set; }
        public string Diagnostico { get; set; }
        public string Estado { get; set; }
    }
}
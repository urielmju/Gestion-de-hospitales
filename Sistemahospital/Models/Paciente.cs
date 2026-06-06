using System;

namespace Sistemahospital.Models
{
    public class Paciente
    {
        public int IDPaciente { get; set; }
        public int IDHospital { get; set; }
        public string NombreHospital { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public DateTime FechaNacimiento { get; set; }
        public string Genero { get; set; }
        public string Direccion { get; set; }
        public string Telefono { get; set; }
        public string Email { get; set; }
        public string Estado { get; set; }
    }
}
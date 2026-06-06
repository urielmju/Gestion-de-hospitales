namespace Sistemahospital.Models
{
    public class Medico
    {
        public int IDMedico { get; set; }
        public int IDHospital { get; set; }
        public string NombreHospital { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Especialidad { get; set; }
        public string Telefono { get; set; }
        public string Email { get; set; }
        public string Estado { get; set; }
    }
}
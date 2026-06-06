namespace Sistemahospital.Models
{
    public class Usuario
    {
        public int IDUsuario { get; set; }
        public int IDRol { get; set; }
        public string NombreRol { get; set; }
        public int? IDHospital { get; set; }
        public int? IDMedico { get; set; }
        public int? IDPaciente { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
    }
}
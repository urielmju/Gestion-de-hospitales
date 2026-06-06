namespace Sistemahospital.Models
{
    public class Tratamiento
    {
        public int IDTratamiento { get; set; }
        public int IDCita { get; set; }
        public string Descripcion { get; set; }
        public decimal CostoTotal { get; set; }
        public System.DateTime FechaInicio { get; set; }
        public string Estado { get; set; }
    }

    public class Prescripcion
    {
        public int IDPrescripcion { get; set; }
        public int IDTratamiento { get; set; }
        public int IDMedicamento { get; set; }
        public string NombreMedicamento { get; set; }
        public int IDHospital { get; set; }
        public int Cantidad { get; set; }
        public string Dosis { get; set; }
        public string Frecuencia { get; set; }
    }

    public class AtencionViewModel
    {
        public Cita Cita { get; set; }
        public Paciente Paciente { get; set; }
        public System.Collections.Generic.List<Medicamento> MedicamentosDisponibles { get; set; }
        public string Diagnostico { get; set; }
        public string DescripcionTratamiento { get; set; }
    }
}
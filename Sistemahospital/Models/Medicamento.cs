namespace Sistemahospital.Models
{
    public class Medicamento
    {
        public int IDMedicamento { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public decimal CostoPorUnidad { get; set; }
        public string UnidadMedida { get; set; }
        public string Estado { get; set; }
        public int StockHospital { get; set; }
    }
}
using System.Data.SqlClient;

namespace Sistemahospital.Database
{
    public class ConexionDB
    {
        private readonly string _connectionString =
            "Server=FRANKIE;Database=SistemaHospitales;Trusted_Connection=True;";

        public SqlConnection ObtenerConexion()
        {
            return new SqlConnection(_connectionString);
        }
    }
}
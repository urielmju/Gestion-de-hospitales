using System.Configuration;
using System.Data.SqlClient;

namespace Sistemahospital.Database
{
    public class ConexionDB
    {
        private readonly string _connectionString =
            ConfigurationManager.ConnectionStrings["SistemaHospitalesDB"].ConnectionString;

        public SqlConnection ObtenerConexion()
        {
            return new SqlConnection(_connectionString);
        }
    }
}
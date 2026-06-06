using System;
using System.Data.SqlClient;
using Sistemahospital.Database;
using Sistemahospital.Models;

namespace Sistemahospital.Repositories
{
    public class UsuarioRepository
    {
        private readonly ConexionDB _db = new ConexionDB();

        public Usuario Login(string username, string password)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    SELECT U.IDUsuario, U.IDRol, R.NombreRol, U.IDHospital, 
                           U.IDMedico, U.IDPaciente, U.Username, U.Email
                    FROM USUARIOS U
                    INNER JOIN ROLES R ON U.IDRol = R.IDRol
                    WHERE U.Username = @Username 
                      AND U.PasswordHash = @Password
                      AND U.Estado = 'A'", con);

                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);

                var reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    return new Usuario
                    {
                        IDUsuario = (int)reader["IDUsuario"],
                        IDRol = (int)reader["IDRol"],
                        NombreRol = reader["NombreRol"].ToString(),
                        IDHospital = reader["IDHospital"] == DBNull.Value ? (int?)null : (int)reader["IDHospital"],
                        IDMedico = reader["IDMedico"] == DBNull.Value ? (int?)null : (int)reader["IDMedico"],
                        IDPaciente = reader["IDPaciente"] == DBNull.Value ? (int?)null : (int)reader["IDPaciente"],
                        Username = reader["Username"].ToString(),
                        Email = reader["Email"] == DBNull.Value ? "" : reader["Email"].ToString()
                    };
                }
                return null;
            }
        }
    }
}
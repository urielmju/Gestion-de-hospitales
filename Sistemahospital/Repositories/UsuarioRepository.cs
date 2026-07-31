using System;
using System.Data.SqlClient;
using Sistemahospital.Database;
using Sistemahospital.Models;
using Sistemahospital.Seguridad;

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
                           U.IDMedico, U.IDPaciente, U.Username, U.Email, U.PasswordHash
                    FROM USUARIOS U
                    INNER JOIN ROLES R ON U.IDRol = R.IDRol
                    WHERE U.Username = @Username
                      AND U.Estado = 'A'", con);

                cmd.Parameters.AddWithValue("@Username", username);

                var reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    var hash = reader["PasswordHash"].ToString();
                    if (!HashContrasena.Verificar(password, hash))
                        return null;

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

        public void CrearStaff(int idRol, int idHospital, string nombre, string apellido,
            string username, string password, string email)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    INSERT INTO USUARIOS (IDRol, IDHospital, Nombre, Apellido, Username, PasswordHash, Email, FechaCreacion, Estado)
                    VALUES (@IDRol, @IDHospital, @Nombre, @Apellido, @Username, @Password, @Email, GETDATE(), 'A')", con);

                cmd.Parameters.AddWithValue("@IDRol", idRol);
                cmd.Parameters.AddWithValue("@IDHospital", idHospital);
                cmd.Parameters.AddWithValue("@Nombre", nombre);
                cmd.Parameters.AddWithValue("@Apellido", apellido);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", HashContrasena.Generar(password));
                cmd.Parameters.AddWithValue("@Email", (object)email ?? DBNull.Value);

                cmd.ExecuteNonQuery();
            }
        }
    }
}
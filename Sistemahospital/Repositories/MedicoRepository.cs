using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Sistemahospital.Database;
using Sistemahospital.Models;

namespace Sistemahospital.Repositories
{
    public class MedicoRepository
    {
        private readonly ConexionDB _db = new ConexionDB();

        public List<Medico> ObtenerTodos()
        {
            var lista = new List<Medico>();
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    SELECT M.*, H.Nombre AS NombreHospital 
                    FROM MEDICOS M
                    INNER JOIN HOSPITALES H ON M.IDHospital = H.IDHospital
                    WHERE M.Estado = 'A'
                    ORDER BY M.Apellido, M.Nombre", con);

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(new Medico
                    {
                        IDMedico = (int)r["IDMedico"],
                        IDHospital = (int)r["IDHospital"],
                        NombreHospital = r["NombreHospital"].ToString(),
                        Nombre = r["Nombre"].ToString(),
                        Apellido = r["Apellido"].ToString(),
                        Especialidad = r["Especialidad"].ToString(),
                        Telefono = r["Telefono"].ToString(),
                        Email = r["Email"].ToString(),
                        Estado = r["Estado"].ToString()
                    });
                }
            }
            return lista;
        }

        public Medico ObtenerPorId(int id)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    SELECT M.*, H.Nombre AS NombreHospital 
                    FROM MEDICOS M
                    INNER JOIN HOSPITALES H ON M.IDHospital = H.IDHospital
                    WHERE M.IDMedico = @ID", con);
                cmd.Parameters.AddWithValue("@ID", id);

                var r = cmd.ExecuteReader();
                if (r.Read())
                {
                    return new Medico
                    {
                        IDMedico = (int)r["IDMedico"],
                        IDHospital = (int)r["IDHospital"],
                        NombreHospital = r["NombreHospital"].ToString(),
                        Nombre = r["Nombre"].ToString(),
                        Apellido = r["Apellido"].ToString(),
                        Especialidad = r["Especialidad"].ToString(),
                        Telefono = r["Telefono"].ToString(),
                        Email = r["Email"].ToString(),
                        Estado = r["Estado"].ToString()
                    };
                }
                return null;
            }
        }

        public void Crear(Medico m, string username, string password)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var trans = con.BeginTransaction();
                try
                {
                    var cmdMedico = new SqlCommand(@"
                INSERT INTO MEDICOS (IDHospital, Nombre, Apellido, Especialidad, Telefono, Email, FechaContratacion)
                VALUES (@IDHospital, @Nombre, @Apellido, @Especialidad, @Telefono, @Email, GETDATE());
                SELECT SCOPE_IDENTITY();", con, trans);

                    cmdMedico.Parameters.AddWithValue("@IDHospital", m.IDHospital);
                    cmdMedico.Parameters.AddWithValue("@Nombre", m.Nombre);
                    cmdMedico.Parameters.AddWithValue("@Apellido", m.Apellido);
                    cmdMedico.Parameters.AddWithValue("@Especialidad", m.Especialidad);
                    cmdMedico.Parameters.AddWithValue("@Telefono", (object)m.Telefono ?? DBNull.Value);
                    cmdMedico.Parameters.AddWithValue("@Email", (object)m.Email ?? DBNull.Value);

                    int idMedico = Convert.ToInt32(cmdMedico.ExecuteScalar());
                    var cmdUsuario = new SqlCommand(@"
                INSERT INTO USUARIOS (IDRol, IDHospital, IDMedico, Username, PasswordHash, Email)
                VALUES (2, @IDHospital, @IDMedico, @Username, @Password, @Email)", con, trans);

                    cmdUsuario.Parameters.AddWithValue("@IDHospital", m.IDHospital);
                    cmdUsuario.Parameters.AddWithValue("@IDMedico", idMedico);
                    cmdUsuario.Parameters.AddWithValue("@Username", username);
                    cmdUsuario.Parameters.AddWithValue("@Password", password);
                    cmdUsuario.Parameters.AddWithValue("@Email", (object)m.Email ?? DBNull.Value);

                    cmdUsuario.ExecuteNonQuery();
                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }

        public void Editar(Medico m)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    UPDATE MEDICOS SET 
                        Nombre = @Nombre, Apellido = @Apellido,
                        Especialidad = @Especialidad,
                        Telefono = @Telefono, Email = @Email
                    WHERE IDMedico = @ID", con);

                cmd.Parameters.AddWithValue("@ID", m.IDMedico);
                cmd.Parameters.AddWithValue("@Nombre", m.Nombre);
                cmd.Parameters.AddWithValue("@Apellido", m.Apellido);
                cmd.Parameters.AddWithValue("@Especialidad", m.Especialidad);
                cmd.Parameters.AddWithValue("@Telefono", (object)m.Telefono ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Email", (object)m.Email ?? DBNull.Value);
                cmd.ExecuteNonQuery();
            }
        }

        public void Eliminar(int id)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand("UPDATE MEDICOS SET Estado = 'I' WHERE IDMedico = @ID", con);
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
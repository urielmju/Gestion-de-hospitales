using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Sistemahospital.Database;
using Sistemahospital.Models;

namespace Sistemahospital.Repositories
{
    public class PacienteRepository
    {
        private readonly ConexionDB _db = new ConexionDB();

        public List<Paciente> ObtenerTodos(int? idHospital = null)
        {
            var lista = new List<Paciente>();
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var sql = @"
                    SELECT P.*, H.Nombre AS NombreHospital 
                    FROM PACIENTES P
                    INNER JOIN HOSPITALES H ON P.IDHospital = H.IDHospital
                    WHERE P.Estado = 'A'";

                if (idHospital.HasValue)
                    sql += " AND P.IDHospital = @IDHospital";

                sql += " ORDER BY P.Apellido, P.Nombre";

                var cmd = new SqlCommand(sql, con);
                if (idHospital.HasValue)
                    cmd.Parameters.AddWithValue("@IDHospital", idHospital.Value);

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(MapPaciente(r));
                }
            }
            return lista;
        }

        public Paciente ObtenerPorId(int id)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    SELECT P.*, H.Nombre AS NombreHospital 
                    FROM PACIENTES P
                    INNER JOIN HOSPITALES H ON P.IDHospital = H.IDHospital
                    WHERE P.IDPaciente = @ID", con);
                cmd.Parameters.AddWithValue("@ID", id);

                var r = cmd.ExecuteReader();
                if (r.Read())
                    return MapPaciente(r);
                return null;
            }
        }

        public void Crear(Paciente p, string username, string password)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var trans = con.BeginTransaction();
                try
                {
                    var cmdPaciente = new SqlCommand(@"
                        INSERT INTO PACIENTES (IDHospital, Nombre, Apellido, FechaNacimiento, Genero, Direccion, Telefono, Email)
                        VALUES (@IDHospital, @Nombre, @Apellido, @FechaNacimiento, @Genero, @Direccion, @Telefono, @Email);
                        SELECT SCOPE_IDENTITY();", con, trans);

                    cmdPaciente.Parameters.AddWithValue("@IDHospital", p.IDHospital);
                    cmdPaciente.Parameters.AddWithValue("@Nombre", p.Nombre);
                    cmdPaciente.Parameters.AddWithValue("@Apellido", p.Apellido);
                    cmdPaciente.Parameters.AddWithValue("@FechaNacimiento", p.FechaNacimiento);
                    cmdPaciente.Parameters.AddWithValue("@Genero", p.Genero);
                    cmdPaciente.Parameters.AddWithValue("@Direccion", (object)p.Direccion ?? DBNull.Value);
                    cmdPaciente.Parameters.AddWithValue("@Telefono", (object)p.Telefono ?? DBNull.Value);
                    cmdPaciente.Parameters.AddWithValue("@Email", (object)p.Email ?? DBNull.Value);

                    int idPaciente = Convert.ToInt32(cmdPaciente.ExecuteScalar());

                    var cmdUsuario = new SqlCommand(@"
                        INSERT INTO USUARIOS (IDRol, IDHospital, IDPaciente, Username, PasswordHash, Email)
                        VALUES (1, @IDHospital, @IDPaciente, @Username, @Password, @Email)", con, trans);

                    cmdUsuario.Parameters.AddWithValue("@IDHospital", p.IDHospital);
                    cmdUsuario.Parameters.AddWithValue("@IDPaciente", idPaciente);
                    cmdUsuario.Parameters.AddWithValue("@Username", username);
                    cmdUsuario.Parameters.AddWithValue("@Password", password);
                    cmdUsuario.Parameters.AddWithValue("@Email", (object)p.Email ?? DBNull.Value);

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

        public void Editar(Paciente p)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    UPDATE PACIENTES SET 
                        Nombre = @Nombre, Apellido = @Apellido,
                        FechaNacimiento = @FechaNacimiento, Genero = @Genero,
                        Direccion = @Direccion, Telefono = @Telefono, Email = @Email
                    WHERE IDPaciente = @ID", con);

                cmd.Parameters.AddWithValue("@ID", p.IDPaciente);
                cmd.Parameters.AddWithValue("@Nombre", p.Nombre);
                cmd.Parameters.AddWithValue("@Apellido", p.Apellido);
                cmd.Parameters.AddWithValue("@FechaNacimiento", p.FechaNacimiento);
                cmd.Parameters.AddWithValue("@Genero", p.Genero);
                cmd.Parameters.AddWithValue("@Direccion", (object)p.Direccion ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Telefono", (object)p.Telefono ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Email", (object)p.Email ?? DBNull.Value);
                cmd.ExecuteNonQuery();
            }
        }

        public void Eliminar(int id)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand("UPDATE PACIENTES SET Estado = 'I' WHERE IDPaciente = @ID", con);
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.ExecuteNonQuery();
            }
        }

        public List<Paciente> Buscar(string nombre, string apellido, int? idHospital)
        {
            var lista = new List<Paciente>();
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand("EXEC sp_BuscarPacientes @Nombre, @Apellido, @IDHospital, @Estado", con);
                cmd.Parameters.AddWithValue("@Nombre", (object)nombre ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Apellido", (object)apellido ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@IDHospital", (object)idHospital ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Estado", "A");

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(new Paciente
                    {
                        IDPaciente = (int)r["IDPaciente"],
                        NombreHospital = r["NombreHospital"].ToString(),
                        Nombre = r["Nombre"].ToString(),
                        Apellido = r["Apellido"].ToString(),
                        Telefono = r["Telefono"].ToString(),
                        Email = r["Email"].ToString(),
                        Estado = r["Estado"].ToString()
                    });
                }
            }
            return lista;
        }

        private Paciente MapPaciente(SqlDataReader r)
        {
            return new Paciente
            {
                IDPaciente = (int)r["IDPaciente"],
                IDHospital = (int)r["IDHospital"],
                NombreHospital = r["NombreHospital"].ToString(),
                Nombre = r["Nombre"].ToString(),
                Apellido = r["Apellido"].ToString(),
                FechaNacimiento = (DateTime)r["FechaNacimiento"],
                Genero = r["Genero"].ToString(),
                Direccion = r["Direccion"] == DBNull.Value ? "" : r["Direccion"].ToString(),
                Telefono = r["Telefono"] == DBNull.Value ? "" : r["Telefono"].ToString(),
                Email = r["Email"] == DBNull.Value ? "" : r["Email"].ToString(),
                Estado = r["Estado"].ToString()
            };
        }
    }
}
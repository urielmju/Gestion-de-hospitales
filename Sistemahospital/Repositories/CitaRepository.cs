using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Sistemahospital.Database;
using Sistemahospital.Models;

namespace Sistemahospital.Repositories
{
    public class CitaRepository
    {
        private readonly ConexionDB _db = new ConexionDB();

        public List<Cita> ObtenerTodos()
        {
            var lista = new List<Cita>();
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    SELECT C.IDCita, C.FechaHora, C.Diagnostico, C.Estado,
                        P.Nombre + ' ' + P.Apellido AS NombrePaciente,
                        M.Nombre + ' ' + M.Apellido AS NombreMedico,
                        H.Nombre AS NombreHospital,
                        C.IDPaciente, C.IDMedico, C.IDHospital
                    FROM CITAS C
                    INNER JOIN PACIENTES P ON C.IDPaciente = P.IDPaciente
                    INNER JOIN MEDICOS M ON C.IDMedico = M.IDMedico
                    INNER JOIN HOSPITALES H ON C.IDHospital = H.IDHospital
                    ORDER BY C.FechaHora DESC", con);

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(MapCita(r));
                }
            }
            return lista;
        }

        public List<Cita> ObtenerPorHospital(int idHospital)
        {
            var lista = new List<Cita>();
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    SELECT C.IDCita, C.FechaHora, C.Diagnostico, C.Estado,
                        P.Nombre + ' ' + P.Apellido AS NombrePaciente,
                        M.Nombre + ' ' + M.Apellido AS NombreMedico,
                        H.Nombre AS NombreHospital,
                        C.IDPaciente, C.IDMedico, C.IDHospital
                    FROM CITAS C
                    INNER JOIN PACIENTES P ON C.IDPaciente = P.IDPaciente
                    INNER JOIN MEDICOS M ON C.IDMedico = M.IDMedico
                    INNER JOIN HOSPITALES H ON C.IDHospital = H.IDHospital
                    WHERE C.IDHospital = @IDHospital
                    ORDER BY C.FechaHora DESC", con);
                cmd.Parameters.AddWithValue("@IDHospital", idHospital);

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(MapCita(r));
                }
            }
            return lista;
        }

        public Cita ObtenerPorId(int id)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    SELECT C.IDCita, C.FechaHora, C.Diagnostico, C.Estado,
                        P.Nombre + ' ' + P.Apellido AS NombrePaciente,
                        M.Nombre + ' ' + M.Apellido AS NombreMedico,
                        H.Nombre AS NombreHospital,
                        C.IDPaciente, C.IDMedico, C.IDHospital
                    FROM CITAS C
                    INNER JOIN PACIENTES P ON C.IDPaciente = P.IDPaciente
                    INNER JOIN MEDICOS M ON C.IDMedico = M.IDMedico
                    INNER JOIN HOSPITALES H ON C.IDHospital = H.IDHospital
                    WHERE C.IDCita = @ID", con);
                cmd.Parameters.AddWithValue("@ID", id);

                var r = cmd.ExecuteReader();
                if (r.Read())
                    return MapCita(r);
                return null;
            }
        }

        public void Crear(int idPaciente, int idMedico, int idHospital, DateTime fechaHora)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand("EXEC sp_RegistrarCita @IDPaciente, @IDMedico, @IDHospital, @FechaHora", con);
                cmd.Parameters.AddWithValue("@IDPaciente", idPaciente);
                cmd.Parameters.AddWithValue("@IDMedico", idMedico);
                cmd.Parameters.AddWithValue("@IDHospital", idHospital);
                cmd.Parameters.AddWithValue("@FechaHora", fechaHora);
                cmd.ExecuteNonQuery();
            }
        }

        public void ActualizarEstado(int id, string estado, string diagnostico)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    UPDATE CITAS SET Estado = @Estado, Diagnostico = @Diagnostico
                    WHERE IDCita = @ID", con);
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.Parameters.AddWithValue("@Estado", estado);
                cmd.Parameters.AddWithValue("@Diagnostico", (object)diagnostico ?? DBNull.Value);
                cmd.ExecuteNonQuery();
            }
        }

        public void Cancelar(int id)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand("UPDATE CITAS SET Estado = 'CA' WHERE IDCita = @ID", con);
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.ExecuteNonQuery();
            }
        }

        private Cita MapCita(SqlDataReader r)
        {
            return new Cita
            {
                IDCita = (int)r["IDCita"],
                IDPaciente = (int)r["IDPaciente"],
                NombrePaciente = r["NombrePaciente"].ToString(),
                IDMedico = (int)r["IDMedico"],
                NombreMedico = r["NombreMedico"].ToString(),
                IDHospital = (int)r["IDHospital"],
                NombreHospital = r["NombreHospital"].ToString(),
                FechaHora = (DateTime)r["FechaHora"],
                Diagnostico = r["Diagnostico"] == DBNull.Value ? "" : r["Diagnostico"].ToString(),
                Estado = r["Estado"].ToString()
            };
        }
    }
}
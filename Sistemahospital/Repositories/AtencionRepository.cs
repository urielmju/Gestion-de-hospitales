using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Sistemahospital.Database;
using Sistemahospital.Models;

namespace Sistemahospital.Repositories
{
    public class AtencionRepository
    {
        private readonly ConexionDB _db = new ConexionDB();

        public List<Cita> ObtenerCitasMedico(int idMedico)
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
                    WHERE C.IDMedico = @IDMedico AND C.Estado = 'P'
                    ORDER BY C.FechaHora ASC", con);
                cmd.Parameters.AddWithValue("@IDMedico", idMedico);

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(new Cita
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
                    });
                }
            }
            return lista;
        }

        public void RegistrarAtencion(int idCita, int idPaciente, int idHospital,
            string diagnostico, string descripcionTratamiento, decimal costoTotal,
            List<Prescripcion> prescripciones)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var trans = con.BeginTransaction();
                try
                {
                    // actualizar diagnostico y estado de la cita
                    var cmdCita = new SqlCommand(@"
                        UPDATE CITAS SET Diagnostico = @Diagnostico, Estado = 'C'
                        WHERE IDCita = @IDCita", con, trans);
                    cmdCita.Parameters.AddWithValue("@Diagnostico", diagnostico);
                    cmdCita.Parameters.AddWithValue("@IDCita", idCita);
                    cmdCita.ExecuteNonQuery();

                    // crear tratamiento
                    var cmdTrat = new SqlCommand(@"
                        INSERT INTO TRATAMIENTOS (IDCita, Descripcion, CostoTotal, FechaInicio, Estado)
                        VALUES (@IDCita, @Descripcion, @CostoTotal, CAST(GETDATE() AS DATE), 'A');
                        SELECT SCOPE_IDENTITY();", con, trans);
                    cmdTrat.Parameters.AddWithValue("@IDCita", idCita);
                    cmdTrat.Parameters.AddWithValue("@Descripcion", descripcionTratamiento);
                    cmdTrat.Parameters.AddWithValue("@CostoTotal", costoTotal);
                    int idTratamiento = Convert.ToInt32(cmdTrat.ExecuteScalar());

                    // insertar prescripciones
                    foreach (var p in prescripciones)
                    {
                        var cmdPresc = new SqlCommand(@"
                            INSERT INTO PRESCRIPCIONES 
                                (IDTratamiento, IDMedicamento, IDHospital, Cantidad, Dosis, Frecuencia, FechaInicio)
                            VALUES 
                                (@IDTratamiento, @IDMedicamento, @IDHospital, @Cantidad, @Dosis, @Frecuencia, CAST(GETDATE() AS DATE))",
                            con, trans);
                        cmdPresc.Parameters.AddWithValue("@IDTratamiento", idTratamiento);
                        cmdPresc.Parameters.AddWithValue("@IDMedicamento", p.IDMedicamento);
                        cmdPresc.Parameters.AddWithValue("@IDHospital", idHospital);
                        cmdPresc.Parameters.AddWithValue("@Cantidad", p.Cantidad);
                        cmdPresc.Parameters.AddWithValue("@Dosis", p.Dosis);
                        cmdPresc.Parameters.AddWithValue("@Frecuencia", p.Frecuencia);
                        cmdPresc.ExecuteNonQuery();
                    }

                    // generar pago pendiente
                    var cmdPago = new SqlCommand(@"
                        INSERT INTO PAGOS (IDPaciente, IDTratamiento, IDHospital, Monto, Estado)
                        VALUES (@IDPaciente, @IDTratamiento, @IDHospital, @Monto, 'P')", con, trans);
                    cmdPago.Parameters.AddWithValue("@IDPaciente", idPaciente);
                    cmdPago.Parameters.AddWithValue("@IDTratamiento", idTratamiento);
                    cmdPago.Parameters.AddWithValue("@IDHospital", idHospital);
                    cmdPago.Parameters.AddWithValue("@Monto", costoTotal);
                    cmdPago.ExecuteNonQuery();

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }
    }
}
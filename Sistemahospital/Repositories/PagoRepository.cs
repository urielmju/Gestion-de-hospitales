using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Sistemahospital.Database;
using Sistemahospital.Models;

namespace Sistemahospital.Repositories
{
    public class PagoRepository
    {
        private readonly ConexionDB _db = new ConexionDB();

        public List<Pago> ObtenerTodos()
        {
            var lista = new List<Pago>();
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    SELECT PG.IDPago, PG.Monto, PG.MetodoPago, PG.Estado, PG.Fecha,
                        PA.Nombre + ' ' + PA.Apellido AS NombrePaciente,
                        T.Descripcion AS DescripcionTratamiento,
                        H.Nombre AS NombreHospital,
                        PG.IDPaciente, PG.IDTratamiento, PG.IDHospital
                    FROM PAGOS PG
                    INNER JOIN PACIENTES PA ON PG.IDPaciente = PA.IDPaciente
                    INNER JOIN TRATAMIENTOS T ON PG.IDTratamiento = T.IDTratamiento
                    INNER JOIN HOSPITALES H ON PG.IDHospital = H.IDHospital
                    ORDER BY PG.Fecha DESC", con);

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(new Pago
                    {
                        IDPago = (int)r["IDPago"],
                        IDPaciente = (int)r["IDPaciente"],
                        NombrePaciente = r["NombrePaciente"].ToString(),
                        IDTratamiento = (int)r["IDTratamiento"],
                        DescripcionTratamiento = r["DescripcionTratamiento"].ToString(),
                        IDHospital = (int)r["IDHospital"],
                        NombreHospital = r["NombreHospital"].ToString(),
                        Fecha = (DateTime)r["Fecha"],
                        Monto = (decimal)r["Monto"],
                        MetodoPago = r["MetodoPago"].ToString(),
                        Estado = r["Estado"].ToString()
                    });
                }
            }
            return lista;
        }

        public List<Pago> ObtenerPendientes()
        {
            var lista = new List<Pago>();
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    SELECT PG.IDPago, PG.Monto, PG.MetodoPago, PG.Estado, PG.Fecha,
                        PA.Nombre + ' ' + PA.Apellido AS NombrePaciente,
                        T.Descripcion AS DescripcionTratamiento,
                        H.Nombre AS NombreHospital,
                        PG.IDPaciente, PG.IDTratamiento, PG.IDHospital
                    FROM PAGOS PG
                    INNER JOIN PACIENTES PA ON PG.IDPaciente = PA.IDPaciente
                    INNER JOIN TRATAMIENTOS T ON PG.IDTratamiento = T.IDTratamiento
                    INNER JOIN HOSPITALES H ON PG.IDHospital = H.IDHospital
                    WHERE PG.Estado = 'P'
                    ORDER BY PG.Fecha DESC", con);

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(new Pago
                    {
                        IDPago = (int)r["IDPago"],
                        IDPaciente = (int)r["IDPaciente"],
                        NombrePaciente = r["NombrePaciente"].ToString(),
                        IDTratamiento = (int)r["IDTratamiento"],
                        DescripcionTratamiento = r["DescripcionTratamiento"].ToString(),
                        IDHospital = (int)r["IDHospital"],
                        NombreHospital = r["NombreHospital"].ToString(),
                        Fecha = (DateTime)r["Fecha"],
                        Monto = (decimal)r["Monto"],
                        MetodoPago = r["MetodoPago"].ToString(),
                        Estado = r["Estado"].ToString()
                    });
                }
            }
            return lista;
        }

        public List<Pago> ObtenerPorPaciente(int idPaciente)
        {
            var lista = new List<Pago>();
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    SELECT PG.IDPago, PG.Monto, PG.MetodoPago, PG.Estado, PG.Fecha,
                        PA.Nombre + ' ' + PA.Apellido AS NombrePaciente,
                        T.Descripcion AS DescripcionTratamiento,
                        H.Nombre AS NombreHospital,
                        PG.IDPaciente, PG.IDTratamiento, PG.IDHospital
                    FROM PAGOS PG
                    INNER JOIN PACIENTES PA ON PG.IDPaciente = PA.IDPaciente
                    INNER JOIN TRATAMIENTOS T ON PG.IDTratamiento = T.IDTratamiento
                    INNER JOIN HOSPITALES H ON PG.IDHospital = H.IDHospital
                    WHERE PG.IDPaciente = @IDPaciente
                    ORDER BY PG.Fecha DESC", con);
                cmd.Parameters.AddWithValue("@IDPaciente", idPaciente);

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(new Pago
                    {
                        IDPago = (int)r["IDPago"],
                        IDPaciente = (int)r["IDPaciente"],
                        NombrePaciente = r["NombrePaciente"].ToString(),
                        IDTratamiento = (int)r["IDTratamiento"],
                        DescripcionTratamiento = r["DescripcionTratamiento"].ToString(),
                        IDHospital = (int)r["IDHospital"],
                        NombreHospital = r["NombreHospital"].ToString(),
                        Fecha = (DateTime)r["Fecha"],
                        Monto = (decimal)r["Monto"],
                        MetodoPago = r["MetodoPago"].ToString(),
                        Estado = r["Estado"].ToString()
                    });
                }
            }
            return lista;
        }

        public void Pagar(int idPago, string metodoPago)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    UPDATE PAGOS SET Estado = 'PA', MetodoPago = @MetodoPago
                    WHERE IDPago = @ID", con);
                cmd.Parameters.AddWithValue("@ID", idPago);
                cmd.Parameters.AddWithValue("@MetodoPago", metodoPago);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
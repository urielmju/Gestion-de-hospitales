using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Mvc;
using Sistemahospital.Database;
using Sistemahospital.Models;
using Sistemahospital.Filters;

namespace Sistemahospital.Controllers
{
    [RolAutorizado(3, 4)]
    public class ReportesController : Controller
    {
        private readonly ConexionDB _db = new ConexionDB();

        public ActionResult Index()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            return View();
        }

        [HttpPost]
        public ActionResult PacientesPorMedico(int idMedico, int idHospital, DateTime fechaInicio, DateTime fechaFin)
        {
            var lista = new List<Cita>();
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand("EXEC sp_PacientesPorMedicoHospital @IDMedico, @IDHospital, @FechaInicio, @FechaFin", con);
                cmd.Parameters.AddWithValue("@IDMedico", idMedico);
                cmd.Parameters.AddWithValue("@IDHospital", idHospital);
                cmd.Parameters.AddWithValue("@FechaInicio", fechaInicio);
                cmd.Parameters.AddWithValue("@FechaFin", fechaFin);

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(new Cita
                    {
                        IDPaciente = (int)r["IDPaciente"],
                        NombrePaciente = r["NombrePaciente"].ToString(),
                        IDCita = (int)r["IDCita"],
                        FechaHora = (DateTime)r["FechaHora"],
                        Diagnostico = r["Diagnostico"] == DBNull.Value ? "-" : r["Diagnostico"].ToString(),
                        Estado = r["EstadoCita"].ToString()
                    });
                }
            }
            ViewBag.Resultados = lista;
            ViewBag.Tipo = "PacientesPorMedico";
            return View("Index");
        }

        [HttpPost]
        public ActionResult PagosPaciente(int idPaciente, DateTime fechaInicio, DateTime fechaFin)
        {
            var lista = new List<Pago>();
            decimal totalPagado = 0, totalPendiente = 0;

            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand("EXEC sp_TotalPagosPaciente @IDPaciente, @FechaInicio, @FechaFin", con);
                cmd.Parameters.AddWithValue("@IDPaciente", idPaciente);
                cmd.Parameters.AddWithValue("@FechaInicio", fechaInicio);
                cmd.Parameters.AddWithValue("@FechaFin", fechaFin);

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(new Pago
                    {
                        IDPago = (int)r["IDPago"],
                        NombrePaciente = r["NombrePaciente"].ToString(),
                        DescripcionTratamiento = r["DescripcionTratamiento"].ToString(),
                        NombreHospital = r["NombreHospital"].ToString(),
                        Fecha = (DateTime)r["Fecha"],
                        Monto = (decimal)r["Monto"],
                        MetodoPago = r["MetodoPago"].ToString(),
                        Estado = r["Estado"].ToString()
                    });
                }
                r.NextResult();
                r.NextResult();
                if (r.Read())
                {
                    totalPagado = r["TotalPagado"] == DBNull.Value ? 0 : (decimal)r["TotalPagado"];
                    totalPendiente = r["TotalPendiente"] == DBNull.Value ? 0 : (decimal)r["TotalPendiente"];
                }
            }

            ViewBag.Resultados = lista;
            ViewBag.TotalPagado = totalPagado;
            ViewBag.TotalPendiente = totalPendiente;
            ViewBag.Tipo = "PagosPaciente";
            return View("Index");
        }

        public ActionResult StockBajo(int idHospital = 1, int stockMinimo = 100)
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");

            var lista = new List<dynamic>();
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand("EXEC sp_ReporteStockBajo @IDHospital, @StockMinimo", con);
                cmd.Parameters.AddWithValue("@IDHospital", idHospital);
                cmd.Parameters.AddWithValue("@StockMinimo", stockMinimo);

                var r = cmd.ExecuteReader();
                var tabla = new DataTable();
                tabla.Load(r);
                ViewBag.Tabla = tabla;
            }

            ViewBag.IDHospital = idHospital;
            ViewBag.StockMinimo = stockMinimo;
            return View();
        }

        public ActionResult HistorialMedico(int idPaciente = 0)
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");

            DataTable tabla = null;
            if (idPaciente > 0)
            {
                using (var con = _db.ObtenerConexion())
                {
                    con.Open();
                    var cmd = new SqlCommand(@"
                        SELECT * FROM vw_HistorialMedico 
                        WHERE IDPaciente = @IDPaciente
                        ORDER BY FechaHora DESC", con);
                    cmd.Parameters.AddWithValue("@IDPaciente", idPaciente);
                    var r = cmd.ExecuteReader();
                    tabla = new DataTable();
                    tabla.Load(r);
                }
            }

            ViewBag.Tabla = tabla;
            ViewBag.IDPaciente = idPaciente;
            return View();
        }
    }
}
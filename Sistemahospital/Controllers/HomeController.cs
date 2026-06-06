using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Mvc;
using Sistemahospital.Database;
using Sistemahospital.Models;

namespace Sistemahospital.Controllers
{
    public class HomeController : Controller
    {
        private readonly ConexionDB _db = new ConexionDB();

        public ActionResult Denegado()
        {
            return View();
        }

        public ActionResult Index()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");

            int rol = Convert.ToInt32(Session["IDRol"].ToString());
            string filtroHospitalPacientes = "";
            string filtroHospitalMedicos = "";
            string filtroHospitalCitas = "";
            string filtroHospitalPagos = "";

            if (rol == 3 && Session["IDHospital"] != null)
            {
                string idH = Session["IDHospital"].ToString();
                filtroHospitalPacientes = " AND P.IDHospital = " + idH;
                filtroHospitalMedicos = " AND M.IDHospital = " + idH;
                filtroHospitalCitas = " AND C.IDHospital = " + idH;
                filtroHospitalPagos = " AND PG.IDHospital = " + idH;
            }

            using (var con = _db.ObtenerConexion())
            {
                con.Open();

                ViewBag.TotalPacientes = new SqlCommand(
                    "SELECT COUNT(*) FROM PACIENTES P WHERE P.Estado='A'" + filtroHospitalPacientes, con).ExecuteScalar();

                ViewBag.TotalMedicos = new SqlCommand(
                    "SELECT COUNT(*) FROM MEDICOS M WHERE M.Estado='A'" + filtroHospitalMedicos, con).ExecuteScalar();

                ViewBag.TotalCitas = new SqlCommand(
                    "SELECT COUNT(*) FROM CITAS C WHERE C.Estado='P'" + filtroHospitalCitas, con).ExecuteScalar();

                ViewBag.TotalPagos = new SqlCommand(
                    "SELECT COUNT(*) FROM PAGOS PG WHERE PG.Estado='P'" + filtroHospitalPagos, con).ExecuteScalar();

                // proximas citas
                var citas = new List<Cita>();
                var sqlCitas = @"
        SELECT TOP 5 C.IDCita, 
            P.Nombre + ' ' + P.Apellido AS NombrePaciente,
            M.Nombre + ' ' + M.Apellido AS NombreMedico,
            C.FechaHora, C.Estado
        FROM CITAS C
        INNER JOIN PACIENTES P ON C.IDPaciente = P.IDPaciente
        INNER JOIN MEDICOS M ON C.IDMedico = M.IDMedico
        WHERE C.Estado = 'P'" + filtroHospitalCitas + @"
        ORDER BY C.FechaHora ASC";

                var cmdCitas = new SqlCommand(sqlCitas, con);
                var rCitas = cmdCitas.ExecuteReader();
                while (rCitas.Read())
                {
                    citas.Add(new Cita
                    {
                        IDCita = (int)rCitas["IDCita"],
                        NombrePaciente = rCitas["NombrePaciente"].ToString(),
                        NombreMedico = rCitas["NombreMedico"].ToString(),
                        FechaHora = (DateTime)rCitas["FechaHora"],
                        Estado = rCitas["Estado"].ToString()
                    });
                }
                rCitas.Close();
                ViewBag.ProximasCitas = citas;

                // pagos pendientes
                var pagos = new List<Pago>();
                var sqlPagos = @"
        SELECT TOP 5 PG.IDPago,
            PA.Nombre + ' ' + PA.Apellido AS NombrePaciente,
            T.Descripcion AS DescripcionTratamiento,
            PG.Monto
        FROM PAGOS PG
        INNER JOIN PACIENTES PA ON PG.IDPaciente = PA.IDPaciente
        INNER JOIN TRATAMIENTOS T ON PG.IDTratamiento = T.IDTratamiento
        WHERE PG.Estado = 'P'" + filtroHospitalPagos + @"
        ORDER BY PG.Fecha DESC";

                var cmdPagos = new SqlCommand(sqlPagos, con);
                var rPagos = cmdPagos.ExecuteReader();
                while (rPagos.Read())
                {
                    pagos.Add(new Pago
                    {
                        IDPago = (int)rPagos["IDPago"],
                        NombrePaciente = rPagos["NombrePaciente"].ToString(),
                        DescripcionTratamiento = rPagos["DescripcionTratamiento"].ToString(),
                        Monto = (decimal)rPagos["Monto"]
                    });
                }
                rPagos.Close();
                ViewBag.PagosPendientes = pagos;
            }

            return View();
        }
    }
}
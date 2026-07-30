using System;
using System.Collections.Generic;
using System.Web.Mvc;
using Sistemahospital.Repositories;
using Sistemahospital.Models;
using Sistemahospital.Filters;

namespace Sistemahospital.Controllers
{
    [RolAutorizado(1, 3, 4, 5)]
    public class PagosController : Controller
    {
        private readonly PagoRepository _repo = new PagoRepository();

        public ActionResult Index()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");

            int rol = Convert.ToInt32(Session["IDRol"].ToString());

            if (rol == 1)
            {
                if (Session["IDPaciente"] == null)
                {
                    ViewBag.Error = "No se encontro el paciente asociado a este usuario.";
                    return View(new List<Pago>());
                }

                int idPaciente = Convert.ToInt32(Session["IDPaciente"]);
                ViewBag.DebugIDPaciente = idPaciente;
                return View(_repo.ObtenerPorPaciente(idPaciente));
            }

            return View(_repo.ObtenerTodos());
        }

        public ActionResult Pendientes()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            return View(_repo.ObtenerPendientes());
        }

        [HttpPost]
        public ActionResult Pagar(int idPago, string metodoPago)
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");

            int rol = Convert.ToInt32(Session["IDRol"].ToString());
            if (rol == 1)
            {
                int idPaciente = Convert.ToInt32(Session["IDPaciente"]);
                if (!_repo.PerteneceAPaciente(idPago, idPaciente))
                    return RedirectToAction("Denegado", "Home");
            }

            _repo.Pagar(idPago, metodoPago);
            TempData["Exito"] = "Pago registrado exitosamente.";
            return RedirectToAction("Pendientes");
        }
    }
}
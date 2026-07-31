using System;
using System.Web.Mvc;
using Sistemahospital.Models;
using Sistemahospital.Repositories;
using Sistemahospital.Filters;

namespace Sistemahospital.Controllers
{
    [RolAutorizado(3, 4, 6)]
    public class MedicamentosController : Controller
    {
        private readonly MedicamentoRepository _repo = new MedicamentoRepository();

        public ActionResult Index(int idHospital = 1)
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            ViewBag.IDHospital = idHospital;
            return View(_repo.ObtenerTodos(idHospital));
        }

        [HttpPost]
        public ActionResult ActualizarStock(int idMedicamento, int idHospital, int cantidad)
        {
            _repo.ActualizarStock(idMedicamento, idHospital, cantidad);
            TempData["Exito"] = "Stock actualizado exitosamente.";
            return RedirectToAction("Index", new { idHospital });
        }

        [RolAutorizado(6)]
        [HttpPost]
        public ActionResult AgregarStock(int idMedicamento, int idHospital, int cantidad)
        {
            if (cantidad > 0)
                _repo.AgregarStock(idMedicamento, idHospital, cantidad);
            TempData["Exito"] = "Stock agregado exitosamente.";
            return RedirectToAction("Index", new { idHospital });
        }

        [RolAutorizado(6)]
        public ActionResult Crear()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            return View(new Medicamento());
        }

        [HttpPost]
        [RolAutorizado(6)]
        public ActionResult Crear(Medicamento m, int idHospital, int cantidadInicial)
        {
            try
            {
                _repo.Crear(m, idHospital, cantidadInicial);
                TempData["Exito"] = "Medicamento registrado exitosamente.";
                return RedirectToAction("Index", new { idHospital });
            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                return View(m);
            }
        }
    }
}
using Sistemahospital.Models;
using Sistemahospital.Repositories;
using System;
using System.Web.Mvc;
using Sistemahospital.Filters;

namespace Sistemahospital.Controllers
{
    [RolAutorizado(3, 4)]
    public class MedicosController : Controller
    {
        private readonly MedicoRepository _repo = new MedicoRepository();

        public ActionResult Index()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            return View(_repo.ObtenerTodos());
        }

        public ActionResult Crear()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            return View(new Medico());
        }

        [HttpPost]
        public ActionResult Crear(Medico m, string username, string password)
        {
            try
            {
                _repo.Crear(m, username, password);
                TempData["Exito"] = "Medico registrado exitosamente.";
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                return View(m);
            }
        }

        public ActionResult Editar(int id)
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            return View(_repo.ObtenerPorId(id));
        }

        [HttpPost]
        public ActionResult Editar(Medico m)
        {
            _repo.Editar(m);
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            _repo.Eliminar(id);
            return RedirectToAction("Index");
        }
    }
}
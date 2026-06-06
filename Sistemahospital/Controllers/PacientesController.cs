using System;
using System.Web.Mvc;
using Sistemahospital.Repositories;
using Sistemahospital.Models;
using Sistemahospital.Filters;

namespace Sistemahospital.Controllers
{
    [RolAutorizado(3, 4)]
    public class PacientesController : Controller
    {
        private readonly PacienteRepository _repo = new PacienteRepository();

        public ActionResult Index(string nombre, string apellido)
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");

            int rol = Convert.ToInt32(Session["IDRol"].ToString());
            int? idHospital = rol == 3 ? (int?)Convert.ToInt32(Session["IDHospital"]) : null;

            var lista = string.IsNullOrEmpty(nombre) && string.IsNullOrEmpty(apellido)
                ? _repo.ObtenerTodos(idHospital)
                : _repo.Buscar(nombre, apellido, idHospital);

            ViewBag.Nombre = nombre;
            ViewBag.Apellido = apellido;
            return View(lista);
        }

        public ActionResult Crear()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            return View(new Paciente());
        }

        [HttpPost]
        public ActionResult Crear(Paciente p, string username, string password)
        {
            try
            {
                _repo.Crear(p, username, password);
                TempData["Exito"] = "Paciente registrado exitosamente.";
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                return View(p);
            }
        }

        public ActionResult Editar(int id)
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            return View(_repo.ObtenerPorId(id));
        }

        [HttpPost]
        public ActionResult Editar(Paciente p)
        {
            _repo.Editar(p);
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            _repo.Eliminar(id);
            return RedirectToAction("Index");
        }

        public ActionResult Historial(int id)
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            var paciente = _repo.ObtenerPorId(id);
            ViewBag.Paciente = paciente;
            return View();
        }

        [RolAutorizado(1, 3, 4)]
        public ActionResult MiHistorial()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");

            int idPaciente = Convert.ToInt32(Session["IDPaciente"]);
            var paciente = _repo.ObtenerPorId(idPaciente);
            ViewBag.Paciente = paciente;
            ViewBag.IDPaciente = idPaciente;
            return View();
        }
    }
}
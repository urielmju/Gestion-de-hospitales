using System;
using System.Web.Mvc;
using Sistemahospital.Repositories;
using Sistemahospital.Filters;

namespace Sistemahospital.Controllers
{
    [RolAutorizado(2, 3, 4)]
    public class CitasController : Controller
    {
        private readonly CitaRepository _repo = new CitaRepository();
        private readonly PacienteRepository _repoPaciente = new PacienteRepository();
        private readonly MedicoRepository _repoMedico = new MedicoRepository();

        [RolAutorizado(2, 3, 4, 5)]
        public ActionResult Index()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            return View(_repo.ObtenerTodos());
        }

        [RolAutorizado(2, 3, 4, 5)]
        public ActionResult Crear()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            CargarListasParaCita();
            return View();
        }

        [HttpPost]
        [RolAutorizado(2, 3, 4, 5)]
        public ActionResult Crear(int idPaciente, int idMedico, int idHospital, DateTime fechaHora)
        {
            try
            {
                int rol = Convert.ToInt32(Session["IDRol"].ToString());
                if (rol != 4 && Session["IDHospital"] != null)
                    idHospital = Convert.ToInt32(Session["IDHospital"]);

                _repo.Crear(idPaciente, idMedico, idHospital, fechaHora);
                TempData["Exito"] = "Cita registrada exitosamente.";
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                CargarListasParaCita();
                return View();
            }
        }

        private void CargarListasParaCita()
        {
            int rol = Convert.ToInt32(Session["IDRol"].ToString());
            int? idHospitalSesion = (rol != 4 && Session["IDHospital"] != null)
                ? (int?)Convert.ToInt32(Session["IDHospital"])
                : null;

            ViewBag.Pacientes = _repoPaciente.ObtenerTodos(idHospitalSesion);
            ViewBag.Medicos = idHospitalSesion.HasValue
                ? _repoMedico.ObtenerTodos().FindAll(m => m.IDHospital == idHospitalSesion.Value)
                : _repoMedico.ObtenerTodos();
            ViewBag.IDHospitalFijo = idHospitalSesion;
        }

        public ActionResult Editar(int id)
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");
            return View(_repo.ObtenerPorId(id));
        }

        [HttpPost]
        public ActionResult Editar(int idCita, string estado, string diagnostico)
        {
            _repo.ActualizarEstado(idCita, estado, diagnostico);
            return RedirectToAction("Index");
        }

        public ActionResult Cancelar(int id)
        {
            _repo.Cancelar(id);
            return RedirectToAction("Index");
        }
    }
}
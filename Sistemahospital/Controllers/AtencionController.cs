using System;
using System.Collections.Generic;
using System.Web.Mvc;
using Sistemahospital.Models;
using Sistemahospital.Repositories;
using Sistemahospital.Filters;

namespace Sistemahospital.Controllers
{
    public class AtencionController : Controller
    {
        private readonly AtencionRepository _repo = new AtencionRepository();
        private readonly CitaRepository _repoCita = new CitaRepository();
        private readonly PacienteRepository _repoPaciente = new PacienteRepository();
        private readonly MedicamentoRepository _repoMed = new MedicamentoRepository();

        [RolAutorizado(2, 3, 4)]
        public ActionResult MisCitas()
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");

            int rol = 0;
            int.TryParse(Session["IDRol"]?.ToString(), out rol);

            List<Cita> citas;

            if (rol == 2)
            {
                int idMedico = Convert.ToInt32(Session["IDMedico"]);
                citas = _repo.ObtenerCitasMedico(idMedico);
            }
            else if (rol == 3)
            {
                int idHospital = Convert.ToInt32(Session["IDHospital"]);
                citas = _repoCita.ObtenerPorHospital(idHospital);
            }
            else
            {
                citas = _repoCita.ObtenerTodos();
            }

            return View(citas);
        }

        [RolAutorizado(2, 3, 4)]
        public ActionResult Atender(int idCita)
        {
            if (Session["IDUsuario"] == null)
                return RedirectToAction("Login", "Account");

            var cita = _repoCita.ObtenerPorId(idCita);
            var paciente = _repoPaciente.ObtenerPorId(cita.IDPaciente);
            var medicamentos = _repoMed.ObtenerTodos(cita.IDHospital);

            var modelo = new AtencionViewModel
            {
                Cita = cita,
                Paciente = paciente,
                MedicamentosDisponibles = medicamentos
            };

            return View(modelo);
        }

        [HttpPost]
        [RolAutorizado(2, 3, 4)]
        public ActionResult Atender(int idCita, int idPaciente, int idHospital,
            string diagnostico, string descripcionTratamiento, string costoTotal,
            int[] idsMedicamento, int[] cantidades, string[] dosis, string[] frecuencias)
        {
            try
            {
                decimal costo = 0;
                decimal.TryParse(costoTotal, System.Globalization.NumberStyles.Any,
                    System.Globalization.CultureInfo.InvariantCulture, out costo);

                if (costo <= 0) costo = 0.01m;

                var prescripciones = new List<Prescripcion>();

                if (idsMedicamento != null)
                {
                    for (int i = 0; i < idsMedicamento.Length; i++)
                    {
                        if (cantidades[i] > 0)
                        {
                            prescripciones.Add(new Prescripcion
                            {
                                IDMedicamento = idsMedicamento[i],
                                Cantidad = cantidades[i],
                                Dosis = dosis[i],
                                Frecuencia = frecuencias[i]
                            });
                        }
                    }
                }

                _repo.RegistrarAtencion(idCita, idPaciente, idHospital,
                    diagnostico, descripcionTratamiento, costo, prescripciones);

                TempData["Exito"] = "Atencion registrada. Pago generado para el paciente ID: " + idPaciente;
                return RedirectToAction("MisCitas");
            }
            catch (Exception ex)
            {
                TempData["Error"] = ex.Message;
                return RedirectToAction("Atender", new { idCita });
            }
        }
    }
}
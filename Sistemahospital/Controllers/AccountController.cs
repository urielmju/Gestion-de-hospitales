using System;
using System.Data.SqlClient;
using System.Web.Mvc;
using Sistemahospital.Models;
using Sistemahospital.Repositories;

namespace Sistemahospital.Controllers
{
    public class AccountController : Controller
    {
        private readonly UsuarioRepository _repo = new UsuarioRepository();
        private readonly PacienteRepository _repoPaciente = new PacienteRepository();
        private readonly MedicoRepository _repoMedico = new MedicoRepository();

        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [ValidateInput(false)]
        public ActionResult Login(string username, string password)
        {
            Usuario usuario;
            try
            {
                usuario = _repo.Login(username, password);
            }
            catch (Exception)
            {
                ViewBag.Error = "La base de datos esta reactivandose, intenta de nuevo en unos segundos.";
                return View();
            }

            if (usuario == null)
            {
                ViewBag.Error = "Usuario o contrasena incorrectos.";
                return View();
            }

            Session["IDUsuario"] = usuario.IDUsuario;
            Session["Username"] = usuario.Username;
            Session["IDRol"] = usuario.IDRol;
            Session["NombreRol"] = usuario.NombreRol;
            Session["IDHospital"] = usuario.IDHospital.HasValue ? (object)usuario.IDHospital.Value : null;
            Session["IDMedico"] = usuario.IDMedico.HasValue ? (object)usuario.IDMedico.Value : null;
            Session["IDPaciente"] = usuario.IDPaciente.HasValue ? (object)usuario.IDPaciente.Value : null;

            switch (usuario.IDRol)
            {
                case 2:
                    return RedirectToAction("MisCitas", "Atencion");
                case 1:
                    return RedirectToAction("MiHistorial", "Pacientes");
                case 5:
                    return RedirectToAction("Index", "Home");
                case 6:
                    return RedirectToAction("Index", "Medicamentos");
                default:
                    return RedirectToAction("Index", "Home");
            }
        }

        public ActionResult Registro()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Registro(string tipoCuenta, string username, string password,
            string nombre, string apellido, int idHospital, string email)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
                {
                    ViewBag.Error = "Usuario y contrasena son obligatorios.";
                    return View();
                }

                if (tipoCuenta == "paciente")
                {
                    var paciente = new Paciente
                    {
                        IDHospital = idHospital,
                        Nombre = nombre,
                        Apellido = apellido,
                        FechaNacimiento = DateTime.Now,
                        Email = email
                    };
                    _repoPaciente.Crear(paciente, username, password);
                }
                else if (tipoCuenta == "medico")
                {
                    var medico = new Medico
                    {
                        IDHospital = idHospital,
                        Nombre = nombre,
                        Apellido = apellido,
                        Especialidad = "General",
                        Email = email
                    };
                    _repoMedico.Crear(medico, username, password);
                }
                else if (tipoCuenta == "recepcionista")
                {
                    _repo.CrearStaff(5, idHospital, nombre, apellido, username, password, email);
                }
                else if (tipoCuenta == "farmaceutico")
                {
                    _repo.CrearStaff(6, idHospital, nombre, apellido, username, password, email);
                }
                else
                {
                    ViewBag.Error = "Tipo de cuenta invalido.";
                    return View();
                }

                TempData["Exito"] = "Cuenta creada exitosamente. Ya puedes iniciar sesion.";
                return RedirectToAction("Login");
            }
            catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
            {
                ViewBag.Error = "Ese nombre de usuario ya existe. Elige otro.";
                return View();
            }
            catch (Exception ex)
            {
                ViewBag.Error = ex.Message;
                return View();
            }
        }

        public ActionResult Logout()
        {
            Session.Clear();
            Session.Abandon();
            return RedirectToAction("Login", "Account");
        }
    }
}
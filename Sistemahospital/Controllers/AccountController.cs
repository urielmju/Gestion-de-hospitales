using System.Web.Mvc;
using Sistemahospital.Repositories;

namespace Sistemahospital.Controllers
{
    public class AccountController : Controller
    {
        private readonly UsuarioRepository _repo = new UsuarioRepository();

        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(string username, string password)
        {
            var usuario = _repo.Login(username, password);
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
                default:
                    return RedirectToAction("Index", "Home");
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
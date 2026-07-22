using System.Web.Mvc;
using Sistemahospital.Repositories;
using Sistemahospital.Filters;

namespace Sistemahospital.Controllers
{
    [RolAutorizado(3, 4)]
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
    }
}
using System;
using System.Web.Mvc;

namespace Sistemahospital.Filters
{
    public class RolAutorizadoAttribute : ActionFilterAttribute
    {
        private readonly int[] _roles;

        public RolAutorizadoAttribute(params int[] roles)
        {
            _roles = roles;
        }

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var session = filterContext.HttpContext.Session;

            if (session["IDUsuario"] == null)
            {
                filterContext.Result = new RedirectResult("/Account/Login");
                return;
            }

            int idRol = Convert.ToInt32(session["IDRol"]);
            bool tieneAcceso = false;

            foreach (var rol in _roles)
            {
                if (idRol == rol)
                {
                    tieneAcceso = true;
                    break;
                }
            }

            if (!tieneAcceso)
            {
                filterContext.Result = new RedirectResult("/Home/Denegado");
            }
        }
    }
}
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace Sistemahospital
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        protected void Application_Error()
        {
            var ex = Server.GetLastError();
            if (ex == null)
                return;

            try
            {
                var ruta = Server.MapPath("~/App_Data/error_log.txt");
                var texto = string.Format(
                    "{0:yyyy-MM-dd HH:mm:ss} UTC{1}URL: {2}{1}{3}{1}{4}{1}",
                    DateTime.UtcNow, Environment.NewLine,
                    Request?.Url, ex.ToString(),
                    new string('-', 60));
                File.AppendAllText(ruta, texto + Environment.NewLine);
            }
            catch
            {
            }
        }
    }
}

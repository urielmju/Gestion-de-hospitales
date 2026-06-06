using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using Sistemahospital.Database;
using Sistemahospital.Models;

namespace Sistemahospital.Repositories
{
    public class MedicamentoRepository
    {
        private readonly ConexionDB _db = new ConexionDB();

        public List<Medicamento> ObtenerTodos(int idHospital)
        {
            var lista = new List<Medicamento>();
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    SELECT M.IDMedicamento, M.Nombre, M.Descripcion, 
                        M.CostoPorUnidad, M.UnidadMedida, M.Estado,
                        ISNULL(IM.CantidadStock, 0) AS StockHospital
                    FROM MEDICAMENTOS M
                    LEFT JOIN INVENTARIO_MEDICAMENTOS IM 
                        ON M.IDMedicamento = IM.IDMedicamento
                        AND IM.IDHospital = @IDHospital
                    WHERE M.Estado = 'A'
                    ORDER BY M.Nombre", con);
                cmd.Parameters.AddWithValue("@IDHospital", idHospital);

                var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(new Medicamento
                    {
                        IDMedicamento = (int)r["IDMedicamento"],
                        Nombre = r["Nombre"].ToString(),
                        Descripcion = r["Descripcion"].ToString(),
                        CostoPorUnidad = (decimal)r["CostoPorUnidad"],
                        UnidadMedida = r["UnidadMedida"].ToString(),
                        Estado = r["Estado"].ToString(),
                        StockHospital = (int)r["StockHospital"]
                    });
                }
            }
            return lista;
        }

        public void ActualizarStock(int idMedicamento, int idHospital, int cantidad)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    UPDATE INVENTARIO_MEDICAMENTOS 
                    SET CantidadStock = @Cantidad, FechaActualizacion = GETDATE()
                    WHERE IDMedicamento = @IDMedicamento AND IDHospital = @IDHospital", con);
                cmd.Parameters.AddWithValue("@IDMedicamento", idMedicamento);
                cmd.Parameters.AddWithValue("@IDHospital", idHospital);
                cmd.Parameters.AddWithValue("@Cantidad", cantidad);
                cmd.ExecuteNonQuery();
            }
        }
    }
}
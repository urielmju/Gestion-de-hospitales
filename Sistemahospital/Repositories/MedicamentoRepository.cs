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

        public void AgregarStock(int idMedicamento, int idHospital, int cantidad)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var cmd = new SqlCommand(@"
                    IF EXISTS (SELECT 1 FROM INVENTARIO_MEDICAMENTOS WHERE IDMedicamento = @IDMedicamento AND IDHospital = @IDHospital)
                        UPDATE INVENTARIO_MEDICAMENTOS
                        SET CantidadStock = CantidadStock + @Cantidad, FechaActualizacion = GETDATE()
                        WHERE IDMedicamento = @IDMedicamento AND IDHospital = @IDHospital
                    ELSE
                        INSERT INTO INVENTARIO_MEDICAMENTOS (IDMedicamento, IDHospital, CantidadStock, FechaActualizacion)
                        VALUES (@IDMedicamento, @IDHospital, @Cantidad, GETDATE())", con);
                cmd.Parameters.AddWithValue("@IDMedicamento", idMedicamento);
                cmd.Parameters.AddWithValue("@IDHospital", idHospital);
                cmd.Parameters.AddWithValue("@Cantidad", cantidad);
                cmd.ExecuteNonQuery();
            }
        }

        public void Crear(Medicamento m, int idHospital, int cantidadInicial)
        {
            using (var con = _db.ObtenerConexion())
            {
                con.Open();
                var trans = con.BeginTransaction();
                try
                {
                    var cmdMed = new SqlCommand(@"
                        INSERT INTO MEDICAMENTOS (Nombre, Descripcion, CostoPorUnidad, UnidadMedida, FechaRegistro, Estado)
                        VALUES (@Nombre, @Descripcion, @CostoPorUnidad, @UnidadMedida, GETDATE(), 'A');
                        SELECT SCOPE_IDENTITY();", con, trans);

                    cmdMed.Parameters.AddWithValue("@Nombre", m.Nombre);
                    cmdMed.Parameters.AddWithValue("@Descripcion", (object)m.Descripcion ?? DBNull.Value);
                    cmdMed.Parameters.AddWithValue("@CostoPorUnidad", m.CostoPorUnidad);
                    cmdMed.Parameters.AddWithValue("@UnidadMedida", (object)m.UnidadMedida ?? DBNull.Value);

                    int idMedicamento = Convert.ToInt32(cmdMed.ExecuteScalar());

                    var cmdInv = new SqlCommand(@"
                        INSERT INTO INVENTARIO_MEDICAMENTOS (IDMedicamento, IDHospital, CantidadStock, FechaActualizacion)
                        VALUES (@IDMedicamento, @IDHospital, @Cantidad, GETDATE())", con, trans);

                    cmdInv.Parameters.AddWithValue("@IDMedicamento", idMedicamento);
                    cmdInv.Parameters.AddWithValue("@IDHospital", idHospital);
                    cmdInv.Parameters.AddWithValue("@Cantidad", cantidadInicial);

                    cmdInv.ExecuteNonQuery();
                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }
    }
}
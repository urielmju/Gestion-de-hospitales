--inventario de medicamentos de 30 dias 
USE SistemaHospitales;
GO

CREATE PROCEDURE sp_InventarioYPrescripciones
    @IDHospital INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM HOSPITALES WHERE IDHospital = @IDHospital)
            RAISERROR('El hospital especificado no existe.', 16, 1);

        SELECT 
            M.IDMedicamento,
            M.Nombre AS NombreMedicamento,
            M.Descripcion,
            M.CostoPorUnidad,
            M.UnidadMedida,
            IM.CantidadStock,
            ISNULL(SUM(PR.Cantidad), 0) AS TotalPrescrito30Dias
        FROM MEDICAMENTOS M
        INNER JOIN INVENTARIO_MEDICAMENTOS IM 
            ON M.IDMedicamento = IM.IDMedicamento
           AND IM.IDHospital = @IDHospital
        LEFT JOIN PRESCRIPCIONES PR 
            ON M.IDMedicamento = PR.IDMedicamento
           AND PR.IDHospital = @IDHospital
           AND PR.FechaRegistro >= DATEADD(DAY, -30, GETDATE())
        WHERE M.Estado = 'A'
        GROUP BY 
            M.IDMedicamento,
            M.Nombre,
            M.Descripcion,
            M.CostoPorUnidad,
            M.UnidadMedida,
            IM.CantidadStock
        ORDER BY M.Nombre;

    END TRY
    BEGIN CATCH
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO

/* -- pruebas 
EXEC sp_InventarioYPrescripciones @IDHospital = 1;
GO
-- historial de pagos pendientes 
USE SistemaHospitales;
GO

CREATE PROCEDURE sp_PagosPendientesPaciente
    @IDPaciente INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM PACIENTES WHERE IDPaciente = @IDPaciente)
            RAISERROR('El paciente especificado no existe.', 16, 1);

        SELECT 
            P.IDPago,
            PA.Nombre + ' ' + PA.Apellido AS NombrePaciente,
            T.IDTratamiento,
            T.Descripcion AS DescripcionTratamiento,
            T.CostoTotal,
            P.Monto,
            P.MetodoPago,
            P.Fecha,
            H.Nombre AS NombreHospital,
            T.CostoTotal - ISNULL((
                SELECT SUM(P2.Monto) 
                FROM PAGOS P2 
                WHERE P2.IDTratamiento = T.IDTratamiento 
                  AND P2.Estado = 'PA'
            ), 0) AS SaldoPendiente
        FROM PAGOS P
        INNER JOIN PACIENTES PA ON P.IDPaciente = PA.IDPaciente
        INNER JOIN TRATAMIENTOS T ON P.IDTratamiento = T.IDTratamiento
        INNER JOIN HOSPITALES H ON P.IDHospital = H.IDHospital
        WHERE P.IDPaciente = @IDPaciente
          AND P.Estado = 'P'
        ORDER BY P.Fecha DESC;

        SELECT 
            SUM(Monto) AS TotalPendiente
        FROM PAGOS
        WHERE IDPaciente = @IDPaciente
          AND Estado = 'P';

    END TRY
    BEGIN CATCH
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO

/*-- pruebas 
EXEC sp_PagosPendientesPaciente @IDPaciente = 1;
GO
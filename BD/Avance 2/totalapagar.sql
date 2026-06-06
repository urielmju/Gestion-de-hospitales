--calcular el total de los pacientes 
USE SistemaHospitales;
GO

CREATE PROCEDURE sp_TotalPagosPaciente
    @IDPaciente INT,
    @FechaInicio DATETIME,
    @FechaFin DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM PACIENTES WHERE IDPaciente = @IDPaciente)
            RAISERROR('El paciente especificado no existe.', 16, 1);

        IF @FechaInicio > @FechaFin
            RAISERROR('La fecha de inicio no puede ser mayor a la fecha fin.', 16, 1);
        SELECT 
            P.IDPago,
            PA.Nombre + ' ' + PA.Apellido AS NombrePaciente,
            T.Descripcion AS DescripcionTratamiento,
            H.Nombre AS NombreHospital,
            P.Fecha,
            P.Monto,
            P.MetodoPago,
            P.Estado
        FROM PAGOS P
        INNER JOIN PACIENTES PA ON P.IDPaciente = PA.IDPaciente
        INNER JOIN TRATAMIENTOS T ON P.IDTratamiento = T.IDTratamiento
        INNER JOIN HOSPITALES H ON P.IDHospital = H.IDHospital
        WHERE P.IDPaciente = @IDPaciente
          AND P.Fecha BETWEEN @FechaInicio AND @FechaFin
        ORDER BY P.Fecha DESC;
        SELECT 
            P.Estado,
            COUNT(*) AS CantidadPagos,
            SUM(P.Monto) AS TotalMonto
        FROM PAGOS P
        WHERE P.IDPaciente = @IDPaciente
          AND P.Fecha BETWEEN @FechaInicio AND @FechaFin
        GROUP BY P.Estado;
        SELECT 
            COUNT(*) AS TotalTransacciones,
            SUM(CASE WHEN Estado = 'PA' THEN Monto ELSE 0 END) AS TotalPagado,
            SUM(CASE WHEN Estado = 'P'  THEN Monto ELSE 0 END) AS TotalPendiente,
            SUM(Monto) AS TotalGeneral
        FROM PAGOS
        WHERE IDPaciente = @IDPaciente
          AND Fecha BETWEEN @FechaInicio AND @FechaFin;

    END TRY
    BEGIN CATCH
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO

/* --pruebas 
EXEC sp_TotalPagosPaciente 
    @IDPaciente = 1,
    @FechaInicio = '2026-01-01',
    @FechaFin = '2026-12-31';
GO
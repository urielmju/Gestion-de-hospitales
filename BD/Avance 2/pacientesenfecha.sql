-- pacientes atendidos en rango de fechas 
USE SistemaHospitales;
GO

CREATE PROCEDURE sp_PacientesPorMedicoHospital
    @IDMedico INT,
    @IDHospital INT,
    @FechaInicio DATETIME,
    @FechaFin DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- validaciones
        IF NOT EXISTS (SELECT 1 FROM MEDICOS WHERE IDMedico = @IDMedico)
            RAISERROR('El medico especificado no existe.', 16, 1);

        IF NOT EXISTS (SELECT 1 FROM HOSPITALES WHERE IDHospital = @IDHospital)
            RAISERROR('El hospital especificado no existe.', 16, 1);

        IF @FechaInicio > @FechaFin
            RAISERROR('La fecha de inicio no puede ser mayor a la fecha fin.', 16, 1);

        SELECT 
            P.IDPaciente,
            P.Nombre + ' ' + P.Apellido AS NombrePaciente,
            P.Telefono,
            P.Email,
            C.IDCita,
            C.FechaHora,
            C.Diagnostico,
            C.Estado AS EstadoCita
        FROM CITAS C
        INNER JOIN PACIENTES P ON C.IDPaciente = P.IDPaciente
        WHERE C.IDMedico = @IDMedico
          AND C.IDHospital = @IDHospital
          AND C.FechaHora BETWEEN @FechaInicio AND @FechaFin
        ORDER BY C.FechaHora DESC;

    END TRY
    BEGIN CATCH
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO

/* -- pruebas 

EXEC sp_PacientesPorMedicoHospital 
    @IDMedico = 1, 
    @IDHospital = 1, 
    @FechaInicio = '2026-01-01', 
    @FechaFin = '2026-12-31';
GO
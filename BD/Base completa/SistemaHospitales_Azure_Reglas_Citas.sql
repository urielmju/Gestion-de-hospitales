-- Agrega reglas de negocio a sp_RegistrarCita:
-- 1) El paciente y el medico deben pertenecer al mismo hospital.
-- 2) Los cupos son cada 30 minutos, dentro del horario 7:00-17:00.
-- Correr en Azure (reemplaza el procedimiento existente).

ALTER PROCEDURE [dbo].[sp_RegistrarCita]
    @IDPaciente INT,
    @IDMedico INT,
    @IDHospital INT,
    @FechaHora DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- validaciones
        IF NOT EXISTS (SELECT 1 FROM PACIENTES WHERE IDPaciente = @IDPaciente AND Estado = 'A')
            RAISERROR('El paciente no existe o esta inactivo.', 16, 1);

        IF NOT EXISTS (SELECT 1 FROM MEDICOS WHERE IDMedico = @IDMedico AND Estado = 'A')
            RAISERROR('El medico no existe o esta inactivo.', 16, 1);

        IF NOT EXISTS (SELECT 1 FROM HOSPITALES WHERE IDHospital = @IDHospital AND Estado = 'A')
            RAISERROR('El hospital no existe o esta inactivo.', 16, 1);

        -- verificar que el medico pertenece al hospital
        IF NOT EXISTS (SELECT 1 FROM MEDICOS WHERE IDMedico = @IDMedico AND IDHospital = @IDHospital)
            RAISERROR('El medico no pertenece al hospital especificado.', 16, 1);

        -- verificar que el paciente pertenece al mismo hospital que el medico
        IF NOT EXISTS (SELECT 1 FROM PACIENTES WHERE IDPaciente = @IDPaciente AND IDHospital = @IDHospital)
            RAISERROR('El paciente y el medico deben pertenecer al mismo hospital.', 16, 1);

        -- verificar horario laboral (7:00 a 17:00) y cupos de 30 minutos
        DECLARE @Hora TIME = CAST(@FechaHora AS TIME);
        IF @Hora < '07:00' OR @Hora >= '17:00'
            RAISERROR('El horario de atencion es de 7:00 a.m. a 5:00 p.m.', 16, 1);

        IF DATEPART(MINUTE, @FechaHora) NOT IN (0, 30) OR DATEPART(SECOND, @FechaHora) != 0
            RAISERROR('Los cupos son cada 30 minutos (ej. 9:00, 9:30, 10:00).', 16, 1);

        -- verificar doble booking
        IF EXISTS (SELECT 1 FROM CITAS WHERE IDMedico = @IDMedico AND FechaHora = @FechaHora AND Estado != 'CA')
            RAISERROR('El medico ya tiene una cita en ese horario.', 16, 1);

        -- registrar la cita
        INSERT INTO CITAS (IDPaciente, IDMedico, IDHospital, FechaHora, Estado)
        VALUES (@IDPaciente, @IDMedico, @IDHospital, @FechaHora, 'P');

        DECLARE @IDCita INT = SCOPE_IDENTITY();

        -- log de transaccion
        INSERT INTO LOG_TRANSACCIONES (Tipo, Estado, Descripcion, FechaFin)
        VALUES ('RegistrarCita', 'C',
                'Cita ID ' + CAST(@IDCita AS VARCHAR) + ' registrada para paciente ' + CAST(@IDPaciente AS VARCHAR),
                GETDATE());

        COMMIT TRANSACTION;

        SELECT
            C.IDCita,
            P.Nombre + ' ' + P.Apellido AS NombrePaciente,
            M.Nombre + ' ' + M.Apellido AS NombreMedico,
            H.Nombre AS NombreHospital,
            C.FechaHora,
            C.Estado
        FROM CITAS C
        INNER JOIN PACIENTES P ON C.IDPaciente = P.IDPaciente
        INNER JOIN MEDICOS M ON C.IDMedico = M.IDMedico
        INNER JOIN HOSPITALES H ON C.IDHospital = H.IDHospital
        WHERE C.IDCita = @IDCita;

        PRINT 'Cita registrada exitosamente. ID: ' + CAST(@IDCita AS VARCHAR);

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        INSERT INTO LOG_TRANSACCIONES (Tipo, Estado, Descripcion, FechaFin, MensajeError)
        VALUES ('RegistrarCita', 'E', 'Error al registrar cita', GETDATE(), @msg);
        RAISERROR(@msg, 16, 1);
    END CATCH
END;

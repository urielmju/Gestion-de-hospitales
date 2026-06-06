--triggers varios 
USE SistemaHospitales;
GO
CREATE TRIGGER trg_Auditoria_Pacientes
ON PACIENTES
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM INSERTED) AND NOT EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        INSERT INTO AUDITORIA (Tabla, IDRegistro, Operacion, FechaHora, DatosDespues)
        SELECT 
            'PACIENTES',
            IDPaciente,
            'I',
            GETDATE(),
            'Nombre: ' + Nombre + ' ' + Apellido + 
            ' | Hospital: ' + CAST(IDHospital AS VARCHAR) +
            ' | Estado: ' + Estado
        FROM INSERTED;
    END
    IF EXISTS (SELECT 1 FROM INSERTED) AND EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        INSERT INTO AUDITORIA (Tabla, IDRegistro, Operacion, FechaHora, DatosAntes, DatosDespues)
        SELECT 
            'PACIENTES',
            I.IDPaciente,
            'U',
            GETDATE(),
            'Nombre: ' + D.Nombre + ' ' + D.Apellido + 
            ' | Estado: ' + D.Estado,
            'Nombre: ' + I.Nombre + ' ' + I.Apellido + 
            ' | Estado: ' + I.Estado
        FROM INSERTED I
        INNER JOIN DELETED D ON I.IDPaciente = D.IDPaciente;
    END
    IF NOT EXISTS (SELECT 1 FROM INSERTED) AND EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        INSERT INTO AUDITORIA (Tabla, IDRegistro, Operacion, FechaHora, DatosAntes)
        SELECT 
            'PACIENTES',
            IDPaciente,
            'D',
            GETDATE(),
            'Nombre: ' + Nombre + ' ' + Apellido + 
            ' | Hospital: ' + CAST(IDHospital AS VARCHAR)
        FROM DELETED;
    END
END;
GO
CREATE TRIGGER trg_Auditoria_Citas
ON CITAS
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM INSERTED) AND NOT EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        INSERT INTO AUDITORIA (Tabla, IDRegistro, Operacion, FechaHora, DatosDespues)
        SELECT 
            'CITAS',
            IDCita,
            'I',
            GETDATE(),
            'Paciente: ' + CAST(IDPaciente AS VARCHAR) +
            ' | Medico: ' + CAST(IDMedico AS VARCHAR) +
            ' | Fecha: ' + CAST(FechaHora AS VARCHAR) +
            ' | Estado: ' + Estado
        FROM INSERTED;
    END

    IF EXISTS (SELECT 1 FROM INSERTED) AND EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        INSERT INTO AUDITORIA (Tabla, IDRegistro, Operacion, FechaHora, DatosAntes, DatosDespues)
        SELECT 
            'CITAS',
            I.IDCita,
            'U',
            GETDATE(),
            'Estado: ' + D.Estado + ' | Diagnostico: ' + ISNULL(D.Diagnostico, 'NULL'),
            'Estado: ' + I.Estado + ' | Diagnostico: ' + ISNULL(I.Diagnostico, 'NULL')
        FROM INSERTED I
        INNER JOIN DELETED D ON I.IDCita = D.IDCita;
    END

    IF NOT EXISTS (SELECT 1 FROM INSERTED) AND EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        INSERT INTO AUDITORIA (Tabla, IDRegistro, Operacion, FechaHora, DatosAntes)
        SELECT 
            'CITAS',
            IDCita,
            'D',
            GETDATE(),
            'Paciente: ' + CAST(IDPaciente AS VARCHAR) +
            ' | Medico: ' + CAST(IDMedico AS VARCHAR) +
            ' | Fecha: ' + CAST(FechaHora AS VARCHAR)
        FROM DELETED;
    END
END;
GO
CREATE TRIGGER trg_Auditoria_Pagos
ON PAGOS
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM INSERTED) AND NOT EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        INSERT INTO AUDITORIA (Tabla, IDRegistro, Operacion, FechaHora, DatosDespues)
        SELECT 
            'PAGOS',
            IDPago,
            'I',
            GETDATE(),
            'Paciente: ' + CAST(IDPaciente AS VARCHAR) +
            ' | Monto: ' + CAST(Monto AS VARCHAR) +
            ' | Metodo: ' + ISNULL(MetodoPago, 'NULL') +
            ' | Estado: ' + Estado
        FROM INSERTED;
    END

    IF EXISTS (SELECT 1 FROM INSERTED) AND EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        INSERT INTO AUDITORIA (Tabla, IDRegistro, Operacion, FechaHora, DatosAntes, DatosDespues)
        SELECT 
            'PAGOS',
            I.IDPago,
            'U',
            GETDATE(),
            'Estado: ' + D.Estado + ' | Monto: ' + CAST(D.Monto AS VARCHAR),
            'Estado: ' + I.Estado + ' | Monto: ' + CAST(I.Monto AS VARCHAR)
        FROM INSERTED I
        INNER JOIN DELETED D ON I.IDPago = D.IDPago;
    END

    IF NOT EXISTS (SELECT 1 FROM INSERTED) AND EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        INSERT INTO AUDITORIA (Tabla, IDRegistro, Operacion, FechaHora, DatosAntes)
        SELECT 
            'PAGOS',
            IDPago,
            'D',
            GETDATE(),
            'Paciente: ' + CAST(IDPaciente AS VARCHAR) +
            ' | Monto: ' + CAST(Monto AS VARCHAR) +
            ' | Estado: ' + Estado
        FROM DELETED;
    END
END;
GO

/* pruebas 
INSERT INTO PACIENTES (IDHospital, Nombre, Apellido, FechaNacimiento, Genero, Telefono)
VALUES (1, 'Test', 'Auditoria', '1995-01-01', 'M', '9999-9999');
UPDATE CITAS SET Estado = 'C' WHERE IDCita = 1;
UPDATE PAGOS SET Estado = 'PA' WHERE IDPago = 1;
SELECT * FROM AUDITORIA ORDER BY FechaHora DESC;
GO
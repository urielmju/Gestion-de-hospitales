--triger para control de stock 
USE SistemaHospitales;
GO

CREATE TRIGGER trg_ControlStock
ON PRESCRIPCIONES
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (
            SELECT 1
            FROM INSERTED I
            INNER JOIN INVENTARIO_MEDICAMENTOS IM 
                ON I.IDMedicamento = IM.IDMedicamento
               AND I.IDHospital = IM.IDHospital
            WHERE IM.CantidadStock < I.Cantidad
        )
        BEGIN
            RAISERROR('Stock insuficiente para uno o mas medicamentos prescritos.', 16, 1);
        END
        IF EXISTS (
            SELECT 1
            FROM INSERTED I
            WHERE NOT EXISTS (
                SELECT 1 FROM INVENTARIO_MEDICAMENTOS IM
                WHERE IM.IDMedicamento = I.IDMedicamento
                  AND IM.IDHospital = I.IDHospital
            )
        )
        BEGIN
            RAISERROR('El medicamento no existe en el inventario del hospital.', 16, 1);
        END
        UPDATE IM
        SET IM.CantidadStock = IM.CantidadStock - I.Cantidad,
            IM.FechaActualizacion = GETDATE()
        FROM INVENTARIO_MEDICAMENTOS IM
        INNER JOIN INSERTED I 
            ON IM.IDMedicamento = I.IDMedicamento
           AND IM.IDHospital = I.IDHospital;
        INSERT INTO AUDITORIA (Tabla, IDRegistro, Operacion, FechaHora, DatosDespues)
        SELECT 
            'PRESCRIPCIONES',
            I.IDPrescripcion,
            'I',
            GETDATE(),
            'Medicamento: ' + CAST(I.IDMedicamento AS VARCHAR) + 
            ' | Cantidad: ' + CAST(I.Cantidad AS VARCHAR) +
            ' | Hospital: ' + CAST(I.IDHospital AS VARCHAR)
        FROM INSERTED I;

    END TRY
    BEGIN CATCH
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO
/*pruebas 
-- debe funcionar 
INSERT INTO PRESCRIPCIONES 
    (IDTratamiento, IDMedicamento, IDHospital, Cantidad, Dosis, Frecuencia, FechaInicio, FechaFin)
VALUES 
    (1, 1, 1, 10, '500mg', 'Cada 8 horas', '2026-05-01', '2026-05-10');

-- verificar stock
SELECT CantidadStock FROM INVENTARIO_MEDICAMENTOS WHERE IDMedicamento = 1 AND IDHospital = 1;

-- falla
INSERT INTO PRESCRIPCIONES 
    (IDTratamiento, IDMedicamento, IDHospital, Cantidad, Dosis, Frecuencia, FechaInicio, FechaFin)
VALUES 
    (1, 1, 1, 999, '500mg', 'Cada 8 horas', '2026-05-01', '2026-05-10');
GO
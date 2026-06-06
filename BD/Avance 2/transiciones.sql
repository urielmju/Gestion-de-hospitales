-- transiciones 
USE SistemaHospitales;
GO
CREATE PROCEDURE sp_RegistrarTratamientoCompleto
    @IDCita INT,
    @Descripcion VARCHAR(500),
    @CostoTotal DECIMAL(10,2),
    @FechaInicio DATE,
    @IDMedicamento INT,
    @IDHospital INT,
    @Cantidad INT,
    @Dosis VARCHAR(100),
    @Frecuencia VARCHAR(100),
    @MetodoPago VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IDTratamiento INT;
    DECLARE @IDPaciente INT;

    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM CITAS WHERE IDCita = @IDCita)
            RAISERROR('La cita especificada no existe.', 16, 1);
        IF NOT EXISTS (SELECT 1 FROM MEDICAMENTOS WHERE IDMedicamento = @IDMedicamento AND Estado = 'A')
            RAISERROR('El medicamento no existe o esta inactivo.', 16, 1);
        SELECT @IDPaciente = IDPaciente FROM CITAS WHERE IDCita = @IDCita;
        INSERT INTO TRATAMIENTOS (IDCita, Descripcion, CostoTotal, FechaInicio, Estado)
        VALUES (@IDCita, @Descripcion, @CostoTotal, @FechaInicio, 'A');

        SET @IDTratamiento = SCOPE_IDENTITY();
        INSERT INTO PRESCRIPCIONES 
            (IDTratamiento, IDMedicamento, IDHospital, Cantidad, Dosis, Frecuencia, FechaInicio)
        VALUES 
            (@IDTratamiento, @IDMedicamento, @IDHospital, @Cantidad, @Dosis, @Frecuencia, @FechaInicio);
        INSERT INTO PAGOS (IDPaciente, IDTratamiento, IDHospital, Monto, MetodoPago, Estado)
        VALUES (@IDPaciente, @IDTratamiento, @IDHospital, @CostoTotal, @MetodoPago, 'P');
        INSERT INTO LOG_TRANSACCIONES (Tipo, Estado, Descripcion, FechaFin)
        VALUES ('RegistrarTratamiento', 'C',
                'Tratamiento ID ' + CAST(@IDTratamiento AS VARCHAR) + ' registrado para cita ' + CAST(@IDCita AS VARCHAR),
                GETDATE());
        COMMIT TRANSACTION;
        SELECT @IDTratamiento AS IDTratamientoCreado;
        PRINT 'Tratamiento registrado exitosamente. ID: ' + CAST(@IDTratamiento AS VARCHAR);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        INSERT INTO LOG_TRANSACCIONES (Tipo, Estado, Descripcion, FechaFin, MensajeError)
        VALUES ('RegistrarTratamiento', 'E', 'Error al registrar tratamiento', GETDATE(), @msg);
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO
CREATE PROCEDURE sp_BuscarPacientes
    @Nombre VARCHAR(100) = NULL,
    @Apellido VARCHAR(100) = NULL,
    @IDHospital INT = NULL,
    @Estado CHAR(1) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(1000) = N'
        SELECT P.IDPaciente, P.Nombre, P.Apellido, P.Telefono, P.Email,
               H.Nombre AS NombreHospital, P.Estado
        FROM PACIENTES P
        INNER JOIN HOSPITALES H ON P.IDHospital = H.IDHospital
        WHERE 1=1';

    IF @Nombre IS NOT NULL
        SET @sql = @sql + N' AND P.Nombre LIKE ''%'' + @Nombre + ''%''';
    IF @Apellido IS NOT NULL
        SET @sql = @sql + N' AND P.Apellido LIKE ''%'' + @Apellido + ''%''';
    IF @IDHospital IS NOT NULL
        SET @sql = @sql + N' AND P.IDHospital = @IDHospital';
    IF @Estado IS NOT NULL
        SET @sql = @sql + N' AND P.Estado = @Estado';

    SET @sql = @sql + N' ORDER BY P.Apellido, P.Nombre';

    EXEC sp_executesql @sql,
        N'@Nombre VARCHAR(100), @Apellido VARCHAR(100), @IDHospital INT, @Estado CHAR(1)',
        @Nombre, @Apellido, @IDHospital, @Estado;
END;
GO
CREATE PROCEDURE sp_ReporteStockBajo
    @IDHospital INT,
    @StockMinimo INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NombreMed VARCHAR(100);
    DECLARE @Stock INT;
    DECLARE @Costo DECIMAL(10,2);
    DECLARE @Contador INT = 0;

    CREATE TABLE #StockBajo (
        NombreMedicamento VARCHAR(100),
        StockActual INT,
        CostoPorUnidad DECIMAL(10,2),
        Alerta VARCHAR(50)
    );

    DECLARE cur_Stock CURSOR FOR
        SELECT M.Nombre, IM.CantidadStock, M.CostoPorUnidad
        FROM INVENTARIO_MEDICAMENTOS IM
        INNER JOIN MEDICAMENTOS M ON IM.IDMedicamento = M.IDMedicamento
        WHERE IM.IDHospital = @IDHospital
          AND IM.CantidadStock <= @StockMinimo
          AND M.Estado = 'A'
        ORDER BY IM.CantidadStock ASC;

    OPEN cur_Stock;
    FETCH NEXT FROM cur_Stock INTO @NombreMed, @Stock, @Costo;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @Alerta VARCHAR(50);

        IF @Stock = 0
            SET @Alerta = 'CRITICO - Sin stock';
        ELSE IF @Stock <= 10
            SET @Alerta = 'URGENTE - Stock muy bajo';
        ELSE
            SET @Alerta = 'ADVERTENCIA - Stock bajo';

        INSERT INTO #StockBajo VALUES (@NombreMed, @Stock, @Costo, @Alerta);
        SET @Contador = @Contador + 1;

        FETCH NEXT FROM cur_Stock INTO @NombreMed, @Stock, @Costo;
    END;

    CLOSE cur_Stock;
    DEALLOCATE cur_Stock;

    SELECT * FROM #StockBajo ORDER BY StockActual ASC;
    PRINT 'Total medicamentos con stock bajo: ' + CAST(@Contador AS VARCHAR);

    DROP TABLE #StockBajo;
END;
GO

/*-- pruebas 
-- transaccion completa
EXEC sp_RegistrarTratamientoCompleto
    @IDCita = 6,
    @Descripcion = 'Tratamiento post consulta',
    @CostoTotal = 8000.00,
    @FechaInicio = '2026-06-01',
    @IDMedicamento = 1,
    @IDHospital = 1,
    @Cantidad = 5,
    @Dosis = '200mg',
    @Frecuencia = 'Cada 12 horas',
    @MetodoPago = 'Tarjeta';

-- sql dinamico
EXEC sp_BuscarPacientes @Nombre = 'Ana';
EXEC sp_BuscarPacientes @IDHospital = 1, @Estado = 'A';

-- cursor stock bajo (umbral 100 para ver el ibuprofeno)
EXEC sp_ReporteStockBajo @IDHospital = 1, @StockMinimo = 100;
GO
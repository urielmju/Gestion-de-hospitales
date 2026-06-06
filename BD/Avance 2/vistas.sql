--vistas
USE SistemaHospitales;
GO
CREATE VIEW vw_HistorialMedico AS
SELECT 
    P.IDPaciente,
    P.Nombre + ' ' + P.Apellido AS NombrePaciente,
    H.Nombre AS NombreHospital,
    C.IDCita,
    C.FechaHora,
    M.Nombre + ' ' + M.Apellido AS NombreMedico,
    M.Especialidad,
    C.Diagnostico,
    C.Estado AS EstadoCita,
    T.IDTratamiento,
    T.Descripcion AS DescripcionTratamiento,
    T.CostoTotal,
    T.Estado AS EstadoTratamiento
FROM PACIENTES P
INNER JOIN HOSPITALES H ON P.IDHospital = H.IDHospital
INNER JOIN CITAS C ON P.IDPaciente = C.IDPaciente
INNER JOIN MEDICOS M ON C.IDMedico = M.IDMedico
LEFT JOIN TRATAMIENTOS T ON C.IDCita = T.IDCita;
GO
CREATE VIEW vw_DisponibilidadMedicos AS
SELECT 
    M.IDMedico,
    M.Nombre + ' ' + M.Apellido AS NombreMedico,
    M.Especialidad,
    H.Nombre AS NombreHospital,
    HM.DiaSemana,
    HM.HoraInicio,
    HM.HoraFin,
    HM.Disponible
FROM MEDICOS M
INNER JOIN HOSPITALES H ON M.IDHospital = H.IDHospital
INNER JOIN HORARIOS_MEDICOS HM ON M.IDMedico = HM.IDMedico
WHERE M.Estado = 'A';
GO
CREATE VIEW vw_PagosPendientes AS
SELECT 
    PA.IDPaciente,
    PA.Nombre + ' ' + PA.Apellido AS NombrePaciente,
    H.Nombre AS NombreHospital,
    T.IDTratamiento,
    T.Descripcion AS DescripcionTratamiento,
    PG.IDPago,
    PG.Monto,
    PG.Fecha,
    PG.MetodoPago
FROM PAGOS PG
INNER JOIN PACIENTES PA ON PG.IDPaciente = PA.IDPaciente
INNER JOIN TRATAMIENTOS T ON PG.IDTratamiento = T.IDTratamiento
INNER JOIN HOSPITALES H ON PG.IDHospital = H.IDHospital
WHERE PG.Estado = 'P';
GO
CREATE VIEW vw_InventarioHospital AS
SELECT 
    H.Nombre AS NombreHospital,
    M.Nombre AS NombreMedicamento,
    M.Descripcion,
    M.CostoPorUnidad,
    M.UnidadMedida,
    IM.CantidadStock,
    IM.FechaActualizacion
FROM INVENTARIO_MEDICAMENTOS IM
INNER JOIN HOSPITALES H ON IM.IDHospital = H.IDHospital
INNER JOIN MEDICAMENTOS M ON IM.IDMedicamento = M.IDMedicamento
WHERE M.Estado = 'A';
GO
CREATE VIEW vw_ResumenCitasMedico AS
SELECT 
    M.IDMedico,
    M.Nombre + ' ' + M.Apellido AS NombreMedico,
    M.Especialidad,
    H.Nombre AS NombreHospital,
    COUNT(C.IDCita) AS TotalCitas,
    SUM(CASE WHEN C.Estado = 'P'  THEN 1 ELSE 0 END) AS CitasPendientes,
    SUM(CASE WHEN C.Estado = 'C'  THEN 1 ELSE 0 END) AS CitasCompletadas,
    SUM(CASE WHEN C.Estado = 'CA' THEN 1 ELSE 0 END) AS CitasCanceladas
FROM MEDICOS M
INNER JOIN HOSPITALES H ON M.IDHospital = H.IDHospital
LEFT JOIN CITAS C ON M.IDMedico = C.IDMedico
WHERE M.Estado = 'A'
GROUP BY M.IDMedico, M.Nombre, M.Apellido, M.Especialidad, H.Nombre;
GO

/*-- pruebas 
SELECT * FROM vw_HistorialMedico;
SELECT * FROM vw_PagosPendientes;
SELECT * FROM vw_InventarioHospital;
SELECT * FROM vw_ResumenCitasMedico;
GO
use [SistemaHospitales] 
-- Indices en claves foráneas (búsquedas frecuentes)
CREATE INDEX IX_Pacientes_IDHospital ON PACIENTES(IDHospital);
CREATE INDEX IX_Medicos_IDHospital ON MEDICOS(IDHospital);
CREATE INDEX IX_Citas_IDPaciente ON CITAS(IDPaciente);
CREATE INDEX IX_Citas_IDMedico ON CITAS(IDMedico);
CREATE INDEX IX_Citas_IDHospital ON CITAS(IDHospital);
CREATE INDEX IX_Citas_FechaHora ON CITAS(FechaHora);
CREATE INDEX IX_Tratamientos_IDCita ON TRATAMIENTOS(IDCita);
CREATE INDEX IX_Prescripciones_IDTratamiento ON PRESCRIPCIONES(IDTratamiento);
CREATE INDEX IX_Prescripciones_IDMedicamento ON PRESCRIPCIONES(IDMedicamento);
CREATE INDEX IX_Prescripciones_FechaRegistro ON PRESCRIPCIONES(FechaRegistro);
CREATE INDEX IX_Pagos_IDPaciente ON PAGOS(IDPaciente);
CREATE INDEX IX_Pagos_IDTratamiento ON PAGOS(IDTratamiento);
CREATE INDEX IX_Pagos_Estado ON PAGOS(Estado);
CREATE INDEX IX_Pagos_Fecha ON PAGOS(Fecha);
CREATE INDEX IX_Usuarios_Username ON USUARIOS(Username);
CREATE INDEX IX_Usuarios_IDRol ON USUARIOS(IDRol);
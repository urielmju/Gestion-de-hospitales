--Auditoria
USE SistemaHospitales;
GO

ALTER TABLE AUDITORIA
ADD CONSTRAINT FK_Auditoria_Usuarios 
FOREIGN KEY (IDUsuario) REFERENCES USUARIOS(IDUsuario);
GO

GO
INSERT INTO MEDICOS (IDHospital, Nombre, Apellido, Especialidad, Telefono, Email, FechaContratacion) VALUES
(1, 'Maria', 'Jimenez', 'Pediatria', '8888-2222', 'mjimenez@hospital.com', '2019-03-10'),
(1, 'Luis', 'Vargas', 'Neurologia', '8888-3333', 'lvargas@hospital.com', '2021-07-01'),
(2, 'Sofia', 'Rojas', 'Dermatologia', '8888-4444', 'srojas@hospital.com', '2020-05-15'),
(2, 'Diego', 'Mora', 'Traumatologia', '8888-5555', 'dmora@hospital.com', '2022-01-20');
INSERT INTO PACIENTES (IDHospital, Nombre, Apellido, FechaNacimiento, Genero, Direccion, Telefono, Email) VALUES
(1, 'Pedro', 'Gonzalez', '1985-08-15', 'M', 'Alajuela Centro', '7777-3333', 'pgonzalez@email.com'),
(1, 'Laura', 'Vega', '1992-11-30', 'F', 'Heredia Norte', '7777-4444', 'lvega@email.com'),
(2, 'Marco', 'Salas', '1978-04-22', 'M', 'Cartago Sur', '7777-5555', 'msalas@email.com'),
(2, 'Carmen', 'Arias', '2000-01-10', 'F', 'Liberia Centro', '7777-6666', 'carias@email.com');
GO
INSERT INTO HORARIOS_MEDICOS (IDMedico, IDHospital, DiaSemana, HoraInicio, HoraFin, Disponible) VALUES
(1, 1, 2, '08:00', '12:00', 1),
(1, 1, 4, '08:00', '12:00', 1),
(1, 1, 6, '08:00', '11:00', 1);
INSERT INTO HORARIOS_MEDICOS (IDMedico, IDHospital, DiaSemana, HoraInicio, HoraFin, Disponible) VALUES
(2, 1, 2, '13:00', '17:00', 1),
(2, 1, 3, '08:00', '12:00', 1),
(2, 1, 5, '13:00', '17:00', 1);
INSERT INTO HORARIOS_MEDICOS (IDMedico, IDHospital, DiaSemana, HoraInicio, HoraFin, Disponible) VALUES
(3, 1, 2, '08:00', '16:00', 1),
(3, 1, 5, '08:00', '16:00', 1);
INSERT INTO HORARIOS_MEDICOS (IDMedico, IDHospital, DiaSemana, HoraInicio, HoraFin, Disponible) VALUES
(4, 2, 3, '09:00', '13:00', 1),
(4, 2, 4, '09:00', '13:00', 1);
INSERT INTO HORARIOS_MEDICOS (IDMedico, IDHospital, DiaSemana, HoraInicio, HoraFin, Disponible) VALUES
(5, 2, 2, '07:00', '15:00', 1),
(5, 2, 6, '07:00', '12:00', 1);
GO
INSERT INTO MEDICAMENTOS (Nombre, Descripcion, CostoPorUnidad, UnidadMedida) VALUES
('Amoxicilina', 'Antibiotico de amplio espectro', 350.00, 'capsulas'),
('Paracetamol', 'Analgesico y antipiretico', 150.00, 'tabletas'),
('Omeprazol', 'Inhibidor de bomba de protones', 420.00, 'capsulas'),
('Metformina', 'Antidiabetico oral', 280.00, 'tabletas'),
('Losartan', 'Antihipertensivo', 390.00, 'tabletas');
INSERT INTO INVENTARIO_MEDICAMENTOS (IDMedicamento, IDHospital, CantidadStock) VALUES
(2, 1, 200),
(3, 1, 150),
(4, 1, 180),
(5, 1, 120),
(6, 1, 90);
INSERT INTO INVENTARIO_MEDICAMENTOS (IDMedicamento, IDHospital, CantidadStock) VALUES
(1, 2, 300),
(2, 2, 250),
(3, 2, 100),
(4, 2, 200),
(5, 2, 160),
(6, 2, 140);
GO
GO
INSERT INTO ROLES (NombreRol, Descripcion) VALUES
('Paciente', 'Usuario paciente del sistema'),
('Medico', 'Usuario medico del sistema'),
('Admin_Hospital', 'Administrador de un hospital'),
('Admin_Sistema', 'Administrador del sistema global');
INSERT INTO PERMISOS (NombrePermiso, Descripcion, Modulo) VALUES
('VerMiPerfil', 'Ver datos personales', 'Perfil'),
('EditarMiPerfil', 'Editar datos personales', 'Perfil'),
('VerMisCitas', 'Ver citas asignadas', 'Citas'),
('RegistrarCita', 'Crear nueva cita', 'Citas'),
('EditarCita', 'Modificar cita', 'Citas'),
('CancelarCita', 'Cancelar cita', 'Citas'),
('VerMiHistorialMedico', 'Ver historial medico completo', 'Historial'),
('RegistrarTratamiento', 'Registrar tratamiento', 'Tratamientos'),
('RegistrarPrescripcion', 'Registrar prescripcion de medicamento', 'Prescripciones'),
('VerMedicamentos', 'Ver catalogo de medicamentos', 'Medicamentos'),
('VerInventario', 'Ver inventario de medicamentos', 'Medicamentos'),
('RegistrarPago', 'Registrar pago', 'Pagos'),
('VerMisPagos', 'Ver historial de pagos', 'Pagos'),
('VerPacientes', 'Ver lista de pacientes', 'Pacientes'),
('CrearPaciente', 'Crear nuevo paciente', 'Pacientes'),
('EditarPaciente', 'Modificar datos paciente', 'Pacientes'),
('VerMedicos', 'Ver lista de medicos', 'Medicos'),
('CrearMedico', 'Crear nuevo medico', 'Medicos'),
('EditarMedico', 'Modificar datos medico', 'Medicos'),
('GestionUsuarios', 'Crear y editar usuarios', 'Usuarios'),
('VerReportes', 'Acceder a reportes avanzados', 'Reportes'),
('GestionAuditoria', 'Ver logs de auditoria', 'Auditoria');
INSERT INTO ROLES_PERMISOS (IDRol, IDPermiso) VALUES
(1, 1), (1, 2), (1, 3), (1, 7), (1, 12), (1, 13);
INSERT INTO ROLES_PERMISOS (IDRol, IDPermiso) VALUES
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 8), (2, 9), (2, 10), (2, 11), (2, 14);

INSERT INTO ROLES_PERMISOS (IDRol, IDPermiso) VALUES
(3, 1), (3, 3), (3, 4), (3, 5), (3, 6), (3, 8), (3, 9), (3, 10), (3, 11), (3, 12),
(3, 13), (3, 14), (3, 15), (3, 16), (3, 17), (3, 18), (3, 19), (3, 20), (3, 21), (3, 22);
INSERT INTO ROLES_PERMISOS (IDRol, IDPermiso)
SELECT 4, IDPermiso FROM PERMISOS;
GO
INSERT INTO USUARIOS (IDRol, IDHospital, IDMedico, Username, PasswordHash, Email) VALUES
(4, NULL, NULL, 'admin_sistema', 'hash_admin123', 'admin@sistema.com'),
(3, 1, NULL, 'admin_h1', 'hash_admin_h1', 'admin@hospitalcentral.com'),
(3, 2, NULL, 'admin_h2', 'hash_admin_h2', 'admin@metropolitano.com'),
(2, 1, 1, 'cmora', 'hash_cmora', 'cmora@hospital.com'),
(2, 1, 2, 'mjimenez', 'hash_mjimenez', 'mjimenez@hospital.com'),
(2, 1, 3, 'lvargas', 'hash_lvargas', 'lvargas@hospital.com'),
(2, 2, 4, 'srojas', 'hash_srojas', 'srojas@hospital.com'),
(2, 2, 5, 'dmora', 'hash_dmora', 'dmora@hospital.com'),
(1, 1, NULL, 'ana_lopez', 'hash_ana', 'alopez@email.com'),
(1, 1, NULL, 'pedro_gon', 'hash_pedro', 'pgonzalez@email.com');
GO
GO

INSERT INTO CITAS (IDPaciente, IDMedico, IDHospital, FechaHora, Diagnostico, Estado) VALUES
(2, 2, 1, '2026-03-10 09:00:00', 'Bronquitis aguda', 'C'),
(3, 3, 1, '2026-03-15 14:00:00', 'Migraña cronica', 'C'),
(4, 4, 2, '2026-03-20 10:00:00', 'Dermatitis atopica', 'C'),
(5, 5, 2, '2026-03-25 08:00:00', 'Fractura de muneca', 'C'),
(2, 2, 1, '2026-04-05 09:00:00', NULL, 'P'),
(3, 3, 1, '2026-04-10 14:00:00', NULL, 'P'),
(4, 4, 2, '2026-04-15 10:00:00', NULL, 'CA'),
(5, 5, 2, '2026-04-20 08:00:00', NULL, 'P');
GO
INSERT INTO TRATAMIENTOS (IDCita, Descripcion, CostoTotal, FechaInicio, FechaFin, Estado) VALUES
(7, 'Tratamiento bronquitis con antibioticos', 12000.00, '2026-03-10', '2026-03-20', 'F'),
(8, 'Tratamiento neurologico para migraña', 25000.00, '2026-03-15', '2026-04-15', 'F'),
(9, 'Tratamiento dermatologico topico', 8000.00, '2026-03-20', '2026-03-30', 'F'),
(10, 'Inmovilizacion y fisioterapia', 35000.00, '2026-03-25', '2026-05-25', 'A');

INSERT INTO PAGOS (IDPaciente, IDTratamiento, IDHospital, Monto, MetodoPago, Estado) VALUES
(2, 3, 1, 12000.00, 'Tarjeta', 'PA'),
(3, 4, 1, 25000.00, 'Efectivo', 'PA'),
(4, 5, 2, 8000.00, 'Tarjeta', 'PA'),
(5, 6, 2, 35000.00, 'Transferencia', 'P');
GO


/*-- pruebas 
GO

-- resumen general de la bd
SELECT 'HOSPITALES'   AS Tabla, COUNT(*) AS Registros FROM HOSPITALES
UNION ALL
SELECT 'PACIENTES',    COUNT(*) FROM PACIENTES
UNION ALL
SELECT 'MEDICOS',      COUNT(*) FROM MEDICOS
UNION ALL
SELECT 'HORARIOS',     COUNT(*) FROM HORARIOS_MEDICOS
UNION ALL
SELECT 'CITAS',        COUNT(*) FROM CITAS
UNION ALL
SELECT 'MEDICAMENTOS', COUNT(*) FROM MEDICAMENTOS
UNION ALL
SELECT 'INVENTARIO',   COUNT(*) FROM INVENTARIO_MEDICAMENTOS
UNION ALL
SELECT 'TRATAMIENTOS', COUNT(*) FROM TRATAMIENTOS
UNION ALL
SELECT 'PRESCRIPCIONES', COUNT(*) FROM PRESCRIPCIONES
UNION ALL
SELECT 'PAGOS',        COUNT(*) FROM PAGOS
UNION ALL
SELECT 'USUARIOS',     COUNT(*) FROM USUARIOS
UNION ALL
SELECT 'ROLES',        COUNT(*) FROM ROLES
UNION ALL
SELECT 'PERMISOS',     COUNT(*) FROM PERMISOS
UNION ALL
SELECT 'ROLES_PERMISOS', COUNT(*) FROM ROLES_PERMISOS
UNION ALL
SELECT 'AUDITORIA',    COUNT(*) FROM AUDITORIA
UNION ALL
SELECT 'LOG_TRANSACCIONES', COUNT(*) FROM LOG_TRANSACCIONES;
GO
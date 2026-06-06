use [SistemaHospitales] 
-- Insertar Roles
INSERT INTO ROLES (NombreRol, Descripcion) VALUES
('Paciente', 'Usuario paciente del sistema'),
('Medico', 'Usuario médico del sistema'),
('Admin_Hospital', 'Administrador de un hospital'),
('Admin_Sistema', 'Administrador del sistema global');
 
-- Insertar Permisos
INSERT INTO PERMISOS (NombrePermiso, Descripcion, Modulo) VALUES
('VerMiPerfil', 'Ver datos personales', 'Perfil'),
('EditarMiPerfil', 'Editar datos personales', 'Perfil'),
('VerMisCitas', 'Ver citas asignadas', 'Citas'),
('RegistrarCita', 'Crear nueva cita', 'Citas'),
('EditarCita', 'Modificar cita', 'Citas'),
('CancelarCita', 'Cancelar cita', 'Citas'),
('VerMiHistorialMedico', 'Ver historial médico completo', 'Historial'),
('RegistrarTratamiento', 'Registrar tratamiento', 'Tratamientos'),
('RegistrarPrescripcion', 'Registrar prescripción de medicamento', 'Prescripciones'),
('VerMedicamentos', 'Ver catálogo de medicamentos', 'Medicamentos'),
('VerInventario', 'Ver inventario de medicamentos', 'Medicamentos'),
('RegistrarPago', 'Registrar pago', 'Pagos'),
('VerMisPagos', 'Ver historial de pagos', 'Pagos'),
('VerPacientes', 'Ver lista de pacientes', 'Pacientes'),
('CrearPaciente', 'Crear nuevo paciente', 'Pacientes'),
('EditarPaciente', 'Modificar datos paciente', 'Pacientes'),
('VerMedicos', 'Ver lista de médicos', 'Medicos'),
('CrearMedico', 'Crear nuevo médico', 'Medicos'),
('EditarMedico', 'Modificar datos médico', 'Medicos'),
('GestionUsuarios', 'Crear y editar usuarios', 'Usuarios'),
('VerReportes', 'Acceder a reportes avanzados', 'Reportes'),
('GestionAuditoria', 'Ver logs de auditoría', 'Auditoria');
 
-- Insertar Relaciones Rol-Permiso para PACIENTE
INSERT INTO ROLES_PERMISOS (IDRol, IDPermiso) VALUES
(1, 1), (1, 2), (1, 3), (1, 7), (1, 12), (1, 13); -- Paciente: ver perfil, citas, historial, pagos
 
-- Insertar Relaciones Rol-Permiso para MEDICO
INSERT INTO ROLES_PERMISOS (IDRol, IDPermiso) VALUES
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 8), (2, 9), (2, 10), (2, 11), (2, 14); -- Medico: ver pacientes, crear citas, registrar tratamientos
 
-- Insertar Relaciones Rol-Permiso para ADMIN_HOSPITAL
INSERT INTO ROLES_PERMISOS (IDRol, IDPermiso) VALUES
(3, 1), (3, 3), (3, 4), (3, 5), (3, 6), (3, 8), (3, 9), (3, 10), (3, 11), (3, 12), 
(3, 13), (3, 14), (3, 15), (3, 16), (3, 17), (3, 18), (3, 19), (3, 20), (3, 21), (3, 22);
 
-- Insertar Relaciones Rol-Permiso para ADMIN_SISTEMA (todos los permisos)
INSERT INTO ROLES_PERMISOS (IDRol, IDPermiso) 
SELECT 4, IDPermiso FROM PERMISOS;
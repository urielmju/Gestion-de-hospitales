-- Nuevos roles: Recepcionista y Farmaceutico
-- Correr DESPUES de SistemaHospitales_Azure_Seed.sql

INSERT INTO ROLES (NombreRol, Descripcion) VALUES
('Recepcionista', 'Registro de pacientes, cobro de consultas y medicamentos, agenda de citas'),
('Farmaceutico', 'Gestion de inventario y stock de medicamentos');

-- Permisos para RECEPCIONISTA (IDRol 5)
INSERT INTO ROLES_PERMISOS (IDRol, IDPermiso) VALUES
(5, 4),  -- RegistrarCita
(5, 12), -- RegistrarPago
(5, 14), -- VerPacientes
(5, 15), -- CrearPaciente
(5, 16); -- EditarPaciente

-- Permisos para FARMACEUTICO (IDRol 6)
INSERT INTO ROLES_PERMISOS (IDRol, IDPermiso) VALUES
(6, 10), -- VerMedicamentos
(6, 11); -- VerInventario

use [SistemaHospitales]
 
INSERT INTO HOSPITALES (Nombre, Direccion, Telefono, Estado) VALUES
('Hospital Central San José', 'Calle Principal 100, San José', '2222-3333', 'A'),
('Hospital Metropolitano', 'Avenida 2, Cartago', '2555-4444', 'A');
PRINT 'Base de datos SistemaHospitales creada exitosamente!'
PRINT 'Total de tablas: 16'
PRINT 'Tablas principales: HOSPITALES, PACIENTES, MEDICOS, CITAS, TRATAMIENTOS, MEDICAMENTOS, INVENTARIO_MEDICAMENTOS, PRESCRIPCIONES, PAGOS'
PRINT 'Tablas de seguridad: USUARIOS, ROLES, PERMISOS, ROLES_PERMISOS'
PRINT 'Tablas de auditoría: AUDITORIA, LOG_TRANSACCIONES'
GO
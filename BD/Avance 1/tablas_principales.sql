
USE SistemaHospitales;
GO
 --tablas pricipales
 
-- 1. HOSPITALES
CREATE TABLE HOSPITALES (
    IDHospital INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200),
    Telefono VARCHAR(20),
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Estado CHAR(1) DEFAULT 'A' CHECK (Estado IN ('A', 'I'))
);
 
-- 2. PACIENTES
CREATE TABLE PACIENTES (
    IDPaciente INT PRIMARY KEY IDENTITY(1,1),
    IDHospital INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    FechaNacimiento DATE,
    Genero CHAR(1) CHECK (Genero IN ('M', 'F', 'O')),
    Direccion VARCHAR(200),
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Estado CHAR(1) DEFAULT 'A' CHECK (Estado IN ('A', 'I')),
    FOREIGN KEY (IDHospital) REFERENCES HOSPITALES(IDHospital)
);
 
-- 3. MEDICOS
CREATE TABLE MEDICOS (
    IDMedico INT PRIMARY KEY IDENTITY(1,1),
    IDHospital INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Especialidad VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    FechaContratacion DATE,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Estado CHAR(1) DEFAULT 'A' CHECK (Estado IN ('A', 'I')),
    FOREIGN KEY (IDHospital) REFERENCES HOSPITALES(IDHospital)
);
 
-- 4. HORARIOS_MEDICOS
CREATE TABLE HORARIOS_MEDICOS (
    IDHorario INT PRIMARY KEY IDENTITY(1,1),
    IDMedico INT NOT NULL,
    IDHospital INT NOT NULL,
    DiaSemana INT NOT NULL CHECK (DiaSemana BETWEEN 1 AND 7),
    HoraInicio TIME NOT NULL,
    HoraFin TIME NOT NULL,
    Disponible BIT DEFAULT 1,
    FOREIGN KEY (IDMedico) REFERENCES MEDICOS(IDMedico),
    FOREIGN KEY (IDHospital) REFERENCES HOSPITALES(IDHospital),
    UNIQUE(IDMedico, DiaSemana, HoraInicio)
);
 
-- 5. CITAS
CREATE TABLE CITAS (
    IDCita INT PRIMARY KEY IDENTITY(1,1),
    IDPaciente INT NOT NULL,
    IDMedico INT NOT NULL,
    IDHospital INT NOT NULL,
    FechaHora DATETIME NOT NULL,
    Diagnostico VARCHAR(500),
    Estado CHAR(1) DEFAULT 'P' CHECK (Estado IN ('P', 'C', 'CA')), -- P=Pendiente, C=Completada, CA=Cancelada
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IDPaciente) REFERENCES PACIENTES(IDPaciente),
    FOREIGN KEY (IDMedico) REFERENCES MEDICOS(IDMedico),
    FOREIGN KEY (IDHospital) REFERENCES HOSPITALES(IDHospital),
    UNIQUE(IDMedico, FechaHora) -- No duplicar horarios para el mismo medico
);
 
-- 6. MEDICAMENTOS
CREATE TABLE MEDICAMENTOS (
    IDMedicamento INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(500),
    CostoPorUnidad DECIMAL(10,2) NOT NULL,
    UnidadMedida VARCHAR(20), -- mg, ml, tabletas, etc.
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Estado CHAR(1) DEFAULT 'A' CHECK (Estado IN ('A', 'I'))
);
 
-- 7. INVENTARIO_MEDICAMENTOS
CREATE TABLE INVENTARIO_MEDICAMENTOS (
    IDInventario INT PRIMARY KEY IDENTITY(1,1),
    IDMedicamento INT NOT NULL,
    IDHospital INT NOT NULL,
    CantidadStock INT NOT NULL DEFAULT 0 CHECK (CantidadStock >= 0),
    FechaActualizacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IDMedicamento) REFERENCES MEDICAMENTOS(IDMedicamento),
    FOREIGN KEY (IDHospital) REFERENCES HOSPITALES(IDHospital),
    UNIQUE(IDMedicamento, IDHospital)
);
 
-- 8. TRATAMIENTOS
CREATE TABLE TRATAMIENTOS (
    IDTratamiento INT PRIMARY KEY IDENTITY(1,1),
    IDCita INT NOT NULL,
    Descripcion VARCHAR(500),
    CostoTotal DECIMAL(10,2) NOT NULL,
    FechaInicio DATE,
    FechaFin DATE,
    Estado CHAR(1) DEFAULT 'A' CHECK (Estado IN ('A', 'F', 'C')), -- A=Activo, F=Finalizado, C=Cancelado
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IDCita) REFERENCES CITAS(IDCita)
);
 
-- 9. PRESCRIPCIONES
CREATE TABLE PRESCRIPCIONES (
    IDPrescripcion INT PRIMARY KEY IDENTITY(1,1),
    IDTratamiento INT NOT NULL,
    IDMedicamento INT NOT NULL,
    IDHospital INT NOT NULL,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    Dosis VARCHAR(100),
    Frecuencia VARCHAR(100),
    FechaInicio DATE,
    FechaFin DATE,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IDTratamiento) REFERENCES TRATAMIENTOS(IDTratamiento),
    FOREIGN KEY (IDMedicamento) REFERENCES MEDICAMENTOS(IDMedicamento),
    FOREIGN KEY (IDHospital) REFERENCES HOSPITALES(IDHospital)
);
 
-- 10. PAGOS
CREATE TABLE PAGOS (
    IDPago INT PRIMARY KEY IDENTITY(1,1),
    IDPaciente INT NOT NULL,
    IDTratamiento INT NOT NULL,
    IDHospital INT NOT NULL,
    Fecha DATETIME DEFAULT GETDATE(),
    Monto DECIMAL(10,2) NOT NULL CHECK (Monto > 0),
    MetodoPago VARCHAR(50),
    Estado CHAR(1) DEFAULT 'P' CHECK (Estado IN ('P', 'PA', 'C')), -- P=Pendiente, PA=Pagado, C=Cancelado
    FechaRegistro DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IDPaciente) REFERENCES PACIENTES(IDPaciente),
    FOREIGN KEY (IDTratamiento) REFERENCES TRATAMIENTOS(IDTratamiento),
    FOREIGN KEY (IDHospital) REFERENCES HOSPITALES(IDHospital)
);
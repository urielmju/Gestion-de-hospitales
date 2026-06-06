use [SistemaHospitales]
-- 15. AUDITORIA
CREATE TABLE AUDITORIA (
    IDAuditoria INT PRIMARY KEY IDENTITY(1,1),
    Tabla VARCHAR(100) NOT NULL,
    IDRegistro INT,
    Operacion CHAR(1) NOT NULL CHECK (Operacion IN ('I', 'U', 'D')), -- Insert, Update, Delete
    IDUsuario INT,
    FechaHora DATETIME DEFAULT GETDATE(),
    DatosAntes VARCHAR(MAX),
    DatosDespues VARCHAR(MAX)
);
 
-- 16. LOG_TRANSACCIONES
CREATE TABLE LOG_TRANSACCIONES (
    IDLog INT PRIMARY KEY IDENTITY(1,1),
    IDUsuario INT,
    Tipo VARCHAR(50),
    Estado CHAR(1) DEFAULT 'I' CHECK (Estado IN ('I', 'C', 'E')), -- Iniciada, Completada, Error
    Descripcion VARCHAR(500),
    FechaInicio DATETIME DEFAULT GETDATE(),
    FechaFin DATETIME,
    MensajeError VARCHAR(MAX),
    FOREIGN KEY (IDUsuario) REFERENCES USUARIOS(IDUsuario)
);
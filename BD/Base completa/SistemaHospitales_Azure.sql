/****** Object:  Table [dbo].[HOSPITALES]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOSPITALES](
	[IDHospital] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Direccion] [varchar](200) NULL,
	[Telefono] [varchar](20) NULL,
	[FechaRegistro] [datetime] NULL,
	[Estado] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[IDHospital] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PACIENTES]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PACIENTES](
	[IDPaciente] [int] IDENTITY(1,1) NOT NULL,
	[IDHospital] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Apellido] [varchar](100) NOT NULL,
	[FechaNacimiento] [date] NULL,
	[Genero] [char](1) NULL,
	[Direccion] [varchar](200) NULL,
	[Telefono] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[FechaRegistro] [datetime] NULL,
	[Estado] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[IDPaciente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MEDICOS]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MEDICOS](
	[IDMedico] [int] IDENTITY(1,1) NOT NULL,
	[IDHospital] [int] NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Apellido] [varchar](100) NOT NULL,
	[Especialidad] [varchar](100) NOT NULL,
	[Telefono] [varchar](20) NULL,
	[Email] [varchar](100) NULL,
	[FechaContratacion] [date] NULL,
	[FechaRegistro] [datetime] NULL,
	[Estado] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[IDMedico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CITAS]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CITAS](
	[IDCita] [int] IDENTITY(1,1) NOT NULL,
	[IDPaciente] [int] NOT NULL,
	[IDMedico] [int] NOT NULL,
	[IDHospital] [int] NOT NULL,
	[FechaHora] [datetime] NOT NULL,
	[Diagnostico] [varchar](500) NULL,
	[Estado] [varchar](2) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IDCita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[IDMedico] ASC,
	[FechaHora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TRATAMIENTOS]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRATAMIENTOS](
	[IDTratamiento] [int] IDENTITY(1,1) NOT NULL,
	[IDCita] [int] NOT NULL,
	[Descripcion] [varchar](500) NULL,
	[CostoTotal] [decimal](10, 2) NOT NULL,
	[FechaInicio] [date] NULL,
	[FechaFin] [date] NULL,
	[Estado] [char](1) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IDTratamiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_HistorialMedico]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_HistorialMedico] AS
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
/****** Object:  Table [dbo].[HORARIOS_MEDICOS]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HORARIOS_MEDICOS](
	[IDHorario] [int] IDENTITY(1,1) NOT NULL,
	[IDMedico] [int] NOT NULL,
	[IDHospital] [int] NOT NULL,
	[DiaSemana] [int] NOT NULL,
	[HoraInicio] [time](7) NOT NULL,
	[HoraFin] [time](7) NOT NULL,
	[Disponible] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[IDHorario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[IDMedico] ASC,
	[DiaSemana] ASC,
	[HoraInicio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_DisponibilidadMedicos]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DisponibilidadMedicos] AS
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
/****** Object:  Table [dbo].[PAGOS]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAGOS](
	[IDPago] [int] IDENTITY(1,1) NOT NULL,
	[IDPaciente] [int] NOT NULL,
	[IDTratamiento] [int] NOT NULL,
	[IDHospital] [int] NOT NULL,
	[Fecha] [datetime] NULL,
	[Monto] [decimal](10, 2) NOT NULL,
	[MetodoPago] [varchar](50) NULL,
	[Estado] [varchar](2) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IDPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_PagosPendientes]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_PagosPendientes] AS
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
/****** Object:  Table [dbo].[MEDICAMENTOS]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MEDICAMENTOS](
	[IDMedicamento] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Descripcion] [varchar](500) NULL,
	[CostoPorUnidad] [decimal](10, 2) NOT NULL,
	[UnidadMedida] [varchar](20) NULL,
	[FechaRegistro] [datetime] NULL,
	[Estado] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[IDMedicamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[INVENTARIO_MEDICAMENTOS]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INVENTARIO_MEDICAMENTOS](
	[IDInventario] [int] IDENTITY(1,1) NOT NULL,
	[IDMedicamento] [int] NOT NULL,
	[IDHospital] [int] NOT NULL,
	[CantidadStock] [int] NOT NULL,
	[FechaActualizacion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IDInventario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[IDMedicamento] ASC,
	[IDHospital] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_InventarioHospital]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_InventarioHospital] AS
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
/****** Object:  View [dbo].[vw_ResumenCitasMedico]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ResumenCitasMedico] AS
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
/****** Object:  Table [dbo].[AUDITORIA]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AUDITORIA](
	[IDAuditoria] [int] IDENTITY(1,1) NOT NULL,
	[Tabla] [varchar](100) NOT NULL,
	[IDRegistro] [int] NULL,
	[Operacion] [char](1) NOT NULL,
	[IDUsuario] [int] NULL,
	[FechaHora] [datetime] NULL,
	[DatosAntes] [varchar](max) NULL,
	[DatosDespues] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[IDAuditoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOG_TRANSACCIONES]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOG_TRANSACCIONES](
	[IDLog] [int] IDENTITY(1,1) NOT NULL,
	[IDUsuario] [int] NULL,
	[Tipo] [varchar](50) NULL,
	[Estado] [char](1) NULL,
	[Descripcion] [varchar](500) NULL,
	[FechaInicio] [datetime] NULL,
	[FechaFin] [datetime] NULL,
	[MensajeError] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[IDLog] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PERMISOS]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PERMISOS](
	[IDPermiso] [int] IDENTITY(1,1) NOT NULL,
	[NombrePermiso] [varchar](100) NOT NULL,
	[Descripcion] [varchar](200) NULL,
	[Modulo] [varchar](50) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IDPermiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[NombrePermiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PRESCRIPCIONES]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRESCRIPCIONES](
	[IDPrescripcion] [int] IDENTITY(1,1) NOT NULL,
	[IDTratamiento] [int] NOT NULL,
	[IDMedicamento] [int] NOT NULL,
	[IDHospital] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[Dosis] [varchar](100) NULL,
	[Frecuencia] [varchar](100) NULL,
	[FechaInicio] [date] NULL,
	[FechaFin] [date] NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IDPrescripcion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ROLES]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLES](
	[IDRol] [int] IDENTITY(1,1) NOT NULL,
	[NombreRol] [varchar](50) NOT NULL,
	[Descripcion] [varchar](200) NULL,
	[FechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IDRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[NombreRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ROLES_PERMISOS]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ROLES_PERMISOS](
	[IDRolPermiso] [int] IDENTITY(1,1) NOT NULL,
	[IDRol] [int] NOT NULL,
	[IDPermiso] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IDRolPermiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[IDRol] ASC,
	[IDPermiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USUARIOS]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USUARIOS](
	[IDUsuario] [int] IDENTITY(1,1) NOT NULL,
	[IDRol] [int] NOT NULL,
	[IDHospital] [int] NULL,
	[IDPaciente] [int] NULL,
	[IDMedico] [int] NULL,
	[Username] [varchar](50) NOT NULL,
	[PasswordHash] [varchar](255) NOT NULL,
	[Email] [varchar](100) NULL,
	[FechaCreacion] [datetime] NULL,
	[FechaUltimoLogin] [datetime] NULL,
	[Estado] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[IDUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Citas_FechaHora]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Citas_FechaHora] ON [dbo].[CITAS]
(
	[FechaHora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Citas_IDHospital]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Citas_IDHospital] ON [dbo].[CITAS]
(
	[IDHospital] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Citas_IDMedico]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Citas_IDMedico] ON [dbo].[CITAS]
(
	[IDMedico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Citas_IDPaciente]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Citas_IDPaciente] ON [dbo].[CITAS]
(
	[IDPaciente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Medicos_IDHospital]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Medicos_IDHospital] ON [dbo].[MEDICOS]
(
	[IDHospital] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Pacientes_IDHospital]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Pacientes_IDHospital] ON [dbo].[PACIENTES]
(
	[IDHospital] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Pagos_Estado]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Pagos_Estado] ON [dbo].[PAGOS]
(
	[Estado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Pagos_Fecha]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Pagos_Fecha] ON [dbo].[PAGOS]
(
	[Fecha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Pagos_IDPaciente]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Pagos_IDPaciente] ON [dbo].[PAGOS]
(
	[IDPaciente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Pagos_IDTratamiento]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Pagos_IDTratamiento] ON [dbo].[PAGOS]
(
	[IDTratamiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Prescripciones_FechaRegistro]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Prescripciones_FechaRegistro] ON [dbo].[PRESCRIPCIONES]
(
	[FechaRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Prescripciones_IDMedicamento]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Prescripciones_IDMedicamento] ON [dbo].[PRESCRIPCIONES]
(
	[IDMedicamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Prescripciones_IDTratamiento]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Prescripciones_IDTratamiento] ON [dbo].[PRESCRIPCIONES]
(
	[IDTratamiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Tratamientos_IDCita]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Tratamientos_IDCita] ON [dbo].[TRATAMIENTOS]
(
	[IDCita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Usuarios_IDRol]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Usuarios_IDRol] ON [dbo].[USUARIOS]
(
	[IDRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Usuarios_Username]    Script Date: 22/04/2026 22:47:18 ******/
CREATE NONCLUSTERED INDEX [IX_Usuarios_Username] ON [dbo].[USUARIOS]
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AUDITORIA] ADD  DEFAULT (getdate()) FOR [FechaHora]
GO
ALTER TABLE [dbo].[CITAS] ADD  CONSTRAINT [DF_Citas_Estado]  DEFAULT ('P') FOR [Estado]
GO
ALTER TABLE [dbo].[CITAS] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[HORARIOS_MEDICOS] ADD  DEFAULT ((1)) FOR [Disponible]
GO
ALTER TABLE [dbo].[HOSPITALES] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[HOSPITALES] ADD  DEFAULT ('A') FOR [Estado]
GO
ALTER TABLE [dbo].[INVENTARIO_MEDICAMENTOS] ADD  DEFAULT ((0)) FOR [CantidadStock]
GO
ALTER TABLE [dbo].[INVENTARIO_MEDICAMENTOS] ADD  DEFAULT (getdate()) FOR [FechaActualizacion]
GO
ALTER TABLE [dbo].[LOG_TRANSACCIONES] ADD  DEFAULT ('I') FOR [Estado]
GO
ALTER TABLE [dbo].[LOG_TRANSACCIONES] ADD  DEFAULT (getdate()) FOR [FechaInicio]
GO
ALTER TABLE [dbo].[MEDICAMENTOS] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[MEDICAMENTOS] ADD  DEFAULT ('A') FOR [Estado]
GO
ALTER TABLE [dbo].[MEDICOS] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[MEDICOS] ADD  DEFAULT ('A') FOR [Estado]
GO
ALTER TABLE [dbo].[PACIENTES] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[PACIENTES] ADD  DEFAULT ('A') FOR [Estado]
GO
ALTER TABLE [dbo].[PAGOS] ADD  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[PAGOS] ADD  CONSTRAINT [DF_Pagos_Estado]  DEFAULT ('P') FOR [Estado]
GO
ALTER TABLE [dbo].[PAGOS] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[PERMISOS] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[PRESCRIPCIONES] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[ROLES] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[TRATAMIENTOS] ADD  DEFAULT ('A') FOR [Estado]
GO
ALTER TABLE [dbo].[TRATAMIENTOS] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[USUARIOS] ADD  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[USUARIOS] ADD  DEFAULT ('A') FOR [Estado]
GO
ALTER TABLE [dbo].[AUDITORIA]  WITH CHECK ADD  CONSTRAINT [FK_Auditoria_Usuarios] FOREIGN KEY([IDUsuario])
REFERENCES [dbo].[USUARIOS] ([IDUsuario])
GO
ALTER TABLE [dbo].[AUDITORIA] CHECK CONSTRAINT [FK_Auditoria_Usuarios]
GO
ALTER TABLE [dbo].[CITAS]  WITH CHECK ADD FOREIGN KEY([IDHospital])
REFERENCES [dbo].[HOSPITALES] ([IDHospital])
GO
ALTER TABLE [dbo].[CITAS]  WITH CHECK ADD FOREIGN KEY([IDMedico])
REFERENCES [dbo].[MEDICOS] ([IDMedico])
GO
ALTER TABLE [dbo].[CITAS]  WITH CHECK ADD FOREIGN KEY([IDPaciente])
REFERENCES [dbo].[PACIENTES] ([IDPaciente])
GO
ALTER TABLE [dbo].[HORARIOS_MEDICOS]  WITH CHECK ADD FOREIGN KEY([IDHospital])
REFERENCES [dbo].[HOSPITALES] ([IDHospital])
GO
ALTER TABLE [dbo].[HORARIOS_MEDICOS]  WITH CHECK ADD FOREIGN KEY([IDMedico])
REFERENCES [dbo].[MEDICOS] ([IDMedico])
GO
ALTER TABLE [dbo].[INVENTARIO_MEDICAMENTOS]  WITH CHECK ADD FOREIGN KEY([IDHospital])
REFERENCES [dbo].[HOSPITALES] ([IDHospital])
GO
ALTER TABLE [dbo].[INVENTARIO_MEDICAMENTOS]  WITH CHECK ADD FOREIGN KEY([IDMedicamento])
REFERENCES [dbo].[MEDICAMENTOS] ([IDMedicamento])
GO
ALTER TABLE [dbo].[LOG_TRANSACCIONES]  WITH CHECK ADD FOREIGN KEY([IDUsuario])
REFERENCES [dbo].[USUARIOS] ([IDUsuario])
GO
ALTER TABLE [dbo].[MEDICOS]  WITH CHECK ADD FOREIGN KEY([IDHospital])
REFERENCES [dbo].[HOSPITALES] ([IDHospital])
GO
ALTER TABLE [dbo].[PACIENTES]  WITH CHECK ADD FOREIGN KEY([IDHospital])
REFERENCES [dbo].[HOSPITALES] ([IDHospital])
GO
ALTER TABLE [dbo].[PAGOS]  WITH CHECK ADD FOREIGN KEY([IDHospital])
REFERENCES [dbo].[HOSPITALES] ([IDHospital])
GO
ALTER TABLE [dbo].[PAGOS]  WITH CHECK ADD FOREIGN KEY([IDPaciente])
REFERENCES [dbo].[PACIENTES] ([IDPaciente])
GO
ALTER TABLE [dbo].[PAGOS]  WITH CHECK ADD FOREIGN KEY([IDTratamiento])
REFERENCES [dbo].[TRATAMIENTOS] ([IDTratamiento])
GO
ALTER TABLE [dbo].[PRESCRIPCIONES]  WITH CHECK ADD FOREIGN KEY([IDHospital])
REFERENCES [dbo].[HOSPITALES] ([IDHospital])
GO
ALTER TABLE [dbo].[PRESCRIPCIONES]  WITH CHECK ADD FOREIGN KEY([IDMedicamento])
REFERENCES [dbo].[MEDICAMENTOS] ([IDMedicamento])
GO
ALTER TABLE [dbo].[PRESCRIPCIONES]  WITH CHECK ADD FOREIGN KEY([IDTratamiento])
REFERENCES [dbo].[TRATAMIENTOS] ([IDTratamiento])
GO
ALTER TABLE [dbo].[ROLES_PERMISOS]  WITH CHECK ADD FOREIGN KEY([IDPermiso])
REFERENCES [dbo].[PERMISOS] ([IDPermiso])
GO
ALTER TABLE [dbo].[ROLES_PERMISOS]  WITH CHECK ADD FOREIGN KEY([IDRol])
REFERENCES [dbo].[ROLES] ([IDRol])
GO
ALTER TABLE [dbo].[TRATAMIENTOS]  WITH CHECK ADD FOREIGN KEY([IDCita])
REFERENCES [dbo].[CITAS] ([IDCita])
GO
ALTER TABLE [dbo].[USUARIOS]  WITH CHECK ADD FOREIGN KEY([IDHospital])
REFERENCES [dbo].[HOSPITALES] ([IDHospital])
GO
ALTER TABLE [dbo].[USUARIOS]  WITH CHECK ADD FOREIGN KEY([IDMedico])
REFERENCES [dbo].[MEDICOS] ([IDMedico])
GO
ALTER TABLE [dbo].[USUARIOS]  WITH CHECK ADD FOREIGN KEY([IDPaciente])
REFERENCES [dbo].[PACIENTES] ([IDPaciente])
GO
ALTER TABLE [dbo].[USUARIOS]  WITH CHECK ADD FOREIGN KEY([IDRol])
REFERENCES [dbo].[ROLES] ([IDRol])
GO
ALTER TABLE [dbo].[AUDITORIA]  WITH CHECK ADD CHECK  (([Operacion]='D' OR [Operacion]='U' OR [Operacion]='I'))
GO
ALTER TABLE [dbo].[CITAS]  WITH CHECK ADD  CONSTRAINT [CK_Citas_Estado] CHECK  (([Estado]='CA' OR [Estado]='C' OR [Estado]='P'))
GO
ALTER TABLE [dbo].[CITAS] CHECK CONSTRAINT [CK_Citas_Estado]
GO
ALTER TABLE [dbo].[HORARIOS_MEDICOS]  WITH CHECK ADD CHECK  (([DiaSemana]>=(1) AND [DiaSemana]<=(7)))
GO
ALTER TABLE [dbo].[HOSPITALES]  WITH CHECK ADD CHECK  (([Estado]='I' OR [Estado]='A'))
GO
ALTER TABLE [dbo].[INVENTARIO_MEDICAMENTOS]  WITH CHECK ADD CHECK  (([CantidadStock]>=(0)))
GO
ALTER TABLE [dbo].[LOG_TRANSACCIONES]  WITH CHECK ADD CHECK  (([Estado]='E' OR [Estado]='C' OR [Estado]='I'))
GO
ALTER TABLE [dbo].[MEDICAMENTOS]  WITH CHECK ADD CHECK  (([Estado]='I' OR [Estado]='A'))
GO
ALTER TABLE [dbo].[MEDICOS]  WITH CHECK ADD CHECK  (([Estado]='I' OR [Estado]='A'))
GO
ALTER TABLE [dbo].[PACIENTES]  WITH CHECK ADD CHECK  (([Estado]='I' OR [Estado]='A'))
GO
ALTER TABLE [dbo].[PACIENTES]  WITH CHECK ADD CHECK  (([Genero]='O' OR [Genero]='F' OR [Genero]='M'))
GO
ALTER TABLE [dbo].[PAGOS]  WITH CHECK ADD CHECK  (([Monto]>(0)))
GO
ALTER TABLE [dbo].[PAGOS]  WITH CHECK ADD  CONSTRAINT [CK_Pagos_Estado] CHECK  (([Estado]='C' OR [Estado]='PA' OR [Estado]='P'))
GO
ALTER TABLE [dbo].[PAGOS] CHECK CONSTRAINT [CK_Pagos_Estado]
GO
ALTER TABLE [dbo].[PRESCRIPCIONES]  WITH CHECK ADD CHECK  (([Cantidad]>(0)))
GO
ALTER TABLE [dbo].[TRATAMIENTOS]  WITH CHECK ADD CHECK  (([Estado]='C' OR [Estado]='F' OR [Estado]='A'))
GO
ALTER TABLE [dbo].[USUARIOS]  WITH CHECK ADD CHECK  (([Estado]='I' OR [Estado]='A'))
GO
/****** Object:  StoredProcedure [dbo].[sp_BuscarPacientes]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- sql dinamico: busqueda flexible de pacientes
CREATE PROCEDURE [dbo].[sp_BuscarPacientes]
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
/****** Object:  StoredProcedure [dbo].[sp_InventarioYPrescripciones]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_InventarioYPrescripciones]
    @IDHospital INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM HOSPITALES WHERE IDHospital = @IDHospital)
            RAISERROR('El hospital especificado no existe.', 16, 1);

        SELECT 
            M.IDMedicamento,
            M.Nombre AS NombreMedicamento,
            M.Descripcion,
            M.CostoPorUnidad,
            M.UnidadMedida,
            IM.CantidadStock,
            ISNULL(SUM(PR.Cantidad), 0) AS TotalPrescrito30Dias
        FROM MEDICAMENTOS M
        INNER JOIN INVENTARIO_MEDICAMENTOS IM 
            ON M.IDMedicamento = IM.IDMedicamento
           AND IM.IDHospital = @IDHospital
        LEFT JOIN PRESCRIPCIONES PR 
            ON M.IDMedicamento = PR.IDMedicamento
           AND PR.IDHospital = @IDHospital
           AND PR.FechaRegistro >= DATEADD(DAY, -30, GETDATE())
        WHERE M.Estado = 'A'
        GROUP BY 
            M.IDMedicamento,
            M.Nombre,
            M.Descripcion,
            M.CostoPorUnidad,
            M.UnidadMedida,
            IM.CantidadStock
        ORDER BY M.Nombre;

    END TRY
    BEGIN CATCH
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_PacientesPorMedicoHospital]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PacientesPorMedicoHospital]
    @IDMedico INT,
    @IDHospital INT,
    @FechaInicio DATETIME,
    @FechaFin DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- validaciones
        IF NOT EXISTS (SELECT 1 FROM MEDICOS WHERE IDMedico = @IDMedico)
            RAISERROR('El medico especificado no existe.', 16, 1);

        IF NOT EXISTS (SELECT 1 FROM HOSPITALES WHERE IDHospital = @IDHospital)
            RAISERROR('El hospital especificado no existe.', 16, 1);

        IF @FechaInicio > @FechaFin
            RAISERROR('La fecha de inicio no puede ser mayor a la fecha fin.', 16, 1);

        SELECT 
            P.IDPaciente,
            P.Nombre + ' ' + P.Apellido AS NombrePaciente,
            P.Telefono,
            P.Email,
            C.IDCita,
            C.FechaHora,
            C.Diagnostico,
            C.Estado AS EstadoCita
        FROM CITAS C
        INNER JOIN PACIENTES P ON C.IDPaciente = P.IDPaciente
        WHERE C.IDMedico = @IDMedico
          AND C.IDHospital = @IDHospital
          AND C.FechaHora BETWEEN @FechaInicio AND @FechaFin
        ORDER BY C.FechaHora DESC;

    END TRY
    BEGIN CATCH
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_PagosPendientesPaciente]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PagosPendientesPaciente]
    @IDPaciente INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM PACIENTES WHERE IDPaciente = @IDPaciente)
            RAISERROR('El paciente especificado no existe.', 16, 1);

        SELECT 
            P.IDPago,
            PA.Nombre + ' ' + PA.Apellido AS NombrePaciente,
            T.IDTratamiento,
            T.Descripcion AS DescripcionTratamiento,
            T.CostoTotal,
            P.Monto,
            P.MetodoPago,
            P.Fecha,
            H.Nombre AS NombreHospital,
            T.CostoTotal - ISNULL((
                SELECT SUM(P2.Monto) 
                FROM PAGOS P2 
                WHERE P2.IDTratamiento = T.IDTratamiento 
                  AND P2.Estado = 'PA'
            ), 0) AS SaldoPendiente
        FROM PAGOS P
        INNER JOIN PACIENTES PA ON P.IDPaciente = PA.IDPaciente
        INNER JOIN TRATAMIENTOS T ON P.IDTratamiento = T.IDTratamiento
        INNER JOIN HOSPITALES H ON P.IDHospital = H.IDHospital
        WHERE P.IDPaciente = @IDPaciente
          AND P.Estado = 'P'
        ORDER BY P.Fecha DESC;

        SELECT 
            SUM(Monto) AS TotalPendiente
        FROM PAGOS
        WHERE IDPaciente = @IDPaciente
          AND Estado = 'P';

    END TRY
    BEGIN CATCH
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_RegistrarCita]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_RegistrarCita]
    @IDPaciente INT,
    @IDMedico INT,
    @IDHospital INT,
    @FechaHora DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- validaciones
        IF NOT EXISTS (SELECT 1 FROM PACIENTES WHERE IDPaciente = @IDPaciente AND Estado = 'A')
            RAISERROR('El paciente no existe o esta inactivo.', 16, 1);

        IF NOT EXISTS (SELECT 1 FROM MEDICOS WHERE IDMedico = @IDMedico AND Estado = 'A')
            RAISERROR('El medico no existe o esta inactivo.', 16, 1);

        IF NOT EXISTS (SELECT 1 FROM HOSPITALES WHERE IDHospital = @IDHospital AND Estado = 'A')
            RAISERROR('El hospital no existe o esta inactivo.', 16, 1);

        -- verificar que el medico pertenece al hospital
        IF NOT EXISTS (SELECT 1 FROM MEDICOS WHERE IDMedico = @IDMedico AND IDHospital = @IDHospital)
            RAISERROR('El medico no pertenece al hospital especificado.', 16, 1);

        -- verificar doble booking
        IF EXISTS (SELECT 1 FROM CITAS WHERE IDMedico = @IDMedico AND FechaHora = @FechaHora AND Estado != 'CA')
            RAISERROR('El medico ya tiene una cita en ese horario.', 16, 1);

        -- verificar disponibilidad en HORARIOS_MEDICOS
        DECLARE @DiaSemana INT = DATEPART(WEEKDAY, @FechaHora);
        DECLARE @Hora TIME = CAST(@FechaHora AS TIME);

        IF EXISTS (SELECT 1 FROM HORARIOS_MEDICOS 
                   WHERE IDMedico = @IDMedico 
                     AND DiaSemana = @DiaSemana
                     AND @Hora BETWEEN HoraInicio AND HoraFin
                     AND Disponible = 0)
            RAISERROR('El medico no esta disponible en ese horario.', 16, 1);

        -- registrar la cita
        INSERT INTO CITAS (IDPaciente, IDMedico, IDHospital, FechaHora, Estado)
        VALUES (@IDPaciente, @IDMedico, @IDHospital, @FechaHora, 'P');

        DECLARE @IDCita INT = SCOPE_IDENTITY();

        -- log de transaccion
        INSERT INTO LOG_TRANSACCIONES (Tipo, Estado, Descripcion, FechaFin)
        VALUES ('RegistrarCita', 'C', 
                'Cita ID ' + CAST(@IDCita AS VARCHAR) + ' registrada para paciente ' + CAST(@IDPaciente AS VARCHAR),
                GETDATE());

        COMMIT TRANSACTION;

        SELECT 
            C.IDCita,
            P.Nombre + ' ' + P.Apellido AS NombrePaciente,
            M.Nombre + ' ' + M.Apellido AS NombreMedico,
            H.Nombre AS NombreHospital,
            C.FechaHora,
            C.Estado
        FROM CITAS C
        INNER JOIN PACIENTES P ON C.IDPaciente = P.IDPaciente
        INNER JOIN MEDICOS M ON C.IDMedico = M.IDMedico
        INNER JOIN HOSPITALES H ON C.IDHospital = H.IDHospital
        WHERE C.IDCita = @IDCita;

        PRINT 'Cita registrada exitosamente. ID: ' + CAST(@IDCita AS VARCHAR);

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        INSERT INTO LOG_TRANSACCIONES (Tipo, Estado, Descripcion, FechaFin, MensajeError)
        VALUES ('RegistrarCita', 'E', 'Error al registrar cita', GETDATE(), @msg);
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_RegistrarTratamientoCompleto]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- transaccion: registrar tratamiento completo con pago
CREATE PROCEDURE [dbo].[sp_RegistrarTratamientoCompleto]
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

        -- validaciones
        IF NOT EXISTS (SELECT 1 FROM CITAS WHERE IDCita = @IDCita)
            RAISERROR('La cita especificada no existe.', 16, 1);

        IF NOT EXISTS (SELECT 1 FROM MEDICAMENTOS WHERE IDMedicamento = @IDMedicamento AND Estado = 'A')
            RAISERROR('El medicamento no existe o esta inactivo.', 16, 1);

        -- obtener paciente de la cita
        SELECT @IDPaciente = IDPaciente FROM CITAS WHERE IDCita = @IDCita;

        -- insertar tratamiento
        INSERT INTO TRATAMIENTOS (IDCita, Descripcion, CostoTotal, FechaInicio, Estado)
        VALUES (@IDCita, @Descripcion, @CostoTotal, @FechaInicio, 'A');

        SET @IDTratamiento = SCOPE_IDENTITY();

        -- insertar prescripcion (activa el trigger de stock)
        INSERT INTO PRESCRIPCIONES 
            (IDTratamiento, IDMedicamento, IDHospital, Cantidad, Dosis, Frecuencia, FechaInicio)
        VALUES 
            (@IDTratamiento, @IDMedicamento, @IDHospital, @Cantidad, @Dosis, @Frecuencia, @FechaInicio);

        -- registrar pago pendiente
        INSERT INTO PAGOS (IDPaciente, IDTratamiento, IDHospital, Monto, MetodoPago, Estado)
        VALUES (@IDPaciente, @IDTratamiento, @IDHospital, @CostoTotal, @MetodoPago, 'P');

        -- log
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
/****** Object:  StoredProcedure [dbo].[sp_ReporteStockBajo]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- cursor: reporte de stock bajo por hospital
CREATE PROCEDURE [dbo].[sp_ReporteStockBajo]
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
/****** Object:  StoredProcedure [dbo].[sp_TotalPagosPaciente]    Script Date: 22/04/2026 22:47:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_TotalPagosPaciente]
    @IDPaciente INT,
    @FechaInicio DATETIME,
    @FechaFin DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM PACIENTES WHERE IDPaciente = @IDPaciente)
            RAISERROR('El paciente especificado no existe.', 16, 1);

        IF @FechaInicio > @FechaFin
            RAISERROR('La fecha de inicio no puede ser mayor a la fecha fin.', 16, 1);
        SELECT 
            P.IDPago,
            PA.Nombre + ' ' + PA.Apellido AS NombrePaciente,
            T.Descripcion AS DescripcionTratamiento,
            H.Nombre AS NombreHospital,
            P.Fecha,
            P.Monto,
            P.MetodoPago,
            P.Estado
        FROM PAGOS P
        INNER JOIN PACIENTES PA ON P.IDPaciente = PA.IDPaciente
        INNER JOIN TRATAMIENTOS T ON P.IDTratamiento = T.IDTratamiento
        INNER JOIN HOSPITALES H ON P.IDHospital = H.IDHospital
        WHERE P.IDPaciente = @IDPaciente
          AND P.Fecha BETWEEN @FechaInicio AND @FechaFin
        ORDER BY P.Fecha DESC;
        SELECT 
            P.Estado,
            COUNT(*) AS CantidadPagos,
            SUM(P.Monto) AS TotalMonto
        FROM PAGOS P
        WHERE P.IDPaciente = @IDPaciente
          AND P.Fecha BETWEEN @FechaInicio AND @FechaFin
        GROUP BY P.Estado;
        SELECT 
            COUNT(*) AS TotalTransacciones,
            SUM(CASE WHEN Estado = 'PA' THEN Monto ELSE 0 END) AS TotalPagado,
            SUM(CASE WHEN Estado = 'P'  THEN Monto ELSE 0 END) AS TotalPendiente,
            SUM(Monto) AS TotalGeneral
        FROM PAGOS
        WHERE IDPaciente = @IDPaciente
          AND Fecha BETWEEN @FechaInicio AND @FechaFin;

    END TRY
    BEGIN CATCH
        DECLARE @msg VARCHAR(500) = ERROR_MESSAGE();
        RAISERROR(@msg, 16, 1);
    END CATCH
END;
GO

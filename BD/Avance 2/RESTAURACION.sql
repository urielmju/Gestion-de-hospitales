--RESTAURACION!!

USE master;
GO
-- desconectar usuarios
ALTER DATABASE SistemaHospitales SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
RESTORE DATABASE SistemaHospitales
FROM DISK = 'C:\Respaldos\Proyecto final respaldo\SistemaHospitales_Full.bak'
WITH 
    NORECOVERY,
    REPLACE,
    STATS = 10;
GO
RESTORE DATABASE SistemaHospitales
FROM DISK = 'C:\Respaldos\Proyecto final respaldo\SistemaHospitales_Diff.bak'
WITH 
    NORECOVERY,
    STATS = 10;
GO
RESTORE LOG SistemaHospitales
FROM DISK = 'C:\Respaldos\Proyecto final respaldo\SistemaHospitales_Log.bak'
WITH 
    RECOVERY,
    STATS = 10;
GO
ALTER DATABASE SistemaHospitales SET MULTI_USER;
GO
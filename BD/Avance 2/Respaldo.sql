--respaldos

USE master;
GO
-- respaldo completo
BACKUP DATABASE SistemaHospitales
TO DISK = 'C:\Respaldos\Proyecto final respaldo\SistemaHospitales_Full.bak'
WITH 
    FORMAT,
    NAME = 'SistemaHospitales - Respaldo Completo',
    DESCRIPTION = 'Respaldo completo del sistema de gestion de hospitales';
GO
-- respaldo diferencial
BACKUP DATABASE SistemaHospitales
TO DISK = 'C:\Respaldos\Proyecto final respaldo\SistemaHospitales_Diff.bak'
WITH 
    DIFFERENTIAL,
    NAME = 'SistemaHospitales - Respaldo Diferencial',
    DESCRIPTION = 'Respaldo diferencial del sistema de gestion de hospitales';
GO
-- respaldo del log
BACKUP LOG SistemaHospitales
TO DISK = 'C:\Respaldos\Proyecto final respaldo\SistemaHospitales_Log.bak'
WITH 
    NAME = 'SistemaHospitales - Respaldo Log',
    DESCRIPTION = 'Respaldo del log de transacciones';
GO
SELECT 
    bs.database_name,
    bs.backup_start_date,
    bs.backup_finish_date,
    CASE bs.type
        WHEN 'D' THEN 'Completo'
        WHEN 'I' THEN 'Diferencial'
        WHEN 'L' THEN 'Log'
    END AS TipoRespaldo,
    bmf.physical_device_name AS Archivo
FROM msdb.dbo.backupset bs
INNER JOIN msdb.dbo.backupmediafamily bmf 
    ON bs.media_set_id = bmf.media_set_id
WHERE bs.database_name = 'SistemaHospitales'
ORDER BY bs.backup_start_date DESC;
GO
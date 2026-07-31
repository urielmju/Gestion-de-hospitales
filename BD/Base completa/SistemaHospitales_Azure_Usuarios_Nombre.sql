-- Agrega Nombre y Apellido a USUARIOS para cuentas de staff sin tabla de perfil
-- (Recepcionista, Farmaceutico). Ya aplicado en Azure.

ALTER TABLE USUARIOS ADD Nombre VARCHAR(100) NULL, Apellido VARCHAR(100) NULL;

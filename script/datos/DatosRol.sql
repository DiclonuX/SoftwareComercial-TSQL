/*
Nombre: Servio Lemos
Descripcion: Script con el objetivo de generar datos semillas para la tabla ROL.
Fecha: 2025-03-05
Version: 1.0
*/

BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO Rol (Nombre) 
    VALUES ('Administrador'), ('AuxiliarRegistro');
    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
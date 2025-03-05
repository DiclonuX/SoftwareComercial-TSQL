/*
Nombre: Servio Lemos
Descripcion: Script contiene un trigger para auditoria de COMERCIANTE este afecta en INSERT y UPDATE
Fecha: 2025-03-05
Version: 1.0
*/

CREATE TRIGGER trg_Auditoria_Comerciante
ON Comerciante
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE C
        SET 
            C.FechaActualizacion = GETDATE(),
            C.UsuarioModificacionId = I.UsuarioModificacionId
        FROM 
            Comerciante C
        INNER JOIN 
            inserted I ON C.IdComerciante = I.IdComerciante
        WHERE 
            I.UsuarioModificacionId IS NOT NULL;

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
    END CATCH
END;
GO


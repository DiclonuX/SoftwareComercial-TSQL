/*
Nombre: Servio Lemos
Descripcion: Script contiene un trigger para auditoria de ESTABLECIMIENTO este afecta en INSERT y UPDATE
Fecha: 2025-03-05
Version: 1.0
*/

CREATE TRIGGER trg_Auditoria_Establecimiento
ON Establecimiento
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE E
    SET 
        E.FechaActualizacion = GETDATE(),
        E.UsuarioModificacionId = I.UsuarioModificacionId
    FROM 
        Establecimiento E
    INNER JOIN 
        inserted I ON E.IdEstablecimiento = I.IdEstablecimiento
    WHERE 
        I.UsuarioModificacionId IS NOT NULL;
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK;
        RAISERROR ('Error al actualizar los campos de auditoría en la tabla Establecimiento.', 16, 1);
    END
END;
GO

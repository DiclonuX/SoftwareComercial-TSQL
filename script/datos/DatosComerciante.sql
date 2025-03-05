/*
Nombre: Servio Lemos
Descripcion: Script con el objetivo de generar datos semillas para la tabla COMERCIANTE.
Fecha: 2025-03-05
Version: 1.0
*/

BEGIN TRY
    BEGIN TRANSACTION;
        INSERT INTO Comerciante (NombreRazonSocial, Municipio, Telefono, CorreoElectronico, Estado, UsuarioModificacion)
        VALUES ('Almacenes El Poblado', 'Bogotá', '3014567890', 'contacto@elpoblado.com.co', 1, 1),
               ('Distribuidora del Valle', 'Medellín', '3045678901', 'info@distribuidoradelvalle.com', 1, 1),
               ('Comercializadora del Pacífico', 'Cali', NULL, 'ventas@comercializadordelpacifico.com.co', 1, 2),
               ('Almacenes del Caribe', 'Barranquilla', '3056789012', 'contacto@almacenesdelcaribe.com.co', 1, 2),
               ('Tiendas El Turista', 'Cartagena', NULL, NULL, 0, 1);
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
/*
Nombre: Servio Lemos
Descripcion: Script con el objetivo de generar datos semillas para la tabla ESTABLECIMIENTOS.
Fecha: 2025-03-05
Version: 1.0
*/

BEGIN TRY
    BEGIN TRANSACTION;
      INSERT INTO Establecimiento (IdComerciante, NombreEstablecimiento, Ingresos, NumeroEmpleados, UsuarioModificacion)
      VALUES
            (1, 'Almacén El Poblado - Centro', 25000.00, 8, 1),
            (1, 'Almacén El Poblado - Norte', 30000.50, 10, 1),
            (2, 'Distribuidora del Valle - Sur', 18000.00, 6, 2),
            (3, 'Comercializadora del Pacífico - Oeste', 22000.30, 9, 2),
            (3, 'Comercializadora del Pacífico - Este', 35000.00, 12, 1),
            (4, 'Almacenes del Caribe - Puerto', 12000.00, 5, 1),
            (4, 'Almacenes del Caribe - Aeropuerto', 16000.40, 7, 1),
            (5, 'Tiendas El Turista - Centro Histórico', 28000.00, 10, 2),
            (5, 'Tiendas El Turista - Playa Blanca', 20000.90, 8, 2),
            (5, 'Tiendas El Turista - Aeropuerto', 32000.00, 11, 1);
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
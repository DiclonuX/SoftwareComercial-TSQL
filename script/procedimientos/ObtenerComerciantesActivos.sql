/*
Nombre: Servio Lemos
Descripcion: Script contiene un procedimiento almacenado con el objetivo de crear un reporte de comerciantes activos. 
Fecha: 2025-03-05
Version: 1.0
*/
CREATE PROCEDURE ObtenerComerciantesActivos
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        c.NombreRazonSocial, 
        c.Municipio, 
        c.Telefono, 
        c.CorreoElectronico, 
        c.FechaRegistro, 
        CASE WHEN c.Estado = 1 THEN 'Activo' ELSE 'Inactivo' END AS Estado,
        COUNT(e.Id) AS CantidadEstablecimientos,
        COALESCE(SUM(e.Ingresos), 0) AS TotalIngresos,
        COALESCE(SUM(e.NumeroEmpleados), 0) AS CantidadEmpleados
    FROM Comerciante c
    LEFT JOIN Establecimiento e ON c.Id = e.IdComerciante
    WHERE c.Estado = 1
    GROUP BY c.Id, c.NombreRazonSocial, c.Municipio, c.Telefono, c.CorreoElectronico, c.FechaRegistro, c.Estado
    ORDER BY CantidadEstablecimientos DESC;
END;
GO


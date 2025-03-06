# TSQL
# Proyecto de Base de Datos en Visual Studio

Este proyecto es una implementación de una base de datos relacional utilizando SQL Server. El proyecto incluye la creación de tablas, triggers, datos semilla y procedimientos almacenados para gestionar comerciantes, establecimientos, usuarios y roles.

## Estructura del Proyecto

El proyecto está compuesto por los siguientes componentes principales:

1. **Tablas**: Definición de las tablas `Rol`, `Usuario`, `Comerciante` y `Establecimiento`.
2. **Triggers**: Implementación de triggers para auditoría en las tablas `Comerciante` y `Establecimiento`.
3. **Datos Semilla**: Inserción de datos iniciales en las tablas `Rol`, `Usuario`, `Comerciante` y `Establecimiento`.
4. **Procedimientos Almacenados**: Creación de un procedimiento almacenado para obtener un reporte de comerciantes activos.

## Orden de ejecucion (Opcional)
Este orden se da por si no se desa desplegar desde el publish en Visual Studio.

1. Ejecutar tablas en el siguiente orden:
   
1.1 Rol.sql.

1.2 Usuario.sql.

1.3 Establecimiento.sql.

1.4 Comerciante.sql.

2. Ejecutar los trigger no importa el orden:

2.1 trg_Auditoria_Comerciante.sql.

2.2 trg_Auditoria_Establecimiento.sql.

3. Ejecutar los datos este tienen el siguiente orden.

3.1 DatosRol.sql.

3.2 DatosUsuario.sql.

3.3 DatosComerciante.sql

3.4 DatosEstablecimientos.sql.

4. Ejecutar el procedimiento almacenado.

4.1 ObtenerComerciantesActivos.sql.


## Imagen proyecto en visual studio
![Captura de Pantalla 2025-03-05 a la(s) 1 31 17 p  m](https://github.com/user-attachments/assets/e3dffcb1-1d48-4209-9765-524827ebff03)

## Tablas

### Tabla `Rol`
Esta tabla almacena los roles que pueden tener los usuarios en el sistema.

```sql
CREATE TABLE [dbo].[Rol]
(
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Nombre] NVARCHAR(50) UNIQUE NOT NULL
)
```
### Tabla Usuario
Esta tabla almacena la información de los usuarios del sistema.
```sql
CREATE TABLE [dbo].[Usuario]
(
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Nombre] NVARCHAR(100) NOT NULL,
    [CorreoElectronico] NVARCHAR(150) UNIQUE NOT NULL,
    [Contrasena] NVARCHAR(255) NOT NULL,
    [IdRol] INT NOT NULL,
    FOREIGN KEY (IdRol) REFERENCES Rol(Id)
)
```
### Tabla Comerciante
Esta tabla almacena la información de los comerciantes.
```sql
CREATE TABLE [dbo].[Comerciante]
(
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NombreRazonSocial] NVARCHAR(200) NOT NULL,
    [Municipio] NVARCHAR(100) NOT NULL,
    [Telefono] NVARCHAR(20) NULL,
    [CorreoElectronico] NVARCHAR(150) NULL,
    [FechaRegistro] DATETIME DEFAULT GETDATE() NOT NULL,
    [Estado] BIT NOT NULL DEFAULT 1,
    [FechaActualizacion] DATETIME NULL,
    [UsuarioModificacionId] INT NULL,
    FOREIGN KEY (UsuarioModificacionId) REFERENCES Usuario(Id)
)
```
### Tabla Establecimiento
Esta tabla almacena la información de los establecimientos asociados a los comerciantes.
```sql
CREATE TABLE [dbo].[Establecimiento]
(
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [IdComerciante] INT NOT NULL,
    [NombreEstablecimiento] NVARCHAR(200) NOT NULL,
    [Ingresos] DECIMAL(18,2) NOT NULL,
    [NumeroEmpleados] INT NOT NULL,
    [FechaActualizacion] DATETIME NULL,
    [UsuarioModificacionId] INT NULL,
    FOREIGN KEY (IdComerciante) REFERENCES Comerciante(Id) ON DELETE CASCADE,
    FOREIGN KEY (UsuarioModificacionId) REFERENCES Usuario(Id)
)
```

### Triggers
### Trigger trg_Auditoria_Comerciante
Este trigger actualiza los campos de auditoría (FechaActualizacion y UsuarioModificacionId) en la tabla Comerciante después de una operación de INSERT o UPDATE.
```sql
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
```


### Trigger trg_Auditoria_Establecimiento
Este trigger actualiza los campos de auditoría (FechaActualizacion y UsuarioModificacionId) en la tabla Establecimiento después de una operación de INSERT o UPDATE.
```sql
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
```
### Datos Semilla
Datos Semilla para la Tabla Rol
Se insertan roles iniciales en la tabla Rol.
```sql
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
```
### Datos Semilla para la Tabla Usuario
Se insertan usuarios iniciales en la tabla Usuario.
```sql
BEGIN TRY
    BEGIN TRANSACTION;
        INSERT INTO Usuario (Nombre, CorreoElectronico, Contrasena, IdRol)
        VALUES ('Admin', 'admin@comercio.com', 'hash', 1), ('Auxiliar', 'auxiliar@comercio.com', 'hash', 2);
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
```

### Datos Semilla para la Tabla Comerciante
Se insertan comerciantes iniciales en la tabla Comerciante.
```sql
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
```

### Datos Semilla para la Tabla Establecimiento
Se insertan establecimientos iniciales en la tabla Establecimiento.
```sql
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
```

### Procedimientos Almacenados
### Procedimiento Almacenado ObtenerComerciantesActivos
Este procedimiento almacenado genera un reporte de los comerciantes activos, incluyendo información sobre sus establecimientos.
```sql
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
```

Cómo Ejecutar el Proyecto
Clonar el Repositorio: Clona este repositorio en tu máquina local git clone https://github.com/tu-usuario/tu-repositorio.git.
Abrir en Visual Studio: Abre el proyecto en Visual Studio.
Ejecutar los Scripts SQL: Ejecuta los scripts SQL proporcionados en tu servidor SQL Server para crear las tablas, triggers, datos semilla y procedimientos almacenados.
Probar el Proyecto: Una vez que la base de datos esté configurada, puedes probar el proyecto ejecutando consultas y procedimientos almacenados desde Visual Studio o cualquier cliente SQL.

# Contacto

Nombre: Servio Lemos

Correo: servio.lemos@gmail.com

GitHub: [Repositorio del Proyecto](https://github.com/DiclonuX)



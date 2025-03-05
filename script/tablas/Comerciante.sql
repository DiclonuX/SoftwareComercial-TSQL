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

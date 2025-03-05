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

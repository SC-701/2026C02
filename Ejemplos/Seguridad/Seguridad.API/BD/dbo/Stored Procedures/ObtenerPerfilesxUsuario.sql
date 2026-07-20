-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerPerfilesxUsuario]
	-- Add the parameters for the stored procedure here
@IdUsuario UNIQUEIDENTIFIER = NULL,
@NombreUsuario VARCHAR(MAX) = NULL,
@CorreoElectronico VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT        Perfiles.Id, Perfiles.Nombre
FROM            Perfiles INNER JOIN
                         PerfilesxUsuario ON Perfiles.Id = PerfilesxUsuario.IdPerfil INNER JOIN
                         Usuarios ON PerfilesxUsuario.IdUsuario = Usuarios.Id
WHERE        (@IdUsuario IS NOT NULL AND Usuarios.Id = @IdUsuario)
			 OR (@IdUsuario IS NULL AND ((Usuarios.NombreUsuario = @Nombreusuario) OR (Usuarios.CorreoElectronico = @CorreoElectronico)))

END
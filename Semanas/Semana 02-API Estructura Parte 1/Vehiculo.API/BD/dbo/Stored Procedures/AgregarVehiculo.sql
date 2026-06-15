-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AgregarVehiculo]
	-- Add the parameters for the stored procedure here
	@Id AS uniqueidentifier
	,@IdModelo AS uniqueidentifier
	,@Placa AS varchar(max)
	,@Color AS varchar(max)
	,@Anio AS int
	,@Precio AS decimal(18,0)
	,@CorreoPropietario AS varchar(max)
	,@TelefonoPropietario AS varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRAN
    -- Insert statements for procedure here
	INSERT INTO [dbo].[Vehiculo]
           ([Id]
           ,[IdModelo]
           ,[Placa]
           ,[Color]
           ,[Anio]
           ,[Precio]
           ,[CorreoPropietario]
           ,[TelefonoPropietario])
     VALUES
           (@Id
			,@IdModelo
			,@Placa
			,@Color
			,@Anio
			,@Precio
			,@CorreoPropietario
			,@TelefonoPropietario)
			SELECT @ID
COMMIT TRAN
END
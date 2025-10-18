SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fns_GM_Distancia]
(
	@ToAddress VARCHAR(100),
    @FromAddress VARCHAR(100) 
)

Returns FLOAT
AS
BEGIN

DECLARE  
	@DistanceInKilometers VARCHAR(100) ,
    @Object AS INT ,
    @ResponseText AS VARCHAR(8000) ,
    @serviceUrl AS VARCHAR(500),
    @Response XML

SET @serviceUrl = 'http://maps.googleapis.com/maps/api/distancematrix/xml'
                + '?origins='+ @ToAddress 
                + '&destinations='+ @FromAddress
                + '&mode=driving&language=en-EN&units=metric;'
    
EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
EXEC sp_OAMethod @Object, 'open', NULL, 'get', @serviceUrl, 'false'    
EXEC sp_OAMethod @Object, 'send'
EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
 


SET @Response = @ResponseText COLLATE SQL_Latin1_General_CP1251_CS_AS

DECLARE @Status AS VARCHAR(20)
DECLARE @Distance FLOAT


SET @Status = @Response.value('(DistanceMatrixResponse/row/element/status)[1]',
                              'varchar(20)') 
--PRINT @Status
IF ( @Status = 'ZERO_RESULTS' ) 
    BEGIN

        SET @Distance = -1
    END
ELSE 
    BEGIN
        SET @Distance = @Response.value('(DistanceMatrixResponse/row/element/distance/value)[1]',
                                        'varchar(20)') 
    END
 

	-- Return the result of the function
	RETURN @Distance

END
GO

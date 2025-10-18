SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CalculateDistance]
    @ToAddress NVARCHAR(100) = '' ,
    @FromAddress NVARCHAR(100) = '' ,
    @DistanceistanceInKm FLOAT OUTPUT
AS 
    BEGIN

        DECLARE @Object INT
        DECLARE @ResponseonseText NVARCHAR(4000)
        DECLARE @StatuserviceUrl NVARCHAR(500)

        SET @StatuserviceUrl = 'http://maps.googleapis.com/maps/api/distancematrix/xml?origins='
            + @ToAddress + '&destinations=' + @FromAddress
            + '&mode=driving&language=en-EN&units=metric;'

        EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
            EXEC sp_OAMethod @Object, 'open', NULL, 'get', @StatuserviceUrl,
                'false'
        EXEC sp_OAMethod @Object, 'send'
        EXEC sp_OAMethod @Object, 'responseText', @ResponseonseText OUTPUT

        DECLARE @Response XML

        SET @Response = CAST(CAST(@ResponseonseText AS NVARCHAR(MAX)) AS XML)

        DECLARE @Status NVARCHAR(20)
        DECLARE @Distance NVARCHAR(20)

        SET @Status = @Response.value('(DistanceMatrixResponse/row/element/status)[1]',
                                      'NVARCHAR(20)')

        IF ( @Status = 'ZERO_RESULTS' ) 
            SET @Distance = NULL
        ELSE 
            SET @Distance = @Response.value('(DistanceMatrixResponse/row/element/distance/value)[1]',
                                            'NVARCHAR(20)')

        SET @DistanceistanceInKm = ROUND(CAST(@Distance AS FLOAT) / 1000, 1)

        PRINT @DistanceistanceInKm

    END
GO

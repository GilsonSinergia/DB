SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[stpBusca_Informacoes_Cidade](
    @Ds_Cidade VARCHAR(100)
)
AS BEGIN
 
    -- DECLARE @Ds_Cidade VARCHAR(100) = 'Vitória'
 
    DECLARE 
        @obj INT,
        @Url VARCHAR(255),
        @resposta VARCHAR(8000),
        @xml XML
    
    SET @Url = 'http://maps.googleapis.com/maps/api/geocode/xml?address=' + @Ds_Cidade + '&sensor=false'
    
    EXEC sys.sp_OACreate 'MSXML2.ServerXMLHTTP', @obj OUT
    EXEC sys.sp_OAMethod @obj, 'open', NULL, 'GET', @Url, false
    EXEC sys.sp_OAMethod @obj, 'send'
    EXEC sys.sp_OAGetProperty @obj, 'responseText', @resposta OUT
    EXEC sys.sp_OADestroy @obj
    
    
    SET @xml = @resposta COLLATE SQL_Latin1_General_CP1251_CS_AS
    
     SELECT @xml
    
    SELECT        
        @xml.value('(/GeocodeResponse/result/formatted_address)[1]', 'varchar(200)') AS Endereco,
        @xml.value('(/GeocodeResponse/result/address_component/long_name)[5]', 'varchar(200)') AS Estado,
        @xml.value('(/GeocodeResponse/result/address_component/short_name)[5]', 'varchar(200)') AS Estado_Sigla,
        @xml.value('(/GeocodeResponse/result/address_component/long_name)[4]', 'varchar(200)') AS Pais,
        @xml.value('(/GeocodeResponse/result/address_component/short_name)[4]', 'varchar(200)') AS Pais_Sigla,
        @xml.value('(/GeocodeResponse/result/geometry/location/lat)[1]', 'varchar(200)') AS Latitude,
        @xml.value('(/GeocodeResponse/result/geometry/location/lng)[1]', 'varchar(200)') AS Longitude
                
END

GO

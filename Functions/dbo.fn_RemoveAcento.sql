SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create Function [dbo].[fn_RemoveAcento] 
(
 @palavra varchar(50)

 )

Returns varchar(50)

As 
Begin


Set @palavra = replace(@palavra,'À','A')
Set @palavra = replace(@palavra,'à','a')
Set @palavra = replace(@palavra,'Â','A')
Set @palavra = replace(@palavra,'â','a')
Set @palavra = replace(@palavra,'Ê','E')
Set @palavra = replace(@palavra,'ê','e')
Set @palavra = replace(@palavra,'Ô','O')
Set @palavra = replace(@palavra,'ô','o')
Set @palavra = replace(@palavra,'Î','I')
Set @palavra = replace(@palavra,'î','i')
Set @palavra = replace(@palavra,'Û','U')
Set @palavra = replace(@palavra,'û','u')
Set @palavra = replace(@palavra,'Ã','a')
Set @palavra = replace(@palavra,'ã','a')
Set @palavra = replace(@palavra,'Õ','o')
Set @palavra = replace(@palavra,'õ','o')
Set @palavra = replace(@palavra,'Á','a')
Set @palavra = replace(@palavra,'á','a')
Set @palavra = replace(@palavra,'É','E')
Set @palavra = replace(@palavra,'é','e')
Set @palavra = replace(@palavra,'Í','I')
Set @palavra = replace(@palavra,'í','i')
Set @palavra = replace(@palavra,'Ó','o')
Set @palavra = replace(@palavra,'ó','o')
Set @palavra = replace(@palavra,'Ú','U')
Set @palavra = replace(@palavra,'ú','u')
Set @palavra = replace(@palavra,'Ç','C')
Set @palavra = replace(@palavra,'ç','c')
Set @palavra = replace(@palavra,'Ü','U')
Set @palavra = replace(@palavra,'ü','u')
Return (@palavra)

end
GO

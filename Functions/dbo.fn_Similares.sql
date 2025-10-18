SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  Function [dbo].[fn_Similares] 
(
  @Codigo int

 )
 
 Returns Varchar(8000)

As 
Begin

DECLARE
  @SQLStr VARCHAR(5000)=''  

--SELECT 
--  @SQLStr=@SQLStr+[a].[Similar]+', ' 
--FROM (SELECT 
--        CONVERT(VARCHAR(20),COM_ITE_CAD.Digito) Similar
--      FROM COM_ITE_Similar 
--       Inner Join COM_ITE_CAD
--         On COM_ITE_CAD.ItemID= COM_ITE_Similar.Similar
--      Where COM_ITE_Similar.ItemID=CONVERT(VARCHAR(100),@Codigo)) As a 

--SET @SQLStr=LEFT(@SQLStr,ABS(len(@SQLStr)-1))

Return (isnull(@SQLStr,''))  

end

GO

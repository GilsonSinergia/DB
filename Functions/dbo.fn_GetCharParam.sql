SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create   Function [dbo].[fn_GetCharParam] (@Parametro VarChar(50), @UnidadeID Int = Null)
	RETURNS   VarChar(50)
	AS
	BEGIN  
	  RETURN(Select top 1 Caracter
	  from SysPara0
	  Where Parametro = @Parametro
	    AND (@UnidadeID Is Null or UnidadeID = @UnidadeID))
	end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   Function [dbo].[ValorNotaAnexo]
(
  @UnidadeID Int,
  @TipoID    Int,
  @Nota       Int
)
RETURNS Decimal(18,2)               
AS
BEGIN
  RETURN(Select IsNull(Sum(VL_Total),0)
         From MovNota0
         JOIN dbo.VWS_Movimento_Totais T ON T.Chave = MovNota0.Chave
         Where MovNota0.UnidadeID    = @UnidadeID
           AND ParentTipoID = @TipoID
           AND ParentNota   = @Nota)
end


GO

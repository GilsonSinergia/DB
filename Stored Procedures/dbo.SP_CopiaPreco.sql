SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                   Procedure [dbo].[SP_CopiaPreco]
  @UnidadeID        Int,
  @PrecoID          Int,
  @OrigemUnidadeID  Int,
  @OrigemPrecoID    Int
as
   
--Select Proprec0.*, Origem.Valor
Update COM_ITE_PRC Set Valor = Origem.Valor
from COM_ITE_PRC
  INNER JOIN COM_ITE_PRC Origem
     ON Origem.ItemID = COM_ITE_PRC.ItemID
Where COM_ITE_PRC.PrecoID > 2
  AND COM_ITE_PRC.UnidadeID = @UnidadeID
  AND COM_ITE_PRC.PrecoID   = @PrecoID
  AND Origem.Valor       > 0 
  AND Origem.UnidadeID   = @OrigemunidadeID
  AND Origem.PrecoID     = @OrigemPrecoID
GO

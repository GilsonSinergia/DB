SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_R_Contagem]
  @Data Date,  
  @UnidadeID int,
  @LinhaID   Int = Null,
  @GrupoID   int = Null,
  @ExibirQuantidade bit = 1,
  @Ordem     int = 0
As

Select 
  COM_ITE_CAD.ItemID,
  COM_ITE_CAD.Item,
  COM_ITE_CAD.NCM,
  COM_ITE_CAD.Referencia,
  COM_ITE_CAD.Localizacao,
  COM_ITE_CAD.Contabil * @ExibirQuantidade  Quantidade
from dbo.VWS_Itens COM_ITE_CAD
  --JOIN CadPess0 ON COM_ITE_CAD.PessoaID=CadPess0.PessoaID
Where COM_ITE_CAD.UnidadeID = @UnidadeID    
  --AND (@PessoaID is Null OR CadPess0.PessoaID = @PessoaID)
  AND (@GrupoID is Null OR COM_ITE_CAD.GrupoID = @GrupoID)
  AND (@LinhaID is Null OR COM_ITE_CAD.LinhaID = @LinhaID)
Order by 
  Case @Ordem
    when 0 then COM_ITE_CAD.Item
    when 1 then COM_ITE_CAD.Item
    when 2 then COM_ITE_CAD.Localizacao
    else COM_ITE_CAD.Item
  end
GO

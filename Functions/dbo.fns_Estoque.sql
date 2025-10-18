SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   Function [dbo].[fns_Estoque]
(@Data DateTime = NULL, @Chave CHAR(14)=Null)

RETURNS Table AS RETURN
(

Select 
  COM_ITE_MOV.UnidadeID,
  COM_ITE_MOV.ItemID,
  Convert(Decimal(18, 3), SUM(COM_ITE_MOV.Quantidade 
								* COM_ITE_MOV.Fator 
								* COM_ITE_MOV.Estoque 
								* LkpNota0.Estoque  
								* LkpNota1.Ativo), 0) Contabil
from COM_ITE_UND
  JOIN COM_ITE_CAD on COM_ITE_CAD.ItemID=COM_ITE_UND.ItemID
  JOIN COM_ITE_MOV ON COM_ITE_UND.UnidadeID=COM_ITE_MOV.UnidadeID AND COM_ITE_UND.ItemID=COM_ITE_MOV.ItemID 
  JOIN MovNota0    on MovNota0.Chave=COM_ITE_MOV.Chave
  JOIN LkpNota0    on LkpNota0.TipoID=COM_ITE_MOV.TipoID
  JOIN LkpNota1    on LkpNota1.StatusID=MovNota0.StatusID
where MovNota0.StatusID=2   
  AND (@Data IS NULL AND @Chave IS NULL OR MovNota0.DtMovimento <= @Data)
  AND (@Chave IS NULL OR COM_ITE_MOV.Chave=@Chave)
Group BY COM_ITE_MOV.UnidadeID,	COM_ITE_MOV.ItemID  
Having Convert(Decimal(18, 3), SUM(COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator * COM_ITE_MOV.Estoque * LkpNota0.Estoque  * LkpNota1.Ativo), 0) <> 0
)
GO

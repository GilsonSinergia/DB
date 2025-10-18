SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       Procedure [dbo].[SP_R_CurvaABC]

@UnidadeID  Int          = Null,
@DtIni      Datetime     = Null,
@DtFim      Datetime     = Null,
@Tipo int =0
As

Select 
IDENTITY(Int,1,1)Indece,
COM_ITE_CAD.ItemID,
COM_ITE_CAD.Item,
SUM(Case @tipo
  when 0 then COM_ITE_MOV.Quantidade 
  when 1 then COM_ITE_MOV.VL_Liquido 
  when 2 then COM_ITE_MOV.Quantidade * (COM_ITE_MOV.VL_Unitario  - COM_ITE_MOV.VL_CustoBruto) 
end * LkpNota0.Financeiro)  Montante   
Into #Vendas 
from COM_ITE_CAD
  Join COM_ITE_PRD on COM_ITE_PRD.ItemID =COM_ITE_CAD.ItemID
 Join COM_ITE_MOV on COM_ITE_MOV.ItemID =COM_ITE_CAD.ItemID
 Join MovNota0
   on MovNota0.UnidadeID=COM_ITE_MOV.UnidadeID
  AND MovNota0.TipoID=COM_ITE_MOV.TipoID
  AND MovNota0.Nota=COM_ITE_MOV.Nota
Inner Join LkpNota0
  On LkpNota0.TipoID = MovNota0.TipoID
Where (@DtIni     Is Null OR MovNota0.DtMovimento  >= @DtIni)
  And (@DtFim     Is Null OR MovNota0.DtMovimento  <= @DtFim)
  And  (COM_ITE_MOV.UnidadeID  = @UnidadeID )
  And MovNota0.TipoID in(7,8,9,10,13) 
  AND MovNota0.StatusID=2   
Group by 
COM_ITE_CAD.ItemID,
COM_ITE_CAD.Item,
LkpNota0.Financeiro
order by Montante desc


;WITH Res (Posicao, Codigo, Produto, PorItem, Total) As (
SELECT
   Indece, ItemID, Item, Montante,
   SUM(Montante) OVER (PARTITION BY 1) As TotalVendido
FROM #Vendas),

QPerc (Posicao, Codigo, Produto, PorItem, Total, Perc) As (

SELECT
   Posicao, Codigo, Produto, PorItem, Total,
   PorItem / CAST(Total As Decimal(12,2)) As Perc 
FROM Res)

SELECT
   Case 
      when Posicao = 1 OR (ROUND((SELECT SUM(TInt.Perc) FROM QPerc As TInt WHERE TInt.Posicao <= TOut.Posicao),4) *100)<=65 then 'A'
      when Posicao = 2 OR (ROUND((SELECT SUM(TInt.Perc) FROM QPerc As TInt WHERE TInt.Posicao <= TOut.Posicao),4) *100)<=90 then 'B'
      else  'C'
   end Classe,       
   Posicao, 
   Codigo, Produto, PorItem, Total, (Perc * 100) Perc,
   ROUND((SELECT SUM(TInt.Perc) FROM QPerc As TInt WHERE TInt.Posicao <= TOut.Posicao),4) *100 As PercAcum        
FROM QPerc As TOut

drop table #vendas
GO

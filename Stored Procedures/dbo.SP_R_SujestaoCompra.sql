SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SP_R_SujestaoCompra]
  @UnidadeID  int,
  @PeriodoMovimentoMedio Int,
  @PessoaID   int  = 7270,
  @LinhaID    int  = Null,
  @GrupoID    int  = Null,
  @HomitirComEstoque Bit = 0
as

Declare @Data Date = GetDate()


;with CTE_Compra(ItemID, UtCompra, UtEntrega, PrazoEntraga)
as
( 
Select 
  COM_ITE_CAD.ItemID, 
  Max(MovFisc0.DtEmissao)UtCompra,
  Max(MovNota0.DtMovimento)UtEntrega,
  DATEDIFF(day,Max(MovFisc0.DtEmissao),Max(MovNota0.DtMovimento))PrazoEntraga   
from COM_ITE_CAD
  Join COM_ITE_MOV
    on COM_ITE_MOV.ItemID=COM_ITE_CAD.ItemID
  Join MovNota0
    on COM_ITE_MOV.UnidadeID=MovNota0.UnidadeID
   AND COM_ITE_MOV.TipoID=MovNota0.TipoID
   AND COM_ITE_MOV.Nota=MovNota0.Nota
  Join MovFisc0
    on MovFisc0.UnidadeID=MovNota0.UnidadeID
   AND MovFisc0.TipoID=MovNota0.TipoID
   AND MovFisc0.Nota=MovNota0.Nota 
Where MovNota0.UnidadeID=@UnidadeID 
  AND MovNota0.TipoID=1
  AND MovNota0.StatusID=2
Group by COM_ITE_CAD.ItemID

)


Select 
  dbo.COM_ITE_LIN.Linha+'=>'+dbo.COM_ITE_GRP.Grupo LinhaGrupo,
  dbo.COM_ITE_LIN.Linha,
  dbo.COM_ITE_GRP.Grupo,
  COM_ITE_CAD.ItemID, 
  COM_ITE_CAD.Item, 
  CTE_Compra.UtCompra,
  CTE_Compra.UtEntrega,
  CTE_Compra.PrazoEntraga,  
  CONVERT(Decimal(18,4), Estoque.Contabil) Saldo,
  CONVERT(Decimal(18,4), AVG(COM_ITE_MOV.Quantidade))VendaMedia,
  DATEADD(Day, (CONVERT(int, Estoque.Contabil /  AVG(COM_ITE_MOV.Quantidade)) - CTE_Compra.PrazoEntraga), GETDATE())  DiasEstoque,
  COM_ITE_PRC.Valor PrecoCompra
from COM_ITE_CAD
  JOIN COM_ITE_PRD on COM_ITE_CAD.ItemID=COM_ITE_PRD.ItemID
  JOIN dbo.COM_ITE_LIN on COM_ITE_PRD.LinhaID=dbo.COM_ITE_LIN.LinhaID      
  JOIN dbo.COM_ITE_GRP on dbo.COM_ITE_GRP.GrupoID=COM_ITE_PRD.GrupoID  
  JOIN dbo.VWS_Estoque Estoque on Estoque.ItemID=COM_ITE_CAD.ItemID
  JOIN COM_ITE_PRC
    on COM_ITE_PRC.UnidadeID=Estoque.UnidadeID
   AND COM_ITE_PRC.ItemID=Estoque.ItemID      
  LEFT JOIN dbo.COM_ITE_Fornecedor F ON F.ItemID = COM_ITE_CAD.ItemID
  LEFT Join COM_ITE_MOV
    on COM_ITE_MOV.UnidadeID=Estoque.UnidadeID
   AND COM_ITE_MOV.ItemID=Estoque.ItemID
	 AND Quantidade > 0
  LEFT Join MovNota0
    on COM_ITE_MOV.UnidadeID=MovNota0.UnidadeID
   AND COM_ITE_MOV.TipoID=MovNota0.TipoID
   AND COM_ITE_MOV.Nota=MovNota0.Nota 
   AND MovNota0.DtMovimento >= GETDATE()-@PeriodoMovimentoMedio
   AND MovNota0.TipoID in(7,8,9,10)  
   AND MovNota0.UnidadeID = @UnidadeID 
  LEFT JOIN CTE_Compra
    on CTE_Compra.ItemID=COM_ITE_CAD.ItemID
  JOIN com_ite_und
    on com_ite_und.unidadeId = COM_ITE_PRC.unidadeId
   And com_ite_und.itemID = COM_ITE_PRC.itemID
Where COM_ITE_PRC.PrecoID=0
  AND Com_ite_und.ativo = 1
  AND Estoque.UnidadeID=@UnidadeID
  AND (@PessoaID is Null OR F.PessoaID = @PessoaID)
  AND (@LinhaID is Null OR COM_ITE_PRD.LinhaID = @LinhaID)
  AND (@GrupoID is Null OR COM_ITE_PRD.GrupoID = @GrupoID) 
  AND (@HomitirComEstoque = 0 OR  Estoque.Contabil = 0)
Group BY 
  dbo.COM_ITE_LIN.Linha,
  dbo.COM_ITE_GRP.Grupo,
  COM_ITE_CAD.ItemID, 
  COM_ITE_CAD.Item,
  Estoque.Contabil,   
  CTE_Compra.PrazoEntraga,
  CTE_Compra.UtCompra,
  CTE_Compra.UtEntrega,
  COM_ITE_PRC.Valor
Order by dbo.COM_ITE_LIN.Linha, dbo.COM_ITE_GRP.Grupo, COM_ITE_CAD.Item
GO

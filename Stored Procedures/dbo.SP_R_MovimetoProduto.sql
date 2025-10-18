SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SP_R_MovimetoProduto]
  @UnidadeID Int = Null,
  @PessoaID  Int = Null,
  @GrupoID   int = Null,
  @LinhaID   int = Null,
  @ItemID    Int = Null,
  @TipoID    Int = Null,
  @ModeloID  Int = Null,
  @StatusID  Int = Null,
  @DtInicio  DateTime,
  @DtFinal   DateTime
AS

Select *
Into #LkpNota0
from LkpNota0
where ( @TipoID  IS Null OR @TipoID  & Power( 2, LkpNota0.TipoID ) > 0 )

Select * 
Into #LkpNota1
from LkpNota1
Where ( @StatusID  IS Null OR @StatusID  & Power( 2, LkpNota1.StatusID ) > 0 )

Select * 
Into #LkpFisc0
from LkpFisc0
Where ( @ModeloID  IS Null OR @ModeloID  & Power( 2, LkpFisc0.ModeloID ) > 0 )

Select 
  MovNota0.Chave, 
  MovFisc0.Serie,
  MovFisc0.NF,
  VWS_Pessoas.Nome Cliente,
  Vendedor.Nome Vendedor,
  VWS_Itens.ItemID, 
  VWS_Itens.Item, 
  VWS_Itens.Referencia,
  VWS_Itens.Grupo,
  lkpNota0.OP Operacao,  
  LkpNota0.Tipo Tipo, 
  MovNota0.DtMovimento,     
  COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator * lkpNota0.Estoque Quantidade,
  Case lkpNota0.Estoque  when  1 then COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator else 0 end Entradas,
  Case lkpNota0.Estoque  when -1 then COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator else 0 end Saidas,
  COM_ITE_MOV.VL_Item / COM_ITE_MOV.Quantidade * lkpNota0.Estoque * -1 Valor,
  COM_ITE_MOV.VL_Liquido  Total
From MovNota0
  JOIN VWS_Pessoas on VWS_Pessoas.PessoaID=Movnota0.PessoaID
  JOIN COM_ITE_MOV ON COM_ITE_MOV.Chave = MovNota0.Chave
  JOIN #LkpNota0 LkpNota0
   ON MovNota0.TipoID    = LkpNota0.TipoID
  JOIN #LkpNota1 LkpNota1
   ON MovNota0.StatusID    = LkpNota1.StatusID  
 JOIN VWS_Itens
   ON VWS_Itens.UnidadeID = COM_ITE_MOV.UnidadeID
  AND VWS_Itens.ItemID = COM_ITE_MOV.ItemID
  LEFT JOIN MovVend0 ON MovVend0.Chave = MovNota0.Chave
  LEFT JOIN CadPess0 Vendedor on Vendedor.PessoaID=MovVend0.PessoaID
  LEFT JOIN MovFisc0
	On MovNota0.Chave  = MovFisc0.Chave
 LEFT JOIN #LkpFisc0 LkpFisc0
   ON MovFisc0.ModeloID    = LkpFisc0.ModeloID    
Where MovNota0.StatusID = 2
  AND LkpNota0.Estoque <> 0
  AND COM_ITE_MOV.Quantidade <> 0
  AND ( @UnidadeID IS NULL OR MovNota0.UnidadeID = @UnidadeID)
  AND ( @PessoaID  IS Null OR MovNota0.PessoaID  = @PessoaID )
  AND ( @GrupoID   IS Null OR VWS_Itens.GrupoID  = @GrupoID)
  AND ( @LinhaID   IS NULL OR VWS_Itens.LinhaID = @LinhaID )
  AND MovNota0.DtMovimento >= @DtInicio
  AND MovNota0.DtMovimento <= @DtFinal
  AND ( @ItemID Is Null Or VWS_Itens.ItemID = @ItemID)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SP_R_Movimentos]
  @UnidadeID Int =2,
  @TipoID Int = Null,
  @PessoaID Int = Null,
  @StatusID Int = Null,
  @DtIni Date = '20160401',
  @DtFin Date = '20160430'
AS

Select UnidadeID,Unidade
Into #Unidade
From CadUnid0
Where @UnidadeID is Null OR POWER(2,UnidadeID) & @UnidadeID <>0

Select 
  TipoID,
  Tipo,
  Case 
    when LkpNota0.Financeiro = -1 then '01-Entrada'
    when LkpNota0.Financeiro =  1 then '02-Saida'
    Else '03-Outras'
  End Operacao  
Into #Tipos
From LkpNota0
Where @TipoID is Null OR POWER(2,TipoID) & @TipoID <>0



Select StatusID,Status
Into #LkpNota1
From LkpNota1
Where @StatusID is Null OR POWER(2,StatusID) & @StatusID <>0

Select 
  LkpNota0.Operacao,
  LkpNota0.Tipo,
  MovNota0.Chave,
  MovNota0.DtMovimento,
  MovFisc0.DtEmissao,
  ISNULL(CTE_Conhecimento.NUM_DOC, MovFisc0.NF) NF,
  MovFisc0.Serie,
  CadPess0.Nome Participante,
  Financeiro.Pagamento,
  Financeiro.Total,
  LkpNota1.Status
from MovNota0
  JOIN #Unidade on #Unidade.UnidadeID=MovNota0.UnidadeID
  JOIN #Tipos LkpNota0  on LkpNota0.TipoID=Movnota0.TipoID
  JOIn CadPess0 on CadPess0.PessoaID=Movnota0.PessoaID
  JOIN #LkpNota1 LkpNota1 on LkpNota1.StatusID=Movnota0.StatusID
  LEFT JOIN Financeiro
     on Financeiro.UnidadeID=Movnota0.UnidadeID
    AND Financeiro.TipoID=Movnota0.TipoID
    AND Financeiro.Nota=Movnota0.Nota 
   LEFT JOIN MovFisc0
     on MovFisc0.UnidadeID=Movnota0.UnidadeID
    AND MovFisc0.TipoID=Movnota0.TipoID
    AND MovFisc0.Nota=Movnota0.Nota   
   LEFT JOIN CTE_Conhecimento 
     on CTE_Conhecimento.UnidadeID=MovNota0.UnidadeID
	and CTE_Conhecimento.TipoID=MovNota0.TipoID
	and CTE_Conhecimento.Nota=MovNota0.Nota
Where MovNota0.DtMovimento >= @DtIni
  AND MovNota0.DtMovimento <= @DtFin
  AND (@PessoaID IS NULL OR MovNota0.PessoaID = @PessoaID)
  
Order by LkpNota0.Operacao,MovNota0.TipoID, MovNota0.Chave


GO

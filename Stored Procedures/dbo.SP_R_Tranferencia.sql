SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE      Procedure [dbo].[SP_R_Tranferencia]
  @UnidadeID Int,
  @ContaID   int = Null,
  @DtInicio  Datetime = Null,
  @DtFinal   Datetime = Null
AS
Select MovFina2.DtPagamento Data, MovFina2.Valor, 
 LkpBaix1.Operacao OPOrigem, CadCont0.Conta +' - '+ CadPort0.Portador Origem, 
 LkpBaix1A.Operacao OPDestino, CadCont0A.Conta +' - '+ CadPort0A.Portador Destino
From MovFina2
  INNER JOIN LkpBaix1
     ON LkpBaix1.OperacaoID = MovFina2.OperacaoID
  Inner Join CadCont0
     ON CadCont0.ContaID   = MovFina2.ContaID
  Inner Join CadPort0
    On CadPort0.PortadorID = CadCont0.PortadorID
  Inner Join MovFina2 MovFina2A
    ON MovFina2A.ParentOperacaoID  = MovFina2.OperacaoID
   AND MovFina2A.ParentMovimentoID = MovFina2.MovimentoID
  INNER JOIN LkpBaix1 LkpBaix1A
     ON LkpBaix1A.OperacaoID = MovFina2A.OperacaoID
  Inner Join CadCont0 CadCont0A
     ON CadCont0A.ContaID   = MovFina2A.ContaID
  Inner Join CadPort0 CadPort0A
    On CadPort0A.PortadorID = CadCont0A.PortadorID
Where MovFina2.OperacaoID   > 1
  AND MovFina2.ParentMovimentoID Is Null
  And (@ContaID IS Null 
       OR MovFina2.ContaID  = @ContaID 
       OR MovFina2A.ContaID = @ContaID)
  And (@DtInicio Is Null OR MovFina2.DtPagamento >= @DtInicio)
  And (@DtFinal  Is Null OR MovFina2.DtPagamento <= @DtFinal)



GO

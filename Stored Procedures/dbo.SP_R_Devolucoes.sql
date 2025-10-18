SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE     Procedure [dbo].[SP_R_Devolucoes]
  @unidadeID int  = Null,
  @ContaID   int,
  @DtInicio  Datetime = Null,
  @DtFinal   Datetime = Null
AS
SELECT MovFina2.Titulo, MovFina2.DtProjecao, MovFina2.Valor, MovFina2.Conta, MovFina2.BancoID, MovFina2.Agencia, 
  CadPess0.Documento + ' - ' + CadPess0.Nome AS Emitente, LkpBaix0.Status, FinDeve0.Incidencia, FinDeve0.DtDevolucao, 
   FinDeve0.DtReapresentacao, FinDeve0.Motivo, FinDeve0.Alinea
FROM  FinDeve0 
  INNER JOIN MovFina2 
    On  FinDeve0.OperacaoID  = MovFina2.OperacaoID 
   AND FinDeve0.MovimentoID = MovFina2.MovimentoID 
  INNER JOIN MovFina1
     On MovFina1.OperacaoID  = MovFina2.OperacaoID 
    And MovFina1.MovimentoID = MovFina2.MovimentoID
  INNER JOIN CadPess0 
    ON MovFina2.PessoaID = CadPess0.PessoaID 
  INNER JOIN LkpBaix0 
    ON MovFina2.StatusID = LkpBaix0.StatusID


Where MovFina2.OperacaoID   = 1
  And MovFina2.ContaID      = @ContaID 
  And (@DtInicio Is Null OR FinDeve0.DtDevolucao >= @DtInicio)
  And (@DtFinal  Is Null OR FinDeve0.DtDevolucao <= @DtFinal)
Order by Movfina2.Titulo, FinDeve0.DtDevolucao







GO

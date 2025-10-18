SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE   Procedure [dbo].[SP_GetPesCredito]
  @UnidadeID int,
  @PessoaID  Int
AS
  Create Table #Credito
    (
     PessoaID        Int Not Null Primary Key,
     Nome            VarChar(50) Not Null,
     Reduzido        VarChar(30) Not Null,

     --Limite de Credito
     LimiteCredito   Money Not Null Default 0,
     Adiantamento    Money Not Null Default 0,
     Emprestimo      Money Not Null Default 0,
     Debito          Money Not Null Default 0,
     Saldo           As LimiteCredito + Adiantamento - Emprestimo - Debito,

     --Movimentação
     QtdCompras       int  Not Null Default 0,
     ValMedioCompra   Money Not Null Default 0,
     ValMaiorCompra   Money Not Null Default 0,
     DtMaiorCompra    Datetime Null,
     ValUltimaCompra  Money Not Null Default 0,
     ValUltimaCompra  Datetime Null,
     
     --Faturas
     QtdFaturasQuitadas int  Not Null Default 0,
     ValFaturasQuitadas  Money Not Null Default 0,
     QtdFaturasVencidas int  Not Null Default 0,
     ValFaturasVencidas  Money Not Null Default 0,
     QtdFaturasAbertas  int  Not Null Default 0,
     ValFaturasAbertas   Money Not Null Default 0,
     QtdChequeDevolvido int  Not Null Default 0,
     ValChequeDevolvido  Money Not Null Default 0,

     --Média de Atraso
     MaiorAtraso     int  Not Null Default 0,
     DtMaiorAtraso   Datetime Null,
     Atrasomedio     int  Not Null Default 0,
     )

If exists (Select PessoaID From CadPess0 Where PessoaID = @PessoaID) begin
  Select 1
end








GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE           Procedure  [dbo].[SP_R_Baixa]
  @Financeiro int,    
  @PessoaID  Int = Null,
  @ContaID Int = Null,
  @Moedas Int = Null,
  @Status Int = Null,

  @IniPag DateTime = Null,
  @FinPag DateTime = Null,
  @IniPro DateTime = Null,
  @FinPro DateTime = Null,
  @IniCon DateTime = Null,
  @FinCon DateTime = Null 
AS


SELECT 
  MovFina2.MovimentoID,
  ISNULL(MovFina2.DtConciliacao, MovFina2.DtProjecao)DtOperacao, 
  MovFina2.DtPagamento,
  MovFina2.DtProjecao,
  MovFina2.DtConciliacao,
  CadMoed0.Moeda,
  CadPort0.Portador + ' / ' + CadCont0.Agencia +' / '+ CadCont0.Conta Conta,
  CadPess0.Reduzido Participante,
  Financeiro.Historico,
  Movnota0.Chave,
  MovFina0.ChaveTitulo,
  MovFina0.Parcela,
  MovFina0.DtVencimento,
  MovFina0.Valor,
  MovFina1.ValorLiquido,
  MovFina1.ValorEncargos,
  MovFina1.ValorDesconto,
  MovFina1.ValorPago,
  LkpBaix0.StatusID,
  LkpBaix0.Status
FROM MovNota0
  JOIN Financeiro ON MovNota0.Chave = Financeiro.Chave
  JOIN LkpNota0 ON MovNota0.TipoID = LkpNota0.TipoID
  JOIN LkpNota1 On MovNota0.StatusID = LkpNota1.StatusID
  JOIN MovFina0 ON MovNota0.Chave = MovFina0.Chave
  JOIN LkpFina0 On MovFina0.StatusID = LkpFina0.StatusID
  JOIN MovFina1 ON MovFina0.ChaveTitulo = MovFina1.ChaveTitulo
  JOIN MovFina2
    on MovFina1.MovimentoID = MovFina2.MovimentoID
   AND MovFina1.OperacaoID = MovFina2.OperacaoID
  JOIN CadPess0 ON MovNota0.PessoaID = CadPess0.PessoaID
  JOIN CadPort0 ON MovFina0.PortadorID = CadPort0.PortadorID
  JOIN CadMoed0 ON MovFina2.MoedaID = CadMoed0.MoedaID
  JOIN CadDocu0 ON MovFina0.DocumentoID = CadDocu0.DocumentoID
  JOIN LkpBaix1 ON MovFina2.OperacaoID = LkpBaix1.OperacaoID
  JOIN LkpBaix0 ON MovFina2.StatusID = LkpBaix0.StatusID
  JOIN CadCont0 on CadCont0.ContaID   = MovFina2.ContaID
  JOIN CadPort0 Bancos ON Bancos.PortadorID = CadCont0.PortadorID
Where (LkpNota1.Ativo = 1)
  AND (LkpFina0.Ativo = 1)
  AND (LkpBaix0.Ativo = 1)
  AND (LkpNota0.Financeiro = @Financeiro)
  AND (@Moedas IS Null OR  Power (2,MovFina2.MoedaID) & @Moedas > 0)
  AND (@Status IS Null OR  Power (2,MovFina2.StatusID) & @Status > 0)
  AND (@PessoaID      Is Null Or MovNota0.PessoaID   = @PessoaID)
  AND (@ContaID       Is Null Or MovFina2.ContaID    = @ContaID)
  AND (@IniPag        Is Null or MovFina2.DtPagamento  >= @IniPag)
  AND (@FinPag        Is Null or MovFina2.DtPagamento  <= @FinPag)
  AND (@IniPro        Is Null or MovFina2.DtProjecao   >= @IniPro)
  AND (@FinPro        Is Null or MovFina2.DtProjecao   <= @FinPro)  
  AND (@FinCon        Is Null or MovFina2.DtConciliacao>= @IniCon)
  AND (@FinCon        Is Null or MovFina2.DtConciliacao<= @FinCon)
order by 
  LkpBaix0.StatusID desc, 
  ISNULL(MovFina2.DtConciliacao, MovFina2.DtProjecao), 
  MovFina2.MovimentoID, 
  MovFina0.DtVencimento


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      Function [dbo].[FN_Staus_Parcela]
(@Financeiro int, 
 @PessoaID Int, 
 @Conciliado bit, 
 @date DateTime)
Returns Table
AS
Return
  (
SELECT 
  dbo.MovNota0.Chave,
  MovFina0.UnidadeID, 
  MovNota0.TipoID, 
  MovNota0.Nota,
  MovFina0.Reneg, 
  MovFina0.Parcela,
  MovFina0.ChaveTitulo,
  --Quitado
  Convert(Decimal(18,2),IsNull(MovFina1.ValorLiquido,0)) Quitado,
  --Aberto
  Convert(Decimal(18,2),MovFina0.Valor - IsNull(MovFina1.ValorLiquido,0)) Aberto,
  --Dias de Atraso  
  DateDiff(Day, MovFina0.DtVencimento, IsNull( MovFina1.DtPagamento, @date)) - IsNull(PesClie0.Carencia, 0) Dias,
  --Juros  
   Convert(Decimal(18,2),Case 
                          when DateDiff(Day, MovFina0.DtVencimento, IsNull( MovFina1.DtPagamento, @date))- IsNull(PesClie0.Carencia, 0) > 0 then 
                           ((MovFina0.Valor - IsNull(MovFina1.ValorLiquido,0)) 
						   * CadUnid0.juros
						   / 100 * (DateDiff(Day, MovFina0.DtVencimento, @date) - IsNull(PesClie0.Carencia, 0) ) )
                          else 0
                        end 
                        ) Juros, 

  --Valor Corrigido  
    Convert(Decimal(18,2), (MovFina0.Valor - IsNull(MovFina1.ValorLiquido,0)) 
                           +Case 
                          when DateDiff(Day, MovFina0.DtVencimento, IsNull( MovFina1.DtPagamento, @date))- IsNull(PesClie0.Carencia, 0) > 0 then 
                           ((MovFina0.Valor - IsNull(MovFina1.ValorLiquido,0)) 
						   * CadUnid0.juros
						   / 100 * (DateDiff(Day, MovFina0.DtVencimento, @date) - IsNull(PesClie0.Carencia, 0) ) )
                          else 0
                        end ) Corrigido,
  DATEDIFF(DAY, DtMovimento,DtVencimento)Intervalo,
   
  Case   
     When MovFina0.Valor > IsNull(MovFina1.ValorLiquido,0) AND MovFina0.DtVencimento <  @date Then 0
     When MovFina0.Valor > IsNull(MovFina1.ValorLiquido,0) AND MovFina0.DtVencimento >= @date Then 1
     When MovFina0.Valor = IsNull(MovFina1.ValorLiquido,0)                                    Then 2
     ELse                                                                                          3
  End PagamentoID,
  Case   
     When MovFina0.Valor > IsNull(MovFina1.ValorLiquido,0) AND MovFina0.DtVencimento <  @date Then 'Vencido'
     When MovFina0.Valor > IsNull(MovFina1.ValorLiquido,0) AND MovFina0.DtVencimento >= @date Then 'A Vencer'
     When MovFina0.Valor = IsNull(MovFina1.ValorLiquido,0)                                    Then 'Liquidado'
     ELse                                                                                          'Indefinido'
  End Pagamento,
  Case   
     When IsNull(MovFina1.ValorLiquido,0) = 0              Then 0
     When MovFina0.Valor > IsNull(MovFina1.ValorLiquido,0) Then 1
     When MovFina0.Valor = IsNull(MovFina1.ValorLiquido,0) Then 2
  End As StatusID,
  Case   
     When IsNull(MovFina1.ValorLiquido,0) = 0              Then 'Aberto'
     When MovFina0.Valor > IsNull(MovFina1.ValorLiquido,0) Then 'Parcial'
     When MovFina0.Valor = IsNull(MovFina1.ValorLiquido,0) Then 'Quitado'
  End As Status,
  LkpNota0.Financeiro
FROM MovFina0
  JOIN LkpNota0
    ON LkpNota0.TipoID = MovFina0.TipoID
  JOIN MovNota0
     ON MovFina0.UnidadeID = MovNota0.UnidadeID
    AND MovFina0.TipoID    = MovNota0.TipoID
    AND MovFina0.Nota      = MovNota0.Nota
  JOIN CadUnid0
     ON CadUnid0.UnidadeID = MovNota0.UnidadeID 
  LEFT JOIN (Select 
               MovFina1.UnidadeID, 
               MovFina1.TipoID, 
               MovFina1.Nota, 
               MovFina1.Reneg, 
               MovFina1.Parcela, 
               Sum(MovFina1.ValorLiquido) ValorLiquido, 
 	 	       Max( MovFina2.DtPagamento ) DtPagamento
             From MovFina1
               JOIN MovFina2 
                 ON MovFina1.OperacaoID  = MovFina2.OperacaoID
                AND MovFina1.MovimentoID = MovFina2.MovimentoID
             Where MovFina2.StatusID In (0, 1, 2, 3)  
               AND (@Conciliado = 0 OR MovFina2.StatusID=3)
			   AND( MovFina2.DtConciliacao <= @date OR MovFina2.DtConciliacao is NULL)
             Group BY 
               MovFina1.UnidadeID,
               MovFina1.TipoID,
               MovFina1.Nota, 
               MovFina1.Reneg, 
               MovFina1.Parcela)AS MovFina1
    ON MovFina0.UnidadeID = MovFina1.UnidadeID
   AND MovFina0.TipoID  = MovFina1.TipoID
   AND MovFina0.Nota    = MovFina1.Nota
   AND MovFina0.Reneg   = MovFina1.Reneg
   AND MovFina0.Parcela = MovFina1.Parcela
 LEFT JOIN PesClie0
   ON PesClie0.PessoaID = MovNota0.PessoaID
Where (MovFina0.StatusID = 0)
  AND (@PessoaID  Is Null OR MovNota0.PessoaID= @PessoaID)
  AND (@Financeiro IS Null OR LkpNota0.Financeiro = @Financeiro)
  AND MovNota0.StatusID = 2
)
GO

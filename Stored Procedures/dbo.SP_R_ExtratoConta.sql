SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   Procedure [dbo].[SP_R_ExtratoConta]
  @IniEmissao DateTime,	
  @FinEmissao DateTime,
  @ContaID    Int,
  @Conciliado bit = 1

AS

Set NoCount ON

Update movfina2 Set StatusID  = 6  
from movfina2
     LEFT JOIN MovFina1
       ON MovFina1.OperacaoID  = MovFina2.OperacaoID
      AND MovFina1.MovimentoID = MovFina2.MovimentoID
where movfina2.OperacaoID <=1
  and StatusID <> 6
  and MovFina1.Reneg is null

    Update MovFina2 Set Valor = MovFina1.Valor
    From MovFina2
    LEFT JOIN( 
              Select OperacaoID, MovimentoID, Sum(ValorPago)Valor
              From MovFina1
              Group By OperacaoID, MovimentoID
              )MovFina1
       ON MovFina1.OperacaoID  = MovFina2.OperacaoID
      AND MovFina1.MovimentoID = MovFina2.MovimentoID
    Where MovFina2.Valor <> MovFina1.Valor
      and MovFina2.StatusID <> 6

Create Table #MovCaixa
  (
  UnidadeID    Int Null,
  OperacaoID   Int Not Null,
  MovimentoID  Int Not Null,
  DtMovimento  DateTime Not Null,
  Sinal        Int      Not Null,

  Descricao    VarChar(150) not Null,
  Fatura       VARCHAR(20) NULL,
  Mov          INT NULL,
  Debito       Decimal(18,2) Not Null,
  Credito      Decimal(18,2) Not Null,
  Saldo        Decimal(18,2) Null,
  StatusID     Bit Not Null ,
  Status       Varchar(20) Not Null,
  Moeda        VarChar(20)  Null
)


Declare 
  @Debito   Decimal(12,2),
  @Credito  Decimal(12,2),
  @SaldoAnt Decimal(12,2),
  @SaldoPos Decimal(12,2),
  @Data     DateTime

Select
    @SaldoAnt = 0, 
    @Debito   = 0, 
    @Credito  = 0




Set @Data = @IniEmissao-1
   
   Select @SaldoAnt = IsNull(Conciliado,0)
   from dbo.fn_SaldoContas( @Data)
   where ContaID = @ContaID
   
   Insert Into #MovCaixa (UnidadeID, OperacaoID, MovimentoID, Descricao, DtMovimento, Credito, Debito,  Saldo, StatusID, Status, Sinal)
   Values  (0, 0, 0, 'Saldo Anterior',
          @IniEmissao,          
          CaSE WHEN @SaldoAnt >= 0 THEN @SaldoAnt ELSE 0 END,
          CaSE WHEN @SaldoAnt <= 0 THEN @SaldoAnt ELSE 0 END,
	  @SaldoAnt, 1,
          'Realizados',
          0)


  --   Set @Data = Convert(DateTime,Floor(Convert(Float,GetDate())))


  -- Pagamentos/Recebimentos
  Insert Into #MovCaixa
  Select 
    MovFina1.UnidadeID, MovFina2.OperacaoID, MovFina2.MovimentoID,
    IsNull(MovFina2.DtConciliacao, MovFina2.DtProjecao) Data, 
    Case when LkpBaix1.Multiplicador = -1 then 1 else 0 end,
    Case
      When MovFina2.OperacaoID in(0,1) THEN 
        CadPess0.Reduzido+ '-'+Financeiro.Historico
      else LkpBaix1.Operacao+' - '+MovFina2.Titulo+' Ref '+MovFina2.Descricao
    End Descricao,  
    MovFina0.Fatura, MovNota0.Nota Mov,
    Case LkpBaix1.Multiplicador When -1 Then IsNull(MovFina1.ValorPago,MovFina2.Valor)  Else 0 End  As Debito,
    Case LkpBaix1.Multiplicador When  1 Then IsNull(MovFina1.ValorPago,MovFina2.Valor)  Else 0 End  As Credito,
    0 Saldo, 
    Case when MovFina2.StatusID = 3 then 1 else 0 end,
    Case when MovFina2.StatusID = 3 then 'Realizados' else 'Futuros' end,
    Moeda
  From MovFina2
     Inner Join LkpBaix0
        On MovFina2.StatusID = LkpBaix0.StatusID
     Inner Join LkpBaix1
        On LkpBaix1.OperacaoID = MovFina2.OperacaoID
     Inner Join CadMoed0
        On CadMoed0.MoedaID = MovFina2.MoedaID
    LEFT JOIN MovFina1
       ON MovFina1.OperacaoID  = MovFina2.OperacaoID
      AND MovFina1.MovimentoID = MovFina2.MovimentoID
    LEFT JOIN MovFina0
      ON MovFina1.UnidadeID   = MovFina0.UnidadeID
     AND MovFina1.TipoID      = MovFina0.TipoID
     AND MovFina1.Nota        = MovFina0.Nota  
     AND MovFina1.Reneg       = MovFina0.Reneg
     AND MovFina1.Parcela     = MovFina0.Parcela
    LEFT JOIN MovNota0
      ON MovNota0.UnidadeID   = MovFina0.UnidadeID
     AND MovNota0.TipoID      = MovFina0.TipoID
     AND MovNota0.Nota        = MovFina0.Nota  
    LEFT JOIN CadPess0
      ON MovNota0.PessoaID   = CadPess0.PessoaID
    LEFT JOIN Financeiro
      ON MovNota0.UnidadeID   = Financeiro.UnidadeID
     AND MovNota0.TipoID      = Financeiro.TipoID
     AND MovNota0.Nota        = Financeiro.Nota  
  Where ( MovFina2.ContaID    = @ContaID )
    And (MovFina2.DtConciliacao IS Null   OR (MovFina2.DtConciliacao >= @IniEmissao  And  MovFina2.DtConciliacao <= @FinEmissao) )
    And ( LkpBaix0.Ativo = 1 )
    AND ( MovFina2.StatusID <= 3)
    --AND MovFina2.MovimentoID=5627

Create Clustered Index Ind ON #MovCaixa (StatuSID Desc, DtMovimento, Sinal, MovimentoID, Mov)    

Declare C  Cursor Local for
Select Debito, Credito, DtMovimento 
from #MovCaixa
where MovimentoID <> 0
Open C

FETCH NEXT FROM C INTO @Debito, @Credito, @Data

WHILE @@FETCH_STATUS = 0
BEGIN
   UPDATE #MovCaixa 
     SET Saldo = @SaldoAnt + @Credito  - @Debito 
   FROM #MovCaixa
   WHERE CURRENT OF C
   set @SaldoAnt = @SaldoAnt  + @Credito - @Debito
   
   
   FETCH NEXT FROM C INTO @Debito, @Credito, @Data
End

DEALLOCATE C


Select * from #MovCaixa



Drop Table #MovCaixa
GO

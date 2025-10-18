SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE              Procedure [dbo].[SP_R_Extrato]
  @Financeiro  Int,
  @PessoaID    Int,
  @UnidadeID   Int = Null,
  @PortadorID  Int = Null,
  @DataIni     DateTime = Null,
  @DataFin     DateTime = Null,
  @UsuarioID   Int = Null
AS
Set NoCount ON
Create Table #Extrato
  (
   Chave     Int Not Null Identity( 1, 1 ),
   Data      DateTime Null,
   Origem    Int Null,
   UnidadeID Int Null,
   Tipo      Int Null,
   Codigo    Int Null,
   Operacao  VarChar(20) Null,
   Processo  VarChar(20) Null,
   Historico VarChar(255) Null,
   Encargos  Decimal(12,2) Not Null Default 0,
   Desconto  Decimal(12,2) Not Null Default 0,
   Debito    Decimal(12,2) Not Null Default 0,
   Credito   Decimal(12,2) Not Null Default 0,
   Saldo     Decimal(12,2) Not Null Default 0,
   TipoID    AS Case when Origem = 0 then Tipo else null end,
   Nota      AS Case when Origem = 0 then Codigo else null end,
   OperacaoID  AS Case when Origem = 1 then Tipo else null end,
   MovimentoID AS Case when Origem  = 1 then Codigo else null end
  )
  CREATE CLUSTERED INDEX Ind
   ON #Extrato (Data, Origem)


Declare 
  @Debito   Decimal(12,2),
  @Credito  Decimal(12,2),
  @SaldoAnt Decimal(12,2)

Select  @Debito = 0, @Credito = 0, @SaldoAnt = 0
--Saldo Anterior

if @DataIni is not Null begin
Select @SaldoAnt = IsNull( Sum( MovFina0.Valor ), 0 )
From MovFina0
  INNER Join UsrUnid0
     ON UsrUnid0.UnidadeID = MovFina0.UnidadeID
  INNER JOIN MovNota0
     ON MovFina0.UnidadeID = MovNota0.UnidadeID
    AND MovFina0.TipoID    = MovNota0.TipoID
    AND MovFina0.Nota      = MovNota0.Nota
  INNER Join LkpNota0
     ON MovFina0.TipoID      = LkpNota0.TipoID
Where LkpNota0.Financeiro = @Financeiro
  AND (MovFina0.StatusID=0)  
  AND (UsrUnid0.UsuarioID = IsNull(@UsuarioID,1))
  AND (MovFina0.DtEmissao < @DataIni)
  And (@UnidadeID  IS Null OR MovNota0.UnidadeID     = @UnidadeID)
  And (@PessoaID   IS Null OR MovNota0.PessoaID      = @PessoaID)
  And (@PortadorID IS Null OR MovFina0.PortadorID    = @PortadorID)



Select @SaldoAnt = IsNull( Sum( MovFina2.Valor ), 0 ) - @SaldoAnt 
From MovFina2
  INNER JOIN MovFina1
     ON MovFina2.OperacaoID   = MovFina1.OperacaoID
    AND MovFina2.MovimentoID  = MovFina1.MovimentoID
  INNER JOIN MovFina0
     ON MovFina1.UnidadeID = MovFina0.UnidadeID
    AND MovFina1.TipoID    = MovFina0.TipoID
    AND MovFina1.Nota      = MovFina0.Nota
    AND MovFina1.Reneg     = MovFina0.Reneg
    AND MovFina1.Parcela   = MovFina0.Parcela
  INNER JOIN MovNota0
     ON MovFina0.UnidadeID = MovNota0.UnidadeID
    AND MovFina0.TipoID    = MovNota0.TipoID
    AND MovFina0.Nota      = MovNota0.Nota
  INNER Join UsrUnid0
     ON UsrUnid0.UnidadeID = MovNota0.UnidadeID
  INNER Join LkpNota0
     ON MovNota0.TipoID = LkpNota0.TipoID
Where LkpNota0.Financeiro = @Financeiro
  AND (MovFina0.StatusID=0)  
  AND (MovFina2.StatusID In (0,1,2,3))
  AND (MovFina2.DtProjecao < @DataIni)
  AND (UsrUnid0.UsuarioID = IsNull(@UsuarioID,1))
  And (@UnidadeID  IS Null OR MovNota0.UnidadeID     = @UnidadeID)
  And (@PessoaID   IS Null OR MovNota0.PessoaID      = @PessoaID)
  And (@PortadorID IS Null OR MovFina0.PortadorID    = @PortadorID)


Insert Into #Extrato ( Data, Operacao, Processo, Historico , Saldo )
Values  ( @DataIni-Day( @DataIni )+1, 
          'Saldo Anterior', 
          'Saldo Anterior',
          Convert( VarChar(10), Month( @DataIni) )+'/'+ Convert( VarChar(10), Year( @DataIni) ),  
          @SaldoAnt )


end 

--Lançamentos

Insert Into #Extrato ( Data,                    Origem,        UnidadeID, 
                       Tipo,                    Codigo,        Operacao, 
                       Processo,                Historico,     Debito)
Select                 MovFina0.DtEmissao Data, 0 Origem, MovFina0.UnidadeID, 
                       MovFina0.TipoID,         MovFina0.Nota, 'Lançamento', 
                       LkpNota0.Tipo,           Financeiro.Historico + ' Ref. Movimento  '+Convert(Varchar(6),MovNota0.Nota) Historico,  MovFina0.Valor
From MovFina0
  INNER Join UsrUnid0
     ON UsrUnid0.UnidadeID = MovFina0.UnidadeID
  INNER JOIN MovNota0
     ON MovFina0.UnidadeID = MovNota0.UnidadeID
    AND MovFina0.TipoID    = MovNota0.TipoID
    AND MovFina0.Nota      = MovNota0.Nota
Inner Join Financeiro
     ON Financeiro.UnidadeID = MovNota0.UnidadeID
    AND Financeiro.TipoID    = MovNota0.TipoID
    AND Financeiro.Nota      = MovNota0.Nota
  INNER Join LkpNota0
     ON MovFina0.TipoID    = LkpNota0.TipoID

Where LkpNota0.Financeiro = @Financeiro
  AND (MovFina0.StatusID=0)
  AND (@DataIni   IS Null OR MovFina0.DtEmissao >= @DataIni)
  AND (@DataFin   IS Null OR MovFina0.DtEmissao <= @DataFin)
  AND (UsrUnid0.UsuarioID = IsNull(@UsuarioID,1))
  And (@UnidadeID  IS Null OR MovNota0.UnidadeID     = @UnidadeID)
  And (@PessoaID   IS Null OR MovNota0.PessoaID      = @PessoaID)
  And (@PortadorID IS Null OR MovFina0.PortadorID    = @PortadorID)


--Baixas
Insert Into #Extrato (Data, Origem,  Tipo, Codigo, Operacao, Processo, Historico, Credito, Encargos, Desconto)
Select MovFina2.DtProjecao Data, 1 Origem,  MovFina2.OperacaoID, MovFina2.MovimentoID,
  'Baixa', LkpNota0.Tipo,'Ref. ' + Financeiro.Historico AS Historico,
  MovFina1.ValorLiquido, MovFina1.ValorMulta + MovFina1.ValorJuros, MovFina1.ValorDesconto
From MovFina2
   INNER JOIN MovFina1
    On MovFina2.OperacaoID   = MovFina1.OperacaoID
    AND MovFina2.MovimentoID  = MovFina1.MovimentoID
  INNER JOIN MovFina0
     ON MovFina1.UnidadeID = MovFina0.UnidadeID
    AND MovFina1.TipoID    = MovFina0.TipoID
    AND MovFina1.Nota      = MovFina0.Nota
    AND MovFina1.Reneg     = MovFina0.Reneg
    AND MovFina1.Parcela   = MovFina0.Parcela
  INNER JOIN MovNota0
     ON MovFina0.UnidadeID = MovNota0.UnidadeID
    AND MovFina0.TipoID    = MovNota0.TipoID
    AND MovFina0.Nota      = MovNota0.Nota
  Inner Join Financeiro
     ON Financeiro.UnidadeID = MovNota0.UnidadeID
    AND Financeiro.TipoID    = MovNota0.TipoID
    AND Financeiro.Nota      = MovNota0.Nota
  INNER Join UsrUnid0
     ON UsrUnid0.UnidadeID = MovNota0.UnidadeID
  INNER Join LkpNota0
     ON MovNota0.TipoID = LkpNota0.TipoID
Where LkpNota0.Financeiro = @Financeiro
  AND (MovFina0.StatusID=0)
  AND MovFina2.StatusID In (0,1,2,3)
  AND ( @DataIni   IS Null OR MovFina2.DtProjecao >= @DataIni)
  AND ( @DataFin   IS Null OR MovFina2.DtProjecao <= @DataFin)
  AND (UsrUnid0.UsuarioID = IsNull(@UsuarioID,1))
  And (@UnidadeID  IS Null OR MovNota0.UnidadeID     = @UnidadeID)
  And (@PessoaID   IS Null OR MovNota0.PessoaID      = @PessoaID)
  And (@PortadorID IS Null OR MovFina0.PortadorID    = @PortadorID)
Declare C  Cursor Local for
Select Debito, Credito from #Extrato
Open C

FETCH NEXT FROM C INTO @Debito, @Credito

WHILE @@FETCH_STATUS = 0
BEGIN  
   UPDATE #Extrato SET Saldo = @SaldoAnt - @Debito + @Credito 
   WHERE CURRENT OF c
   set @SaldoAnt = @SaldoAnt - @Debito + @Credito
   FETCH NEXT FROM C INTO @Debito, @Credito
END
Set NoCount OFF
Select *
From #Extrato
Order By Data, Origem, Tipo, Codigo

SET QUOTED_IDENTIFIER ON
GO

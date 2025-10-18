SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE          Procedure [dbo].[SP_GeraTaxaBancaria]

@UnidadeID  Int,
@ContaID    Int,
@Descricao  VarChar(50),
@Valor      Real,
@CentroID   Int,
@Data       DateTime,
@UsuarioID  Int
As 

Declare @Nota       Int,
	@TipoID     Int,
	@PessoaID   Int,
	@PortadorID Int
Set @TipoID = 3

Select @PessoaID = CadPess0.PessoaID,  @PortadorID = CadPort0.PortadorID
From CadCont0
   JOIN CadPort0
     On CadCont0.PortadorID = CadPort0.PortadorID
   JOIN dbo.VWS_Pessoas CadPess0
     On CadPess0.PessoaID = IsNull(CadPort0.PessoaID, 1)
Where  CadCont0.ContaID   = @ContaID

Select @Nota = IsNull( Max( Nota ), 0 )+1
From MovNota0
Where UnidadeID = @UnidadeID
  And TipoID    = @TipoID


Insert Into MovNota0 (UnidadeID, TipoID, Nota, DtMovimento, 
                      PessoaID, StatusID)
	        Values ( @UnidadeID, @TipoID, @Nota,@Data,
	                 @PessoaID, 2)

Insert into Financeiro (UnidadeID, TipoID, Nota, Historico, Juros, Retencao, Total, Pagamento)
    Values ( @UnidadeID, @TipoID, @Nota,
	         @Descricao, 0, 0, @Valor, 'A Vista')
	         
if @CentroID is not null	
begin         
  Insert into MovOrca0 (UnidadeID, TipoID, Nota, OrcamentoID, Rateio)	         
  Values (@UnidadeID, @TipoID, @Nota,	@CentroID, 100)
end


Insert into MovFina0 (UnidadeID, TipoID, Nota, Reneg, Parcela, 
                      Fatura, DocumentoID, PortadorID, 
                      DtEmissao, DtVencimento, Valor, StatusID)
Values (@UnidadeID, @TipoID, @Nota, 0, 1,
        'Taxa bancaria', 1, 999,
        CONVERT(Date,@Data), CONVERT(Date,@Data), @Valor, 0)                      
         

Declare 
  @MovimentoID Int,
  @OperacaoID  Int,
  @Titulo      VarChar(10)

Set @OperacaoID = 0

Select @MovimentoID = IsNull( Max( MovimentoID ), 0 )+1
From MovFina2
Where MovFina2.OperacaoID = @OperacaoID

Select @Titulo = replicate('0',10-Len(@MovimentoID))+STR(@MovimentoID, Len( @MovimentoID), 0) 


Insert Into MovFina2  ( OperacaoID,  MovimentoID, 
			Titulo,       MoedaID, DtPagamento,
			DtProjecao,   Valor,       ContaID, 
			StatusID,     Operador,    DtMovimento,
			DtConciliacao )
	       Values ( @OperacaoID, @MovimentoID,
			@Titulo,    0,           @Data,
			@Data,      @Valor,      @ContaID,
			3,          @UsuarioID,  @Data,
			@Data )

Insert Into MovFina1  ( UnidadeID,    TipoID,        Nota,
                        Reneg,        Parcela,       OperacaoID,
			MovimentoID,  ValorLiquido,  ValorMulta,
			ValorJuros,   ValorDesconto )
	       Values ( @UnidadeID,   @TipoID,  @Nota,
			0,            1,        @OperacaoID,
			@MovimentoID, @Valor,   0,
			0,            0 )

GO

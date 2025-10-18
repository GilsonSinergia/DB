SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE               Procedure [dbo].[SP_SetTransfereValor]
  @ContaSac        Int,
  @ContaDeposito   Int,
  @Data            DateTime,
  @Valor           Money,
  @UsuarioID       Int,
  @Historico       VarChar(50)= Null,
  @Numero          VarChar(10) = ''
AS
Declare 
  @MovimentoID       Int,
  @ParentOperacaoID  int,
  @ParentMovimentoID int,
  @MoedaID           INT;

SELECT @MoedaID = MIN(MoedaID) FROM dbo.CadMoed0 

Select @MovimentoID = IsNull(Max(MovimentoID),0)+1
From MovFina2
Where OperacaoID = 2

insert into MovFina2
    (OperacaoID,  MovimentoID, 
     Titulo,      MoedaID,     DtPagamento, 
     Valor,       ContaID,     StatusID, 
     Operador,    DtMovimento, DtProjecao, 
     ParentOperacaoID, ParentMovimentoID, DtConciliacao,
     Descricao)
  values
    ( 2, @MovimentoID, 
     @MovimentoID, @MoedaID , @Data,
     @Valor,       @ContaSac,  3,
     @UsuarioID,   @Data,      @Data,
     @ParentOperacaoID, @ParentMovimentoID, @Data,
     IsNull(@Historico, 'Sac'))

Set @ParentMovimentoID = @MovimentoID
Set @ParentOperacaoID  = 2

Select @MovimentoID = IsNull(Max(MovimentoID),0)+1
From MovFina2
Where OperacaoID = 3

insert into MovFina2
    (OperacaoID,  MovimentoID, 
     Titulo,    MoedaID, DtPagamento, 
     Valor,     ContaID    , StatusID, 
     Operador,  DtMovimento, DtProjecao, 
     ParentOperacaoID, ParentMovimentoID, DtConciliacao,
     Descricao)
Select
     3,  @MovimentoID, 
     Titulo,    MoedaID, DtPagamento, 
     Valor,     @ContaDeposito, StatusID, 
     Operador,  DtMovimento, DtProjecao, 
     OperacaoID,MovimentoID, DtConciliacao, 
     IsNull(@Historico, 'Deposito')
From MovFina2
Where OperacaoID  = 2
  AND MovimentoID = @ParentMovimentoID


Select @ParentOperacaoID OperacaoID, @ParentMovimentoID MovimentoID, @Numero Numero



GO

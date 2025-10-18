SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE                      Procedure [dbo].[SP_GetPesEstatistica]
  @PessoaID     INT = NULL,
  @FinanceiroID INT=1,
  @Conciliado int=1
AS
   Create Table #Credito
    (
     PessoaID        Int         Not Null Primary Key,
     Nome            VarChar(150) Not Null,
     Reduzido        VarChar(150) Not Null,
     DtVenctoCredito DateTime   Null,

     --Limite de Credito
     LimiteCredito   Money Not Null Default 0,
     Adiantamento    Money Not Null Default 0,
     Emprestimo      Money Not Null Default 0,
     Debito          Money Not Null Default 0,
     Saldo           As LimiteCredito + Adiantamento - Emprestimo - Debito,

     --Movimentação
     QtdMovimanto       int  Not Null Default 0,
     ValMedioMovimanto  Money Not Null Default 0,
     ValMaiorMovimanto  Money Not Null Default 0,
     DtMaiorMovimanto   Datetime Null,
     ValUltimaMovimanto Money Not Null Default 0,
     DtlUltimaMovimanto Datetime Null,
     
     --Faturas
     QtdFaturasQuitadas int  Not Null Default 0,
     QtdFaturasParciais int  Not Null Default 0,    
     QtdFaturasVencidas int  Not Null Default 0,
     QtdFaturasAVencer  int  Not Null Default 0,

     ValQuitadas        Money Not Null Default 0,
     ValVencidas        Money  not Null Default 0,
     ValAVencer         Money Not Null Default 0,
     ValProcimaFatura   Money Not Null Default 0,
     DtProcimaFatura    DateTime Null ,

     QtdChequeDevolvido int  Not Null Default 0,
     ValChequeDevolvido Money Not Null Default 0,

     --Atraso
     QtdAtraso       int  Not Null Default 0,
     MaiorAtraso     int  Not Null Default 0,
     Atrasomedio     int  Not Null Default 0,
     CreditoAntecipado  Money Not Null Default 0 
     )

If exists (Select PessoaID From CadPess0 Where PessoaID = @PessoaID) begin
  Insert into #Credito (PessoaID, Nome, Reduzido, DtVenctoCredito, LimiteCredito)
  Select CadPess0.PessoaID, Nome, Reduzido, DtCredito, IsNull( Credito, 0 )
  From CadPess0
    LEFT OUTER JOIN PesClie0
      ON PesClie0.PessoaID = CadPess0.PessoaID
  Where CadPess0.PessoaID = @PessoaID

  Declare
     @QtdMovimantos        int = 0,
     @ValMedioMovimantos   Money =0,
     @ValMaiorMovimantos   Money  = 0,
     @DtMaiorMovimantos    Datetime = 0,
     @ValUltimaMovimantos  Money = 0,
     @DtlUltimaMovimantos  Datetime



  Select @QtdMovimantos = Count(*) , @ValMedioMovimantos = Avg(VL_Total),
         @ValMaiorMovimantos = Max(VL_Total), @DtlUltimaMovimantos = Max(DtMovimento)
  From MovNota0
    JOIN lkpNota0 ON lkpNota0.TipoID = MovNota0.TipoID
	JOIN dbo.VWS_Movimento_Totais T ON T.Chave = MovNota0.Chave
  Where MovNota0.PessoaID   = @PessoaID
    AND lkpNota0.Financeiro = @FinanceiroID  
    AND (MovNota0.StatusID =2  )
    AND MovNota0.UnidadeID in (1,3,5)

  Select @DtMaiorMovimantos = Max(DtMovimento)
  From MovNota0
    Inner join lkpNota0
       ON lkpNota0.TipoID = MovNota0.TipoID

  Where MovNota0.PessoaID   = @PessoaID
    AND lkpNota0.Financeiro = @FinanceiroID
    AND (MovNota0.StatusID =2  )
    AND MovNota0.UnidadeID in (1,3,5)



Select @ValUltimaMovimantos = Max(VL_Total)
  From MovNota0
    Inner join lkpNota0
       ON lkpNota0.TipoID = MovNota0.TipoID
    JOIN dbo.VWS_Movimento_Totais T ON T.Chave = MovNota0.Chave
  Where MovNota0.PessoaID   = @PessoaID
    AND lkpNota0.Financeiro = @FinanceiroID
    AND MovNota0.DtMovimento = @DtlUltimaMovimantos
    AND (MovNota0.StatusID =2  )
    AND MovNota0.UnidadeID in (1,3,5)




Update #Credito Set 
  QtdMovimanto       = @QtdMovimantos,
  ValMedioMovimanto  = IsNull( @ValMedioMovimantos, 0 ),
  ValMaiorMovimanto  = IsNull( @ValMaiorMovimantos, 0 ),
  DtMaiorMovimanto   = @DtMaiorMovimantos,
  ValUltimaMovimanto = IsNull( @ValUltimaMovimantos, 0 ),
  DtlUltimaMovimanto = @DtlUltimaMovimantos

--Faturas
declare
  @Data DateTime, 
  @QtdFaturasQuitadas   int,
  @QtdFaturasParciais   int,  
  @QtdFaturasVencidas   int,  
  @QtdFaturasAVencer    int,

  @ValQuitadas          Money,
  @ValVencidas          Money,
  @ValAVencer           Money,

  @QtdAtraso            int,
  @MaiorAtraso          int,
  @Atrasomedio          int,


  @QtdChequeDevolvido   int,
  @ValChequeDevolvido   Money,
  @CreditoAntecipado    Money,
  @ValProcimaFatura     Money,
  @DtProcimaFatura      DateTime
  
  
    
	select Top 1 @ValProcimaFatura= Sum(ST.Corrigido), @DtProcimaFatura = dtVencimento
	from dbo.FN_Staus_Parcela(@FinanceiroID, @PessoaID, @Conciliado ,@Data)ST
	  Inner JOIN MovFina0
		 ON MovFina0.UnidadeID=ST.UnidadeID
		AND MovFina0.TipoID=ST.TipoID 
		AND MovFina0.Nota=ST.Nota
		AND MovFina0.Reneg=ST.Reneg
		AND MovFina0.Parcela=ST.Parcela
	Where ST.StatusID<>2
	Group BY dtVencimento
	Order BY dtVencimento 
  

    Set @Data = Convert(Datetime,Floor(Convert(Float,GetDate())))
  
   
   

Select  
  @QtdFaturasQuitadas =
  IsNull( Sum(case when VW_Staus_Parcela.StatusID = 2 then 1  else 0 end),0), 
 
  @QtdFaturasParciais =  
  IsNull( Sum(case when VW_Staus_Parcela.StatusID = 1 then 1  else 0 end),0), 
 
  @QtdFaturasAVencer =  
  IsNull( Sum(case when VW_Staus_Parcela.PagamentoID = 1 then 1  else 0 end),0), 

  @ValQuitadas       = 
  IsNull( Sum(VW_Staus_Parcela.Quitado),0),
 
  @ValAVencer         =  
  IsNull( Sum(case when VW_Staus_Parcela.PagamentoID = 1 then VW_Staus_Parcela.Corrigido  else 0 end),0) 
    From MovNota0
      Inner join lkpNota0
        ON lkpNota0.TipoID = MovNota0.TipoID
      Inner Join FN_Staus_Parcela(@FinanceiroID, @PessoaID, @Conciliado, @Data)  VW_Staus_Parcela
        ON VW_Staus_Parcela.UnidadeID = MovNota0.UnidadeID
       AND VW_Staus_Parcela.TipoID    = MovNota0.TipoID
       AND VW_Staus_Parcela.Nota      = MovNota0.Nota
   where MovNota0.PessoaID  = @PessoaID
    AND lkpNota0.Financeiro = @FinanceiroID    
    --AND MovNota0.StatusID =2
    
  Select  @ValVencidas  =   IsNull(Sum(case when VW_Staus_Parcela.PagamentoID = 0 then VW_Staus_Parcela.Corrigido  else 0 end),0),   
          @QtdFaturasVencidas =    IsNull( Sum(case when VW_Staus_Parcela.PagamentoID = 0 then 1  else 0 end),0)
      From MovNota0
      Inner join lkpNota0
        ON lkpNota0.TipoID = MovNota0.TipoID
      Inner Join FN_Staus_Parcela(@FinanceiroID, @PessoaID, 0, @Data)  VW_Staus_Parcela
        ON VW_Staus_Parcela.UnidadeID = MovNota0.UnidadeID
       AND VW_Staus_Parcela.TipoID    = MovNota0.TipoID
       AND VW_Staus_Parcela.Nota      = MovNota0.Nota
   where MovNota0.PessoaID  = @PessoaID
    AND lkpNota0.Financeiro = @FinanceiroID    
    --AND MovNota0.StatusID =2

Select   
  @QtdAtraso   = SUM(case when PagamentoID = 0  then 1 else 0 end),
  @ValVencidas = SUM(case when PagamentoID = 0  then Aberto else 0 end),
  @MaiorAtraso = Max(Dias),
  @Atrasomedio = Avg(Case when Dias > 0 then Dias else 0 end )
from FN_Staus_Parcela(1, @PessoaID, 1, @Data)



  Select @QtdChequeDevolvido = Sum(Case when MovFina2.MoedaID =1 AND MovFina2.StatusID = 4 then 1 else 0 end ), 
         @ValChequeDevolvido = Sum(Case when MovFina2.MoedaID =1 AND MovFina2.StatusID = 4 then MovFina2.Valor else 0 end)  
  from MovNota0
      Inner join lkpNota0
        ON lkpNota0.TipoID = MovNota0.TipoID
      Inner Join  MovFina0     
         ON MovFina0.UnidadeID = MovNota0.UnidadeID
        AND MovFina0.TipoID    = MovNota0.TipoID
        AND MovFina0.Nota      = MovNota0.Nota
      INNER  Join MovFina1
      ON MovFina0.UnidadeID = MovFina1.UnidadeID
     AND MovFina0.TipoID  = MovFina1.TipoID
     AND MovFina0.Nota    = MovFina1.Nota
     AND MovFina0.Reneg   = MovFina1.Reneg
     AND MovFina0.Parcela = MovFina1.Parcela
   INNER JOIN MovFina2
     ON MovFina1.OperacaoID  = MovFina2.OperacaoID
    AND MovFina1.MovimentoID = MovFina2.MovimentoID
   where MovNota0.PessoaID = @PessoaID
    AND lkpNota0.Financeiro = 1
    AND MovFina0.StatusID = 0




  Update #Credito Set 
    Debito             = (select IsNull(Sum(case when VW_Staus_Parcela.PagamentoID = 0 then VW_Staus_Parcela.Corrigido  else 0 end),0)
                                 From MovNota0
								  Inner join lkpNota0
									ON lkpNota0.TipoID = MovNota0.TipoID
								  Inner Join FN_Staus_Parcela(@FinanceiroID, @PessoaID, @Conciliado, @Data)  VW_Staus_Parcela
									ON VW_Staus_Parcela.UnidadeID = MovNota0.UnidadeID
								   AND VW_Staus_Parcela.TipoID    = MovNota0.TipoID
								   AND VW_Staus_Parcela.Nota      = MovNota0.Nota
							   where MovNota0.PessoaID  = @PessoaID
								AND lkpNota0.Financeiro = @FinanceiroID   ) + @ValAVencer,
    QtdFaturasQuitadas = IsNull(@QtdFaturasQuitadas, 0),
    QtdFaturasParciais = IsNull(@QtdFaturasParciais, 0),
    QtdFaturasVencidas = IsNull(@QtdFaturasVencidas, 0),
    QtdFaturasAVencer  = IsNull(@QtdFaturasAVencer, 0),
    ValQuitadas        = IsNull(@ValQuitadas, 0),
    ValVencidas        = IsNull(@ValVencidas, 0),
    ValAVencer         = IsNull(@ValAVencer, 0),
    QtdAtraso          = IsNull(@QtdAtraso, 0),
    MaiorAtraso        = IsNull(@MaiorAtraso, 0),
    Atrasomedio        = IsNull(@Atrasomedio, 0),
    QtdChequeDevolvido = IsNull(@QtdChequeDevolvido,0),
    ValChequeDevolvido = IsNull(@ValChequeDevolvido,0),
    CreditoAntecipado  = IsNull(@CreditoAntecipado,0),
    ValProcimaFatura   = IsNull(@ValProcimaFatura,0),
    DtProcimaFatura    = @DtProcimaFatura 		

end
Select C.*, CadPess0.OBS From #Credito C
Inner JOIN CadPess0 ON CadPess0.PessoaID=C.PessoaID
Drop Table #Credito

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

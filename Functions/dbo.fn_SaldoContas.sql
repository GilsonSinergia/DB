SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  Function [dbo].[fn_SaldoContas]
  ( @Data Date)
Returns Table

As 
Return
  (
  Select  MovFina2.ContaID, 
    Sum(Case  
         When MovFina2.DtConciliacao <= @Data then MovFina2.Valor * LkpBaix1.Multiplicador
         else 0
        End
        ) Conciliado, 
    Sum(Case  
          When MovFina2.DtConciliacao <= @Data then MovFina2.Valor * LkpBaix1.Multiplicador
          else 0
         End+
         Case 
          When MovFina2.DtConciliacao Is Null 
            OR MovFina2.DtConciliacao > @Data then  MovFina2.Valor * LkpBaix1.Multiplicador 
          else 0 
         end
         ) Projetado
  From CadCont0 
     Left Join MovFina2
        On CadCont0.ContaID = MovFina2.ContaID
     LEFT Join LkpBaix1
        On LkpBaix1.OperacaoID = MovFina2.OperacaoID
  Where (MovFina2.StatusID <= 3)
  Group by MovFina2.ContaID, CadCont0.Limite

  )
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    Procedure [dbo].[SP_R_FluxoCaixaSimplificado]
  @UnidadeID       Int = Null,
  @Data            dateTime
AS
  
SET LANGUAGE [Português (Brasil)]

Declare @dataConta Datetime = Convert(DateTime,Floor(Convert(Float,GetDate())))

--Gerando Saldo em contas
Select IDENTITY(Int,1,1)ID,
       '00-Saaldo em contas                             ' Grupo,
       CadPort0.Portador + '-' + CadCont0.Conta SubGrupo,
       case when Conciliado < 0 then ABS( Conciliado ) else 0 end ValPagar,
       case when Conciliado > 0 then ABS( Conciliado ) else 0 end ValReceber
Into #Fluxo         
from fn_SaldoContas(@Data)Saldos
  JOIN CadCont0 on CadCont0.ContaID=Saldos.ContaID 
  JOIN CadPort0 on CadPort0.PortadorID=CadCont0.PortadorID
where Conciliado <> 0   
Order by CadPort0.PortadorID  


Select  
   LkpNota0.Financeiro, 
   MovFina0.DtVencimento,
   TBStatus.Aberto 
  Into #T  
  from  dbo.FN_Staus_Parcela(Null, Null, 0, @dataConta)TBStatus
    JOIN lkpNota0  ON  lkpNota0.TipoID  = tbStatus.TipoID
     JOIN MovFina0 ON tbStatus.ChaveTitulo = MovFina0.ChaveTitulo       
  Where TBStatus.Aberto <> 0
    AND @UnidadeID Is Null OR Power(2, tbStatus.UnidadeID) & @UnidadeID <> 0  
    And Aberto<>0   
union all  
 
Select  
  lkpNota0.Financeiro, 
  MovFina2.DtProjecao, 
  MovFina1.ValorPago
from MovFina2
  Join MovFina1
    on MovFina1.OperacaoID=MovFina2.OperacaoID
   AND MovFina1.MovimentoID=MovFina2.MovimentoID 
  Inner JOIN lkpNota0 ON lkpNota0.TipoID  = MovFina1.TipoID 
  JOIN Movnota0 ON Movnota0.Chave = MovFina1.Chave
Where Movnota0.StatusID=2    
  AND MovFina2.StatusID<=2




Insert into #Fluxo(Grupo, SubGrupo, ValPagar, ValReceber)
Select 
    Case  
     When  Year(@Data) > Year (DtVencimento) then '01-Anos Anteriores'
     When  Year(@Data) = Year (DtVencimento) 
       AND Month(@Data) >  Month(DtVencimento)then '02-Meses Anteriores'
     When Year (@Data) = Year (DtVencimento) 
      AND Month(@Data) = month(DtVencimento) then '03-Mes atual'
     When Year (@Data) = Year(DtVencimento)  
      AND Month(@Data) < month(DtVencimento) then '04-Meses postreriores'
     else                                         '05-Anos Posteriores'
  end Grupo,
  Case  
     When  Year(@Data) <> Year (DtVencimento) then Convert(VarChar, Year (DtVencimento)) 
     When  Year(@Data) =  Year (DtVencimento)
      AND Month(@Data) <> Month(DtVencimento)then REPLACE(STR(Month(DtVencimento),2,0), ' ', '0') + ' ' + Datename(mm, DtVencimento)
     When Year (@Data) = Year (DtVencimento) 
      AND Month(@Data) = month(DtVencimento) then REPLACE(STR(day(DtVencimento),2,0), ' ', '0') +' de '+ DATENAME(mm, DtVencimento) + ' '+ Convert(Char(3), DATENAME(dw, DtVencimento))
     else Convert(Varchar, DtVencimento)
  end  SubGrupo,
  sum (Case Financeiro when  -1 then Aberto else 0 end) Credito,
  sum (Case Financeiro when   1 then Aberto else 0 end) Debito
from #T
Group by 
  Case  
     When  Year(@Data) > Year (DtVencimento) then '01-Anos Anteriores'
     When  Year(@Data) = Year (DtVencimento) 
       AND Month(@Data) >  Month(DtVencimento)then '02-Meses Anteriores'
     When Year (@Data) = Year (DtVencimento) 
      AND Month(@Data) = month(DtVencimento) then '03-Mes atual'
     When Year (@Data) = Year(DtVencimento)  
      AND Month(@Data) < month(DtVencimento) then '04-Meses postreriores'
     else                                         '05-Anos Posteriores'
  end,
  Case  
     When  Year(@Data) <> Year (DtVencimento) then Convert(VarChar, Year (DtVencimento)) 
     When  Year(@Data) =  Year (DtVencimento)
      AND Month(@Data) <> Month(DtVencimento)then REPLACE(STR(Month(DtVencimento),2,0), ' ', '0') + ' ' + Datename(mm, DtVencimento)
     When Year (@Data) = Year (DtVencimento) 
      AND Month(@Data) = month(DtVencimento) then REPLACE(STR(Day(DtVencimento),2,0), ' ', '0') +' de '+ DATENAME(mm, DtVencimento) + ' '+ Convert(Char(3), DATENAME(dw, DtVencimento))
     else Convert(Varchar, DtVencimento)
  end 
Order by Grupo, SubGrupo

;WITH Fluxo (TipoID, Grupo, SubGrupo, Credito, PerCredito,  Debito, PerDebito ) As (
 SELECT
   ID, 
   Grupo, 
   SubGrupo, 
   ValReceber, 
   ValReceber / IsNULL( SUM(ValReceber) OVER (PARTITION BY 1),1) * 100 As PerCredito,
   ValPagar,
   ValPagar   / ISNULL(SUM(ValPagar)   OVER (PARTITION BY 1),1) * 100 As PerlDebito
 From #Fluxo)
 

Select 
  *,
  (SELECT SUM(TInt.Credito - Debito) FROM Fluxo As TInt
        WHERE TInt.TipoID <= Fluxo.TipoID) As Saldo 
from Fluxo 
order by TipoID
GO

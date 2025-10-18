SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                 Procedure [dbo].[SP_R_OrcamentoAnual]
  @UnidadeID Int = 3, 
  @Ano       Int = 2019,
  @Tipo      Char(1) = 1,
  @IniNivel  Int = null,
  @FimNivel  Int = null
AS


if @Tipo =1
Select 
  CadOrca0.OrcamentoID,
  CadOrca0.Codigo,
  '-'+Convert(VarChar, Space(Nivel-1)+CadOrca0.Orcamento) Classe, 
  TipoID Tipo,
  IsNull(Sum( Case Mes when  1 then Saldo.Saldo else 0 end),0)Jan,
  
  IsNull(Sum( Case Mes when  2 then Saldo.Saldo else 0 end),0)Fev,

  IsNull(Sum( Case Mes when  3 then Saldo.Saldo else 0 end),0)Mar,
  
  IsNull(Sum( Case Mes when  4 then Saldo.Saldo else 0 end),0)Abr,
  
  IsNull(Sum( Case Mes when  5 then Saldo.Saldo else 0 end),0)Mai,
  
  IsNull(Sum( Case Mes when  6 then Saldo.Saldo else 0 end),0)Jun,

  IsNull(Sum( Case Mes when  7 then Saldo.Saldo else 0 end),0)Jul,

  IsNull(Sum( Case Mes when  8 then Saldo.Saldo else 0 end),0)Ago,

  IsNull(Sum( Case Mes when  9 then Saldo.Saldo else 0 end),0)'Set',

  IsNull(Sum( Case Mes when 10 then Saldo.Saldo else 0 end),0)'Out',

  IsNull(Sum( Case Mes when 11 then Saldo.Saldo else 0 end),0)Nov,

  IsNull(Sum( Case Mes when 12 then Saldo.Saldo else 0 end),0)Dez
from VWS_Orcamento CadOrca0
  JOIN (Select CadOrca0.Codigo, 
                     Month(MovFina0.DtEmissao) Mes, 
                     Sum(lkpNota0.Financeiro * MovFina0.Valor * Rateio / 100)Saldo
            From  MovOrca0
				JOIN MovFina0
				  ON MovOrca0.Chave = MovFina0.Chave
                JOIN VWS_Orcamento CadOrca0
                  ON MovOrca0.OrcamentoID  = CadOrca0.OrcamentoID
                JOIN LkpNota0
                  ON LkpNota0.TipoID    = MovOrca0.TipoID
            Where  LkpNota0.Financeiro <> 0 
              AND (@UnidadeID Is null OR MovOrca0.UnidadeID = @UnidadeID)
              AND Year(MovFina0.DtEmissao) = @Ano
            Group by CadOrca0.Codigo, Month(MovFina0.DtEmissao) )AS Saldo
     ON CadOrca0.Codigo     = SubString(Saldo.Codigo,1 ,Len(CadOrca0.Codigo))     
where (@IniNivel  Is Null     OR CadOrca0.Nivel  >=  @IniNivel)
 AND (@FimNivel  Is Null     OR CadOrca0.Nivel  <=  @FimNivel)
Group BY 
  CadOrca0.OrcamentoID,
  CadOrca0.Codigo, 
  TipoID,
  Convert(VarChar, Space(Nivel-1)+CadOrca0.Orcamento)
Order BY  CadOrca0.Codigo 

else if @Tipo = 2

Select 
  CadOrca0.Codigo,
  Convert(VarChar, Space(Nivel-1)+CadOrca0.Orcamento) Classe, 
  TipoID Tipo,
  IsNull(Sum( Case Mes when  1 then Saldo.Saldo else 0 end),0)Jan,
  IsNull(Sum( Case when Mes = 1 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotJan,
  
  IsNull(Sum( Case Mes when  2 then Saldo.Saldo else 0 end),0)Fev,
  IsNull(Sum( Case when Mes = 2 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotFev,

  IsNull(Sum( Case Mes when  3 then Saldo.Saldo else 0 end),0)Mar,
  IsNull(Sum( Case when Mes = 3 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotMar,
  
  IsNull(Sum( Case Mes when  4 then Saldo.Saldo else 0 end),0)Abr,
  IsNull(Sum( Case when Mes = 4 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotAbr,
  
  IsNull(Sum( Case Mes when  5 then Saldo.Saldo else 0 end),0)Mai,
  IsNull(Sum( Case when Mes = 5 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotMai,
  
  IsNull(Sum( Case Mes when  6 then Saldo.Saldo else 0 end),0)Jun,
  IsNull(Sum( Case when Mes = 6 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotJun,

  IsNull(Sum( Case Mes when  7 then Saldo.Saldo else 0 end),0)Jul,
  IsNull(Sum( Case when Mes = 7 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotJul,

  IsNull(Sum( Case Mes when  8 then Saldo.Saldo else 0 end),0)Ago,
  IsNull(Sum( Case when Mes = 8 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotAgo,

  IsNull(Sum( Case Mes when  9 then Saldo.Saldo else 0 end),0)'Set',
  IsNull(Sum( Case when Mes = 9 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotSet,

  IsNull(Sum( Case Mes when 10 then Saldo.Saldo else 0 end),0)'Out',
  IsNull(Sum( Case when Mes = 10 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotOut,

  IsNull(Sum( Case Mes when 11 then Saldo.Saldo else 0 end),0)Nov,
  IsNull(Sum( Case when Mes = 11 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotNov,

  IsNull(Sum( Case Mes when 12 then Saldo.Saldo else 0 end),0)Dez,
  IsNull(Sum( Case when Mes = 12 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotDez
from VWS_Orcamento CadOrca0
  LEFT JOIN (
		Select 
			CadOrca0.Codigo, 
            Month(MovFina0.DtVencimento) Mes,
            Sum(lkpNota0.Financeiro * MovFina0.Valor)Saldo
        From MovOrca0
			JOIN MovNota0 ON MovNota0.Chave = MovOrca0.Chave                 
			JOIN MovFina0 ON MovOrca0.Chave = MovFina0.Chave
            JOIN VWS_Orcamento CadOrca0 on MovOrca0.OrcamentoID  = CadOrca0.OrcamentoID
        INNER JOIN LkpNota0
            ON LkpNota0.TipoID    = MovOrca0.TipoID
        Where  LkpNota0.Financeiro <> 0 
            AND Year(MovFina0.DtVencimento) = @Ano
            AND MovFina0.Documentoid <> 6  
            AND MovNota0.StatusID=2
            AND MovFina0.StatusID=0
            AND (@UnidadeID Is null OR MovOrca0.UnidadeID = @UnidadeID)
        Group by CadOrca0.Codigo, Month(MovFina0.DtVencimento) )AS Saldo
    on  CadOrca0.Codigo     = SubString(Saldo.Codigo,1 ,Len(CadOrca0.Codigo))     
where (@IniNivel  Is Null     OR CadOrca0.Nivel  >=  @IniNivel)
  AND (@FimNivel  Is Null     OR CadOrca0.Nivel  <=  @FimNivel)
  Group BY CadOrca0.Codigo, TipoID,
  Convert(VarChar, Space(Nivel-1)+CadOrca0.Orcamento)
Order BY  CadOrca0.Codigo


ELSE IF @Tipo = 3
Select 
  CadOrca0.Codigo,
  Convert(VarChar, Space(Nivel-1)+CadOrca0.Orcamento) Classe,TipoID Tipo,
  IsNull(Sum( Case Mes when  1 then Saldo.Saldo else 0 end),0)Jan,
  IsNull(Sum( Case when Mes = 1 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotJan,
  
  IsNull(Sum( Case Mes when  2 then Saldo.Saldo else 0 end),0)Fev,
  IsNull(Sum( Case when Mes = 2 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotFev,

  IsNull(Sum( Case Mes when  3 then Saldo.Saldo else 0 end),0)Mar,
  IsNull(Sum( Case when Mes = 3 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotMar,
  
  IsNull(Sum( Case Mes when  4 then Saldo.Saldo else 0 end),0)Abr,
  IsNull(Sum( Case when Mes = 4 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotAbr,
  
  IsNull(Sum( Case Mes when  5 then Saldo.Saldo else 0 end),0)Mai,
  IsNull(Sum( Case when Mes = 5 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotMai,
  
  IsNull(Sum( Case Mes when  6 then Saldo.Saldo else 0 end),0)Jun,


  IsNull(Sum( Case when Mes = 6 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotJun,

  IsNull(Sum( Case Mes when  7 then Saldo.Saldo else 0 end),0)Jul,
  IsNull(Sum( Case when Mes = 7 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotJul,

  IsNull(Sum( Case Mes when  8 then Saldo.Saldo else 0 end),0)Ago,
  IsNull(Sum( Case when Mes = 8 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotAgo,

  IsNull(Sum( Case Mes when  9 then Saldo.Saldo else 0 end),0)'Set',
  IsNull(Sum( Case when Mes = 9 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotSet,

  IsNull(Sum( Case Mes when 10 then Saldo.Saldo else 0 end),0)'Out',
  IsNull(Sum( Case when Mes = 10 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotOut,

  IsNull(Sum( Case Mes when 11 then Saldo.Saldo else 0 end),0)Nov,
  IsNull(Sum( Case when Mes = 11 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotNov,

  IsNull(Sum( Case Mes when 12 then Saldo.Saldo else 0 end),0)Dez,
  IsNull(Sum( Case when Mes = 12 AND TipoID = @IniNivel then Saldo.Saldo else 0 end),0)TotDez
from VWS_Orcamento CadOrca0
  LEFT OUTER JOIN (Select CadOrca0.Codigo, 
                     Month(MovFina2.DtConciliacao) Mes,
                     Sum(lkpNota0.Financeiro * MovFina1.ValorPago)Saldo
                   From MovFina2
                     JOIN MovFina1
                       ON MovFina2.OperacaoID   = MovFina1.OperacaoID
                      AND MovFina2.MovimentoID  = MovFina1.MovimentoID
                     JOIN MovOrca0
                       ON MovOrca0.UnidadeID    = MovFina1.UnidadeID
                      AND MovOrca0.TipoID       = MovFina1.TipoID
                      AND MovOrca0.Nota         = MovFina1.Nota
                    JOIN VWS_Orcamento CadOrca0
                       on MovOrca0.OrcamentoID  = CadOrca0.OrcamentoID
                    INNER JOIN LkpNota0
                       ON LkpNota0.TipoID    = MovOrca0.TipoID
                   Where  LkpNota0.Financeiro <> 0 
                     AND MovFina2.StatusID = 3
                     AND Year(MovFina2.DtConciliacao) = @Ano
                     AND (@UnidadeID Is null OR MovOrca0.UnidadeID = @UnidadeID)
                   Group by CadOrca0.Codigo, Month(MovFina2.DtConciliacao) )AS Saldo
     on CadOrca0.Codigo     = SubString(Saldo.Codigo,1 ,Len(CadOrca0.Codigo))     
where (@IniNivel  Is Null     OR CadOrca0.Nivel  >=  @IniNivel)
  AND (@FimNivel  Is Null     OR CadOrca0.Nivel  <=  @FimNivel)
Group BY CadOrca0.Codigo,TipoID,
  Convert(VarChar, Space(Nivel-1)+CadOrca0.Orcamento)
Order BY  CadOrca0.Codigo


GO

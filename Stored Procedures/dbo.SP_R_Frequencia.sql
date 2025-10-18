SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      Procedure [dbo].[SP_R_Frequencia]
  @UnidadeID Int = Null,
  @AreaID   Int= Null,
  @CidadeID int= Null,
  @Ordem     int = 0
  
AS
Select 
  CadArea0.Area, 
  DateDiff(dd,MovNota0.DtMovimento,GetDate())SemVendas_a, 
  Case 
    When DateDiff(dd,MovNota0.DtMovimento,GetDate()) <= 30 then 'Ativos <= 30 Dias'
    When DateDiff(dd,MovNota0.DtMovimento,GetDate()) <= 60 then 'Cobertos  entre 31 e 60 Dias'
    When DateDiff(dd,MovNota0.DtMovimento,GetDate()) <= 90 then 'Descobertos  entre 61 e 90 Dias'
    When DateDiff(dd,MovNota0.DtMovimento,GetDate()) <= 180 then 'Abandonados  entre  91  e 180 Dias'
    Else 'Inativos a mais 180'
  End Status,
  MovNota0.PessoaID, 
  VWS_Pessoas.Nome, 
  VWS_Pessoas.Tel, 
  VWS_Pessoas.Cidade, 
  VWS_Pessoas.UF, 
  MovNota0.DtMovimento, 
  VL_Total UltimaVenda,
  Qtdvenda NumeroCompras, 
  VendaBruta , 
  MaiorVenda
From MovNota0
Inner JOIN VWS_Pessoas
     ON VWS_Pessoas.PessoaID=MovNota0.PessoaID
Inner JOIN PesClie0
     ON PesClie0.PessoaID=MovNota0.PessoaID
Inner JOIN CadArea0
     ON PesClie0.AreaID=CadArea0.AreaID
Inner JOIN (Select MovNota0.UnidadeID, PessoaID, 
              Max(DtMovimento)DtMovimento,
              Count(MovNota0.Nota) Qtdvenda,
              Sum(VL_Total)VendaBruta,
              Max(VL_Total)MaiorVenda
              From MovNota0
              JOIN dbo.VWS_Movimento_Totais T ON T.Chave = MovNota0.Chave
              Where MovNota0.UnidadeID = 1
                AND MovNota0.TipoID in(7,8,9,10)
              Group BY MovNota0.UnidadeID, PessoaID) Resumo
       ON Resumo.UnidadeID=MovNota0.UnidadeID
      AND Resumo.PessoaID=MovNota0.PessoaID
      AND Resumo.DtMovimento=MovNota0.DtMovimento
 JOIN dbo.VWS_Movimento_Totais T ON T.Chave = MovNota0.Chave
WHERE  MovNota0.TipoID IN (7, 8, 9, 10 )
 AND (@UnidadeID Is Null OR Power(2, MovNota0.UnidadeID) & @UnidadeID <> 0 )
 AND (@AreaID    Is Null OR CadArea0.AreaID = @AreaID)
 AND (@CidadeID  IS Null OR VWS_Pessoas.CidadeID   = @CidadeID)
Order by 
  Case @Ordem
    when 0 then Case 
					When DateDiff(dd,MovNota0.DtMovimento,GetDate()) <= 30 then 'Ativos <= 30 Dias'
					When DateDiff(dd,MovNota0.DtMovimento,GetDate()) <= 60 then 'Cobertos  entre 31 e 60 Dias'
					When DateDiff(dd,MovNota0.DtMovimento,GetDate()) <= 90 then 'Descobertos  entre 61 e 90 Dias'
					When DateDiff(dd,MovNota0.DtMovimento,GetDate()) <= 180 then 'Abandonados  entre  91  e 180 Dias'
					Else 'Inativos a mais 180'
				  End
    when 1 then CadArea0.Area
    else VWS_Pessoas.Cidade 
  end,
  MovNota0.DtMovimento
  
GO

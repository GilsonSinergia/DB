SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dbo].[fns_Movimento_Titulos](@Data DATE = NULL)
RETURNS TABLE
AS RETURN (
  WITH
  Parametros AS (
    SELECT 
      30 AS DiasAtraso, 
      90 AS DiasDuvidoso, 
      360 AS DiasPrejuizo,
      1 AS ContaminaPorCliente
  ),
  
  Baixas AS (
    SELECT 
      R.UnidadeID, R.TipoID, R.Nota, R.Reneg, R.Parcela,  
      SUM(ValorLiquido) ValorLiquido
    FROM dbo.VWS_Movimento_Baixa R 
    WHERE R.DtConciliacao <= ISNULL(@Data, CAST(GETDATE() AS DATE))
    GROUP BY R.UnidadeID, R.TipoID, R.Nota, R.Reneg, R.Parcela	
  ),
  
  StatusTitulo AS (
    SELECT
      T.UnidadeID, T.TipoID, T.Nota, T.Reneg, T.Parcela,
      M.PessoaID,
      T.Valor - ISNULL(B.ValorLiquido, 0) AS SaldoAberto,
      IIF(
        T.Valor - ISNULL(B.ValorLiquido, 0) <= 0 OR T.DtVencimento >= ISNULL(@Data, CAST(GETDATE() AS DATE)),
        0,
        DATEDIFF(DAY, T.DtVencimento, ISNULL(@Data, CAST(GETDATE() AS DATE)))
      ) AS Atraso
    FROM dbo.MovNota0 M
    JOIN dbo.MovFina0 T ON T.UnidadeID = M.UnidadeID AND T.TipoID = M.TipoID AND T.Nota = M.Nota
    LEFT JOIN Baixas B ON B.UnidadeID = T.UnidadeID AND B.TipoID = T.TipoID 
                       AND B.Nota = T.Nota AND B.Reneg = T.Reneg AND B.Parcela = T.Parcela
    WHERE M.StatusID = 2
  ),
  
  StatusCliente AS (
    SELECT
      ST.PessoaID,
      MAX(ST.Atraso) AS PiorAtraso
    FROM StatusTitulo ST
    WHERE ST.SaldoAberto > 0
    GROUP BY ST.PessoaID
  )
  
  SELECT 
    -- Identificadores + Descrições
    T.UnidadeID, U.Unidade,
    T.TipoID, T.Nota, T.Reneg, T.Parcela,
    T.ChaveTitulo, M.Chave,
    
    -- Classificações ID + Descrição
    IIF(LN.Financeiro = 1, 1, 2) AS NaturezaID,
    IIF(LN.Financeiro = 1, 'Direito', 'Obrigação') AS Natureza,
    M.FinalidadeID + 1 AS FinalidadeID,
    FIN.Finalidade,
    M.PessoaID, P.Reduzido AS Pessoa,
    T.DocumentoID + 1 AS DocumentoID,
    D.Documento,
    
    -- Datas
    M.DtMovimento, T.DtEmissao, T.DtVencimento,
    
    -- Valores
	LN.Financeiro Multiplicador,
    T.Valor,
    ISNULL(B.ValorLiquido, 0) AS Quitado,
    T.Valor - ISNULL(B.ValorLiquido, 0) AS Aberto,
    
    -- Status
    ST.Atraso,
    CASE 
      WHEN ST.SaldoAberto <= 0 THEN 6 
      WHEN IIF(PT.ContaminaPorCliente = 1, ISNULL(SC.PiorAtraso, ST.Atraso), ST.Atraso) >= DiasPrejuizo THEN 5
      WHEN IIF(PT.ContaminaPorCliente = 1, ISNULL(SC.PiorAtraso, ST.Atraso), ST.Atraso) >= DiasDuvidoso THEN 4
      WHEN IIF(PT.ContaminaPorCliente = 1, ISNULL(SC.PiorAtraso, ST.Atraso), ST.Atraso) >= DiasAtraso   THEN 3
      ELSE IIF(T.DtVencimento < ISNULL(@Data, CAST(GETDATE() AS DATE)), 1, 2)
    END AS StatusID,
    CASE 
      WHEN ST.SaldoAberto <= 0 THEN 'Quitado' 
      WHEN IIF(PT.ContaminaPorCliente = 1, ISNULL(SC.PiorAtraso, ST.Atraso), ST.Atraso) >= DiasPrejuizo THEN 'Prejuízo'
      WHEN IIF(PT.ContaminaPorCliente = 1, ISNULL(SC.PiorAtraso, ST.Atraso), ST.Atraso) >= DiasDuvidoso THEN 'Duvidoso'
      WHEN IIF(PT.ContaminaPorCliente = 1, ISNULL(SC.PiorAtraso, ST.Atraso), ST.Atraso) >= DiasAtraso   THEN 'Em Atraso'
      ELSE IIF(T.DtVencimento < ISNULL(@Data, CAST(GETDATE() AS DATE)), 'Vencido', 'A Vencer')
    END AS Status,
    IIF(DATEDIFF(DAY, ISNULL(@Data, CAST(GETDATE() AS DATE)), T.DtVencimento) < 365, 1, 0) AS Circulante
    
  FROM dbo.MovNota0 M
  JOIN dbo.CadUnid0 U ON U.UnidadeID = M.UnidadeID
  JOIN dbo.CadPess0 P ON P.PessoaID = M.PessoaID
  JOIN dbo.CTB_Finalidade FIN ON FIN.FinalidadeID = M.FinalidadeID
  JOIN dbo.MovFina0 T ON T.UnidadeID = M.UnidadeID AND T.TipoID = M.TipoID AND T.Nota = M.Nota
  JOIN dbo.CadDocu0 D ON D.DocumentoID = T.DocumentoID
  JOIN dbo.LkpNota0 LN ON LN.TipoID = M.TipoID
  LEFT JOIN Baixas B ON B.UnidadeID = T.UnidadeID AND B.TipoID = T.TipoID 
                     AND B.Nota = T.Nota AND B.Reneg = T.Reneg AND B.Parcela = T.Parcela
  LEFT JOIN StatusTitulo ST ON ST.UnidadeID = T.UnidadeID AND ST.TipoID = T.TipoID 
                            AND ST.Nota = T.Nota AND ST.Reneg = T.Reneg AND ST.Parcela = T.Parcela
  LEFT JOIN StatusCliente SC ON SC.PessoaID = M.PessoaID
  CROSS JOIN Parametros PT
  WHERE M.StatusID = 2
);
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[sp_R_Faturamento]
  @UnidadeID INT = NULL,
  @Dtini DATETIME = NULL,
  @DtFin DATETIME = NULL
as
SELECT 
  M.DtMovimento,  
  M.Chave,
  dbo.LkpFisc0.Modelo,
  F.NF,
  F.Serie,
  P.Nome Cliente,
  (T.VL_Total + T.VL_Desconto) * Financeiro VL_Bruto,
  T.VL_Desconto * Financeiro VL_Desconto,
  T.VL_Total * Financeiro VL_Venda,
  T.VL_CustoMedio * Financeiro VL_CMV,  
  (T.VL_Frete+T.VL_Seguro+T.VL_Outro + T.Vl_Operacional) * Financeiro VL_Acrecimo,
  T.VL_Comissao * Financeiro VL_Comissao,
  (T.Vl_ICMS + T.Vl_IPI - T.Vl_PIS- T.Vl_COFINS - T.Vl_ICMSSUB) * Financeiro VL_Imposto,
  (T.VL_Total - T.VL_CustoMedio - T.VL_Frete - T.VL_Seguro - T.VL_Outro - T.VL_Comissao - T.Vl_Operacional) * Financeiro VL_Lucro
FROM dbo.MovNota0 M  
  JOIN dbo.LkpNota0 ON LkpNota0.TipoID = M.TipoID
  JOIN dbo.VWS_Movimento_Totais T ON T.Chave = M.Chave
  JOIN dbo.VWS_Pessoas P ON P.PessoaID = M.PessoaID
  LEFT JOIN dbo.MovFisc0 F ON F.Chave = M.Chave
  LEFT JOIN dbo.LkpFisc0 ON LkpFisc0.ModeloID = F.ModeloID
WHERE M.StatusID=2
  AND M.TipoID IN (7,8,9,10, 13)
  AND ((@DtFin IS NULL AND @DtFin IS NULL) OR M.DtMovimento BETWEEN @Dtini AND @DtFin)
  AND (@UnidadeID IS NULL OR POWER(2, M.UnidadeID) & @UnidadeID <> 2)
ORDER BY M.UnidadeID, M.DtMovimento, M.Chave

GO

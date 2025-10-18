SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[SP_R_Orcamento_CentroCusto]
  @TipoID TINYINT =0,--Emissoao
  @DtIni DATETIME = '20220701',
  @DtFin DATETIME = '20220731'
AS
WITH CTE_LAN AS (
SELECT 
  Codigo,
  M.Chave,
  T.DtEmissao Data,
  T.Valor * Financeiro Valor
FROM dbo.MovNota0 M
  JOIN dbo.LkpNota0 ON LkpNota0.TipoID = M.TipoID
  JOIN dbo.MovFina0 T ON T.Chave = M.Chave  
  JOIN dbo.MovOrca0 MO ON MO.Chave = M.Chave
  JOIN dbo.VWS_Orcamento ON VWS_Orcamento.OrcamentoID = MO.OrcamentoID
WHERE @TipoID=0
  AND M.DtMovimento BETWEEN @DtIni AND @DtFin
  ),
CTE_Root AS (
SELECT 
  dbo.VWS_Orcamento.Codigo,
  dbo.VWS_Orcamento.Orcamento,
  dbo.VWS_Orcamento.Nivel,
  dbo.VWS_Orcamento.Tipo,
  SUM(LAN.Valor)Valor
FROM CTE_LAN LAN
  JOIN dbo.VWS_Orcamento ON LAN.Codigo LIKE dbo.VWS_Orcamento.Codigo +'%'
GROUP BY
  dbo.VWS_Orcamento.Codigo,
  dbo.VWS_Orcamento.Orcamento,
  dbo.VWS_Orcamento.Nivel,
  dbo.VWS_Orcamento.Tipo

)

SELECT 
  R.Codigo,
  R.Orcamento,
  R.Nivel,
  R.Tipo,
  L.Chave,
  L.Data,
  p.Nome Pessoa,
  F.Historico,
  ISNULL(L.Valor, R.Valor)Valor
FROM CTE_Root R
  LEFT JOIN CTE_LAN L ON L.Codigo = R.Codigo
  LEFT JOIN dbo.MovNota0 M ON M.Chave = L.Chave
  LEFT JOIN dbo.Financeiro F ON F.Chave = M.Chave
  LEFT JOIN dbo.CadPess0 p ON p.PessoaID = M.PessoaID
ORDER BY Codigo
GO

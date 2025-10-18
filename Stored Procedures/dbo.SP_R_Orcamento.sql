SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[SP_R_Orcamento]
  @UnidadeID INT = NULL,
  @TipoID TINYINT =2,--Emissoao
  @DtIni DATETIME = '20220701',
  @DtFin DATETIME = '20220731',
  @Conta VARCHAR(20) = '1.1'
AS
DECLARE @Unidade TABLE (UnidadeID INT, Unidade VARCHAR(50))


INSERT INTO @Unidade
(
    UnidadeID,
    Unidade
)
SELECT UnidadeID, Unidade FROM dbo.CadUnid0
WHERE (@UnidadeID IS NULL OR POWER(2, UnidadeID)& @UnidadeID <> 0);

WITH CTE_LAN AS (
SELECT 
  Codigo,  
  T.ChaveTitulo,
  T.DtEmissao Data,
  'Chave: ' + T.ChaveTitulo + ' Ref ' + F.Historico Historico,
  T.Valor * Financeiro Valor
FROM dbo.MovNota0 M
  JOIN dbo.Financeiro F ON F.Chave = M.Chave
  JOIN @Unidade u ON u.UnidadeID = M.UnidadeID
  JOIN dbo.LkpNota0 ON LkpNota0.TipoID = M.TipoID
  JOIN dbo.MovFina0 T ON T.Chave = M.Chave  
  JOIN dbo.MovOrca0 MO ON MO.Chave = M.Chave
  JOIN dbo.VWS_Orcamento ON VWS_Orcamento.OrcamentoID = MO.OrcamentoID
WHERE @TipoID=0
  AND M.DtMovimento BETWEEN @DtIni AND @DtFin
UNION ALL
SELECT 
  Codigo,
  F.ChaveTitulo,
  F.DtVencimento Data,
  'Chave: ' + T.ChaveTitulo + ' Ref ' + H.Historico Historico,
  T.VL_Aberto * Financeiro Valor
FROM dbo.MovNota0 M
  JOIN dbo.Financeiro H ON H.Chave = M.Chave
  JOIN @Unidade u ON u.UnidadeID = M.UnidadeID
  JOIN dbo.LkpNota0 ON LkpNota0.TipoID = M.TipoID
  JOIN dbo.MovFina0 F ON F.Chave = M.Chave
  JOIN dbo.FNS_Staus_Parcela(NULL) T ON T.ChaveTitulo = F.ChaveTitulo
  JOIN dbo.MovOrca0 MO ON MO.Chave = M.Chave
  JOIN dbo.VWS_Orcamento ON VWS_Orcamento.OrcamentoID = MO.OrcamentoID
WHERE @TipoID=1
  AND T.DtVencimento BETWEEN @DtIni AND @DtFin

UNION ALL
SELECT 
  Codigo,
  F.ChaveTitulo,
  B.DtConciliacao Data,
  'Baixa:'+ STR(B.MovimentoID, 6 , 0) 
  + ' Conta: ' + C.Conta_Extenso
  + CHAR(13)+
  + 'Ref: ' + H.Historico Historico,
  
  F.ValorPago * Financeiro Valor
FROM dbo.MovNota0 M
  JOIN dbo.Financeiro H ON H.Chave = M.Chave
  JOIN @Unidade u ON u.UnidadeID = M.UnidadeID  
  JOIN dbo.MovOrca0 MO ON MO.Chave = M.Chave
  JOIN dbo.VWS_Orcamento ON VWS_Orcamento.OrcamentoID = MO.OrcamentoID
  JOIN dbo.LkpNota0 ON LkpNota0.TipoID = M.TipoID
  JOIN dbo.MovFina1 F ON F.Chave = M.Chave
  JOIN dbo.MovFina2 B ON B.OperacaoID = F.OperacaoID AND B.MovimentoID = F.MovimentoID
  JOIN dbo.VWS_Conta C ON C.ContaID = B.ContaID
WHERE @TipoID=2
  AND B.DtConciliacao BETWEEN @DtIni AND @DtFin
  AND B.StatusID=3
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
  L.Data,
  L.ChaveTitulo,
  p.Reduzido + ' ( ' + p.Nome + ')' Pessoa,
  L.Historico,
  L.Valor,
  R.Valor Total
FROM CTE_Root R
  LEFT JOIN CTE_LAN L ON L.Codigo = R.Codigo
  LEFT JOIN dbo.MovNota0 M ON M.Chave = SUBSTRING(L.ChaveTitulo, 1, 14)
  LEFT JOIN dbo.CadPess0 p ON p.PessoaID = M.PessoaID
WHERE R.Codigo LIKE @Conta + '%'
ORDER BY Codigo, L.Data, L.ChaveTitulo

GO

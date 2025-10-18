SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [dbo].[VWS_Titulo_Extrato_Diario] AS
WITH Titulos AS  (
SELECT   
  T.UnidadeID,
  IIF(Financeiro=1, 1, 2)TipoID,
  IIF(T.DtVencimento < CONVERT(DATE, GETDATE()),T.DtVencimento, CONVERT(DATE, GETDATE()))  Data,
  T.ChaveTitulo,
  T.Valor
FROM dbo.MovNota0 M
  JOIN dbo.LkpNota0 ON LkpNota0.TipoID = M.TipoID
  JOIN dbo.MovFina0 T ON T.Chave = M.Chave  
WHERE M.StatusID=2
UNION ALL
SELECT 
  T.UnidadeID,
  IIF(Financeiro=1, 1, 2)TipoID,
  IIF(B.DtConciliacao < CONVERT(DATE, GETDATE()),B.DtConciliacao, CONVERT(DATE, GETDATE()))  Data,
  T.ChaveTitulo,
  - BR.ValorLiquido
FROM dbo.MovNota0 M
  JOIN dbo.LkpNota0 ON LkpNota0.TipoID = M.TipoID
  JOIN dbo.MovFina0 T ON T.Chave = M.Chave  
  JOIN dbo.MovFina1 BR ON BR.ChaveTitulo = T.ChaveTitulo
  JOIN dbo.MovFina2 B ON B.OperacaoID = BR.OperacaoID AND B.MovimentoID = BR.MovimentoID
WHERE M.StatusID=2 AND B.StatusID=3
),
T AS (
SELECT 
  T.*
FROM Titulos T
)

SELECT 
  T.*,
  SUM(Valor) OVER (PARTITION BY T.UnidadeID, T.TipoID ORDER BY T.Data ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )Saldo
FROM T
GO

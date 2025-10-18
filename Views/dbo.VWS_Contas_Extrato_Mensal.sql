SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE       VIEW [dbo].[VWS_Contas_Extrato_Mensal] AS
WITH T AS (
SELECT 
  T.UnidadeID,
  YEAR(T.Data)*100 + MONTH(T.Data) ANOMES,
  SUM(IIF(T.Valor > 0, T.Valor, 0)) Credito,
  SUM(IIF(T.Valor > 0, T.Valor, 0)) Debito,
  SUM(T.Valor) Valor
FROM dbo.VWS_Contas_Extrato_Diario T
GROUP BY 
  T.UnidadeID,
  YEAR(T.Data)*100+MONTH(T.Data))

SELECT 
  *,
  SUM(T.Valor) OVER (PARTITION BY UnidadeID ORDER BY T.ANOMES ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)Saldo
FROM T

GO

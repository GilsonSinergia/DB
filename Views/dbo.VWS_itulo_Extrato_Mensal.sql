SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [dbo].[VWS_itulo_Extrato_Mensal] AS
WITH T AS (
SELECT   
  T.UnidadeID,
  YEAR( T.Data-DAY(T.Data)+1) * 100 + MONTH( T.Data-DAY(T.Data)+1) AnoMes,
  SUM(IIF(T.TipoID = 1 AND T.Valor > 0, T.Valor, 0))Entradas_Emi,
  SUM(IIF(T.TipoID = 1 AND T.Valor < 0, T.Valor * -1, 0))Entradas_Bax,
  SUM(IIF(T.TipoID = 1, T.Valor, 0))AReceber,
  SUM(IIF(T.TipoID = 2 AND T.Valor > 0, T.Valor, 0))Saidas_Emi,
  SUM(IIF(T.TipoID = 2 AND T.Valor < 0, T.Valor * -1, 0))Saidas_Bax,
  SUM(IIF(T.TipoID = 2, T.Valor, 0))APagar
FROM VWS_Titulo_Extrato_Diario T
GROUP BY
  T.UnidadeID,
  YEAR( T.Data-DAY(T.Data)+1) * 100 + MONTH( T.Data-DAY(T.Data)+1)) 

SELECT 
  *,
  SUM(T.AReceber) OVER ( PARTITION BY T.UnidadeID ORDER BY T.AnoMes ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)SaldoAreceber,
  SUM(T.APagar) OVER ( PARTITION BY T.UnidadeID ORDER BY T.AnoMes ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)SaldoAPagar
FROM T
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     VIEW [dbo].[VWS_Meses] AS
SELECT   
  M.UnidadeID,
  T1.number +1 ID,
  YEAR( DATEADD(M, T1.number, MIN(DtLancamento-DAY(M.DtLancamento)+1))) ANO,
  MONTH( DATEADD(M, T1.number, MIN(DtLancamento-DAY(M.DtLancamento)+1))) MES,
  YEAR( DATEADD(M, T1.number, MIN(DtLancamento-DAY(M.DtLancamento)+1))) * 100
  +MONTH( DATEADD(M, T1.number, MIN(DtLancamento-DAY(M.DtLancamento)+1))) ANOMES,
  DATEADD(M, T1.number, MIN(DtLancamento-DAY(M.DtLancamento)+1)) DtIni,
  DATEADD(M, T1.number +1, MIN(DtLancamento-DAY(M.DtLancamento))) DtFin
FROM master..spt_values T1, dbo.MovNota0 M
WHERE type='P'
GROUP BY M.UnidadeID, T1.number
HAVING DATEADD(M, T1.number, MIN(DtLancamento-DAY(M.DtLancamento)+1)) <= GETDATE()


GO

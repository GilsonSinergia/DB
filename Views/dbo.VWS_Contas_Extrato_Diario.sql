SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE     VIEW [dbo].[VWS_Contas_Extrato_Diario]
AS
WITH Extrato AS (
SELECT 
  UnidCont0.UnidadeID,
  E.ContaID,
  MR.ChaveTitulo,
  E.MovimentoID,
  DENSE_RANK() OVER (PARTITION BY E.ContaID ORDER BY E.ContaID, E.DtConciliacao, BO.Multiplicador DESC, E.OperacaoID, E.MovimentoID, ISNULL(MR.ChaveTitulo, '00000000000000001'))ID,
  IIF(E.DtConciliacao < CONVERT(DATE, GETDATE()), E.DtConciliacao, CONVERT(DATE, GETDATE()))  Data,
  BO.Operacao +' - '+ISNULL(F.Historico, E.Descricao)Historico,
  ISNULL(MR.ValorPago, E.Valor) * BO.Multiplicador Valor
FROM MovFina2 E
  JOIN dbo.LkpBaix1 BO ON BO.OperacaoID = E.OperacaoID
  JOIN dbo.UnidCont0 ON UnidCont0.ContaID = E.ContaID
  LEFT JOIN dbo.MovFina1 MR ON MR.OperacaoID = E.OperacaoID AND MR.MovimentoID = E.MovimentoID
  LEFT JOIN dbo.Financeiro F ON F.Chave = MR.Chave
WHERE E.StatusID=3
)

SELECT 
  T1.*, 
  SUM(T1.Valor) OVER(PARTITION BY T1.UnidadeID, T1.ContaID ORDER BY T1.ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Saldo
FROM Extrato T1 

GO

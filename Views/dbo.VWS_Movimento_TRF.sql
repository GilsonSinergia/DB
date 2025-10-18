SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   VIEW [dbo].[VWS_Movimento_TRF] 
AS
SELECT 
  CA.OperacaoID, CA.MovimentoID,
  LB.Operacao,
  CA.ContaID, C.Conta,
  P.PortadorID, P.Portador,
  CA.Historico,
  B.DtPagamento, B.DtProjecao, B.DtConciliacao,
  LB.Multiplicador,
  CA.Valor
  
FROM dbo.MovFina2 B
JOIN dbo.MovFina2 DEst 
  ON DEst.OperacaoID = B.ParentOperacaoID 
 AND DEst.MovimentoID = B.ParentMovimentoID
CROSS APPLY (VALUES 
  -- Saque (origem)
  (B.OperacaoID, B.MovimentoID, B.ContaID, 
   'Transferido para ' + (SELECT Conta FROM CadCont0 WHERE ContaID = DEst.ContaID), 
   B.Valor),
  
  -- Depósito (destino)
  (DEst.OperacaoID, DEst.MovimentoID, DEst.ContaID,
   'Recebido de ' + (SELECT Conta FROM CadCont0 WHERE ContaID = B.ContaID),
   DEst.Valor)
) CA (OperacaoID, MovimentoID, ContaID, Historico, Valor)
JOIN dbo.CadCont0 C ON C.ContaID = CA.ContaID
JOIN dbo.CadPort0 P ON P.PortadorID = C.PortadorID
JOIN dbo.LkpBaix1 LB ON LB.OperacaoID = CA.OperacaoID
WHERE B.OperacaoID IN (2,3)
  AND B.ParentMovimentoID IS NOT NULL;
GO

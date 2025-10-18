SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   VIEW [dbo].[VWS_Estoque_Kardex]
AS
SELECT 
  M.UnidadeID,
  MI.ItemID,
  ROW_NUMBER() OVER (PARTITION BY M.UnidadeID, MI.ItemID ORDER BY M.DtMovimento, LkpNota0.Estoque DESC, M.chave)ID,
  M.DtMovimento,  
  M.Chave,  
  CONVERT(DECIMAL(18,2), MI.VL_CustoMedio) CustoMedio,
  SUM(MI.Quantidade*LkpNota0.Estoque) OVER (PARTITION BY M.UnidadeID, MI.ItemID ORDER BY M.DtMovimento, LkpNota0.Estoque DESC ROWS UNBOUNDED PRECEDING) - MI.Quantidade*LkpNota0.Estoque SaldoAnterior,
  IIF(LkpNota0.Estoque=1, MI.Quantidade,0)Entrada,
  IIF(LkpNota0.Estoque=-1, MI.Quantidade,0)Saida,
  SUM(MI.Quantidade*LkpNota0.Estoque * MI.Estoque) OVER (PARTITION BY M.UnidadeID, MI.ItemID ORDER BY M.DtMovimento, LkpNota0.Estoque DESC ROWS UNBOUNDED PRECEDING)Saldo,
  SUM(MI.Quantidade*LkpNota0.Estoque * MI.Estoque * MI.VL_CustoMedio) OVER (PARTITION BY M.UnidadeID, MI.ItemID ORDER BY M.DtMovimento, LkpNota0.Estoque DESC ROWS UNBOUNDED PRECEDING)VL_Saldo
FROM dbo.MovNota0 M
  JOIN dbo.COM_ITE_MOV MI ON MI.Chave = M.Chave
  JOIN dbo.LkpNota0 ON LkpNota0.TipoID = M.TipoID
  JOIN dbo.COM_ITE_UND ON COM_ITE_UND.UnidadeID = MI.UnidadeID AND COM_ITE_UND.ItemID = MI.ItemID
WHERE LkpNota0.Estoque <> 0 
  AND M.StatusID=2
  AND COM_ITE_UND.OrigemID < 7
GO

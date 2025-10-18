SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [dbo].[VWS_Estoque] AS
WITH MovimentoMes AS(
SELECT 
  I.UnidadeID,
  I.ItemID,
  SUM(I.Quantidade * I.Fator * I.Estoque * L.Estoque)Quantidades
FROM dbo.COM_ITE_MOV I
  JOIN dbo.MovNota0 M ON M.UnidadeID = I.UnidadeID AND M.TipoID = I.TipoID AND M.Nota = I.Nota
  JOIN dbo.LkpNota0 L ON L.TipoID = M.TipoID
WHERE M.StatusID=2
  AND M.DtMovimento>CONVERT(DATE,GETDATE()-DAY(GETDATE()))
GROUP BY
  I.UnidadeID,
  I.ItemID
), Pedidos AS (

SELECT 
  I.UnidadeID,
  I.ItemID,
  SUM(I.Quantidade * I.Fator * I.Estoque * L.Estoque)Quantidades
FROM dbo.COM_ITE_MOV I
  JOIN dbo.MovNota0 M ON M.UnidadeID = I.UnidadeID AND M.TipoID = I.TipoID AND M.Nota = I.Nota
  JOIN dbo.LkpNota0 L ON L.TipoID = M.TipoID
WHERE M.StatusID=1
  AND M.TipoID IN (7,8,9,10)
GROUP BY
  I.UnidadeID,
  I.ItemID)

SELECT 
  I.UnidadeID,
  I.ItemID, 
  ISNULL(E.Contabil, 0) Contabil,
  ISNULL(E.Contabil, 0) - ISNULL(P.Quantidades, 0)Disponivel
  
FROM dbo.COM_ITE_UND I
LEFT JOIN dbo.fns_Estoque(GETDATE(), null) E ON E.UnidadeID = I.UnidadeID AND E.ItemID = I.ItemID
LEFT JOIN Pedidos P ON P.UnidadeID = I.UnidadeID AND P.ItemID = I.ItemID

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VWS_TMS_Pedidos]
AS
SELECT 
  MovNota0.Chave,
  MovNota0.DtLancamento,
  MovNota0.DtMovimento,
  MovNota0.PessoaID,
  lkpnota1.Status,
  VL_Total,
  SUM(dbo.COM_ITE_PRd.PsBruto * dbo.COM_ITE_MOV.Quantidade)PsBruto,
  SUM(dbo.COM_ITE_PRD.PsLiquido * dbo.COM_ITE_MOV.Quantidade)PsLiquido,
  SUM(dbo.COM_ITE_PRD.Altura * dbo.COM_ITE_PRD.Largura * dbo.COM_ITE_PRD.Profundidade * 300 * dbo.COM_ITE_MOV.Quantidade)Cubagem
FROM  dbo.MovNota0 
  JOIN LkpNota0 ON dbo.LkpNota0.TipoID=MovNota0.TipoID
  JOIN dbo.LkpNota1 ON dbo.LkpNota1.StatusID=MovNota0.StatusID
  JOIN dbo.COM_ITE_MOV ON dbo.COM_ITE_MOV.Chave = dbo.MovNota0.Chave
  JOIN dbo.COM_ITE_PRD ON dbo.COM_ITE_PRD.ItemID=dbo.COM_ITE_MOV.ItemID
  JOIN dbo.VWS_Movimento_Totais T ON T.Chave = MovNota0.Chave
  LEFT JOIN dbo.TMS_Carregamento_Item ON dbo.TMS_Carregamento_Item.Chave = dbo.MovNota0.Chave 
WHERE MovNota0.StatusID<=1
  AND LkpNota0.Financeiro=1
  AND TMS_Carregamento_Item.CargaID IS NULL
  AND (DtMovimento >= GETDATE()-30 OR lkpnota1.StatusID =1)
GROUP BY
  MovNota0.Chave,
  MovNota0.PessoaID,  
  VL_Total,
  MovNota0.DtLancamento,
  MovNota0.DtMovimento,
  lkpnota1.Status

GO

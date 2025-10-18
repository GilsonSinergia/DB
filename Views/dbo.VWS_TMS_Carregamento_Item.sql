SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VWS_TMS_Carregamento_Item]
AS
SELECT 
  dbo.TMS_Carregamento.UnidadeID,
  dbo.TMS_Carregamento.CargaID,
  TMS_Carregamento_Item.Ordem,
  TMS_Carregamento_Item.Chave,
  MovNota0.PessoaID,
  dbo.MovFisc0.NF,
  dbo.MovFisc0.Serie,
  TMS_Carregamento_Item.OBS,
  SUM(dbo.COM_ITE_PRd.PsBruto * dbo.COM_ITE_MOV.Quantidade)PsBruto,
  SUM(dbo.COM_ITE_PRD.PsLiquido * dbo.COM_ITE_MOV.Quantidade)PsLiquido,
  SUM(dbo.COM_ITE_PRD.Altura * dbo.COM_ITE_PRD.Largura * dbo.COM_ITE_PRD.Profundidade * dbo.COM_ITE_MOV.Quantidade)Cubagem
FROM dbo.TMS_Carregamento
  JOIN dbo.TMS_Carregamento_Item
    ON dbo.TMS_Carregamento.UnidadeID = dbo.TMS_Carregamento_Item.UnidadeID 
   AND dbo.TMS_Carregamento.CargaID = dbo.TMS_Carregamento_Item.CargaID
  JOIN dbo.MovNota0 ON dbo.TMS_Carregamento_Item.Chave = dbo.MovNota0.Chave 
  JOIN dbo.COM_ITE_MOV ON dbo.COM_ITE_MOV.Chave = dbo.MovNota0.Chave
  JOIN dbo.COM_ITE_PRD ON dbo.COM_ITE_PRD.ItemID=dbo.COM_ITE_MOV.ItemID
  LEFT JOIN dbo.MovFisc0 ON dbo.MovFisc0.Chave=dbo.MovNota0.Chave
GROUP BY 
  dbo.TMS_Carregamento.UnidadeID,
  dbo.TMS_Carregamento.CargaID,
  TMS_Carregamento_Item.Chave,
  TMS_Carregamento_Item.Ordem,
  MovNota0.PessoaID,
  dbo.MovFisc0.NF,
  dbo.MovFisc0.Serie,
  TMS_Carregamento_Item.OBS  

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   VIEW [dbo].[VWS_Itens]
AS
SELECT DISTINCT
  COM_ITE_UND.UnidadeID,
  COM_ITE_CAD.ItemID,
  COM_ITE_UND.Localizacao,
  Referencia.Referencia,
  EAN.Referencia Barras,
  COM_ITE_CAD.DtCadastro,
  FIS_NCM.GFID,
  COM_ITE_CAD.Item,
  COM_ITE_CAD.NCM,
  COM_ITE_CAD.Cest,
  dbo.COM_ITE_PRD.Descricao Aplicacao,
  COM_ITE_CAD.Similaridade,
  dbo.COM_ITE_GRP.GrupoID,  
  dbo.COM_ITE_GRP.Grupo,
  dbo.COM_ITE_LIN.LinhaID, 
  dbo.COM_ITE_LIN.Linha,
  COM_ITE_Marca.MarcaID,
  COM_ITE_Marca.Marca,

  COM_ITE_MED.MedidaID,
  COM_ITE_MED.UN,
  COM_ITE_MED.UsaBalanca,
  COM_ITE_MED.Decimal,
  COM_ITE_UND.Estoque,
  COM_ITE_PRD.PsLiquido,
  COM_ITE_PRD.PsBruto,
  COM_ITE_PRD.Altura,
  COM_ITE_PRD.Largura,
  COM_ITE_PRD.Profundidade,
  COM_ITE_PRD.Altura * COM_ITE_PRD.Largura * COM_ITE_PRD.Profundidade * 300 M3,  
  COM_ITE_PRD.Fracionamento,
  COM_ITE_PRD.FotoID,
  COM_ITE_PRD.Descricao,
  
  COM_ITE_UND.VL_Sugerido,
  CM.Valor CM,
  CB.Valor CB,
  PC_Venda.Valor VL_Venda,
  COM_ITE_UND.Ativo,
  COM_ITE_UND.DestinoID,
  COM_ITE_UND.Lucro,
  COM_ITE_UND.EstMinimo,
  COM_ITE_UND.EstMaximo,
  ISNULL(VWS_Estoque.Disponivel,0)Disponivel,
  ISNULL(VWS_Estoque.Contabil,0)Contabil
FROM COM_ITE_CAD
  JOIN dbo.FIS_NCM ON FIS_NCM.NCM = COM_ITE_CAD.NCM
  JOIN COM_ITE_PRD ON COM_ITE_PRD.ItemID=COM_ITE_CAD.ItemID
  JOIN COM_ITE_MED ON COM_ITE_MED.MedidaID=COM_ITE_PRD.MedidaID  
  JOIN dbo.COM_ITE_LIN ON COM_ITE_LIN.LinhaID=COM_ITE_PRD.LinhaID  
  JOIN dbo.COM_ITE_GRP ON dbo.COM_ITE_GRP.GrupoID=COM_ITE_PRD.GrupoID
  JOIN COM_ITE_UND     ON COM_ITE_UND.ItemID=COM_ITE_CAD.ItemID
  JOIN COM_ITE_PRC CM
    ON CM.UnidadeID=COM_ITE_UND.UnidadeID
   AND CM.ItemID=COM_ITE_UND.ItemID    
   AND CM.PrecoID=1    
  JOIN COM_ITE_PRC CB
    ON CB.UnidadeID=COM_ITE_UND.UnidadeID
   AND CB.ItemID=COM_ITE_UND.ItemID    
   AND CB.PrecoID=2
  JOIN COM_ITE_PRC PC_Venda
    ON PC_Venda.UnidadeID=COM_ITE_UND.UnidadeID
   AND PC_Venda.ItemID=COM_ITE_UND.ItemID    
   AND PC_Venda.PrecoID=3  
  LEFT JOIN COM_ITE_Referencia EAN 
    ON EAN.ItemID=COM_ITE_CAD.ItemID
   AND EAN.ReferenciaID=0 
  LEFT JOIN COM_ITE_Referencia Referencia
    ON Referencia.ItemID=COM_ITE_CAD.ItemID
   AND Referencia.ReferenciaID=1 
  LEFT JOIN COM_ITE_Referencia Digito
    ON Digito.ItemID=COM_ITE_CAD.ItemID
   AND Digito.ReferenciaID=2
  LEFT JOIN COM_ITE_Marca
    ON COM_ITE_Marca.MarcaID=COM_ITE_PRD.MarcaID
  LEFT JOIN VWS_Estoque
    ON VWS_Estoque.UnidadeID = COM_ITE_UND.UnidadeID
   AND VWS_Estoque.ItemID = COM_ITE_UND.ItemID 





GO

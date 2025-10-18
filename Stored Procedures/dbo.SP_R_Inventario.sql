SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE     PROCEDURE [dbo].[SP_R_Inventario]
  @UnidadeID INT=1,
  @P INT=1,
  @Data      DATETIME= '20221019',
  @GrupoID   INT = NULL,
  @LinhaID   INT = NULL,
  @DtCadastro DATETIME = NULL
AS  


SELECT 
  I.NCM NCMID,
  N.Descricao NCM,
  GF.Grupo,
  I.ItemID,
  I.Item,  
  dbo.COM_ITE_MED.MedidaID,
  UN,
  E.Contabil Quantidade,
  P.VL_Custo VL_Unitario,
  E.Contabil * P.VL_Custo VL_Total
FROM dbo.COM_ITE_CAD I  
  JOIN dbo.COM_ITE_PRD PRD ON PRD.ItemID = I.ItemID
  JOIN dbo.COM_ITE_UND U ON U.ItemID = I.ItemID
  JOIN dbo.FIS_NCM ON FIS_NCM.NCM = I.NCM
  JOIN dbo.FIS_ITE_GRP_CAD GF ON GF.GFID = FIS_NCM.GFID
  JOIN dbo.COM_ITE_MED ON COM_ITE_MED.MedidaID = PRD.MedidaID
  LEFT JOIN dbo.FIS_NCM N ON N.NCM = I.NCM
  JOIN dbo.fns_Estoque(@Data, NULL)  E ON E.UnidadeID = U.UnidadeID AND E.ItemID = U.ItemID
  JOIN dbo.FIS_Inventario P ON P.UnidadeID = U.UnidadeID AND P.ItemID = U.ItemID AND P.Competencia=YEAR(@Data)*100+MONTH(@Data)
WHERE U.OrigemID NOT IN (7,9)
  --AND E.Contabil > 0
  AND U.UnidadeID = @UnidadeID
  AND (@GrupoID IS NULL OR PRD.GrupoID = @GrupoID)
  AND (@LinhaID IS NULL OR PRD.LinhaID = @LinhaID)
  AND (@DtCadastro IS NULL OR I.DtCadastro >= @DtCadastro)
ORDER BY I.NCM, GF.Grupo, I.Item


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE 
[dbo].[SPs_BuscaProduto] 
@BuscaID INT, 
@UnidadeID INT,
@ItemID INT, 
@Item VARCHAR(100),
@ReferenciaID INT, 
@PromocaoID INT, 
@PrecoID INT, 
@PessoaID INT, 
@Exceto CHAR(14)

AS
SELECT
  I.ItemID,
  I.Item,
  Referencia.Referencia,
  COM_ITE_GRP.Grupo,
  COM_ITE_MED.MedidaID,
  COM_ITE_MED.UN,
  COM_ITE_PRD.PsLiquido,
  COM_ITE_PRD.PsBruto,
  0 OrigemID,
  COM_ITE_UND.Localizacao,
  I.Similaridade,
  Preco.MaxComissao,
  Preco.VL_Sugerido,
  Preco.MaxDesconto,
  Preco.EmPromocao,
  Preco.PromocaoID,
  Preco.Promocao_Cor,
  CM.Valor CM,
  CB.Valor CB,
  Preco.Preco,
  ISNULL(E.Disponivel,0)Disponivel,
  ISNULL(E.Contabil, 0) Contabil
FROM dbo.COM_ITE_CAD I
  JOIN dbo.COM_ITE_PRD ON COM_ITE_PRD.ItemID = I.ItemID
  JOIN dbo.fns_Preco(@UnidadeID, DEFAULT, @PrecoID, @PessoaID)  Preco ON Preco.ItemID=I.ItemID
  JOIN dbo.COM_ITE_MED     ON COM_ITE_MED.MedidaID=COM_ITE_PRD.MedidaID  
  JOIN dbo.COM_ITE_LIN  ON COM_ITE_LIN.LinhaID=COM_ITE_PRD.LinhaID  
  JOIN dbo.COM_ITE_GRP  ON dbo.COM_ITE_GRP.GrupoID=COM_ITE_PRD.GrupoID
  JOIN COM_ITE_UND  ON COM_ITE_UND.ItemID=I.ItemID
  JOIN COM_ITE_PRC CM
    ON CM.UnidadeID=COM_ITE_UND.UnidadeID
   AND CM.ItemID=COM_ITE_UND.ItemID    
   AND CM.PrecoID=1    
  JOIN COM_ITE_PRC CB
    ON CB.UnidadeID=COM_ITE_UND.UnidadeID
   AND CB.ItemID=COM_ITE_UND.ItemID    
   AND CB.PrecoID=2
  JOIN dbo.VWS_Estoque E ON E.UnidadeID = COM_ITE_UND.UnidadeID AND E.ItemID = COM_ITE_UND.ItemID
  LEFT JOIN COM_ITE_Referencia Referencia
    ON Referencia.ItemID=I.ItemID
   AND Referencia.ReferenciaID=1 
WHERE (COM_ITE_UND.UnidadeID =@UnidadeID )
  AND (COM_ITE_UND.Ativo=1)
  AND ((@BuscaID = 1 AND I.ItemID = @ItemID)
  OR  (@BuscaID = 2 AND  I.Item LIKE '%'+@Item+'%')
  OR  (@BuscaID = 3 AND I.ItemID IN (SELECT ItemID
										   FROM COM_ITE_Referencia
										     JOIN COM_ITE_Referencia_CAD
											   ON COM_ITE_Referencia_CAD.ReferenciaID=COM_ITE_Referencia.ReferenciaID
											WHERE COM_ITE_Referencia_CAD.Pesquisa=1
										      AND COM_ITE_Referencia.ReferenciaID = @ReferenciaID
											  AND COM_ITE_Referencia.Referencia LIKE '%'+@Item+'%')
												   )
												   
		)
		
   AND (@PromocaoID = 0 OR Preco.PromocaoID =@PromocaoID)


GO

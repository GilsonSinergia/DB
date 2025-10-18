SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_R_TabelaPrecos]
  @UnidadeID   INT,
  @LinhaID     BIGINT = NULL,
  @Grupo       VARCHAR(12) = NULL,
  @Ordem       VARCHAR(20) = NULL,  
 
  @OcutarPreco       BIT = 1,  
  @OcutarSemEstoque  INT = 2,  
  @ExibirItemSemPreco BIT = 0, 
  @Preco1      INT = 1,
  @Preco2      INT = NULL,
  
  @Preco3      INT = NULL,
  @Preco4      INT = NULL   
AS


SELECT 
  VWS_ITENS.ItemID,
  VWS_ITENS.ItemID Codigo,
  VWS_ITENS.Item, 
  VWS_ITENS.Aplicacao, 
  VWS_ITENS.Referencia,
  VWS_ITENS.Grupo,
  VWS_ITENS.Linha,
  VWS_ITENS.Marca,
  VWS_ITENS.Disponivel Estoque,
  CASE 
    WHEN @OcutarPreco = 0 AND VWS_ITENS.Disponivel <= 0 THEN NULL
    ELSE Prec1.Preco
  END  Preco1,

  CASE 
    WHEN @OcutarPreco = 0 AND VWS_ITENS.Disponivel <= 0 THEN NULL
    ELSE Prec2.Preco
  END Preco2,

  CASE 
    WHEN @OcutarPreco = 0 AND VWS_ITENS.Disponivel <= 0 THEN NULL
    ELSE Prec3.Preco
  END Preco3,

  CASE 
    WHEN @OcutarPreco = 0 AND VWS_ITENS.Disponivel <= 0 THEN NULL
    ELSE Prec4.Preco
  END Preco4
FROM VWS_ITENS 
  JOIN FNS_Preco(@UnidadeID,DEFAULT,DEFAULT,DEFAULT) Prec1
    ON Prec1.UnidadeID = VWS_ITENS.UnidadeID
   AND Prec1.ItemID = VWS_ITENS.ItemID
   AND Prec1.PrecoID = @Preco1
  LEFT JOIN FNS_Preco(@UnidadeID,DEFAULT,DEFAULT,DEFAULT) Prec2
    ON Prec2.UnidadeID = VWS_ITENS.UnidadeID
   AND Prec2.ItemID = VWS_ITENS.ItemID
   AND Prec2.PrecoID = @Preco2 
  
  LEFT JOIN FNS_Preco(@UnidadeID,DEFAULT,DEFAULT,DEFAULT) Prec3
    ON Prec3.UnidadeID = VWS_ITENS.UnidadeID
   AND Prec3.ItemID = VWS_ITENS.ItemID
   AND Prec3.PrecoID = @Preco3 

  LEFT JOIN FNS_Preco(@UnidadeID,DEFAULT,DEFAULT,DEFAULT) Prec4
    ON Prec4.UnidadeID = VWS_ITENS.UnidadeID
   AND Prec4.ItemID = VWS_ITENS.ItemId
   AND Prec4.PrecoID = @Preco4
    
WHERE (VWS_ITENS.UnidadeID = @UnidadeID)
  AND VWS_ITENS.Ativo=1 
  AND (@LinhaID  IS NULL OR VWS_ITENS.LinhaID         = @LinhaID  )
  AND (@Grupo    IS NULL OR VWS_ITENS.GrupoID  =  @Grupo)
  AND (@OcutarSemEstoque = 0 OR  VWS_ITENS.Disponivel >  0 )
  AND (@ExibirItemSemPreco = 1 OR  ISNULL(Prec1.Preco,0)+ISNULL(Prec2.Preco,0)+ISNULL(Prec3.Preco,0)+ISNULL(Prec4.Preco,0)>0)
GO

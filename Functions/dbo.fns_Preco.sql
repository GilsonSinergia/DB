SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [dbo].[fns_Preco]
  (@UnidadeID INT, @ItemID INT, @PrecoID INT, @PessoaID INT)
  RETURNS TABLE
AS
RETURN(

WITH CTE_Promocao AS (
SELECT 
  P.UnidadeID,
  P.PromocaoID,
  C.Promocao,
  C.Cor,
  C.DtInicio,
  C.DtTermino,
  C.PrecoID, 
  P.ItemID, 
  P.Unitario,
  P.Desconto, 
  P.Comissao
FROM dbo.COM_ITE_Promocao P
  JOIN dbo.COM_Promocao C ON C.PromocaoID = P.PromocaoID
WHERE GETDATE() BETWEEN C.DtInicio AND C.DtTermino),

CTE_Tabela AS (
SELECT 
  P.UnidadeID,
  P.PrecoID,
  P.ItemID,   
  P.Valor
FROM dbo.COM_ITE_PRC P 
Union
SELECT 
  P.UnidadeID,
  C.PrecoID,
  P.ItemID,    
  CONVERT(MONEY, P.Valor * IIF(C.TipoID=1, 100 + C.Margem, 100 - C.Margem) / 100) Valor
FROM dbo.COM_PRC_CAD C  
  JOIN dbo.COM_ITE_PRC P ON P.PrecoID = C.Parent
WHERE C.TipoID>0
),
CTE_Desconto_Comissao AS (
SELECT   
  C.Ativo,
  P.UnidadeID,
  P.ItemID,
  C.PrecoID, 
  C.Nome,
  CASE 
     WHEN PRM.Desconto IS NOT NULL     THEN PRM.Desconto
     WHEN I.MaxDesconto > 0            THEN I.MaxDesconto
     WHEN COM_ITE_LIN.MaxDesconto > 0  THEN COM_ITE_LIN.MaxDesconto
     WHEN COM_ITE_GRP.MaxDesconto  > 0 THEN C.MaxDesconto
	 WHEN A.Desconto  > 0              THEN A.Desconto
     ELSE C.MaxDesconto 
   END  MaxDesconto,
   CASE 
     WHEN PRM.Comissao IS NOT NULL     THEN PRM.Comissao
     WHEN I.MaxComissao > 0            THEN I.MaxComissao
     WHEN COM_ITE_LIN.MaxComissao > 0  THEN COM_ITE_LIN.MaxComissao
     WHEN COM_ITE_GRP.MaxComissao  > 0 THEN C.MaxComissao
	 WHEN A.Comissao  > 0              THEN A.Comissao
     ELSE C.MaxComissao 
   END  MaxComissao,  
  I.VL_Sugerido,
  C.SomarMargem,
  ISNULL(PRM.Unitario, P.Valor)VL_Tabela,
  IIF(PRM.Unitario IS NOT NULL, 1, 0) EmPromocao,
  PRM.PromocaoID,
  PRM.Promocao,
  PRM.DtInicio Promocao_Inicio,
  PRM.DtTermino Promocao_Termino, 
  PRM.Cor Promocao_Cor 
FROM CTE_Tabela P
  JOIN dbo.COM_ITE_PRD ON COM_ITE_PRD.ItemID = P.ItemID
  JOIN dbo.COM_ITE_LIN ON COM_ITE_LIN.LinhaID = COM_ITE_PRD.LinhaID
  JOIN dbo.COM_ITE_GRP ON COM_ITE_GRP.GrupoID = COM_ITE_PRD.GrupoID
  JOIN dbo.COM_PRC_CAD C ON C.PrecoID = P.PrecoID
  JOIN dbo.COM_ITE_UND I ON I.UnidadeID = P.UnidadeID AND I.ItemID = P.ItemID
  LEFT JOIN CTE_Promocao PRM 
    ON PRM.UnidadeID = P.UnidadeID 
   AND PRM.PrecoID = C.PrecoID
   AND PRM.ItemID = P.ItemID
 LEFT JOIN dbo.PesClie0 PC ON PC.PessoaID = @PessoaID
 LEFT JOIN dbo.CadArea0 A  ON A.AreaID = PC.AreaID
   )

SELECT 
  *,
  P.VL_Sugerido PrecoMinimo,
  CONVERT(MONEY, IIF(P.SomarMargem=1, P.VL_Tabela / ((100)/100.00), P.VL_Tabela)) Preco
FROM CTE_Desconto_Comissao P
WHERE (@ItemID    IS NULL OR  P.ItemID=@ItemID)
  AND (@UnidadeID IS NULL OR P.UnidadeID=@UnidadeID)
  AND (@PrecoID   IS NULL OR P.PrecoID=@PrecoID)
)
GO

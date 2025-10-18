SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- ================================================================
-- SP_LiberaEstoque - VERSÃO CORRIGIDA FINAL
-- Elimina dízimas + threshold para diferenças microscópicas
-- ================================================================

CREATE PROCEDURE [dbo].[SP_LiberaEstoque] 
  @Chave CHAR(14),
  @Data DATE
AS
WITH CTE_Base AS (
SELECT 
  MI.UnidadeID,
  MI.Chave,
  MI.Seq,
  MI.ItemID,
  I.Item,
  MI.VL_Liquido / MI.Quantidade AS VL_Item,
  MI.VL_Frete / MI.Quantidade AS VL_Frete,
  MI.VL_Seguro / MI.Quantidade AS VL_Seguro,
  MI.VL_Outro / MI.Quantidade AS VL_Outro,
  MI.VL_Operacional / MI.Quantidade AS VL_Operacional,
  MI.VL_Anexo / MI.Quantidade AS VL_Anexo,
  MI.VL_IPI / MI.Quantidade AS VL_IPI,
  IIF(FIS_Unidade.RegimeID > 0, MI.Vl_ICMS / MI.Quantidade, 0) AS VL_ICMS,
  MI.Vl_ICMSSUB / MI.Quantidade AS VL_ICMSSub,
  IIF(FIS_Unidade.RegimeID = 3, MI.Vl_PIS / MI.Quantidade, 0) AS VL_PIS,
  IIF(FIS_Unidade.RegimeID = 3, MI.VL_COFINS / MI.Quantidade, 0) AS VL_COFINS,
  MI.VL_CustoAquisicao AS VL_CustoAquisicao,
  ISNULL(E.Contabil, 0.000) AS QT_Estoque,
  ISNULL(P.Valor, 0.00) AS VL_Estoque,
  ISNULL(P.Valor * E.Contabil, 0) AS VL_CustoEstoque,
  MI.Quantidade AS QT_Compra,  
  MI.VL_CustoAquisicao / MI.Quantidade AS VL_Compra
FROM dbo.VWS_Movimento_Item MI
  JOIN dbo.COM_ITE_CAD I ON I.ItemID = MI.ItemID
  JOIN dbo.VWS_Unidades U ON U.UnidadeID = MI.UnidadeID
  JOIN dbo.FIS_Unidade ON FIS_Unidade.UnidadeID = U.UnidadeID
  JOIN dbo.COM_ITE_PRC P ON P.UnidadeID = MI.UnidadeID AND P.ItemID = MI.ItemID AND P.PrecoID = 1
  LEFT JOIN dbo.fns_Estoque(GETDATE(), NULL) E ON E.UnidadeID = MI.UnidadeID AND E.ItemID = MI.ItemID
WHERE MI.Chave = @Chave AND MI.Quantidade > 0
),
CTE_CustoMedio AS (
SELECT 
  A.*,
  -- ================================================================
  -- CORREÇÃO COMPLETA:
  -- 1. Usa valor total (elimina dízimas dos 0,98 centavos)
  -- 2. Threshold no custo unitário (elimina diferenças microscópicas)
  -- ================================================================
  CASE 
    WHEN ISNULL(A.QT_Estoque + A.QT_Compra, 0) = 0 THEN
      A.VL_Estoque  -- Preserva custo histórico quando sem estoque
    WHEN ABS((A.VL_CustoAquisicao + A.VL_CustoEstoque) / (A.QT_Compra + A.QT_Estoque) - A.VL_Estoque) < 0.01 THEN
      A.VL_Estoque  -- Mantém custo atual se diferença unitária < 1 centavo
    ELSE 
      (A.VL_CustoAquisicao + A.VL_CustoEstoque) / (A.QT_Compra + A.QT_Estoque)
  END AS VL_CustoMedio
FROM CTE_Base A
)
SELECT   
  A.*,   
  FIS_Unidade.PIS + FIS_Unidade.COFINS + FIS_Unidade.CSLL + FIS_Unidade.IRPJ 
    + IIF(FIS_Unidade.RegimeID = 0 AND A.VL_ICMSSub = 0, FIS_Unidade.ICMS, 0) AS Tributos,
  U.Comercial,
  I.Lucro,
  ABS(
    100 - FIS_Unidade.PIS - FIS_Unidade.COFINS - FIS_Unidade.CSLL - FIS_Unidade.IRPJ 
    - IIF(FIS_Unidade.RegimeID = 0 AND A.VL_ICMSSub = 0, FIS_Unidade.ICMS, 0)
    - U.Comercial - I.Lucro
  ) AS Markup,
  I.VL_Sugerido AS VL_OLD_Sugerido,
  CONVERT(DECIMAL(18, 2), A.VL_CustoMedio / (
    (100 - FIS_Unidade.PIS - FIS_Unidade.COFINS - FIS_Unidade.CSLL - FIS_Unidade.IRPJ 
     - IIF(FIS_Unidade.RegimeID = 0 AND A.VL_ICMSSub = 0, FIS_Unidade.ICMS, 0) 
     - U.Comercial - I.Lucro) / 100)) AS VL_Sugerido
FROM CTE_CustoMedio A
  JOIN dbo.CadUnid0 U ON U.UnidadeID = A.UnidadeID
  JOIN dbo.COM_ITE_UND I ON I.UnidadeID = A.UnidadeID AND I.ItemID = A.ItemID
  JOIN FIS_Unidade ON FIS_Unidade.UnidadeID = U.UnidadeID 
ORDER BY A.Seq;

-- ================================================================
-- CORREÇÕES APLICADAS:
-- 1. DÍZIMAS: Usa VL_CustoAquisicao total ao invés de multiplicação
-- 2. THRESHOLD: Ignora diferenças < R$ 0,01 (elimina ruído microscópico)  
-- 3. LIMPEZA: Removido campo de depuração SUM() OVER
-- 4. ESTABILIDADE: Produtos iguais mantêm mesmo custo médio
-- ================================================================
GO

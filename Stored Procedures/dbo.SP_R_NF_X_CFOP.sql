SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SP_R_NF_X_CFOP]
  @UnidadeID Int,
  @DtIni DateTime,
  @DtFin DATETIME,
  @Modo int =1
AS  
DECLARE
  @T TABLE (UnidadrID INT)
  
INSERT INTO @T(UnidadrID) SELECT UnidadeID FROM dbo.CadUnid0 WHERE Ativa=1 AND (@UnidadeID IS NULL OR POWER(2, UnidadeID)& @UnidadeID <>0)

SELECT   
  M.OperacaoID,
  M.Operacao,
  M.SubOperacao,
  M.DtMovimento,
  F.Chave,
  F.Serie,
  F.NF,
  I.Seq,
  I.ItemID,
  IC.Item,
  IC.NCM,
  I.VL_NF,
  I.CFOP,
  I.CST_ICMS,
  I.BC_ICMS,
  I.Aliq_ICMS ICMS,
  I.VL_ICMS,
  I.BC_ICMSSub,
  I.Aliq_ICMSSub ICMSSUB,
  I.VL_ICMSSub,
  IIF(I.VL_ICMSSub>0, I.VL_ICMSSub-I.VL_ICMS,0)VL_ICMSRetido,
  I.CST_IPI,
  I.BC_IPI,
  I.Aliq_IPI,
  I.VL_IPI,
  I.CST_PIS,
  I.BC_PIS,
  I.Aliq_PIS,
  I.VL_PIS,
  I.CST_COFINS,
  I.BC_COFINS,
  I.ALIQ_COFINS,
  I.VL_COFINS
INTO #T
FROM dbo.VWS_Movimento M
  JOIN dbo.MovFisc0 F ON F.Chave = M.Chave
  JOIN dbo.VWS_Movimento_Item I ON I.Chave = F.Chave
  JOIN dbo.COM_ITE_CAD IC ON IC.ItemID = I.ItemID
  JOIN @T T1 ON T1.UnidadrID=M.UnidadeID
WHERE M.StatusID=2
  AND M.UnidadeID=3
  AND M.DtMovimento BETWEEN @DtIni AND @DtFin

SELECT 
  T.Operacao,
  T.SubOperacao, T.CFOP,
  SUM(T.VL_NF)VL_NF,
  SUM(T.BC_ICMS)BC_ICMS,
  SUM(T.VL_ICMS)VL_ICMS,
  SUM(T.BC_ICMSSub)BC_ICMSSub,
  SUM(T.VL_ICMSSub)VL_ICMSSub,
  SUM(T.BC_IPI)BC_IPI,
  SUM(T.VL_IPI)VL_IPI,
  SUM(T.BC_PIS)BC_PIS,
  SUM(T.VL_PIS)VL_PIS,
  SUM(T.BC_COFINS)BC_COFINS,
  SUM(T.VL_COFINS)VL_COFINS
FROM #T T
GROUP BY T.OperacaoID, T.Operacao,T.SubOperacao, T.CFOP
ORDER BY T.OperacaoID, T.SubOperacao, T.CFOP
GO

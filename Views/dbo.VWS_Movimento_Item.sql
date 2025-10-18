SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE   VIEW [dbo].[VWS_Movimento_Item]  
AS

WITH CTE_DIFAL AS (
	SELECT
		M.Chave,
		IIF(P.AtividadesID = 0 AND FU.RegimeID > 0 AND CP.UFID <> CU.UFID AND M.TipoID IN (7,8,9), 1, 0) AS AplicaDIFAL
	FROM dbo.MovNota0 M
	  JOIN dbo.VWS_Pessoas P ON P.PessoaID = M.PessoaID
	  JOIN dbo.VWS_Unidades U ON U.UnidadeID = M.UnidadeID
	  JOIN dbo.FIS_Unidade FU ON FU.UnidadeID = M.UnidadeID
	  JOIN dbo.PesEnde0 EP ON EP.PessoaID = P.PessoaID AND EP.TipoID = 0
	  JOIN dbo.PesEnde0 EU ON EU.PessoaID = U.PessoaID AND EU.TipoID = 0
	  JOIN dbo.CadCida0 CP ON CP.CidadeID = EP.CidadeID
	  JOIN dbo.CadCida0 CU ON CU.CidadeID = EU.CidadeID
),

CTE_CustoContabil AS (
	SELECT
		MI.Chave,
		MI.Seq,
		IIF(L.Estoque=1,
			MI.VL_Liquido + MI.VL_Frete + MI.VL_Seguro + MI.VL_Outro + MI.Vl_IPI + MI.Vl_ICMSSUB + MI.VL_Operacional
			- IIF(FU.Atividade & POWER(2,0) <> 0, MI.Vl_IPI , 0)
			- IIF(FU.RegimeID>1 AND MI.BC_ICMSSub=0, MI.Vl_ICMS, 0)
			- IIF(FU.RegimeID=3, MI.Vl_PIS, 0)
			- IIF(FU.RegimeID=3, MI.Vl_COFINS, 0),
			MI.Quantidade * MI.VL_CustoMedio) AS VL_BaseCusto
	FROM dbo.COM_ITE_MOV MI
	  JOIN dbo.MovNota0 M ON M.Chave = MI.Chave
	  JOIN dbo.FIS_Unidade FU ON FU.UnidadeID = M.UnidadeID
	  JOIN dbo.LkpNota0 L ON L.TipoID = M.TipoID
)

SELECT 
	MI.UnidadeID,
	MI.Chave,
	MI.Seq,
	MI.ItemID,
	MI.VL_Pedido,
	UM.UN AS UM,
	MI.Quantidade,
	MI.VL_Unitario,
	MI.VL_Item,
	MI.Desconto,
	MI.VL_Desconto,
	MI.VL_Liquido,
	MI.VL_Frete,
	MI.VL_Seguro,
	MI.VL_Outro,
	MI.VL_Operacional,
	MI.VL_Anexo,
	MI.CFOP,
	MI.CST_IPI,
	MI.BC_IPI,
	MI.Aliq_IPI,
	MI.Vl_IPI,
	MI.CST_ICMS,
	MI.Modalidade_ICMS,
	MI.BC_ICMS,
	MI.Aliq_ICMS,
	MI.Vl_ICMS,
	MI.Aliq_FCP,
	MI.Modalidade_ICMSSub,
	MI.MVA,
	MI.BC_ICMSSub,
	MI.Aliq_ICMSSub,
	MI.Vl_ICMSSUB,
	MI.CST_PIS,
	MI.BC_PIS,
	MI.Aliq_PIS,
	MI.Vl_PIS,
	MI.CST_COFINS,
	MI.BC_COFINS,
	MI.Aliq_COFINS,
	MI.Vl_COFINS,
	MI.BC_ISS,
	MI.Aliq_ISS,
	MI.VL_ISS,
	FU.Atividade,
	FU.RegimeID,

	-- Peso e Volume
	CONVERT(DECIMAL(18,6), COM_ITE_PRD.PsBruto * MI.Quantidade) AS Ps_Bruto,
	CONVERT(DECIMAL(18,6), COM_ITE_PRD.PsLiquido * MI.Quantidade) AS Ps_Liquido,
	CONVERT(DECIMAL(18,6), COM_ITE_PRD.Altura * COM_ITE_PRD.Largura * COM_ITE_PRD.Profundidade * MI.Quantidade) AS Volume,

	-- Comissão
	MI.Comissao,
	CONVERT(DECIMAL(18,6), MI.Comissao * MI.VL_Liquido / 100) AS VL_Comissao,

	-- DIFAL
	MI.BC_ICMS * DIF.AplicaDIFAL AS DIFAL_BC_FCP,
	MI.Aliq_FCP * DIF.AplicaDIFAL AS DIFAL_Aliq_FCP,
	CONVERT(DECIMAL(18,6), MI.BC_ICMS * MI.Aliq_FCP / 100 * DIF.AplicaDIFAL) AS DIFAL_VL_FCP,
	CONVERT(DECIMAL(18,6), MI.BC_ICMS * DIF.AplicaDIFAL) AS DIFAL_BC_ICMSDest,
	MI.Aliq_ICMS * DIF.AplicaDIFAL AS DIFAL_Aliq_ICMSInter,
	MI.Aliq_ICMSSub * DIF.AplicaDIFAL AS DIFAL_Aliq_ICMSDest,
	100.00 * DIF.AplicaDIFAL AS DIFAL_Partilha,
	CONVERT(DECIMAL(18,6), MI.BC_ICMS * (MI.Aliq_ICMSSub - MI.Aliq_ICMS) / 100 * DIF.AplicaDIFAL) AS DIFAL_VL_ICMSDest,
	0.00 AS DIFAL_VL_ICMSRemet,

	-- Custo contábil
	CONVERT(DECIMAL(18,6), CC.VL_BaseCusto) AS VL_Estoque,
	CONVERT(DECIMAL(18,6), MI.VL_CustoBruto * MI.Quantidade) AS VL_CustoBruto,
	CONVERT(DECIMAL(18,6), MI.VL_CustoMedio * MI.Quantidade) AS VL_CustoMedio,
	CONVERT(DECIMAL(18,6),
		MI.VL_Liquido + MI.VL_Frete + MI.VL_Seguro + MI.VL_Outro + MI.VL_Operacional + MI.VL_Anexo - CC.VL_BaseCusto
	) AS VL_Margem,

	-- Totais derivados formatados
	CONVERT(DECIMAL(18,6), 
		MI.VL_Operacional + 
		MI.VL_Frete + 
		MI.VL_Seguro + 
		MI.VL_Outro + 
		MI.Vl_IPI
	) AS VL_Despesa,

	CONVERT(DECIMAL(18,6), 
		MI.VL_Liquido + 
		MI.VL_Frete + 
		MI.VL_Seguro + 
		MI.VL_Outro + 
		MI.Vl_IPI + 
		MI.Vl_ICMSSUB + 
		MI.VL_Anexo + 
		MI.VL_Operacional - 
		IIF(FU.RegimeID >= 2, MI.Vl_ICMS, 0) - 
		IIF(FU.RegimeID = 3, MI.Vl_PIS, 0) -
		IIF(FU.RegimeID = 3, MI.Vl_COFINS, 0)
	) AS VL_CustoAquisicao,

	CONVERT(DECIMAL(18,6), 
		MI.VL_Liquido + 
		MI.VL_Frete + 
		MI.VL_Seguro + 
		MI.VL_Outro + 
		MI.Vl_IPI + 
		IIF(MI.CST_ICMS IN (10, 110, 210, 201), MI.Vl_ICMSSUB, 0)
	) AS VL_NF,

	CONVERT(DECIMAL(18,6), 
		MI.VL_Item - 
		MI.VL_Desconto + 
		MI.VL_Frete + 
		MI.VL_Seguro + 
		MI.VL_Outro + 
		MI.Vl_IPI + 
		MI.VL_Operacional + 
		IIF(MI.CST_ICMS IN (10, 110, 210, 201), MI.Vl_ICMSSUB, 0)
	) AS VL_Total

FROM dbo.MovNota0 M
  JOIN dbo.LkpNota0 L ON L.TipoID = M.TipoID
  JOIN dbo.VWS_Unidades U ON U.UnidadeID = M.UnidadeID
  JOIN dbo.VWS_Pessoas P ON P.PessoaID = M.PessoaID
  JOIN dbo.PesEnde0 EU ON EU.PessoaID = U.PessoaID AND EU.TipoID = 0
  JOIN dbo.CadCida0 CU ON CU.CidadeID = EU.CidadeID
  JOIN dbo.PesEnde0 EP ON EP.PessoaID = P.PessoaID AND EP.TipoID = 0
  JOIN dbo.CadCida0 CP ON CP.CidadeID = EP.CidadeID
  JOIN dbo.FIS_Unidade FU ON FU.UnidadeID = M.UnidadeID
  JOIN dbo.COM_ITE_MOV MI ON MI.Chave = M.Chave
  JOIN dbo.COM_ITE_PRD ON COM_ITE_PRD.ItemID = MI.ItemID
  JOIN dbo.COM_ITE_MED UM ON UM.MedidaID = MI.MedidaID
  JOIN CTE_DIFAL DIF ON DIF.Chave = M.Chave
  JOIN CTE_CustoContabil CC ON CC.Chave = MI.Chave AND CC.Seq = MI.Seq
WHERE MI.VL_Item > 0
GO

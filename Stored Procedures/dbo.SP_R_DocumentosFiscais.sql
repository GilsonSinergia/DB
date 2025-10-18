SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[SP_R_DocumentosFiscais]
  @UnidadeID INT = NULL,
  @DtIni DATETIME = '20230301',
  @DtFin DATETIME = '20230331',
  @Modo INT =0
AS  
DECLARE
  @T TABLE (UnidadrID INT)
  
INSERT INTO @T(UnidadrID) SELECT UnidadeID FROM dbo.CadUnid0 WHERE Ativa=1 AND (@UnidadeID IS NULL OR POWER(2, UnidadeID)& @UnidadeID <>0)

IF @Modo=0
SELECT 
		M.OperacaoID,
		m.Operacao,
		m.SubOperacao,
		m.DtMovimento,
		Modelo,
		DFe_MOV.ID CHE_DFe,
		F.Serie,
		F.NF Numero,
		T.VL_NF VL_Documento,
		T.BC_ICMS,
		T.Vl_ICMS,
		T.BC_IPI,
		T.Vl_IPI,
		T.BC_ICMSSub,
		T.Vl_ICMSSUB,
		T.BC_PIS,
		T.Vl_PIS,
		T.BC_COFINS,
		T.Vl_COFINS
FROM dbo.VWS_Movimento m
  JOIN @T u ON u.UnidadrID=m.UnidadeID
	JOIN dbo.MovFisc0 F ON F.Chave = m.Chave
	JOIN dbo.LkpFisc0 ON LkpFisc0.ModeloID = F.ModeloID
	JOIN dbo.VWS_Movimento_Totais T ON T.Chave = F.Chave
	LEFT JOIN dbo.DFe_MOV ON DFe_MOV.Chave = F.Chave
WHERE m.DtMovimento BETWEEN @DtIni AND @DtFin
  AND m.StatusID=2
ORDER BY m.OperacaoID, F.ModeloID, m.DtMovimento
GO

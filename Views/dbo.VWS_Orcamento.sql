SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VWS_Orcamento]
AS
WITH cteMenuNivel(OrcamentoID, Nome, TipoID,  Nivel, NomeCompleto, Codigo, ParenteOrcamentoID)
AS
(
    -- Ancora
    SELECT CadOrca0.OrcamentoID, 
      CadOrca0.Orcamento, 
	  CadOrca0.TipoID,
      1 AS Nivel,
      CAST(CadOrca0.Orcamento AS VARCHAR(255)) AS NomeCompleto,
      CONVERT(VARCHAR(255),STR(DENSE_RANK()OVER (PARTITION BY ParenteOrcamentoID ORDER BY OrcamentoID), 10,0)) Codigo,
      ParenteOrcamentoID
    FROM CadOrca0 
    WHERE ParenteOrcamentoID IS NULL
    
    UNION ALL
    
    -- Parte RECURSIVA
    SELECT 
        CadOrca0.OrcamentoID,
        CadOrca0.Orcamento, 
		CadOrca0.TipoID,
        cteMenuNivel.Nivel + 1 AS Nivel,
        CAST((cteMenuNivel.NomeCompleto + '\' + CadOrca0.Orcamento) AS VARCHAR(255)) NomeCompleto,
        CONVERT(VARCHAR(255), cteMenuNivel.Codigo + '.' +LTRIM(STR( DENSE_RANK()OVER (PARTITION BY CadOrca0.ParenteOrcamentoID ORDER BY CadOrca0.OrcamentoID), 10,0)))Codigo,        
        CadOrca0.ParenteOrcamentoID 
    FROM CadOrca0 
      JOIN cteMenuNivel 
        ON CadOrca0.ParenteOrcamentoID = cteMenuNivel.OrcamentoID
    
    
)
SELECT 
  OrcamentoID,
  Nome Orcamento,
  LTRIM( Codigo) Codigo,
  NomeCompleto, 
  cteMenuNivel.Nivel,
  TipoID,
  CASE cteMenuNivel.TipoID WHEN  1 THEN 'Analítico'  when  2 then 'Dinâmico' ELSE 'Sintético' end Tipo, 
  ParenteOrcamentoID
FROM cteMenuNivel    





GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VWS_NFE_Pagamento]
AS
SELECT
  F.Chave,
  F.DocumentoID,
  Documento,
  SUM(F.Valor)Valor
FROM dbo.MovFina0 F
  JOIN dbo.CadDocu0 ON CadDocu0.DocumentoID = F.DocumentoID
GROUP BY
  F.Chave,
  F.DocumentoID,
  Documento
GO

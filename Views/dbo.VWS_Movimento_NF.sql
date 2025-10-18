SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [dbo].[VWS_Movimento_NF] AS
SELECT 
  F.UnidadeID,
  F.TipoID,
  F.Chave,
  F.DtEmissao,
  LkpFisc0.Sigla +  ' ' +  LkpFisc0.Modelo Modelo,
  F.Serie,
  F.NF,
  F.Consumidor,
  F.NFPropria Emitida
 -- ID
FROM dbo.MovNota0 M
  JOIN dbo.LkpNota0 ON LkpNota0.TipoID = M.TipoID
  JOIN dbo.MovFisc0 F ON F.Chave = M.Chave
  JOIN dbo.LkpFisc0 ON LkpFisc0.ModeloID = F.ModeloID
  LEFT JOIN dbo.DFe_MOV ON DFe_MOV.Chave = F.Chave

GO

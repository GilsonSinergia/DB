SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create View [dbo].[VWS_IBGE_Municipios]
AS
Select
  CadCida0.CidadeID,
  CadCida0.Cidade,
  LkpUF0.UF 
From CadCida0
  JOIN LkpUF0 on LkpUF0.UFID=CadCida0.UFID
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [dbo].[VWS_XNL_MDFe] AS
WITH XMLNAMESPACES (DEFAULT 'http://www.portalfiscal.inf.br/mdfe') 
SELECT 
   X.ID,
   SUBSTRING(ID, 7,14)Emitente,
   SUBSTRING(ID, 21,2)Modelo,
   SUBSTRING(ID, 23,3)Serie,
   SUBSTRING(ID, 26,9)Numero,
   MDFe.value('tpAmb[1]', 'Int')Amboente,
   PR.value('cStat[1]', 'Int')StatusID,
   PR.value('xMotivo[1]', 'Varchar(50)')Status,
   X.XML
FROM DFE_XML X
  CROSS APPLY XML_DOC.nodes('//infMDFe/ide') AS DFes(MDFe) 
  CROSS APPLY xml_DOC.nodes('//protMDFe/infProt') AS Procs(PR) 
WHERE SUBSTRING(ID, 21,2) in(58)
GO

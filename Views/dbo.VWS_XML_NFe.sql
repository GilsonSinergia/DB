SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE   VIEW [dbo].[VWS_XML_NFe]   AS
WITH XMLNAMESPACES (DEFAULT 'http://www.portalfiscal.inf.br/nfe') 
SELECT 
   X.ID,
   DFe_MOV.Chave,
   SUBSTRING(X.ID, 7,14)Emitente,
   SUBSTRING(X.ID, 21,2)Modelo,
   SUBSTRING(X.ID, 23,3)Serie,
   SUBSTRING(X.ID, 26,9)Numero,
   NFE.value('tpAmb[1]', 'Int')Amboente,
   ISNULL(infProt.value('cStat[1]', 'Int'), 0)XM_cStat,
   infProt.value('xMotivo[1]', 'Varchar(50)')XML_Msg,
   X.StatusID,
   X.MSG,
   X.XML_DOC XML   
FROM dbo.DFE_XML X
	LEFT JOIN dbo.DFe_MOV ON DFe_MOV.ID = X.ID
    OUTER APPLY XML_DOC.nodes('//infNFe/ide') AS NFes(NFE) 
	OUTER APPLY XML_DOC.nodes('//protNFe/infProt') AS protNFe(infProt) 
WHERE SUBSTRING(X.ID, 21,2)IN(55,65)
GO

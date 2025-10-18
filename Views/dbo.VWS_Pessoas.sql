SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE    VIEW [dbo].[VWS_Pessoas]  WITH SCHEMABINDING AS

SELECT
  --Identificação  
  dbo.CadPess0.PessoaID, 
  dbo.CadPess0.Nome, 
  dbo.CadPess0.Reduzido, 
  dbo.lkpPess1.Tipo, 
  dbo.CadPess0.Documento,   
  PES_IE.IE Inscricao, 
  IM.Rotulo IM,
  dbo.CadPess0.Naturezas,
  --Contato 
  dbo.PesEnde0.Contato, 
  dbo.PesEnde0.Tel, 
  dbo.PesEnde0.Celular, 
  dbo.PesEnde0.Fax, 
  dbo.CadPess0.EMail, 
  dbo.CadPess0.Web, 
  --Localização
  dbo.PesEnde0.CEP, 
  dbo.PesEnde0.Endereco, 
  dbo.PesEnde0.Numero, 
  dbo.PesEnde0.Proximidade Complemento,
  dbo.PesEnde0.Bairro, 
  dbo.CadCida0.CidadeID, 
  dbo.CadCida0.Cidade, 
  dbo.LkpUF0.UFID, 
  dbo.LkpUF0.UF, 
  dbo.CadPess0.PaisID, 
  dbo.Paises.Pais,
  dbo.PesEnde0.Lat,
  dbo.PesEnde0.Lng,
  dbo.LkpUF0.UF  + ' ' 
  +dbo.CadCida0.Cidade UF_Cidade,  
  
  dbo.PesEnde0.Endereco + ' ' 
  +dbo.PesEnde0.Numero  + ' '
  +dbo.PesEnde0.Bairro Endereco_Bairro,
  
   dbo.LkpUF0.UF  + ' ' 
  +dbo.CadCida0.Cidade  + ' ' 
  +dbo.PesEnde0.Bairro UF_Cidade_Bairro,
  
  
  dbo.PesEnde0.Endereco + ' ' 
  +dbo.PesEnde0.Numero  + ' '
  +dbo.PesEnde0.Bairro  + ' '
  +dbo.CadCida0.Cidade  + ' ' 
  +dbo.LkpUF0.UF   Localidade,
  UPPER(
  dbo.LkpUF0.UF  + ' ' 
  +dbo.CadCida0.Cidade  + ' ' 
  +dbo.PesEnde0.Bairro  + ' '
  +dbo.PesEnde0.Endereco +  ' - '
  +dbo.PesEnde0.Numero)  Localidade_Invertida,
  --Documento Auxiliares
  SUFRAMA.Rotulo SUFRAMA,
  CRC_Contabíl.Rotulo CRC_Contabil,
  --Tributação 
  dbo.LkpUF0.ICMSInt, 
  dbo.LkpUF0.ICMSExt,
  dbo.LkpUF0.MVA, 
  dbo.LkpUF0.FCP, 
  dbo.CadPess0.AtividadesID,
  --Outrtas
  dbo.CadPess0.DtCadastro, 
  dbo.CadPess0.TipoID, 
  dbo.CadPess0.StatusID
FROM dbo.CadPess0 
  JOIN dbo.LkpPess1 ON dbo.CadPess0.TipoID = dbo.lkpPess1.TipoID 
  JOIN dbo.Paises   ON dbo.CadPess0.PaisID = dbo.Paises.PaisID 
  LEFT JOIN dbo.PES_Rotulo  SUFRAMA   ON SUFRAMA.PessoaID=CadPess0.PessoaID AND SUFRAMA.PES_DOC_ID=2
  LEFT JOIN dbo.PES_Rotulo  IM ON IM.PessoaID=CadPess0.PessoaID AND IM.PES_DOC_ID=3
  LEFT JOIN dbo.PES_Rotulo  CRC_Contabíl   ON CRC_Contabíl.PessoaID=CadPess0.PessoaID AND CRC_Contabíl.PES_DOC_ID=4  
  LEFT JOIN dbo.PesEnde0  ON dbo.CadPess0.PessoaID = dbo.PesEnde0.PessoaID  AND PesEnde0.TipoID=0 AND CadPess0.PessoaID > 1
  LEFT JOIN dbo.CadCida0  ON dbo.PesEnde0.CidadeID = dbo.CadCida0.CidadeID 
  LEFT JOIN dbo.LkpUF0    ON dbo.CadCida0.UFID = dbo.LkpUF0.UFID 
  LEFT JOIN dbo.PES_IE 
    ON PES_IE.PessoaID=PesEnde0.PessoaID
   AND PES_IE.UFID=CadCida0.UFID

GO

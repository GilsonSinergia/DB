SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE   VIEW [dbo].[VWS_Unidades]   
AS
SELECT 
  dbo.CadUnid0.UnidadeID, 
  dbo.CadUnid0.Unidade, 
  C.PessoaID ContabilistaID,
  dbo.CadUnid0.Ativa,
  dbo.CadUnid0.Homilogacao,  
  dbo.CadUnid0.Logo,
  dbo.VWS_Pessoas.PessoaID,
  dbo.VWS_Pessoas.Nome, 
  dbo.VWS_Pessoas.Reduzido, 
  dbo.VWS_Pessoas.Tipo, 
  dbo.VWS_Pessoas.Documento, 
  dbo.VWS_Pessoas.Inscricao, 
  dbo.VWS_Pessoas.IM,
  dbo.VWS_Pessoas.SUFRAMA,
  dbo.VWS_Pessoas.CRC_Contabil,
  dbo.VWS_Pessoas.Naturezas, 
  dbo.VWS_Pessoas.Contato, 
  dbo.VWS_Pessoas.Tel, 
  dbo.VWS_Pessoas.Celular, 
  dbo.VWS_Pessoas.Fax, 
  dbo.VWS_Pessoas.EMail, 
  dbo.VWS_Pessoas.Web, 
  dbo.VWS_Pessoas.CEP, 
  dbo.VWS_Pessoas.Endereco, 
  dbo.VWS_Pessoas.Numero, 
  dbo.VWS_Pessoas.Complemento, 
  dbo.VWS_Pessoas.Bairro, 
  dbo.VWS_Pessoas.CidadeID, 
  dbo.VWS_Pessoas.Cidade, 
  dbo.VWS_Pessoas.UFID, 
  dbo.VWS_Pessoas.UF, 
  dbo.VWS_Pessoas.PaisID, 
  dbo.VWS_Pessoas.Pais, 
  dbo.VWS_Pessoas.Localidade,
  dbo.VWS_Pessoas.ICMSInt, 
  dbo.VWS_Pessoas.ICMSExt, 
  dbo.VWS_Pessoas.MVA, 
  dbo.VWS_Pessoas.DtCadastro, 
  dbo.VWS_Pessoas.TipoID, 
  dbo.VWS_Pessoas.StatusID
FROM dbo.CadUnid0 
	LEFT JOIN dbo.UND_PES U ON U.UnidadeID = CadUnid0.UnidadeID AND U.ID=1
	LEFT JOIN dbo.VWS_Pessoas ON VWS_Pessoas.PessoaID = U.PessoaID
	LEFT JOIN dbo.UND_PES C ON C.UnidadeID = CadUnid0.UnidadeID AND C.ID=2
WHERE CadUnid0.Ativa=1
  
  
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE             Procedure [dbo].[SP_R_Pessoas] 
  @PessoaID    int = Null,
  @Naturezas   int = 8,
  @CidadeID    Int = Null,
  @UFID        Int = Null,
  @Ordem       int = 0,
  @StausID     int = Null,
  @DtIni       DateTime = Null,
  @DtFin       DateTime = Null
AS


Select 
  VWS_Pessoas.PessoaID,
  VWS_Pessoas.Documento,
  VWS_Pessoas.Inscricao,
  VWS_Pessoas.Nome,
  VWS_Pessoas.Reduzido,
  
  VWS_Pessoas.Endereco,
  VWS_Pessoas.Numero,
  VWS_Pessoas.CEP,
  VWS_Pessoas.Bairro,
  VWS_Pessoas.Cidade,
  VWS_Pessoas.UF,
  VWS_Pessoas.Naturezas
from VWS_Pessoas
where (@PessoaID IS NULL OR VWS_Pessoas.PessoaID = @PessoaID)
  AND (@CidadeID is Null OR VWS_Pessoas.CidadeID = @CidadeID) 
  AND (@UFID     is Null OR VWS_Pessoas.UFID = @UFID) 
  AND (@DtIni    is Null OR VWS_Pessoas.DtCadastro >= @DtIni)
  AND (@DtFin    is Null OR VWS_Pessoas.DtCadastro <= @DtFin)
  AND (@Naturezas IS Null OR  VWS_Pessoas.Naturezas & @Naturezas <> 0) 
  AND (@StausID  Is Null OR Power(2, VWS_Pessoas.StatusID) & @StausID <> 0)
Order by
  case @Ordem
     when 0 then VWS_Pessoas.Nome
     when 1 then VWS_Pessoas.UF+VWS_Pessoas.Cidade
end
GO

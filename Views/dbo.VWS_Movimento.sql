SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  VIEW [dbo].[VWS_Movimento]   AS
SELECT 
  M.Chave,
  M.UnidadeID,
  M.TipoID,
  LkpNota0.Tipo,
  LkpNota0.Sigla,
  M.Nota Movimento,
  M.PessoaID,
  P.Documento PessoaDocumento,
  P.Nome PessoaNome,
  M.DtMovimento,
  YEAR(M.DtMovimento)Ano,
  YEAR(M.DtMovimento) * 100 + MONTH(M.DtMovimento) Competencia,
  M.DtLancamento,
  M.StatusID,
  Status,
  IIF(Estoque=1, 1, 2)OperacaoID,
  IIF(Estoque=1, 'Entrada', 'Saida')Operacao,
  IIF(M.TipoID IN (1, 7,8,9,10),1, 2)SubOperacaoID,
  IIF(M.TipoID IN (7,8,9,10),'Venda', LkpNota0.Tipo)SubOperacao,
  Estoque,
  Financeiro,
  M.OBS
FROM dbo.MovNota0 M 
  JOIN dbo.LkpNota0 ON LkpNota0.TipoID = M.TipoID
  JOIN dbo.LkpNota1 ON LkpNota1.StatusID = M.StatusID
  JOIN dbo.VWS_Pessoas P ON P.PessoaID = M.PessoaID
GO

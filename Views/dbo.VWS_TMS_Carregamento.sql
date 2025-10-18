SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VWS_TMS_Carregamento]
AS
SELECT 
  dbo.TMS_Carregamento.UnidadeID,
  dbo.TMS_Carregamento.CargaID,
  TMS_Carregamento.DtCarga,
  dbo.CadPess0.Reduzido Vendedor,
  dbo.TMS_Veiculo.Placa,
  dbo.TMS_Veiculo.Tara,
  dbo.TMS_Veiculo.Area,
  TMS_Carregamento.StatusID,
  CASE TMS_Carregamento.StatusID WHEN 0 THEN 'Aberto' WHEN 1 THEN 'Fechado' WHEN 2 then 'Em Rota' ELSE 'Finalizado' end STATUS
FROM dbo.TMS_Carregamento
  JOIN dbo.CadPess0 ON dbo.CadPess0.PessoaID=dbo.TMS_Carregamento.PessoaID
  JOIN dbo.TMS_Veiculo ON  dbo.TMS_Veiculo.VeiculoID=dbo.TMS_Carregamento.VeiculoID

GO

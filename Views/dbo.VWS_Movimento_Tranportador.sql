SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VWS_Movimento_Tranportador]
AS
select 
  T.Chave,
  MP.modFrete TipoFrete,
  T.Documento,
  T.Nome,
  T.IE,
  T.Endereco,
  T.Municipio,
  T.UF,
  T.VeiculoPlaca,
  T.VeiculoUF,
  T.VeiculoRNTRC
from MovTran0 T
  JOIn dbo.MovFisc0 MP ON MP.Chave=T.Chave


GO

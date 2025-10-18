CREATE TABLE [dbo].[MovOrca0]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[OrcamentoID] [tinyint] NOT NULL,
[Rateio] [float] NOT NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[MovOrca0] ADD CONSTRAINT [PK_MovOrca0] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [OrcamentoID])
GO
ALTER TABLE [dbo].[MovOrca0] ADD CONSTRAINT [FK_MovOrca0_CadOrca0] FOREIGN KEY ([OrcamentoID]) REFERENCES [dbo].[CadOrca0] ([OrcamentoID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovOrca0] ADD CONSTRAINT [FK_MovOrca0_Financeiro] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[Financeiro] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO

CREATE TABLE [dbo].[MovCent0]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[CentroID] [int] NOT NULL,
[Rateio] [float] NOT NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[MovCent0] ADD CONSTRAINT [PK_RatNota0] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [CentroID])
GO
ALTER TABLE [dbo].[MovCent0] ADD CONSTRAINT [FK_MovCent0_Financeiro] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[Financeiro] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovCent0] ADD CONSTRAINT [FK_RatNota0_CadRate0] FOREIGN KEY ([CentroID]) REFERENCES [dbo].[CadCent0] ([CentroID]) ON UPDATE CASCADE
GO

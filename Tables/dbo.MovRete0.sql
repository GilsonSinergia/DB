CREATE TABLE [dbo].[MovRete0]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[RetencaoID] [tinyint] NOT NULL,
[Aliquota] [float] NOT NULL,
[Base] [float] NOT NULL,
[Valor] AS (([Aliquota]*[Base])/(100)),
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[MovRete0] ADD CONSTRAINT [PK_MovRete0] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [RetencaoID])
GO
ALTER TABLE [dbo].[MovRete0] WITH NOCHECK ADD CONSTRAINT [FK_MovRete0_CadRete0] FOREIGN KEY ([RetencaoID]) REFERENCES [dbo].[CadRete0] ([RetencaoID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovRete0] ADD CONSTRAINT [FK_MovRete0_Financeiro] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[Financeiro] ([UnidadeID], [TipoID], [Nota]) ON UPDATE CASCADE
GO

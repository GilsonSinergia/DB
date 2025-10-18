CREATE TABLE [dbo].[MovFina1]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Reneg] [tinyint] NOT NULL,
[Parcela] [smallint] NOT NULL,
[OperacaoID] [tinyint] NOT NULL,
[MovimentoID] [int] NOT NULL,
[ValorLiquido] [decimal] (18, 2) NOT NULL,
[ValorMulta] [decimal] (18, 2) NOT NULL,
[ValorJuros] [decimal] (18, 2) NOT NULL,
[ValorDesconto] [decimal] (18, 2) NOT NULL,
[ValorEncargos] AS (isnull([ValorJuros]+[ValorMulta],(0))),
[ValorPago] AS (isnull((([ValorLiquido]+[ValorJuros])+[ValorMulta])-[ValorDesconto],(0))),
[ValorQuitado] AS (isnull([ValorLiquido]+[ValorDesconto],(0))),
[ChaveTitulo] AS (CONVERT([char](18),(((replace(str([UnidadeID],(2)),' ','0')+replace(str([TipoID],(2)),' ','0'))+replace(str([Nota],(10)),' ','0'))+replace(str([Reneg],(1)),' ','0'))+replace(str([Parcela],(3)),' ','0'),(0))) PERSISTED,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[MovFina1] ADD CONSTRAINT [PK_MovFina1] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [Reneg], [Parcela], [MovimentoID], [OperacaoID])
GO
ALTER TABLE [dbo].[MovFina1] ADD CONSTRAINT [FK_MovFina1_MovFina0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota], [Reneg], [Parcela]) REFERENCES [dbo].[MovFina0] ([UnidadeID], [TipoID], [Nota], [Reneg], [Parcela]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovFina1] ADD CONSTRAINT [FK_MovFina1_MovFina2] FOREIGN KEY ([OperacaoID], [MovimentoID]) REFERENCES [dbo].[MovFina2] ([OperacaoID], [MovimentoID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFina1].[Reneg]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFina1].[ValorLiquido]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFina1].[ValorMulta]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFina1].[ValorJuros]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFina1].[ValorDesconto]'
GO

CREATE TABLE [dbo].[MovFina0]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Reneg] [tinyint] NOT NULL,
[Parcela] [smallint] NOT NULL,
[Fatura] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[DocumentoID] [tinyint] NOT NULL,
[PortadorID] [smallint] NOT NULL,
[DtEmissao] [date] NOT NULL,
[DtVencimento] [date] NOT NULL,
[DtLancamento] [datetime] NOT NULL,
[Valor] [decimal] (18, 2) NOT NULL,
[StatusID] [tinyint] NOT NULL,
[Impresso] [bit] NOT NULL,
[ChaveTitulo] AS (CONVERT([char](18),(((replace(str([UnidadeID],(2)),' ','0')+replace(str([TipoID],(2)),' ','0'))+replace(str([Nota],(10)),' ','0'))+replace(str([Reneg],(1)),' ','0'))+replace(str([Parcela],(3)),' ','0'),(0))) PERSISTED,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[MovFina0] ADD CONSTRAINT [PK_MovFina0] PRIMARY KEY NONCLUSTERED ([UnidadeID], [TipoID], [Nota], [Reneg], [Parcela])
GO
CREATE CLUSTERED INDEX [IX_MovFina0_Chave] ON [dbo].[MovFina0] ([Chave])
GO
ALTER TABLE [dbo].[MovFina0] ADD CONSTRAINT [IX_MovFina0_ChaveTitulo] UNIQUE NONCLUSTERED ([ChaveTitulo])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFina0].[Reneg]'
GO
EXEC sp_bindefault N'[dbo].[DF_DtHoje]', N'[dbo].[MovFina0].[DtEmissao]'
GO
EXEC sp_bindefault N'[dbo].[DF_DtHoje]', N'[dbo].[MovFina0].[DtVencimento]'
GO
EXEC sp_bindefault N'[dbo].[DF_DtHoje]', N'[dbo].[MovFina0].[DtLancamento]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFina0].[Valor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFina0].[StatusID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFina0].[Impresso]'
GO

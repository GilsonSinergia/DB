CREATE TABLE [dbo].[Financeiro]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Historico] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Juros] [money] NOT NULL,
[Retencao] [money] NOT NULL,
[Total] [money] NOT NULL,
[Pagamento] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[Financeiro] ADD CONSTRAINT [PK_Financeiro] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota])
GO
ALTER TABLE [dbo].[Financeiro] ADD CONSTRAINT [FK_Financeiro_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[Financeiro].[Juros]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[Financeiro].[Retencao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[Financeiro].[Total]'
GO

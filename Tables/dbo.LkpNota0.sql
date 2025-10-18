CREATE TABLE [dbo].[LkpNota0]
(
[TipoID] [tinyint] NOT NULL,
[Tipo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Sigla] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Estoque] [smallint] NOT NULL,
[Financeiro] [smallint] NOT NULL,
[CTB_OperacaoID] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[LkpNota0] ADD CONSTRAINT [PK_LkpEsto0] PRIMARY KEY CLUSTERED ([TipoID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[LkpNota0].[Estoque]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[LkpNota0].[Financeiro]'
GO

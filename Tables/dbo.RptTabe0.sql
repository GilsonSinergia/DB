CREATE TABLE [dbo].[RptTabe0]
(
[TabelaID] [int] NOT NULL IDENTITY(1, 1),
[Tabela] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Apelido] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Selecionavel] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[RptTabe0] ADD CONSTRAINT [PK_RptTabe0] PRIMARY KEY CLUSTERED ([TabelaID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[RptTabe0].[Selecionavel]'
GO

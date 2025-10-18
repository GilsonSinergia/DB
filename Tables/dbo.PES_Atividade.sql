CREATE TABLE [dbo].[PES_Atividade]
(
[AtividadesID] [tinyint] NOT NULL,
[Atividade] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[PES_Atividade] ADD CONSTRAINT [PK_PES_Atividade] PRIMARY KEY CLUSTERED ([AtividadesID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[PES_Atividade].[AtividadesID]'
GO

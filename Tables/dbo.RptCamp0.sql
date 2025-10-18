CREATE TABLE [dbo].[RptCamp0]
(
[TabelaID] [int] NOT NULL,
[CampoID] [tinyint] NOT NULL,
[Campo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Apelido] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[DataType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Visivel] [bit] NOT NULL,
[Filtro] [bit] NOT NULL,
[AltoFiltro] [bit] NOT NULL,
[Obrigatorio] [bit] NOT NULL,
[Ordenavel] [bit] NOT NULL,
[OBS] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[RptCamp0] ADD CONSTRAINT [PK_RptCamp0] PRIMARY KEY CLUSTERED ([TabelaID], [CampoID])
GO
ALTER TABLE [dbo].[RptCamp0] WITH NOCHECK ADD CONSTRAINT [FK_RptCamp0_RptTabe0] FOREIGN KEY ([TabelaID]) REFERENCES [dbo].[RptTabe0] ([TabelaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[RptCamp0].[Visivel]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[RptCamp0].[Filtro]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[RptCamp0].[AltoFiltro]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[RptCamp0].[Obrigatorio]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[RptCamp0].[Ordenavel]'
GO

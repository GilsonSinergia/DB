CREATE TABLE [dbo].[CadDocu0]
(
[DocumentoID] [tinyint] NOT NULL,
[Documento] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Moeda] [bit] NOT NULL,
[Ativo] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[CadDocu0] ADD CONSTRAINT [PK_Doc] PRIMARY KEY CLUSTERED ([DocumentoID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadDocu0].[Moeda]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadDocu0].[Ativo]'
GO

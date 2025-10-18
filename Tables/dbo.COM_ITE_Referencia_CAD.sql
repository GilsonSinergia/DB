CREATE TABLE [dbo].[COM_ITE_Referencia_CAD]
(
[ReferenciaID] [tinyint] NOT NULL,
[Referencia] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Requerido] [bit] NOT NULL,
[Unico] [bit] NOT NULL,
[Reincidente] [bit] NOT NULL,
[Pesquisa] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[COM_ITE_Referencia_CAD] ADD CONSTRAINT [PK_COM_ITE_Referencia_CAD] PRIMARY KEY CLUSTERED ([ReferenciaID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_Referencia_CAD].[Requerido]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_Referencia_CAD].[Unico]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_Referencia_CAD].[Reincidente]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_Referencia_CAD].[Pesquisa]'
GO

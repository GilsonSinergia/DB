CREATE TABLE [dbo].[COM_ITE_MED]
(
[MedidaID] [tinyint] NOT NULL,
[Medida] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Decimal] [tinyint] NOT NULL,
[UsaBalanca] [bit] NOT NULL,
[UN] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[COM_ITE_MED] ADD CONSTRAINT [PK_Unidades] PRIMARY KEY NONCLUSTERED ([MedidaID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MED].[Decimal]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MED].[UsaBalanca]'
GO

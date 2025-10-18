CREATE TABLE [dbo].[COM_ITE_Referencia]
(
[ItemID] [int] NOT NULL,
[ReferenciaID] [tinyint] NOT NULL,
[Referencia] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Descricao] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[COM_ITE_Referencia] ADD CONSTRAINT [CK_COM_ITE_Referencia] CHECK ((ltrim([Referencia])<>''))
GO
ALTER TABLE [dbo].[COM_ITE_Referencia] ADD CONSTRAINT [PK_COM_ITE_Referencia] PRIMARY KEY CLUSTERED ([ItemID], [ReferenciaID], [Referencia])
GO
ALTER TABLE [dbo].[COM_ITE_Referencia] ADD CONSTRAINT [FK_COM_ITE_Referencia_COM_ITE_CAD] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[COM_ITE_CAD] ([ItemID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COM_ITE_Referencia] ADD CONSTRAINT [FK_COM_ITE_Referencia_COM_ITE_Referencia_CAD] FOREIGN KEY ([ReferenciaID]) REFERENCES [dbo].[COM_ITE_Referencia_CAD] ([ReferenciaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO

CREATE TABLE [dbo].[COM_ITE_Inventario]
(
[Competencia] [int] NOT NULL,
[UnidadeID] [tinyint] NOT NULL,
[ItemID] [int] NOT NULL,
[Quantidade] [float] NULL,
[Custo] [money] NOT NULL
)
GO
ALTER TABLE [dbo].[COM_ITE_Inventario] ADD CONSTRAINT [PK_COM_ITE_Inventario] PRIMARY KEY CLUSTERED ([Competencia], [UnidadeID], [ItemID])
GO
ALTER TABLE [dbo].[COM_ITE_Inventario] ADD CONSTRAINT [FK_COM_ITE_Inventario_COM_ITE_UND] FOREIGN KEY ([UnidadeID], [ItemID]) REFERENCES [dbo].[COM_ITE_UND] ([UnidadeID], [ItemID]) ON DELETE CASCADE ON UPDATE CASCADE
GO

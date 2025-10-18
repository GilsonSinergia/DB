CREATE TABLE [dbo].[FIS_Inventario]
(
[UnidadeID] [tinyint] NOT NULL,
[ItemID] [int] NOT NULL,
[Competencia] [int] NOT NULL,
[VL_Custo] [decimal] (18, 10) NOT NULL
)
GO
ALTER TABLE [dbo].[FIS_Inventario] ADD CONSTRAINT [PK_FIS_Inventario] PRIMARY KEY CLUSTERED ([UnidadeID], [ItemID], [Competencia])
GO
ALTER TABLE [dbo].[FIS_Inventario] ADD CONSTRAINT [FK_FIS_Inventario_COM_ITE_UND] FOREIGN KEY ([UnidadeID], [ItemID]) REFERENCES [dbo].[COM_ITE_UND] ([UnidadeID], [ItemID])
GO

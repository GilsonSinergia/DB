CREATE TABLE [dbo].[COM_ITE_UND]
(
[UnidadeID] [tinyint] NOT NULL,
[ItemID] [int] NOT NULL,
[OrigemID] [tinyint] NOT NULL,
[DestinoID] [tinyint] NOT NULL,
[Ativo] [bit] NOT NULL,
[Lucro] [decimal] (6, 4) NOT NULL,
[MaxDesconto] [decimal] (6, 4) NOT NULL,
[MaxComissao] [decimal] (6, 4) NOT NULL,
[VL_Sugerido] [money] NOT NULL,
[Estoque] [bit] NOT NULL,
[EstMinimo] [decimal] (18, 3) NOT NULL,
[EstMaximo] [decimal] (18, 3) NOT NULL,
[Localizacao] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    TRIGGER [dbo].[GeraPreco] ON [dbo].[COM_ITE_UND]
FOR INSERT
AS
INSERT INTO COM_ITE_prc
(UnidadeID, ItemID, PrecoID)
SELECT
Inserted.UnidadeID, Inserted.ItemID, COM_PRC_CAD.PrecoID
FROM Inserted, COM_PRC_CAD
GO
ALTER TABLE [dbo].[COM_ITE_UND] ADD CONSTRAINT [PK_COM_ITE_UND] PRIMARY KEY CLUSTERED ([UnidadeID], [ItemID])
GO
ALTER TABLE [dbo].[COM_ITE_UND] ADD CONSTRAINT [FK_COM_ITE_UND_CadUnid0] FOREIGN KEY ([UnidadeID]) REFERENCES [dbo].[CadUnid0] ([UnidadeID])
GO
ALTER TABLE [dbo].[COM_ITE_UND] ADD CONSTRAINT [FK_COM_ITE_UND_COM_ITE_CAD] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[COM_ITE_CAD] ([ItemID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COM_ITE_UND] ADD CONSTRAINT [FK_COM_ITE_UND_COM_ITE_Origem] FOREIGN KEY ([DestinoID]) REFERENCES [dbo].[COM_ITE_Destino] ([DestinoID])
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_UND].[UnidadeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_UND].[OrigemID]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_UND].[DestinoID]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_UND].[Ativo]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_UND].[Lucro]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_UND].[MaxDesconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_UND].[MaxComissao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_UND].[VL_Sugerido]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_UND].[Estoque]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_UND].[EstMinimo]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_UND].[EstMaximo]'
GO

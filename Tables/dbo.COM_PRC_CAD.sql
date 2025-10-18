CREATE TABLE [dbo].[COM_PRC_CAD]
(
[PrecoID] [tinyint] NOT NULL,
[Nome] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[AutoReajuste] [bit] NOT NULL,
[Ativo] [bit] NOT NULL,
[SomarMargem] [bit] NOT NULL,
[MaxDesconto] [decimal] (6, 2) NOT NULL,
[MaxComissao] [decimal] (6, 2) NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Parent] [tinyint] NULL,
[Margem] [float] NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE      TRIGGER [dbo].[UpdatePreco] ON [dbo].[COM_PRC_CAD]
FOR INSERT
AS 
INSERT INTO COM_ITE_PRC
  (UnidadeID, ItemID, PrecoID)
SELECT COM_ITE_UND.UnidadeID, COM_ITE_UND.ItemID, COM_PRC_CAD.PrecoID 
FROM  inserted  COM_PRC_CAD
  CROSS JOIN COM_ITE_UND
GO
ALTER TABLE [dbo].[COM_PRC_CAD] ADD CONSTRAINT [PK_SysPrec0] PRIMARY KEY CLUSTERED ([PrecoID])
GO
ALTER TABLE [dbo].[COM_PRC_CAD] ADD CONSTRAINT [FK_COM_PRC_CAD_COM_PRC_CAD] FOREIGN KEY ([Parent]) REFERENCES [dbo].[COM_PRC_CAD] ([PrecoID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_PRC_CAD].[AutoReajuste]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_PRC_CAD].[Ativo]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_PRC_CAD].[SomarMargem]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_PRC_CAD].[MaxDesconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_PRC_CAD].[MaxComissao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_PRC_CAD].[TipoID]'
GO

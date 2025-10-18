CREATE TABLE [dbo].[COM_ITE_PRD]
(
[ItemID] [int] NOT NULL,
[GrupoID] [int] NOT NULL,
[LinhaID] [tinyint] NOT NULL,
[MarcaID] [int] NULL,
[Modelo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[MedidaID] [tinyint] NOT NULL,
[Fracionamento] [decimal] (18, 3) NOT NULL,
[PsLiquido] [decimal] (18, 3) NOT NULL,
[PsBruto] [decimal] (18, 3) NOT NULL,
[Validade] [int] NOT NULL,
[Altura] [decimal] (18, 12) NOT NULL,
[Largura] [decimal] (18, 12) NOT NULL,
[Profundidade] [decimal] (18, 12) NOT NULL,
[FotoID] [int] NULL,
[Descricao] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TRS_COM_ITE_PRD_Apaga_Foto_orfa]
   ON  [dbo].[COM_ITE_PRD]
   for Delete, UPDATE
AS 
BEGIN
	delete from COM_ITE_Foto where FotoID  not in (Select FotoID from COM_ITE_PRD)
END
GO
ALTER TABLE [dbo].[COM_ITE_PRD] ADD CONSTRAINT [PK_PRODUTOS] PRIMARY KEY CLUSTERED ([ItemID])
GO
CREATE NONCLUSTERED INDEX [IX_COM_ITE_PRD] ON [dbo].[COM_ITE_PRD] ([LinhaID], [ItemID], [GrupoID], [MedidaID]) INCLUDE ([Fracionamento], [PsLiquido], [PsBruto])
GO
ALTER TABLE [dbo].[COM_ITE_PRD] ADD CONSTRAINT [FK_CadProd0_CadGrup0] FOREIGN KEY ([GrupoID]) REFERENCES [dbo].[COM_ITE_GRP] ([GrupoID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COM_ITE_PRD] ADD CONSTRAINT [FK_CadProd0_CadLinh0] FOREIGN KEY ([LinhaID]) REFERENCES [dbo].[COM_ITE_LIN] ([LinhaID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COM_ITE_PRD] ADD CONSTRAINT [FK_CadProd0_COM_ITE_Foto] FOREIGN KEY ([FotoID]) REFERENCES [dbo].[COM_ITE_Foto] ([FotoID])
GO
ALTER TABLE [dbo].[COM_ITE_PRD] ADD CONSTRAINT [FK_CadProd0_COM_ITE_Marca] FOREIGN KEY ([MarcaID]) REFERENCES [dbo].[COM_ITE_Marca] ([MarcaID])
GO
ALTER TABLE [dbo].[COM_ITE_PRD] ADD CONSTRAINT [FK_COM_ITE_PRD_COM_ITE_CAD] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[COM_ITE_CAD] ([ItemID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COM_ITE_PRD] ADD CONSTRAINT [FK_COM_ITE_PRD_COM_ITE_MED] FOREIGN KEY ([MedidaID]) REFERENCES [dbo].[COM_ITE_MED] ([MedidaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_PRD].[LinhaID]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_PRD].[MedidaID]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_PRD].[Fracionamento]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_PRD].[PsLiquido]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_PRD].[PsBruto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_PRD].[Validade]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_PRD].[Altura]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_PRD].[Largura]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_PRD].[Profundidade]'
GO

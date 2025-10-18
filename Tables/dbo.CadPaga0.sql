CREATE TABLE [dbo].[CadPaga0]
(
[PagamentoID] [smallint] NOT NULL,
[Nome] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Parcelas] [smallint] NOT NULL,
[Carencia] [tinyint] NOT NULL,
[Intervalo] [tinyint] NOT NULL,
[DocumentoID] [tinyint] NOT NULL,
[Desconto] [decimal] (6, 2) NOT NULL,
[Comissao] [decimal] (6, 2) NOT NULL,
[ValorMinimo] [dbo].[Dinheiro] NOT NULL,
[Personalizavel] [bit] NOT NULL,
[Exportavel] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[CadPaga0] ADD CONSTRAINT [PK_CadPaga0] PRIMARY KEY CLUSTERED ([PagamentoID])
GO
ALTER TABLE [dbo].[CadPaga0] ADD CONSTRAINT [FK_CadPaga0_CadDocu0] FOREIGN KEY ([DocumentoID]) REFERENCES [dbo].[CadDocu0] ([DocumentoID]) ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadPaga0].[Carencia]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadPaga0].[Intervalo]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadPaga0].[DocumentoID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadPaga0].[Desconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadPaga0].[Comissao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadPaga0].[ValorMinimo]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadPaga0].[Personalizavel]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadPaga0].[Exportavel]'
GO

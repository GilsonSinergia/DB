CREATE TABLE [dbo].[CadOrca0]
(
[OrcamentoID] [tinyint] NOT NULL,
[Orcamento] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[TipoID] [tinyint] NOT NULL,
[ParenteOrcamentoID] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[CadOrca0] ADD CONSTRAINT [PK_CadCent0] PRIMARY KEY CLUSTERED ([OrcamentoID])
GO
ALTER TABLE [dbo].[CadOrca0] ADD CONSTRAINT [FK_CadCent0_CadCent01] FOREIGN KEY ([ParenteOrcamentoID]) REFERENCES [dbo].[CadOrca0] ([OrcamentoID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadOrca0].[TipoID]'
GO

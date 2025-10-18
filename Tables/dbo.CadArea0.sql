CREATE TABLE [dbo].[CadArea0]
(
[AreaID] [int] NOT NULL,
[Area] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Comissao] [float] NOT NULL,
[Desconto] [decimal] (6, 2) NOT NULL,
[Meta] [dbo].[Dinheiro] NOT NULL,
[Exportavel] [bit] NOT NULL,
[Ativo] [bit] NOT NULL,
[PessoaID] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[CadArea0] ADD CONSTRAINT [PK_CadArea0] PRIMARY KEY CLUSTERED ([AreaID])
GO
ALTER TABLE [dbo].[CadArea0] ADD CONSTRAINT [FK_CadArea0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadArea0].[Comissao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadArea0].[Desconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadArea0].[Meta]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadArea0].[Exportavel]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadArea0].[Ativo]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadArea0].[PessoaID]'
GO

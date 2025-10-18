CREATE TABLE [dbo].[PesFunc0]
(
[PessoaID] [int] NOT NULL,
[Comissao] [decimal] (6, 2) NOT NULL,
[Salario] [money] NOT NULL
)
GO
ALTER TABLE [dbo].[PesFunc0] ADD CONSTRAINT [PK_PesFunc0] PRIMARY KEY CLUSTERED ([PessoaID])
GO
ALTER TABLE [dbo].[PesFunc0] ADD CONSTRAINT [FK_PesFunc0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[PesFunc0].[Comissao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[PesFunc0].[Salario]'
GO

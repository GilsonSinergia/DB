CREATE TABLE [dbo].[MovCred0]
(
[OperacaoID] [tinyint] NOT NULL,
[MovimentoID] [int] NOT NULL,
[PessoaID] [int] NOT NULL,
[Valor] [dbo].[Dinheiro] NOT NULL
)
GO
ALTER TABLE [dbo].[MovCred0] ADD CONSTRAINT [PK_MovCred0] PRIMARY KEY CLUSTERED ([OperacaoID], [MovimentoID], [PessoaID])
GO
ALTER TABLE [dbo].[MovCred0] ADD CONSTRAINT [FK_MovCred0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID])
GO
ALTER TABLE [dbo].[MovCred0] ADD CONSTRAINT [FK_MovCred0_MovFina2] FOREIGN KEY ([OperacaoID], [MovimentoID]) REFERENCES [dbo].[MovFina2] ([OperacaoID], [MovimentoID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovCred0].[Valor]'
GO

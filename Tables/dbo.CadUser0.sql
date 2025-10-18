CREATE TABLE [dbo].[CadUser0]
(
[UsuarioID] [int] NOT NULL,
[UserNome] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Nivel] [tinyint] NOT NULL,
[Admin] [bit] NOT NULL,
[Senha] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[PessoaID] [int] NOT NULL,
[Email] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[CadUser0] ADD CONSTRAINT [PK_CADUSER0] PRIMARY KEY CLUSTERED ([UsuarioID])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CadUser0_Email] ON [dbo].[CadUser0] ([Email]) WHERE ([Email] IS NOT NULL)
GO
ALTER TABLE [dbo].[CadUser0] ADD CONSTRAINT [IX_CadUser0] UNIQUE NONCLUSTERED ([UserNome])
GO
ALTER TABLE [dbo].[CadUser0] ADD CONSTRAINT [FK_CadUser0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadUser0].[Nivel]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadUser0].[Admin]'
GO

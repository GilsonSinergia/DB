CREATE TABLE [dbo].[UsrUnid0]
(
[UnidadeID] [tinyint] NOT NULL,
[UsuarioID] [int] NOT NULL,
[Nivel] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[UsrUnid0] ADD CONSTRAINT [PK_UsrUnid0] PRIMARY KEY CLUSTERED ([UsuarioID], [UnidadeID])
GO
ALTER TABLE [dbo].[UsrUnid0] ADD CONSTRAINT [FK_UsrUnid0_CadUnid0] FOREIGN KEY ([UnidadeID]) REFERENCES [dbo].[CadUnid0] ([UnidadeID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UsrUnid0] WITH NOCHECK ADD CONSTRAINT [FK_UsrUnid0_CadUser0] FOREIGN KEY ([UsuarioID]) REFERENCES [dbo].[CadUser0] ([UsuarioID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[UsrUnid0].[Nivel]'
GO

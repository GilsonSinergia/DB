CREATE TABLE [dbo].[CadCont0]
(
[ContaID] [int] NOT NULL,
[Conta] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Agencia] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[TipoID] [tinyint] NOT NULL,
[PortadorID] [smallint] NOT NULL,
[OperacaoID] [tinyint] NOT NULL,
[PessoaID] [int] NOT NULL,
[UnidadeID] [tinyint] NOT NULL,
[Limite] [money] NOT NULL
)
GO
ALTER TABLE [dbo].[CadCont0] ADD CONSTRAINT [PK_CadCont0] PRIMARY KEY CLUSTERED ([ContaID])
GO
ALTER TABLE [dbo].[CadCont0] ADD CONSTRAINT [FK_CadCont0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID])
GO
ALTER TABLE [dbo].[CadCont0] WITH NOCHECK ADD CONSTRAINT [FK_CadCont0_CadPort0] FOREIGN KEY ([PortadorID]) REFERENCES [dbo].[CadPort0] ([PortadorID])
GO
ALTER TABLE [dbo].[CadCont0] ADD CONSTRAINT [FK_CadCont0_CadUnid0] FOREIGN KEY ([UnidadeID]) REFERENCES [dbo].[CadUnid0] ([UnidadeID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CadCont0] WITH NOCHECK ADD CONSTRAINT [FK_CadCont0_LkpCont0] FOREIGN KEY ([TipoID]) REFERENCES [dbo].[LkpCont0] ([TipoID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CadCont0] WITH NOCHECK ADD CONSTRAINT [FK_CadCont0_LkpCont1] FOREIGN KEY ([OperacaoID]) REFERENCES [dbo].[LkpCont1] ([OperacaoID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadCont0].[PessoaID]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadCont0].[UnidadeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadCont0].[Limite]'
GO

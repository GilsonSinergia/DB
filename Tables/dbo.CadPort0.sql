CREATE TABLE [dbo].[CadPort0]
(
[PortadorID] [smallint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Portador] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[PessoaID] [int] NULL
)
GO
ALTER TABLE [dbo].[CadPort0] ADD CONSTRAINT [PK_CadBanc0] PRIMARY KEY NONCLUSTERED ([PortadorID])
GO
ALTER TABLE [dbo].[CadPort0] WITH NOCHECK ADD CONSTRAINT [FK_CadPort0_LkpBanc0] FOREIGN KEY ([TipoID]) REFERENCES [dbo].[LkpPort0] ([TipoID])
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadPort0].[TipoID]'
GO

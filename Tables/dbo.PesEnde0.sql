CREATE TABLE [dbo].[PesEnde0]
(
[PessoaID] [int] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Endereco] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Numero] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Bairro] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[CidadeID] [int] NOT NULL,
[Lat] [float] NOT NULL,
[Lng] [float] NOT NULL,
[CEP] [int] NULL,
[Contato] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Tel] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Ramal] [int] NULL,
[Fax] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Celular] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Proximidade] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Postal] [bit] NULL
)
GO
ALTER TABLE [dbo].[PesEnde0] ADD CONSTRAINT [PK_CliEnde0] PRIMARY KEY CLUSTERED ([PessoaID], [TipoID])
GO
CREATE NONCLUSTERED INDEX [IX_PesEnde0] ON [dbo].[PesEnde0] ([TipoID], [CidadeID], [PessoaID])
GO
ALTER TABLE [dbo].[PesEnde0] ADD CONSTRAINT [FK_CliEnde0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PesEnde0] WITH NOCHECK ADD CONSTRAINT [FK_CliEnde0_LkpEnde01] FOREIGN KEY ([TipoID]) REFERENCES [dbo].[LkpEnde0] ([TipoID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PesEnde0] ADD CONSTRAINT [FK_PesEnde0_CadCida0] FOREIGN KEY ([CidadeID]) REFERENCES [dbo].[CadCida0] ([CidadeID]) ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[PesEnde0].[TipoID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[PesEnde0].[Lat]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[PesEnde0].[Lng]'
GO

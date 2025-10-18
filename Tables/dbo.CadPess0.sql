CREATE TABLE [dbo].[CadPess0]
(
[PessoaID] [int] NOT NULL,
[Nome] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Reduzido] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[TipoID] [tinyint] NOT NULL,
[StatusID] [tinyint] NOT NULL,
[DtCadastro] [datetime] NOT NULL,
[Documento] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[AtividadesID] [tinyint] NOT NULL,
[PaisID] [int] NOT NULL,
[EMail] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Web] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[OBS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Naturezas] [int] NULL,
[Parent] [int] NULL
)
GO
ALTER TABLE [dbo].[CadPess0] ADD CONSTRAINT [PK_CadPess0] PRIMARY KEY CLUSTERED ([PessoaID])
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_CadPess_Nome] ON [dbo].[CadPess0] ([Documento]) INCLUDE ([Nome], [Reduzido])
GO
ALTER TABLE [dbo].[CadPess0] ADD CONSTRAINT [FK_CadPess0_CadPess0] FOREIGN KEY ([Parent]) REFERENCES [dbo].[CadPess0] ([PessoaID])
GO
ALTER TABLE [dbo].[CadPess0] ADD CONSTRAINT [FK_CadPess0_LkpPess0] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[LkpPess0] ([StatusID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CadPess0] ADD CONSTRAINT [FK_CadPess0_lkpPess1] FOREIGN KEY ([TipoID]) REFERENCES [dbo].[lkpPess1] ([TipoID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CadPess0] ADD CONSTRAINT [FK_CadPess0_Paises] FOREIGN KEY ([PaisID]) REFERENCES [dbo].[Paises] ([PaisID]) ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadPess0].[StatusID]'
GO
EXEC sp_bindefault N'[dbo].[DF_DtHoje]', N'[dbo].[CadPess0].[DtCadastro]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadPess0].[AtividadesID]'
GO

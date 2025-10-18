CREATE TABLE [dbo].[PesRefe0]
(
[PessoaID] [int] NOT NULL,
[Nome] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Endereco] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Bairro] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[CidadeID] [int] NULL,
[Tel] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[PesRefe0] ADD CONSTRAINT [PK_CliRefe0] PRIMARY KEY CLUSTERED ([PessoaID], [Nome])
GO
ALTER TABLE [dbo].[PesRefe0] ADD CONSTRAINT [FK_CliRefe0_CadClie0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PesRefe0] ADD CONSTRAINT [FK_PesRefe0_CadCida0] FOREIGN KEY ([CidadeID]) REFERENCES [dbo].[CadCida0] ([CidadeID]) ON UPDATE CASCADE
GO

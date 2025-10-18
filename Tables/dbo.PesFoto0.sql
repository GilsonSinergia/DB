CREATE TABLE [dbo].[PesFoto0]
(
[PessoaID] [int] NOT NULL,
[Nome] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Foto] [image] NOT NULL
)
GO
ALTER TABLE [dbo].[PesFoto0] ADD CONSTRAINT [PK_PesFoto0] PRIMARY KEY CLUSTERED ([PessoaID], [Nome])
GO
ALTER TABLE [dbo].[PesFoto0] ADD CONSTRAINT [FK_PesFoto0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO

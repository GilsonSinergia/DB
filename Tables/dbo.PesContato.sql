CREATE TABLE [dbo].[PesContato]
(
[PessoaID] [int] NOT NULL,
[Contato] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Setor] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Tel] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Celular] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[EMail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[DtNascimento] [datetime] NULL
)
GO
ALTER TABLE [dbo].[PesContato] ADD CONSTRAINT [PK_PesContato] PRIMARY KEY CLUSTERED ([PessoaID], [Contato])
GO
ALTER TABLE [dbo].[PesContato] ADD CONSTRAINT [FK_PesContato_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO

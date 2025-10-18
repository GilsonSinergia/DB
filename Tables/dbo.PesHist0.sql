CREATE TABLE [dbo].[PesHist0]
(
[PessoaID] [int] NOT NULL,
[Data] [datetime] NOT NULL,
[Historico] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_PesHist0_Historico] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[PesHist0] ADD CONSTRAINT [PK_PesHist0] PRIMARY KEY CLUSTERED ([PessoaID], [Data])
GO
ALTER TABLE [dbo].[PesHist0] ADD CONSTRAINT [FK_PesHist0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO

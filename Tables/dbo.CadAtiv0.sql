CREATE TABLE [dbo].[CadAtiv0]
(
[AtividadeID] [int] NOT NULL,
[Atividade] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[CadAtiv0] ADD CONSTRAINT [PK_CadAtiv0] PRIMARY KEY CLUSTERED ([AtividadeID])
GO

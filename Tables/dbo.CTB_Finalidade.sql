CREATE TABLE [dbo].[CTB_Finalidade]
(
[FinalidadeID] [tinyint] NOT NULL,
[Finalidade] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Parent] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[CTB_Finalidade] ADD CONSTRAINT [PK_CTB_Finalidade] PRIMARY KEY CLUSTERED ([FinalidadeID])
GO
ALTER TABLE [dbo].[CTB_Finalidade] ADD CONSTRAINT [FK_CTB_Finalidade_CTB_Finalidade] FOREIGN KEY ([Parent]) REFERENCES [dbo].[CTB_Finalidade] ([FinalidadeID])
GO

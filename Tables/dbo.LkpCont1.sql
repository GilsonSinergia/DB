CREATE TABLE [dbo].[LkpCont1]
(
[OperacaoID] [tinyint] NOT NULL,
[Operacao] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[LkpCont1] ADD CONSTRAINT [PK_LkpCont1] PRIMARY KEY CLUSTERED ([OperacaoID])
GO

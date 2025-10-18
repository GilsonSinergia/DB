CREATE TABLE [dbo].[FIS_Operacao_CAD]
(
[OperacaoID] [tinyint] NOT NULL,
[Operacao] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[FIS_Operacao_CAD] ADD CONSTRAINT [PK_FIS_Operacao_CAD] PRIMARY KEY CLUSTERED ([OperacaoID])
GO

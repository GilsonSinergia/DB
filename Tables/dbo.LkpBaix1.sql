CREATE TABLE [dbo].[LkpBaix1]
(
[OperacaoID] [tinyint] NOT NULL,
[Operacao] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Multiplicador] [smallint] NOT NULL
)
GO
ALTER TABLE [dbo].[LkpBaix1] ADD CONSTRAINT [PK_LkpFina1] PRIMARY KEY CLUSTERED ([OperacaoID])
GO

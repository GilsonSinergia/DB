CREATE TABLE [dbo].[FinDeve0]
(
[OperacaoID] [tinyint] NOT NULL,
[MovimentoID] [int] NOT NULL,
[Incidencia] [tinyint] NOT NULL,
[DtDevolucao] [datetime] NOT NULL,
[DtReapresentacao] [datetime] NULL,
[Motivo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Alinea] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[FinDeve0] ADD CONSTRAINT [PK_FinDeve0] PRIMARY KEY CLUSTERED ([OperacaoID], [MovimentoID], [Incidencia])
GO
ALTER TABLE [dbo].[FinDeve0] ADD CONSTRAINT [FK_FinDeve0_MovFina2] FOREIGN KEY ([OperacaoID], [MovimentoID]) REFERENCES [dbo].[MovFina2] ([OperacaoID], [MovimentoID]) ON DELETE CASCADE ON UPDATE CASCADE
GO

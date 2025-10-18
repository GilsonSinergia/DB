CREATE TABLE [dbo].[FIS_CFO_CTB_Conta]
(
[CFOP] [smallint] NOT NULL,
[Data] [datetime] NOT NULL,
[NaturezaID] [tinyint] NOT NULL,
[TipoID] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Nivel] [tinyint] NOT NULL,
[Codigo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Conta] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[FIS_CFO_CTB_Conta] ADD CONSTRAINT [PK_FIS_CFO_CTB_Conta] PRIMARY KEY CLUSTERED ([CFOP])
GO

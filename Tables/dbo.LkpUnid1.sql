CREATE TABLE [dbo].[LkpUnid1]
(
[TipoID] [tinyint] NOT NULL,
[Tipo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[LkpUnid1] ADD CONSTRAINT [PK_LkpUnid1] PRIMARY KEY CLUSTERED ([TipoID])
GO

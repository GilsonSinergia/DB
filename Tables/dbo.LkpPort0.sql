CREATE TABLE [dbo].[LkpPort0]
(
[TipoID] [tinyint] NOT NULL,
[Tipo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[LkpPort0] ADD CONSTRAINT [PK_LkpBanc0_1] PRIMARY KEY NONCLUSTERED ([TipoID])
GO

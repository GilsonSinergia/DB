CREATE TABLE [dbo].[LkpEnde0]
(
[TipoID] [tinyint] NOT NULL,
[Tipo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[LkpEnde0] ADD CONSTRAINT [PK_LkpEnde0] PRIMARY KEY CLUSTERED ([TipoID])
GO

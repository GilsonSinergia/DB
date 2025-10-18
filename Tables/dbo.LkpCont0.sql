CREATE TABLE [dbo].[LkpCont0]
(
[TipoID] [tinyint] NOT NULL,
[Tipo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[LkpCont0] ADD CONSTRAINT [PK_LkpCont0] PRIMARY KEY CLUSTERED ([TipoID])
GO

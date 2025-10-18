CREATE TABLE [dbo].[lkpMoed0]
(
[TipoID] [tinyint] NOT NULL,
[Tipo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[lkpMoed0] ADD CONSTRAINT [PK_lkpMoed0] PRIMARY KEY CLUSTERED ([TipoID])
GO

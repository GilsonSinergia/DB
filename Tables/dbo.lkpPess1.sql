CREATE TABLE [dbo].[lkpPess1]
(
[TipoID] [tinyint] NOT NULL,
[Tipo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[lkpPess1] ADD CONSTRAINT [PK_lkpClie1] PRIMARY KEY NONCLUSTERED ([TipoID])
GO

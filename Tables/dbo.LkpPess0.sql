CREATE TABLE [dbo].[LkpPess0]
(
[StatusID] [tinyint] NOT NULL,
[Status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[LkpPess0] ADD CONSTRAINT [PK_Lkpclie0] PRIMARY KEY NONCLUSTERED ([StatusID])
GO

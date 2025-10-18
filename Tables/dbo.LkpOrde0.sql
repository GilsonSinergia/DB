CREATE TABLE [dbo].[LkpOrde0]
(
[OrigemID] [tinyint] NOT NULL,
[Origem] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[LkpOrde0] ADD CONSTRAINT [PK_LkpOrde0] PRIMARY KEY CLUSTERED ([OrigemID])
GO

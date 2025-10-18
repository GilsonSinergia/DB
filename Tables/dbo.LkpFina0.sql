CREATE TABLE [dbo].[LkpFina0]
(
[StatusID] [tinyint] NOT NULL,
[Status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Ativo] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[LkpFina0] ADD CONSTRAINT [PK_LkpTic0] PRIMARY KEY CLUSTERED ([StatusID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[LkpFina0].[Ativo]'
GO

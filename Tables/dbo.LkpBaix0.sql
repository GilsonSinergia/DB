CREATE TABLE [dbo].[LkpBaix0]
(
[StatusID] [tinyint] NOT NULL,
[Status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Ativo] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[LkpBaix0] ADD CONSTRAINT [PK_LkpBaix0] PRIMARY KEY CLUSTERED ([StatusID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[LkpBaix0].[Ativo]'
GO

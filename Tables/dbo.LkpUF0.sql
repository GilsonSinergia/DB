CREATE TABLE [dbo].[LkpUF0]
(
[UFID] [tinyint] NOT NULL,
[Nome] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[UF] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[ICMSInt] [decimal] (8, 4) NOT NULL,
[MVA] [decimal] (6, 2) NOT NULL,
[FCP] [decimal] (6, 2) NOT NULL,
[ICMSExt] [decimal] (8, 4) NOT NULL,
[Parente] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[LkpUF0] ADD CONSTRAINT [PK__LkpUF0__2E3E39D8] PRIMARY KEY CLUSTERED ([UFID])
GO
ALTER TABLE [dbo].[LkpUF0] ADD CONSTRAINT [FK_LkpUF0_LkpUF0] FOREIGN KEY ([Parente]) REFERENCES [dbo].[LkpUF0] ([UFID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[LkpUF0].[ICMSInt]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[LkpUF0].[MVA]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[LkpUF0].[FCP]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[LkpUF0].[ICMSExt]'
GO

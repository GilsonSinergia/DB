CREATE TABLE [dbo].[CadCent0]
(
[CentroID] [int] NOT NULL,
[Centro] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[CadCent0] ADD CONSTRAINT [PK_CadRate0] PRIMARY KEY CLUSTERED ([CentroID])
GO

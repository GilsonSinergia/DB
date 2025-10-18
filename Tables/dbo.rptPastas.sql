CREATE TABLE [dbo].[rptPastas]
(
[PastaID] [int] NOT NULL IDENTITY(1, 1),
[Pasta] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[ParentID] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[rptPastas] ADD CONSTRAINT [PK_rptPastas] PRIMARY KEY CLUSTERED ([PastaID])
GO

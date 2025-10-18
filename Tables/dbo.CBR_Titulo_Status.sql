CREATE TABLE [dbo].[CBR_Titulo_Status]
(
[StatusID] [tinyint] NOT NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[CBR_Titulo_Status] ADD CONSTRAINT [PK_CBR_Titulo_Status] PRIMARY KEY CLUSTERED ([StatusID])
GO

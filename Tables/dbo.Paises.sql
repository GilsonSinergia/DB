CREATE TABLE [dbo].[Paises]
(
[PaisID] [int] NOT NULL,
[pais] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[Paises] ADD CONSTRAINT [PK_Paises] PRIMARY KEY CLUSTERED ([PaisID])
GO

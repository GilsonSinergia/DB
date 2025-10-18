CREATE TABLE [dbo].[LkpFisc0]
(
[ModeloID] [tinyint] NOT NULL,
[Modelo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Sigla] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[ModeloDesc] AS ([Sigla])
)
GO
ALTER TABLE [dbo].[LkpFisc0] ADD CONSTRAINT [PK_LkpSaid0] PRIMARY KEY CLUSTERED ([ModeloID])
GO

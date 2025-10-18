CREATE TABLE [dbo].[BaixaClace]
(
[ClasseID] [tinyint] NOT NULL,
[Classe] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[BaixaClace] ADD CONSTRAINT [PK_BaixaClace] PRIMARY KEY CLUSTERED ([ClasseID])
GO

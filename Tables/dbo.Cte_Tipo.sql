CREATE TABLE [dbo].[Cte_Tipo]
(
[TipoCteID] [tinyint] NOT NULL,
[TipoCte] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[Cte_Tipo] ADD CONSTRAINT [PK_Cte_Tipo] PRIMARY KEY CLUSTERED ([TipoCteID])
GO
